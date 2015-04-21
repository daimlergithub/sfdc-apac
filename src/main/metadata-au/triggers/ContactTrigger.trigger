/*
    Type:       Trigger
    Purpose:    1. There should only be one contact with "Dealer Lead Gate Keeper" selected or "Dealer Complaint Gate Keeper" selected in one Dealer.
                2. There should only be one contact with "Dealer Complaint Manager" selected or "Dealer Presales" selected in one Dealer.
    User Story: US-DP-002
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sinow Created on 2013-04-16
    --------------------------
    Type:       Trigger
    Purpose:    1. Copy contact name, phone, email to Dealer.
                2. Populate the information to account if the contact is aftersales manager.
                3. Update related Lead owner when Contact's Lead gate keeper is checked.
    User Story: US-DP-002
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sinow Created on 2013-04-16
    2. Justin modified on 2013-07-30
    3. Sinow modified on 2013-09-10
    4. Gerhard Henning (NTTData) moved code to ContactTriggerHandler on 2015-04-21
*/
trigger ContactTrigger on Contact (after update, after insert,before update, before insert)
{
    TriggerUtil.handleTrigger('ContactTrigger');
}