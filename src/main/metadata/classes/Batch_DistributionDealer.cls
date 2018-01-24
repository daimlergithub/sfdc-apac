global class Batch_DistributionDealer implements Database.Batchable<sObject> ,Database.stateful{
    global final String query;
    
    global Batch_DistributionDealer (String q){
        query = q;
        system.debug('++++++++++++++++++'+query);
        
    }
    
     global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select id ,Name ,Preferred_Dealer__c,Campaign_ID__c, Contact_Id__c   from campaign_Member__c WHERE Campaign_ID__c =: query AND Preferred_Dealer__c != null ] );
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
                      dlist.List_Maintenance_CM_Status__c ='Ready';
                      dlist.NewAccount__c =CamMem.Contact_Id__c;
                   dealerMainList.add(dlist);
      
    }
    
    if(dealerMainList != null){
    Database.insert(dealerMainList,false);
    
    }
    
    }
    global void finish(Database.BatchableContext BC){
       
     List<Campaign> newcamlist = New List<campaign>();
     List<Campaign> Camlist =[Select id,Distribution_is_completed__c From Campaign Where id =:query];
     
     For(Campaign cam :Camlist){
     
     cam.Distribution_is_completed__c = true;
     
     newcamlist.add(cam);
     }
     Update newcamlist;

}
    
    
    
    }