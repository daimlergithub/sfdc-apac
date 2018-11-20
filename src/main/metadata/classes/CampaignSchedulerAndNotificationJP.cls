/***********************************************************************************
Created By          :    Abhishek
Created Date        :    02.02.2017
Company             :    NTT Data,Inc.
Usage               :    Campaign Scheduler and Notification Class
                          
JIRA NO             :    SFDCJP-1013                                            
************************************************************************************/

global class CampaignSchedulerAndNotificationJP implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
    global List<String> notiMailerList = new List<String>();
    global String emailBodyStr;
    global String templateName;
    global List<NotificationWrapper> notificationWrapperList;
    global List<String> templateNameList = new List<String>{'Campaign notification on Execution', 'Campaign Lead Assignment Notification', 'Task Notification'};
    global Set<Id> campignIdSetForLeadType = new Set<Id>();
    global Set<Id> newInsertedLeadId = new Set<Id>();
    global Map<String, Id> templateNameToTemplateIdMap;
      global Map<Id, String> errorMap {get; set;}
  global Map<Id, String> successMap {get; set;}
   global list<Id> successlist=new list<ID>();
  global Map<Id, SObject> IdToSObjectMap {get; set;}
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        Date today = Date.Today();
        String query = 'SELECT ';
        
      // Child Query 
        /*query += '( SELECT ';*/
        for(String fieldName : getCampaignMemberFields()) {
            query += fieldName + ', ';
        }
       // query = query.substring(0, query.length() - 2);
        //query += ' FROM Campaign_Members1__r) ';
        
        query = query.substring(0, query.length() - 2);
        query += ' FROM Campaign_Member__c WHERE ';
        query += 'MD__c =' +'\'JP\'';
        query += ' AND Campaign_Id__r.Execution_Start_Date__c  =:today';
        
        System.debug('+++++++++++++++'+query);
        
        //String query = 'Select Id, OwnerId, Owner.Name, Execution_Type__c, Child_Campaign_Status__c, Campaign_CCC_Manager__c, Execution_Start_Date__c, ParentId, Parent.Campaign_Type__c, ';
        //query += '(Select Id, OwnerId, Contact_Id__c, Special_Flag_to_Include__c, Special_flag_to_Exclude__c, Delinquency_Flag__c, MBF_Anti_Social_flag__c, Offer_Prohibit_Flag__c, Payment_Suspended_Flag__c from Campaign_Members1__r)';
        //query += 'from Campaign Where Execution_Start_Date__c =: today AND RecordType.DeveloperName = \'Campaign_Executiono\'';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Campaign_member__c> scope) {
     //List<Lead__c>leadLst = new List<Lead__c>();
     map<id,Lead__c>leadLst = new map<id,Lead__c>();
        //List<Task>tskLst = new List<Task>();
        map<id,task> tskLst = new map<id,task>();
       // List<Campaign_Lead__c> cLeadLst = new List<Campaign_Lead__c>();
       map<id,Campaign_Lead__c> cLeadLst = new map<id,Campaign_Lead__c>();
        List<Campaign >campLst = new List<Campaign>();
        List<Campaign_Member__c> campMemberLst = new List<Campaign_Member__c>();
        List<DM_Request__c> dmRequestList = New List<DM_Request__c>(); 
         List<Campaign_Member__c> camIdCamMemMap = new List<Campaign_Member__c>();
                Map<id,Campaign_Member__c>pMap = new Map<id,Campaign_Member__c>();
        Map<id,Account>pConMap = new Map<id,Account>();

        notificationWrapperList = new List<NotificationWrapper>();   
    
    
    
     templateNameToTemplateIdMap = new Map<String, Id>();
        List<EmailTemplate> templateList = [Select Id, Name from EmailTemplate where Name IN: templateNameList];
        for(EmailTemplate tempRec : templateList) {
            templateNameToTemplateIdMap.put(tempRec.Name, tempRec.Id);
        }
        
        
        Map<String, Id> leadRecTypeNameToRecTypeIdMap = new Map<String, Id>();
        leadRecTypeNameToRecTypeIdMap.put('Sales Leads', Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId());
        leadRecTypeNameToRecTypeIdMap.put('Aftersales Leads', Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId());
       // leadRecTypeNameToRecTypeIdMap.put('Finance', Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Finance').getRecordTypeId());
         
        Map<String, String> parentCapmaignToLeadRecTypeMap = new Map<String, String>();
        parentCapmaignToLeadRecTypeMap.put('Sales', 'Sales Leads');
        parentCapmaignToLeadRecTypeMap.put('After Sales', 'Aftersales Leads');
        parentCapmaignToLeadRecTypeMap.put('Finance', 'Sales Leads');
        String taskRecTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
        
    
    for(Campaign_Member__c campaignMemberRec : scope) {

         if(campaignMemberRec.Campaign_Id__r.Execution_Type__c == 'Lead'){
                        if(campaignMemberRec.Campaign_Id__r.Campaign_CCC_Manager__c != null){
                        campignIdSetForLeadType.add(campaignMemberRec.Campaign_Id__c);
                    }
                         Id recTypeId = (parentCapmaignToLeadRecTypeMap.containsKey(campaignMemberRec.Campaign_Id__r.Parent.Campaign_Type__c) ? 
                                                leadRecTypeNameToRecTypeIdMap.get(parentCapmaignToLeadRecTypeMap.get(campaignMemberRec.Campaign_Id__r.Parent.Campaign_Type__c)) : null);   
                            
                            Lead__c lead = new Lead__c();
                            lead.CAC_Lead_Status__c = 'Approved'; 
                            lead.Source_Campaign__c = campaignMemberRec.Campaign_Id__c;
                            lead.Contact__c = campaignMemberRec.Contact_Id__c;
                            lead.Assigned_Dealer__c =campaignMemberRec.Preferred_Dealer__c;
                            //lead.Lead_Type__c = campaignMemberRec.Lead_Type__c;
                            lead.Lead_Sub_Type__c = campaignMemberRec.Lead_Sub_Type__c;
                            lead.Existing_Contract__c=campaignMemberRec.Contract__c;
                            lead.Interested_Vehicle_Model__c = campaignMemberRec.Interested_Model__c;
                            lead.Assigned_Dealer__c=campaignMemberRec.Preferred_Dealer__c;
                            //lead.Finance_Product_Name__c=campaignMemberRec.Finance_Product_Name__c;
                            lead.Finance_Contract_Term__c=campaignMemberRec.Term__c;
        lead.Finance_Monthly_Payment__c=campaignMemberRec.Monthly_Payment__c;
        lead.Finance_Interest_Rate__c=campaignMemberRec.Interest_Rate__c;
        lead.Finance_RV_Ballon__c=campaignMemberRec.RV_Ballon__c;
        lead.Finance_Total_V_Price_NoTax__c=campaignMemberRec.Total_Vehicle_Price_without_tax__c;
        lead.Finance_Total_V_Price_Tax__c=campaignMemberRec.Total_Vehicle_Price_with_tax__c;
        lead.Purchase_Time__c=campaignMemberRec.Purchase_Timing__c;
        lead.Lead_Desired_Service__c=campaignMemberRec.Lead_Desired_Service__c;
        lead.Assigned_Date_Time__c = system.now();
        
        lead.Lead_DataSource__c='Campaign';
        lead.UsVIN__c=campaignMemberRec.UsVIN__c;
        if(campaignMemberRec.Campaign_Id__r.Parent.Campaign_Type__c == 'After Sales'){
        
           lead.AfterSales_Vehicle__c=campaignMemberRec.Vehicle__c;
        
        }
        if(campaignMemberRec.Campaign_Id__r.Parent.Campaign_Type__c == 'Sales' || campaignMemberRec.Campaign_Id__r.Parent.Campaign_Type__c == 'Finance')
        {
           lead.Trade_In_Vehicle__c=campaignMemberRec.Vehicle__c;
        }
        if(campaignMemberRec.Campaign_Id__r.Parent.Campaign_Type__c  == 'Finance')
        {
          lead.Cross_Point_Model__c=campaignMemberRec.Cross_Point_Model__c;
          lead.Lead_Type__c = 'New Car';
          lead.Dealer_Lead_Status__c= 'Not Started';
                         
        } else {
        
        lead.Lead_Type__c = campaignMemberRec.Lead_Type__c;
        
        
        }
                            
                            
                            if(campaignMemberRec.Special_Flag_to_Include__c == 'true') {
                                lead.OwnerId = campaignMemberRec.Campaign_Id__r.OwnerId;//campaignMemberRec.Contact_Id__c;
                                
                            } else if(campaignMemberRec.Campaign_Id__r.Parent.Campaign_Type__c == 'Finance' && (campaignMemberRec.Delinquency_Flag__c == 'true' || campaignMemberRec.Special_flag_to_Exclude__c == 'true' ||
                                    campaignMemberRec.MBF_Anti_Social_flag__c == 'true' || campaignMemberRec.Offer_Prohibit_Flag__c == 'true' || campaignMemberRec.Payment_Suspended_Flag__c == 'true')) {
                                lead.OwnerId = campaignMemberRec.Campaign_Id__r.Campaign_CCC_Manager__c;
                                
                            } else {
                                lead.OwnerId = campaignMemberRec.Campaign_Id__r.OwnerId;//campaignMemberRec.Contact_Id__c;
                            }
                            
                            if(recTypeId != null) {
                                lead.RecordTypeId = recTypeId;
                            }
                           // leadLst.add(lead);
                            leadLst.put(campaignMemberRec.id,lead);
                            campaignMemberRec.Status__c = 'Responded';
                            campaignMemberRec.Convert_To_Lead_Flag__c = true;
                            campMemberLst.add(campaignMemberRec);
         }
          else if(campaignMemberRec.Campaign_Id__r.Execution_Type__c == 'OB Call' ){
                     
                    if(campaignMemberRec.Campaign_Id__r.Campaign_CCC_Manager__c != null){
                        setNotificationTemplate(campaignMemberRec.Campaign_Id__r.Campaign_CCC_Manager__c , templateNameToTemplateIdMap.get('Task Notification'),campaignMemberRec.Campaign_Id__c);
                    }
                   Task task = new Task();
                            task.WhatID = campaignMemberRec.Campaign_Id__c;
                            task.Status = 'Open';
                            task.Type = 'Campaign';
                            //task.subject = 'Campaign Executed';
              if (campaignMemberRec.Campaign_Id__r.Name != null){
                  task.subject = campaignMemberRec.Campaign_Id__r.Name;
              }
                            task.ownerId = campaignMemberRec.Campaign_Id__r.Campaign_CCC_Manager__c;
                            task.priority = 'Normal';
                            task.RecordTypeId = taskRecTypeId;
                            task.ActivityDate = campaignMemberRec.Campaign_Id__r.Execution_Start_Date__c;
                            task.Whatid = campaignMemberRec.Campaign_Id__c ;
                            
                             if(campaignMemberRec.Contact_Id__c!=null)
                        {
                    task.whoid =campaignMemberRec.Contact_Id__r.personcontactid;
                      } 
                            task.Contract__c = campaignMemberRec.Contract__c ;
                            task.Related_Vehicle__c= campaignMemberRec.Vehicle__c;
                            task.Account_Name__c =campaignMemberRec.Company_Name__c;
                            task.Phone__c = campaignMemberRec.Contract_Phone1_1__c;
                            task.Phone_number__c= campaignMemberRec.Contract_Phone2_2__c;
                            task.Campaign_Member_ID__c = campaignMemberRec.Name;
                          //  tskLst.add(task);
                            tskLst.put(campaignMemberRec.id,task);
							// Commented by Venky, Changes related to JP-3600
                           // campaignMemberRec.Status__c = 'Executed'; 
                            campMemberLst.add(campaignMemberRec);
}

else if (campaignMemberRec.Campaign_Id__r.Execution_Type__c == 'eMail' || campaignMemberRec.Campaign_Id__r.Execution_Type__c == 'DM'){
							// Commented by Venky, Changes related to JP-3600
                          //  campaignMemberRec.Status__c = 'Executed';
                          //  campMemberLst.add(campaignMemberRec);
                       }
                           

    } 
    
    
    if(leadLst.size() >0){  
          //  Database.insert(leadLst,false);
                  List<Database.SaveResult> dsrs = Database.Insert(leadLst.Values(), false);
            Integer index = 0;
            for(Database.SaveResult dsr : dsrs){
                if(dsr.issuccess())
                {
                successlist.add(dsr.id);            
                }
                if(!dsr.isSuccess()){
                    for(Id key: leadLst.keySet())
                    {
                  String errMsg = dsr.getErrors()[0].getMessage();
                    errorMap.put(key, errMsg);
                    IdToSObjectMap.put(key, leadLst.values());                        
                    }
                    
                }
                index++;
            }
             for(lead__c leadlsta:leadLst.values()){
            if(camIdCamMemMap.size()>0){
            if(camIdCamMemMap.get(0).Interested_Model__c != null){
             system.debug('++++++Intersted model+++++++'+camIdCamMemMap.get(0).Interested_Model__c);
             VehiclePickerController.converttoleadMethod(leadlsta.id,camIdCamMemMap.get(0).Interested_Model__c);
             camIdCamMemMap.remove(0);
             }
             }
             }
        }
        
