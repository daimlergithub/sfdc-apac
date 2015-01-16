/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class AccountHelperTest {

    static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();     // Person Account.
                                    
    static Account customer1 = new Account(Dealer_Default_Flag__c=false,
                                    Dealer_DMS_SR_Code__c='',
                                    Status__c='NoCustomer',
                                    City_CN__c='Beijing',
                                    Gender__c = 'Male',
                                    Phone = '80801010',
                                    Area_code__c = '010',
                                    LastName = 'galaxy1',
                                    Province__c = 'Shanghai',
                                    ZipCode__c='000000',
                                    Allow_Data_Sharing__c='no',
                                    Preferred_Language__c = 'English',
                                    Dealer_LMS__c = 'No',
                                    RecordTypeId=accPerson_RecordTypeId);

    static Account customer2 = new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_SR_Code__c='',
                                    Status__c='xCustomer',
                                    City_CN__c='Beijing',
                                    Phone = '80801010',
                                    Area_code__c = '010',
                                    LastName = 'galaxy2',
                                    ZipCode__c='000000',
                                    RecordTypeId=accPerson_RecordTypeId);

    static Account customer3 = new Account(
                                    Status__c='Customer',
                                    City_CN__c='Beijing',
                                    Phone = '80801010',
                                    Area_code__c = '010',
                                    LastName = 'galaxy2',
                                    ZipCode__c='000000',
                                    RecordTypeId=accPerson_RecordTypeId);                                     
    
    static testMethod void myUnitTest() {
        
        User user1 = UtilTestData.createUser('IB CSR','CAC Data Manager');
   
        system.runAs(user1){
            Test.startTest();
            testMain1();
            testMain2();
            Test.stopTest();
        }
        
    }
    
    
    @future
    private static void testMain1()
    {
        String DealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        String PersonRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        insert customer1;
        
        //test Region_City_Mapping__c is auto setted When account update
        Account dealer = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58392243', Name = 'testdealer');
        insert dealer;
        Lead__c le1 = new Lead__c();
        //le1.Need_Assign_To_Dealer__c = 'Need';
        le1.Assigned_Dealer__c = dealer.id;
        le1.Lead_Type__c = 'New Car';
        le1.Relation_With_The_Leads__c = '本人车主';
        le1.Purchase_Time__c = '0 - 3 months';
        le1.Interested_Vehicle_Brand__c = 'MB';
        le1.Purchase_Time__c = '0 - 3 months';
        le1.Contact__c = customer1.id;
        insert le1;
        customer1.City_CN__c = 'Shanghai';
        customer1.Dealer_Default_Flag__c = true;
        customer1.Allow_Data_Sharing__c = 'yes';
        update customer1;
		
        //test same Dealer_DMS_SR_Code__c and Dealer_Default_Flag__c customer will not be created
        try{
            insert customer2;
        }catch (system.DmlException ex){
            system.assert(ex.getMessage().contains(AccountHelper.ERROR_MSG_CP_010));
        }  
        
    }
    
    @future
    private static void testMain2()
    {
        //test Account having no vehichle relationship, status can not be set Customer
        try{
            insert customer3;
        }catch (system.DmlException ex){
            system.assert(ex.getMessage().contains(AccountHelper.ERROR_MSG_CP_016));
        }
        
        try{
            customer1.Status__c = 'Customer';
            update customer1;
        }catch (system.DmlException ex){
            system.assert(ex.getMessage().contains(AccountHelper.ERROR_MSG_CP_016));
        }
    }
}