/*
 * Daimler CRM - Extension Platform
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
 * Base class for UpdateStampHandler and ChecksumHandler.
 *
 * @author  XLEHMF
 */
public abstract class BaseUpdateHandler<T>
{

  private Map<String, T> updateStamps;
  private String userName;
  private LogWrapper logWrapper;
  private String fileName;
  private boolean readUpdateStamps;

  protected Map<String, T> getUpdateStamps()
  {
    return updateStamps;
  }

  public void initialize(LogWrapper logWrapper, String userName, String fileName, boolean readUpdateStamps)
  {
    this.userName = userName;
    this.logWrapper = logWrapper;
    this.fileName = fileName;
    this.readUpdateStamps = readUpdateStamps;
    
    validate();
    initialize();
  }

  private void validate()
  {
    String name = getClass().getSimpleName();
    
    if (null == userName) {
      throw new BuildException(name + " (userName) not properly initialized.");
    }
    if (null == logWrapper) {
      throw new BuildException(name + " (logWrapper) not properly initialized.");
    }
    if (null == fileName) {
      throw new BuildException(name + " (fileName) not properly initialized.");
    }
  }

  private void initialize()
  {
    updateStamps = new HashMap<>();
  
    if (readUpdateStamps) {
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
                T value = decodeValueToken(tokens[2]);
                
                updateStamps.put(type, value);
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
  }

  protected abstract T decodeValueToken(String token);
  protected abstract String encodeValueToken(T value);
  protected abstract T getValueFromFile(File file);
  public abstract boolean isUpdateRequired(DeploymentUnit du, File file);
  
  public void updateTimestamp(List<DeploymentInfo> deploymentInfos)
  {
    for (DeploymentInfo info : deploymentInfos) {
      for (File file: info.getFileList()) {
        updateTimestamp(info.getDeploymentUnit(), file);
      }
    }
    writeUpdateStampes();
  }

  protected void writeUpdateStampes()
  {
    try {
      FileWriter fw = new FileWriter(fileName);
      BufferedWriter bw = new BufferedWriter(fw);
  
      for (Map.Entry<String, T> entry : updateStamps.entrySet()) {
        String line = String.format("%s:%s:%s", userName, URLEncoder.encode(entry.getKey(), "UTF-8"), encodeValueToken(entry.getValue()));
        
        bw.write(line);
        bw.newLine();
      }
  
      bw.close();
    }
    catch (IOException e) {
      throw new BuildException(String.format("Error saving update stamps: %s.", e.getMessage()), e);
    }
  }

  protected String getKey(DeploymentUnit du, File file)
  {
    return getKey(du.getTypeName(), file.getName());
  }

  protected String getKey(String category, String entityName)
  {
    return category + "/" + entityName;
  }

  private void updateTimestamp(DeploymentUnit du, File file)
  {
    T value = getValueFromFile(file);
    
    String key = getKey(du, file);
  
    updateStamps.put(key, value);
  }

}
