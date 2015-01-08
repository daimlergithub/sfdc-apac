/*
    Type:       Trigger
    Purpose:    Update campaign city start/end date 
    User Story: 
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1.  Chris Created on 2013-08-15
*/

trigger TriggerParticipatingDealerCityDate on Participating_Dealer__c (after insert, after update, after delete) {
    if (!UtilCustomSettings.isEnabled('TriggerParticipatingDealerCityDate')) {
        return;
    }
    
    Participating_Dealer__c pd = Trigger.isDelete ? Trigger.old[0] : Trigger.new[0];

    if(pd.Campaign__c != null) {

        Campaign cam = [
            Select 
                (Select Dealer_City__c, Session_End_Date__c, Session_Start_Date__c From Participating_Dealers__r), 
                (Select Dealer_City__r.Name, End_Date__c, Start_Date__c From Campaign_Cities__r) 
            From Campaign 
            Where Id =: pd.Campaign__c];

        Map<String, Campaign_City__c> cMap = new Map<String, Campaign_City__c>();
        for(Campaign_City__c cc : cam.Campaign_Cities__r) {
            cc.Start_Date__c = null;
            cc.End_Date__c = null;
            cMap.put(cc.Dealer_City__r.Name, cc);   
        }

        for (Participating_Dealer__c dealer : cam.Participating_Dealers__r) {
            if (dealer.Dealer_City__c != null && cMap.containsKey(dealer.Dealer_City__c)) {
                Campaign_City__c cc = cMap.get(dealer.Dealer_City__c);
                if (dealer.Session_Start_Date__c != null 
                    && (cc.Start_Date__c == null || dealer.Session_Start_Date__c < cc.Start_Date__c)) {
                    cc.Start_Date__c = dealer.Session_Start_Date__c;
                }
                if (dealer.Session_End_Date__c != null 
                    && (cc.End_Date__c == null || dealer.Session_End_Date__c > cc.End_Date__c)) {
                    cc.End_Date__c = dealer.Session_End_Date__c;
                }
            }
        }

        if (!cMap.isEmpty()) {
            update cMap.values();
        }
    }

}