/*
    Type:Test class
    Purpose:Test Class for CaseCommentHelperMY     
*/
@isTest 
public class CaseCommentHelperMYTest {
    static testMethod void testmethod1() {
       
       // Create the Case Record.
        Test.startTest();
        Trigger__c CaseCommentTriggerMY=new Trigger__c();
        CaseCommentTriggerMY.Name='CaseCommentTriggerMY';
        CaseCommentTriggerMY.Market__c='MY';
        CaseCommentTriggerMY.Trigger_Handler__c='CaseCommentTriggerHandlerMY';
        CaseCommentTriggerMY.Trigger_Name__c='CaseCommentTrigger';
        CaseCommentTriggerMY.after__c=true;
        CaseCommentTriggerMY.before__c=true;
        CaseCommentTriggerMY.enabled__c=true;
        CaseCommentTriggerMY.insert__c=true;
        CaseCommentTriggerMY.update__c=true;
        insert CaseCommentTriggerMY;
        Case cas = new Case(Status ='New', Priority = 'Low' , COS_Ticket_Number__c='T745119'); 
        insert cas;
        
        Casecomment casecomment = new Casecomment (ParentId=cas.id , CommentBody='Test');
        insert casecomment; 
        
        Map<id,sObject> caseComments = new Map<id,sObject>([Select Id, ParentId, IsPublished, CommentBody, CreatedById, CreatedDate, SystemModstamp, LastModifiedDate, LastModifiedById, IsDeleted From CaseComment where ParentId=:cas.id]);
        
        CaseCommentHelperMY.SendCaseCommentsToCOS(caseComments);      
        Test.stopTest();  
    }
}