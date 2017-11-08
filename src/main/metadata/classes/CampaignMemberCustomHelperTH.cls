public class CampaignMemberCustomHelperTH{
Map<ID,String> retcampstatus=new MAP<Id,String>();
//if the status of parent campaign is Execution or response collection or completed then it will not allow to add the campaign members
public void  campaignMemberHelperBeforeInsert(List<Campaign_Member__c> campmember){
    List<ID> retcamplst=new List<ID>();
    List<Retail_Campaign__c> retcamplststatus=new List<Retail_Campaign__c>();
    for(Campaign_Member__c camp:campmember){
        if(camp.Retail_Campaign_Id__c!=null){
        system.debug('hellordfdkdkdkfjfd'+camp.Retail_Campaign_Id__c);
        retcamplst.add(camp.Retail_Campaign_Id__c);
        }
    }
   system.debug(retcamplst);
    retcamplststatus=[Select id,Child_Campaign_Status__c from Retail_Campaign__c where id IN : retcamplst and Child_Campaign_Status__c!=''];
    
    for(Retail_Campaign__c camp: retcamplststatus){
            
            retcampstatus.put(camp.id,camp.Child_Campaign_Status__c);
            system.debug(camp.Child_Campaign_Status__c+'%%%%%');
        
    }
    for(Campaign_Member__c camp:campmember){
        system.debug('****'+camp.Retail_Campaign_Id__c);
        if(camp.Retail_Campaign_Id__c!=null){
            system.debug('$$$$$$'+camp.Retail_Campaign_Id__c+'   '+retcampstatus.get(camp.Retail_Campaign_Id__c));
            if(retcampstatus.get(camp.Retail_Campaign_Id__c)=='Response collection'||retcampstatus.get(camp.Retail_Campaign_Id__c)=='Completed'){
                camp.addError('You Can Not Add Campaign Members with Retail Campaign Status Response Collection/Completed');
            }
        }
    
    }
    
    }
    //Will allow to delete the campaign members with the campaign status "segmentation 
     public static void beforeDeleteOperation(List<Campaign_Member__c> oldList) {
        List<String> CHILD_CAMPAIGN_STATUS_LIST = new List<String> {'Response collection', 'Completed'};//'Execution',
        Map<Id, Campaign_Member__c> campaignMemberMap = 
                    new Map<Id, Campaign_Member__c>([select Id from Campaign_Member__c where Id IN: oldList and Retail_Campaign_Id__r.Child_Campaign_Status__c IN: CHILD_CAMPAIGN_STATUS_LIST ]);
        
        for(Campaign_Member__c campaignMemberRec : oldList) {
            if(campaignMemberMap.containsKey(campaignMemberRec.Id)) {
                campaignMemberRec.addError('You can\'t delete the Campaign Member for this Campaign Status.');
            }
        }
    }


}
