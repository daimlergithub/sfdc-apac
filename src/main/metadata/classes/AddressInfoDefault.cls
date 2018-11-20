public virtual class AddressInfoDefault implements AddressInfo
{
    public Map<String,List<String>> factoryFieldsMap = new Map<String,List<String>>();
    public Integer maxAddressCount;    
    Factory_Fields__mdt addressInfoFactoryFields;
    
    public AddressInfoDefinition fetchFactoryResponse(String recordId)
    {
        AddressInfoDefinition adrInfoDef = new AddressInfoDefinition();
        adrInfoDef.factoryFieldsMap =factoryFieldsMap;
        adrInfoDef.addressList = getAddressList(recordId);
        adrInfoDef.maxAddressCount = maxAddressCount;
        
        return adrInfoDef;
    }

    public List<Address__c> getAddressList(ID recordId) 
    {
        list <Address__c>  addressList = [  Select State_City__c,Address_Code__c,Address_Line_1__c,
                                            Address_Line_2__c,Address_Type__c,Block__c,City__c,Company_Name__c,
                                            Country__c,Created_By_EP_Transaction__c,Customer__c,District__c,Id,
                                            LastModifiedById,LastModifiedDate,MD__c,Name,Preferred__c,Province__c,
                                            RecordTypeId,Status__c,ZipCode__c 
                                            From Address__c 
                                            where Customer__c = :recordId
                                        ]; 
        system.debug(addressList);
        
        return addressList;
    }  

    
    public Integer getMaxAddressCount()
    {
        return maxAddressCount;
    }
    
    public void setMetadataFields(Factory_Fields__mdt addressInfoFactoryFields)
    {
        this.addressInfoFactoryFields = addressInfoFactoryFields; 
        setFactoryFieldsInResponseMap();
        setMaxAddressCount();
    }
    
    
    void setFactoryFieldsInResponseMap()
    { 
        Factory_Fields__mdt marketSpecificFields = new Factory_Fields__mdt();
        List<String> lstIoFields = new List<String>();
        
        if(addressInfoFactoryFields.Input_Fields__c!=null)
            factoryFieldsMap.put('inputFields',addressInfoFactoryFields.Input_Fields__c.split(','));
            
        if(addressInfoFactoryFields.Output_Fields__c!=null)
            factoryFieldsMap.put('outputFields',addressInfoFactoryFields.Output_Fields__c.split(','));
            
        if(addressInfoFactoryFields.buttons__c!=null)
            factoryFieldsMap.put('buttons',addressInfoFactoryFields.buttons__c.split(','));
        
        if(addressInfoFactoryFields.Table_Columns__c!=null)
            factoryFieldsMap.put('outputSideBarFields',addressInfoFactoryFields.Table_Columns__c.split(','));  
    }
    
    void setMaxAddressCount() 
    {
            
        if(addressInfoFactoryFields.MaxAddressCount__c!=null)
            maxAddressCount = Integer.valueOf(addressInfoFactoryFields.MaxAddressCount__c);
    }
}