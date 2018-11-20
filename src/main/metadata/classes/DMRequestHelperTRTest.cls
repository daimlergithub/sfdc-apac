@isTest
public class DMRequestHelperTRTest {
    
    private static Account account;
    private static Address__c address;
    private static DM_Request__c dmr;
    private static DM_Material__c Material;
    private static Address__c address1;
    private static User usr;
    public static Map<Id,Address__c> newmap = new Map<Id,Address__c>();
    public static List<Address__c> addresslist =new List<Address__c>();
    
    public static void createTestData(){
        CallOutHandlerSettingDFW__c coh = new CallOutHandlerSettingDFW__c();
        coh.Name = 'CalloutValues';
        coh.DEFAULT_CALLOUT_TIME__c = '10000';
        coh.MAX_CALLOUT_TIME__c ='120000';  
        coh.FAILED_STATUS__c='failed';
        coh.JSON_CONTENT_TYPE__c ='application/json';
        coh.KO_STATUS__c='KO';       
        coh.OK_STATUS__c='OK';
        coh.PLAIN_TEXT_CONTENT_TYPE__c='text/plain';
        coh.QUEUED_STATUS__c='Queued';
        coh.REQUEST_BODY_NAME__c='request body';
        coh.REQUEST_CERT_NAME__c='request cert';
        coh.REQUEST_HEADERS_NAME__c='request headers';
        coh.RESPONSE_NAME__c='response';
        DMLManagerService.insertAsSystem(coh);

        Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAddress',Trigger_Name__c='TriggerAddress',Trigger_Handler__c='TriggerAddressTriggerHandlerTR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TR');
        upsert TriggerAddress;

        Profile taskprofile = [select id, Name from profile where Name='System Administrator' limit 1];
        User user = new User(LastName='User',country='Australia',firstName='BCI',ProfileId=taskprofile.Id,Alias='Taskain1',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_Mtest@infosys.com',UserName='sa2222222m@test.com.dev01'+String.valueof(DateTime.now().getTime()),Market__c = 'TR');
        insert user;
        System.runas(user){       
            Profile profileCAC = [select Id from Profile where Name = :Label.IntProfileName];
            usr = new User();
            usr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com'+String.valueof(DateTime.now().getTime());        
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
            usr.Market__C='TR';    
      insert usr;

            SystemSettingsDFW__c sysSet = new SystemSettingsDFW__c();
            sysSet.Debug__c =true;
            sysSet.Error__c = true;
            sysSet.Info__c= true;
            sysSet.Warning__c = true;
            sysSet.Log_Purge__c =10;
            sysSet.Name=taskprofile.Name;
            DMLManagerService.insertAsSystem(sysSet);
        
            account= new Account();
            account.Phone='09844650654';
            account.Email__c = 'testemail@test.com';
            account.Market__c = 'TR';
            account.firstName = 'firstname';
            account.lastName = 'lastname';
            account.Data_Source__c = 'MBT Event';
            account = (Account)UtilTestData.createSobject(account,UtilConstant.person_Account); 

            address=new Address__c();
            address.Address_Type__c='Home';
            address.Province__c='Bangkok';
            address.TitleOfHonor__c = 'To Person';
            address.City__c='bangalore';
            address.District__c='test2';
            address.Block__c='test3';
            address.Address_Line_1__c='testaddress1';
            address.Address_Line_2__c='testaddress2';
            address.Customer__c=account.id;
			address.Market__c='TR';
			address.country__c = 'Turkey';
            insert address;  

            address1=new Address__c();
            address1.Address_Type__c='Other Address 1';
            address1.Province__c='Bangkok';
            address1.TitleOfHonor__c = 'To Person';
            address1.City__c='Hyderabd';
            address1.District__c='test';
            address1.Block__c='test';
            address1.Address_Line_1__c='testaddress';
            address1.Address_Line_2__c='testaddress';
            address1.Customer__c=account.id;
			address1.Market__c='TR';
			address1.country__c = 'Turkey';
            insert address1; 
        } 
    }
    public static void createDMRequest(){
        Trigger__c TriggerDMR=new Trigger__c(Name='DMRequestTR',Trigger_Name__c='TriggerDMRequest',Trigger_Handler__c='TriggerDMRequestTriggerHandlerTR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TR');
        upsert TriggerDMR;
           
        system.runAs(usr){
            Material = new DM_Material__c();
            Material.Name='testname';
			Material.Market__c='TR';
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
			dmr.Market__c='TR';
            dmr.Sent_Date__c=system.today().addDays(-10);
            insert dmr;
        }
    } 
    
    public static testMethod void UpdateDMRequestTest(){
        //create test data
        createTestData();
        createDMRequest();
        
        //start test
    system.runAs(usr){
        test.startTest();
        dmr.Sending_Address__c='Other Address 1';
		update dmr;        
        test.stopTest();
        //verify test
        dmr=[select Province__c  from DM_Request__c where id=:dmr.id];
        system.assertEquals(dmr.Province__c, null);        
    }    
        
    }
    public static testMethod void updateStatusTest(){
        //create test data
        createTestData();
        createDMRequest();

        system.runAs(usr){
        DM_Request__c dmr1 = new  DM_Request__c();  
        dmr1.Status__c='to be sent'; 
        dmr1.Customer_Name__c=account.id;
		dmr1.Market__c='TR';
        dmr1.Sending_Address__c='Home';
        dmr1.TitleOfHonor__c ='To Person';
        dmr1.Expected_DM_Material1__c=Material.id;
        dmr1.Expected_DM_Material2__c=Material.id;
        dmr1.Expected_DM_Material3__c=Material.id;
        dmr1.Status3__c='Success';
        dmr1.Status2__c='Success';
        dmr1.Status1__c='to be sent';
        dmr1.sent_date__c=system.today();
        insert dmr1;
       
        //start test
        test.startTest();
        dmr1.Status2__c='to be sent';
        dmr1.sent_date__c=system.today()+2;
        update dmr1;
        test.stopTest();
        //verify test
        dmr=[select Status2__c   from DM_Request__c where id=:dmr1.id];
        system.assertEquals(dmr.Status2__c, 'to be sent');
         }
    } 
}