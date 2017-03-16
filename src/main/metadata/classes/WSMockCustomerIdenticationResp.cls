@isTest
global class WSMockCustomerIdenticationResp implements WebServiceMock {
	global void doInvoke(Object stub, Object request, Map<String, Object> response, String endpoint, 
							String soapAction, String requestName, String responseNS, String responseName,
								String responseType) {
		crmasiaDaimlerApacComValidateaddress.Address address = new crmasiaDaimlerApacComValidateaddress.Address();
	   	address.Address_Code = '12121000';
	   	address.Address_Line_1 = 'address line 1';
	   	address.Address_Line_2 = 'address line 2';
	   	address.Block = 'block';
	   	address.City = 'city';
	   	address.District = 'district';
	   	address.Province = 'province';
	   	address.ZipCode = '1040041';
	   	address.MarketDiscriminator = 'JP';
		address.valid = false;

   		list<crmasiaDaimlerApacComValidateaddress.Address> addresses = new list<crmasiaDaimlerApacComValidateaddress.Address>();
   		addresses.add(address);

   		crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType responseMsg = new crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType();
   		responseMsg.ValidationStatus  = 'OK';
   		responseMsg.Addresses = addresses;
		
		crmasiaDaimlerApacComValidateaddress.ValidateAddressResponse response_x = new crmasiaDaimlerApacComValidateaddress.ValidateAddressResponse();
        response_x.AddressValidationResponseMessage = responseMsg;
        
        response.put('response_x',response_x );
	}
}