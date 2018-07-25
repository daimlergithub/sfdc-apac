global class Batch_EmailNotification implements Database.Batchable<sObject> ,Database.stateful{
    global final Set<id> query;
    
    global Batch_EmailNotification  (Set<id> q){
        query = q;
        system.debug('++++++++++++++++++'+query);
        
    }
    
     global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select id,Dealer__c,Campaign__c,Dealer__r.Dealer_Sales_Manager_Email__c,Dealer__r.Dealer_Aftersales_Manager_Email__c,Dealer__r.Name,ownerId from Participating_Dealer__c Where Campaign__c =:query ] );
    }
    global void execute(Database.BatchableContext BC, List<Participating_Dealer__c> scope){
    
    Set<Id> sid = New Set<Id>();
    Set<Id> DealerIds = New Set<Id>();
    Set<Id> ParticipateIds = New Set<Id>();
  List<Id> userIds = new List<Id>();
  List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
   EmailTemplate templateId = [Select id from EmailTemplate where name = 'ListMaintenanceNotification']; 
     
  
     For(Participating_Dealer__c parDealer : scope){
          
          
             DealerIds.add(parDealer.Dealer__c);
             ParticipateIds.add(ParDealer.Id);
          
           }
           
         
         If(DealerIds.size() >0){
          List<User> UseList = [Select id,profile.name,email,contactId,contact.AccountId from User where isActive =true AND contact.AccountId=:DealerIds AND ((profile.Name='Japan Dealer Sales Manager') OR (profile.Name='Japan Dealer Service Manager') ) ]; 
          
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
  
   } 
    
    
    
    
    }
    
    
    
    global void finish(Database.BatchableContext BC){
       

}
    
    
    
    
    
    }