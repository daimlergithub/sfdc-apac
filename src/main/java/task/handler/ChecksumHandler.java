/*
 * Daimler CRM - Extension Platform
 */
package task.handler;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildException;

import task.handler.configuration.DeploymentUnit;

/**
 * ChecksumHandler
 *
 * @author  XLEHMF
 */
public class ChecksumHandler
{

  private static final String KEY_UPDATESTAMP_DESTRUCTIVE_CHANGES = "DestructiveChanges.xml";

  private Map<String, String> updateStamps;
  private LogWrapper logWrapper;
  private String fileName;
  private boolean loadFile;
  private boolean dryRun;

  private byte[] checkChecksum(File file)
  {
    try (InputStream fis = new FileInputStream(file)) {

      MessageDigest digest = MessageDigest.getInstance("MD5");
      byte[] buffer = new byte[1024];
      int numRead;
      do {
        numRead = fis.read(buffer);
        if (numRead > 0) {
          digest.update(buffer, 0, numRead);
        }
      }
      while (numRead != -1);

      return digest.digest();
    }
    catch (IOException | NoSuchAlgorithmException e) {
      throw new BuildException(String.format("Error creating checksum for binary file %s: %s.",
                                             file.getName(),
                                             e.getMessage()), e);
    }
  }

  protected String getValueFromFile(File file)
  {
    byte[] checksum = checkChecksum(file);

    return Base64.encodeBase64String(checksum);
  }

  public boolean isUpdateRequired(DeploymentUnit du, File file)
  {
    String newChecksum = getValueFromFile(file);

    String key = getKey(du, file);

    String oldChecksum = updateStamps.get(key);

    return !StringUtils.equals(newChecksum, oldChecksum);
  }

  public Map<String, String> getChecksums()
  {
    return updateStamps;
  }

  /**
   * This method replaces the checksums in the internal cache and saves them in the given file.
   *   
   * @param checksums The checksums to use for replacement.
   */
  public void replaceChecksums(Map<String, String> checksums)
  {
    updateStamps.clear();
    updateStamps.putAll(checksums);

    writeUpdateStampes();
  }

  @SuppressWarnings("hiding")
  public void initialize(LogWrapper logWrapper, String fileName, boolean loadFile, boolean dryRun)
  {
    this.logWrapper = logWrapper;
    this.fileName = fileName;
    this.loadFile = loadFile;
    this.dryRun = dryRun;

    validate();
    initialize();
  }

  private void validate()
  {
    if (null == logWrapper) {
      throw new BuildException("ChecksumHandler (logWrapper) not properly initialized.");
    }
    if (null == fileName) {
      throw new BuildException("ChecksumHandler (fileName) not properly initialized.");
    }
  }

  private void initialize()
  {
    updateStamps = new HashMap<>();

    if (loadFile) {
      File file = new File(fileName);
      if (file.exists()) {
        try (FileReader fr = new FileReader(file); BufferedReader br = new BufferedReader(fr)) {
          String line = null;
          do {
            line = br.readLine();
            if (null != line) {
              int version = determineVersion(line);
              switch (version) {
                case 1 :
                  decodeVersion1(line);
                  break;
                default :
                  decodeVersion0(line);
                  break;
              }
            }
          }
          while (null != line);

          br.close();
        }
        catch (IOException e) {
          updateStamps.clear();

          logWrapper.log(String.format("Error reading update stamps: %s. Continue without update timestamps.",
                                       e.getMessage()));
        }
      }
      else {
        logWrapper.log("Did not find update timestamps. Continue without update timestamps.");
      }
    }
  }

  private String encodeVersion1(Map.Entry<String, String> entry)
    throws UnsupportedEncodingException
  {
    return String.format("1:%s:%s", URLEncoder.encode(entry.getKey(), "UTF-8"), entry.getValue());
  }

  private void decodeVersion1(String line)
    throws UnsupportedEncodingException
  {
    String[] tokens1 = line.split(":");
    if (3 == tokens1.length) {
      String type = URLDecoder.decode(tokens1[1], "UTF-8");
      String value = tokens1[2];

      updateStamps.put(type, value);
    }
  }

  private void decodeVersion0(String line)
    throws UnsupportedEncodingException
  {
    String[] tokens1 = line.split(":");
    if (3 == tokens1.length) {
      String type = URLDecoder.decode(tokens1[1], "UTF-8");
      String value = tokens1[2];

      updateStamps.put(type, value);
    }
  }

  private int determineVersion(String line)
  {
    if (line.startsWith("1:")) {
      return 1;
    }
    return 0;
  }

  private void writeUpdateStampes()
  {
    if (dryRun) {
      return;
    }

    try (FileWriter fw = new FileWriter(fileName); BufferedWriter bw = new BufferedWriter(fw)) {

      for (Map.Entry<String, String> entry : updateStamps.entrySet()) {
        String line = encodeVersion1(entry);

        bw.write(line);
        bw.newLine();
      }

      bw.close();
    }
    catch (IOException e) {
      throw new BuildException(String.format("Error saving update stamps: %s.", e.getMessage()), e);
    }
  }

  private String getKey(DeploymentUnit du, File file)
  {
    return getKey(du.getTypeName(), file.getName());
  }

  private String getKey(String category, String entityName)
  {
    return category + "/" + entityName;
  }

  public void updateTimestamp(List<DeploymentInfo> deploymentInfos)
  {
    for (DeploymentInfo info : deploymentInfos) {
      for (File file : info.getFileList()) {
        updateTimestamp(info.getDeploymentUnit(), file);
      }
    }
    writeUpdateStampes();
  }

  private void updateTimestamp(DeploymentUnit du, File file)
  {
    String value = getValueFromFile(file);

    String key = getKey(du, file);

    updateStamps.put(key, value);
  }

  public Map<String, File> filterDestructiveFiles(Map<String, File> destructiveFiles)
  {
    Map<String, File> filteredFiles = new HashMap<>();

    Set<String> deployedIds = getDestructiveIDs();

    for (Map.Entry<String, File> destructiveEntry : destructiveFiles.entrySet()) {
      if (!deployedIds.contains(destructiveEntry.getKey())) {
        filteredFiles.put(destructiveEntry.getKey(), destructiveEntry.getValue());
      }
    }

    return filteredFiles;
  }

  private Set<String> getDestructiveIDs()
  {
    Set<String> deployedIds = new HashSet<>();

    String idString = updateStamps.get(KEY_UPDATESTAMP_DESTRUCTIVE_CHANGES);
    if (null != idString) {
      deployedIds.addAll(Arrays.asList(StringUtils.split(",")));
    }
    return deployedIds;
  }

  public void updateDestructiveTimestamp(String key)
  {
    Set<String> deployedIds = getDestructiveIDs();

    deployedIds.add(key);

    updateStamps.put(KEY_UPDATESTAMP_DESTRUCTIVE_CHANGES, StringUtils.join(deployedIds, ","));

    writeUpdateStampes();
  }
}
