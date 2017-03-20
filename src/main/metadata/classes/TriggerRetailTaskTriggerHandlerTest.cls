@isTest
private class TriggerRetailTaskTriggerHandlerTest{
    
    private static Retail_Task__c contract;
    private static Retail_Task__c retailActivity;      
    Private static Retail_Task__c service;
    private static Account accDealer;
    private static Contact dealerContact;
    Private static Vehicle__c vehicle;
    
    public static void preparedTestData()
       {
        Trigger__c TriggerRT = new Trigger__c(Name='RetailTaskTrigger',Trigger_Name__c='RetailTaskTrigger',Trigger_Handler__c='TriggerRetailTaskTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
       insert TriggerRT;
        //Inserting record for Account
        accDealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(), Name = 'test dealer');
        insert accDealer;
        //Inserting record for Contact
        dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = accDealer.Id, Email = 'test@test.com');
        insert dealerContact;
        //Inserting record for Vehicle
        vehicle = new Vehicle__c(Brand__c = 'Maybach',UsVIN__c ='tlikkkkkkkkllllll',EuroVIN__c = '12345678901111111',CurrentMileage__c=5000,NextMileage__c=6000,Recall__c = FALSE,FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
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