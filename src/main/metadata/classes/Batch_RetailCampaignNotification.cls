global class Batch_RetailCampaignNotification implements Database.Batchable<sObject> ,Database.stateful{
  global set<id> campid=new set<Id>(); 
  global  Map<id,Retail_campaign__c> Maplist; 
   global List<Retail_Campaign__c> retCampList; 
    
    global Batch_RetailCampaignNotification (set<id> retailIds){
    
      System.debug('%%%%%%%%%%%%%%%%%%%%%%%% retailIds'+retailIds);
      campid=retailIds;
         System.debug('%%%%%%%%%%%%%%%%%%%%%%%% campid'+campid);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    
    System.debug('%%%%%%%%%%%%%%%%%%%%%%%% campid'+campid);
        return Database.getQueryLocator([Select Id,Parent_Campaign__c,RecordTypeId  From Retail_Campaign__c where id =:campid ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Retail_Campaign__c> scope){
    
    Id parentCampaignId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
Id childCampaign= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
  List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
   Set<Id> retId = New Set<Id>(); 
   Set<Id> sid = New Set<Id>();
   String mailSales ;
     system.debug('@@@@@  retList   retCampList'+retCampList);
  For(Retail_Campaign__c  camp : scope){
  
   if(camp.Parent_Campaign__c != null && camp.RecordTypeId == childCampaign ){
   
   
        sid.add(camp.Parent_Campaign__c);
        retId.add(camp.Id);
         }
  
    
    
  }
   system.debug('@@@@@  retList   retList '+sid);
    system.debug('@@@@@  retList   retList '+retId);
  EmailTemplate templateId = [Select id from EmailTemplate where name = 'Dealer Campaign Notification'];
  //List<Campaign> CamList = [Select id,Name,Parent.Campaign_Type__c,(Select id,Dealer__c,Dealer__r.Dealer_Sales_Manager_Email__c,Dealer__r.Dealer_Aftersales_Manager_Email__c,Dealer__r.Name,ownerId from Participating_Dealers__r) from Campaign Where Id =:sid];
     List<Retail_Campaign__c> retList =[Select id,owner.id,Dealer_Name__c,Dealer_Name__r.id From Retail_Campaign__c Where Id =: retId];
  
   system.debug('@@@@@  retList   retList '+retList );
  For(Retail_Campaign__c reCampaign : retList ){
         if(!Test.isRunningTest()){
          
          if(reCampaign.Dealer_Name__c !=null)
          {
          for(User u : [Select id,profile.name,email,contactId,contact.AccountId from User where IsActive=true and contact.AccountId=:reCampaign.Dealer_Name__r.id AND ((profile.Name='Japan Dealer Sales Manager') OR (profile.Name='Japan Dealer Service Manager') ) ])
          
          {
          system.debug('@@@@@EmailNotification'+u.Id);
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.saveAsActivity = false;
        mail.setTargetObjectId(u.Id);
        //mail.setToAddresses(toaddress);
        mail.setWhatId(reCampaign.Id);
        
        mail.setTemplateID(templateId.Id); 
        mail.setUseSignature(false);
        mail.setSaveAsActivity(false);
            
               
               
               
            mails.add(mail);   
         }
         }
            }
            }
  Messaging.sendEmail(mails);
        
    
    }
    
    global void finish(Database.BatchableContext BC){
    

}
}

