@isTest
public class RelatedDealerViewForLoanTest
{
    public static Retail_Task__c Loann;
      private static Account dealer;
    public static Contact contactObj;
     Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
     public static Id AccountLink_ContactSectorRecordTypeId = Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Loan Contract').getRecordTypeId();
    static Testmethod void ValidateLoan()
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
            Loann=new Retail_Task__c();
            Loann.RecordtypeId = AccountLink_ContactSectorRecordTypeId ;
            Loann.Bank_Account_Name_Native__c='Test1';
            Loann.Bank_Account_Name__c='may';
            Loann.Actual_Maturity_Date__c=date.today()-10;
            Loann.Contractor_Address1_Native__c='Vcs';
            Loann.Contractor_Address1__c='Test2';
            Loann.Annual_Income__c=10000;
            Loann.Balloon_RV_Amount__c=2000;
            Loann.Bonus_Amount1__c=250;
            Loann.Bonus_Amount2__c=300;
            Loann.Bonus_Month1__c='200';
            Loann.Bonus_Month2__c='250';
            Loann.Campaign_Description__c='Test3';
            Loann.Contractor_BirthDate__c=date.today();
            Loann.Contractor_Company_Name_Native__c='Test5';
            Loann.Contractor_Company_Name__c='ccs';
            Loann.Contractor_Mail__c='jsdn@gmail.com';
            Loann.Contractor_Gender__c='male';
            Loann.Credit_Loan_Company_Name__c='Test4';
           Loann.Related_Dealer__c= dealer.Id;
        insert Loann;
        Test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',Loann.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(Loann);
        RelatedDealerViewForLoan Lo= new RelatedDealerViewForLoan(controller);
        Test.StopTest();
        }
     }   
}