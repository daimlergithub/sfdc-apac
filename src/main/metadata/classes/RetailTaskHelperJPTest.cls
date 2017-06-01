@istest
public class RetailTaskHelperJPTest 
{
  public Static Account objAccount; 
  public Static Account objAccount2; 
  public Static Account DealerAccount;
  public static Retail_Task__c lead1;
  public static Retail_Task__c lead2;
  public static Retail_Task__c lead3;
  public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
  public static String DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
  public static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
    
  public static testMethod void test_updateCustomerStage1() {  
     Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
     User u = new User(Alias = 'standt', Email='test@mbj.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id, 
                       TimeZoneSidKey='America/Los_Angeles', UserName='test@mbj.com');
     System.runAs(u) {           
       test.startTest();    
         createTestData();           
         lead2.Supporting_Dealer__c = DealerAccount.id;   
         lead3.Supporting_Dealer__c = DealerAccount.Id;
         update lead2;
       
         RetailTaskTriggerHandlerJP TriggerLeadHandlerJP = new RetailTaskTriggerHandlerJP();
         TriggerLeadHandlerJP.handleTrigger(false, false, false, false, false);
         TriggerLeadHandlerJP.handleIntegrationTrigger(false, false, false, false, false);
         RetailTaskTriggerHandlerKR TriggerLeadHandlerKR = new RetailTaskTriggerHandlerKR();
         TriggerLeadHandlerKR.handleTrigger(false, false, false, false, false);
         TriggerLeadHandlerKR.handleIntegrationTrigger(false, false, false, false, false);
       test.stopTest();        
       system.assertEquals(lead3.MD__c,'KR');    
     }   
  }   
    
  static void createTestData() {
    Trigger__c TriggerVehicleRelationshipJP=new Trigger__c(Name='RetailTaskTriggerJP',Trigger_Name__c='RetailTaskTrigger',Trigger_Handler__c='RetailTaskTriggerHandlerJP',
                                                         update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
    insert TriggerVehicleRelationshipJP;                                                         
    Trigger__c TriggerVehicleRelationshipKR=new Trigger__c(Name='RetailTaskTriggerKR',Trigger_Name__c='RetailTaskTrigger',Trigger_Handler__c='RetailTaskTriggerHandlerKR',
                                                         update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');                                                         
    insert TriggerVehicleRelationshipKR;
    
    DealerAccount= new Account();
    DealerAccount.RecordtypeId=DealerAccRecordTypeId;
    DealerAccount.Name='Test Person 1st';
    DealerAccount.Type='Personal';
    DealerAccount.Status__c='Active';
    DealerAccount.Province__c='Province1';
    DealerAccount.City__c='Test';
    DealerAccount.Email__c='test@mbj.com';
    //DealerAccount.Mobile__c ='0435488899';
    insert DealerAccount;
        
    objAccount= new Account();
    objAccount.RecordtypeId=personAccRecordTypeId;
    objAccount.LastName='Test Person 1st';
    //objAccount.Type='Personal';
    objAccount.Status__c='Active';
    objAccount.Province__c='Province1';
    objAccount.City__c='Test';
    objAccount.ZipCode__c = '1004235';
    objAccount.Email__c='test@mbj.com';
    //objAccount.Mobile__c ='0435488899';
    objAccount.Phone = '08022420181';
    objAccount.Main_Dealer__c = DealerAccount.id;
    objAccount.Customer_Lifecycle_Phase__c = 'Care';
    insert objAccount;
  
    //inserted new address record
    Address__c addr = new Address__c(Customer__c = objAccount.id, Address_Type__c = 'Home', Province__c = 'Hokkaido' , City__c = 'NY');
    insert addr;
    //added address reference to address 
    Account objacc = new Account(id = objAccount.id, Primary_Address_Reference__c = addr.id); 
    update objacc;
    objAccount2= new Account();
    objAccount2.RecordtypeId=companyAccRecordTypeId;
    objAccount2.Name='Test Company2nd';
    //objAccount.Type='Personal';
    objAccount2.Status__c='Active';
    objAccount2.Province__c='Province1';
    objAccount2.City__c='Test';
    objAccount2.ZipCode__c = '1004235';
    objAccount2.Email__c='test@mbj.com';
    objAccount2.Mobile__c ='0435488899';
    objAccount2.Phone = '08022420181';
    objAccount2.Main_Dealer__c = DealerAccount.id;
    objAccount2.Customer_Lifecycle_Phase__c = 'Care';
    objAccount2.Foundation_Date__c = System.today();
    insert objAccount2;

    lead1 = new Retail_Task__c();
    lead1.MD__c = 'KR';
    lead1.Account__c = objAccount.id;
    lead1.Supporting_Dealer__c = DealerAccount.id;        
    insert lead1;  
       
    lead2 = new Retail_Task__c();
    lead2.MD__c = 'KR';
    lead2.Account__c = objAccount.id;
    lead2.Supporting_Dealer__c = DealerAccount.id;        
    insert lead2;  
    
    lead3 = new Retail_Task__c();
    lead3.MD__c = 'KR';
    lead3.Account__c = objAccount2.id;
    lead3.Supporting_Dealer__c = DealerAccount.id;        
    insert lead3;  
  }   
}
