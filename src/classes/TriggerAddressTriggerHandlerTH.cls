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
            
            AddressHelperTH.validateSameAddressType(trigger.new,(Map<Id,Address__c>)Trigger.OldMap,trigger.isInsert,trigger.isUpdate);
            }
            
            if ((Trigger.isAfter && Trigger.isUpdate)){
                
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
                AddressHelperTH.updateAddressOnAccount(trigger.new);
            }
        
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)        
    {                
        //Integration related code to be added here.
    }
    
    
    
}