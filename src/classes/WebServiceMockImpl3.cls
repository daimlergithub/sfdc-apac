@isTest
global class WebServiceMockImpl3 implements WebServiceMock {
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
            crmasiaDaimlerApacComSarinotificatio.SARINotificationResponseMessageType  res= new crmasiaDaimlerApacComSarinotificatio.SARINotificationResponseMessageType();
            res.TransactionId='1212121';
            response.put('response_x',res);
               
   }
}