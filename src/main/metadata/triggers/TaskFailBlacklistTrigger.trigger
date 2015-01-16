/*
    Type:       Trigger
    Purpose:    Task Fail Blacklist
    User Story: 	
    Used By:    
    ---------------------------------------------------------------
    History:
    
    10-July-2013 Stephano Shi (Breakingpoint)    Created
*/
trigger TaskFailBlacklistTrigger on Task (after insert, after update) {
    if(trigger.isAfter){
        if (!UtilCustomSettings.isEnabled('TaskFailBlacklistTrigger')) {
            return;
        }

        List<Id> tkIds = new List<Id>();
        
        for(Task tk : trigger.new){
            if(Trigger.isInsert && tk.Activity_Status__c == 'Fail-Blacklist'){
            	tkIds.add(tk.Id);
            }
            if(Trigger.isUpdate && tk.Activity_Status__c == 'Fail-Blacklist' && trigger.oldMap.get(tk.Id).Activity_Status__c != 'Fail-Blacklist'){
                tkIds.add(tk.Id);
            }
        }
        
        List<Task> tkss = [SELECT Id, WhoId FROM Task WHERE Id in :tkIds];
        Set<Id> conIds = new Set<Id>();
        for(Task tks : tkss){
            if (tks.WhoId != null) {
                conIds.add(tks.WhoId);
            }                
        }

        if (conIds.size() > 0) {
            List<Account> accs = [SELECT Id, Is_Blacklist__c FROM Account WHERE PersonContactId=:conIds And Is_Blacklist__c != true];
            for(Account acc : accs){
                acc.Is_Blacklist__c = true;
            }
            
            if (accs.size() > 0) {
                update accs;
            } 
        }       
        
    }
}