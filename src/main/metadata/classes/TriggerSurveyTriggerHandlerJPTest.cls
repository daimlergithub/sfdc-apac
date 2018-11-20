@isTest
private class TriggerSurveyTriggerHandlerJPTest
{
    Public static Id personrectypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    Public static Survey__c survy;
    Public static Survey__c survyHq;
    Public static Account acc;
    Public static Account acchq;
    public static Account dlrAcc;
    public static Group accGrp;
    public static User usrMBJ;
    public static User usrSup;
    public static User user3 = TestUtils.IntegrationAPIUser();

    
    static testmethod void test_shareSurverTakertoDealer()
    {
        test.startTest();
        createTestData();
        test.stopTest();
    }
    
    static void createTestData()
    {
Trigger__c TriggerSurvey = new Trigger__c(Name='TriggerSurvey',Trigger_Name__c='TriggerSurvey',Trigger_Handler__c='TriggerSurveyTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
  insert TriggerSurvey;
        
       User thisUser = [ select Id,ContactId from User where Id = :UserInfo.getUserId()];
       System.runAs(thisUser)
       {
           Profile supportProfile = [select Id from Profile where Name =:'System Administrator'];
           UserRole usrRole = [SELECT Id, Name FROM UserRole where Name = 'MBJ IT Department'];
           usrMBJ = new User();
           usrMBJ.UserName = 'TestUser.MBJSupport' + Math.rint(Math.random() * 1300000) + '@daimler.com.supportUser';        
           if(supportProfile != Null)
           {
               usrMBJ.ProfileId = supportProfile.Id;
           }
           if(usrRole != null)
           {
                usrMBJ.UserRoleId = usrRole.Id;
           }
           usrMBJ.LastName = 'MBj Support User';
           usrMBJ.Email = 'test.support.user@daimler.com.testuser';
           usrMBJ.Alias = 'SupUsr';
           usrMBJ.TimeZoneSidKey = 'Asia/Tokyo';
           usrMBJ.EmailEncodingKey = 'UTF-8';
           usrMBJ.LanguageLocaleKey = 'en_US';
           usrMBJ.localesidkey='en_US';
           usrMBJ.isActive = true;
           usrMBJ.Market__c = 'JP';
           insert usrMBJ;
       }
        
        dlrAcc = (Account)UtilTestData.createSobject(new Account(mobile__c='0123654',Dealer_ND_Code__c = 'MBJ0463',Dealer_Type__c = 'Company', OwnerId = usrMBJ.Id, MD__c = 'JP'), UTilTestData.ACCOUNT_RT_DEALER); 
        
        Contact contDlr = new Contact();
        contDlr.AccountId = dlrAcc.Id; 
        contDlr.LastName = 'Test Contact'; 
        contDlr.Phone = '0123654'; 
        contDlr.email = 'test@hqcontact.com';        
        insert contDlr;
        
        system.runAs(usrMBJ)
        {
            Profile JapanDealerCompanyManager = [select Id from Profile where Name ='Japan Dealer Company Manager'];
            usrSup = new User();
            usrSup.UserName = 'test.dealer.callcenter' + Math.rint(Math.random() * 14000000) + '@daimler.com.testuser';        
            if(JapanDealerCompanyManager!= Null)
            {
               usrSup.ProfileId = JapanDealerCompanyManager.Id;
            }
               usrSup.LastName = 'Test Call Center User';
               usrSup.Email = 'dealer.hqcallcenter.test@daimler.com';
               usrSup.ContactId = contDlr.Id;
               usrSup.Alias = 'MBJUsr';
               usrSup.TimeZoneSidKey = 'Asia/Tokyo';
               usrSup.EmailEncodingKey = 'UTF-8';
               usrSup.LanguageLocaleKey = 'en_US';
               usrSup.localesidkey='en_US';
               usrSup.isActive = true;
               usrSup.Market__C='JP'; 
               insert usrSup;
        }
        
        accGrp = new group();
        accGrp.Name = dlrAcc.Dealer_ND_Code__c;
        insert accGrp;

        
        survy = new Survey__c();
        survy.Name = 'MBJ Survey';
        survy.Survey_Type__c = 'OB Call';
        survy.MD__c = 'JP';
      //  insert survy;
        
        system.runAs(usrSup)
        {

        
           survyHq = new Survey__c();
           survyHq.Name = 'DealerSurvey';
           survyHq.Survey_Type__c = 'OB Call';
           survyHq.MD__c = 'JP';
           insert survyHq;
                      survyHq.MD__c = 'JP';
           Update survyHq;
        }
                 system.runAs(user3) {
            TriggerUtil.userCreate = false;
            Survey__c  testSurvey1 =new Survey__c(Name='Survey1');
                insert testSurvey1;
				update testSurvey1;



        }

        
    }    
}