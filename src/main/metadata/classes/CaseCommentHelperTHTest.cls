/*
    Type:Test class
    Purpose:Test Class for CaseCommentHelperTH
    User Story:
    Used By:     
    ---------------------------------------------------------------
    History:
    1. Created on 18-04-2018 by Abhishek Mohanty 
    2. Modified     
*/
@isTest 
public class CaseCommentHelperTHTest {
	public static User user1 = TestUtils.IntegrationAPIUser();
    static testMethod void testmethod1() {
       // Create the Case Record.
        Trigger__c CaseCommentTriggerTH=new Trigger__c();
        CaseCommentTriggerTH.Name='CaseCommentTriggerTH';
        CaseCommentTriggerTH.Market__c='TH';
        CaseCommentTriggerTH.Trigger_Handler__c='CaseCommentTriggerHandlerTH';
        CaseCommentTriggerTH.Trigger_Name__c='CaseCommentTrigger';
        CaseCommentTriggerTH.after__c=true;
        CaseCommentTriggerTH.before__c=true;
        CaseCommentTriggerTH.enabled__c=true;
        CaseCommentTriggerTH.insert__c=true;
        CaseCommentTriggerTH.update__c=true;
        insert CaseCommentTriggerTH;
        Case cas = new Case(Status ='New', Priority = 'Low' , COS_Ticket_Number__c='T745119'); 
        insert cas;
        
        Casecomment casecomment = new Casecomment (ParentId=cas.id , CommentBody='Test');
        insert casecomment; 
        
        //Map<id,sObject> caseComments = new Map<id,sObject>([Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, SystemModstamp, LastModifiedDate, LastModifiedById, IsDeleted From CaseComment where ParentId=:cas.id]);
        
        //CaseCommentHelperTH.SendCaseCommentsToCOS(caseComments);
    }
    @isTest
    static void THIntegrationtestmethod1() {      
        user1=[select Id,Name,profile.Name from user where id=:user1.Id];
        system.runAs(user1){
        Test.startTest();
        TriggerUtil.userCreate=false;
        Trigger__c CaseCommentTriggerTH=new Trigger__c();
        CaseCommentTriggerTH.Name='CaseCommentTriggerTH';
        CaseCommentTriggerTH.Market__c='TH';
        CaseCommentTriggerTH.Trigger_Handler__c='CaseCommentTriggerHandlerTH';
        CaseCommentTriggerTH.Trigger_Name__c='CaseCommentTrigger';
        CaseCommentTriggerTH.after__c=true;
        CaseCommentTriggerTH.before__c=true;
        CaseCommentTriggerTH.enabled__c=true;
        CaseCommentTriggerTH.insert__c=true;
        CaseCommentTriggerTH.update__c=true;
        insert CaseCommentTriggerTH;
            Trigger__C casetrigger=new Trigger__C(name='TriggerCaseTH',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='CaseTriggerHandlerTH',Trigger_Name__c='CaseTrigger',update__c=true);
    insert casetrigger;
       CDM_Integration_URLs__c cdm= new CDM_Integration_URLs__c();
            cdm.Name='TH-Case Update';
            cdm.Context__c='Case';
            cdm.Country__c='TH';
            cdm.Type__c='Update';
            cdm.Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-TH-FS-Salesforce-COS';
            insert cdm;
            
            CallOutHandlerSettingDFW__c callout=new CallOutHandlerSettingDFW__c();
            callout.Name='CalloutValues';
            callout.DEFAULT_CALLOUT_TIME__c='5000';
            callout.MAX_CALLOUT_TIME__c='30000';
            insert callout;
            
            SystemSettingsDFW__c setting=new SystemSettingsDFW__c();
            setting.Log_Purge__c=2;
            insert setting;
            
           Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorCase());
        
        TriggerUtil.userCreate=false;
        Case cas = new Case(Status ='New', Priority = 'Low' , COS_Ticket_Number__c='T745119',market__C='TH'); 
        insert cas;
        
            TriggerUtil.userCreate=false;
        Casecomment casecomment = new Casecomment (ParentId=cas.id , 
         CommentBody='CR/n'+system.now()+'/ntest from COS/n Htpps://test.com');
        insert casecomment; 
        TriggerUtil.userCreate=false;
        Casecomment casecomment2 = new Casecomment (ParentId=cas.id , 
         CommentBody='CR/n'+system.now()+'/ntest from COS/n');
        insert casecomment2; 
        test.stoptest();
        }
        
    }
}