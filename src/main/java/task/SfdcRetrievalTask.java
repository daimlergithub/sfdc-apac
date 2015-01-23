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
  private Set<String> typeSets;

  private UpdateStampHandler updateStampHandler;
  private SfdcHandler sfdcHandler;
  private MetadataHandler metadataHandler;
  private ZipFileHandler zipFileHandler;

  public SfdcRetrievalTask()
  {
    typeSets = new HashSet<String>();
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

    // TODO consider timestamps
    
    Map<String, List<String>> metadata = sfdcHandler.extractMetadata(typeSets);
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

    updateStampHandler.initializeUpdateStamps(logWrapper, username);
    
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
  }
  
}
