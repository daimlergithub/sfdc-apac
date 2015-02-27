package task;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.taskdefs.Taskdef;

import task.handler.ChecksumHandler;
import task.handler.DeploymentInfo;
import task.handler.LogWrapper;
import task.handler.MetadataHandler;
import task.handler.SfdcHandler;
import task.handler.TransformationHandler;
import task.handler.ZipFileHandler;
import task.model.SfdcTypeSet;

/**
 * SfdcDeploymentTask
 *
 * @author  xlehmf
 */
public class SfdcDeploymentTask
  extends Taskdef
{

  private String username;
  private String password;
  private String serverurl;
  private int maxPoll;
  private boolean useProxy;
  private String proxyHost;
  private int proxyPort;
  private String deployRoot;
  private boolean debug;
  private boolean dryRun;
  private List<SfdcTypeSet> typeSets;
  private String transformationsRoot;
  private String checksums;

  private ChecksumHandler checksumHandler;
  private ZipFileHandler zipFileHandler;
  private SfdcHandler sfdcHandler;
  private MetadataHandler metadataHandler;
  private TransformationHandler transformationHandler;

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

  public void setDeployRoot(String deployRoot)
  {
    this.deployRoot = deployRoot;
  }

  public void setDebug(boolean debug)
  {
    this.debug = debug;
  }

  public void setDryRun(boolean dryRun)
  {
    this.dryRun = dryRun;
  }

  public void setTransformationsRoot(String transformationsRoot)
  {
    this.transformationsRoot = transformationsRoot;
  }

  public void setChecksums(String checksums)
  {
    this.checksums = checksums;
  }

  public void addConfigured(SfdcTypeSet typeSet)
  {
    typeSet.validateSettings();
    
    typeSets.add(typeSet);
  }

  @Override
  public void init()
    throws BuildException
  {
    super.init();
    
    typeSets = new ArrayList<>();
    checksumHandler = new ChecksumHandler();
    zipFileHandler = new ZipFileHandler();
    sfdcHandler = new SfdcHandler();
    metadataHandler = new MetadataHandler();
    transformationHandler = new TransformationHandler();
  }

  @Override
  public void execute()
  {
    validate();
    initialize();
    
    List<DeploymentInfo> deploymentInfos = metadataHandler.compileDeploymentInfos(typeSets);
    if (deploymentInfos.isEmpty()) {
      log(String.format("Nothing to deploy."));
    }
    else {
      byte[] packageXml = metadataHandler.createPackageXml(deploymentInfos);
      metadataHandler.savePackageXml(packageXml);
      ByteArrayOutputStream zipFile = zipFileHandler.prepareZipFile(deploymentInfos, packageXml);
      zipFileHandler.saveZipFile("deploy", zipFile);
      sfdcHandler.deployTypes(zipFile, deploymentInfos);
    }
  }

  private void initialize()
  {
    LogWrapper logWrapper = new LogWrapper(this);

    checksumHandler.initialize(logWrapper, username, checksums, true);
    transformationHandler.initialize(logWrapper, username, transformationsRoot, deployRoot);
    
    sfdcHandler.initialize(this, maxPoll, dryRun, serverurl, username, password, useProxy, proxyHost, proxyPort, checksumHandler, null);
    zipFileHandler.initialize(logWrapper, debug, transformationHandler);
    metadataHandler.initialize(logWrapper, deployRoot, debug, checksumHandler);
  }

  private void validate()
  {
    // TODO validate settings
  }
  
}
