@istest
global class WebServiceMockImplapac1 implements WebServiceMock
    {
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType)
        {
            if(request instanceof crmasiaDaimlerApacComSfdcnotificatio.SARICustomerNotificationRequestMessageType )
                response.put('response_x', new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType());
            return;
           
        }
    }