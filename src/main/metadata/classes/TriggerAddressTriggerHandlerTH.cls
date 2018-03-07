/*
Type:      class
Purpose:   Update Preferred address on Account 
Create By: Mohammed Touseef Ahmed
Created on :1/18/2017
*/

public class TriggerAddressTriggerHandlerTH implements TriggerHandlerIf
{
    list<Address__C> ListAddOld = (list<Address__C>)trigger.old;
    list<Address__C> ListAddNew = (list<Address__C>)trigger.new;
    string serializedObject;
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
        
    {            
        /* any code that may use any trigger functionality like trigger.isBefore, trigger.new, ... */
        
          if ((Trigger.isBefore && Trigger.isUpdate)||(Trigger.isBefore && Trigger.isInsert)){
            /* Data Update MD Fix - Santosh Mohanty*/
            AddressHelperTH.updatemarket(Trigger.New);
            AddressHelperTH.validateSameAddressType(trigger.new,(Map<Id,Address__c>)Trigger.OldMap,trigger.isInsert,trigger.isUpdate);
            }
            
            if(isAfter && isinsert){
            if(TriggerRecursiveCheck.run){
                TriggerRecursiveCheck.runOnce();
                AddressHelperTH.updateAddressCDM(trigger.new,Label.TH,Label.UpdateContext);
            }
            }

            if(isafter && isupdate){
            if(TriggerRecursiveCheck.run){
                TriggerRecursiveCheck.runOnce();
                AddressHelperTH.updateAddressCDM(trigger.new,Label.TH,Label.UpdateContext);
            }
            }
            
            if ((Trigger.isAfter && Trigger.isUpdate)){
                AddressHelperTH.updateAcclinkAddress(trigger.new);
                AddressHelperTH.updatePrimaryAddressOnAccount((map<id,Address__c>)trigger.newMap);
            }
            
             if ((Trigger.isAfter && Trigger.isDelete)){
            
            AddressHelperTH.updateAccountonDeletion(Trigger.Old);
            }
        
           if(trigger.isBefore && trigger.isInsert)
            {           
                AddressHelperTH.updateAddressOnAccount(trigger.new);
            }
            
            if(trigger.isBefore && trigger.isUpdate)
            {   
                /* Data Update MD Fix - Santosh Mohanty*/
                AddressHelperTH.updatemarket(Trigger.New);         
                AddressHelperTH.updateAddressOnAccount(trigger.new);
            }       
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)        
    {                
        //Integration related code to be added here.
		if(isAfter && isinsert){
            if(TriggerRecursiveCheck.run){
                TriggerRecursiveCheck.runOnce();
                AddressHelperTH.updateSalesAddressAccount((map<id,Address__c>)trigger.newMap);
            }
        }
    }  
}