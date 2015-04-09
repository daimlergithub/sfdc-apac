/*
    Type:       Class
    Purpose:    Detail in Campaign Offering or Campaign Package or Participating Dealer is created or updated or deleted 
    User Story: US-Cpn-017

    Used By:    Trigger
    ---------------------------------------------------------------
    History:

    18-June-2013 Stephano.shi (Breakingpoint)    Created
*/
public class campaignHistoryLogGeneration{
 List<Campaign_history_log__c>  lstCampaign_history=new List<Campaign_history_log__c>();
    public void logGeneration(String type, String objId, String action, Id cm, Id us, String objName){
        // LOG Record
    	Campaign_history_log__c chl = new Campaign_history_log__c();
        chl.Object_Type__c = type;	// What type of reocrd
        chl.Object_ID__c = objId;	// Object id
        chl.Action__c = action;		// What operation
        chl.Campaign__c = cm;		// What campaign releated
        chl.User__c = us;			// Who makes the operation
        chl.Object_Name__c = objName;
        lstCampaign_history.add(chl);
            
        if(cm != null)
        	insert lstCampaign_history;
    }
}