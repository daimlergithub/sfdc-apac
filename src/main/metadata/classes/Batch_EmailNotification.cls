global class Batch_EmailNotification implements Database.Batchable<sObject> ,Database.stateful{
    global final Set<id> query;
    global Set<Id> partid=new Set<Id>();
     global List<Participating_Dealer__c> listpart=new List<Participating_Dealer__c>();
    global Batch_EmailNotification  (Set<id> q){
        query = q;
        system.debug('++++++++++++++++++'+query);
        
    }
    
     global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select id,Dealer__c,Dealer__r.Dealer_GC_Code__c,Campaign__c,Dealer__r.Dealer_Sales_Manager_Email__c,Dealer__r.Dealer_Aftersales_Manager_Email__c,Dealer__r.Name,ownerId from Participating_Dealer__c Where Campaign__c =:query ] );
    }
    global void execute(Database.BatchableContext BC, List<Participating_Dealer__c> scope){
    
    Set<Id> sid = New Set<Id>();
    Set<Id> DealerIds = New Set<Id>();
    Set<Id> ParticipateIds = New Set<Id>();
  List<Id> userIds = new List<Id>();
          Map<Id, Map<String, String>> AssignedDealers = new Map<Id, Map<String, String>>();
        Map<Id, List<User>> AssignedDealerRecipients = new Map<Id, List<User>>();
        Set<String> assignedDealerGCCodes = new Set<String>();
        Map<Id, User> AssignedUserMap = new Map<Id, User>();
  List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
   EmailTemplate templateId = [Select id from EmailTemplate where name = 'ListMaintenanceNotification']; 
     
  
     For(Participating_Dealer__c parDealer : scope){
          
          partid.add(parDealer.id);
             DealerIds.add(parDealer.Dealer__c);
             ParticipateIds.add(ParDealer.Id);
          
         assignedDealerGCCodes.add(parDealer.Dealer__r.Dealer_GC_Code__c);
                
                 Map<String, String> GcNdMap = new Map<String, String>();
            GcNdMap.put(parDealer.Dealer__r.Name, parDealer.Dealer__r.Dealer_GC_Code__c);
            AssignedDealers.put(parDealer.Id, GcNdMap);
           }
           
         List<User> userRecords = [Select id,Name,contact.accountId,email,Market__c,Dealer_GC_Code__c,Notification_Campaign__c from User where IsActive = True and contact.AccountId=:DealerIds and ((profile.Name='Japan Dealer Sales Manager') OR (profile.Name='Japan Dealer Service Manager') ) ];
            
            for(User us:userRecords)
            {
                AssignedUserMap.put(us.id,us);
            }
            List<User> userGccodeRecords = [Select id,Name,contact.accountId,email,Market__c,Dealer_GC_Code__c,Notification_Campaign__c from User where IsActive = True and Dealer_GC_Code__c IN : assignedDealerGCCodes];
         
              
        for (Id lid: AssignedDealers.keySet()) {
            List<User> leadAssignedDealerRecipientsList = new List<User>();
            for (User u: userGccodeRecords) {
                for (String assignedDealerName: AssignedDealers.get(lid).keySet()){
                    if (u.Dealer_GC_Code__c == AssignedDealers.get(lid).get(assignedDealerName)){
                        if (u.Notification_Campaign__c != Null){
                            List<String> outletNameList = u.Notification_Campaign__c.split(';');
                            for (String outletName: outletNameList){
                                if (outletName == assignedDealerName){
                                    leadAssignedDealerRecipientsList.add(u);
                                }
                            }
                        }
                    }
                }
            }
            AssignedDealerRecipients.put(lid, leadAssignedDealerRecipientsList);
        }
        /* If(DealerIds.size() >0){
             
          List<User> UseList = [Select id,profile.name,email,contactId,contact.AccountId from User where contact.AccountId=:DealerIds AND ((profile.Name='Japan Dealer Sales Manager') OR (profile.Name='Japan Dealer Service Manager') ) ]; 
          
          For(Participating_Dealer__c parDealer : Scope){
          For(User u : UseList  )
          { 
          
          If(u.contact.AccountId == parDealer.Dealer__c){
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         mail.saveAsActivity = false;
         mail.setTargetObjectId(u.Id);
       
         mail.setWhatId(parDealer.Id);
        
         mail.setTemplateID(templateId.Id); 
         mail.setUseSignature(false);
         mail.setSaveAsActivity(false);
              
       mails.add(mail); 
      }     
   }
       
         
    }
     Messaging.sendEmail(mails);
             
             
             
  
   } */
    
    
     sendMail(AssignedUserMap,AssignedDealerRecipients);     
    
    }
    
     //SENDING EMAILS TO SALES MANAGERS  
    public void sendMail(Map<Id, User> AssignedUserMap,Map<Id, List<User>> AssignedDealerRecipients){        
        List<Id> userIds = new List<Id>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        if(partid !=null)
        {
        listpart=[Select id,Dealer__c,Dealer__r.Dealer_GC_Code__c from Participating_Dealer__c where id=:partid];
        }
        
        EmailTemplate e =  [select id,name from EmailTemplate WHERE NAME =: 'ListMaintenanceNotification' limit 1];
        System.debug('@@@@@@@@@@@@@@AssignedDealerRecipients'+AssignedDealerRecipients);
        System.debug('@@@@@@@@@@@@@@AssignedUserMap'+AssignedUserMap);
        System.debug('@@@@@@@@@@@@@@AssignedDealerRecipients'+AssignedDealerRecipients);
        
        for(Participating_Dealer__c pd:listpart)
        {
       
         for(Id lid : AssignedUserMap.keySet()){ 
         for(user usd:AssignedUserMap.values())
         {
           
         if( usd.contact.AccountID==pd.Dealer__c && usd.id==lid)  
         {       
            if (AssignedUserMap.get(lid).Id != null){
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.saveAsActivity = false;
                mail.setTargetObjectId(AssignedUserMap.get(lid).Id);
                mail.setTemplateId(e.Id);
                if (AssignedUserMap.get(lid).Market__c == 'JP'){
                    mail.setCharset('JIS');
                }
                mail.setUseSignature(false);
                mail.setWhatId(pd.id);
                mail.setSaveAsActivity(false);
                mails.add(mail);
            }
            }
            }
        }
        
        if(AssignedDealerRecipients !=null)
        {
        
        for(Id lid : AssignedDealerRecipients.keySet()){
             System.debug('@@@@@@@@@@@@@@AssignedDealerRecipients'+AssignedDealerRecipients);
            for (User u: AssignedDealerRecipients.get(lid)) {
                 System.debug('@@@@@@@@@@@@@@AssignedDealerRecipients'+AssignedDealerRecipients);
                if (u.Id != null  && u.Dealer_GC_Code__c==pd.Dealer__r.Dealer_GC_Code__c && pd.id==lid){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.saveAsActivity = false;
                    mail.setTargetObjectId(u.Id);
                    mail.setTemplateId(e.Id);
                    if (u.Market__c == 'JP'){
                        mail.setCharset('JIS');
                    }
                    mail.setUseSignature(false);
                    mail.setWhatId(pd.id);
                    mail.setSaveAsActivity(false);
                    mails.add(mail);
                }
            }
        }
           }
            }
           System.debug('@@@@@@@@@@@@@@mails '+mails );  
           if(mails !=null)
           {
           Messaging.sendEmail(mails);
           }  
        
        
       
    }
    
    global void finish(Database.BatchableContext BC){
       

}
    
    
    
    
    
    }