/*
 * Daimler CRM - Extension Platform
 */
package task.handler;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildEvent;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.BuildListener;
import org.apache.tools.ant.Task;
import org.apache.tools.ant.types.LogLevel;

import task.handler.configuration.DeploymentUnit;

import com.sforce.soap.enterprise.EnterpriseConnection;
import com.sforce.soap.enterprise.LoginResult;
import com.sforce.soap.metadata.AsyncResult;
import com.sforce.soap.metadata.DeployOptions;
import com.sforce.soap.metadata.DeployResult;
import com.sforce.soap.metadata.DescribeMetadataObject;
import com.sforce.soap.metadata.DescribeMetadataResult;
import com.sforce.soap.metadata.FileProperties;
import com.sforce.soap.metadata.ListMetadataQuery;
import com.sforce.soap.metadata.Metadata;
import com.sforce.soap.metadata.MetadataConnection;
import com.sforce.soap.metadata.Package;
import com.sforce.soap.metadata.PackageTypeMembers;
import com.sforce.soap.metadata.ReadResult;
import com.sforce.soap.metadata.RetrieveRequest;
import com.sforce.soap.metadata.RetrieveResult;
import com.sforce.soap.metadata.StaticResource;
import com.sforce.soap.metadata.StaticResourceCacheControl;
import com.sforce.soap.metadata.UpsertResult;
import com.sforce.ws.ConnectionException;
import com.sforce.ws.ConnectorConfig;

/**
 * SfdcHandler
 *
 * @author  XLEHMF
 */
public class SfdcHandler
{

  private static final String PROJECT_PROPERTY_SFDC_SESSION = "SFDC_SESSION";

  private class SfdcBuildListener
    implements BuildListener
  {

    @Override
    public void buildStarted(BuildEvent event)
    {
      // TODO we could move the login here
    }

    @Override
    public void buildFinished(BuildEvent event)
    {
      ConnectorConfig eConfig = createConnectorConfig();
      try {
        EnterpriseConnection eConnection = new EnterpriseConnection(eConfig);
        SfdcConnectionContext result = retrieveContext(eConnection);
        if (null != result) {
          result.getEConnection().logout();
        }
      }
      catch (ConnectionException e) {
        // e.printStackTrace();

        throw new BuildException(String.format("Error logging out at SFDC: %s.", e.getMessage()), e);
      }
    }

    @Override
    public void targetStarted(BuildEvent event)
    {
      // nothing to do
    }

    @Override
    public void targetFinished(BuildEvent event)
    {
      // nothing to do
    }

    @Override
    public void taskStarted(BuildEvent event)
    {
      // nothing to do
    }

    @Override
    public void taskFinished(BuildEvent event)
    {
      // nothing to do
    }

    @Override
    public void messageLogged(BuildEvent event)
    {
      // nothing to do
    }

  }

  private final static double VERSION = 32.0d;
  private final Set<String> noChildHandling = new HashSet<>();

  private Task task;
  private int maxPoll;
  private boolean dryRun;
  private String serverurl;
  private String username;
  private String password;
  private boolean useProxy;
  private String proxyHost;
  private int proxyPort;
  private BaseUpdateHandler<?> updateHandler;

  public SfdcHandler()
  {
    noChildHandling.add("CustomObject");
    // noChildHandling.add("CustomLabels");
    noChildHandling.add("Workflow");
  }

  @SuppressWarnings("hiding")
  public void initialize(Task task,
                         int maxPoll,
                         boolean dryRun,
                         String serverurl,
                         String username,
                         String password,
                         boolean useProxy,
                         String proxyHost,
                         int proxyPort,
                         BaseUpdateHandler<?> updateStampHandler)
  {
    this.task = task;
    this.maxPoll = maxPoll;
    this.dryRun = dryRun;
    this.serverurl = serverurl;
    this.username = username;
    this.password = password;
    this.useProxy = useProxy;
    this.proxyHost = proxyHost;
    this.proxyPort = proxyPort;
    this.updateHandler = updateStampHandler;

    validate();

    // do not register a second time to omit double logouts
    boolean alreadyRegistered = false;
    for (BuildListener bl : task.getProject().getBuildListeners()) {
      if (SfdcBuildListener.class.getSimpleName().equals(bl.getClass().getSimpleName())) {
        alreadyRegistered = true;
      }
    }
    if (!alreadyRegistered) {
      task.getProject().addBuildListener(new SfdcBuildListener());
    }
  }

  private void validate()
  {
    if (null == task || null == updateHandler || null == serverurl || null == username || null == password) {
      throw new BuildException("SfdcHandler is not properly initialized.");
    }
  }

