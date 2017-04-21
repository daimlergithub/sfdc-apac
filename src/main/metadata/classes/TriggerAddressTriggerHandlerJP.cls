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
        
        if ((Trigger.isBefore && Trigger.isUpdate)||(Trigger.isBefore && Trigger.isInsert))
        {            
            AddressHelperJP.validateSameAddressType(trigger.new,(Map<Id,Address__c>)Trigger.OldMap,trigger.isInsert,trigger.isUpdate);
        }
        if ((isAfter && isUpdate))
        {
            AddressHelperJP.updateAccountlinks((Map<Id,Address__c>)Trigger.newMap);
            serializedObject=json.serialize(ListAddNew);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AddressHelperJP.entityNotifyUpdate('UPDATE',ListAddNew[0].Id,serializedObject);
        }
        if ((isAfter && isDelete))
        {            
            AddressHelperJP.updateAccountonDeletion(Trigger.Old);
            serializedObject=json.serialize(ListAddOld);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');
            AddressHelperJP.entityNotifyUpdate('DELETE',ListAddOld[0].Id,serializedObject);
        } 
        if(isAfter && isInsert)
        {
            serializedObject=json.serialize(ListAddNew);
            serializedObject = EncodingUtil.URLENCODE(serializedObject,'UTF-8');            
            AddressHelperJP.entityNotifyUpdate('INSERT',ListAddNew[0].Id,serializedObject);
             AddressHelperJP.updateAccountlinks((Map<Id,Address__c>)Trigger.newMap);
        }         
    }
    
   public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
        
    {
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