package task;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.taskdefs.Taskdef;

import task.handler.LogWrapper;
import task.handler.SfdcHandler;
import task.handler.UpdateStampHandler;
import task.model.SfdcTypeSet;
import task.model.SfdcTypeSets;

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
  private String timestamps;
  private List<SfdcTypeSet> typeSets;

  private UpdateStampHandler updateStampHandler;
  private SfdcHandler sfdcHandler;

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

  public void setTimestamps(String timestamps)
  {
    this.timestamps = timestamps;
  }

  public void addConfigured(SfdcTypeSets typeSetNames)
  {
    String names = typeSetNames.getNames();
    
    if (StringUtils.isNotEmpty(names)) {
      String[] tokens = names.split(",");
      for (String token : tokens) {
        String trimmed = StringUtils.trimToEmpty(token);
        if (StringUtils.isNotEmpty(trimmed)) {
          SfdcTypeSet typeSet = new SfdcTypeSet();
          typeSet.setName(trimmed);
          
          typeSets.add(typeSet);
        }
      }
    } else {
      throw new BuildException("The names of type sets must be set.");
    }
  }
  
  public void addConfigured(SfdcTypeSet typeSet)
  {
    typeSets.add(typeSet);
  }

  @Override
  public void init() {
    super.init();
    
    typeSets = new ArrayList<>();
    updateStampHandler = new UpdateStampHandler();
    sfdcHandler = new SfdcHandler();
  }
  
  @Override
  public void execute()
  {
    validate();
    initialize();
    
    Map<String, Map<String, Long>> updateStamps = sfdcHandler.getUpdateStamps(typeSets);
    updateStampHandler.updateTimestamps(updateStamps, true);
  }

  private void initialize()
  {
    LogWrapper logWrapper = new LogWrapper(this);

    updateStampHandler.initialize(logWrapper, username, timestamps, false);
    
    sfdcHandler.initialize(this, 0, false, serverurl, username, password, useProxy, proxyHost, proxyPort, updateStampHandler, null);
  }

  private void validate()
  {
    if (null == timestamps) {
      throw new BuildException("The property timestamps must be specified.");
    }
    
    for (SfdcTypeSet typeSet : typeSets) {
      typeSet.validateSettings();
    }

    // TODO fix this
    // metadataHandler.validateTypeSetsByName(typeSets);
  }
  
}
