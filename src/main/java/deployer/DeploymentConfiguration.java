/*
 * Daimler CRM - Extension Platform
 */
package deployer;

import java.util.ArrayList;
import java.util.List;

import com.sforce.soap.metadata.AccountSharingRules;
import com.sforce.soap.metadata.ApexClass;
import com.sforce.soap.metadata.ApexComponent;
import com.sforce.soap.metadata.ApexPage;
import com.sforce.soap.metadata.ApexTrigger;
import com.sforce.soap.metadata.AppMenu;
import com.sforce.soap.metadata.ApprovalProcess;
import com.sforce.soap.metadata.AssignmentRules;
import com.sforce.soap.metadata.AutoResponseRules;
import com.sforce.soap.metadata.CallCenter;
import com.sforce.soap.metadata.CampaignSharingRules;
import com.sforce.soap.metadata.CaseSharingRules;
import com.sforce.soap.metadata.Community;
import com.sforce.soap.metadata.CustomApplication;
import com.sforce.soap.metadata.CustomApplicationComponent;
import com.sforce.soap.metadata.CustomLabels;
import com.sforce.soap.metadata.CustomObject;
import com.sforce.soap.metadata.CustomObjectSharingRules;
import com.sforce.soap.metadata.CustomObjectTranslation;
import com.sforce.soap.metadata.CustomPageWebLink;
import com.sforce.soap.metadata.CustomTab;
import com.sforce.soap.metadata.Dashboard;
import com.sforce.soap.metadata.DataCategoryGroup;
import com.sforce.soap.metadata.Document;
import com.sforce.soap.metadata.EmailTemplate;
import com.sforce.soap.metadata.EscalationRules;
import com.sforce.soap.metadata.Flow;
import com.sforce.soap.metadata.Group;
import com.sforce.soap.metadata.HomePageComponent;
import com.sforce.soap.metadata.HomePageLayout;
import com.sforce.soap.metadata.Layout;
import com.sforce.soap.metadata.Letterhead;
import com.sforce.soap.metadata.Network;
import com.sforce.soap.metadata.PermissionSet;
import com.sforce.soap.metadata.Portal;
import com.sforce.soap.metadata.Profile;
import com.sforce.soap.metadata.Queue;
import com.sforce.soap.metadata.QuickAction;
import com.sforce.soap.metadata.RemoteSiteSetting;
import com.sforce.soap.metadata.Report;
import com.sforce.soap.metadata.ReportType;
import com.sforce.soap.metadata.Role;
import com.sforce.soap.metadata.SamlSsoConfig;
import com.sforce.soap.metadata.StaticResource;
import com.sforce.soap.metadata.SynonymDictionary;
import com.sforce.soap.metadata.Translations;
import com.sforce.soap.metadata.Workflow;

import deployer.custom.Settings;

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
public class DeploymentConfiguration
{

