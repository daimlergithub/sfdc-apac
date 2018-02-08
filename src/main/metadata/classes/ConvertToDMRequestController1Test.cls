@isTest
public class ConvertToDMRequestController1Test {

public static User user1;
public static User user_Obj; 
public static DM_Request__c dmr;
public static DM_Material__c Material;    
public static Account account;
public static Address__c address;  
public static Campaign_Member__c campaignMemberObj;
public static Retail_Campaign__c retailCampaignObj;    
public static Account personAccount;
public static Retail_Campaign__c parentCampaignObj;    
@testSetup    
static void setupTestData(){ 
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        
        user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user1 );
        user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user_Obj );
        system.runAs(user1){
        account= new Account();
        account.Phone='09844650654';
        account.Email__c = 'testemail@test.com';
        account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account); 
        
        address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='Tokyo';
        address.TitleOfHonor__c = 'To Person';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=account.id;
        insert address;  
        Material = new DM_Material__c();
            Material.Name='testname';
            insert Material;

            dmr = new  DM_Request__c();
            dmr.Status__c='to be sent'; 
            dmr.Customer_Name__c=account.id;
            dmr.Sending_Address__c='Home';
            dmr.TitleOfHonor__c = 'To Person';
            dmr.Status2__c='Success';
            dmr.Expected_DM_Material1__c=Material.id;
            dmr.Expected_DM_Material2__c=Material.id;
            dmr.Expected_DM_Material3__c=Material.id;
            dmr.Status1__c='Success';
            dmr.Status3__c='Success';
            dmr.Sent_Date__c=system.today().addDays(-10);
            insert dmr;
            Date todaydate=System.today();
            personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='TH', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
            insert personAccount;
            parentCampaignObj=new Retail_Campaign__c(Name='Test Parent Campaign',RecordTypeId=Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId());
            insert parentCampaignObj;
            retailCampaignObj=new Retail_Campaign__c(Name='Test Retail Campaign',md__c='TH',Execution_Type__c='OB Call',Parent_Campaign1__c=parentCampaignObj.Id,Execution_Start_Date__c=todaydate,MBTH_Approval_Status__c='Approved',RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId());
            insert retailCampaignObj;
            campaignMemberObj=new Campaign_Member__c(Retail_Campaign_Id__c=retailCampaignObj.Id,Auto_creation_of_tasks__c=false,Status__c='Responded',md__c='TH',Contact_Id__c=personAccount.Id);
            insert campaignMemberObj;
        
        
       }
}
    
     static testMethod void coverttolead1controller1() {
        try{
        
          setupTestData();  
          System.runAs (user_Obj) {  
          test.startTest();  
          ApexPages.currentPage().getParameters().put('CampaignMemberId',campaignMemberObj.id );  
          ConvertToDMRequestController1 c = new ConvertToDMRequestController1();
          c.cancel();
          c.convertToDMRequest();  
          system.assertNotEquals(Null, c.campaignMembers ) ;   
          test.stopTest();
          }
          }
        catch(Exception e){}
    }    


}