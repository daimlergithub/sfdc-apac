global class CampaignSchedulerAndNotificationJP implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
    global List<String> notiMailerList = new List<String>();
    global String emailBodyStr;
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Date today = Date.Today();
        String query = 'Select Id, OwnerId, Owner.Name, Execution_Type__c, Child_Campaign_Status__c, Campaign_CCC_Manager__c, ParentId, Parent.Campaign_Type__c, ';
        query += '(Select Id, OwnerId from Campaign_Members1__r) from Campaign Where Execution_Start_Date__c =: today AND RecordType.DeveloperName = \'Campaign_Executiono\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Campaign> scope) {
         List<Lead__c>leadLst = new List<Lead__c>();
         List<Task>tskLst = new List<Task>();
         List<Campaign_Lead__c> cLeadLst = new List<Campaign_Lead__c>();
         List<Campaign >campLst = new List<Campaign>();
         List<Campaign_Member__c> campMemberLst = new List<Campaign_Member__c>();
         Map<String, Id> leadRecTypeNameToRecTypeIdMap = new Map<String, Id>();
         leadRecTypeNameToRecTypeIdMap.put('Sales Leads', Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId());
         leadRecTypeNameToRecTypeIdMap.put('Aftersales Leads', Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId());
         leadRecTypeNameToRecTypeIdMap.put('Finance', Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Finance').getRecordTypeId());
         
         Map<String, String> parentCapmaignToLeadRecTypeMap = new Map<String, String>();
         parentCapmaignToLeadRecTypeMap.put('Sales', 'Sales Leads');
         parentCapmaignToLeadRecTypeMap.put('After Sales', 'Aftersales Leads');
         parentCapmaignToLeadRecTypeMap.put('Finance', 'Finance');
         
         for(Campaign camp : scope){
         
             if((camp.Execution_Type__c == 'eMail' || camp.Execution_Type__c == 'DM') && camp.Child_Campaign_Status__c == 'Segmentation'){
                 emailBodyStr = 'Hi '+camp.Owner.Name+',<br /><br/>This Campaign is ready for excecution. Please find the below detail link for the campaign record:<br/>';
                 emailBodyStr = emailBodyStr +''+URL.getSalesforceBaseUrl().toExternalForm()+'/'+camp.Id+'<br/><br />Thanks!!<br/>Salesforce';
                 notiMailerList.add(camp.OwnerId); 
                 
                 camp.Child_Campaign_Status__c = 'Execution';
                 campLst.add(camp);
             }
             
             else if(camp.Execution_Type__c == 'Lead' && camp.Child_Campaign_Status__c == 'Segmentation') {
                
                emailBodyStr = 'Hi '+camp.Owner.Name+',<br /><br/>Please find the below detail link for the campaign record:<br/>';
                emailBodyStr = emailBodyStr +''+URL.getSalesforceBaseUrl().toExternalForm()+'/'+camp.Id+'<br/><br />Thanks!!<br/>Salesforce';
                if(camp.Campaign_CCC_Manager__c != null) {
                    notiMailerList.add(camp.Campaign_CCC_Manager__c);
                 }
                 Id recTypeId = (parentCapmaignToLeadRecTypeMap.containsKey(camp.Parent.Campaign_Type__c) ? 
                                            leadRecTypeNameToRecTypeIdMap.get(parentCapmaignToLeadRecTypeMap.get(camp.Parent.Campaign_Type__c)) : null);
                 for(Campaign_Member__c campaignMemberRec : camp.Campaign_Members1__r) {
                    Lead__c lead = new Lead__c();
                    lead.CAC_Lead_Status__c = 'New'; 
                    lead.Source_Campaign__c = camp.id;
                    lead.OwnerId = camp.Campaign_CCC_Manager__c;
                    if(recTypeId != null) {
                        lead.RecordTypeId = recTypeId;
                    }
                    leadLst.add(lead);
                    
                    campaignMemberRec.Status__c = 'Executed';
                    campMemberLst.add(campaignMemberRec);
                 }
                 camp.Child_Campaign_Status__c = 'Execution';
                 campLst.add(camp);
             }
             
             else if(camp.Execution_Type__c == 'OB Call' && camp.Child_Campaign_Status__c == 'Segmentation'){
                 emailBodyStr = 'Hi '+camp.Owner.Name+',<br /><br/>Please find the below detail link for the campaign record:<br/>';
                 emailBodyStr = emailBodyStr +''+URL.getSalesforceBaseUrl().toExternalForm()+'/'+camp.Id+'<br/><br />Thanks!!<br/>Salesforce';
                 //notiMailerList.add(camp.OwnerId); 
                 
                 if(camp.Campaign_CCC_Manager__c != null){
                    notiMailerList.add(camp.Campaign_CCC_Manager__c);
                 }
                 
                 String taskRecTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
                 for(Campaign_Member__c campaignMemberRec : camp.Campaign_Members1__r) {
                    Task task = new Task();
                    task.WhatID = camp.Id;
                    task.Status = 'Open';
                    task.Type = 'Campaign';
                    task.subject = 'Campaign Executed';
                    task.ownerId = camp.Campaign_CCC_Manager__c;
                    task.priority = 'Normal';
                    task.RecordTypeId = taskRecTypeId;
                    tskLst.add(task);
                    
                    campaignMemberRec.Status__c = 'Executed';
                    campMemberLst.add(campaignMemberRec);
                 }
                 
                 camp.Child_Campaign_Status__c = 'Execution';
                 campLst.add(camp);
                 
                 /*for(Campaign_Member__c campaignMemberRec : camp.Campaign_Members1__r) {
                    campaignMemberRec.Status__c = 'Executed';
                    campMemberLst.add(campaignMemberRec);
                 }*/
                 
            }
         }
             
          if(tskLst.size() >0){
              insert tskLst;
          }  
          
          if(leadLst.size() >0){  
              insert leadLst;
          }
          
          if(campLst.size() >0){
              update campLst;
          }
          
          if(campMemberLst.size() >0){
              update campMemberLst;
          }
          
          if(leadLst.size() >0){
              for(Lead__c lead : leadLst){
                  Campaign_Lead__c cLead = new Campaign_Lead__c(); 
                  cLead.Lead__c = lead.id;
                  cLead.Campaign__c = lead.Source_Campaign__c;
                  
                  cLeadLst.add(cLead);
              }
             insert cLeadLst;  
          }
             
    }
    
    
    global void finish(Database.BatchableContext bc) {
         EmailTemplate templateId = [Select id from EmailTemplate where name = 'test email'];
         List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
           
         for(String userId : notiMailerList){
               Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
               msg.SetsaveAsActivity(false); 
               msg.setTemplateId(templateId.Id);
               msg.setTargetObjectId(userId);  
               msg.setHTMLBody(emailBodyStr);
               msg.subject = 'Campaign Notification';
              
               msgList.add(msg);
          }
          Messaging.sendEmail(msgList);     
     }
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new CampaignSchedulerAndNotificationJP());
    }
}