  public List<DeploymentUnit> getConfigurations()
  {
    List<DeploymentUnit> duList = new ArrayList<>();
    duList.add(new DeploymentUnit(ApprovalProcess.class, "approvalProcesses"));

    // TODO duList.add(new DeploymentUnit("InstalledPackage"));

    duList.add(new DeploymentUnit(EscalationRules.class));
    duList.add(new DeploymentUnit(AssignmentRules.class));

    // sharing rules
    //    duList.add(new DeploymentUnit("CustomObjectSharingRules.CustomObjectOwnerSharingRule"));
    //    duList.add(new DeploymentUnit("CustomObjectSharingRules.CustomObjectCriteriaBasedSharingRule"));
    duList.add(new DeploymentUnit(CustomObjectSharingRules.class, "customObjectSharingRules", "sharingRules"));
    //    duList.add(new DeploymentUnit("CampaignSharingRules.CampaignCriteriaBasedSharingRule"));
    //    duList.add(new DeploymentUnit("CampaignSharingRules.CampaignOwnerSharingRule"));
    duList.add(new DeploymentUnit(CampaignSharingRules.class, "campaignSharingRules", "sharingRules"));
    //    duList.add(new DeploymentUnit("UserSharingRules.UserMembershipSharingRule"));
    //    duList.add(new DeploymentUnit("UserSharingRules.UserCriteriaBasedSharingRule"));
    //        duList.add(new DeploymentUnit("UserSharingRules"));
    //    duList.add(new DeploymentUnit("ContactSharingRules.ContactOwnerSharingRule"));
    //    duList.add(new DeploymentUnit("ContactSharingRules.ContactCriteriaBasedSharingRule"));
    //        duList.add(new DeploymentUnit("ContactSharingRules"));
    //    duList.add(new DeploymentUnit("CaseSharingRules.CaseOwnerSharingRule"));
    //    duList.add(new DeploymentUnit("CaseSharingRules.CaseCriteriaBasedSharingRule"));
    duList.add(new DeploymentUnit(CaseSharingRules.class, "caseSharingRules", "sharingRules"));
    //    duList.add(new DeploymentUnit("OpportunitySharingRules.OpportunityOwnerSharingRule"));
    //    duList.add(new DeploymentUnit("OpportunitySharingRules.OpportunityCriteriaBasedSharingRule"));
    //        duList.add(new DeploymentUnit("OpportunitySharingRules"));
    //    duList.add(new DeploymentUnit("LeadSharingRules.LeadCriteriaBasedSharingRule"));
    //    duList.add(new DeploymentUnit("LeadSharingRules.LeadOwnerSharingRule"));
    //        duList.add(new DeploymentUnit("LeadSharingRules"));
    //    duList.add(new DeploymentUnit("AccountSharingRules.AccountCriteriaBasedSharingRule"));
    //    duList.add(new DeploymentUnit("AccountSharingRules.AccountOwnerSharingRule"));
    duList.add(new DeploymentUnit(AccountSharingRules.class, "accountSharingRules", "sharingRules"));

    //    duList.add(new DeploymentUnit("Workflow.WorkflowRule"));
    //    duList.add(new DeploymentUnit("Workflow.WorkflowAlert"));
    //    duList.add(new DeploymentUnit("Workflow.WorkflowFieldUpdate"));
    //    duList.add(new DeploymentUnit("Workflow.WorkflowOutboundMessage"));
    //    duList.add(new DeploymentUnit("Workflow.WorkflowKnowledgePublish"));
    //    duList.add(new DeploymentUnit("Workflow.WorkflowSend"));
    //    duList.add(new DeploymentUnit("Workflow.WorkflowTask"));
    duList.add(new DeploymentUnit(Workflow.class, "workflows"));

    duList.add(new DeploymentUnit(Layout.class, "layouts"));

    // -> Layout
    duList.add(new DeploymentUnit(QuickAction.class, "quickActions"));

    duList.add(new DeploymentUnit(CustomApplication.class, "applications", "app"));
    duList.add(new DeploymentUnit(CustomTab.class, "tabs", "tab"));

    duList.add(new DeploymentUnit(RemoteSiteSetting.class, "remoteSiteSettings", "remoteSite"));
    duList.add(new DeploymentUnitWithContent(ApexTrigger.class, "triggers", "trigger"));
    duList.add(new DeploymentUnitWithContent(ApexPage.class, "pages", "page"));
    duList.add(new DeploymentUnitWithContent(ApexComponent.class, "components", "component"));
    duList.add(new DeploymentUnitWithContent(ApexClass.class, "classes", "cls"));

    // TODO
    duList.add(new DeploymentUnit(Profile.class, "profiles"));

    // need to be deleted from bottom up -> roles cannot be deleted if other roles report to it or users are assigned to that role
    duList.add(new DeploymentUnit(Role.class, "roles", "role"));

    // TODO 
    //    duList.add(new DeploymentUnit("ExternalDataSource"));

    duList.add(new DeploymentUnit(CustomLabels.class, "labels", "labels"));

    // -> customer objects
    duList.add(new DeploymentUnit(ReportType.class, "reportTypes"));

    // -> CustomObjects
    duList.add(new DeploymentUnit(CustomObjectTranslation.class, "objectTranslations", "objectTranslation"));

    duList.add(new DeploymentUnit(CustomObject.class, "objects", "object"));

    duList.add(new DeploymentUnit(Translations.class, "translations", "translation"));

    // -> HomePageComponent
    duList.add(new DeploymentUnit(HomePageLayout.class, "homePageLayouts"));
    // -> CustomPageWebLink
    duList.add(new DeploymentUnit(HomePageComponent.class, "homePageComponents"));
    duList.add(new DeploymentUnit(CustomPageWebLink.class, "weblinks", "weblink"));

    duList.add(new DeploymentUnitFolder(Report.class, "reports", "report", true));
    
    duList.add(new DeploymentUnit(Flow.class, "flows"));
    
    duList.add(new DeploymentUnitFolder(Dashboard.class, "dashboards", "dashboard"));
    
    duList.add(new DeploymentUnit(Queue.class, "queues"));

    duList.add(new DeploymentUnit(AutoResponseRules.class));
    
    duList.add(new DeploymentUnitFolderWithContent(EmailTemplate.class, "email", "email", true));

    //    duList.add(new DeploymentUnit("ManagedTopics.ManagedTopic"));
    //    duList.add(new DeploymentUnit("ManagedTopics"));

    // TODO AccountSettings, SecuritySettings, OpportunitySettings...
     duList.add(new DeploymentUnit(Settings.class));
    //    duList.add(new DeploymentUnit("XOrgHub", true));

    //    duList.add(new DeploymentUnit("Scontrol", true));
    //    duList.add(new DeploymentUnit("CustomPermission", true));
    duList.add(new DeploymentUnit(Network.class, "networks"));
    //    duList.add(new DeploymentUnit("PostTemplate", true));
    //    duList.add(new DeploymentUnit("FlexiPage", true));
    //    duList.add(new DeploymentUnit("SiteDotCom", true));
    duList.add(new DeploymentUnit(CallCenter.class, "callCenters"));
    duList.add(new DeploymentUnit(DataCategoryGroup.class, "datacategorygroups"));
    //    duList.add(new DeploymentUnit("AnalyticSnapshot", true));
    duList.add(new DeploymentUnit(PermissionSet.class, "permissionsets", "permissionset"));
    duList.add(new DeploymentUnit(CustomApplicationComponent.class, "customApplicationComponents"));
    duList.add(new DeploymentUnit(Group.class, "groups"));
    duList.add(new DeploymentUnit(SynonymDictionary.class, "synonymDictionaries"));
    duList.add(new DeploymentUnit(SamlSsoConfig.class, "samlssoconfigs", "samlssoconfig"));
    //    duList.add(new DeploymentUnit("ConnectedApp", true));
    //    duList.add(new DeploymentUnit("UiPlugin", true));

    // -> Documents
    duList.add(new DeploymentUnit(Portal.class, "portals"));
    
    // -> Documents
    duList.add(new DeploymentUnit(Letterhead.class, "letterhead", "letter"));
    duList.add(new DeploymentUnit(AppMenu.class, "appMenus"));

    // -> DocumentFolder
    duList.add(new DeploymentUnitFolderWithContent(Document.class, "documents", null));

    //    duList.add(new DeploymentUnit("SharingSet", true));
    duList.add(new DeploymentUnitWithContent(StaticResource.class, "staticresources", "resource"));
    //    duList.add(new DeploymentUnit("AuthProvider", true));

    // should be a manual task -> siteAdmin and subdomain need to be adjusted for target sandbox
    // duList.add(new DeploymentUnit(CustomSite.class, "sites", "site"));

    duList.add(new DeploymentUnit(Community.class, "communities"));
    
    return duList;
  }

}
