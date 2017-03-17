@istest
private class crmasiaDaimlerApacComSfdcnot_Test{

 private static testMethod void method1() { 
   
    new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType();
    new crmasiaDaimlerApacComSfdcnotificatio.SPOCustomerNotificationRequestMessageType();
     new crmasiaDaimlerApacComSfdcnotificatio.SARICustomerNotificationRequestMessageType();
      new crmasiaDaimlerApacComSfdcnotificatio.SARILeadNotificationRequestMessageType();
       new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationFaultType();
        new crmasiaDaimlerApacComSfdcnotificatio.JPOSCustomerNotificationRequestMessageType(); 
        Test.setMock(WebServiceMock.class, new WebServiceMockImplapac());
        new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationPort().SARILeadNotification(null,null,null,null,null,null);
       Test.setMock(WebServiceMock.class, new WebServiceMockImplapac1());
        new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationPort().SARICustomerNotification(null,null,null,null,null,null);
        Test.setMock(WebServiceMock.class, new WebServiceMockImplapac2());
         new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationPort().JPOSCustomerNotification(null,null,null,null,null);
         Test.setMock(WebServiceMock.class, new WebServiceMockImplapac3());
          new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationPort().SPOCustomerNotification(null,null,null,null);
    }
    
}