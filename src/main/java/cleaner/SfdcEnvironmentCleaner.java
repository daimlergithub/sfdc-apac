package cleaner;
/*
 *  Daimler CRM - Extension Platform
 */
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.sforce.soap.enterprise.EnterpriseConnection;
import com.sforce.soap.enterprise.LoginResult;
import com.sforce.soap.metadata.DescribeMetadataObject;
import com.sforce.soap.metadata.DescribeMetadataResult;
import com.sforce.soap.metadata.FileProperties;
import com.sforce.soap.metadata.ListMetadataQuery;
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
public class SfdcEnvironmentCleaner
{

  private final static double VERSION = 32.0d;
  
  private static List<DeploymentUnit> duList = new ArrayList<>();
  
  private static void setup()
  {
    duList.add(new DeploymentUnit("InstalledPackage"));
    
    duList.add(new DeploymentUnit("EscalationRules.EscalationRule"));
    duList.add(new DeploymentUnit("AssignmentRules.AssignmentRule"));
    
    // sharing rules
    duList.add(new DeploymentUnit("CustomObjectSharingRules.CustomObjectOwnerSharingRule"));
    duList.add(new DeploymentUnit("CustomObjectSharingRules.CustomObjectCriteriaBasedSharingRule"));
    duList.add(new DeploymentUnit("CustomObjectSharingRules"));
    duList.add(new DeploymentUnit("CampaignSharingRules.CampaignCriteriaBasedSharingRule"));
    duList.add(new DeploymentUnit("CampaignSharingRules.CampaignOwnerSharingRule"));
    duList.add(new DeploymentUnit("CampaignSharingRules"));
    duList.add(new DeploymentUnit("UserSharingRules.UserMembershipSharingRule"));
    duList.add(new DeploymentUnit("UserSharingRules.UserCriteriaBasedSharingRule"));
    duList.add(new DeploymentUnit("UserSharingRules"));
    duList.add(new DeploymentUnit("ContactSharingRules.ContactOwnerSharingRule"));
    duList.add(new DeploymentUnit("ContactSharingRules.ContactCriteriaBasedSharingRule"));
    duList.add(new DeploymentUnit("ContactSharingRules"));
    duList.add(new DeploymentUnit("CaseSharingRules.CaseOwnerSharingRule"));
    duList.add(new DeploymentUnit("CaseSharingRules.CaseCriteriaBasedSharingRule"));
    duList.add(new DeploymentUnit("CaseSharingRules"));
    duList.add(new DeploymentUnit("OpportunitySharingRules.OpportunityOwnerSharingRule"));
    duList.add(new DeploymentUnit("OpportunitySharingRules.OpportunityCriteriaBasedSharingRule"));
    duList.add(new DeploymentUnit("OpportunitySharingRules"));
    duList.add(new DeploymentUnit("LeadSharingRules.LeadCriteriaBasedSharingRule"));
    duList.add(new DeploymentUnit("LeadSharingRules.LeadOwnerSharingRule"));
    duList.add(new DeploymentUnit("LeadSharingRules"));
    duList.add(new DeploymentUnit("AccountSharingRules.AccountCriteriaBasedSharingRule"));
    duList.add(new DeploymentUnit("AccountSharingRules.AccountOwnerSharingRule"));
    duList.add(new DeploymentUnit("AccountSharingRules"));
    
    duList.add(new DeploymentUnit("Workflow.WorkflowRule"));
    duList.add(new DeploymentUnit("Workflow.WorkflowAlert"));
    duList.add(new DeploymentUnit("Workflow.WorkflowFieldUpdate"));
    duList.add(new DeploymentUnit("Workflow.WorkflowOutboundMessage"));
    duList.add(new DeploymentUnit("Workflow.WorkflowKnowledgePublish"));
    duList.add(new DeploymentUnit("Workflow.WorkflowSend"));
    duList.add(new DeploymentUnit("Workflow.WorkflowTask"));
    duList.add(new DeploymentUnit("Workflow"));
    
    duList.add(new DeploymentUnit4Layout("Layout") {

      @Override
      public boolean include(String name)
      {
        // exclude layout "SocialPost-Social Post Layout"
        return !"SocialPost-Social Post Layout".equals(name);
      }
      
    });
    
    duList.add(new DeploymentUnit("QuickAction") {

      private Set<String> excludes = new HashSet<>(Arrays.asList("Defer", "UpdatePriority", "EditDescription", "NewGroupMember", "NewChildCase", "UpdateStatus"));
      
      @Override
      public boolean include(String name)
      {
        return !excludes.contains(name);
      }
      
    }); // -> Layout
    
    duList.add(new DeploymentUnit("CustomApplication") {

      @Override
      public boolean include(String name)
      {
        return !name.startsWith("standard__");
      }
      
    });
    duList.add(new DeploymentUnit("CustomTab"));
    
    duList.add(new DeploymentUnit("RemoteSiteSetting"));
    duList.add(new DeploymentUnitWithDestructiveChanges("ApexTrigger"));
    duList.add(new DeploymentUnit("ApexPage"));
    duList.add(new DeploymentUnit("ApexComponent"));
    duList.add(new DeploymentUnitWithDestructiveChanges("ApexClass"));
    duList.add(new DeploymentUnit("Profile") {

      // exclude standard profiles
      private Set<String> excludes = new HashSet<>(Arrays.asList("Silver Partner User", "Customer Portal Manager Standard", "Customer Community Plus Login User",
                                                                 "ReadOnly", "Customer Portal Manager Custom", "PlatformPortal", "ContractManager", "StandardAul",
                                                                 "HighVolumePortal", "MarketingProfile", "Cross Org Data Proxy User", "Force%2Ecom - Free User",
                                                                 "Chatter External User", "SolutionManager", "Admin", "Partner Community Login User", "Partner Community User",
                                                                 "Gold Partner User", "Standard", "Force%2Ecom - App Subscription User", "Customer Community User",
                                                                 "Partner App Subscription User", "Chatter Moderator User", "Chatter Free User", "Customer Community Plus User",
                                                                 "External Identity User", "Identity User", "Work%2Ecom Only User", "Customer Community Login User"));
      
      @Override
      public boolean include(String name)
      {
        return !excludes.contains(name);
      }
      
    });
    // need to be deleted from bottom up -> roles cannot be deleted if other roles report to it or users are assigned to that role
    duList.add(new DeploymentUnit("Role") {

      @Override
      public boolean include(String name)
      {
        return !"CEO".equals(name);
      }

      // the dependencies are in the metadata (parent role)
      private Map<String, String> hierarchy = createInversHierarchy();
      
      @Override
      public List<String> sortFullNames(List<String> fullNames)
      {
        Collections.sort(fullNames, new Comparator<String>() {

          @Override
          public int compare(String role1, String role2)
          {
            int depth1 = calculateDepth(role1, 0);
            int depth2 = calculateDepth(role2, 0);
            
            return Integer.compare(depth1, depth2);
          }

          private int calculateDepth(String role, int depth)
          {
            return (null != role) ? calculateDepth(hierarchy.get(role), depth) : depth;
          }
          
        });
        return fullNames;
      }

      private Map<String, String> createInversHierarchy()
      {
        Map<String, String> map = new HashMap<>();
        map.put("CFO", "CEO");
        map.put("COO", "CEO");
        map.put("SVPHumanResources", "CEO");
        map.put("SVPSalesMarketing", "CEO");
        map.put("SVPCustomerServiceSupport", "CEO");
        
        map.put("CustomerSupportInternational", "SVPCustomerServiceSupport");
        map.put("CustomerSupportNorthAmerica", "SVPCustomerServiceSupport");
        map.put("InstallationRepairServices", "SVPCustomerServiceSupport");
        
        map.put("VPInternationalSales", "SVPSalesMarketing");
        map.put("VPMarketing", "SVPSalesMarketing");
        map.put("VPNorthAmericanSales", "SVPSalesMarketing");
        
        map.put("DirectorChannelSales", "VPNorthAmericanSales");
        map.put("DirectorDirectSales", "VPNorthAmericanSales");
        
        map.put("MarketingTeam", "VPMarketing");
        
        map.put("ChannelSalesTeam", "DirectorChannelSales");
        
        map.put("EasternSalesTeam", "DirectorDirectSales");
        map.put("WesternSalesTeam", "DirectorDirectSales");
        return map;
      }
      
    });
    duList.add(new DeploymentUnit("Role") {

      @Override
      public boolean include(String name)
      {
        return "CEO".equals(name);
      }
    });
    
    duList.add(new DeploymentUnit("ExternalDataSource"));
    
    
    duList.add(new DeploymentUnit("CustomLabels.CustomLabel"));
    duList.add(new DeploymentUnit("CustomLabels"));
    
    duList.add(new DeploymentUnit("CustomObject.WebLink") {

      @Override
      public boolean include(String name)
      {
        // exclude weblinks of custom objects
        return !name.substring(0, name.indexOf(".")).endsWith("__c");
      }
      
    });
    
    // -> CustomObject.WebLink
    duList.add(new DeploymentUnit("CustomObject.CustomField") {

      @Override
      public boolean include(String name)
      {
        // exclude weblinks of custom objects -> Opportunity.MainCompetitors__c
        return !name.substring(0, name.indexOf(".")).endsWith("__c");
      }
    });
    duList.add(new DeploymentUnit("CustomObject.FieldSet"));
    duList.add(new DeploymentUnit("CustomObject.ValidationRule"));
    duList.add(new DeploymentUnit("CustomObject.SharingReason"));
    duList.add(new DeploymentUnit("CustomObject.CompactLayout"));
    duList.add(new DeploymentUnit("CustomObject.BusinessProcess"));
    duList.add(new DeploymentUnit("CustomObject.RecordType") {

      @Override
      public boolean include(String name)
      {
        // TODO check
        return !"Account.Company".equals(name);
      }
      
    });
    duList.add(new DeploymentUnit("CustomObject.ListView"));
    duList.add(new DeploymentUnit("CustomObject"));
    
    duList.add(new DeploymentUnit("Translations"));
    
    duList.add(new DeploymentUnit("CustomPageWebLink"));
    
    // TODO
    duList.add(new DeploymentUnit("Report"));
    duList.add(new DeploymentUnit("Flow"));
    duList.add(new DeploymentUnit("Document"));
    duList.add(new DeploymentUnit("Dashboard"));
    duList.add(new DeploymentUnit("Queue"));
    
    duList.add(new DeploymentUnit("AutoResponseRules.AutoResponseRule"));
    duList.add(new DeploymentUnit("AutoResponseRules"));
    duList.add(new DeploymentUnit("EmailTemplate"));
    
    duList.add(new DeploymentUnit("ManagedTopics.ManagedTopic"));
    duList.add(new DeploymentUnit("ManagedTopics"));
    
    duList.add(new DeploymentUnit("Settings", true));
    duList.add(new DeploymentUnit("XOrgHub", true));
    
    
    duList.add(new DeploymentUnit("Scontrol", true));
    duList.add(new DeploymentUnit("CustomPermission", true));
    duList.add(new DeploymentUnit("Network", true));
    duList.add(new DeploymentUnit("PostTemplate", true));
    duList.add(new DeploymentUnit("FlexiPage", true));
    duList.add(new DeploymentUnit("SiteDotCom", true));
    duList.add(new DeploymentUnit("CallCenter", true));
    duList.add(new DeploymentUnit("DataCategoryGroup", true));
    duList.add(new DeploymentUnit("AnalyticSnapshot", true));
    duList.add(new DeploymentUnit("PermissionSet", true));
    duList.add(new DeploymentUnit("CustomApplicationComponent", true));
    duList.add(new DeploymentUnit("Group", true));
    duList.add(new DeploymentUnit("SynonymDictionary", true));
    duList.add(new DeploymentUnit("SamlSsoConfig", true));
    duList.add(new DeploymentUnit("ConnectedApp", true));
    duList.add(new DeploymentUnit("UiPlugin", true));
    duList.add(new DeploymentUnit("Portal", true));
    duList.add(new DeploymentUnit("HomePageComponent", true));
    duList.add(new DeploymentUnit("ReportType", true));
    duList.add(new DeploymentUnit("Letterhead", true));
    duList.add(new DeploymentUnit("AppMenu", true));
    duList.add(new DeploymentUnit("HomePageLayout", true));
    duList.add(new DeploymentUnit("SharingSet", true));
    duList.add(new DeploymentUnit("StaticResource", true));
    duList.add(new DeploymentUnit("AuthProvider", true));
    duList.add(new DeploymentUnit("ApprovalProcess", true));
    duList.add(new DeploymentUnit("CustomSite", true));
    duList.add(new DeploymentUnit("CustomObjectTranslation", true));
    duList.add(new DeploymentUnit("Community", true));
  }
  
