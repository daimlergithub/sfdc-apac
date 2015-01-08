/*
 * Daimler CRM - Extension Platform
 */
package backup;


import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

import com.sforce.soap.enterprise.EnterpriseConnection;
import com.sforce.soap.enterprise.LoginResult;
import com.sforce.soap.metadata.DescribeMetadataObject;
import com.sforce.soap.metadata.DescribeMetadataResult;
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
public class SfdcMetadataCreator
{

  private final static double VERSION = 32.0d;

  public static void main(String[] args)
    throws ConnectionException
  {
    boolean useProxy = false;
    
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

    System.out.println("Retrieving metadata...");

    // TODO document folders
    
    try {
      FileWriter fw = new FileWriter("src/backup/metadata.xml");
      BufferedWriter bw = new BufferedWriter(fw);

      bw.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
      bw.newLine();
      bw.write("<Package xmlns=\"http://soap.sforce.com/2006/04/metadata\">");
      bw.newLine();

      DescribeMetadataResult describeMetadata = mConnection.describeMetadata(VERSION);
      for (DescribeMetadataObject object: describeMetadata.getMetadataObjects()) {
        String name = object.getXmlName();

        bw.write("<types>");
        bw.newLine();

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

        //bw.write(("<members>" + fullName + "</members>\n").getBytes("UTF-8"));
        bw.write("<members>*</members>");
        bw.newLine();

        bw.write("<name>" + name + "</name>");
        bw.newLine();
        bw.write("</types>");
        bw.newLine();
      }

      bw.write("<version>32.0</version>");
      bw.newLine();
      bw.write("</Package>");
      bw.newLine();
      bw.close();
    }
    catch (IOException e) {
      System.err.println(String.format("Error creating metadata.xml: %s", e.getMessage()));
      e.printStackTrace(System.err);
    }
    
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

}
