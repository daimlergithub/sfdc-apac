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
private class TestDealerSharingInTrigger {

    static User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
    static List<Profile> profileIds = [
                Select Id 
                From Profile 
                Where Name ='Dealer-Complaint Manager'];
                
    @isTest
    static void TestDealerSharing() {
        //initialData();
        
        Map<String, Sobject> dealerA = createDealer('KL');
        Map<String, Sobject> dealerB = createDealer('KL');

        Test.StartTest();
        system.assertEquals(4, [select id from AccountShare where AccountId = :dealerB.get('Account').id and userorgroupId in (select id from user where Accountid = :dealerA.get('Account').id)].size());
        
        Test.StopTest();
    }    
    
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