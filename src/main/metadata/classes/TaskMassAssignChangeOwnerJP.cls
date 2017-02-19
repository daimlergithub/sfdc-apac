/***********************************************************************************
Created By          :    Siva Krishna k   
Created Date        :    02.02.2017
Company             :    NTT Data,Inc.
Usage               :    TaskMassAssignChangeOwner Class
                          
JIRA NO             :    SFDCJP-1016 & SFDCJP-1020                                             
************************************************************************************/

public with sharing class TaskMassAssignChangeOwnerJP {
    public Task task{set;get;}    
    private String [] arrObjIds;    
    
    /**
  *@Description : Constructor
  *@return:This mehtod does not return any value.

  */
    public TaskMassAssignChangeOwnerJP(){        
        //Initalize the variables   
             
        task = new Task(recordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Welcome Call').getRecordTypeId());        
        Map<String, String> params = ApexPages.currentPage().getParameters();        
        String strObjIds = params.get('objIds');        
        arrObjIds = strObjIds.split(',');                  
    }            
        
    /**
 
 *@return:This mehtod does not return any value.

  */    
        
    public void assignToOwnerClick(){     
        if(task.OwnerId==null){            
            Apexpages.addMessage(new Apexpages.Message(ApexPages.severity.ERROR,'New Owner Cannot be null.'));            
            return;    
        }                
        List<Id> relatedSSIIds = new List<Id>();

        List<Task> tasks = [Select Id, OwnerId, WhatId From Task Where Id=:arrObjIds];        
        for(Task t : tasks){            
            t.OwnerId = task.OwnerId;    
            if(t.WhatId!=null && t.WhatId.getSObjectType()==SSI__c.getSObjectType()){
                relatedSSIIds.add(t.WhatId);
            }
        }                
        if(tasks.size()>0){                        
            update tasks; 
            sendNotificationToNewOwner(task.OwnerId, tasks);     // Send Notifications.
            if(relatedSSIIds.size()>0){
                updateRelatedSSIs(relatedSSIIds, task.OwnerId);
            }         
        }    
    }
    /**
  *@Description : Assigns the task with different owner and updates Related SSI object.
  
  *@return:This mehtod does not return any value.

  */
    public void updateRelatedSSIs(List<Id> relatedSSIIds, Id ownerId){
        List<SSI__c> ssis = [Select Id, OwnerId From SSI__c Where Id in :relatedSSIIds];
        for(SSI__c ssi : ssis){
            ssi.OwnerId = ownerId;
        }
        update ssis;
    }
    
    // This method is used to send notifications to new owner.
    private void sendNotificationToNewOwner(Id newOwnerId, List<Task> tasks) {
        EmailTemplate templateRec = [Select Id, Name from EmailTemplate where DeveloperName = 'test_email'];
        String emailBody = 'Hi,<br/><br/>Following Task are assigned to you - <br/>';
        for(Integer i = 1; i <= tasks.size(); i++) {
            emailBody += '(' + i +') ' + URL.getSalesforceBaseUrl().toExternalForm()+'/'+ tasks[i-1].Id + '<br/>';
        }
        emailBody += '<br/>Thanks!!<br/>Salesforce';
        
        List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        msg.SetsaveAsActivity(false); 
        msg.setTemplateId(templateRec.Id);
        msg.setTargetObjectId(newOwnerId);  
        msg.setHTMLBody(emailBody);
        msg.subject = 'Task Assignment Notification';
        msgList.add(msg);
        Messaging.sendEmail(msgList);     
    }
}