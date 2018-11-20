@istest
public class RetailTaskTriggerHandlerFMTest 
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
    
  public static testMethod void test_updateCustomerStage11() {  
     Profile p = [SELECT Id FROM Profile WHERE Name='IntegrationAPI']; 
     User u = new User(Alias = 'standt', Email='test@mbj.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US', ProfileId = p.Id, 
                       TimeZoneSidKey='America/Los_Angeles',UserName=System.now().millisecond() +'retail'+'testDaimlerUser@Daimler-test.com',Market__c= 'ID');
    insert u;
     createTestData();  
     System.runAs(u) {       
     system.debug(u);    
       test.startTest();    
        lead1 = new Retail_Task__c();
        lead1.MD__c = 'ID';
        lead1.Account__c = objAccount.id;
        lead1.Service_Dealer__c = DealerAccount.id;
        lead1.Related_Contact__c=objAccount.id;
        lead1.RecordTypeId =Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Service').getRecordTypeId();  
         system.debug(u);  
         TriggerUtil.userCreate=false;  
        insert lead1; 
         system.debug(u);    
       test.stopTest();        
           
     }   
  }   
    
  static void createTestData() {
    Trigger__c TriggerVehicleRelationshipJP=new Trigger__c(Name='RetailTaskTriggerFM',Trigger_Name__c='RetailTaskTrigger',Trigger_Handler__c='RetailTaskTriggerHandlerFM',
                                                         update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='ID');
    insert TriggerVehicleRelationshipJP; 
      objAccount =  new Account(FirstName='刈乾冠寒刊勘',LastName='刈乾冠寒刊勘',Md__c='ID', Individual_Home_Phone__c='+6046234824', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
     insert objAccount;
            DealerAccount = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
          DealerAccount.Dealer_Nd_code__c='abcd';
          dealerAccount.istestrunning__c=true;
          DealerAccount.mD__c='ID';
          update DealerAccount;  
          Group g = new Group(name='MYabcd');
          insert g ;   

  }   //Added by dhanamjaya to imporve Code coverage for TH market
    Private static testMethod void wrapRetailTasksTHTest(){
        //Inserting custom settings for Retail Task.which will call Handler methods
        Trigger__c TriggerVehicleRelationshipTH=new Trigger__c(Name='RetailTaskTriggerTH',Trigger_Name__c='RetailTaskTrigger',
                                               Trigger_Handler__c='RetailTaskTriggerHandlerTH',update__c=True,insert__c=True,delete__c=True,after__c=True, 
                                                               before__c=True,enabled__c=True,Market__c='TH');
        //querying "IntegrationAPI Profile"
 		Profile usrProfile = [SELECT Id FROM Profile WHERE Name='IntegrationAPI']; 
        //Inserting Integration User
       	User usr = new User(Alias = 'standt', Email='test@mbj.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = usrProfile.Id,TimeZoneSidKey='America/Los_Angeles', UserName='test@mbj.com',Market__c='TH');
        insert usr;
    	insert TriggerVehicleRelationshipTH;
        system.runAs(usr){
            Test.startTest();
      		TriggerUtil.userCreate=false;
            //
     		Account acc=new Account(Lastname='dhanam',dealer_nd_code__c='12345');
     		insert acc;
     		Group grp=new Group(Name='TH12345');
     		insert grp;
    		Retail_Task__c rell = new Retail_Task__c(RecordTypeId = UtilRecordType.getRecordTypeIdByName('Retail_Task__c','Service'),Service_Dealer__c=acc.id,Related_Dealer__c=acc.id); 
    		insert rell;  
            Test.stopTest();
        }
    }
}