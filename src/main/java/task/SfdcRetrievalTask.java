package task;

import java.io.ByteArrayOutputStream;
import java.io.File;
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
import task.handler.TransformationHandler;
import task.handler.UpdateStampHandler;
import task.handler.ZipFileHandler;
import task.model.SfdcTypeSets;

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
  private boolean full;
  private String transformationsRoot;

  private UpdateStampHandler updateStampHandler;
  private SfdcHandler sfdcHandler;
  private MetadataHandler metadataHandler;
  private ZipFileHandler zipFileHandler;
  private TransformationHandler transformationHandler;

  public SfdcRetrievalTask()
  {
    objects = new HashSet<String>();
    updateStampHandler = new UpdateStampHandler();
    sfdcHandler = new SfdcHandler();
    metadataHandler = new MetadataHandler();
    zipFileHandler = new ZipFileHandler();
    transformationHandler = new TransformationHandler();
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

  public void setFull(boolean full)
  {
    this.full = full;
  }
  
  public void setTransformationsRoot(String transformationsRoot)
  {
    this.transformationsRoot = transformationsRoot;
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

    Map<String, List<String>> metadata2Update = null;
    if (full) {
      metadata2Update = sfdcHandler.extractMetadata(objects);
    } else {
      Map<String, Long> metadataUpdatestamps = sfdcHandler.getUpdateStamps(objects);
      Map<String, UpdateStampHandler.Action> differences = updateStampHandler.calculateDifferences(metadataUpdatestamps);
  
      metadata2Update = metadataHandler.collectMetadataToUpdate(differences);
      metadataHandler.removeMetadataToDelete(differences);
      
      // TODO create destructive changes
    }
    
    byte[] packageXml = metadataHandler.createPackageXml(metadata2Update);
    metadataHandler.savePackageXml(packageXml);
    ByteArrayOutputStream zipFile = sfdcHandler.retrieveMetadata(metadata2Update);
    zipFileHandler.saveZipFile("retrieve", zipFile);
    zipFileHandler.extractZipFile(retrieveRoot, zipFile);
    
    if (full) {
      
    }
    // TODO think about saving the timestamps
  }

  private void initialize()
  {
    LogWrapper logWrapper = new LogWrapper(this);

    updateStampHandler.initialize(logWrapper, username, timestamps, !full);
    transformationHandler.initialize(logWrapper, username, transformationsRoot, retrieveRoot);
    
    sfdcHandler.initialize(logWrapper, maxPoll, dryRun, serverurl, username, password, useProxy, proxyHost, proxyPort, updateStampHandler);
    metadataHandler.initialize(logWrapper, retrieveRoot, debug, updateStampHandler);
    zipFileHandler.initialize(logWrapper, debug, transformationHandler);
  }

  private void validate()
  {
    // TODO validate settings
    if (null == retrieveRoot) {
      throw new BuildException("The property retrieveRoot must be specified.");
    }
    if (!full && (null == timestamps)) {
      throw new BuildException("The property timestamps must be specified.");
    }
    if (!full && !new File(timestamps).exists()) {
      throw new BuildException(String.format("The file %s does not exist. Please deploy first or use the target 'retrieveAll'.", timestamps));
    }
  }
  
}