  public boolean deployTypes(ByteArrayOutputStream zipFile, List<DeploymentInfo> infos)
  {
    boolean result = false;

    if (dryRun) {
      return false;
    }

    try {
      SfdcConnectionContext context = login();

      task.log(String.format("Start deployment of ZIP."));

      DeployOptions options = new DeployOptions();
      options.setPerformRetrieve(false);
      options.setRollbackOnError(true);

      AsyncResult ar = context.getMConnection().deploy(zipFile.toByteArray(), options);

      int count = 0;
      DeployResult status = null;
      do {

        task.log(String.format("Wait for job %s to finish...", ar.getId()));

        try {
          Thread.sleep(3000);
        }
        catch (InterruptedException e) {
          task.log(String.format("Got interrupted while sleeping for deployment result: %s.", e.getMessage()));
        }
        status = context.getMConnection().checkDeployStatus(ar.getId(), true);

        count++;
      }
      while (!status.isDone() && count < maxPoll);

      if (status.isDone()) {
        if (status.isSuccess()) {
          for (DeploymentInfo info : infos) {
            DeploymentUnit du = info.getDeploymentUnit();

            task.log(String.format("Deployment of %s and %s successful.",
                                   du.getTypeName(),
                                   Arrays.toString(info.getEntityNames().toArray(new String[0]))));
          }
          updateHandler.updateTimestamp(infos);
        }
        else {
          task.log(String.format("Error %s: %s.",
                                 null != status.getErrorStatusCode()
                                                                    ? status.getErrorStatusCode().toString()
                                                                    : "<null>",
                                 status.getErrorMessage()), LogLevel.ERR.getLevel());

          List<String> types = new ArrayList<>();
          for (DeploymentInfo info : infos) {
            types.add(info.getDeploymentUnit().getTypeName());
          }

          throw new BuildException(String.format("Deployment of %s not successful.",
                                                 Arrays.toString(types.toArray(new String[0]))));
        }
      }

      return result;
    }
    catch (ConnectionException e) {
      throw new BuildException(String.format("Error connecting to SFDC: %s.", e.getMessage()), e);
    }
  }

  private SfdcConnectionContext login()
    throws ConnectionException
  {
    ConnectorConfig eConfig = createConnectorConfig();
    EnterpriseConnection eConnection = new EnterpriseConnection(eConfig);

    SfdcConnectionContext result = retrieveContext(eConnection);
    if (null == result) {
      LoginResult loginResult = login(eConnection, eConfig);
      MetadataConnection mConnection = createMetadataConnection(loginResult);

      result = new SfdcConnectionContext(eConnection, mConnection);
    }
    return result;
  }

  private SfdcConnectionContext retrieveContext(EnterpriseConnection eConnection)
    throws ConnectionException
  {
    String session = task.getProject().getProperty(PROJECT_PROPERTY_SFDC_SESSION);
    if (StringUtils.isNotEmpty(session)) {

      String[] tokens = session.split("\\|");
      if (null != tokens && 3 == tokens.length) {
        String serviceEndpointUrl = tokens[0];
        String metadataServerUrl = tokens[1];
        String sessionId = tokens[2];

        eConnection.setSessionHeader(sessionId);
        eConnection.getConfig().setServiceEndpoint(serviceEndpointUrl);

        LoginResult loginResult = new LoginResult();
        loginResult.setMetadataServerUrl(metadataServerUrl);
        loginResult.setSessionId(sessionId);

        MetadataConnection mConnection = createMetadataConnection(loginResult);

        return new SfdcConnectionContext(eConnection, mConnection);
      }
    }
    return null;
  }

  private ConnectorConfig createConnectorConfig()
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

    String sessionInfo =
        String.format("%s|%s|%s",
                      loginResult.getServerUrl(),
                      loginResult.getMetadataServerUrl(),
                      loginResult.getSessionId());
    task.getProject().setProperty(PROJECT_PROPERTY_SFDC_SESSION, sessionInfo);

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

