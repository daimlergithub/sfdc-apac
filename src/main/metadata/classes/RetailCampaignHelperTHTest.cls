@isTest
public class RetailCampaignHelperTHTest {
    private static Account dealer;
    public static Retail_campaign__c retail;
    public static Contact dealerContact;
    public static Retail_Campaign__c ret=new Retail_Campaign__c();
    private static Account dealer1;
    private static Contact contactObj;
    private static Trigger__c casetrigger;
    private static List<Retail_campaign__c> retcamplst=new List<Retail_campaign__c>();
    private static User user1;
    private static User user2;
    public static retail_Campaign__c retailcampaign;
    Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
    public Static boolean booleanCampaignUpdate=true;
    public static Id executionRecordId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    public static Id planningRecordId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
    public static void createtestdata(){
      casetrigger=new Trigger__C(name='TriggerRetailCampaignTH',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='TriggerRetailCampaignHandlerTH',Trigger_Name__c='RetailCampaignTrigger',update__c=true);
      insert casetrigger;
     Profile p1 = [select id from profile where Name='System Administrator' limit 1];
     profile p2=[select id from profile where Name='Thailand Dealer Delegate Admin'];
     user1 = new User(LastName='User',Market__c='TH',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01');
     insert user1;
     dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='TH', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='1235');
      insert dealer1;
        Contact dealerContact = new Contact(FirstName = 'Test',Md__c='TH', Lastname = 'Amit', AccountId = dealer1.Id, Email = 'test@test.com');
        insert dealerContact;
     user2 = new User(LastName='GEORGE',contactid=dealerContact.id,country='Australia',ProfileId=p2.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev01');
    insert user2;
  
     dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c='TH',Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='12345');
        insert dealer;
        retailcampaign=new Retail_Campaign__C(Dealer_Name__c=dealer1.id,name='test123',recordtypeid=planningRecordId,start_date__c=system.today()+1,close_Date__C=system.today()+1);
        insert retailcampaign;
    }
static testMethod void updateRetailCampaignEmail() {
    test.starttest();
     createtestdata();
    system.runAs(user2){
        Retail_Campaign__C retailcampaign1=new Retail_Campaign__C(Dealer_Name__c=dealer1.id,name='test123',recordtypeid=planningRecordId,start_date__c=system.today()+1,close_Date__C=system.today()+1);
        insert retailcampaign1;
    ret.name='test';
    ret.Start_Date__c=system.today()+1;
    ret.Close_Date__c=System.today()+1;
    ret.Dealer_Name__c=null;
    ret.recordtypeid=executionRecordId;
        ret.Parent_Campaign1__c=retailcampaign1.id;
        ret.Child_Campaign_Status__c='Planning';
    insert ret;        
       ret.Dealer_Name__c=dealer1.id;
        update ret;
    test.stopTest();
}
        }

           
    static testMethod void revokeRetailCampaignAccess() {
    test.starttest();
        createtestdata();
        system.runAs(user1){
        retailcampaign.Dealer_Name__c=null;            
    update retailcampaign;  
    test.stopTest();
        }
        }
    static testMethod void DeletChildsandParents() {
        test.starttest();
        createtestdata();
        system.runAs(user1){
            Retail_campaign__c retcampchild=new Retail_Campaign__C(Dealer_Name__c=dealer.id,name='test123',recordtypeid=executionRecordId,start_date__c=system.today()+1,close_Date__C=system.today()+1,Parent_Campaign1__c=retailcampaign.id);
   			insert retcampchild;
           delete retailcampaign;
    test.stopTest();
   
    } 
    }
}