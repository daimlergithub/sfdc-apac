/*
Type:      class
Purpose:   Update Preferred address on Account 
Create By: Mohammed Touseef Ahmed
Created on :03/23/2018
Modified BY :  Honey on 11th Oct 2017
*/

public class TriggerAddressTriggerHandlerAU implements TriggerHandlerIf{
    list<Address__C> ListAddOld = (list<Address__C>)trigger.old;
    list<Address__C> ListAddNew = (list<Address__C>)trigger.new;
    string serializedObject;
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){            

        /* any code that may use any trigger functionality like trigger.isBefore, trigger.new, ... */
        
        if ((isBefore && isUpdate)||(isBefore && isInsert)){
            /* Data Update MD Fix - Santosh Mohanty*/
            AddressHelperAU.updatemarket(Trigger.New);
      if(Util_GetPermissionList.checkAccessOnUser(Label.AUGeneric) || Util_GetPermissionList.checkAccessOnUser(Label.NZGeneric) )  {
        AddressHelperAU.validateSameAddressType(trigger.new,(Map<Id,Address__c>)Trigger.OldMap,trigger.isInsert,trigger.isUpdate);
		AddressHelperAU.updateUnnormalizedAddress(Trigger.New); // Added to updated Unnormized address
      }
        }
        
		//Sada 2018/June/14 Commenting as not required for this sprint 
        if ((isAfter && isUpdate)){
      if(Util_GetPermissionList.checkAccessOnUser(Label.AUGeneric)){
        AddressHelperAU.updatePrimaryAddressOnAccount((map<id,Address__c>)trigger.newMap);
      //  AddressHelperAU.updateAddressRetailCopies((map<id,Address__c>)trigger.newMap, Label.AU);
      }
        }
        
		
        if ((isAfter && isDelete)){
      if(Util_GetPermissionList.checkAccessOnUser(Label.AUGeneric)){
        AddressHelperAU.updateAccountonDeletion(Trigger.Old);
      }
        }
        
		
        if(isAfter && isInsert){     
      if(Util_GetPermissionList.checkAccessOnUser(Label.AUGeneric)){    
        AddressHelperAU.updateAddressOnAccount(trigger.new);
      }
        }

        if(isBefore && isUpdate){
            /* Data Update MD Fix - Santosh Mohanty*/
               
      if(Util_GetPermissionList.checkAccessOnUser(Label.AUGeneric)){    
         AddressHelperAU.updatemarket(Trigger.New);
        //AddressHelperMY.updateAddressOnAccount(trigger.new);
      }
        }
		
	//Sada 2018/June/14 Commenting as not required for this sprint 
        if(isAfter && isinsert){
      if(Util_GetPermissionList.checkAccessOnUser(Label.AUGeneric)){
        if(TriggerRecursiveCheck.run){
          TriggerRecursiveCheck.runOnce();
        //  AddressHelperAU.updateAddressCDM(trigger.new,Label.AU,Label.UpdateContext);
        }
      }
    }
    
	//Sada 2018/June/14 Commenting as not required for this sprint 
        if(isafter && isupdate){
      if(Util_GetPermissionList.checkAccessOnUser(Label.AUGeneric)){
        if(TriggerRecursiveCheck.run){
          TriggerRecursiveCheck.runOnce();
       //   AddressHelperAU.updateAddressCDM(trigger.new,Label.AU,Label.UpdateContext);
        }
      }
        }
    }

    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){                
        //Integration related code to be added here.
    }
}