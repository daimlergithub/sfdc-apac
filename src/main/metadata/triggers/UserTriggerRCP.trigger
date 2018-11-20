/**
Type:       Trigger for User After Update    
Purpose:    1. To get list of users inactivated to process these list in BatchDeleteNews batch class                

User Story: RCP-26
Used By:    
---------------------------------------------------------------
History:

14-August-2018 Surendranath  Created
*/
trigger UserTriggerRCP on User (after update, after insert,before update, before insert) {   
    if(trigger.isInsert && trigger.isBefore){
        UserTriggerSubscribeHandler.defaultSubscribefeature(Trigger.new);
    }
    else if(trigger.isInsert && trigger.isAfter){        
        //UserTriggerSubscribeHandler.addusersToGroup(Trigger.new);
        
    }
    else if(trigger.isUpdate && trigger.isAfter){
        UserTriggerRCPHandler.ProcessInactiveUsers(Trigger.new);
        set<Id> userIds = Trigger.newMap.keySet();
        //UserTriggerSubscribeHandler.addUsersTosubscribegroup(userIds);
    }
    
}