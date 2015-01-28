/*
 * Daimler CRM - Extension Platform
 */
package task.handler;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.apache.tools.ant.BuildException;
import org.apache.tools.ant.types.LogLevel;

import com.sforce.soap.enterprise.EnterpriseConnection;
import com.sforce.soap.enterprise.LoginResult;
import com.sforce.soap.metadata.AsyncResult;
import com.sforce.soap.metadata.DeployOptions;
import com.sforce.soap.metadata.DeployResult;
import com.sforce.soap.metadata.DescribeMetadataObject;
import com.sforce.soap.metadata.DescribeMetadataResult;
import com.sforce.soap.metadata.FileProperties;
import com.sforce.soap.metadata.ListMetadataQuery;
import com.sforce.soap.metadata.MetadataConnection;
import com.sforce.soap.metadata.Package;
import com.sforce.soap.metadata.PackageTypeMembers;
import com.sforce.soap.metadata.RetrieveRequest;
import com.sforce.soap.metadata.RetrieveResult;
import com.sforce.ws.ConnectionException;
import com.sforce.ws.ConnectorConfig;

import deployer.DeploymentUnit;

/**
 * SfdcHandler
 *
 * @author  XLEHMF
 */
public class SfdcHandler
{

  private final static double VERSION = 32.0d;
  private final Set<String> noChildHandling = new HashSet<>();

  private LogWrapper logWrapper;
  private int maxPoll;
  private boolean dryRun;
  private String serverurl;
  private String username;
  private String password;
  private boolean useProxy;
  private String proxyHost;
  private int proxyPort;
  private UpdateStampHandler updateStampHandler;

  public SfdcHandler()
  {
    noChildHandling.add("CustomObject");
    // noChildHandling.add("CustomLabels");
    noChildHandling.add("Workflow");
  }

  public void initialize(LogWrapper logWrapper,
                         int maxPoll,
                         boolean dryRun,
                         String serverurl,
                         String username,
                         String password,
                         boolean useProxy,
                         String proxyHost,
                         int proxyPort,
                         UpdateStampHandler updateStampHandler)
  {
    this.logWrapper = logWrapper;
    this.maxPoll = maxPoll;
    this.dryRun = dryRun;
    this.serverurl = serverurl;
    this.username = username;
    this.password = password;
    this.useProxy = useProxy;
    this.proxyHost = proxyHost;
    this.proxyPort = proxyPort;
    this.updateStampHandler = updateStampHandler;
  }

  public void validate()
  {
    if (null == logWrapper || null == updateStampHandler || null == serverurl || null == username || null == password) {
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

      logWrapper.log(String.format("Start deployment of ZIP."));

      DeployOptions options = new DeployOptions();
      options.setPerformRetrieve(false);
      options.setRollbackOnError(true);

      AsyncResult ar = context.getMConnection().deploy(zipFile.toByteArray(), options);

      int count = 0;
      DeployResult status = null;
      do {

        logWrapper.log(String.format("Wait for job %s to finish...", ar.getId()));

        try {
          Thread.sleep(3000);
        }
        catch (InterruptedException e) {
          logWrapper.log(String.format("Got interrupted while sleeping for deployment result: %s.", e.getMessage()));
        }
        status = context.getMConnection().checkDeployStatus(ar.getId(), true);

        count++;
      }
      while (!status.isDone() && count < maxPoll);

      if (status.isDone()) {
        if (status.isSuccess()) {
          for (DeploymentInfo info : infos) {
            DeploymentUnit du = info.getDeploymentUnit();

            logWrapper.log(String.format("Deployment of %s and %s successful.",
                                         du.getType().getSimpleName(),
                                         Arrays.toString(info.getEntityNames().toArray(new String[0]))));
          }
          updateStampHandler.updateTimestamp(infos);
        }
        else {
          logWrapper.log(String.format("Error %s: %s.",
                                       null != status.getErrorStatusCode()
                                                                          ? status.getErrorStatusCode().toString()
                                                                          : "<null>",
                                       status.getErrorMessage()), LogLevel.ERR.getLevel());

          List<String> types = new ArrayList<>();
          for (DeploymentInfo info : infos) {
            types.add(info.getDeploymentUnit().getType().getSimpleName());
          }

          throw new BuildException(String.format("Deployment of %s not successful.",
                                                 Arrays.toString(types.toArray(new String[0]))));
        }
      }

      context.getEConnection().logout();

      return result;
    }
    catch (ConnectionException e) {
      throw new BuildException(String.format("Error Connecting to SFDC: %s.", e.getMessage()), e);
    }
  }

