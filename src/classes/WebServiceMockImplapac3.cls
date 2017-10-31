@istest
global class WebServiceMockImplapac3 implements WebServiceMock
    {
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType)
        {
           if(request instanceof crmasiaDaimlerApacComSfdcnotificatio.SPOCustomerNotificationRequestMessageType )
                response.put('response_x', new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType());
            return;
           
        }
    }