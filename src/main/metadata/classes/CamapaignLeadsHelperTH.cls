public class CamapaignLeadsHelperTH{
    public void updateCampaignleads(list<Campaign_lead__c> campleads){
        List<lead__c> lelst=new List<lead__c>();
        List<Campaign_lead__c> campleadslist=[select id,contact__c,lead__r.contact__c from campaign_lead__c where id =:campleads];
        for(Campaign_lead__C cl:campleadslist){
            lelst.add(cl.lead__r);
        }
        Map<id, id> leadaccMap = new Map<id, id>();
        List<Lead__c> leadList=[select Contact__C from lead__C where id=:lelst];
        for(Lead__c le:leadList){
            if(le.Contact__C !=null){
                leadaccMap .put(le.id,le.Contact__C); 
              }
        }   
        for(Campaign_lead__c lists:campleads){
            lists.Contact__c= leadaccMap .get(lists.Lead__c);                
        }
    
     }
}