if(tskLst.size() >0){
           // insert tskLst;
                   List<Database.SaveResult> dsrs = Database.Insert(tskLst.Values(), false);
            Integer index = 0;
            for(Database.SaveResult dsr : dsrs){
                if(dsr.issuccess())
                {
                successlist.add(dsr.id);            
                }
                if(!dsr.isSuccess()){
                    for(Id key: tskLst.keySet())
                    {
                  String errMsg = dsr.getErrors()[0].getMessage();
                    errorMap.put(key, errMsg);
                    IdToSObjectMap.put(key, tskLst.values());                        
                    }
                    
                }
                index++;
            }
        } 
if(campMemberLst.size() > 0) {
            update campMemberLst;
        }
         if(leadLst.size() >0){
         
         for(Campaign_Member__c campMemberRec : scope){
            for(Lead__c lead : leadLst.values()){
                Campaign_Lead__c cLead = new Campaign_Lead__c(); 
                cLead.Lead__c = lead.id;
                cLead.Campaign__c = lead.Source_Campaign__c;
                cLead.Campaign_Member__c = campMemberRec.id;
               // cLeadLst.add(cLead);
               cLeadLst.put(lead.id,cLead);
                newInsertedLeadId.add(lead.Id);
            }
            }
           // insert cLeadLst;  
                   List<Database.SaveResult> dsrs = Database.Insert(cLeadLst.Values(), false);
            Integer index = 0;
            for(Database.SaveResult dsr : dsrs){
                if(dsr.issuccess())
                {
                successlist.add(dsr.id);            
                }
                if(!dsr.isSuccess()){
                    for(Id key: cLeadLst.keySet())
                    {
                  String errMsg = dsr.getErrors()[0].getMessage();
                    errorMap.put(key, errMsg);
                    IdToSObjectMap.put(key, cLeadLst.values());                        
                    }
                    
                }
                index++;
            }
        }
        
        
     
    }
    private String getDealerIdForDealerAssignment(Campaign_Member__c campaignMemberRec, Map<Id, Id> personAccIdToDealerAccIdMap, Map<String, Id> zipCodeToDealerAccIdMap) {
        String dealerId;
        if(campaignMemberRec.Preferred_Dealer__c != null) {
            dealerId = campaignMemberRec.Preferred_Dealer__c;
        } else if(campaignMemberRec.Contact_Id__c != null) {
            if(personAccIdToDealerAccIdMap.containsKey(campaignMemberRec.Contact_Id__c)) {
                dealerId = personAccIdToDealerAccIdMap.get(campaignMemberRec.Contact_Id__c);
            }
        } 
        
        if(String.isBlank(dealerId)) {
            String zipCode;
            if(campaignMemberRec.Campaign_ID__r.Parent.Campaign_Type__c == 'Finance') {
                zipCode = campaignMemberRec.Zip_Code_Finance__c;
            } else {
                zipCode = campaignMemberRec.Zip_Code__c;
            }
            if(zipCode != null && zipCodeToDealerAccIdMap.containsKey(zipCode)) {
                dealerId = zipCodeToDealerAccIdMap.get(zipCode);
            }
        }
        return dealerId;
    }
    
    public class NotificationWrapper {
        public String userId;
        public String templateId;
        public String whatId;
        
        public NotificationWrapper(String userId, String templateId, String whatId) {
            this.userId = userId;
            this.templateId = templateId;
            this.whatId = whatId;
        }
    }
    
    
    private void setNotificationTemplate(String userId, String templateId, String whatId) {
        notificationWrapperList.add(new NotificationWrapper(userId, templateId, whatId));
    }  
    
    
    private List<String> getCampaignMemberFields() {
        List<String> fieldList = new List<String> {'OwnerId',
                                                    'Contact_Id__c',
                                                    'Special_Flag_to_Include__c',
                                                    'Special_flag_to_Exclude__c',
                                                    'Delinquency_Flag__c',
                                                    'MBF_Anti_Social_flag__c',
                                                    'Offer_Prohibit_Flag__c',
                                                    'Payment_Suspended_Flag__c',
                                                    'Auto_creation_of_tasks__c',
                                                    'Auto_creation_of_leads__c',
                                                    'Auto_creation_of_DM_requests__c',
                                                    'Address__r.Address_Type__c',
                                                    'Preferred_Dealer__c',
                                                    'Campaign_ID__r.Parent.Campaign_Type__c',
                                                    'Campaign_ID__r.Campaign_CCC_Manager__c',
                                                    'Zip_Code_Finance__c',
                                                    'Zip_Code__c',
                                                    'Campaign_ID__r.OwnerId',
                                                    'Company_Name__c',
                                                    'Contract__c',
                                                    'Contract_Phone1_1__c',
                                                    'Contract_Phone2_2__c',
                                                    'Name',
                                                    'Campaign_ID__r.Execution_Type__c',
                                                    'Campaign_Id__r.Execution_Start_Date__c',
                                                    'Vehicle__c',
                                                    'Lead_Type__c',
                                                    'Lead_Sub_Type__c',
                                                    'Interested_Model__c',
                                                    'Finance_Product__c',
                                                    'Term__c',
                                                    'Monthly_Payment__c',
                                                    'Interest_Rate__c',
                                                    'RV_Ballon__c',
                                                    'Total_Vehicle_Price_without_tax__c',
                                                    'Total_Vehicle_Price_with_tax__c',
                                                    'Purchase_Timing__c',
                                                    'Lead_Desired_Service__c',
                                                    'UsVIN__c',
                                                    'Finance_Product_Name__c',
                                                    'Cross_Point_Model__c',
                                                    'Contact_Id__r.personcontactid',
                                                    'Campaign_Id__r.Name'
                                                  
                                                    
                                                };
                                                 
        
        return fieldList;
    }
    
