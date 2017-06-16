@isTest
public class DMRequestHelperJPTest {
    private static Account dealer;
     private static Account dealer2;
     private static Account account;
     private static Address__c address;
     private static DM_Request__c dmr;
       private static DM_Request__c dmr2;
     private static DM_Material__c Material;
     private static DM_Material__c Material1;
     private static Address__c address1;
     private static User usr;
     private static  profile ProfileAdmin = [select Id from Profile where Name = 'System Administrator'];
     public static Map<Id,Address__c> newmap = new Map<Id,Address__c>();
     public static List<Address__c> addresslist =new List<Address__c>();
     final static String personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    
    public static void createTestData(){
        
        Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAddress',Trigger_Name__c='TriggerAddress',Trigger_Handler__c='TriggerAddressTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
        upsert TriggerAddress;
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer', MBK_Data_Source__c ='Email');
        insert dealer;
            dealer2 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer2', MBK_Data_Source__c ='Email');
        insert dealer2;
              
         Profile profileCAC = [select Id from Profile where Name =:'IntegrationAPI'];
         usr = new User();
        usr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';        
        if(profileCAC!=Null){
        usr.ProfileId = profileCAC.Id;}
        usr.LastName = 'Test User';
        usr.Email = 'test001@daimler.com.full';
        usr.Alias = 'Atest';
        usr.TimeZoneSidKey = 'Asia/Shanghai';
        usr.EmailEncodingKey = 'UTF-8';
        usr.LanguageLocaleKey = 'en_US';
        usr.localesidkey='en_US';
        usr.isActive = true;     
        insert usr;
        
        account= new Account();
        account.RecordTypeId = personRecordtypeid;
        account.Phone='09844650654';
        account.MBK_Data_Source__c ='Email';
        account.Mobile__c ='00000009784';
        account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account);  
        system.debug('$$$$$$$$$$$$$'+account.id);      
        
        address=new Address__c();
        address.Customer__c=account.id;
        address.Address_Type__c='Home';
        address.Province__c='Tokyo';
        address.TitleOfHonor__c = 'To Person';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        insert address;  
        
        address1=new Address__c();
        address1.Customer__c=account.id;
        address1.Address_Type__c='Other Address 1';
        address1.Province__c='Tokyo';
        address1.TitleOfHonor__c = 'To Person';
        address1.City__c='Hyderabd';
        address1.District__c='test';
        address1.Block__c='test';
        address1.Address_Line_1__c='testaddress';
        address1.Address_Line_2__c='testaddress';
        insert address1;  
        
    }
        public static void createDMRequest(){
        
        Trigger__c TriggerDMR=new Trigger__c(Name='DMRequest',Trigger_Name__c='TriggerDMRequest',Trigger_Handler__c='TriggerDMRequestTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
        upsert TriggerDMR;
           
        system.runAs(usr){
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
          dmr.View_By_All__c = true;
         dmr.Sent_Date__c=system.today().addDays(-10);
    //    insert dmr;
        
            dmr2 = new  DM_Request__c();
         dmr2.Status__c='to be sent'; 
         dmr2.Customer_Name__c=account.id;
         dmr2.Sending_Address__c='Home';
         dmr2.TitleOfHonor__c = 'To Person';
         dmr2.Status2__c='to be sent';     
         dmr2.Status1__c='to be sent';
         dmr2.Status3__c='to be sent';
         dmr2.Assigned_Dealer__c = dealer.Id;
         dmr2.Sent_Date__c=system.today().addDays(-10);
        insert dmr2;
        }
    } 
    
    
    
     public static void createDMRequest1(){
        
        Trigger__c TriggerDMR=new Trigger__c(Name='DMRequest',Trigger_Name__c='TriggerDMRequest',Trigger_Handler__c='TriggerDMRequestTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
        upsert TriggerDMR;

       system.runAs(usr){
        Material1 = new DM_Material__c();
        Material1.Name='testname';
        insert Material1;
        
         dmr = new  DM_Request__c();
         dmr.Status__c='to be sent'; 
         dmr.Customer_Name__c=account.id;
         dmr.Sending_Address__c='Home';
         dmr.TitleOfHonor__c = 'To Person';
         dmr.Status2__c='Success';
         dmr.Expected_DM_Material1__c=Material1.id;
         dmr.Expected_DM_Material2__c=Material1.id;
         dmr.Expected_DM_Material3__c=Material1.id;
         dmr.Status1__c='to be sent';
         dmr.Status3__c='to be sent';
         dmr.Assigned_Dealer__c = dealer.Id;
         dmr.Sent_Date__c=system.today().addDays(-10);
        insert dmr;
        }
      }  
  /*  public static testMethod void UpdateDMRequestTest(){
        //create test data
         createTestData();
        createDMRequest();
        
        //start test
        test.startTest();
        dmr.Sending_Address__c='Other Address 1';
        update dmr;        
        dmr2.Assigned_Dealer__c = dealer2.Id;
       update dmr2;
        test.stopTest();
        //verify test
        dmr=[select Province__c  from DM_Request__c where id=:dmr.id];
        //system.assertEquals(dmr.Province__c, 'testrequest');           
        
    }*/
    public static testMethod void updateStatusTest(){
        //create test data
         createTestData();
      //   createDMRequest();
        
         /*system.runAs(usr){
         DM_Request__c dmr1 = new  DM_Request__c();  
         dmr1.Status__c='to be sent'; 
         dmr1.Customer_Name__c=account.id;
         dmr1.Sending_Address__c='Home';
         dmr1.TitleOfHonor__c ='To Person';
         dmr1.Expected_DM_Material1__c=Material.id;
         dmr1.Expected_DM_Material2__c=Material.id;
         dmr1.Expected_DM_Material3__c=Material.id;
         dmr1.Status3__c='Success';
         dmr1.Status2__c='Success';
         dmr1.Status1__c='to be sent';
         dmr1.Sent_Date__c=system.today();
        insert dmr1;
       
        //start test
        test.startTest();
        dmr1.Status2__c='to be sent';
        update dmr1;
        test.stopTest();
        //verify test
        dmr=[select Status2__c   from DM_Request__c where id=:dmr1.id];
        system.assertEquals(dmr.Status2__c, 'Duplicate');
         }*/
    } 
    
    
    

}