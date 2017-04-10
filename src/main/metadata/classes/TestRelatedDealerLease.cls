@isTest
public class TestRelatedDealerLease{


public static Retail_Task__c Ins;
    private static Account dealer;
    public static Contact contactObj;
     Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
     public static Id AccountLink_ContactSectorRecordTypeId = Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Lease Contract').getRecordTypeId();
    static Testmethod void ValidateInsurance()
        {
        Profile profile= [select Id from Profile where name='Japan Dealer Company Manager'];
          dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123');
        insert dealer;
         Contact dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
        insert dealerContact;
     // Create User 
        User objeUser = new User(alias = 'standt',email = 'test@9876test.com',emailencodingkey = 'UTF-8'
                         , lastname = 'TestLasName', languagelocalekey = 'en_US',ContactID= dealerContact.Id,
                                      localesidkey = 'en_US', profileid =profile.Id,User_Type__c = 'Dealer',
                                      timezonesidkey = 'America/Los_Angeles',  username = 'testUniqudeName@test.com' ); 
        insert objeUser ;  
        system.runas(objeUser ){
            Ins=new Retail_Task__c();
            Ins.RecordtypeId = AccountLink_ContactSectorRecordTypeId ;
            Ins.Contractor_Address1__c='Test1';
            Ins.Booking_Month__c='may';
            Ins.Condition_Change__c='Test2';
            Ins.Premium_Change__c=3465;
            Ins.Company_Name__c='Vcs';
            Ins.Contractor_BirthDate__c=date.today()-10;
            Ins.Contractor_Name__c='rama';
            Ins.Contractor_Name_Native__c='rama1';
            Ins.Condition_Change_Date__c=date.today()-5;
            Ins.Insurance_Company__c='vccs';
            Ins.Insured_Name_Native__c='vccs1';
            Ins.Net_Premium__c=123.00;
            Ins.Net_Premium2__c=456.00;
            Ins.Net_Premium3__c=789.00;
            Ins.Non_MB_Insurance__c='Test4';
            Ins.Outlet_Name__c='Test5';
            Ins.Payment_Method__c='cash';
            Ins.Contractor_Phone1__c='7598623345';
            Ins.Vehicle_Registration_No__c='456738';
            Ins.Contractor_ZipCode1__c='5600032';
            Ins.Related_Dealer__c= dealer.Id;
        insert Ins;
        Test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',Ins.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(Ins);
        RelatedDealerLease I= new RelatedDealerLease(controller);
        Test.StopTest();    
    }
  }

}