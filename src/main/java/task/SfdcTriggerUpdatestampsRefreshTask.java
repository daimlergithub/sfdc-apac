package task;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.taskdefs.Taskdef;

import task.handler.DeploymentHandler;
import task.handler.LogWrapper;
import task.handler.UpdateStampHandler;
import task.model.SfdcTypeSets;

/**
 * SfdcTriggerUpdatestampsRefresh
 *
 * @author  xlehmf
 */
public class SfdcTriggerUpdatestampsRefreshTask
  extends Taskdef
{

  private String username;
  private String password;
  private String serverurl;
  private boolean useProxy;
  private String proxyHost;
  private int proxyPort;
   private String fileName;
  private Set<String> objects;

  private UpdateStampHandler updateStampHandler;
//  private SfdcHandler sfdcHandler;
  private DeploymentHandler deploymentHandler;

  public SfdcTriggerUpdatestampsRefreshTask()
  {
    objects = new HashSet<String>();
    updateStampHandler = new UpdateStampHandler();
//    sfdcHandler = new SfdcHandler();
    deploymentHandler = new DeploymentHandler();
  }

  public void setUsername(String username)
  {
    this.username = username;
  }

  public void setPassword(String password)
  {
    this.password = password;
  }

  public void setServerurl(String serverurl)
  {
    this.serverurl = serverurl;
  }

  public void setUseProxy(boolean useProxy)
  {
    this.useProxy = useProxy;
  }

  public void setProxyHost(String proxyHost)
  {
    this.proxyHost = proxyHost;
  }

  public void setProxyPort(int proxyPort)
  {
    this.proxyPort = proxyPort;
  }

  public void setFileName(String fileName)
  {
    this.fileName = fileName;
  }

  public void addConfigured(SfdcTypeSets typeSets)
  {
    String names = typeSets.getNames();
    
    if (StringUtils.isNotEmpty(names)) {
      String[] tokens = names.split(",");
      for (String token : tokens) {
        String trimmed = StringUtils.trimToEmpty(token);
        if (StringUtils.isNotEmpty(trimmed)) {
          objects.add(trimmed);
        }
      }
    } else {
      throw new BuildException("The names of type sets must be set.");
    }
  }

  public void execute()
  {
    validate();
    initialize();
    
    Map<String, Long> metadataUpdatestamps = deploymentHandler.triggerUpdatestampsRefresh(objects);

    updateStampHandler.writeUpdateStampes(metadataUpdatestamps);
  }

  private void initialize()
  {
    LogWrapper logWrapper = new LogWrapper(this);

    updateStampHandler.initialize(logWrapper, username, fileName);
//    
//    sfdcHandler.initialize(logWrapper, 0, false, serverurl, username, password, useProxy, proxyHost, proxyPort, updateStampHandler);
    deploymentHandler.initialize(logWrapper, serverurl, username, password, useProxy, proxyHost, proxyPort);
  }

  private void validate()
  {
    if (null == fileName) {
      throw new BuildException("The property fileName must be specified.");
    }
  }
  
}