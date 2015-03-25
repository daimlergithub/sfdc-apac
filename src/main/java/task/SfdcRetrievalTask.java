package task;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.taskdefs.Taskdef;
import org.apache.tools.ant.types.LogLevel;

import task.handler.LogWrapper;
import task.handler.MetadataHandler;
import task.handler.SfdcHandler;
import task.handler.TransformationHandler;
import task.handler.UpdateStampHandler;
import task.handler.ZipFileHandler;
import task.model.SfdcFeature;
import task.model.SfdcTypeSet;
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
  private List<SfdcTypeSet> typeSets;
  private String timestamps;
  
  // non-full retrievals are broken! Retrieving the timestamps does not return changed value when the setting has been changed on the UI.
  private final boolean full = true;
  private boolean cleanupOther;
  private String transformationsRoot;
  private Map<String, SfdcFeature> features;

  private UpdateStampHandler updateStampHandler;
  private SfdcHandler sfdcHandler;
  private MetadataHandler metadataHandler;
  private ZipFileHandler zipFileHandler;
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

  public void setCleanupOther(boolean cleanupOther)
  {
    this.cleanupOther = cleanupOther;
  }

  public void setTransformationsRoot(String transformationsRoot)
  {
    this.transformationsRoot = transformationsRoot;
  }

  public void addConfigured(SfdcTypeSets typeSetNames)
  {
    typeSetNames.validateSettings();
    
    String names = typeSetNames.getNames();
    String[] tokens = names.split(",");
    for (String token : tokens) {
      String trimmed = StringUtils.trimToEmpty(token);
      if (StringUtils.isNotEmpty(trimmed)) {
        SfdcTypeSet typeSet = new SfdcTypeSet();
        typeSet.setName(trimmed);

        typeSets.add(typeSet);
      }
    }
  }

  public void addConfigured(SfdcFeature feature)
  {
    feature.validateSettings();

    features.put(feature.getFeature().name(), feature);
  }

  @Override
  public void init()
  {
    super.init();

    typeSets = new ArrayList<>();
    updateStampHandler = new UpdateStampHandler();
    sfdcHandler = new SfdcHandler();
    metadataHandler = new MetadataHandler();
    zipFileHandler = new ZipFileHandler();
    transformationHandler = new TransformationHandler();
    features = new HashMap<>();

    cleanupOther = true;
  }

  @Override
  public void execute()
  {
    validate();
    initialize();

    Map<String, Map<String, Long>> metadataUpdatestamps = sfdcHandler.getUpdateStamps(typeSets);

    Map<String, List<String>> metadata2Update = null;
    if (full) {
      metadata2Update = updateStampHandler.buildEntityList(metadataUpdatestamps);
    }
    else {
      Map<String, UpdateStampHandler.Action> differences =
          updateStampHandler.calculateDifferences(metadataUpdatestamps);

      metadata2Update = metadataHandler.collectMetadataToUpdate(differences);
      metadataHandler.removeMetadataToDelete(typeSets, differences);
      metadataHandler.createDestructivePackageXml(differences);
    }

    byte[] packageXml = metadataHandler.createPackageXml(metadata2Update);
    metadataHandler.savePackageXml(packageXml);
    ByteArrayOutputStream zipFile = sfdcHandler.retrieveMetadata(metadata2Update);
    zipFileHandler.saveZipFile("retrieve", zipFile);
    zipFileHandler.extractZipFile(retrieveRoot, zipFile);

    if (full) {
      metadataHandler.removeNotcontainedMetadata(metadata2Update, typeSets, cleanupOther);
    }
    updateStampHandler.updateTimestamps(metadataUpdatestamps, full);
  }

  private void initialize()
  {
    LogWrapper logWrapper = new LogWrapper(this);

    updateStampHandler.initialize(logWrapper, username, timestamps, !full);
    transformationHandler.initialize(logWrapper, username, transformationsRoot, retrieveRoot);

    sfdcHandler.initialize(this,
                           maxPoll,
                           dryRun,
                           serverurl,
                           username,
                           password,
                           useProxy,
                           proxyHost,
                           proxyPort,
                           updateStampHandler,
                           features);
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
      throw new BuildException(String.format("The file %s does not exist. Please deploy first or use the target 'retrieveAll'.",
                                             timestamps));
    }
    
    Set<String> typeNames = new HashSet<>();
    for (SfdcTypeSet typeSet : typeSets) {
      typeNames.add(typeSet.getName());
    }
    String[] relatedTypes = new String[]{"CustomApplication", "ApexClass", "CustomPermission", "ExternalDataSource", "CustomObject", "ApexPage", "CustomTab"};
    if (typeNames.contains("PermissionSet")) {
      for (String relatedType : relatedTypes) {
        checkSfdcTypeSet(typeNames, "PermissionSet", relatedType);
      }
    }
    if (typeNames.contains("Profile")) {
      for (String relatedType : relatedTypes) {
        checkSfdcTypeSet(typeNames, "Profile", relatedType);
      }
    }
  }

  private void checkSfdcTypeSet(Set<String> typeNames, String parentType, String relatedType)
  {
    if (!typeNames.contains(relatedType)) {
      log(String.format("Adding %s for type set %s.", relatedType, parentType), LogLevel.WARN.getLevel());
      SfdcTypeSet sts = new SfdcTypeSet();
      sts.setName(relatedType);
      typeSets.add(sts);
      
      typeNames.add(relatedType);
    }
  }

}
