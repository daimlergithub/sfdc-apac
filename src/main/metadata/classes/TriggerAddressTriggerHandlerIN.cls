/*
Type:      class
Purpose:   Update Preferred address on Account 
Create By: Sravanthi Gudibandi
Created on :01-March-2018

*/

public class TriggerAddressTriggerHandlerIN implements TriggerHandlerIf{
    list<Address__C> ListAddOld = (list<Address__C>)trigger.old;
    list<Address__C> ListAddNew = (list<Address__C>)trigger.new;
    string serializedObject;
    Util_getPermissions util_getP = new Util_getPermissions();
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){            

        /*  code that may use any trigger functionality like trigger.isBefore, trigger.new, ... */
        
        if ((isBefore && isUpdate)||(isBefore && isInsert)){
          
        //prevent duplicate address type  
      if(util_getP.checkCustomPermission(Label.INGeneric)){
        AddressHelperIN.validateSameAddressType(trigger.new,(Map<Id,Address__c>)Trigger.OldMap,trigger.isInsert,trigger.isUpdate);
      }
        }
        //update primary address on account
        if ((isAfter && isUpdate)){
            system.debug('inside after trigger before util check');
            if(util_getP.checkCustomPermission(Label.INGeneric)){
                system.debug('inside after trigger');
                AddressHelperIN.updatePrimaryAddressOnAccount((map<id,Address__c>)trigger.newMap);
            }
        }
        //to update account if address is deleted
        if ((isAfter && isDelete)){
      if(util_getP.checkCustomPermission(Label.INGeneric)){
        AddressHelperIN.updateAccountonDeletion(Trigger.Old);
      }
        }
        
        if(isBefore && isInsert){     
      if(util_getP.checkCustomPermission(Label.INGeneric)){    
        AddressHelperIN.updateAddressOnAccount(trigger.new);
      }
        }

        if(isBefore && isUpdate){
          
               
      if(util_getP.checkCustomPermission(Label.INGeneric)){    
        
        AddressHelperIN.updateAddressOnAccount(trigger.new);
      }
        }

        if(isAfter && isinsert){
      if(util_getP.checkCustomPermission(Label.INGeneric)){
        if(TriggerRecursiveCheck.run){
          TriggerRecursiveCheck.runOnce();
          AddressHelperIN.updateAddressCDM(trigger.new,Label.IN,Label.UpdateContext);
        }
      }
    }
    
        if(isafter && isupdate){
      if(util_getP.checkCustomPermission(Label.INGeneric)){
        if(TriggerRecursiveCheck.run){
          TriggerRecursiveCheck.runOnce();
          AddressHelperIN.updateAddressCDM(trigger.new,Label.IN,Label.UpdateContext);
        }
      }
        }
       
    }

    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){                
        //Integration related code to be added here.
    }
}