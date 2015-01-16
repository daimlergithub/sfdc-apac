@isTest
public class SocialMediaAccountAfterInsertUpdateTest{
    public static testMethod void testTriggerAftersales() {
        Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();     // Person Account.
        Account customer = new Account(Dealer_Default_Flag__c=true,
                                        Dealer_DMS_SR_Code__c='',
                                        Status__c='xCustomer',
                                        City_CN__c='Beijing',
                                        Phone = '80801010',
                                        Area_code__c = '010',
                                        LastName = 'galaxy2',
                                        ZipCode__c='000000',
                                        RecordTypeId=accPerson_RecordTypeId);
        Insert customer;
        
        Test.startTest();
        Social_Media_Account__c sma = new Social_Media_Account__c(
                                        Name = 'Testname01',
                                        Account__c = customer.id,
                                        Nick_Name__c = 'nickName01',
                                        Type__c = 'Weibo');
        
        insert sma;
        
        sma.Name = 'Testname02';
        update sma;
        Test.stopTest();
    }
}