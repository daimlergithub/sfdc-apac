@isTest
global class WebServiceMockImpl2 implements WebServiceMock {
   global void doInvoke(
           Object stub,
           Object request,
           Map<String, Object> response,
           String endpoint,
           String soapAction,
           String requestName,
           String responseNS,
           String responseName,
           String responseType) {
               crmasiaDaimlerApacComCustomeridentif.IdentifyCustomerResponse response_x= new crmasiaDaimlerApacComCustomeridentif.IdentifyCustomerResponse();
               crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse  rsp=new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse();
               rsp.TransactionId='12121000';
                 rsp.ResultStatus='OK';
                 rsp.ResultMessage='Success';
                 response_x.CustomerIdentificationResponse=rsp;
               /*crmasiaDaimlerApacComValidateaddress.Address address = new crmasiaDaimlerApacComValidateaddress.Address();
               address.Address_Code = '12121000';
               address.Address_Line_1 = 'address line 1';
               address.Address_Line_2 = 'address line 2';
               address.Block = 'block';
               address.City = 'city';
               address.District = 'district';
               address.Province = 'province';
               address.ZipCode = '1040041';
               address.MarketDiscriminator = 'JP';
               address.valid = true;
               address.ValidFields = 'Address_Line_1__c,Address_Line_2__c,Block__c,City__c,District__c,Province__c';
               list<crmasiaDaimlerApacComValidateaddress.Address> addresses = new list<crmasiaDaimlerApacComValidateaddress.Address>();
               system.debug('## single address value'+address);
               addresses.add(address);
               system.debug('## list of addressess'+addresses);
               
               crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType responseMsg = new crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType();
               
               responseMsg.ValidationStatus  = 'OK';
              //responseMsg.Addresses = addresses;
               system.debug('responseMsg  :'+responseMsg );
               crmasiaDaimlerApacComValidateaddress.ValidateAddressResponse response_x = new crmasiaDaimlerApacComValidateaddress.ValidateAddressResponse();
               response_x.AddressValidationResponseMessage = responseMsg;*/
  
       response.put('response_x',response_x);
               
   }
}