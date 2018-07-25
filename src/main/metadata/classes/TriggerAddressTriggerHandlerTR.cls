/*
Type:      class
Purpose:   Update Preferred address on Account 
Create By: Hildaa
Created on :28/2/2018

*/

public class TriggerAddressTriggerHandlerTR implements TriggerHandlerIf{
    list<Address__C> ListAddOld = (list<Address__C>)trigger.old;
    list<Address__C> ListAddNew = (list<Address__C>)trigger.new;
    string serializedObject;
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){            

        /* any code that may use any trigger functionality like trigger.isBefore, trigger.new, ... */
        
        if ((isBefore && isUpdate)||(isBefore && isInsert)){
            /* Data Update MD Fix - Santosh Mohanty*/
            AddressHelperTR.updatemarket(Trigger.New);
      if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){
        AddressHelperTR.validateSameAddressType(trigger.new,(Map<Id,Address__c>)Trigger.OldMap,trigger.isInsert,trigger.isUpdate);
      }
        }
        
        if ((isAfter && isUpdate)){
      if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){
        AddressHelperTR.updatePrimaryAddressOnAccount((map<id,Address__c>)trigger.newMap);
      }
        }
        
        if ((isAfter && isDelete)){
      if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){
        AddressHelperTR.updateAccountonDeletion(Trigger.Old);
      }
        }
        
        if(isBefore && isInsert){     
            if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){    
               // AddressHelperTR.updateAddressOnAccount(trigger.new);
            }
        }

        if(isBefore && isUpdate){
            /* Data Update MD Fix - Santosh Mohanty*/
               
      if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){    
         AddressHelperTR.updatemarket(Trigger.New);
        AddressHelperTR.updateAddressOnAccount(trigger.new);
      }
        }

        if(isAfter && isinsert){
            if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){
            AddressHelperTR.updateAddressOnAccount(trigger.new);
                if(TriggerRecursiveCheck.run){
                    TriggerRecursiveCheck.runOnce();
                    AddressHelperTR.updateAddressCDM(trigger.new,Label.TR,Label.UpdateContext);
                }
            }
        }
        
        if(isafter && isupdate){
      if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){
        if(TriggerRecursiveCheck.run){
          TriggerRecursiveCheck.runOnce();
          AddressHelperTR.updateAddressCDM(trigger.new,Label.TR,Label.UpdateContext);
        }
      }
        }
        if(isafter && isupdate){
      if(Util_GetPermissionList.checkAccessOnUser(Label.TRGeneric)){
        if(TriggerRecursiveCheck.run){
          TriggerRecursiveCheck.runOnce();
          AddressHelperTR.updateAddressCDM(Trigger.Old,Label.TR,Label.UpdateContext);
        }
      }
    }
    }

    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){                
        //Integration related code to be added here.
    }
}