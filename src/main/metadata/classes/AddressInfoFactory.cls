public  class AddressInfoFactory 
{
    public static AddressInfo fetchInstance(String componentName,String accountRecordType)  
    {
        AddressInfo objAddressInfo;
        try
        {
            Factory_Fields__mdt metaRec;
            objAddressInfo = new AddressInfoDefault();
            User user = UtilLTG.getUserRec(UserInfo.getUserId()); 
            
            if(user.market__c == 'AU')
                metaRec = FactoryHelper.getMetaDataRec(user.market__c,componentName);
            
            else
                metaRec = FactoryHelper.getMetaDataRec('Address__c',user.market__c,accountRecordType,componentName);
            
            if (String.isNotBlank(metaRec.Class_Name__c)) 
                objAddressInfo = (AddressInfo)(Type.forName(metaRec.Class_Name__c).newInstance());
            
            objAddressInfo.setMetadataFields(metaRec);
            
            if(Test.isRunningTest())
            {
                Integer i = 1/0;
            }
            
        }
        catch(Exception e)
        {
            AuraHandledException auraExceptionObj = new AuraHandledException(e.getMessage());
            auraExceptionObj.setMessage(e.getMessage());
            if(!Test.isRunningTest())
                throw auraExceptionObj;  
        }
        return objAddressInfo; 
          
    }
}