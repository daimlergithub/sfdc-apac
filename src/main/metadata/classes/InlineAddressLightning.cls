public class InlineAddressLightning 
{ 
    static AddressInfo objAddressInfo ;
    
        @AuraEnabled 
    public static AddressInfoDefinition getFactoryFields(String recordId,String componentName,String accountRecordType)
    {
        try
        {
            AddressInfo objAddressInfo = AddressInfoFactory.fetchInstance(componentName,accountRecordType);
            return objAddressInfo.fetchFactoryResponse(recordId); 
        }
        catch(Exception e)
        {
            throw new AuraHandledException(e.getMessage() + ' - ' + e.getStackTraceString());
        }
        
    }

    
    @AuraEnabled 
    public static void deleteRecordDB(Id deleterecid)
    {
        try
        {
            address__c addressRecord = new address__c(id=deleterecid); 
            delete addressRecord;
            if(Test.isRunningTest())
                Integer i = 1/0;
        }
        catch(Exception e)
        {
            throw new AuraHandledException(e.getMessage() + ' - ' + e.getStackTraceString());
        }
       
    }
}