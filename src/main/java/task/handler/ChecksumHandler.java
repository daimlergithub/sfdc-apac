/*
 * Daimler CRM - Extension Platform
 */
package task.handler;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.HashSet;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildException;

import deployer.DeploymentConfiguration;
import deployer.DeploymentUnit;

/**
 * ChecksumHandler
 *
 * @author  XLEHMF
 */
public class ChecksumHandler
  extends BaseUpdateHandler<String>
{

  private Set<String> textExtensions;

  public ChecksumHandler()
  {
    textExtensions = new HashSet<String>();
    textExtensions.add("xml");

    for (DeploymentUnit unit : new DeploymentConfiguration().getConfigurations()) {
      String extension = unit.getExtension();
      if (StringUtils.isNotEmpty(extension)) {
        textExtensions.add(extension);
      }
    }
  }

  @Override
  protected String decodeValueToken(String token)
  {
    return token;
  }

  @Override
  protected String encodeValueToken(String value)
  {
    return value;
  }

  private boolean isTextFile(File file)
  {
    String extension = StringUtils.substringAfterLast(file.getName(), ".");
    return StringUtils.isNotEmpty(extension) && textExtensions.contains(extension);
  }

  private byte[] checkChecksum4Binary(File file)
  {
    try (InputStream fis = new FileInputStream(file)) {

      MessageDigest complete = MessageDigest.getInstance("MD5");
      byte[] buffer = new byte[1024];
      int numRead;
      do {
        numRead = fis.read(buffer);
        if (numRead > 0) {
          complete.update(buffer, 0, numRead);
        }
      }
      while (numRead != -1);
      
      return complete.digest();
    }
    catch (IOException | NoSuchAlgorithmException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
      
      throw new BuildException(String.format("Error creating checksum for binary file %s: %s.", file.getName(), e.getMessage()), e);
    }
  }

  private byte[] createChecksum4Text(File file)
  {
    try (FileReader fr = new FileReader(file);
        BufferedReader br = new BufferedReader(fr)) {

      MessageDigest digest = MessageDigest.getInstance("MD5");
      
      String line = null;
      do {
        line = br.readLine();
        if (null != line) {
          digest.update(line.getBytes("UTF-8"));
        }
      }
      while (null != line);
      
      return digest.digest();
    }
    catch (IOException | NoSuchAlgorithmException e) {
      // TODO Auto-generated catch block
      e.printStackTrace();
      
      throw new BuildException(String.format("Error creating checksum for text file %s: %s.", file.getName(), e.getMessage()), e);
    }
  }

  @Override
  protected String getValueFromFile(File file)
  {
    byte[] checksum = isTextFile(file) ? createChecksum4Text(file) : checkChecksum4Binary(file);

    String result = "";
    for (int i = 0; i < checksum.length; i++) {
      result += Integer.toString((checksum[i] & 0xff) + 0x100, 16).substring(1);
    }
    return result;
  }

  @Override
  public boolean isUpdateRequired(DeploymentUnit du, File file)
  {
    String newChecksum = getValueFromFile(file);

    String key = getKey(du, file);

    String oldChecksum = getUpdateStamps().get(key);

    return !StringUtils.equals(newChecksum, oldChecksum);
  }
}