  private Map<String, List<FileProperties>> listMetadata(final MetadataConnection mConnection,
                                                         DescribeMetadataObject object)
    throws ConnectionException
  {
    final String name = object.getXmlName();

    Map<String, List<FileProperties>> filePropertiesMap = new HashMap<>();
    if (0 < object.getChildXmlNames().length && !noChildHandling.contains(name)) {

      // TODO logWrapper.log(String.format("Children: %s", StringUtils.join(object.getChildXmlNames(), ", ")));

      ChunkedExecutor<String, Map<String, List<FileProperties>>, ConnectionException> childCE =
          new ChunkedExecutor<String, Map<String, List<FileProperties>>, ConnectionException>() {

            @Override
            public Map<String, List<FileProperties>> chunky(List<String> chunk, Map<String, List<FileProperties>> map)
              throws ConnectionException
            {
              List<ListMetadataQuery> queries = new ArrayList<>();
              for (String child : chunk) {
                ListMetadataQuery query = new ListMetadataQuery();
                query.setType(child);
                queries.add(query);
              }

              // TODO logWrapper.log(String.format("List: %s", StringUtils.join(chunk, ",")));

              FileProperties[] metadata =
                  mConnection.listMetadata(queries.toArray(new ListMetadataQuery[queries.size()]), VERSION);
              for (FileProperties props : metadata) {
                List<FileProperties> list = map.get(props.getType());
                if (null == list) {
                  list = new ArrayList<>();
                  map.put(props.getType(), list);
                }
                list.add(props);
              }
              return map;
            }

          };
      childCE.execute(Arrays.asList(object.getChildXmlNames()), 3, filePropertiesMap);
    }
    else {
      if (object.isInFolder()) {
        // folder objects
        Map<String, String> replacements = new HashMap<>();
        replacements.put("Document", "DocumentFolder");
        replacements.put("EmailTemplate", "EmailFolder");
        replacements.put("Dashboard", "DashboardFolder");
        replacements.put("Report", "ReportFolder");

        ListMetadataQuery query = new ListMetadataQuery();
        query.setType(replacements.get(object.getXmlName()));
        FileProperties[] folderFileProperties = mConnection.listMetadata(new ListMetadataQuery[]{ query }, VERSION);

        ChunkedExecutor<FileProperties, List<FileProperties>, ConnectionException> folderCE =
            new ChunkedExecutor<FileProperties, List<FileProperties>, ConnectionException>() {

              @Override
              public List<FileProperties> chunky(List<FileProperties> chunk, List<FileProperties> result)
                throws ConnectionException
              {
                List<ListMetadataQuery> queries = new ArrayList<>();
                List<String> elements = new ArrayList<>();
                for (FileProperties fileProperties : chunk) {
                  ListMetadataQuery fQuery = new ListMetadataQuery();
                  fQuery.setType(name);
                  fQuery.setFolder(fileProperties.getFullName());
                  queries.add(fQuery);
                  elements.add(fileProperties.getFullName());
                }

                // TODO logWrapper.log(String.format("List: %s.[%s]", name, StringUtils.join(elements, ",")));

                result.addAll(Arrays.asList(mConnection.listMetadata(queries.toArray(new ListMetadataQuery[queries.size()]),
                                                                     VERSION)));

                return result;
              }
            };
        List<FileProperties> fileList =
            folderCE.execute(Arrays.asList(folderFileProperties), 3, new ArrayList<FileProperties>());

        // add the folders itself
        fileList.addAll(0, Arrays.asList(folderFileProperties));

        filePropertiesMap.put(name, fileList);
      }
      else {
        // regular metadata category
        ListMetadataQuery query = new ListMetadataQuery();
        query.setType(name);

        // TODO logWrapper.log(String.format("List: %s", name));

        filePropertiesMap.put(name, Arrays.asList(mConnection.listMetadata(new ListMetadataQuery[]{ query }, VERSION)));
      }
    }
    return filePropertiesMap;
  }

  public ByteArrayOutputStream retrieveMetadata(Map<String, List<String>> metadata)
  {
    ByteArrayOutputStream result = null;

    try {
      SfdcConnectionContext context = login();

      List<PackageTypeMembers> types = new ArrayList<>();
      for (Map.Entry<String, List<String>> entry : metadata.entrySet()) {
        PackageTypeMembers type = new PackageTypeMembers();
        type.setName(entry.getKey());
        type.setMembers(entry.getValue().toArray(new String[entry.getValue().size()]));
        types.add(type);
      }

      Package unpackaged = new Package();
      unpackaged.setTypes(types.toArray(new PackageTypeMembers[types.size()]));

      RetrieveRequest retrieveRequest = new RetrieveRequest();
      retrieveRequest.setApiVersion(VERSION);
      retrieveRequest.setUnpackaged(unpackaged);

      AsyncResult ar = context.getMConnection().retrieve(retrieveRequest);

      int count = 0;
      RetrieveResult status = null;
      do {

        task.log(String.format("Wait for job %s to finish...", ar.getId()));

        try {
          Thread.sleep(3000);
        }
        catch (InterruptedException e) {
          task.log(String.format("Got interrupted while sleeping for retrieval result: %s.", e.getMessage()));
        }
        status = context.getMConnection().checkRetrieveStatus(ar.getId());

        count++;
      }
      while (!status.isDone() && count < maxPoll);

      if (status.isDone()) {
        if (status.isSuccess()) {

          Set<String> keys = metadata.keySet();
          task.log(String.format("Retrieval of %s successful.",
                                 StringUtils.join(keys.toArray(new String[keys.size()]), ",")));

          try {
            result = new ByteArrayOutputStream();
            result.write(status.getZipFile());
            result.close();
          }
          catch (IOException e) {
            throw new BuildException(String.format("Error processing result: %s.", e.getMessage()), e);
          }
        }
        else {
          task.log(String.format("Error %s: %s.",
                                 null != status.getErrorStatusCode()
                                                                    ? status.getErrorStatusCode().toString()
                                                                    : "<null>",
                                 status.getErrorMessage()), LogLevel.ERR.getLevel());

          throw new BuildException(String.format("Deployment of %s not successful.",
                                                 Arrays.toString(types.toArray(new String[0]))));
        }
      }

      return result;
    }
    catch (ConnectionException e) {
      throw new BuildException(String.format("Error connecting to SFDC: %s.", e.getMessage()), e);
    }
  }

