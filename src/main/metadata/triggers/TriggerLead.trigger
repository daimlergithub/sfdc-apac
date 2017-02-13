/*
    Type:       Trigger
    Purpose:    1. US-Lead-016: Assign Dealer Lead Status to CAC Lead Status 
                   when assigned dealer has been verified
                2. US-Lead-014: Share related Campaign Lead to Lead Owner after dealer is assigned
                3. Create a custom sharing to share the lead record with Smart Account Owner or the Star Elite Account Owner (from dealer record) with Read Only access.)
                4. Share lead's contact to Dealer Sales Gate Keeper
                5. If a lead is created from Inquiry case, copy lead id to Case's lead.  US-IB-001
    User Story: US-Lead-016, US-Lead-014, US-DP-022, US-DP-023, US-DP-014, US-IB-001
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-04-26
    2. Mouse add logic on sharing related campaign lead to lead owner on 2013-04-27
    3. Mouse add logic for US-Lead-021 on 2013-05-17
    18-April-2013 Sinow Zhang (NTTData)  Created
    16-June-2014 Bing(NDC) Modified
    23-April-2015 Gerhard Henning (NTTData)     Moved code to TriggerLeadTriggerHandler
*/
trigger TriggerLead on Lead__c(before insert, before update, after update,after insert) 
{
    TriggerUtil.handleTrigger('TriggerLead');
}