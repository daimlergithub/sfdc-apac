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
}