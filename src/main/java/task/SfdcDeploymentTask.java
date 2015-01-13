package task;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import org.apache.commons.codec.binary.Base64OutputStream;
import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.taskdefs.Taskdef;
import org.apache.tools.ant.types.LogLevel;

import com.sforce.soap.enterprise.EnterpriseConnection;
import com.sforce.soap.enterprise.LoginResult;
import com.sforce.soap.metadata.AsyncResult;
import com.sforce.soap.metadata.DeployOptions;
import com.sforce.soap.metadata.DeployResult;
import com.sforce.soap.metadata.MetadataConnection;
import com.sforce.ws.ConnectionException;
import com.sforce.ws.ConnectorConfig;

import deployer.DeploymentConfiguration;
import deployer.DeploymentUnit;

/**
 * SfdcDeploymentTask
 *
 * @author  xlehmf
 */
public class SfdcDeploymentTask
  extends Taskdef
{

  private static final String FILENAME_TIMESTAMPS = "timestamps.log";

  private String username;
  private String password;
  private String serverurl;
  private int maxPoll;
  private boolean useProxy;
  private String proxyHost;
  private int proxyPort;
  private String deployRoot;
  private boolean debug;
  private List<SfdcTypeSet> typeSets;

  public SfdcDeploymentTask()
  {
    typeSets = new ArrayList<SfdcTypeSet>();
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

  public void addConfigured(SfdcTypeSet typeSet)
  {
    typeSets.add(typeSet);
  }
  
  public void execute()
  {
    validateSettings();

    List<DeploymentUnit> duList = new DeploymentConfiguration().getConfigurations();

    try {
      ConnectorConfig eConfig = createConnectorConfig();
      EnterpriseConnection eConnection = new EnterpriseConnection(eConfig);

      LoginResult loginResult = login(eConnection, eConfig);
      MetadataConnection mConnection = createMetadataConnection(loginResult);

      Map<String, Long> updateStamps = readUpdateStamps();

      File baseDir = new File(deployRoot);

      for (SfdcTypeSet typeSet : typeSets) {
        DeploymentUnit du = findDeploymentUnit(duList, typeSet);

        List<File> fileList = compileFileList(baseDir, typeSet, du, updateStamps);
        if (fileList.isEmpty()) {
          continue;
        }

        List<String> entityNames = compileEntityNames(du, fileList);

        deployType(mConnection, du, fileList, entityNames, updateStamps);

        writeUpdateStampes(updateStamps);
      }

      eConnection.logout();
    }
    catch (ConnectionException e) {
      e.printStackTrace();
    }
  }

  private void validateSettings()
  {
    // TODO validate settings
    for (SfdcTypeSet typeSet : typeSets) {
      typeSet.validateSettings();
    }
  }

  private static Map<String, Long> readUpdateStamps()
  {
    Map<String, Long> result = new HashMap<>();

    try {
      FileReader fr = new FileReader(FILENAME_TIMESTAMPS);
      BufferedReader br = new BufferedReader(fr);

      String line = null;
      do {
        line = br.readLine();
        if (null != line) {
          String[] tokens = line.split(":");
          if (2 == tokens.length) {
            String type = tokens[0];
            Long timestamp = Long.valueOf(tokens[1]);
            result.put(type, timestamp);
          }
        }

      }
      while (null != line);

      br.close();
    }
    catch (IOException e) {
      // TODO
      System.out.println(String.format("Error reading update stamps."));
    }
    return result;
  }

  private static void printUpdatestamps(Map<String, Long> updateStamps)
  {
    // TODO
    System.out.println("Update stamps:");
    for (Map.Entry<String, Long> entry : updateStamps.entrySet()) {
      System.out.println(String.format("%s: %d", entry.getKey(), entry.getValue()));
    }
  }

  private static void writeUpdateStampes(Map<String, Long> updateStamps)
  {
    try {
      FileWriter fw = new FileWriter(FILENAME_TIMESTAMPS);
      BufferedWriter bw = new BufferedWriter(fw);

      for (Map.Entry<String, Long> entry : updateStamps.entrySet()) {
        bw.write(String.format("%s:%d", entry.getKey(), entry.getValue()));
        bw.newLine();
      }

      bw.close();
    }
    catch (IOException e) {
      // TODO
      System.out.println(String.format("Error saving update stamps."));
    }
  }

  private DeploymentUnit findDeploymentUnit(List<DeploymentUnit> duList, SfdcTypeSet typeSet)
  {
    for (DeploymentUnit du : duList) {
      if (typeSet.getName().equals(du.getSubDir())) {
        log(String.format("Found deployment information for type %s.", typeSet.getName()));
        return du;
      }
    }

    throw new BuildException(String.format("Could not find deployment unit for fileset %s.", typeSet.getName()));
  }

  private List<File> compileFileList(File baseDir, SfdcTypeSet typeSet, DeploymentUnit du, Map<String, Long> updateStamps)
    throws ConnectionException
  {
    String type = du.getType().getSimpleName();

    log(String.format("Deploying metadata for type %s...", type));

    List<File> fileList = du.getFiles(baseDir);

    // process includes
    List<File> filteredFileList = new ArrayList<>();
    if (typeSet.getIncludes().isEmpty()) {
      filteredFileList.addAll(fileList);
    } else {
      for (SfdcInclude include : typeSet.getIncludes()) {
        for (File file : fileList) {
          String fileName = StringUtils.substringBefore(file.getName(), ".");
          if (fileName.matches(include.getName())) {
            filteredFileList.add(file);
          }
        }
      }
    }
    
    // process excludes
    if (!typeSet.getExcludes().isEmpty()) {
      for (SfdcExclude exclude : typeSet.getExcludes()) {
        Iterator<File> fileItr = filteredFileList.iterator();
        while (fileItr.hasNext()) {
          File file = fileItr.next();
          String fileName = StringUtils.substringBefore(file.getName(), ".");
          if (fileName.matches(exclude.getName())) {
            fileItr.remove();
          }
        }
      }
    }

    // check timestamps
    Set<String> entitiesToUpdate = new HashSet<String>();
    for (File file : filteredFileList) {
      long timestamp = file.lastModified();
      String entityName = du.getEntityName(file);
      String key = du.getType().getSimpleName() + "/" + entityName;
      Long updateStamp = updateStamps.get(key);
      
      if (null == updateStamp || timestamp > updateStamp.longValue()) {
        entitiesToUpdate.add(entityName);
      }
    }
    Iterator<File> fileItr = filteredFileList.iterator();
    while (fileItr.hasNext()) {
      File file = fileItr.next();
      String entityName = du.getEntityName(file);
      if (!entitiesToUpdate.contains(entityName)) {
        fileItr.remove();
      }
    }

    if (filteredFileList.isEmpty()) {
      log(String.format("Nothing to deploy for %s.", type));
    }

    return filteredFileList;
  }

  private List<String> compileEntityNames(DeploymentUnit du, List<File> fileList)
  {
    // we need the list to keep the order of the files
    Set<String> entitySet = new HashSet<>();
    List<String> entityNames = new ArrayList<>();
    for (File file : fileList) {
      String entityName = du.getEntityName(file);
      
      if (null == entityName) {
        throw new BuildException(String.format("Error getting entity name for file %s.", file.getName()));
      }
      
      if (!entitySet.contains(entityName)) {
        entitySet.add(entityName);
        entityNames.add(entityName);
      }
    }

    return entityNames;
  }

  private void deployTypes(MetadataConnection mConnection,
                          final List<DeploymentUnit> duList,
                          List<File> fileList,
                          List<String> entityNames, Map<String, Long> updateStamps)
    throws ConnectionException
  {
    String type = du.getType().getSimpleName();

    ByteArrayOutputStream baos = new ByteArrayOutputStream();

    Base64OutputStream b64os = new Base64OutputStream(baos);

    try {
      ZipOutputStream zos = new ZipOutputStream(baos);

      byte[] buffer = new byte[512];

      for (File file : fileList) {
        String fileName = file.getName();

        log(String.format("Add (%s,%s) to ZIP...", type, fileName));

        try {
          zos.putNextEntry(new ZipEntry("unpackaged/" + du.getSubDir() + "/" + fileName));

          FileInputStream fis = new FileInputStream(file);

          int read = 0;
          do {
            read = fis.read(buffer);
            if (-1 != read) {
              zos.write(buffer, 0, read);
            }
          }
          while (-1 != read);

          fis.close();
          zos.closeEntry();
        }
        catch (Exception e) {
          throw new BuildException(String.format("Error reading metadata for type %s and file %s: %s",
                                                 type,
                                                 fileName,
                                                 e.getMessage()), e);
        }
      }

      zos.putNextEntry(new ZipEntry("unpackaged/package.xml"));
      zos.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n".getBytes("UTF-8"));
      zos.write("<Package xmlns=\"http://soap.sforce.com/2006/04/metadata\">\n".getBytes("UTF-8"));
      //zos.write("<fullName>cleanup</fullName>".getBytes("UTF-8"));
      zos.write("<types>\n".getBytes("UTF-8"));
      for (String entityName : entityNames) {
        zos.write(("<members>" + entityName + "</members>\n").getBytes("UTF-8"));
      }
      zos.write(("<name>" + type + "</name>\n").getBytes("UTF-8"));
      zos.write("</types>\n".getBytes("UTF-8"));
      zos.write("<version>32.0</version>\n".getBytes("UTF-8"));
      zos.write("</Package>\n".getBytes("UTF-8"));
      zos.closeEntry();

      zos.close();
      b64os.close();
    }
    catch (IOException e) {
      throw new BuildException(String.format("Error preparing ZIP for deployment: %s.", e.getMessage()), e);
    }

    log(String.format("Starting deployment of type %s...", type));

    DeployOptions options = new DeployOptions();
    options.setPerformRetrieve(false);
    options.setRollbackOnError(true);

    AsyncResult ar = mConnection.deploy(baos.toByteArray(), options);

    // debugging
    if (debug) {
      String fileName = "deploy-" + System.currentTimeMillis() + ".zip";
      
      log(String.format("Saving ZIP file to %s...", fileName));
      
      try {
        File tmp = new File("tmp", fileName);
        FileOutputStream fos = new FileOutputStream(tmp);
        fos.write(baos.toByteArray());
        fos.close();
      }
      catch (IOException e) {
        log(String.format("Error preparing ZIP for deployment: %s.", e.getMessage()),
            e,
            LogLevel.WARN.getLevel());
      }
    }

    int count = 0;
    DeployResult status = null;
    do {

      log(String.format("Waiting for job %s to finish...", ar.getId()));

      try {
        Thread.sleep(3000);
      }
      catch (InterruptedException e) {
        // TODO
        System.err.println(String.format("Got interrupted while sleeping for deployment result: %s.", e.getMessage()));
      }
      status = mConnection.checkDeployStatus(ar.getId(), true);

      count++;
    }
    while (!status.isDone() && count < maxPoll);

    if (status.isDone()) {
      if (status.isSuccess()) {
        log(String.format("Deploying of %s and %s successful.",
                          type,
                          Arrays.toString(entityNames.toArray(new String[entityNames.size()]))));

        for (File file : fileList) {
          long lastModified = file.lastModified();
          String entityName = du.getEntityName(file);
          String key = du.getType().getSimpleName() + "/" + entityName;
          Long updateStamp = updateStamps.get(key);
              
          if (null == updateStamp || lastModified > updateStamp.longValue()) {
            updateStamps.put(key, lastModified);
          }
        }
      }
      else {
        log(String.format("Error %s: %s.",
                          null != status.getErrorStatusCode() ? status.getErrorStatusCode().toString() : "<null>",
                          status.getErrorMessage()), LogLevel.ERR.getLevel());

        throw new BuildException(String.format("Deploying of %s and %s not successful.",
                                               type,
                                               Arrays.toString(entityNames.toArray(new String[entityNames.size()]))));
      }
    }
  }

  private ConnectorConfig createConnectorConfig()
    throws ConnectionException
  {
    ConnectorConfig eConfig = new ConnectorConfig();
    eConfig.setAuthEndpoint(serverurl + "/services/Soap/c/32.0");
    eConfig.setServiceEndpoint(eConfig.getAuthEndpoint());
    eConfig.setUsername(username);
    eConfig.setPassword(password);
    if (useProxy) {
      eConfig.setProxy(proxyHost, proxyPort);
    }
    eConfig.setManualLogin(true);

    return eConfig;
  }

  private LoginResult login(EnterpriseConnection eConnection, ConnectorConfig eConfig)
    throws ConnectionException
  {
    LoginResult loginResult = eConnection.login(eConfig.getUsername(), eConfig.getPassword());
    eConfig.setServiceEndpoint(loginResult.getServerUrl());

    eConnection.setSessionHeader(loginResult.getSessionId());

    return loginResult;
  }

  private MetadataConnection createMetadataConnection(LoginResult loginResult)
    throws ConnectionException
  {
    ConnectorConfig mConfig = new ConnectorConfig();
    mConfig.setServiceEndpoint(loginResult.getMetadataServerUrl());
    mConfig.setSessionId(loginResult.getSessionId());
    if (useProxy) {
      mConfig.setProxy(proxyHost, proxyPort);
    }

    return new MetadataConnection(mConfig);
  }

}
