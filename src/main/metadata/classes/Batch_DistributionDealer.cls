global class Batch_DistributionDealer implements Database.Batchable<sObject> ,Database.stateful{
    global final String query;
      global Map<Id, String> errorMap {get; set;}
  global Map<Id, String> successMap {get; set;}
   global list<Id> successlist=new list<ID>();
  global Map<Id, SObject> IdToSObjectMap {get; set;}
    global Batch_DistributionDealer (String q){
        query = q;
        system.debug('++++++++++++++++++'+query);
        
    }
    
     global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select id ,Name,Retail_Copy__c,Vehicle_ExternalLink__c,Missing_Flag__c,Preferred_Dealer__c,Campaign_ID__c, Contact_Id__c   from campaign_Member__c WHERE Campaign_ID__c =: query AND Preferred_Dealer__c != null ] );
    }
    
    global void execute(Database.BatchableContext BC, List<Campaign_Member__C> scope){
    Set<Id> sid = New Set<Id>();
    Set<Id> camid = New Set<Id>();
    Map<Id, Id> dealerMap = New Map<Id,Id>();
    
    List<Dealer_List_Member__c> dealerMainList = New List<Dealer_List_Member__c>();
    
    For(Campaign_Member__c CamMem : Scope){
            
                   sid.add(camMem.Preferred_Dealer__c);
                   camid.add(camMem.Campaign_ID__c);
         
         }
    
     List<Participating_Dealer__c> ParticipateDealer = [Select id,Name,Campaign__c,Dealer__c From Participating_Dealer__c Where Campaign__c =: camid And Dealer__c =:sid];
    
      For(Participating_Dealer__c pardeal : ParticipateDealer ){
      
                 dealerMap.put(pardeal.Dealer__c ,pardeal.Id);
      
      
      } 
      
       For(Campaign_Member__c CamMem : Scope){
            
                                     
                      Dealer_List_Member__c dlist = New Dealer_List_Member__c();
                      dlist.Campaign__c = CamMem.Campaign_ID__c;
                      if(dealerMap.get(camMem.Preferred_Dealer__c) != null){
                      dlist.Participating_Dealer__c = dealerMap.get(camMem.Preferred_Dealer__c);
                      }
                      dlist.Campaign_Member__c = CamMem.id;
                      if(cammem.Missing_Flag__c ==true)
                      {
                       dlist.List_Maintenance_CM_Status__c ='Removed';
                       dlist.Reason_for_the_removal__c = '管理外フラグ' ;
                      }
                      if(cammem.Missing_Flag__c ==false)
                      {
                      dlist.List_Maintenance_CM_Status__c ='Ready'; 
                      }
                      dlist.NewAccount__c =CamMem.Contact_Id__c;
                      if(CamMem.Vehicle_ExternalLink__c !=null)
                      {
                      dlist.Vehicle_ExternalLink__c=CamMem.Vehicle_ExternalLink__c;
                      }
                      if(CamMem.Retail_Copy__c !=null)
                      {
                      dlist.Retail_Copy__c=CamMem.Retail_Copy__c;
                      }
                   dealerMainList.add(dlist);
      
    }
    
    if(dealerMainList != null){
    Database.insert(dealerMainList,false);
    
    }
    
    }
    global void finish(Database.BatchableContext BC){
    errorMap = new Map<Id, String>();
successMap= new Map<Id, String>();
IdToSObjectMap = new Map<Id, SObject>();
    
    if(!errorMap.isEmpty() || !successlist.isempty())
     {
         AsyncApexJob a = [SELECT id, ApexClassId,JobItemsProcessed, TotalJobItems,NumberOfErrors, CreatedBy.Email FROM AsyncApexJob WHERE id = :BC.getJobId()];
       
         String body = 'Your batch job '
             + 'Batch_DistributionDealer '
             + 'has finished. and' 
             + 'There were '
             +successlist.size() 
             +'Sucess and '
             + errorMap.size()
             + ' errors. Please find the error list attached to the Case.';
         
         // Creating the CSV file
            String finalstr = 'Id, Name, Error \n';
           String subject = 'Distribution Dealer for - Apex Batch Error List';
            String attName = 'Distribution Dealer.csv';
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
    
       
     List<Campaign> newcamlist = New List<campaign>();
     List<Campaign> Camlist =[Select id,Distribution_is_completed__c From Campaign Where id =:query];
     
     For(Campaign cam :Camlist){
     
     cam.Distribution_is_completed__c = true;
     
     newcamlist.add(cam);
     }
     Update newcamlist;

}
    
    
    
    }