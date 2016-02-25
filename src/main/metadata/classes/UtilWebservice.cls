Global class UtilWebservice 
{
    public static crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType validateAddressByZipCode(Address__c address)
    {
        crmasiaDaimlerApacComValidateaddress.AddressValidationPort stub = new crmasiaDaimlerApacComValidateaddress.AddressValidationPort();
        crmasiaDaimlerApacComValidateaddress.Address SendingAddress = new crmasiaDaimlerApacComValidateaddress.Address();
        crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType response = new crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType();
        crmasiaDaimlerApacComValidateaddress.AddressValidationMessageFaultType faultCode = new  crmasiaDaimlerApacComValidateaddress.AddressValidationMessageFaultType(); 
        SendingAddress.ZipCode = address.ZipCode__c;
        SendingAddress.MarketDiscriminator = 'JP';
        SendingAddress.Address_Line_1 = address.Address_Line_1__c;
        SendingAddress.Address_Line_2 = address.Address_Line_2__c;
        SendingAddress.Block = address.Block__c;
        SendingAddress.City = address.City__c;
        SendingAddress.District = address.District__c;
        SendingAddress.Province = address.Province__c;
        crmasiaDaimlerApacComValidateaddress.AddressValidationRequestMessageType request = new crmasiaDaimlerApacComValidateaddress.AddressValidationRequestMessageType();
        request.Organization = UserInfo.getOrganizationId();
        request.Address = SendingAddress;
        try
        {
            response = stub.ValidateAddress(request);
            
        }
        catch(CalloutException excpObj)
        {
            system.debug('!!!!!!!!!'+excpObj.getMessage());
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.AddressValidation_callout_failure));
            
        }
        
        
        return response;
    } 
    
    
}