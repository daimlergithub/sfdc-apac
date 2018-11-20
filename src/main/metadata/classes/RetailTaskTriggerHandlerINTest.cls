/*
Created By : Honey
Date : 7/9/2018
Description : This is used for unit test of triggerhandler and helper for IN
*/
@istest
public class RetailTaskTriggerHandlerINTest{
    public Static Account objAccount; 
    public Static Account objAccount2; 
    public Static Account DealerAccount;
    public static Retail_Task__c lead1;
    public static Retail_Task__c lead2;
    public static Retail_Task__c lead3;
    public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    public static String DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
    
    public static testMethod void test_updateCustomerStage11() {  
        Profile p = [SELECT Id FROM Profile WHERE Name='IntegrationAPI']; 
        User u = new User(Alias = 'standt', Email='test@mbj.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id, 
        Market__c='IN',TimeZoneSidKey='America/Los_Angeles',UserName=System.now().millisecond() +'retail'+'testDaimlerUser@Daimler-test.com');
        insert u;
        createTestData();  
        System.runAs(u) {       
            system.debug(u);    
            test.startTest();    
            lead1 = new Retail_Task__c();
            lead1.MD__c = 'IN';
            lead1.Account__c = objAccount.id;
            lead1.Service_Dealer__c = DealerAccount.id;
            lead1.Related_Contact__c=objAccount.id;
            lead1.RecordTypeId =Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Service').getRecordTypeId();  
            system.debug(u);  
            TriggerUtil.userCreate=false;  
            insert lead1; 
            system.debug(u);    
            test.stopTest();        
        }   
    }   
    static void createTestData() {
        Trigger__c TriggerVehicleRelationshipJP=new Trigger__c(Name='RetailTaskTriggerIN',Trigger_Name__c='RetailTaskTrigger',Trigger_Handler__c='RetailTaskTriggerHandlerIN',
        update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='IN');
        insert TriggerVehicleRelationshipJP; 
        objAccount =  new Account(FirstName='TEST',LastName='acc',Md__c='IN', Individual_Home_Phone__c='+6046234824', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
        insert objAccount;
        DealerAccount = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        DealerAccount.Dealer_Nd_code__c='abcd';
        dealerAccount.istestrunning__c=true;
        DealerAccount.market__C='IN';
        update DealerAccount;  
        Group g = new Group(name='INabcd');
        insert g;   
    }  
}