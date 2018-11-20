public class TriggerAccountLinkTriggerHandlerKR implements TriggerHandlerIf
{
    User usr = [Select Id,ProfileId,Profile.Name from User WHERE ID = : UserInfo.getUserId()];
    //added sravanthi gudibandi for switch
     Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore,boolean isDelete,boolean isAfter)
     {  
      //added sravanthi gudibandi for switch 
     Boolean CDMRCCreation = false;  
      if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('CDM RC Creation and Update')){
           CDMRCCreation  = KRSwitchMap.get('CDM RC Creation and Update').Enable_Flag__c;
        }
      system.debug('Trigger 1 :');
        if(isAfter && isInsert){
            system.debug('Trigger 2 :');
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
            AccountLinkHelperKR.afterInsertEvent(Trigger.new);
            AccountLinkHelperKR.updateRetailPositionfromC2C(Trigger.isUpdate, Trigger.isAfter ,Trigger.isInsert, trigger.new);
            system.debug('Trigger 3 :');
             //added sravanthi gudibandi for switch 
             if (!System.isFuture() && CDMRCCreation) {
                    AccountLinkHelperBase.CDMAccountlinkContextGroup(trigger.new,'KR',Label.InsertContext );
                }
        }
        if(isAfter && isUpdate){
            system.debug('Trigger 4 :');
            system.debug('Leadutil.testadd='+Leadutil.testadd);
            Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
            //if(Leadutil.testadd=false){
               AccountLinkHelperKR.afterUpdateEvent(Trigger.new, oldmap);
               AccountLinkHelperKR.updateRetailPositionfromC2C(Trigger.isUpdate, Trigger.isAfter ,Trigger.isInsert, trigger.new);
                if(!CDMRCCreation){
               AccountLinkHelperKR.ExportNotification(Trigger.new, oldmap);
                }
               system.debug('Entered After TRIGGER');
               //AccountLinkHelperKR.updateAccountlinksonPrimaryAddress(trigger.new ,oldmap ,trigger.isUpdate,trigger.isinsert);
               system.debug('Trigger 5 :');
                //added sravanthi gudibandi for switch 
                if (!System.isFuture() && CDMRCCreation) {
                 if (TriggerRecursiveCheck.run2 && !System.isFuture()) {
                     TriggerRecursiveCheck.runOnce2();
                     AccountLinkHelperBase.CDMAccountlinkContextGroup(trigger.new, 'KR', Label.UpdateContext); 
                    }   
                }
            //}
        }     
        if(isBefore && isInsert)
        {        
		    Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap; 
            system.debug('Entered before TRIGGER');
            AccountLinkHelperKR.beforeInsertUpdateEvent(Trigger.new, oldmap);
            AccountLinkHelperKR.updateRetailCopy(trigger.isUpdate,trigger.isinsert, trigger.isBefore ,trigger.new);
            AccountLinkHelperKR.updateRetailCopyfromC2C(Trigger.isUpdate, Trigger.isBefore,Trigger.isInsert, trigger.new );
           
        }
                
        if(isBefore && isUpdate)
        {
            /* Data Migration Explicit Fix - Santosh Mohanty */
			AccountLinkHelper.updatemarket(Trigger.New);
			Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
			AccountLinkHelperKR.beforeInsertUpdateEvent(Trigger.new, oldmap);
            system.debug('Entered b efore update TRIGGER');
            AccountLinkHelperKR.updateRetailCopy(trigger.isUpdate,trigger.isinsert, trigger.isBefore ,trigger.new);
            AccountLinkHelperKR.updateRetailCopyfromC2C(Trigger.isUpdate, Trigger.isBefore,Trigger.isInsert, trigger.new );
            
        }    
    }        
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
        List<Account_Link__c> accountLinkNewList = Trigger.new;
        if(!isDelete && !accountLinkNewList.isEmpty() && accountLinkNewList.size() > 0 && accountLinkNewList[0].MD__c == 'KR')
        {
            if(Trigger.isAfter && Trigger.isUpdate)
            {
                Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
                AccountLinkHelperKR.afterUpdateEvent(Trigger.new, oldmap);
            }
            if(Trigger.isAfter && Trigger.isInsert)
            {
                Map<Id,Account_Link__c> oldmap = (Map<Id,Account_Link__c>)Trigger.oldmap;
                AccountLinkHelperKR.afterInsertEvent(Trigger.new);
            }
        }
    }
}