  public Map<String, Map<String, Long>> getUpdateStamps(Set<String> objects)
  {
    Map<String, Map<String, Long>> result = new HashMap<>();

    task.log("Get update stamps.");

    try {
      SfdcConnectionContext context = login();

      DescribeMetadataResult describeMetadata = context.getMConnection().describeMetadata(VERSION);
      for (DescribeMetadataObject object : describeMetadata.getMetadataObjects()) {
        // only consider specified objects
        if (!objects.contains(object.getXmlName())) {
          continue;
        }

        // TODO logWrapper.log(String.format("Type: %s", object.getXmlName()));

        Map<String, List<FileProperties>> filePropertiesMap = listMetadata(context.getMConnection(), object);

        for (Map.Entry<String, List<FileProperties>> entry : filePropertiesMap.entrySet()) {
          Map<String, Long> entryMap = new HashMap<>();
          for (FileProperties properties : entry.getValue()) {
            entryMap.put(properties.getFullName(), properties.getLastModifiedDate().getTimeInMillis());
          }
          result.put(entry.getKey(), entryMap);
        }
      }

      return result;
    }
    catch (ConnectionException e) {
      throw new BuildException(String.format("Error Connecting to SFDC: %s.", e.getMessage()), e);
    }
  }

  public Map<String, String> retrieveChecksums()
  {
    try {
      SfdcConnectionContext context = login();

      ReadResult readResult = context.getMConnection().readMetadata("StaticResource", new String[]{ "checksums.txt" });

      Metadata[] mdInfo = readResult.getRecords();

      Map<String, String> map = new HashMap<>();
      if (0 == mdInfo.length || null == mdInfo[0]) {
        task.log("Did not find checksums in SFDC.", LogLevel.WARN.getLevel());
      }
      else {
        task.log("Retrieved checksum from SFDC.");

        StaticResource checksums = (StaticResource)mdInfo[0];
        String content = new String(checksums.getContent(), "UTF-8");

        try (StringReader sr = new StringReader(content); BufferedReader br = new BufferedReader(sr)) {
          String line = null;
          do {
            line = br.readLine();
            if (null != line) {
              String[] tokens = line.split(":");
              if (2 == tokens.length) {
                map.put(tokens[0], tokens[1]);
              }
            }
          }
          while (line != null);
        }
      }
      return map;
    }
    catch (IOException | ConnectionException e) {
      throw new BuildException(String.format("Error retrieving checksums from SFDC: %s.", e.getMessage()), e);
    }
  }

  public void deployChecksums(Map<String, String> checksumMap)
  {
    try {
      SfdcConnectionContext context = login();

      ByteArrayOutputStream baos = new ByteArrayOutputStream();
      for (Map.Entry<String, String> entry : checksumMap.entrySet()) {
        baos.write(String.format("%s:%s\n", entry.getKey(), entry.getValue()).getBytes("UTF-8"));
      }
      byte[] content = baos.toByteArray();

      StaticResource sr = new StaticResource();
      sr.setCacheControl(StaticResourceCacheControl.Private);
      sr.setContent(content);
      sr.setContentType("text/plain");
      sr.setFullName("checksums.txt");
      sr.setDescription("Checksums of all deployed metadata.");

      UpsertResult[] results = context.getMConnection().upsertMetadata(new Metadata[]{ sr });

      for (UpsertResult r : results) {
        if (r.isSuccess()) {
          if (r.isCreated()) {
            task.log("Created checksums in SFDC.");
          }
          else {
            task.log("Updated checksums in SFDC.");
          }
        }
        else {
          for (com.sforce.soap.metadata.Error e : r.getErrors()) {
            task.log(String.format("Error %d during checksum deployment: %s.", e.getStatusCode(), e.getMessage()));
          }

          throw new BuildException("Error deploying checksums to SFDC.");
        }
      }
    }
    catch (IOException | ConnectionException e) {
      throw new BuildException(String.format("Error retrieving checksums from SFDC: %s.", e.getMessage()), e);
    }
  }
}
