/*
    Type:       Test class of CaseEscalationController
    Purpose:    1. Escalate Case to Region Q
                2. Escalate Case to Central Q
    
    User Story: US-DP-013, US-DP-015
    Used By:    
    ---------------------------------------------------------------
    History:
    
    2014-02-17 Shuang Li (NTTData)  Created
*/     
@isTest
public class LeadMassChangeDealerControllerTest 
{
	private static final Id leadFinanceRT = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Finance Lead').getRecordTypeId();
	private static final Id dealerRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
	private static Account dealer1= new Account();
	private static Account dealer2= new Account();
	private static Account personAccount= new Account();
	private static Retail_Task__c retailTask= new Retail_Task__c();
	private static Lead__c lead1= new Lead__c();
	private static Lead__c lead2= new Lead__c();
	static Account personaccount1 = TestDataUtil.getInstance().standardPersonAccount;
	
    @isTest
    static void testLeadMassChangeDealerController()
    {
    	//prepare test data
        init();
        
        //process
        Test.startTest();
        PageReference leadMassChangeDealer = Page.LeadMassChangeDealer;
        leadMassChangeDealer.getParameters().put('objIds',lead1.id + ',' + lead2.id);
        Test.setCurrentPage(leadMassChangeDealer);
        LeadMassChangeDealerController controller = new LeadMassChangeDealerController();
        Test.stopTest();
        
        //verify
        
    }
    
    @isTest
    static void testLeadMassChangeDealerController_saveClick()
    {
    	//prepare test data
        init();
        
        //process
        Test.startTest();
        PageReference leadMassChangeDealer = Page.LeadMassChangeDealer;
        leadMassChangeDealer.getParameters().put('objIds',lead1.id + ',' + lead2.id);
        Test.setCurrentPage(leadMassChangeDealer);
        LeadMassChangeDealerController controller = new LeadMassChangeDealerController();
        controller.assignedDealer = dealer2.id;
        controller.emailRequired = true;
        controller.saveClick();
        Test.stopTest(); 
    }
    
    @isTest
    static void testLeadMassChangeDealerController_saveClick_assignedDealer_null()
    {
    	//prepare test data
        init();
        
        //process
        Test.startTest();
        PageReference leadMassChangeDealer = Page.LeadMassChangeDealer;
        leadMassChangeDealer.getParameters().put('objIds',lead1.id + ',' + lead2.id);
        Test.setCurrentPage(leadMassChangeDealer);
        LeadMassChangeDealerController controller = new LeadMassChangeDealerController();
        controller.assignedDealer = '';
        controller.emailRequired = true;
        controller.saveClick();
        Test.stopTest(); 
    }
    
    @isTest
    static void testLeadMassChangeDealerController_saveClick_assignedDealerName()
    {
    	//prepare test data
        init();
        
        //process
        Test.startTest();
        PageReference leadMassChangeDealer = Page.LeadMassChangeDealer;
        leadMassChangeDealer.getParameters().put('objIds',lead1.id + ',' + lead2.id);
        Test.setCurrentPage(leadMassChangeDealer);
        LeadMassChangeDealerController controller = new LeadMassChangeDealerController();
        controller.assignedDealer = '';
        controller.assignedDealerName = 'TestDealer';
        controller.emailRequired = true;
        controller.saveClick();
        Test.stopTest(); 
    }
    
    @isTest
    static void testLeadMassChangeDealerController_choose()
    {
    	//prepare test data
        init();
        
        //process
        Test.startTest();
        PageReference leadMassChangeDealer = Page.LeadMassChangeDealer;
        leadMassChangeDealer.getParameters().put('objIds',lead1.id + ',' + lead2.id);
        Test.setCurrentPage(leadMassChangeDealer);
        LeadMassChangeDealerController controller = new LeadMassChangeDealerController();
        controller.choose();
        Test.stopTest(); 
    }
    
    @isTest
    static void testLeadMassChangeDealerController_query()
    {
    	//prepare test data
        init();
        
        //process
        Test.startTest();
        PageReference leadMassChangeDealer = Page.LeadMassChangeDealer;
        leadMassChangeDealer.getParameters().put('objIds',lead1.id + ',' + lead2.id);
        Test.setCurrentPage(leadMassChangeDealer);
        LeadMassChangeDealerController controller = new LeadMassChangeDealerController();
        controller.query();
        Test.stopTest(); 
    }
    
    @isTest
    static void testLeadMassChangeDealerController_query_name()
    {
    	//prepare test data
        init();
        
        //process
        Test.startTest();
        PageReference leadMassChangeDealer = Page.LeadMassChangeDealer;
        leadMassChangeDealer.getParameters().put('objIds',lead1.id + ',' + lead2.id);
        Test.setCurrentPage(leadMassChangeDealer);
        LeadMassChangeDealerController controller = new LeadMassChangeDealerController();
        controller.name='TestDealer';
        controller.query();
        Test.stopTest(); 
    }
    
    static Account createAccount()
    {
    	Account accDealer = new Account(Status__c = 'Customer'
                                     , Name = 'TestDealer' + date.Today()
                                     , RecordTypeId = dealerRTId
                                     , Phone ='(01) 8677 0993'
                                     , Dealer_Active__c = true
                                     , Inactivation_Date__c = date.Today().addDays(100)
                                     , Dealer_Reason_for_Inactivation__c = 'Test Record');
        return accDealer;                             
    }
    
    static Retail_Task__c createRetailTask()
    {
    	Retail_Task__c objRT = new Retail_Task__c ( Account__c = personaccount1.Id,
                                            StartDate__c = Date.Today(),
                                            Duration__c = 2,
                                            Status__c = 'Draft');
        return objRT;                                    
    }
    
    static Lead__c createLead()
    {
    	Lead__c leadObj = new Lead__c ( RecordTypeId = leadFinanceRT,
                                      Contact__c = personaccount1.id,
                                      Lead_Source__c = 'End of Contract',
                                      Nature_of_Request__c = 'Key2Key',
                                      Business_Unit__c = 'Cars',
                                      Sub_BusinessUnit__c = 'Sales',
                                      CAC_Lead_Status__c = 'New Enquiry',
                                      //Financial_Product__c = 'Agility Contract',
                                      Is_Finance_Send_Email_Before_60_Days__c = true);
        return  leadObj;                             
    }
    
    static void init()
    {
    	dealer1=createAccount();
        dealer2=createAccount();
        insert dealer1;
        insert dealer2;
        insert personaccount1;
        retailTask = createRetailTask();
        insert retailTask;
        lead1 = createLead();
        lead1.Assigned_Dealer__c = dealer1.id;
        lead1.Existing_Contract__c = retailTask.id;
        insert lead1;
        lead2 = createLead();
        lead2.Assigned_Dealer__c = dealer1.id;
        lead2.Existing_Contract__c = retailTask.id;
        insert lead2;
    }
}