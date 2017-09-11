public class CamapaignLeadsHelperTH{
    public void updateCampaignleads(list<Campaign_lead__c> campleads){
        List<Id> lelst=new List<Id>();
        Map<ID,ID> updatelst=new Map<ID,ID>();
        for(campaign_lead__c camplead:campleads){
        lelst.add(camplead.Lead__c);
        }
        List<Lead__c> leadlist=[Select id,Contact__c from Lead__c where id=:lelst];
        for(Lead__c lst:leadlist){
            if(lst.contact__c!=null){
            updatelst.put(lst.id,lst.contact__c);
          
            }
        }
        for(Campaign_lead__c c:campleads){
        c.contact__c=updatelst.get(c.lead__c);
                }
        }     
}