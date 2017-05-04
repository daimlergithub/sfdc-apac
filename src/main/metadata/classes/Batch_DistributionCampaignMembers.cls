/***********************************************************************************
Created By          :    Abhishekh Dasepalle   
Company             :    NTT Data,Inc.
Usage               :    The functionality used to send a mail of campaign members list who doesnt have preferred dealer after distribution
                         
                                              
JIRA NO             :        SFDCJP-2209                                             
************************************************************************************/
global class Batch_DistributionCampaignMembers implements Database.Batchable<SObject>, Database.Stateful, Schedulable {
    
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        Date today = Date.Today();
        String query = 'Select Id,Name,OwnerId,Distribution_is_completed__c,Email_Notification_to_Owner__c,(select Name From Campaign_Members1__r where Preferred_Dealer__c = null)From Campaign Where Distribution_is_completed__c = true AND Email_Notification_to_Owner__c = false';
         system.debug('+++++++ Query'+query);
        return Database.getQueryLocator(query);
         
    }
    
    
    global void execute(Database.BatchableContext bc, List<Campaign> scope) {
      
      String MainString = '';
       List<Campaign> campListMain = new List<Campaign>();
       List<Messaging.SingleEmailMessage> msgList= new List<Messaging.SingleEmailMessage>(); 
      For(Campaign cam : Scope){
        
        system.debug('+++++++++++'+Scope);
        
        for(Campaign_Member__c camp : cam.Campaign_Members1__r){

              
             String Recordmain= camp.id+','+camp.Name+'\n';
           MainString = MainString +Recordmain ;

   


        }
        system.debug('+++++++++++++++'+MainString );
       
       Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
       blob csvBlob = Blob.valueOf(MainString);
       string csvname= 'Non_Distributed_CM.csv';
       csvAttc.setFileName(csvname);
       csvAttc.setBody(csvBlob);
       Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
       //String[] toAddresses = new list<string> {'test@test.com};
       String subject ='Non Distributed Campaign Members';
       email.setSubject(subject);
       email.setTargetObjectId(cam.OwnerId);  
       //email.setToAddresses( toAddresses );
       email.setPlainTextBody('Campaign Name '+cam.Name);
       email.SetsaveAsActivity(false); 
       email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
       //Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
       msgList.add(email);
       
       cam.Email_Notification_to_Owner__c = true;
        campListMain.add(cam);
               
      }     
      update campListMain;
    Messaging.sendEmail(msgList);    
       //MainString.clear();
    }
    
    global void finish(Database.BatchableContext bc) {
      
      
    
    
    }
      
       
       global void execute(SchedulableContext ctx) {
       
       Batch_DistributionCampaignMembers batchSch = New Batch_DistributionCampaignMembers();
       
        Database.executeBatch(new Batch_DistributionCampaignMembers(),1);
        //System.schedule('Batch Schedule', sch , batchSch);
    }
}