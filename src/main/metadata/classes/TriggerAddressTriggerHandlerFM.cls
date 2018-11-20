/**
* Handler for Trigger on Address for Factory Model
* Author: Shashi
* Created Date : 10th Oct 2018
*/

public class TriggerAddressTriggerHandlerFM implements TriggerHandlerIf{

    list<Address__C> ListAddOld = (list<Address__C>)trigger.old;
    list<Address__C> ListAddNew = (list<Address__C>)trigger.new;
    
	Public User u= Utility_FM.getLoggedInUserInfo();
	
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){            

		String market = u.market__c;
        if ((isBefore && isUpdate)||(isBefore && isInsert)){
            if(Util_GetPermissionList.checkAccessOnUser(Label.FMGeneric)){
                AddressHelperFM.updatemarket(trigger.new);
				AddressHelperFM.validateSameAddressType(trigger.new,(Map<Id,Address__c>)Trigger.OldMap,trigger.isInsert,trigger.isUpdate,market);
			}
        }
        
        if ((isAfter && isUpdate)){
			if(Util_GetPermissionList.checkAccessOnUser(Label.FMGeneric)){
				AddressHelperFM.updatePrimaryAddressOnAccount((map<id,Address__c>)trigger.newMap);
				if(Util_GetPermissionList.checkAccessOnUser(Label.ALAddressUpdate)){ // Check the Custom permission for FM
                AddressHelperFM.updateAddressRetailCopies((map<id,Address__c>)trigger.newMap, u.market__c);
                }
			}
        }
        
        if ((isAfter && isDelete)){
			if(Util_GetPermissionList.checkAccessOnUser(Label.FMGeneric)){
				AddressHelperFM.updateAccountonDeletion(Trigger.Old);
			}
        }
        
        if(isAfter && isInsert){     
			if(Util_GetPermissionList.checkAccessOnUser(Label.FMGeneric)){		
				AddressHelperFM.updateAddressOnAccount(trigger.new);
			}
        }

        if(isAfter && isinsert){
			if(Util_GetPermissionList.checkAccessOnUser(Label.AccCDM)){
				if(TriggerRecursiveCheck.run){
					TriggerRecursiveCheck.runOnce();
					AddressHelperFM.updateAddressCDM(trigger.new,u.market__c,Label.UpdateContext);
				}
			}
		}
		
        if(isafter && isupdate){
			if(Util_GetPermissionList.checkAccessOnUser(Label.AccCDM)){
				if(TriggerRecursiveCheck.run){
					TriggerRecursiveCheck.runOnce();
					AddressHelperFM.updateAddressCDM(trigger.new,u.market__c,Label.UpdateContext);
				}
			}
        }
        
        //to call market specific trigger handler
        FMMarketTriggerFactory.run('Address', u.Market__c, true, true, true, true, true);
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){                
        //Integration related code to be added here.
    }
}