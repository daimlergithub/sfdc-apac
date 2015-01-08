/*
    Type:       Test Class
    Purpose:    ShareCampaignByClooaboration.trigger
				UtilCampaignShareByCollaboration.cls
    ---------------------------------------------------------------
    History:

    27-June-2013 Stephano Shi (Breakingpoint)    Created

*/
@isTest
public class ShareCampaignByCollaboration_TestClass{
	/* Test Method		*/
    static testmethod void runShareCampaignByClooaboration(){
        // Campaign Record Type Id Search
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap_test = Schema.SObjectType.Campaign.getRecordTypeInfosByName();
        Id cca_RecordTypeId = cpRecordTypeMap_test.get('Central Marketing Campaign').getRecordTypeId();         // Central Campaign
        
        Test.startTest();
        // Central Campaign Inital
        Campaign TestData_CCA = new Campaign(Name='TestData_CCA_Campaign',
                                             Campaign_Code__c='Code_CCA',
                                             Type='Other',
                                             Campaign_Objectives__c='Objectives',
                                             Description='Description',
                                             Status='Confirmed',
                                             StartDate=date.newinstance(2013, 5, 17),
                                             EndDate=date.newinstance(2013, 10, 17),
                                             RecordTypeId=cca_RecordTypeId);
		insert TestData_CCA;
        
        // User
        UserRole r = new UserRole(name = 'CRM Assist Manager - Acquisition and Loyalty');
        User us = new User(alias = 'hasrole', 
                           email='userwithrole@roletest1.com',
                           userroleid = r.id,
                           emailencodingkey='UTF-8', 
                           lastname='Testing',
                           languagelocalekey='en_US',
                           localesidkey='en_US',
                           profileid = UserInfo.getProfileId(),
                           timezonesidkey='America/Los_Angeles', username='userwithrole@testorg.com');
        
        insert us;
        
        // Campaign Collaboration Team
        Collaboration_Team__c ct = new Collaboration_Team__c(Campaign__c=TestData_CCA.Id,Member_Name__c=us.Id,Access_Type__c='Read Only');
        insert ct;
        
        ct.Access_Type__c = 'Read/Write';
        update ct;
        
        delete ct;
        Test.stopTest();
        
    }
}