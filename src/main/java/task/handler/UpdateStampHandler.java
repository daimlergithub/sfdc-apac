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
import java.util.List;
import java.util.Map;

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

  private static final String FILENAME_TIMESTAMPS = "timestamps.log";
  
  private Map<String, Long> updateStamps;
  private String username;
  private LogWrapper logWrapper;

  public void validate()
  {
    if (null == updateStamps || null == username || null == logWrapper) {
      throw new BuildException("UpdateStampHandler not properly initialized.");
    }
  }
  
  public void initializeUpdateStamps(LogWrapper logWrapper, String username)
  {
    this.username = username;
    this.logWrapper = logWrapper;
    
    updateStamps = new HashMap<>();

    try {
      FileReader fr = new FileReader(FILENAME_TIMESTAMPS);
      BufferedReader br = new BufferedReader(fr);

      String line = null;
      do {
        line = br.readLine();
        if (null != line) {
          String[] tokens = line.split(":");
          if (3 == tokens.length) {
            String un = tokens[0];
            if (StringUtils.equals(username, un)) {
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
    
    boolean result = (null == updateStamp) || timestamp > updateStamp.longValue();
    if (result) {
      logWrapper.log(String.format("Resource %s modified - last modified: %d updatestamp: %d.", file.getName(), timestamp, updateStamp));
    }
    
    return result;
  }
  
  public void updateTimestamp(List<DeploymentInfo> deploymentInfos)
  {
    for (DeploymentInfo info : deploymentInfos) {
      for (File file: info.getFileList()) {
        updateTimestamp(info.getDeploymentUnit(), file);
      }
    }
    writeUpdateStampes();
  }
  
  private void writeUpdateStampes()
  {
    try {
      FileWriter fw = new FileWriter(FILENAME_TIMESTAMPS);
      BufferedWriter bw = new BufferedWriter(fw);

      for (Map.Entry<String, Long> entry : updateStamps.entrySet()) {
        String line = String.format("%s:%s:%d", username, URLEncoder.encode(entry.getKey(), "UTF-8"), entry.getValue());
        
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

}

