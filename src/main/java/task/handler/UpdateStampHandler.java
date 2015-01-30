/*
 *  Daimler CRM - Extension Platform
 */
package task.handler;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildException;

import deployer.DeploymentUnit;

/**
 * UpdateStampHandler
 *
 * @author  XLEHMF
 */
public class UpdateStampHandler
{

  public enum Action {
    ADD, CHANGE, SAME, DELETE;
  }
  
  public static final String DEFAULT_FILENAME = "timestamps.log";
  
  private Map<String, Long> updateStamps;
  private String userName;
  private LogWrapper logWrapper;
  private String fileName;

  public void initialize(LogWrapper logWrapper, String userName, String fileName)
  {
    this.userName = userName;
    this.logWrapper = logWrapper;
    this.fileName = fileName;
    
    validate();
    initialize();
  }

  private void validate()
  {
    if (null == userName) {
      throw new BuildException("UpdateStampHandler (userName) not properly initialized.");
    }
    if (null == logWrapper) {
      throw new BuildException("UpdateStampHandler (logWrapper) not properly initialized.");
    }
    if (null == fileName) {
      throw new BuildException("UpdateStampHandler (fileName) not properly initialized.");
    }
  }
  
  private void initialize()
  {
    updateStamps = new HashMap<>();

    try {
      FileReader fr = new FileReader(fileName);
      BufferedReader br = new BufferedReader(fr);

      String line = null;
      do {
        line = br.readLine();
        if (null != line) {
          String[] tokens = line.split(":");
          if (3 == tokens.length) {
            String un = tokens[0];
            if (StringUtils.equals(userName, un)) {
              String type = URLDecoder.decode(tokens[1], "UTF-8");
              Long timestamp = Long.valueOf(tokens[2]);
              
              updateStamps.put(type, timestamp);
            }
          }
        }

      }
      while (null != line);

      br.close();
    }
    catch (IOException e) {
      updateStamps.clear();
      
      logWrapper.log(String.format("Error reading update stamps: %s. Continue without update timestamps.", e.getMessage()));
    }
  }

  public boolean isUpdateRequired(DeploymentUnit du, File file)
  {
    long timestamp = file.lastModified();
    
    String key = getKey(du, file);
    
    Long updateStamp = updateStamps.get(key);
    
    return (null == updateStamp) || (timestamp > updateStamp.longValue());
  }
  
  public void updateTimestamp(List<DeploymentInfo> deploymentInfos)
  {
    for (DeploymentInfo info : deploymentInfos) {
      for (File file: info.getFileList()) {
        updateTimestamp(info.getDeploymentUnit(), file);
      }
    }
    writeUpdateStampes(updateStamps);
  }
  
  public void writeUpdateStampes(Map<String, Long> updateStampsToSave)
  {
    try {
      FileWriter fw = new FileWriter(fileName);
      BufferedWriter bw = new BufferedWriter(fw);

      for (Map.Entry<String, Long> entry : updateStampsToSave.entrySet()) {
        String line = String.format("%s:%s:%d", userName, URLEncoder.encode(entry.getKey(), "UTF-8"), entry.getValue());
        
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
    return du.getType().getSimpleName() + "/" + file.getName();
  }

  private void updateTimestamp(DeploymentUnit du, File file)
  {
    long lastModified = file.lastModified();
    
    String key = getKey(du, file);

    updateStamps.put(key, lastModified);
  }

  public Map<String, Action> calculateDifferences(Map<String, Long> metadataUpdatestamps)
  {
    Map<String, Action> result = new HashMap<>();
    
    // work on copies
    Set<String> lastKeys = new HashSet<>(updateStamps.keySet());
    Set<String> currentKeys = new HashSet<>(metadataUpdatestamps.keySet());
    
    for (String currentKey : currentKeys) {
      if (lastKeys.remove(currentKey)) {
        // check for update
        if (0 == Long.compare(metadataUpdatestamps.get(currentKey), updateStamps.get(currentKey))) {
          result.put(currentKey, Action.SAME);
        } else {
          result.put(currentKey, Action.CHANGE);
        }
      } else {
        // new
        result.put(currentKey, Action.ADD);
      }
    }
    for (String lastKey : lastKeys) {
      result.put(lastKey, Action.DELETE);
    }
    
    return result;
  }
}

