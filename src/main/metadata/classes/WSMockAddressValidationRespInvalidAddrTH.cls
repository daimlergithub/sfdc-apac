@isTest
global class WSMockAddressValidationRespInvalidAddrTH implements WebServiceMock {
  global void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, 
              String soapAction, String requestName, String responseNS, String responseName,
                String responseType) {
    crmasiaDaimlerApacComCustomeridentif.Address address = new crmasiaDaimlerApacComCustomeridentif.Address();
       address.Address_Code_xc= '12121000';
       address.Address_Line_1_xc= 'address line 1';
       address.Address_Line_2_xc= 'address line 2';
       address.Block_xc= 'block';
       address.City_xc= 'city';
       address.District_xc= 'district';
       address.Sub_District_xc= 'Sub district';
       address.Country_xc='Thailand';
       address.Province_xc= 'province';
       address.ZipCode_xc= '14287';
       //address.MarketDiscriminator = 'TH';
       //address.valid = false;
       
      crmasiaDaimlerApacComCustomeridentif.Customer Cust = new crmasiaDaimlerApacComCustomeridentif.Customer ();
       Cust .Firstname= 'sanjay';
       Cust .lastName= 'sanjay';
       Cust.Mobile_xc='+66-03-777-9999';
       Cust.RecordType='Customer';
       Cust.Salutation='Mr.';
       CUST.Email_xc='sanjay13najd@daimler.com';
       Cust.Name='Test Person 21st';
       //Cust.Address_xc='address line 1';
        cust.Vin='1232';
      
       list<crmasiaDaimlerApacComCustomeridentif.Address> addresses = new list<crmasiaDaimlerApacComCustomeridentif.Address>();
       addresses.add(address);
       cust.Address_xc=addresses;
       List<crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponseMessageType> responseMsg = new List<crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponseMessageType> ();
       crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponseMessageType  rep= new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponseMessageType();
      system.debug('ttt');
        rep.IdentificationStatus= 'OK';
     //   rep.MarketDiscriminator='TH';
       //responseMsg.Customer.= ;
       rep.Customer=Cust ;
       responseMsg.add(rep);
      
       crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse response_x1 = new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse ();
       response_x1.CustomerIdentificationResponseMessage= responseMsg;
        crmasiaDaimlerApacComCustomeridentif.IdentifyCustomerResponse response_x= new crmasiaDaimlerApacComCustomeridentif.IdentifyCustomerResponse();
       response_x.CustomerIdentificationResponse=response_x1;
        response.put('response_x',response_x );
  }
}