global class Batch_CampaignmemberInsertion implements Database.Batchable<sObject> ,Database.stateful{
  global final set<id> campid; 
  global final Map<id,Retail_campaign__c> Maplist; 
    
    global Batch_CampaignmemberInsertion( Map<id,Retail_Campaign__c> newmaplist,Set<id> campeid){
    
      campid = campeid;
      Maplist = newmaplist;
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select Id,Name,Retail_Campaign_Id__c,Status__c,Preferred_Dealer__c,Contract__c,contact_Id__c,Address__c,Customer_Complete_Address__c,NextInspectionDate__c,NextServiceDate__c,LastInspectionDate__c,LastServiceDate__c,LastWorkDate__c,Service_Advisor__c,Sales_Consultant__c,Vehicle__c,Vehicle_Relationship__c,CUSTOMER_LABEL_NAME__C,Retail_Copy__c,Vehicle_ExternalLink__c From Campaign_Member__c Where Campaign_id__c =: campid ]);
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
                 
                 if(camo.Address__c !=null)
                 {
                  newCamRetail.Address__c = camo.Address__c;
                 }
                 if(camo.Customer_Complete_Address__c !=null)
                 {
                  newCamRetail.Customer_Complete_Address__c = camo.Customer_Complete_Address__c;
                 }
                  
                  if(camo.NextInspectionDate__c !=null)
                 {
                   newCamRetail.NextInspectionDate__c = camo.NextInspectionDate__c;
                 }
                  if(camo.NextServiceDate__c !=null)
                 {
                  newCamRetail.NextServiceDate__c = camo.NextServiceDate__c;
                 }
                  if(camo.LastInspectionDate__c !=null)
                 {
                  newCamRetail.LastInspectionDate__c = camo.LastInspectionDate__c;
                 }
                  if(camo.LastServiceDate__c !=null)
                 {
                 newCamRetail.LastServiceDate__c = camo.LastServiceDate__c;
                 }
                  if(camo.LastWorkDate__c !=null)
                 {
                  newCamRetail.LastWorkDate__c = camo.LastWorkDate__c;
                 }
                 if(camo.Service_Advisor__c !=null)
                 {
                  newCamRetail.Service_Advisor__c = camo.Service_Advisor__c;
                 } 
                 if(camo.Sales_Consultant__c !=null)
                 {
                 newCamRetail.Sales_Consultant__c = camo.Sales_Consultant__c;
                 }
                 if(camo.Vehicle__c !=null)
                 {
                newCamRetail.Vehicle__c = camo.Vehicle__c;
                 }
                 if(camo.Vehicle_Relationship__c !=null)
                 {
                newCamRetail.Vehicle_Relationship__c = camo.Vehicle_Relationship__c;
                 }
                 if(camo.CUSTOMER_LABEL_NAME__C !=null)
                 {
                  newCamRetail.CUSTOMER_LABEL_NAME__C = camo.CUSTOMER_LABEL_NAME__C;
                 }
                 if(camo.Retail_Copy__c !=null)
                 {
                newCamRetail.Retail_Copy__c = camo.Retail_Copy__c;
                 }
                 if(camo.Vehicle_ExternalLink__c !=null)
                 {
                  newCamRetail.Vehicle_ExternalLink__c = camo.Vehicle_ExternalLink__c;
                 }
                  if(camo.Contract__c !=null)
                 {
                  newCamRetail.Contract__c = camo.Contract__c;
                 }
                 
                 
                
                  retailMem.add(newCamRetail);   
     
     }
     }
     
     insert retailMem;
    
    
    
        
    
    }
    
    global void finish(Database.BatchableContext BC){
    
      
    }

}