/** Modified By: Sneha Chail
**  Date: 2015-10-06
*/

@isTest
private class RetailTaskSharingTest {
    
    private static Retail_Task__c contract;
    private static Retail_Task__c retailActivity;      
    Private static Retail_Task__c service;
    private static Account accDealer;
    private static Contact dealerContact;
    Private static Vehicle__c vehicle;
    
    public static void preparedTestData()
       {
        //Inserting record for Account
        accDealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(), Name = 'test dealer');
        insert accDealer;
        //Inserting record for Contact
        dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = accDealer.Id, Email = 'test@test.com');
        insert dealerContact;
        //Inserting record for Vehicle
        vehicle = new Vehicle__c();
        insert vehicle;        
       }
       static {
         preparedTestData();
       
        service = new Retail_Task__c(RecordTypeId = UtilRecordType.getRecordTypeIdByName('Retail_Task__c','Service'), Related_Dealer__c = accDealer.Id, Related_Vehicle__c = vehicle.Id);
       
        retailActivity = new Retail_Task__c(RecordTypeId = UtilRecordType.getRecordTypeIdByName('Retail_Task__c','Retail Activity'), Related_Dealer__c = accDealer.Id, Related_Vehicle__c = vehicle.Id);
                 
        contract = new Retail_Task__c(RecordTypeId = UtilRecordType.getRecordTypeIdByName('Retail_Task__c','Contract'), Related_Dealer__c = accDealer.Id, Related_Vehicle__c = vehicle.Id);
        //Inserting records having recordtype Service RetailActivity and COntract for Retail_Tak__c
        insert new List<Retail_Task__c>{service, retailActivity, contract};
      }
    
     @isTest 
     static void testWrapContract() {
        Test.startTest();        
          RetailTaskSharingWrapService wrapService = new RetailTaskSharingWrapService();
          List<SharingWrapper> wrapContracts=wrapService.wrapContracts(new List<Retail_Task__c>{contract});
        Test.stopTest();
        System.assertNotEquals(null,wrapContracts);
     }
    
    @isTest 
     static void testWrapRetailTask() {
        Test.startTest();        
          RetailTaskSharingWrapService wrapService = new RetailTaskSharingWrapService();        
          List<SharingWrapper> wrapRetailTasks=wrapService.wrapRetailActivities(new List<Retail_Task__c>{retailActivity});
        Test.stopTest();
        System.assertNotEquals(null,wrapRetailTasks);

     }
    
    @isTest 
    static void testWrapService() {
        Test.startTest();
           RetailTaskSharingWrapService wrapService = new RetailTaskSharingWrapService();
          List<SharingWrapper> wrapServices=wrapService.wrapServices(new List<Retail_Task__c>{service});
        Test.stopTest();
        System.assertNotEquals(null,wrapServices);
    }

    @isTest
    static void testWrapRetailTasks() {
        Test.startTest();
          RetailTaskSharingWrapService wrapService = new RetailTaskSharingWrapService();        
          List<SharingWrapper> wrapRetailTasks=wrapService.wrapRetailTasks(new List<Retail_Task__c>{service, retailActivity, contract});
      Test.stopTest();
        System.assertNotEquals(null,wrapRetailTasks);
    }
    
}