global void finish(Database.BatchableContext bc) {
        system.debug('notificationList\n\n' + notificationWrapperList);
        
        errorMap = new Map<Id, String>();
successMap= new Map<Id, String>();
IdToSObjectMap = new Map<Id, SObject>();
         if(!errorMap.isEmpty() || !successlist.isempty())
     {
         AsyncApexJob a = [SELECT id, ApexClassId,JobItemsProcessed, TotalJobItems,NumberOfErrors, CreatedBy.Email FROM AsyncApexJob WHERE id = :BC.getJobId()];
        // camprec=[Select id,name from campaign where id=:campid Limit 1];
         String body = 'Your batch job '
             + 'CampaignSchedulerAndNotificationJP '
             + 'has finished. and' 
             + 'There were '
             +successlist.size() 
             +'Sucess and '
             + errorMap.size()
             + ' errors. Please find the error list attached to the Case.';
         
         // Creating the CSV file
            String finalstr = 'Id, Name, Error \n';
            String subject = 'CampaignSchedulerAndNotification for - Apex Batch Error List';
            String attName = 'CampaignSchedulerAndNotificationJP.csv';
            for(Id id  : errorMap.keySet()){
                string err = errorMap.get(id);
                Campaign_Member__c acct = (Campaign_Member__c) IdToSObjectMap.get(id);
                string recordString = '"'+id+'","'+acct.Name+'","'+err+'"\n';
                finalstr = finalstr +recordString;
            } 
         // Define the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
 
            // Create the email attachment    
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(attName);
            efa.setBody(Blob.valueOf(finalstr));
 
            // Sets the paramaters of the email
            email.setSubject( subject );
           // email.setToAddresses( new String[] {'dinesh.govindaswamy@nttdata.com'} );
            email.setToAddresses( new String[] {'NTT_Daimler_SO_Team@nttdata.com'} );
            email.setCcAddresses( new String[] {'atsushi.ogihara@nttdata.com'} );
            email.setPlainTextBody( body );
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
 
            // Sends the email
            Messaging.SendEmailResult [] r = 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
 
     }
        
        List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>();
        if( notificationWrapperList !=null)
        {
        for(NotificationWrapper notificationWrapperRec : notificationWrapperList) {
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.SetsaveAsActivity(false);
            msg.setTemplateId(notificationWrapperRec.templateId);
            msg.setTargetObjectId(notificationWrapperRec.userId);  
            msg.setWhatId(notificationWrapperRec.whatId);  
            msgList.add(msg);
        }
        }
        if(msgList.size() > 0) {
            Messaging.sendEmail(msgList);     
        }
    }
    
   
    
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new CampaignSchedulerAndNotificationJP(), 1);
    }
}