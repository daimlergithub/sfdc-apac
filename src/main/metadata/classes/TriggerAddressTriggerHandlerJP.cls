/*
    Type:      class
    Purpose:   1.Validates SameAddressType 
    Create By: Sriram kalluri
*/
public class TriggerAddressTriggerHandlerJP implements TriggerHandlerIf
    {
    
            public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
        
            {
                /* any code that may use any trigger functionality like trigger.isBefore, trigger.new, ... */
                
                 if ((Trigger.isBefore && Trigger.isUpdate)||(Trigger.isBefore && Trigger.isInsert)){
                     
                    AddressHelperJP.validateSameAddressType(trigger.new);
                }
        
            }
        
                public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete)
        
            {
        
                /* any code that may use any trigger functionality like trigger.isBefore, trigger.new, ... */
        
            }
    
     
    
    }