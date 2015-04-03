package task;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.List;
import java.util.Map;

import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.taskdefs.Taskdef;

import task.handler.ChecksumHandler;
import task.handler.DestructiveChangesHandler;
import task.handler.LogWrapper;
import task.handler.MetadataHandler;
import task.handler.SfdcHandler;
import task.handler.ZipFileHandler;

/**
 * SfdcDestructiveChangesDeploymentTask
 *
 * @author xlehmf
 */
public class SfdcDestructiveChangesDeploymentTask
  extends Taskdef
{

  private boolean debug;
  private boolean dryRun;
  private String username;
  private String password;
  private String serverurl;
  private int maxPoll;
  private boolean useProxy;
  private String proxyHost;
  private int proxyPort;
  private String deployRoot;
  private String destructiveFile;
  private String checksums;
  private boolean generate;

  private ChecksumHandler checksumHandler;
  private SfdcHandler sfdcHandler;
  private MetadataHandler metadataHandler;
  private DestructiveChangesHandler destructiveHandler;
  private ZipFileHandler zipFileHandler;

  public SfdcDestructiveChangesDeploymentTask() {
    generate = true;
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

  public void setDestructiveFile(String destructiveFile)
  {
    this.destructiveFile = destructiveFile;
  }

  public void setChecksums(String checksums)
  {
    this.checksums = checksums;
  }

  public void setGenerate(boolean generate)
  {
    this.generate = generate;
  }

  @Override
  public void init()
    throws BuildException
  {
    super.init();
    
    checksumHandler = new ChecksumHandler();
    sfdcHandler = new SfdcHandler();
    metadataHandler = new MetadataHandler();
    zipFileHandler = new ZipFileHandler();
    destructiveHandler = new DestructiveChangesHandler();
  }

  @Override
  public void execute()
  {
    validate();
    initialize();
    
    // generate destructive changes files
    if (generate) {
      Map<String, List<String>> destructiveChanges = destructiveHandler.readDestructiveChanges();
      metadataHandler.createDestructivePackageXml(destructiveChanges);
      destructiveHandler.resetDestructiveChanges();
    }
    
    // deploy destructive changes files
    Map<String, File> destructiveFiles = metadataHandler.collectDestructiveFiles();
    Map<String, File> destructiveFilesToDeploy = checksumHandler.filterDestructiveFiles(destructiveFiles);
    for (Map.Entry<String, File> destructiveEntry : destructiveFilesToDeploy.entrySet()) {
      ByteArrayOutputStream zipFile = zipFileHandler.prepareDestructiveZipFile(destructiveEntry.getValue());
      zipFileHandler.saveZipFile("destructiveChanges", zipFile);
      try {
        sfdcHandler.deploy(zipFile, "destructive changes");
        checksumHandler.updateDestructiveTimestamp(destructiveEntry.getKey());
      } catch (BuildException e) {
        // only set a property to prevent other deploy steps from being executed
        getProject().setProperty("deploy-failed", "true");
      }
    }
  }

  private void initialize()
  {
    LogWrapper logWrapper = new LogWrapper(this);

    checksumHandler.initialize(logWrapper, checksums, true, dryRun);
    metadataHandler.initialize(logWrapper, deployRoot, debug);
    sfdcHandler.initialize(this, maxPoll, dryRun, serverurl, username, password, useProxy, proxyHost, proxyPort, null);
    destructiveHandler.initialize(logWrapper, deployRoot, destructiveFile);
    zipFileHandler.initialize(logWrapper, debug, null, metadataHandler);
  }

  private void validate()
  {
    // TODO validate settings
  }
  
}
