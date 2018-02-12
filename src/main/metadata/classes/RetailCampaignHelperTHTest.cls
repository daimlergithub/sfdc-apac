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
    private static User user1=TestUtils.createAdminUser();
    public static retail_Campaign__c retailcampaign;
    Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
    public Static boolean booleanCampaignUpdate=true;
    public static Id executionRecordId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    public static Id planningRecordId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
    public static void createtestdata(){
      casetrigger=new Trigger__C(name='TriggerRetailCampaignTH',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='TriggerRetailCampaignHandlerTH',Trigger_Name__c='RetailCampaignTrigger',update__c=true);
      insert casetrigger;
     dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='TH', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='1235');
      insert dealer1;
        Contact dealerContact = new Contact(FirstName = 'Test',Md__c='TH', Lastname = 'Amit', AccountId = dealer1.Id, Email = 'test@test.com');
        insert dealerContact;  
     dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c='TH',Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='12345');
        insert dealer;
        retailcampaign=new Retail_Campaign__C(Dealer_Name__c=dealer1.id,name='test123',recordtypeid=planningRecordId,start_date__c=system.today()+1,close_Date__C=system.today()+4);
        insert retailcampaign;
    }
static testMethod void updateRetailCampaignEmail() {
     
    system.runAs(user1){ test.starttest();
        createtestdata();
        Retail_Campaign__C retailcampaign1=new Retail_Campaign__C(Dealer_Name__c=dealer1.id,name='test123',recordtypeid=planningRecordId,start_date__c=system.today()+1,close_Date__C=system.today()+3);
        insert retailcampaign1;
      ret.name='test';
      ret.Start_Date__c=system.today()+1;
      ret.Close_Date__c=System.today()+2;
      ret.Dealer_Name__c=null;
      ret.recordtypeid=executionRecordId;
      ret.Child_Campaign_Status__c='Planning';
        insert ret;      
         ret.Dealer_Name__c=dealer1.id;
        ret.Child_Campaign_Status__c='Planning';
        update ret;
     test.stopTest();
}
         }
   
    static testMethod void revokeRetailCampaignAccess() {
   
       
        system.runAs(user1){ 
             test.starttest();
            createtestdata();
        retailcampaign.Dealer_Name__c=null;            
    update retailcampaign;  
   test.stopTest();
        }
        }
    static testMethod void DeletChildsandParents() {
        system.runAs(user1){
            test.starttest();
            createtestdata();
            Retail_campaign__c retcampchild=new Retail_Campaign__C(Dealer_Name__c=dealer.id,name='test123',recordtypeid=executionRecordId,start_date__c=system.today()+2,close_Date__C=system.today()+2,Parent_Campaign1__c=retailcampaign.id);
            insert retcampchild;
           delete retailcampaign;
      test.stopTest();
   
    } 
    }
    
    static testMethod void parentCampaignStatusChange_Test()
    {
       List<Group> groupLst=new List<Group>();
        groupLst.add(new Group(Name='1235'));
        insert groupLst;
        System.runAs(user1)
        { Test.startTest();
            createtestdata();
            Retail_campaign__c retcampchild=new Retail_Campaign__C(name='test123',recordtypeid=executionRecordId,start_date__c=system.today()+2,close_Date__C=system.today()+2);
            insert retcampchild;
         List<Retail_campaign__c> lstRetailCampaign=new List<Retail_campaign__c>();
         lstRetailCampaign.add(retcampchild);
            
         RetailCampaignHelperTH.parentCampaingStatusChange(lstRetailCampaign, true);
        test.stopTest();
        }
        
    }
}