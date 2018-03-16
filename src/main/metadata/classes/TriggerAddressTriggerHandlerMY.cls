/*
Type:      class
Purpose:   Update Preferred address on Account 
Create By: Mohammed Touseef Ahmed
Created on :9/12/2017
Modified BY :  Honey on 11th Oct 2017
*/

public class TriggerAddressTriggerHandlerMY implements TriggerHandlerIf{
    list<Address__C> ListAddOld = (list<Address__C>)trigger.old;
    list<Address__C> ListAddNew = (list<Address__C>)trigger.new;
    string serializedObject;
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){            

        /* any code that may use any trigger functionality like trigger.isBefore, trigger.new, ... */
        
        if ((isBefore && isUpdate)||(isBefore && isInsert)){
            /* Data Update MD Fix - Santosh Mohanty*/
            AddressHelperMY.updatemarket(Trigger.New);
			if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
				AddressHelperMY.validateSameAddressType(trigger.new,(Map<Id,Address__c>)Trigger.OldMap,trigger.isInsert,trigger.isUpdate);
			}
        }
        
        if ((isAfter && isUpdate)){
			if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
				AddressHelperMY.updatePrimaryAddressOnAccount((map<id,Address__c>)trigger.newMap);
				AddressHelperMY.updateAddressRetailCopies((map<id,Address__c>)trigger.newMap, Label.MY);
			}
        }
        
        if ((isAfter && isDelete)){
			if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
				AddressHelperMY.updateAccountonDeletion(Trigger.Old);
			}
        }
        
        if(isAfter && isInsert){     
			if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){		
				AddressHelperMY.updateAddressOnAccount(trigger.new);
			}
        }

        if(isBefore && isUpdate){
            /* Data Update MD Fix - Santosh Mohanty*/
               
			if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){		
				 AddressHelperMY.updatemarket(Trigger.New);
				//AddressHelperMY.updateAddressOnAccount(trigger.new);
			}
        }

        if(isAfter && isinsert){
			if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
				if(TriggerRecursiveCheck.run){
					TriggerRecursiveCheck.runOnce();
					AddressHelpermy.updateAddressCDM(trigger.new,Label.MY,Label.UpdateContext);
				}
			}
		}
		
        if(isafter && isupdate){
			if(Util_GetPermissionList.checkAccessOnUser(Label.MYGeneric)){
				if(TriggerRecursiveCheck.run){
					TriggerRecursiveCheck.runOnce();
					AddressHelperMY.updateAddressCDM(trigger.new,Label.MY,Label.UpdateContext);
				}
			}
        }
    }

    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){                
        //Integration related code to be added here.
    }
}