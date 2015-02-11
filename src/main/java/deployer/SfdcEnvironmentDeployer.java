/*
 * Daimler CRM - Extension Platform
 */
package deployer;

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
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

import org.apache.commons.codec.binary.Base64OutputStream;

import com.sforce.soap.enterprise.EnterpriseConnection;
import com.sforce.soap.enterprise.LoginResult;
import com.sforce.soap.metadata.AsyncResult;
import com.sforce.soap.metadata.DeployOptions;
import com.sforce.soap.metadata.DeployResult;
import com.sforce.soap.metadata.MetadataConnection;
import com.sforce.ws.ConnectionException;
import com.sforce.ws.ConnectorConfig;

/**
 * Manual Steps:
 * 1. remove quick actions from layouts and delete quick actions:
 *    a) Task Layout: "UpdatePriority", "UpdateStatus", "Defer", "EditDescription"
 *    b) Case (Support) Layout: "NewChildCase"
 *    c) "NewGroupMember" ???  
 * 2. delete weblinks from layouts:
 *    a) WebLink.Case.UpsellCrosssellOpportunity (Case (Support) Layout)
 *    b) WebLink.Campaign.ViewCampaignInfluenceReport (Campaign Layout)
 *    c) WebLink.Account.Billing (Account (Support) Layout)
 *    d) WebLink.Opportunity.DeliveryStatus (Opportunity (Support) Layout)
 *    e) WebLink.EpAdapterUnitOfWork__c.Delete_Multiple (???)
 * # 3. remove button "Delete_Multiple" from search layout "Units of Work List View" of customer object "EpAdapterUnitOfWork__c"
 * 
 * @author  xlehmf
 */
public class SfdcEnvironmentDeployer
{

  private final static double VERSION = 32.0d;

  private static List<DeploymentUnit> duList = new DeploymentConfiguration().getConfigurations();

  public static void main(String[] args)
    throws ConnectionException
  {

    boolean useProxy = true;
    
    ConnectorConfig eConfig = new ConnectorConfig();
    eConfig.setAuthEndpoint("https://login.salesforce.com/services/Soap/c/32.0");
    eConfig.setServiceEndpoint(eConfig.getAuthEndpoint());
    eConfig.setUsername("falk@falk-lehmann.sfdc-kernel.dev");
    eConfig.setPassword("fl3sfdc1v2CKwwefnIZXDt5P9hxIcB4k");
    if (useProxy) {
      eConfig.setProxy("141.77.17.155", 8080);
    }
    eConfig.setManualLogin(true);

    EnterpriseConnection eConnection = new EnterpriseConnection(eConfig);
    LoginResult loginResult = eConnection.login(eConfig.getUsername(), eConfig.getPassword());
    eConfig.setServiceEndpoint(loginResult.getServerUrl());

    eConnection.setSessionHeader(loginResult.getSessionId());

    ConnectorConfig mConfig = new ConnectorConfig();
    mConfig.setServiceEndpoint(loginResult.getMetadataServerUrl());
    mConfig.setSessionId(loginResult.getSessionId());
    if (useProxy) {
      mConfig.setProxy("141.77.17.155", 8080);
    }

    MetadataConnection mConnection = new MetadataConnection(mConfig);

    // the list is still in the order for deletion => reverse for deployment
    Collections.reverse(duList);

    System.out.println("Updating metadata...");

    boolean stop = false;

    File baseDir = new File("src/main/metadata");

    Map<String, Long> updateStamps = readUpdateStamps();

    printUpdatestamps(updateStamps);

    for (final DeploymentUnit du : duList) {

      stop = deployType(mConnection, baseDir, du, updateStamps);

      writeUpdateStampes(updateStamps);

      if (stop) {
        break;
      }
    }

    printUpdatestamps(updateStamps);

    //    DescribeMetadataResult describeMetadata = mConnection.describeMetadata(VERSION);
    //    for (DescribeMetadataObject object: describeMetadata.getMetadataObjects()) {
    //      String name = object.getXmlName();
    //      
    //      if (null != object.getChildXmlNames() && 0 < object.getChildXmlNames().length) {
    //        for (String child : object.getChildXmlNames()) {
    //          String fullName = name + "." + child;
    //          
    //          System.out.println(String.format("Folder: %s Name: %s", object.getDirectoryName(), fullName));
    //          
    //          metaSet.add(fullName);
    //          metaMap.put(fullName, object);
    //        }
    //      } else {
    //        System.out.println(String.format("Folder: %s Name: %s", object.getDirectoryName(), name));
    //        
    //        metaSet.add(name);
    //        metaMap.put(name, object);
    //      }
    //    }
    //    
    //    System.out.println();
    //    System.out.println("Checking metadata...");
    //    
    //    for (DeploymentUnit du : duList) {
    //      if (!metaSet.remove(du.getType())) {
    //        System.out.println(String.format("Deployment unit %s will not be used.", du.getType()));
    //      }
    //    }
    //    
    //    boolean stop = false;
    //    
    //    // make sure we have a deployment unit for each metadata type
    //    for (String meta : metaSet) {
    //        System.err.println(String.format("No deployment unit definition found for %s", meta));
    //        stop = true;
    //    }
    //    
    //    System.out.println();
    //    System.out.println("Checking children and delete metadata...");
    //
    //    if (!stop) {
    //      deleteEverything(mConnection, metaMap);
    //    }

    eConnection.logout();
  }

  private static void printUpdatestamps(Map<String, Long> updateStamps)
  {
    System.out.println("Update stamps:");
    for (Map.Entry<String, Long> entry : updateStamps.entrySet()) {
      System.out.println(String.format("%s: %d", entry.getKey(), entry.getValue()));
    }
  }

