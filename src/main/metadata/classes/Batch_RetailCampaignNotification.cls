global class Batch_RetailCampaignNotification implements Database.Batchable<sObject> ,Database.stateful{
  global set<id> campid=new set<Id>(); 
  global set<id> Retcampid=new set<Id>(); 
  global  Map<id,Retail_campaign__c> Maplist; 
   global List<Retail_Campaign__c> retCampList; 
    global List<Retail_Campaign__c> ListretCampList=new List<Retail_Campaign__c>(); 
    
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
         Map<Id, Map<String, String>> AssignedDealers = new Map<Id, Map<String, String>>();
        Set<Id> dealerAccId=new Set<Id>();
        Map<Id, List<User>> AssignedDealerRecipients = new Map<Id, List<User>>();
        Map<Id, User> AssignedUserMap = new Map<Id, User>();
   Set<Id> retId = New Set<Id>(); 
   Set<Id> sid = New Set<Id>();
        Set<Id> retCamDealerID = new Set<Id>();
        Set<String> assignedDealerGCCodes = new Set<String>();
   String mailSales ;
     system.debug('@@@@@  retList   retCampList'+retCampList);
  For(Retail_Campaign__c  camp : scope){
  
   if(camp.Parent_Campaign__c != null && camp.RecordTypeId == childCampaign ){
   Retcampid.add(camp.id);
   
        sid.add(camp.Parent_Campaign__c);
        retId.add(camp.Id);
         }
  
    
    
  }
   system.debug('@@@@@  retList   retList '+sid);
    system.debug('@@@@@  retList   retList '+retId);
  EmailTemplate templateId = [Select id from EmailTemplate where name = 'Dealer Campaign Notification'];
  //List<Campaign> CamList = [Select id,Name,Parent.Campaign_Type__c,(Select id,Dealer__c,Dealer__r.Dealer_Sales_Manager_Email__c,Dealer__r.Dealer_Aftersales_Manager_Email__c,Dealer__r.Name,ownerId from Participating_Dealers__r) from Campaign Where Id =:sid];
     List<Retail_Campaign__c> retList =[Select id,owner.id,Dealer_Name__r.Name,Dealer_Name__c,Dealer_Name__r.id,Dealer_Name__r.Dealer_GC_Code__c From Retail_Campaign__c Where Id =: retId];
         
        
   if(Label.Batch_RetailCampaignNotification=='Batch_RetailCampaignNotification')
   {
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
        if(Label.Batch_RetailCampaignNotification !='Batch_RetailCampaignNotification')
          {
            if(retList !=null)
        {
            for(Retail_Campaign__c retCmp:retList)
            {
                retCamDealerID.add(retCmp.Dealer_Name__c);
                assignedDealerGCCodes.add(retCmp.Dealer_Name__r.Dealer_GC_Code__c);
                dealerAccId.add(retCmp.Dealer_Name__r.id);
                 Map<String, String> GcNdMap = new Map<String, String>();
            GcNdMap.put(retCmp.Dealer_Name__r.Name, retCmp.Dealer_Name__r.Dealer_GC_Code__c);
            AssignedDealers.put(retCmp.Id, GcNdMap);
            }
       List<User> userRecords = [Select id,Name,contact.accountId,email,Market__c,Notification_Campaign__c,Dealer_GC_Code__c from User where IsActive = True and contact.AccountId=:dealerAccId and ((profile.Name='Japan Dealer Sales Manager') OR (profile.Name='Japan Dealer Service Manager') )];            
            for(User us:userRecords)
            {
                AssignedUserMap.put(us.id,us);
            }
            List<User> userGccodeRecords = [Select id,contact.accountId,Name,email,Market__c,Dealer_GC_Code__c,Notification_Campaign__c,Notification_Lead_No_Update__c from User where IsActive = True and Dealer_GC_Code__c IN : assignedDealerGCCodes];
            
            
        
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
            
        }      
           }
         
        sendMail(AssignedUserMap,AssignedDealerRecipients);     
        
            
    }
     //SENDING EMAILS TO SALES MANAGERS  
    public void sendMail(Map<Id, User> AssignedUserMap,Map<Id, List<User>> AssignedDealerRecipients){        
        List<Id> userIds = new List<Id>();
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        if(Retcampid !=null)
        {
        ListretCampList=[Select id,Dealer_Name__c,Dealer_Name__r.Dealer_GC_Code__c from Retail_Campaign__c where id=:Retcampid]; 
        }
       
        EmailTemplate e =  [select id,name from EmailTemplate WHERE NAME =: 'Dealer Campaign Notification' limit 1];
        System.debug('@@@@@@@@@@@@@@AssignedDealerRecipients'+AssignedDealerRecipients);
        
        for(Retail_Campaign__c rets:ListretCampList)
        {
         for(Id lid : AssignedUserMap.keySet()){  
         for(user usd:AssignedUserMap.values())
         {          
         if( usd.contact.AccountID==rets.Dealer_Name__c && usd.id==lid)  
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
                mail.setWhatId(rets.id);
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
                if (u.Id != null  && u.Dealer_GC_Code__c==rets.Dealer_Name__r.Dealer_GC_Code__c && rets.id==lid){
                    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    mail.saveAsActivity = false;
                    mail.setTargetObjectId(u.Id);
                    mail.setTemplateId(e.Id);
                    if (u.Market__c == 'JP'){
                        mail.setCharset('JIS');
                    }
                    mail.setUseSignature(false);
                    mail.setWhatId(rets.id);
                    mail.setSaveAsActivity(false);
                    mails.add(mail);
                }
            }
        }
            
         }
         }
         if(mails !=null)
         {
           Messaging.sendEmail(mails);
         }
      
       
    }
    
    global void finish(Database.BatchableContext BC){
    

}
}