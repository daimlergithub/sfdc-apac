@isTest
private class UpdateRetcopyAddressesTest 
{
    @testSetup 
    static void setup() 
    {
        
        
        Account Peracc = new Account(Lastname ='Person account1', EMAIL__C = 'Person@account1.com', Data_Source__c = 'Dealer', FAX= '0214578', INDIVIDUAL_HOME_PHONE__C = '0215444', MOBILE__C = '03256987', WORK_PHONE__C = '03268889', MD__c = 'JP', RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
        insert Peracc;
        Account Comacc = new Account (name = 'company account1', EMAIL__C = 'Company@account1.com',FAX= '02145148', Data_Source__c = 'Dealer', MD__c = 'JP', RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
        insert Comacc;
        Account Dealeracc = new Account (name = 'Dealer account1', EMAIL__C = 'Dealer@account1.com', Data_Source__c = 'Dealer', Dealer_GC_Code__c = 'GC0000', MD__c = 'JP', RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId());
        insert Dealeracc;
        
        
        Address__c PerAddress = new address__c(Customer__c = Peracc.id, Address_Type__c = 'Home', TitleOfHonor__c = 'To Person', Province__c = 'Shanghai', ZipCode__c= '1002347', CITY__C ='Banglore' , ADDRESS_LINE_1__C = 'Address line1', ADDRESS_LINE_2__C = 'Address line2', MD__c = 'JP', Recordtypeid = Schema.SObjectType.Address__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId());
        insert PerAddress;
        Address__c CompAddress = new address__c(Customer__c = Comacc.id, Address_Type__c = 'Home', TitleOfHonor__c = 'To Person', Province__c = 'Shanghai', ZipCode__c= '1002347', CITY__C ='Banglore' , ADDRESS_LINE_1__C = 'Address line1', ADDRESS_LINE_2__C = 'Address line2', MD__c = 'JP', Recordtypeid = Schema.SObjectType.Address__c.getRecordTypeInfosByName().get('Company').getRecordTypeId());
        insert CompAddress;
        
        
        Account_link__c RetPer = new Account_link__c(Name='RetPer1', MD__c='JP',toRole__c=Peracc.id, FromRole__C = Dealeracc.id, Retail_Address_Reference__c=PerAddress.id, RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId());
        Insert RetPer;
        Account_link__c RetComp = new Account_link__c(Name='RetPer1', MD__c='JP',toRole__c=Peracc.id, FromRole__C = Dealeracc.id, Retail_Address_Reference__c=PerAddress.id, RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId());
        insert RetComp;
    }
    
    static testmethod void test() 
    {        
        Test.startTest();
        UpdateRetcopyAddresses URA = new UpdateRetcopyAddresses();
        Id batchId = Database.executeBatch(URA);
        Test.stopTest();
    }
}
