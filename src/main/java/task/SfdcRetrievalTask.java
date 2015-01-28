package task;

import java.io.ByteArrayOutputStream;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.taskdefs.Taskdef;

import task.handler.LogWrapper;
import task.handler.MetadataHandler;
import task.handler.SfdcHandler;
import task.handler.UpdateStampHandler;
import task.handler.ZipFileHandler;

/**
 * SfdcRetrievalTask
 *
 * @author  xlehmf
 */
public class SfdcRetrievalTask
  extends Taskdef
{

  private String username;
  private String password;
  private String serverurl;
  private int maxPoll;
  private boolean useProxy;
  private String proxyHost;
  private int proxyPort;
  private String retrieveRoot;
  private boolean debug;
  private boolean dryRun;
  private Set<String> objects;
  private String timestamps;

  private UpdateStampHandler updateStampHandler;
  private SfdcHandler sfdcHandler;
  private MetadataHandler metadataHandler;
  private ZipFileHandler zipFileHandler;

  public SfdcRetrievalTask()
  {
    objects = new HashSet<String>();
    updateStampHandler = new UpdateStampHandler();
    sfdcHandler = new SfdcHandler();
    metadataHandler = new MetadataHandler();
    zipFileHandler = new ZipFileHandler();
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

  public void setMaxPoll(int maxPoll)
  {
    this.maxPoll = maxPoll;
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

  public void setRetrieveRoot(String retrieveRoot)
  {
    this.retrieveRoot = retrieveRoot;
  }

  public void setDebug(boolean debug)
  {
    this.debug = debug;
  }

  public void setDryRun(boolean dryRun)
  {
    this.dryRun = dryRun;
  }

  public void setTimestamps(String timestamps)
  {
    this.timestamps = timestamps;
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
    initialize();
    validate();

    // TODO consider timestamps
    Map<String, Long> metadataUpdatestamps = sfdcHandler.getUpdateStamps(objects);
    Map<String, UpdateStampHandler.Action> differences = updateStampHandler.calculateDifferences(metadataUpdatestamps);
    
    
    Map<String, List<String>> metadata = sfdcHandler.extractMetadata(objects);
    byte[] packageXml = metadataHandler.createPackageXml(metadata);
    metadataHandler.savePackageXml(packageXml);
    ByteArrayOutputStream zipFile = sfdcHandler.retrieveMetadata(metadata);
    zipFileHandler.saveZipFile("retrieve", zipFile);
    zipFileHandler.extractZipFile(retrieveRoot, zipFile);
    
//    List<DeploymentInfo> deploymentInfos = metadataHandler.compileDeploymentInfos(typeSets);
//
//    if (deploymentInfos.isEmpty()) {
//      log(String.format("Nothing to deploy."));
//    }
//    else {
//      ByteArrayOutputStream zipFile = zipFileHandler.prepareZipFile(deploymentInfos);
//      zipFileHandler.saveZipFile(zipFile);
//      sfdcHandler.deployTypes(zipFile, deploymentInfos);
//    }
  }

  private void initialize()
  {
    LogWrapper logWrapper = new LogWrapper(this);

    updateStampHandler.initializeUpdateStamps(logWrapper, username, timestamps);
    
    sfdcHandler.initialize(logWrapper, maxPoll, dryRun, serverurl, username, password, useProxy, proxyHost, proxyPort, updateStampHandler);
    metadataHandler.initialize(logWrapper, retrieveRoot, debug, updateStampHandler);
    zipFileHandler.initialize(logWrapper, debug);
  }

  private void validate()
  {
    updateStampHandler.validate();
    sfdcHandler.validate();
    metadataHandler.validate();
    zipFileHandler.validate();

    // TODO validate settings
    if (null == retrieveRoot) {
      throw new BuildException("The property retrieveRoot must be specified.");
    }
    if (null == timestamps) {
      throw new BuildException("The property timestamps must be specified.");
    }
  }
  
}
