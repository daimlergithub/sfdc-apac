@istest
global class WebServiceMockImplsar1 implements WebServiceMock
    {
        public void doInvoke(
            Object stub, Object request, Map<String, Object> response,
            String endpoint, String soapAction, String requestName,
            String responseNS, String responseName, String responseType)
        {
            if(request instanceof crmasiaDaimlerApacComSarinotificatio.SARILeadNotificationRequestMessageType )
                response.put('response_x', new crmasiaDaimlerApacComSarinotificatio.SARINotificationResponseMessageType ());
            return;
           
        }
    }