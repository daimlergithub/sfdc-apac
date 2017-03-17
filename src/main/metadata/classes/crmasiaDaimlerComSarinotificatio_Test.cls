@istest
private class crmasiaDaimlerComSarinotificatio_Test{

 private static testMethod void method1() { 
   
    new crmasiaDaimlerApacComSarinotificatio.SARINotificationResponseMessageType ();
    new crmasiaDaimlerApacComSarinotificatio.SARINotificationFaultType ();
    new crmasiaDaimlerApacComSarinotificatio.SARILeadNotificationRequestMessageType ();
    new crmasiaDaimlerApacComSarinotificatio.SARICustomerNotificationRequestMessageType ();
      Test.setMock(WebServiceMock.class, new WebServiceMockImplsar());
        new crmasiaDaimlerApacComSarinotificatio.SARINotificationPort().SARICustomerNotification(null,null,null,null,null);
       Test.setMock(WebServiceMock.class, new WebServiceMockImplsar1());
        new crmasiaDaimlerApacComSarinotificatio.SARINotificationPort().SARILeadNotification(null,null,null,null,null);
    
    
    }
    
}