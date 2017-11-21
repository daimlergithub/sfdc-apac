/*
    Type:       Test Class
    Purpose:    Test On MassApproveToolKitController
    ---------------------------------------------------------------
    History:
    
    1. Cyril Created on 2014-10-24

*/
@isTest(seeAllData=false)
public class MassApproveToolKitControllerTest {
    static testMethod void myUnitTest() {
        
         List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        // insert updatecustomsettings;
        
        Account dealer = new Account(
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(),
            Name = 'test dealer',
            Dealer_Active__c = true
        );
        insert dealer;
        System.assert(dealer != null);
        Tool_Kit__c toolKit = new Tool_Kit__c(
            RecordTypeId = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('Event').getRecordTypeId(), 
            Name = 'test tool kit',
            Dealer_Name__c = dealer.id,
            Plan_Start_Date__c = System.today(),
            Plan_End_Date__c = System.today() + 20,
            Apply_Status__c = 'Planned',
            Feedback_Status__c = 'Planned',
            Brand__c = 'MB',
            Event_Type__c = 'Road Show',
            Event_Director__c = 'test',
            Event_Participant__c = 'Media',
            Location__c = 'test',
            Location_Size__c = 10,
            Approver__c = Userinfo.getUserId()
        );
        insert toolKit;
           Tool_Kit__c toolKit1 = new Tool_Kit__c(
            RecordTypeId = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('Event').getRecordTypeId(), 
            Name = 'test tool kit',
            Dealer_Name__c = dealer.id,
            Plan_Start_Date__c = System.today(),
            Plan_End_Date__c = System.today() + 20,
            Apply_Status__c = 'Planned',
            Feedback_Status__c = 'Planned',
            Brand__c = 'AMG',
            Event_Type__c = 'Road Show',
            Event_Director__c = 'test',
            Event_Participant__c = 'Media',
            Location__c = 'test',
            Location_Size__c = 10,
            Approver__c = Userinfo.getUserId()
        );
        insert toolKit1;
         Tool_Kit__c toolKit2 = new Tool_Kit__c(
            RecordTypeId = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('Event').getRecordTypeId(), 
            Name = 'test tool kit',
            Dealer_Name__c = dealer.id,
            Plan_Start_Date__c = System.today(),
            Plan_End_Date__c = System.today() + 20,
            Apply_Status__c = 'Planned',
            Feedback_Status__c = 'Planned',
            Brand__c = 'smart',
            Event_Type__c = 'Road Show',
            Event_Director__c = 'test',
            Event_Participant__c = 'Media',
            Location__c = 'test',
            Location_Size__c = 10,
            Approver__c = Userinfo.getUserId()
        );
        insert toolKit2;
         Tool_Kit__c toolKit3 = new Tool_Kit__c(
            RecordTypeId = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('Event').getRecordTypeId(), 
            Name = 'test tool kit',
            Dealer_Name__c = dealer.id,
            Plan_Start_Date__c = System.today(),
            Plan_End_Date__c = System.today() + 20,
            Apply_Status__c = 'Planned',
            Feedback_Status__c = 'Planned',
            Brand__c = 'StarElite',
            Event_Type__c = 'Road Show',
            Event_Director__c = 'test',
            Event_Participant__c = 'Media',
            Location__c = 'test',
            Location_Size__c = 10,
            Approver__c = Userinfo.getUserId()
        );
        insert toolKit3;
        Tool_Kit__c toolKit4 = new Tool_Kit__c(
            RecordTypeId = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('smart Event').getRecordTypeId(), 
            Name = 'test tool kit',
            Dealer_Name__c = dealer.id,
            Original_Plan_Start_Date__c = System.today(),
            Plan_End_Date__c = System.today() + 20,
            Apply_Status__c = 'Tool Kit Finished',
            Feedback_Status__c = 'Planned',
            Brand__c = 'MB',
            Event_Type__c = 'Road Show',
            Event_Director__c = 'test',
            Event_Participant__c = 'Media',
            Location__c = 'test',
            Location_Size__c = 10,
            Approver__c = Userinfo.getUserId()
        );
        insert toolKit4;
           Tool_Kit__c toolKit5 = new Tool_Kit__c(
            RecordTypeId = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('smart Event').getRecordTypeId(), 
            Name = 'test tool kit',
            Dealer_Name__c = dealer.id,
            Original_Plan_Start_Date__c = System.today(),
            Plan_End_Date__c = System.today() + 20,
            Apply_Status__c = 'Tool Kit Finished',
            Feedback_Status__c = 'Planned',
            Brand__c = 'AMG',
            Event_Type__c = 'Road Show',
            Event_Director__c = 'test',
            Event_Participant__c = 'Media',
            Location__c = 'test',
            Location_Size__c = 10,
            Approver__c = Userinfo.getUserId()
        );
        insert toolKit5;
         Tool_Kit__c toolKit6 = new Tool_Kit__c(
            RecordTypeId = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('smart Event').getRecordTypeId(), 
            Name = 'test tool kit',
            Dealer_Name__c = dealer.id,
            Original_Plan_Start_Date__c = System.today(),
            Plan_End_Date__c = System.today() + 20,
            Apply_Status__c = 'Tool Kit Finished',
            Feedback_Status__c = 'Planned',
            Brand__c = 'smart',
            Event_Type__c = 'Road Show',
            Event_Director__c = 'test',
            Event_Participant__c = 'Media',
            Location__c = 'test',
            Location_Size__c = 10,
            Approver__c = Userinfo.getUserId()
        );
        insert toolKit6;
         Tool_Kit__c toolKit7 = new Tool_Kit__c(
            RecordTypeId = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('smart Event').getRecordTypeId(), 
            Name = 'test tool kit',
            Dealer_Name__c = dealer.id,
            Original_Plan_Start_Date__c = System.today(),
            Plan_End_Date__c = System.today() + 20,
            Apply_Status__c = 'Tool Kit Finished',
            Feedback_Status__c = 'Planned',
            Brand__c = 'StarElite',
            Event_Type__c = 'Road Show',
            Event_Director__c = 'test',
            Event_Participant__c = 'Media',
            Location__c = 'test',
            Location_Size__c = 10,
            Approver__c = Userinfo.getUserId()
        );
        insert toolKit7;
    List<User> userlst = new List<User>();
    Profile profile1 =[Select Id from Profile where name= 'External Marketing User'];
    User AccountOwner = new User(
    ProfileId = profile1.Id,
    Username ='test22589y6@test.com',
    Alias = 'batman',
    Email='loly@wayneenterprises.com',
    EmailEncodingKey='UTF-8',
    Firstname='lol',
    Lastname='iol',
    CommunityNickname = 'test12p34510',
    TimeZoneSidKey = 'America/Los_Angeles',
    LocaleSidKey = 'en_US',
    LanguageLocaleKey = 'en_US');
    
    userlst.add(AccountOwner );
    
    AccountOwner = new User(
    ProfileId = profile1.Id,
    Username ='test225896@test.com',
    Alias = 'batman',
    Email='lol@wayneenterprises.com',
    EmailEncodingKey='UTF-8',
    Firstname='lol',
    Lastname='iol',
    CommunityNickname = 'test1234510',
    TimeZoneSidKey = 'America/Los_Angeles',
    LocaleSidKey = 'en_US',
    LanguageLocaleKey = 'en_US');
    userlst.add(AccountOwner );
        
   User lu = [Select Id From User where Id=:userinfo.getuserId()];
    system.runAs(lu){
        insert userlst;
    }
    Approval.ProcessResult result;
    
        System.runAs (lu){
         Tool_Kit__c toolKit8 = new Tool_Kit__c(
            
            RecordTypeId = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('smart Event').getRecordTypeId(), 
            Name = 'test tool kit',
            Dealer_Name__c = dealer.id,
            Original_Plan_Start_Date__c = System.today(),
            Plan_End_Date__c = System.today() + 20,
            Apply_Status__c = 'Tool Kit Finished',
            Feedback_Status__c = 'Planned',
            Brand__c = 'StarElite',
            Event_Type__c = 'Road Show',
            Event_Director__c = 'test',
            Event_Participant__c = 'Media',
            Location__c = 'test',
            Location_Size__c = 10,
            Approver__c = Userinfo.getUserId(),
            Vendor_Employee__c = userlst.get(0).Id);
             insert toolKit8;
       
            /*Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(toolKit.id);
            req1.setSubmitterId(Userinfo.getUserId()); 
            req1.setProcessDefinitionNameOrId('Tool_Kit_Approval_Process');
            req1.setSkipEntryCriteria(false);
            result = Approval.process(req1);*/
            toolKit8.Vendor_Employee__c  = userlst.get(1).Id;
            update toolKit8;
         }
        Test.startTest();
        //System.assert(result.isSuccess());
        System.assert([Select Id, Apply_Status__c from Tool_Kit__c where id = :toolKit.id][0].Apply_Status__c == 'Planned');
        
        PageReference pr = new PageReference('/apex/MassApproveToolKit');
        Test.setCurrentPage(pr);
        
        MassApproveToolKitController con = new MassApproveToolKitController();
        con.toolKit.Dealer_Name__c = dealer.id;
        con.getRecordTypes();
        con.getApplyStatusOptions();
        con.getFeedbackStatusOptions();
        con.getRegions();
        con.getSubRegions();
        con.query();
        system.debug(con.hasPrev);
        system.debug(con.hasNext);
        con.previous();
        con.next();
        con.first();
        con.last();
        system.debug(con.recordNumbering);
        
        //con.toolKitsInfo[0].isToApprove = true;
        
        con.approve();
        Test.stopTest();
    }
}