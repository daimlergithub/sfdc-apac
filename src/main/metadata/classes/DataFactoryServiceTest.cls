@isTest
public class DataFactoryServiceTest {
    
    static testMethod void callingDataFactory(){
        // Create account record
        list<Account> testAccount = (list<Account>)DataFactoryServices.CreateRecords('Account',new list<String>{'Name','Individual_Home_Phone__c'},'Test',1);
        DMLManagerService.insertAsSystem(testAccount);
        //System.assertEquals('Test1',testAccount[0].Name,'Error in DataFactoryService.CreateRecords - Stacktrace: ' + DiagnosticsInstrumentation.ExceptionTrace);

        // Create contact record
        list<Contact> testContact = (list<Contact>)DataFactoryServices.CreateRecords('Contact',new list<String>{'LastName'},'Test',1);
        DMLManagerService.insertAsSystem(testContact);
        //System.assertEquals('Test1',testContact[0].LastName,'Error in DataFactoryService.CreateRecords - Stacktrace: ' + DiagnosticsInstrumentation.ExceptionTrace);

        // Relate contact record to account record
        test.startTest();
        DataFactoryServices.CreateRelationships(testContact, testAccount, 'AccountId');
        DMLManagerService.updateAsSystem(testContact);
        test.stopTest(); 
        //System.assertEquals(testAccount[0].Id,testContact[0].AccountId,'Error in DataFactoryService.CreateRelationships - Stacktrace: ' + DiagnosticsInstrumentation.ExceptionTrace);
    }
}