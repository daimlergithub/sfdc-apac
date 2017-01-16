/*
    Type:       SMSReplyHistory Visualforce page 
    Purpose:    Search SMSReplyHistory
    User Story: SMS
    Used By:    HistoryRespond.page
    ---------------------------------------------------------------
    History:
    
    1. lishuang Created on 2013-12-09

*/
public class HistoryRespondController {

    public Task taskInfo { get; set; }
    public List<SMSReplyHistory__c> theResults = new List<SMSReplyHistory__c>();
    public HistoryRespondController(ApexPages.StandardController controller) {
        taskInfo = (Task)controller.getRecord();
    }
    public List<SMSReplyHistory__c> getTheResults () {
        String taskId = taskInfo.id;
        theResults  = [SELECT  Name, SMSCode__c, SMSContent__c, SMSSentTime__c, Respondtime__c, ValidReply__c , ResponseContent__c, IsFirstValid__c FROM SMSReplyHistory__c where TaskID__c = :taskId ];
        return theResults;
     }      
}