  private SfdcConnectionContext login()
    throws ConnectionException
  {
    ConnectorConfig eConfig = createConnectorConfig();
    EnterpriseConnection eConnection = new EnterpriseConnection(eConfig);

    LoginResult loginResult = login(eConnection, eConfig);
    MetadataConnection mConnection = createMetadataConnection(loginResult);

    return new SfdcConnectionContext(eConnection, mConnection);
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

  // TODO seems similar to #getUpdateStamps
  public Map<String, List<String>> extractMetadata(Set<String> objects)
  {
    Map<String, List<String>> result = new HashMap<>();

    logWrapper.log("Collect available metadata.");
    
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

        result.putAll(filterOutExcludes(filePropertiesMap));
      }
      context.getEConnection().logout();

      return result;
    }
    catch (ConnectionException e) {

      e.printStackTrace();

      throw new BuildException(String.format("Error Connecting to SFDC: %s.", e.getMessage()), e);
    }
  }

  private Map<String, List<String>> filterOutExcludes(Map<String, List<FileProperties>> filePropertiesMap)
  {
    Map<String, List<String>> result = new HashMap<>();

    for (Map.Entry<String, List<FileProperties>> entry : filePropertiesMap.entrySet()) {
      String name = entry.getKey();

      List<String> fullNames = new ArrayList<>();
      for (FileProperties properties : entry.getValue()) {
        boolean toExclude = false;
        // TODO fix child filtering
        //        String qualifiedName = String.format("%s/%s", name, properties.getFullName());
        //        for (String exclude : excludes) {
        //          if (qualifiedName.matches(exclude)) {
        //            toExclude = true;
        //            break;
        //          }
        //        }
        if (toExclude) {
          logWrapper.log(String.format("Filtered out: %s Objects: %s", name, properties.getFullName()));
        }
        else {
          fullNames.add(properties.getFullName());
        }
      }

      if (!fullNames.isEmpty()) {
        result.put(name, fullNames);
      }

    }
    return result;
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
                  list = new ArrayList<FileProperties>();
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
                  ListMetadataQuery query = new ListMetadataQuery();
                  query.setType(name);
                  query.setFolder(fileProperties.getFullName());
                  queries.add(query);
                  
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

        logWrapper.log(String.format("Wait for job %s to finish...", ar.getId()));

        try {
          Thread.sleep(3000);
        }
        catch (InterruptedException e) {
          logWrapper.log(String.format("Got interrupted while sleeping for retrieval result: %s.", e.getMessage()));
        }
        status = context.getMConnection().checkRetrieveStatus(ar.getId());

        count++;
      }
      while (!status.isDone() && count < maxPoll);

      if (status.isDone()) {
        if (status.isSuccess()) {
          
          Set<String> keys = metadata.keySet();
          logWrapper.log(String.format("Retrieval of %s successful.", StringUtils.join(keys.toArray(new String[keys.size()]), ",")));
          
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
          logWrapper.log(String.format("Error %s: %s.",
                                       null != status.getErrorStatusCode()
                                                                          ? status.getErrorStatusCode().toString()
                                                                          : "<null>",
                                       status.getErrorMessage()), LogLevel.ERR.getLevel());

          throw new BuildException(String.format("Deployment of %s not successful.",
                                                 Arrays.toString(types.toArray(new String[0]))));
        }
      }

      context.getEConnection().logout();

      return result;
    }
    catch (ConnectionException e) {
      throw new BuildException(String.format("Error connecting to SFDC: %s.", e.getMessage()), e);
    }
  }

  // TODO seems similar to #extractMetadata
  public Map<String, Long> getUpdateStamps(Set<String> objects)
  {
    Map<String, Long> result = new HashMap<>();

    logWrapper.log("Get update stamps.");
    
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
          for (FileProperties properties : entry.getValue()) {
            // TODO logWrapper.log(properties.toString());
            
            result.put(String.format("%s/%s", entry.getKey(), properties.getFullName()), properties.getLastModifiedDate().getTimeInMillis());
          }
        }
      }
      context.getEConnection().logout();

      return result;
    }
    catch (ConnectionException e) {

      e.printStackTrace();

      throw new BuildException(String.format("Error Connecting to SFDC: %s.", e.getMessage()), e);
    }
  }
}
