/*
    Type:       Test class for class: ExtSelectAssignedDealer
    Purpose:    Test codes
    User Story: US AU-Lead-007
    Used By:    
    ---------------------------------------------------------------
    History:

    1. Polaris Yu (BreakingPoint) Created on 2013-8-28
*/
@isTest
public class ExtSelectAssignedDealerTest {
	
	private static Id personAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
	private static Id dealerRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
	private static Id finLdRTId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Finance Lead').getRecordTypeId();
	private static Account personAcc;
	private static Account dealer;
	private static Lead__c finLead;
	
    public static testMethod void testSelectAssignedDealer()
    {
        createAccount();
        createPersonAccount();
		createLead();
		test.starttest();
        // Select a dealer for this lead by click the button 'Select Assigned Dealer'
        PageReference pr = new PageReference('/apex/SelectAssignedDealer?Id=' + finLead.Id);
        Test.setCurrentPage(pr);        
        Lead__c objFinLead=[select id from Lead__c where id=:finLead.Id];
        ExtSelectAssignedDealer selectDealer = new ExtSelectAssignedDealer(new ApexPages.StandardController(objFinLead));
        test.stoptest();
        //verify
    }
    
    public static testMethod void testSelectAssignedDealer_query()
    {
        createAccount();
        createPersonAccount();
		createLead();
		test.starttest();
        // Select a dealer for this lead by click the button 'Select Assigned Dealer'
        PageReference pr = new PageReference('/apex/SelectAssignedDealer?Id=' + finLead.Id);
        Test.setCurrentPage(pr);        
        Lead__c objFinLead=[select id from Lead__c where id=:finLead.Id];
        ExtSelectAssignedDealer selectDealer = new ExtSelectAssignedDealer(new ApexPages.StandardController(objFinLead));
        selectDealer.name = 'Beijing';
        selectDealer.dealer.ZipCode__c = '001010';
        selectDealer.dealer.Cars_Offered_Service__c = 'Sales; Service';
        selectDealer.query();
        test.stoptest();
        //verify
    }
    
    public static testMethod void testSelectAssignedDealer_choose()
    {
        createAccount();
        createPersonAccount();
		createLead();
		test.starttest();
        // Select a dealer for this lead by click the button 'Select Assigned Dealer'
        PageReference pr = new PageReference('/apex/SelectAssignedDealer?Id=' + finLead.Id);
        Test.setCurrentPage(pr);        
        Lead__c objFinLead=[select id from Lead__c where id=:finLead.Id];
        ExtSelectAssignedDealer selectDealer = new ExtSelectAssignedDealer(new ApexPages.StandardController(objFinLead));
        selectDealer.choosenDealerId = dealer.Id;
        selectDealer.lead.Id = null;
        selectDealer.choose();
        selectDealer.lead.Id = finLead.Id;
        selectDealer.choose();
        test.stoptest();
        //verify
    }
    
    static void createAccount()
    {
    	dealer = new Account(Status__c = 'Customer'
                                     , Name = 'TestDealer' + date.Today()
                                     , RecordTypeId = dealerRTId
                                     , Phone ='0186770993');
        insert dealer;                             
    }
    
    static void createPersonAccount()
    {
    	personAcc = new Account(Status__c = 'Customer'
                                        , LastName = 'LastName'
                                        , Salutation = 'Mr'
                                        , Title__c = 'Title'
                                        , FirstName = 'FirstName'
                                        , Suffix__c = 'suffix'
                                        , PersonEmail ='test@test.com'
                                        , RecordTypeId = personAccRTId
                                        , PersonMobilePhone ='1800999999');
    	insert personAcc;
    }
    
    static void createLead()
    {
    	 finLead = new Lead__c(Contact__c = personAcc.Id,RecordtypeId=finLdRTId
                                      , Lead_Source__c = 'Web Form'
                                      , Nature_of_Request__c = 'General Enquiry'
                                      , Business_Unit__c = 'Cars'
                                      , Sub_BusinessUnit__c = 'Sales'
                                      , CAC_Lead_Status__c = 'New Enquiry');
        insert finLead;
    }
}