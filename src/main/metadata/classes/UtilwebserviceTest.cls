@istest
public class UtilwebserviceTest 
{
   public static Address__c Addressobj ;
   public static Address__c custAddress;
   public static Account objAccount ; 
     private static Account contact;
   private static Account dealer;
   private static Account_Link__c contact2Contact ;
    public static Lead__C lead1;
   public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
   public static Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(); 
    Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
    static testmethod void UtilWebserviceTest()
    {
        createTestData();
        test.startTest();
        crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType response = new crmasiaDaimlerApacComValidateaddress.AddressValidationResponseMessageType();
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        response = UtilWebservice.validateAddressByZipCode(addressobj);
        
        system.debug('response-->>>>'+ response.ValidationStatus);
        
        test.stopTest();
        system.assertEquals('OK', response.ValidationStatus);
    }
    
    static testmethod void UtilWebserviceTest1()
    {
        createTestData();
        test.startTest();
        crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse custresponse = new crmasiaDaimlerApacComCustomeridentif.CustomerIdentificationResponse();
       Test.setMock(WebServiceMock.class, new WebServiceMockImpl2());
        
        custresponse = UtilWebservice.validateCustomerDetails(objAccount);
        custresponse = UtilWebservice.validateCustomerDetailsWithAddress(objAccount,Addressobj);
        //system.debug('custresponse -->>>>'+ custresponse.ResultStatus);
        test.stopTest();
        //system.assertEquals('OK', custresponse.ResultStatus);
    }
     static testmethod void UtilWebserviceTest5()
    {
        createTestData();
        test.startTest();
        crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType response = new crmasiaDaimlerApacComSfdcnotificatio.SFDCNotificationResponseMessageType();
        Test.setMock(WebServiceMock.class, new WebServiceMockImplapac ());
        try{
        response = UtilWebservice.AccountIfnoSendSPO(objAccount.Id,Dealer.Id);     
        }catch(exception e){}
        test.stopTest();
        
    }
    
    static testmethod void UtilWebserviceTest2()
    {
        createTestData();
        test.startTest();
       Test.setMock(WebServiceMock.class, new WebServiceMockImplsar1 ());
       try{
        UtilWebservice.LeadIfnoSendToAL(lead1.Id,dealer.Id,contact2Contact.Id);  
        }catch(exception e){}    
        test.stopTest();
       
    }
    static testmethod void UtilWebserviceTest3()
    {
        createTestData();
        test.startTest();
       Test.setMock(WebServiceMock.class, new WebServiceMockImplsar ());
       try{
        UtilWebservice.AccountLinkIfnoSendToAL(objAccount.Id,dealer.Id,contact2Contact.Id);  
        
        }catch(exception e){}    
        test.stopTest();
       
    }
    static testmethod void UtilWebserviceTest4()
    {
        createTestData();
        test.startTest();
       Test.setMock(WebServiceMock.class, new WebServiceMockImplapac());
       try{
        UtilWebservice.AccountIfnoSendToJPOS(objAccount.Id,addressobj.Id,dealer.Id);  
        }catch(exception e){}    
        test.stopTest();
       
    }
     static testmethod void UtilWebserviceTest6()
    {
        createTestData();
        test.startTest();
        try{
      UtilWebservice.entityUpdateNotification('Test','Test','Test','Test','Test','Test');
      }catch(exception e){}
        test.stopTest();
       
    }
    
    static void createTestData()
    {  
     
       objAccount= new Account();
       objAccount.RecordtypeId= companyAccRecordTypeId;
       objAccount.Name='Test Person 1st';
       objAccount.Status__c='Active';
       objAccount.Province__c='Province1';
       objAccount.City__c='Test';
       objAccount.ZipCode__c = '1040044';
       objAccount.Email__c='test@mbj.com';
       objAccount.MBK_Data_Source__c='Email';
       //objAccount.Mobile__c ='000-0000-8899';
       objAccount.Phone = '08022420181';
       insert objAccount;
        
       addressobj =  new Address__C();
       addressobj.Address_Type__c = 'Home';
       addressobj.Address_Line_1__c= 'line 1';
       addressobj.Address_Line_2__c = 'line 2';
       addressobj.Province__c='Province1';
       addressobj.Block__c = 'Block';
       addressobj.Customer__c = objAccount.id;
       addressobj.ZipCode__c = '1040041';
       insert addressobj;
       
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123');
        insert dealer;
  contact2Contact = new Account_Link__c(RecordTypeId = AccountLink_RetailPersonRecordTypeId , Name = 'contact2Contact', toRole__c=objAccount.id , fromRole__c = dealer.Id ,CorrelationID__c = 'Test1234');
    insert contact2Contact ; 
       contact = (Account)UtilTestData.createSobject(new Account(Mobile__c ='0001234567'), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);

        RecordType retailLeadType = [select Id, developername from recordtype where sobjecttype = 'lead__c' and developername = 'Retail_Sales_Leads'];
        lead1 = new Lead__c(Assigned_Dealer__c = dealer.Id, Contact__c = contact.Id, RecordTypeId = retailLeadType.Id);
        insert lead1;
    }
    private static testMethod void coverTypes()
    {
        new crmasiaDaimlerApacComSarinotificatio.SARINotificationResponseMessageType();
        new crmasiaDaimlerApacComSarinotificatio.SARINotificationFaultType();
        new crmasiaDaimlerApacComSarinotificatio.SARILeadNotificationRequestMessageType(); 
        new crmasiaDaimlerApacComSarinotificatio.SARICustomerNotificationRequestMessageType(); 
        new crmasiaDaimlerApacComSarinotificatio.SARINotificationPort(); 
        
         test.startTest();
         crmasiaDaimlerApacComSarinotificatio.SARINotificationPort req=new crmasiaDaimlerApacComSarinotificatio.SARINotificationPort();
         Test.setMock(WebServiceMock.class, new WebServiceMockImpl3());
        String response=req.SARICustomerNotification('test','test','test','test','test');
        
        test.stopTest();

    }   
     private static testMethod void coverMethos()
    {
        new crmasiaDaimlerApacComSarinotificatio.SARINotificationResponseMessageType();
        new crmasiaDaimlerApacComSarinotificatio.SARINotificationFaultType();
        new crmasiaDaimlerApacComSarinotificatio.SARILeadNotificationRequestMessageType(); 
        new crmasiaDaimlerApacComSarinotificatio.SARICustomerNotificationRequestMessageType(); 
        new crmasiaDaimlerApacComSarinotificatio.SARINotificationPort(); 
        
         test.startTest();
         crmasiaDaimlerApacComSarinotificatio.SARINotificationPort req=new crmasiaDaimlerApacComSarinotificatio.SARINotificationPort();
         Test.setMock(WebServiceMock.class, new WebServiceMockImpl3());
        String response=req.SARILeadNotification('test','test','test','test','test');
        
        test.stopTest();

    }   
}