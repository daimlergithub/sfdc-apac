/*
Type:      class
Purpose:   Update Preferred address on Account 
Create By: Mohammed Touseef Ahmed
Created on :9/12/2017
*/

public class TriggerAddressTriggerHandlerMY implements TriggerHandlerIf
{
    list<Address__C> ListAddOld = (list<Address__C>)trigger.old;
    list<Address__C> ListAddNew = (list<Address__C>)trigger.new;
    string serializedObject;
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
        
    {            
        /* any code that may use any trigger functionality like trigger.isBefore, trigger.new, ... */
        
          if ((isBefore && isUpdate)||(isBefore && isInsert)){
            
				AddressHelperTH.validateSameAddressType(trigger.new,(Map<Id,Address__c>)Trigger.OldMap,trigger.isInsert,trigger.isUpdate);
            }
            
            if ((isAfter && isUpdate)){
                
                AddressHelperTH.updatePrimaryAddressOnAccount((map<id,Address__c>)trigger.newMap);
            }
            
             if ((isAfter && isDelete)){
            
            AddressHelperTH.updateAccountonDeletion(Trigger.Old);
            }
        
           if(isBefore && isInsert)
            {           
                AddressHelperTH.updateAddressOnAccount(trigger.new);
            }
            
            if(isBefore && isUpdate)
            {            
                AddressHelperTH.updateAddressOnAccount(trigger.new);
            }
			if(isAfter && isinsert){
				if(TriggerRecursiveCheck.run){
					TriggerRecursiveCheck.runOnce();
					AddressHelperTH.updateAddressCDM(trigger.new,Label.MY,Label.InsertContext);
				}
			}
			if(isafter && isupdate){
				if(TriggerRecursiveCheck.run){
					TriggerRecursiveCheck.runOnce();
					AddressHelperTH.updateAddressCDM(trigger.new,Label.MY,Label.UpdateContext);
				}
			}
			if(isafter && isupdate){
				if(TriggerRecursiveCheck.run){
					TriggerRecursiveCheck.runOnce();
					AddressHelperTH.updateAddressCDM(Trigger.Old,Label.MY,Label.UpdateContext);
				}
			}
        
    }
    
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)        
    {                
        //Integration related code to be added here.
    }
    
    
    
}