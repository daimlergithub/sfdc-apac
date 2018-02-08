global class Batch_CampaignmemberInsertion implements Database.Batchable<sObject> ,Database.stateful{
  global final set<id> campid; 
  global final Map<id,Retail_campaign__c> Maplist; 
    
    global Batch_CampaignmemberInsertion( Map<id,Retail_Campaign__c> newmaplist,Set<id> campeid){
    
      campid = campeid;
      Maplist = newmaplist;
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id,Name,Retail_Campaign_Id__c,Status__c,Preferred_Dealer__c,contact_Id__c From Campaign_Member__c Where Campaign_id__c =: campid ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Campaign_Member__c> scope){
    List<Campaign_Member__c > retailMem = New List<Campaign_Member__c >();
    Map<id,id> MapMainList = New Map<Id,id>();
    List<Retail_Campaign__c> rett = [Select id,Dealer_Name__c,Parent_Campaign__c From Retail_Campaign__c Where Parent_Campaign__c =: Campid];
    
    For(Retail_Campaign__c retmain : rett){
    
    
   MapMainList.put(retmain.Dealer_Name__c , retmain.id);
    
    }
    For(Campaign_Member__c camo : scope){
    
    if(camo.Status__c !='Removed'){ 
                 system.debug('++++++++++++++++'+Maplist.size());
                 Campaign_Member__c newCamRetail = new Campaign_Member__c();
                if(MapMainList.get(camo.Preferred_Dealer__c) != null){
                 newCamRetail.Retail_Campaign_Id__c =MapMainList.get(camo.Preferred_Dealer__c);
                 }
                 
                 system.debug('++++++++++===='+MapMainList.get(camo.Preferred_Dealer__c));
                 newCamRetail.Status__c = camo.Status__c;
                 newCamRetail.Preferred_Dealer__c = camo.Preferred_Dealer__c;
                 newCamRetail.contact_Id__c = camo.contact_Id__c;
                  retailMem.add(newCamRetail);   
     
     }
     }
     
     insert retailMem;
    
    
    
        
    
    }
    
    global void finish(Database.BatchableContext BC){
    
      
    }

}