  private static void writeUpdateStampes(Map<String, Long> updateStamps)
  {
    try {
      FileWriter fw = new FileWriter("timestamps");
      BufferedWriter bw = new BufferedWriter(fw);

      for (Map.Entry<String, Long> entry : updateStamps.entrySet()) {
        bw.write(String.format("%s:%d", entry.getKey(), entry.getValue()));
        bw.newLine();
      }

      bw.close();
    }
    catch (IOException e) {
      System.out.println(String.format("Error saving update stamps."));
    }
  }

  private static Map<String, Long> readUpdateStamps()
  {
    Map<String, Long> result = new HashMap<>();

    try {
      FileReader fr = new FileReader("timestamps");
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
      System.out.println(String.format("Error reading update stamps."));
    }
    return result;
  }

  private static boolean deployType(MetadataConnection mConnection,
                                    File baseDir,
                                    final DeploymentUnit du,
                                    Map<String, Long> updateStamps)
    throws ConnectionException
  {
    String type = du.getTypeName();

    System.out.println(String.format("Deploying metadata for type %s...", type));

    List<File> fileList = du.getFiles(baseDir);

    if (fileList.isEmpty()) {
      System.out.println(String.format("Nothing to deploy for %s.", type));
      return false;
    }

    // we need the list to keep the order of the files
    Set<String> entitySet = new HashSet<>();
    List<String> entityNames = new ArrayList<>();
    for (File file : fileList) {
      String fullName = du.getEntityName(file);
      if (!entitySet.contains(fullName)) {
        entitySet.add(fullName);
        entityNames.add(fullName);
      }
    }

    long lastModified = getLatestModifiedStamp(fileList);

    Long updateStamp = updateStamps.get(type);

    System.out.println(String.format("Checking update stamps...update stamp: %d last modified: %d.",
                                     updateStamp,
                                     lastModified));

    if (null != updateStamp && updateStamp >= lastModified) {
      System.out.println(String.format("Not updating type %s because it is up-to-date (update stamp: %d last modified: %d).",
                                       type,
                                       updateStamp,
                                       lastModified));
      return false;
    }

    ByteArrayOutputStream baos = new ByteArrayOutputStream();

    Base64OutputStream b64os = new Base64OutputStream(baos);

    try {
      ZipOutputStream zos = new ZipOutputStream(baos);

      byte[] buffer = new byte[512];

      for (File file : fileList) {
        String fileName = file.getName();

        System.out.println(String.format("Adding file %s for type %s to ZIP file...", fileName, type));

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
          System.err.println(String.format("Error reading metadata for type %s and file %s: %s",
                                           type,
                                           fileName,
                                           e.getMessage()));
          e.printStackTrace(System.err);

          // stop
          return true;
        }
      }

      zos.putNextEntry(new ZipEntry("unpackaged/package.xml"));
      zos.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n".getBytes("UTF-8"));
      zos.write("<Package xmlns=\"http://soap.sforce.com/2006/04/metadata\">\n".getBytes("UTF-8"));
      //zos.write("<fullName>cleanup</fullName>".getBytes("UTF-8"));
      zos.write("<types>\n".getBytes("UTF-8"));
      for (String fullName : entityNames) {
        zos.write(("<members>" + fullName + "</members>\n").getBytes("UTF-8"));
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
      System.err.println(String.format("Error preparing ZIP for deployment: %s.", e.getMessage()));

      // stop processing
      return true;
    }

    System.out.println(String.format("Starting deployment of type %s...", type));

    DeployOptions options = new DeployOptions();
    options.setPerformRetrieve(false);
    options.setRollbackOnError(true);

    AsyncResult ar = mConnection.deploy(baos.toByteArray(), options);

    // debugging
    try {
      File tmp = new File("tmp", "deploy-" + System.currentTimeMillis() + ".zip");
      FileOutputStream fos = new FileOutputStream(tmp);
      fos.write(baos.toByteArray());
      fos.close();
    }
    catch (IOException e) {
      System.err.println(String.format("Error preparing ZIP for deployment: %s.", e.getMessage()));
    }

    int count = 0;
    DeployResult status = null;
    do {

      System.out.println(String.format("Waiting for job %s to finish...", ar.getId()));

      try {
        Thread.sleep(3000);
      }
      catch (InterruptedException e) {
        System.err.println(String.format("Got interrupted while sleeping for deployment result: %s.", e.getMessage()));
      }
      status = mConnection.checkDeployStatus(ar.getId(), true);

      count++;
    }
    while (!status.isDone() && count < 100);

    if (status.isDone()) {
      if (status.isSuccess()) {
        System.out.println(String.format("Deploying of %s and %s successful.",
                                         type,
                                         Arrays.toString(entityNames.toArray(new String[entityNames.size()]))));

        updateStamps.put(type, lastModified);
      }
      else {
        System.err.println(String.format("Deploying of %s and %s not successful.",
                                         type,
                                         Arrays.toString(entityNames.toArray(new String[entityNames.size()]))));
        System.err.println(String.format("Error %s: %s.",
                                         null != status.getErrorStatusCode()
                                                                            ? status.getErrorStatusCode().toString()
                                                                            : "<null>",
                                         status.getErrorMessage()));

        // stop processing
        return true;
      }
    }

    return false;
  }

  private static long getLatestModifiedStamp(List<File> fullFileList)
  {
    long lastModified = Long.MIN_VALUE;

    for (File file : fullFileList) {
      lastModified = Math.max(lastModified, file.lastModified());
    }

    return lastModified;
  }

}