  public static void main(String[] args) throws ConnectionException
  {
    setup();
    
    ConnectorConfig eConfig = new ConnectorConfig();
    eConfig.setAuthEndpoint("https://login.salesforce.com/services/Soap/c/32.0");
    eConfig.setServiceEndpoint(eConfig.getAuthEndpoint());
    eConfig.setUsername("falk@falk-lehmann.sfdc-kernel.dev");
    eConfig.setPassword("fl3sfdc1v2CKwwefnIZXDt5P9hxIcB4k");
    eConfig.setProxy("141.77.17.155", 8080);
    eConfig.setManualLogin(true);
    
    EnterpriseConnection eConnection = new EnterpriseConnection(eConfig);
    LoginResult loginResult = eConnection.login(eConfig.getUsername(), eConfig.getPassword());
    eConfig.setServiceEndpoint(loginResult.getServerUrl());
    
    eConnection.setSessionHeader(loginResult.getSessionId());
    
    ConnectorConfig mConfig = new ConnectorConfig();
    mConfig.setServiceEndpoint(loginResult.getMetadataServerUrl());
    mConfig.setSessionId(loginResult.getSessionId());
    mConfig.setProxy("141.77.17.155", 8080);
    
    MetadataConnection mConnection = new MetadataConnection(mConfig);
    
    Set<String> metaSet = new HashSet<>();
    Map<String, DescribeMetadataObject> metaMap = new HashMap<>();
    
    // TODO do we need to handle parents?
    
    System.out.println("Analzying metadata...");
    
    DescribeMetadataResult describeMetadata = mConnection.describeMetadata(VERSION);
    for (DescribeMetadataObject object: describeMetadata.getMetadataObjects()) {
      String name = object.getXmlName();
      
      if (null != object.getChildXmlNames() && 0 < object.getChildXmlNames().length) {
        for (String child : object.getChildXmlNames()) {
          String fullName = name + "." + child;
          
          System.out.println(String.format("Folder: %s Name: %s", object.getDirectoryName(), fullName));
          
          metaSet.add(fullName);
          metaMap.put(fullName, object);
        }
      } else {
        System.out.println(String.format("Folder: %s Name: %s", object.getDirectoryName(), name));
        
        metaSet.add(name);
        metaMap.put(name, object);
      }
    }
    
    System.out.println();
    System.out.println("Checking metadata...");
    
    for (DeploymentUnit du : duList) {
      if (!metaSet.remove(du.getType())) {
        System.out.println(String.format("Deployment unit %s will not be used.", du.getType()));
      }
    }
    
    boolean stop = false;
    
    // make sure we have a deployment unit for each metadata type
    for (String meta : metaSet) {
        System.err.println(String.format("No deployment unit definition found for %s", meta));
        stop = true;
    }
    
    System.out.println();
    System.out.println("Checking children and delete metadata...");

    if (!stop) {
      deleteEverything(mConnection, metaMap);
    }
    
    eConnection.logout();
  }


