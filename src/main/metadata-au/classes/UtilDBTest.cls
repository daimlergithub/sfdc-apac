@isTest 
public class UtilDBTest {
    public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    private static Account personAcc;
    private static list<Account> lst;
    private static void createTestData(){
        personAcc = new Account(Dealer_Default_Flag__c=false,
                                   Dealer_DMS_SR_Code__c='test code 2',
                                    Status__c='NoCustomer',
                                    City__c='Beijing',
                                    Gender__c = 'Male',
                                    Phone = '801801010',
                                    Area_code__c = '0101',
                                    LastName = 'galaxy1',
                                    FirstName = 'First Name',
                                    Salutation = 'Unknown',      
                                    Province__c = 'Shanghai',
                                    ZipCode__c='0000001',
                                    //Allow_Data_Sharing__c='yes',
                                    Preferred_Language__c = 'English',
                                    Dealer_Lead_System__c = 'Salesforce',Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',Home_Phone_2__c = '98765413',
                                    
                                    RecordTypeId=accPerson_RecordTypeId);
       
       
        personAcc.Allow_Data_Sharing__c='yes';
       // update personAcc;
        
    }
    
    private static testmethod void testUpdateSobjects(){
        createTestData();
        lst = new  list<Account>();
        lst.add(personAcc);
        
     
        UtilDB.updateSobjects(lst);
         
       // UtilDB.deleteSobjects(lst);
        
        
    }
    private static testmethod void testInsertSobjects(){
        createTestData();
        insert personAcc;
        lst = new  list<Account>();
        lst.add(personAcc);
        
     
       
          UtilDB.insertSobjects(lst);
       // UtilDB.deleteSobjects(lst);
        
        
    }
     private static testmethod void testDeleteSobjects(){
        createTestData();
          insert personAcc;
         delete personAcc;
        lst = new  list<Account>();
        lst.add(personAcc);
        
     
       // UtilDB.updateSobjects(lst);
         
       UtilDB.deleteSobjects(lst);
        
        
    }

}