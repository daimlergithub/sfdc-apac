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
private class ReservationMessageTemplateTest {
    private static Event evnt;
    private static User usr;
    private static User userrecord;
    private static Account Dealer;
    private static Contact con;
    private static Contact cont;
    private static Contract ct;
    private static Lead__c le;    
    private static Order od;
    
     static testMethod void TestReservationMessageTemplate()
    { 
        prepareTestData();
        test.startTest();
        ReservationMessageTemplate.getNewReservationToCustomerMessage(evnt,cont,od);
        ReservationMessageTemplate.getNewReservationToInstructorMessage(evnt,userrecord,cont,od);                        
        ReservationMessageTemplate.getCancelReservationToCustomerMessage(evnt,cont);
        ReservationMessageTemplate.getCancelReservationToInstructorMessage(evnt,userrecord,cont);
        ReservationMessageTemplate.getUpdateReservationToCustomerMessage(evnt,cont);
        ReservationMessageTemplate.getUpdateReservationToInstructorMessage(evnt,userrecord,cont);
        ReservationMessageTemplate.getLeadFollowUpToCustomerWithDealer(le,dealer,userrecord,dealer);
        ReservationMessageTemplate.getLeadFollowUpToInstructor(le,dealer,userrecord);
        ReservationMessageTemplate.getLeadFollowUpToCustomerWithoutDealer(le,dealer,userrecord);
        ReservationMessageTemplate.getSMSContent(le,dealer,userrecord,dealer,'test');
        test.stopTest();
        system.assertEquals('Test lastname', cont.Name);
    }
    public static void prepareTestData(){
        String DealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
        dealer = new Account(RecordTypeId = DealerRecordtypeid, Phone = '058392243', Name = 'testdealer',ID_Number__c='123456');
        insert dealer;

        con = new Contact(AccountId = dealer.Id,firstName='Test', LastName = 'lastname',Salutation='Mr',Title='test', Phone = '0123', email = 's@s.s');
        insert con;
        
        cont=[select id,name,MobilePhone,Account.ID_Number__c from contact where id=:con.id];
            ct = new Contract();
            ct.AccountId = dealer.Id;
            ct.Status = 'Draft';
            ct.StartDate = Date.Today();
            ct.ContractTerm = 12;
        insert ct;
                        
        od = new Order();
            od.Name = '14TPE000001';
            od.AccountId = dealer.Id;
            od.EffectiveDate = Date.Today();
            od.ContractId = ct.Id;
            od.Status = 'Draft';
        insert od;
            
        Profile DealerDelegatedAdmin = [select Id from Profile where Name = 'System Administrator'];
        
        // Create a portal user and validate No of Dealer Portal Licenses
        usr = new User(
          Username = System.now().millisecond() + 'test23456@test.com',
          ProfileId = DealerDelegatedAdmin.Id,
          Alias = 'test123',
          Email = 'test12345@test.com',
          EmailEncodingKey = 'UTF-8',
          LastName = 'McTesty',
          CommunityNickname = System.now().millisecond() + 'test23456',
          TimeZoneSidKey = 'America/Los_Angeles',
          LocaleSidKey = 'en_US',
          LanguageLocaleKey = 'en_US'
        );
         insert usr;
        userrecord=[select id,name from user where id=:usr.id];
        
        le = new Lead__c();
        le.Assigned_Dealer__c = dealer.id;
        le.RecordTypeId = afterSalesRecordTypeId;
        insert le;
            
        evnt = new Event( Whoid=con.id,Subject='Test subject',StartDateTime=system.today(),ActivityDate=system.today()+1,EndDateTime=system.today()+2);
        insert evnt;
    }
}