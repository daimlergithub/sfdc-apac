@istest
public with sharing class UtilAccountTest 
{
    public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static List<Account> acc1 = Database.query('select id from Account where Id =:accPerson_RecordTypeId');
    public static Account personAcc;
    public static Account personAcc2;
    public static Lead__c testLead;  
    
    
    public static testmethod void test_updateLeadForDataSharing()
    {
        CreateTestData();
        test.startTest();
        Set<Id> accIds = new set<Id>();
        accIds = (new Map<Id,SObject>(acc1)).keyset();
        List<Account> accList = new List<Account>();
        Map<id,Account> accMap = new Map<id,Account>();
        accList.add(personAcc);
        accMap.put(personAcc.id, personAcc);
        UtilAccount.beforeAccDealerInfo(accList, accMap, true, false);
        UtilAccount.beforeAccDealerInfo(accList, accMap, false, true);
        UtilAccount.accountSetForUpdateLead(accList, accMap);
       // accIds.add(personAcc.id);
        //accIds.add(personAcc2.id);
        UtilAccount.updateLeadForDataSharing(accIds);
        
        test.stopTest();
        
        system.assertNotEquals(true, testLead.Allow_Data_Sharing__c);
        
    }
    
    
    static void CreateTestData()
    {
        personAcc = new Account(Dealer_Default_Flag__c=true,
                                   // Dealer_DMS_SR_Code__c='test code 2',
                                    Status__c='NoCustomer',
                                    City__c='Beijing',
                                    Gender__c = 'Male',
                                    Phone = '001801010',
                                    Area_code__c = '0101',
                                    LastName = 'galaxy1',
                                    FirstName = 'First Name',
                                    Salutation = 'Unknown',      
                                    Province__c = 'Shanghai',
                                    ZipCode__c='1004563',
                                    Allow_Data_Sharing__c='yes',
                                    Preferred_Language__c = 'English',
                                    Dealer_Lead_System__c = 'Salesforce',Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',
                                    Mobile__c ='01234567652',Allow_Data_Sharing_Comment__c='Comments',
                                    RecordTypeId=accPerson_RecordTypeId);
       
       insert personAcc;
       
       personAcc2 = new Account(Dealer_Default_Flag__c=false,
                                    Dealer_DMS_SR_Code__c='test code 1',
                                    Status__c='NoCustomer',
                                    City__c='Beijin',
                                    Gender__c = 'Male',
                                    Phone = '08080101',
                                    Area_code__c = '0100',
                                    LastName = 'galaxy1',
                                    FirstName = 'First Name',
                                    Salutation = 'Unknown',      
                                    Province__c = 'Shanghai',
                                    ZipCode__c='1004356',
                                    Allow_Data_Sharing__c='no',
                                    Preferred_Language__c = 'English',
                                    Dealer_Lead_System__c = 'Salesforce',Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',
                                    Mobile__c ='01234567891',Allow_Data_Sharing_Comment__c='Comments',RecordTypeId=accPerson_RecordTypeId);
       
       insert personAcc2;
        
        testLead = new Lead__c();
        //testLead.Need_Assign_To_Dealer__c = 'Need';
        testLead.Contact__c = personAcc.id;
        testLead.RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
        testLead.Lead_Type__c = 'New Car';
        testLead.Relation_With_The_Leads__c = 'I owner';
        testLead.Purchase_Time__c = '0 - 3 months';
        testLead.Interested_Vehicle_Brand__c = 'MB';
        testLead.Purchase_Time__c = '0 - 3 months';
        
        insert testLead;
        
    }


}