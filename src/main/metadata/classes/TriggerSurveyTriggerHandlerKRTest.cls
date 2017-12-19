/*********************************************************************************
Name         : TriggerSurveyTriggerHandlerKRTest
Created By   : NTT Data
Modified BY  : 
Company Name : NTT Data
Project      : Daimler APAC  
Created Date : 13th December 2017
Modified Date:
Requirement  : SFDCKR - 1557
Usages       : Test class for code coverage related to TriggerSurvey trigger flow classes.
*********************************************************************************/
@isTest
private class TriggerSurveyTriggerHandlerKRTest 
{
    Public static Id personrectypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    Public static Survey__c survy;
    Public static Survey__c survyHq;
    Public static Account acc;
    Public static Account acchq;
    public static Account dlrAcc;
    public static Group accGrp;
    public static User usrMBKSup;
    public static User usrSup;
    
    static testmethod void test_shareSurverTakertoDealer()
    {
        test.startTest();
        createTestData();
        test.stopTest();
    }
    
	static void createTestData()
    {
        Trigger__c TriggerSurveyKR = new Trigger__c(Name='TriggerSurveyKR',Trigger_Name__c='TriggerSurvey',Trigger_Handler__c='TriggerSurveyTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
        insert TriggerSurveyKR;
        
       User thisUser = [ select Id,ContactId from User where Id = :UserInfo.getUserId()];
       System.runAs(thisUser)
       {
    	   Profile supportProfile = [select Id from Profile where Name =:'System Administrator'];
	       UserRole usrRole = [SELECT Id, Name FROM UserRole where Name = 'MBK Management'];
	       usrMBKSup = new User();
	       usrMBKSup.UserName = 'TestUser.MBKSupport' + Math.rint(Math.random() * 1300000) + '@daimler.com.supportUser';        
	       if(supportProfile != Null)
	       {
		       usrMBKSup.ProfileId = supportProfile.Id;
		   }
		   if(usrRole != null)
	       {
	       		usrMBKSup.UserRoleId = usrRole.Id;
	       }
	       usrMBKSup.LastName = 'MBK Support User';
	       usrMBKSup.Email = 'test.support.user@daimler.com.testuser';
	       usrMBKSup.Alias = 'SupUsr';
	       usrMBKSup.TimeZoneSidKey = 'Asia/Seoul';
	       usrMBKSup.EmailEncodingKey = 'UTF-8';
	       usrMBKSup.LanguageLocaleKey = 'en_US';
	       usrMBKSup.localesidkey='en_US';
	       usrMBKSup.isActive = true;
	       usrMBKSup.Market__c = 'KR';
		   insert usrMBKSup;
       }
        
        dlrAcc = (Account)UtilTestData.createSobject(new Account(mobile__c='010-6363-8383',Dealer_ND_Code__c = 'MBK0463',Dealer_Type__c = 'Company', OwnerId = usrMBKSup.Id, MD__c = 'KR'), UTilTestData.ACCOUNT_RT_DEALER); 
        
        Contact contDlrHQ = new Contact();
        contDlrHQ.AccountId = dlrAcc.Id; 
        contDlrHQ.LastName = 'Test Dealer HQ Contact'; 
        contDlrHQ.Phone = '011-5678-9876'; 
        contDlrHQ.email = 'test@hqcontact.com';        
        insert contDlrHQ;
        
        system.runAs(usrMBKSup)
        {
        	Profile mbkCCCRetailSupervisor = [select Id from Profile where Name ='MBK CCC Retail - Manager'];
	        usrSup = new User();
	        usrSup.UserName = 'test.dealer.callcenter' + Math.rint(Math.random() * 14000000) + '@daimler.com.testuser';        
	        if(mbkCCCRetailSupervisor != Null)
	        {
		       usrSup.ProfileId = mbkCCCRetailSupervisor.Id;
		    }
		       usrSup.LastName = 'Test Dealer HQ Call Center User';
		       usrSup.Email = 'dealer.hqcallcenter.test@daimler.com';
		       usrSup.ContactId = contDlrHQ.Id;
		       usrSup.Alias = 'MBKHQUsr';
		       usrSup.TimeZoneSidKey = 'Asia/Seoul';
		       usrSup.EmailEncodingKey = 'UTF-8';
		       usrSup.LanguageLocaleKey = 'en_US';
		       usrSup.localesidkey='en_US';
		       usrSup.isActive = true;
		       usrSup.Market__C='KR'; 
		       insert usrSup;
        }
        
        accGrp = new group();
        accGrp.Name = dlrAcc.Dealer_ND_Code__c;
        insert accGrp;
        
        /*acc = new Account(Dealer_Default_Flag__c=false,
	       Dealer_DMS_SR_Code__c='test code 2',
	       Status__c='NoCustomer',Email__c = 'testemail@test.com',
	       City__c='Beijing',
	       Gender__c = 'Male',
	       Area_code__c = '0101',
	       LastName = 'galaxy1',
	  	   MBK_Data_Source__c = 'Mercedes Call Catalogue',
	       FirstName = 'First Name',
	       Salutation = 'Unknown',
	       Mobile__c = '011-2833-1222',
	       Primary_Email__c = 'Email1',
	       Primary_Fax__c = 'FAX2',
	       Primary_Phone__c ='Other2',
	       MD__c = 'KR',
	       Industry = 'Other',
	  	   ownerId = userinfo.getUserId(),
	       RecordTypeId = personrectypeId);
        insert acc;*/
        
        survy = new Survey__c();
        survy.Name = 'MBK Survey';
	    survy.Survey_Type__c = 'OB Call';
	    survy.MD__c = 'KR';
      //  insert survy;
        
        system.runAs(usrSup)
        {
           /*acchq = new Account(Dealer_Default_Flag__c=false,
	       Dealer_DMS_SR_Code__c='test code 2',
	       Status__c='NoCustomer',Email__c = 'testemail@test.com',
	       City__c='Beijing',
	       Gender__c = 'Male',
	       Area_code__c = '0101',
	       LastName = 'galaxy1',
	  	   MBK_Data_Source__c = 'Mercedes Call Catalogue',
	       FirstName = 'First Name',
	       Salutation = 'Unknown',
	       Mobile__c = '011-2833-1222',
	       Primary_Email__c = 'Email1',
	       Primary_Fax__c = 'FAX2',
	       Primary_Phone__c ='Other2',
	       MD__c = 'KR',
	       Industry = 'Other',
	  	   ownerId = userinfo.getUserId(),
	       RecordTypeId = personrectypeId);
           insert acchq;*/
        
           survyHq = new Survey__c();
	       survyHq.Name = 'Dealer HQ Survey';
	       survyHq.Survey_Type__c = 'OB Call';
	       survyHq.MD__c = 'KR';
	       insert survyHq;
        }
    }    
}