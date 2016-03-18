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
        request.Organization = '00Dp00000000eeV';
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
    
     public static void entityUpdateNotification(String organizationId,String sfdcId,String sfdcTypeName,String sfdcMarketDiscriminator,String updateType,String serlializedObject)
    {
        //Soap over http
        String requestXML='<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ep="http://ep.apac.crm.daimler.com">';
        requestXML+='<soapenv:Header/>';
        requestXML+='<soapenv:Body>';
        requestXML+='<ep:notifyEntityUpdate>';
        requestXML+='<ep:organizationId>'+organizationId+'</ep:organizationId>';
        requestXML+='<ep:sfdcId>'+sfdcId+'</ep:sfdcId>';
        requestXML+='<ep:sfdcTypeName>'+sfdcTypeName+'</ep:sfdcTypeName>';
        requestXML+='<ep:sfdcMarketDiscriminator>'+sfdcMarketDiscriminator+'</ep:sfdcMarketDiscriminator>';
        requestXML+='<ep:updateType>'+updateType+'</ep:updateType>';
        requestXML+='<ep:serlializedObject>'+serlializedObject+'</ep:serlializedObject>';
        requestXML+='</ep:notifyEntityUpdate>';
        requestXML+='</soapenv:Body>';
        requestXML+='</soapenv:Envelope>';
        
        HttpRequest req=new HttpRequest();
        req.setMethod('GET');
        //system.debug('req UtilCustomSettings >>>>>'+UtilCustomSettings.getEndPointURL(UtilConstant.ENTITY_UPDATE_NOTIFICATION));
        req.setEndpoint(UtilCustomSettings.getWebserviceUrl('EPUrlEntityNotification'));
        req.setTimeout(120000);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8');
        req.setHeader('SOAPAction', '""');
        req.setHeader('Connection', 'Keep-Alive');
        req.setBody(requestXML);
        system.debug('req >>>>>'+req);
        Http http=new Http();
        HTTPResponse res ;
        try{
            res=http.send(req);  
            system.debug('res>>>>>'+res);
        }catch(Exception e)
        {
            system.debug('e>>>>>'+e.getmessage()+'>>>>>'+e.getstacktracestring());
        }
    }
    
    
}