  private static void deleteEverything(MetadataConnection mConnection,
                                       Map<String, DescribeMetadataObject> metaMap)
    throws ConnectionException
  {
    for (DeploymentUnit du : duList) {
      String name = du.getType();
      DescribeMetadataObject object = metaMap.get(name);
      
      if (null == object) {
        continue;
      }
      
      String folder = object.getInFolder() ? object.getDirectoryName() : null;
    
      System.out.println(String.format("Folder: %s Name: %s", folder, name));
      
      FileProperties[] fileProperties = null;
      
      // list metadata
      if (du.hasChild()) {
        ListMetadataQuery childQuery = new ListMetadataQuery(); 
        childQuery.setType(du.getChild());
        childQuery.setFolder(folder);
        
        fileProperties = mConnection.listMetadata(new ListMetadataQuery[]{childQuery}, VERSION);
        
        for (FileProperties childProperties : fileProperties) {
          System.out.println(String.format(" Child for %s: %s", du.getChild(), childProperties.getFullName()));
        }
      } else {
        ListMetadataQuery query = new ListMetadataQuery(); 
        query.setType(name);
        query.setFolder(folder);
        
        fileProperties = mConnection.listMetadata(new ListMetadataQuery[]{query}, VERSION);
        
        for (FileProperties properties : fileProperties) {
          System.out.println(String.format(" %s", properties.getFullName()));
        }
      }
      
      // now delete
      if (!du.isIgnoreUndeploy()) {
        if (du.hasChild()) {
            List<String> fullNames = new ArrayList<>();
            for (FileProperties childProperties : fileProperties) {
              if (du.include(childProperties.getFullName())) {
                fullNames.add(childProperties.getFullName());
              }
            }
            
            boolean stop = du.deleteMetadata(mConnection, du.getChild(), fullNames);
            if (stop) {
              break;
            }
        } else {
          List<String> fullNames = new ArrayList<>();
          for (FileProperties properties : fileProperties) {
            if (du.include(properties.getFullName())) {
              fullNames.add(properties.getFullName());
            }
          }
          boolean stop = du.deleteMetadata(mConnection, object.getXmlName(), fullNames);
          if (stop) {
            break;
          }
        }
      }
    }
  }
}

