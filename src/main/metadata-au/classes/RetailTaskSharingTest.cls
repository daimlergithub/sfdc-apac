@isTest
private class RetailTaskSharingTest {
    
    private static Account dealer;
    private static Vehicle__c vehicle;
    
    static {
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer');
        insert dealer;

        Contact dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = dealer.Id, Email = 'test@test.com');
        insert dealerContact;

        vehicle = new Vehicle__c();
        insert vehicle;
    }
    
    @isTest 
    static void testWrapContract() {
        Test.startTest();
        RecordType contractType = [select Id from RecordType where SObjectType = 'Retail_Task__c' and DeveloperName = 'contract' limit 1];
        Retail_Task__c contract = new Retail_Task__c(RecordTypeId = contractType.Id, Related_Dealer__c = dealer.Id, Related_Vehicle__c = vehicle.Id);
        insert contract;
        RetailTaskSharingWrapService wrapService = new RetailTaskSharingWrapService();
       List<SharingWrapper> wrapContracts= wrapService.wrapContracts(new List<Retail_Task__c>{contract});
        Test.stopTest();
        system.assertNotEquals(null, wrapContracts);
    }
    
    @isTest 
    static void testWrapRetailTask() {
        Test.startTest();
        RecordType retailTaskType = [select Id from RecordType where SObjectType = 'Retail_Task__c' and DeveloperName = 'Retail_Activity' limit 1];
        Retail_Task__c retailActivity = new Retail_Task__c(RecordTypeId = retailTaskType.Id, Related_Dealer__c = dealer.Id, Related_Vehicle__c = vehicle.Id);
        RetailTaskSharingWrapService wrapService = new RetailTaskSharingWrapService();
         List<SharingWrapper> wrapRetailActivities=wrapService.wrapRetailActivities(new List<Retail_Task__c>{retailActivity});
        Test.stopTest();
         system.assertNotEquals(null, wrapRetailActivities);
    }
    
    @isTest 
    static void testWrapService() {
        Test.startTest();
        RecordType serviceType = [select Id from RecordType where SObjectType = 'Retail_Task__c' and DeveloperName = 'Service' limit 1];
        Retail_Task__c service = new Retail_Task__c(RecordTypeId = serviceType.Id, Related_Dealer__c = dealer.Id, Related_Vehicle__c = vehicle.Id);
        RetailTaskSharingWrapService wrapService = new RetailTaskSharingWrapService();
        List<SharingWrapper> wrapServices=wrapService.wrapServices(new List<Retail_Task__c>{service});
        Test.stopTest();
        system.assertNotEquals(null, wrapServices);
    }

    @isTest
    static void testWrapRetailTasks() {
        RecordType serviceType = [select Id from RecordType where SObjectType = 'Retail_Task__c' and DeveloperName = 'Service' limit 1];
        Retail_Task__c service = new Retail_Task__c(RecordTypeId = serviceType.Id, Related_Dealer__c = dealer.Id, Related_Vehicle__c = vehicle.Id);
        RecordType retailTaskType = [select Id from RecordType where SObjectType = 'Retail_Task__c' and DeveloperName = 'Retail_Activity' limit 1];
        Retail_Task__c retailActivity = new Retail_Task__c(RecordTypeId = retailTaskType.Id, Related_Dealer__c = dealer.Id, Related_Vehicle__c = vehicle.Id);
        RecordType contractType = [select Id from RecordType where SObjectType = 'Retail_Task__c' and DeveloperName = 'contract' limit 1];
        Retail_Task__c contract = new Retail_Task__c(RecordTypeId = contractType.Id, Related_Dealer__c = dealer.Id, Related_Vehicle__c = vehicle.Id);
        insert new List<Retail_Task__c>{service, retailActivity, contract};

        Test.startTest();
        RetailTaskSharingWrapService wrapService = new RetailTaskSharingWrapService();
        List<SharingWrapper> wrapRetailTasks=wrapService.wrapRetailTasks(new List<Retail_Task__c>{service, retailActivity, contract});
        Test.stopTest();
        system.assertNotEquals(null, wrapRetailTasks);
    }
    
    @isTest
    static void testRetailTaskTrigger() {
    	Test.startTest();
    	RecordType serviceType = [select Id from RecordType where SObjectType = 'Retail_Task__c' and DeveloperName = 'Service' limit 1];
        Retail_Task__c service = new Retail_Task__c(RecordTypeId = serviceType.Id, Related_Dealer__c = dealer.Id, Related_Vehicle__c = vehicle.Id);
        RecordType retailTaskType = [select Id from RecordType where SObjectType = 'Retail_Task__c' and DeveloperName = 'Retail_Activity' limit 1];
        Retail_Task__c retailActivity = new Retail_Task__c(RecordTypeId = retailTaskType.Id, Related_Dealer__c = dealer.Id, Related_Vehicle__c = vehicle.Id);
        RecordType contractType = [select Id from RecordType where SObjectType = 'Retail_Task__c' and DeveloperName = 'contract' limit 1];
        list<id> recId =new list<id>();
        recId.add(contractType.id);
        Retail_Task__c contract = new Retail_Task__c(RecordTypeId = contractType.id, Related_Dealer__c = dealer.Id, Related_Vehicle__c = vehicle.Id);
        insert new List<Retail_Task__c>{service, retailActivity, contract};
        Test.stopTest();
         contract = [select RecordTypeId,Related_Dealer__c,Related_Vehicle__c  from Retail_Task__c where RecordTypeId in: recId limit 1 ];
        system.assertEquals(contract.RecordTypeId, contractType.id);
        
    }
}