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
private class TestBatchSharingPersonAccountOfComplaint {

    static Id recordTypeRetail = 
        Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();

    static List<Account> accounts = new List<Account>();
    static List<Contact> contacts = new List<Contact>();
    static List<Vehicle__C> cars = new List<Vehicle__C>();
    static List<Vehicle_Relationship__c> vehicleRelates = 
            new List<Vehicle_Relationship__c>();
    static List<User> newUsers = new List<User>();  
    static List<Account> dealers = new List<Account>();
    static User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    static List<Profile> profileIds = [
                Select Id 
                From Profile 
                Where Name ='Dealer-Complaint Manager'];

    @isTest
    static void testA() {
        // TO DO: implement unit test
        //initialData();
      
        List<Account> dealerst = new List<Account>();
        Map<String, Sobject> dealerA = createDealer('KL');
        dealerst.add((Account)dealerA.get('Account'));
        Map<String, Sobject> dealerB = createDealer('KL');
        dealerst.add((Account)dealerB.get('Account'));
        Map<String, Sobject> dealerC = createDealer('AF');
        dealerst.add((Account)dealerC.get('Account'));        
        /**

        Map<String, Sobject> dealerD = createDealer('AF');
        dealerst.add((Account)dealerD.get('Account'));        
        Map<String, Sobject> dealerE = createDealer('DE');
        dealerst.add((Account)dealerE.get('Account'));        
        Map<String, Sobject> dealerF = createDealer('ED');
        dealerst.add((Account)dealerF.get('Account'));        
*/
        Test.StartTest();
        
        List<Account> accountsT = new List<Account>();
        for(integer i = 0; i< 2; i++) {
            Account personAccountA = (Account)UtilTestData.createSobject(new Account(), 
                    UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
            accountsT.add(personAccountA);
                        
            Case MBcomplaint = (Case)UtilTestData.createSobject(new Case(), 
                    UtilTestData.CASE_RT_MB_COMPLAINT);
            
            //Case fireObj = new Case();
            MBcomplaint.AccountId = personAccountA.id;
            MBcomplaint.Case_Dealer__C = dealerst[i].id;
            update MBcomplaint;

        }
        
        system.debug('ready to excuteBatch');
                    
        BatchSharingAccountOfComplaint batch1 = new BatchSharingAccountOfComplaint();
        ID batchprocessid = Database.executeBatch(batch1);
        system.debug(batchprocessid);
        //id bLeadKeeperId = dealerB.get('LeadKeeper').id;
        Test.StopTest();
        
        system.assertEquals(1, [select id from AccountShare where AccountId = :accountsT[0].id and userorgroupid = :dealerB.get('LeadKeeper').id].size());
        system.assertEquals(0, [select id from AccountShare where AccountId = :accountsT[0].id and userorgroupid = :dealerC.get('LeadKeeper').id].size());
        

    }
/**
    @isTest
    static void TestShareCompalintPersonAccountToGateKeeper() {
        // TO DO: implement unit test
        //initialData();
        
        Map<String, Sobject> dealerA = createDealer('KL');
        Map<String, Sobject> dealerB = createDealer('KL');
        Map<String, Sobject> dealerC = createDealer('AF');

        Test.StartTest();
        Account personAccountA = (Account)UtilTestData.createSobject(new Account(), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
                        
        Case MBcomplaint = (Case)UtilTestData.createSobject(new Case(), 
                UtilTestData.CASE_RT_MB_COMPLAINT);
        
        //Case fireObj = new Case();
        MBcomplaint.AccountId = personAccountA.id;
        MBcomplaint.Case_Dealer__C = dealerA.get('Account').id;
        
        update MBcomplaint;
        
        id bLeadKeeperId = dealerB.get('LeadKeeper').id;
        
        system.assertEquals(1, [select id from AccountShare where AccountId = :personAccountA.id and userOrgroupId = :bLeadKeeperId].size());
        
        Test.StopTest();
    }

/**
    @isTest
    static void TestShareAccountLinkPersonAccountToDealer() {
        // TO DO: implement unit test
        //initialData();
        
        Map<String, Sobject> dealerA = createDealer('KL');
        Map<String, Sobject> dealerB = createDealer('KL');
        Map<String, Sobject> dealerC = createDealer('AF');

        Test.StartTest();
        Account personAccountA = (Account)UtilTestData.createSobject(new Account(), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        Account personAccountB = (Account)UtilTestData.createSobject(new Account(), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
                                        
        Account_Link__c accountLink = new Account_Link__c();
        
        //Case fireObj = new Case();
        accountLink.fromRole__c = personAccountA.id;
        accountLink.toRole__c = personAccountB.id;
        accountLink.Name = 'PA-DMS-ABCKL-001XXX';
        
        insert accountLink;
        
        Map<id, User> dealerUser = new Map<Id, User>([select id from User where AccountId = :dealerA.get('Account').id or Accountid = :dealerB.get('Account').id]);
        
        system.assertEquals(8, [select id from AccountShare where AccountId = :personAccountA.id and userOrgroupId in :dealerUser.keyset() ].size());
        
        Test.StopTest();
    }
    
    @isTest
    static void TestShareVRPersonAccountToDealer() {
        // TO DO: implement unit test
        //initialData();
        
        Map<String, Sobject> dealerA = createDealer('KL');
        Map<String, Sobject> dealerB = createDealer('KL');
        Map<String, Sobject> dealerC = createDealer('AF');

        Test.StartTest();
        Account personAccountA = (Account)UtilTestData.createSobject(new Account(), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        Account personAccountB = (Account)UtilTestData.createSobject(new Account(), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
                                        
        Vehicle_Relationship__c vrc = new Vehicle_Relationship__c();
        String retailRvId = UtilRecordType.getRecordTypeIdByName('Vehicle_Relationship__c', 'Vehicle Relationship Retail'); 
        
        vrc.RecordTypeId = retailRvId;
        vrc.Contact__c = personAccountA.id;
        vrc.Owner_Dealer__c = dealerA.get('Account').id;
        
        insert vrc;
        
        Map<id, User> dealerUser = new Map<Id, User>([select id from User where AccountId = :dealerA.get('Account').id]);
        
        system.assertEquals(4, [select id from AccountShare where AccountId = :personAccountA.id and userOrgroupId in :dealerUser.keyset() ].size());
        
        Test.StopTest();
    }
   */  
    /**
     * Create a Dealer and retrun a Map contains info of the dealer
     * key: Account , return account object
     * key: ComplaintKeeper, return case keeper user
     * key: LeadKeeper, return lead keeper user
     *
     */    
    private static Map<String, Sobject> createDealer(String crmCode){
        
        Map<String, Sobject> rtnDealerInfo = new Map<String, Sobject>();
        
        //Following is Create Dealer info
        //A and B have same CRM code
        Account dealer = (Account)UtilTestData.createSobject(new Account(), 
                UtilTestData.ACCOUNT_RT_DEALER);

        dealer.Dealer_Active__c = true;
        dealer.Dealer_DMS_CRM_Code__c = crmCode;
        update dealer;
        rtnDealerInfo.put('Account', dealer);
        
        //AccountA contact
        List<Contact> dealerContacts = new List<Contact>();

        for (integer i = 0; i<4 ; i++){
            //Contact
            Contact contact = (Contact)UtilTestData.createSobject(new Contact(), 
                '');
            contact.AccountId = dealer.id;
            if(i==0){
                contact.Dealer_Complaint_Gate_Keeper__c = true;
            }
            if(i==1){
                contact.Dealer_Lead_Gate_Keeper__c = true;
            }

            dealerContacts.add(contact);
        }
        
        update dealerContacts;
        
        //Create users
        integer i = 0;
        List<User> newUsers1 = new List<User>();  
        System.runAs ( thisUser ) {
            
            for(Contact c: dealerContacts){
                User usr = new User();
                usr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';
                usr.ProfileId = profileIds[0].Id;
                usr.LastName = 'Test User';
                usr.Email = 'test001@daimler.com.full';
                usr.Alias = 'test';
                usr.TimeZoneSidKey = 'Asia/Shanghai';
                usr.EmailEncodingKey = 'UTF-8';
                usr.LanguageLocaleKey = 'en_US';
                usr.localesidkey='en_US';
                usr.contactId = c.ID;
                i++;
                newUsers1.add(usr);
            }
            
            insert newUsers1;

        }
        
         rtnDealerInfo.put('ComplaintKeeper', newUsers1[0]);
         rtnDealerInfo.put('LeadKeeper', newUsers1[1]);
         
         return rtnDealerInfo;
    }

}