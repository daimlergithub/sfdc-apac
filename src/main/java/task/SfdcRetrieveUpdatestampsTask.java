package task;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.taskdefs.Taskdef;

import task.handler.LogWrapper;
import task.handler.SfdcHandler;
import task.handler.UpdateStampHandler;

/**
 * SfdcRetrieveUpdatestampsTask
 *
 * @author  xlehmf
 */
public class SfdcRetrieveUpdatestampsTask
  extends Taskdef
{

  private String username;
  private String password;
  private String serverurl;
  private boolean useProxy;
  private String proxyHost;
  private int proxyPort;
  private String fileName;
  private Set<String> typeSets;

  private UpdateStampHandler updateStampHandler;
  private SfdcHandler sfdcHandler;

  public SfdcRetrieveUpdatestampsTask()
  {
    typeSets = new HashSet<String>();
    updateStampHandler = new UpdateStampHandler();
    sfdcHandler = new SfdcHandler();
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

  public void addConfigured(SfdcTypeSet typeSet)
  {
    String name = typeSet.getName();
    if (StringUtils.isEmpty(name)) {
      throw new BuildException("The name of the type set must be set.");
    }
    typeSets.add(name);
  }

  public void execute()
  {
    initialize();
    validate();

    Map<String, Long> metadataUpdatestamps = sfdcHandler.getUpdateStamps(typeSets);
    
    updateStampHandler.writeUpdateStampes(fileName, metadataUpdatestamps);
  }

  private void initialize()
  {
    LogWrapper logWrapper = new LogWrapper(this);

    updateStampHandler.initializeUpdateStamps(logWrapper, username);
    
    sfdcHandler.initialize(logWrapper, 0, false, serverurl, username, password, useProxy, proxyHost, proxyPort, updateStampHandler);
  }

  private void validate()
  {
    updateStampHandler.validate();
    sfdcHandler.validate();

    if (null == fileName) {
      throw new BuildException("The property fileName must be specified.");
    }
  }
  
}
