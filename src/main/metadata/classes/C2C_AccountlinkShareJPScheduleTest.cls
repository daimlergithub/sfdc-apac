@isTest(seeAllData=false)
public class C2C_AccountlinkShareJPScheduleTest {
public static testmethod void oneTimeScheduleBatchTest(){
        C2C_AccountlinkShareJPSchedule lus= new C2C_AccountlinkShareJPSchedule();
        Test.startTest();
        lus.oneTimeScheduleBatch();
        Test.stopTest();
        
    }
@testSetUp
    public static void createTestData() {
        Id DealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        id AccountLink_Contact2ContactRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId(); 
        
        
      
        Profile p = [select id from profile where Name='IntegrationAPI' limit 1];
        User u = new User(LastName='integration',country='JP',firstName='Inf',ProfileId=p.Id,Alias='aind123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='integration.inf@infosys.com.initload1',UserName='integration.inf@infosys.com.initload1',Market__c = 'JP');
        insert u;
        
      //  User u =[select id,FirstName,LastName from user where username like '%integration.inf@infosys.com%' limit 1];
        Account accobj;
        Account a;
        system.runas(u){
            accobj = new Account();
            accobj.RecordTypeId = DealerRecordTypeId;
            accobj.Name = 'testaccount';
            accobj.Phone = '000-0000-9642';
            accobj.MBK_Data_Source__c='Email';
            accobj.Mobile__c = '000-0000-9642';
            accobj.ZipCode__c= '1002347';
            accobj.OwnerId = UserInfo.getUserId();
            accobj.Dealer_ND_Code__c ='01350';
            accobj.Dealer_Group__c ='Yanase';
            accobj.Data_Source__c='Dealer';
            accobj.Dealer_Active__c=true;
            accobj.Dealer_GC_Code__c='GC0008652';
            insert accobj;   
        Group grp = new Group();
        grp.Name = accobj.Name;
        grp.DeveloperName=accobj.Name;
       // grp.Type='';
        
        insert grp;    
            
        a = new Account(FirstName = u.FirstName,LastName = u.LastName);
        a.Dealer_Default_Flag__c   = false;
        a.Dealer_DMS_SR_Code__c    = 'test code 2';
        a.Home_Phone_2__c          = '02202123626';
        a.Work_Phone__c            = '+6612123799';
        a.Status__c                = 'NoCustomer';
        a.Email__c                 = 'testmail@test.com';
        a.Email2__c                = 'teemail2@test.com';
        a.Email3__c                = 'temail3@test.com';
        a.City__c                  = 'Tokyo';
        a.Gender__c                = 'Male';
        a.Phone                    = '0802101110';
        a.Individual_Home_Phone__c = '+6612323789';
        a.Area_code__c             = '0101';
        a.MD__c                    = 'JP';  // Modified by Laqshay Arora
        a.Market__c                = 'JP';  // Modified by Hildaa
        a.Data_Source__c           = 'Dealer Outlet';  // Modified by Hildaa 
        a.Postal_Opt_Out__c        = True;
        a.Province__c              = 'Shinagawa';
        a.ZipCode__c               = '32703';
        a.Primary_Email__c         = 'Email1';
        a.Primary_Fax__c           = 'FAX2';
        a.Primary_Phone__c         = 'Other2';
        a.PersonDoNotCall          = True;
        a.ownerid                  = u.id;
        a.PersonHasOptedOutOfEmail = true;
        a.Opt_In_Email__c          = true;
        a.PersonBirthdate          = date.newInstance(1991,03,18); 
        a.Foundation_Date__c       = date.today();
        a.RecordTypeId             = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        insert a;
        
        
       Account_Link__c acclnk = new Account_Link__c(Name = 'Test', ToRole__c = a.Id, fromRole__c = accobj.id, ReCordTypeId = AccountLink_Contact2ContactRecordTypeId,MD__c='JP', Market__c='JP');
        insert acclnk; 
        }  
    }
    
}