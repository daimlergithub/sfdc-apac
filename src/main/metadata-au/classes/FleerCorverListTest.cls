/*
    Type:       Test class of FleerCorverList
    2015-05-06 Sinow zhang Created
*/     
@isTest
public class FleerCorverListTest {
        @isTest
        static void testCaseEscalationController1(){
            
        //prepare test data
        Id leadFinanceRT = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Finance Lead').getRecordTypeId();
        Id dealerRTId
            = Schema.SObjectType.Account.getRecordTypeInfosByName()
              .get('Dealer').getRecordTypeId();
        Account dealer1 = new Account(Status__c = 'Customer'
                                     , Name = 'TestDealer' + date.Today()
                                     , RecordTypeId = dealerRTId
                                     , Phone ='(01) 8677 0993'
                                     , Dealer_Active__c = true
                                     , Inactivation_Date__c = date.Today().addDays(100)
                                     , Dealer_Reason_for_Inactivation__c = 'Test Record');
        insert dealer1;

        Account personaccount1 = TestDataUtil.getInstance().standardPersonAccount;
        insert personaccount1;
        
                                                  
        Vehicle__c vehicle = new Vehicle__c();
        insert vehicle;
            
            RecordType contractType = [select Id from RecordType where SObjectType = 'Retail_Task__c' and DeveloperName = 'contract' limit 1];
        Retail_Task__c contract = new Retail_Task__c(RecordTypeId = contractType.Id, Related_Dealer__c = dealer1.Id, Related_Vehicle__c = vehicle.Id);
        insert contract;
            
        Lead__c lead1 = new Lead__c ( RecordTypeId = leadFinanceRT,
                                      Contact__c = personaccount1.id,
                                      Lead_Source__c = 'End of Contract',
                                      Nature_of_Request__c = 'Key2Key',
                                      Business_Unit__c = 'Cars',
                                      Sub_BusinessUnit__c = 'Sales',
                                      CAC_Lead_Status__c = 'New Enquiry',
                                      Assigned_Dealer__c = dealer1.id,
                                      Existing_Contract__c = contract.id,
                                      //Financial_Product__c = 'Agility Contract',
                                      Is_Finance_Send_Email_Before_60_Days__c = true);
                                      
        insert lead1;
		
         //start test
        Test.startTest();
        PageReference Fleetsettlementchecklist = Page.Fleet_settlement_checklist;
        Test.setCurrentPage(Fleetsettlementchecklist);
         ApexPages.currentPage().getParameters().put('isDownload', 'true');
        FleerCorverList controller = new FleerCorverList(new ApexPages.StandardController(lead1));

        controller.generateDoc();
        controller.setItemValue(Fleetsettlementchecklist);
        controller.getItems();
            
        String str = 'teststring';
        String str1 = '1258752'; 
            
        controller.getfieldStr(str);
        FleerCorverList.currency(str1);
        Test.stopTest();
            
        // verify
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Yes',' Yes '));
        options.add(new SelectOption('N/A',' N/A '));
            
        system.assertEquals(options, controller.getItems());  
        system.assertEquals(controller.getfieldStr(str),'teststring'); 
        system.assertEquals(FleerCorverList.currency(str1),'1,258,752.00');
            
    }
}