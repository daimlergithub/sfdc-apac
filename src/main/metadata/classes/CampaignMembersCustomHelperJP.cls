/*
    Type:       Trigger
    Purpose:    CampaignMemberCustomHelper
    User Story:     
    Used By:    
    ---------------------------------------------------------------
    History:
    
    
*/
public with sharing class CampaignMembersCustomHelperJP {
    
    /*
        * Added By: Siva Krishna
        * Desc: trigger handler code for Custom Campaignmember
        * Updated: February 2, 2017
        */
    
    public static void afterUpdateOperation(Map<Id, Campaign_Member__c> oldMap, Map<Id, Campaign_Member__c> newMap, List<Campaign_Member__c> newList) {
        Set<Id> campaignIdSet = new Set<Id>(); 
        String FINAL_CAMPAIGN_STATUS = 'Response collection';
        Set<String> campaignMemberStatusSet = new Set<String>{'Bounced', 'Responded', 'Not Responded'};
        for(Campaign_Member__c campaignMemberRec : newList) {
            if(oldMap.get(campaignMemberRec.Id).Status__c == 'Executed' && campaignMemberStatusSet.contains(newMap.get(campaignMemberRec.Id).Status__c)) {
                campaignIdSet.add(campaignMemberRec.Campaign_ID__c);
            }
        }
        
        List<Campaign> campaignList = [select Name, Child_Campaign_Status__c from Campaign where Id =: campaignIdSet]; 
        for(Campaign campaignRec : campaignList) {
            campaignRec.Child_Campaign_Status__c = FINAL_CAMPAIGN_STATUS;
        }
        if(campaignList.size() > 0) {
            update campaignList;
        }
    }
}
       /*
         Added By: Siva Krishna
        */