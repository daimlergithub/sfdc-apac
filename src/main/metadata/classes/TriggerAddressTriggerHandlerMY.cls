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
            AddressHelperMY.validateSameAddressType(trigger.new,(Map<Id,Address__c>)Trigger.OldMap,trigger.isInsert,trigger.isUpdate);
        }
        
        if ((isAfter && isUpdate)){
            AddressHelperMY.updatePrimaryAddressOnAccount((map<id,Address__c>)trigger.newMap);
        }
        
        if ((isAfter && isDelete)){
            AddressHelperMY.updateAccountonDeletion(Trigger.Old);
        }
        
        if(isBefore && isInsert){           
            AddressHelperMY.updateAddressOnAccount(trigger.new);
        }

        if(isBefore && isUpdate){            
            AddressHelperMY.updateAddressOnAccount(trigger.new);
        }

        if(isAfter && isinsert){
            if(TriggerRecursiveCheck.run){
                TriggerRecursiveCheck.runOnce();
                AddressHelpermy.updateAddressCDM(trigger.new,Label.MY,Label.UpdateContext);
            }
        }

        if(isafter && isupdate){
            if(TriggerRecursiveCheck.run){
                TriggerRecursiveCheck.runOnce();
                AddressHelperMY.updateAddressCDM(trigger.new,Label.MY,Label.UpdateContext);
            }
        }
        
        if(isafter && isupdate){
            if(TriggerRecursiveCheck.run){
                TriggerRecursiveCheck.runOnce();
                AddressHelperMY.updateAddressCDM(Trigger.Old,Label.MY,Label.UpdateContext);
            }
        }
    }

    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter){                
        //Integration related code to be added here.
    }
}