/*
Type:      class
Purpose:   1.Validates SameAddressType 
Create By: Sriram kalluri
*/
public class TriggerAddressTriggerHandlerJP implements TriggerHandlerIf
{
    list<Address__C> ListAddOld = (list<Address__C>)trigger.old;
    list<Address__C> ListAddNew = (list<Address__C>)trigger.new;
    string serializedObject;
    
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
        
    {
        /* any code that may use any trigger functionality like trigger.isBefore, trigger.new, ... */
        
        if ((Trigger.isBefore && Trigger.isUpdate)||(Trigger.isBefore && Trigger.isInsert)){
            
            AddressHelperJP.validateSameAddressType(trigger.new,(Map<Id,Address__c>)Trigger.OldMap,trigger.isInsert,trigger.isUpdate);
        }
        
        if ((Trigger.isAfter && Trigger.isUpdate)){
            
            AddressHelperJP.updatePrimaryAddressOnAccount((map<id,Address__c>)trigger.newMap);
            AddressHelperJP.updateAccountlinks((Map<Id,Address__c>)Trigger.newMap);
        }
        if ((Trigger.isAfter && Trigger.isDelete)){
            
            AddressHelperJP.updateAccountonDeletion(Trigger.Old);
        }
        
        
        if(isAfter && isInsert)
        {
            serializedObject=json.serialize(ListAddNew);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            
            AddressHelperJP.entityNotifyUpdate('INSERT',ListAddNew[0].Id,serializedObject);
             AddressHelperJP.updateAccountlinks((Map<Id,Address__c>)Trigger.newMap);
			 //added by lokesh M
             AddressHelperJP.afterInsetAddressUpdateRetailPerson(trigger.new);
        } 
        if(isAfter && isUpdate)
        {
            serializedObject=json.serialize(ListAddNew);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AddressHelperJP.entityNotifyUpdate('UPDATE',ListAddNew[0].Id,serializedObject);
        }
        
        if(isAfter && isDelete)
        {
            serializedObject=json.serialize(ListAddOld);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AddressHelperJP.entityNotifyUpdate('DELETE',ListAddOld[0].Id,serializedObject);
        }
        
    }
    
   public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
        
    {
	  // Added  as  part of SFDCJP-2730
	 if(isAfter && isUpdate)
        {
		 AddressHelperJP.afterUpdateVehicleRelationship(Trigger.new,(Map<Id,Address__c>)Trigger.OldMap);
		}
        /*
        if(isAfter && isInsert)

        {
            serializedObject=json.serialize(ListAddNew);
            
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
           // AddressHelperJP.entityNotifyUpdate('INSERT',ListAddNew[0].Id,serializedObject);
        } 
        if(isAfter && isUpdate)
        {
            serializedObject=json.serialize(ListAddNew);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
           // AddressHelperJP.entityNotifyUpdate('UPDATE',ListAddNew[0].Id,serializedObject);
        }
        
        if(isAfter && isDelete)
        {
            serializedObject=json.serialize(ListAddOld);
			serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AddressHelperJP.entityNotifyUpdate('DELETE',ListAddOld[0].Id,serializedObject);
        }
        */
    }
    
}