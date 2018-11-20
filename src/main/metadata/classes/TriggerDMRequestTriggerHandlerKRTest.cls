/*********************************************************************************
Name         : TriggerDMRequestTriggerHandlerKRTest
Created By   : NTT Data
Modified BY  : 
Company Name : NTT Data
Project      : Daimler APAC  
Created Date : 20th November 2017
Modified Date:
Requirement  : SFDCKR - 1558
Usages       : Test class for code coverage related to TriggerDMRequest trigger flow classes.
*********************************************************************************/
@isTest
private class TriggerDMRequestTriggerHandlerKRTest 
{
	public static Id personAccountRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
	
    static testMethod void testDataPreparation() 
    {
       KR_Switch__c krswitch2=new KR_Switch__c(Name='AccountHelperswitch',Enable_Flag__c=True);
   List<KR_Switch__c> lsttrgt2 = new List<KR_Switch__c>();
   lsttrgt2.add(krswitch2);
   insert lsttrgt2;
   Map<String, KR_Switch__c> KRSwitchMap2 = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag2 = false;  
       if(!KRSwitchMap2.isEmpty() && KRSwitchMap2.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag2 = KRSwitchMap2.get('AccountHelperswitch').Enable_Flag__c;
        }
    	DM_Request__c dmReqSC;
      	DM_Request__c dmReqTL;
      	DM_Request__c dmReqMgr;
      	DM_Request__c dmReqRtlCCC;
      	DM_Request__c dmReqIntUsr;
      	User usrSC;
      	User usrTL;
      	User usrMgr;
      	User usrSup;
      	User usrMBKSup;
       
       User thisUser = [ select Id,ContactId from User where Id = :UserInfo.getUserId()];
       System.runAs(thisUser)
       {
    	   Profile supportProfile = [select Id from Profile where Name =:'System Administrator'];
	       UserRole usrRole = [SELECT Id, Name FROM UserRole where Name = 'MBK Management'];
	       usrMBKSup = new User();
	       usrMBKSup.UserName = 'TestUser.MBKSupport' + Math.rint(Math.random() * 800000) + '@daimler.com.supportUser';        
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
      	
    	Trigger__c TriggerDMRequestKR = new Trigger__c();
    	TriggerDMRequestKR.Name='TriggerDMRequestKR';
    	TriggerDMRequestKR.Trigger_Name__c='TriggerDMRequest';
    	TriggerDMRequestKR.Trigger_Handler__c='TriggerDMRequestTriggerHandlerKR';
    	TriggerDMRequestKR.update__c=True;
    	TriggerDMRequestKR.insert__c=True;
    	TriggerDMRequestKR.delete__c=True;
    	TriggerDMRequestKR.after__c=True;
    	TriggerDMRequestKR.before__c=True;
    	TriggerDMRequestKR.enabled__c=True;
    	TriggerDMRequestKR.Market__c='KR';
  		insert TriggerDMRequestKR;
  		
        Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        
        Account accObj1 = new Account();
        accObj1.RecordTypeId = recordTypeAccDealerAccountObjId;
        accObj1.Name='Dealer Company';
        accObj1.Phone ='543234760605';
        accObj1.Dealer_Rollout_Status__c='Done';
        accObj1.MD__c='KR';
        accObj1.Dealer_Type__c = 'Company';
        accObj1.Dealer_GC_Code__c='GC1234';
        accObj1.Dealer_ND_Code__c='MBK963KR';
        accObj1.OwnerId = usrMBKSup.Id;
        insert accObj1;
        
        Account accObj2 = new Account();
        accObj2.RecordTypeId = recordTypeAccDealerAccountObjId;
        accObj2.Name='Dealer Outlet';
        accObj2.Phone ='09874760605';
        accObj2.Dealer_Rollout_Status__c='Done';
        accObj2.MD__c='KR';
        accObj2.ParentId = accObj1.Id;
        accObj2.Dealer_Type__c = 'Outlet';
        accObj2.Dealer_GC_Code__c='GC1234';
        accObj2.Dealer_ND_Code__c='MBK369KR';
        accObj2.OwnerId = usrMBKSup.Id;
        insert accobj2;
        
        Contact contSC = new Contact();
        contSC.AccountId = accobj2.Id; 
        contSC.LastName = 'Test Sales Consultant Contact'; 
        contSC.Phone = '019-5678-9876'; 
        contSC.email = 'test@contact.com';        
        insert contSC;
        
        Contact contTL = new Contact();
        contTL.AccountId = accobj2.Id; 
        contTL.LastName = 'Test Team Lead Contact'; 
        contTL.Phone = '018-5678-9876'; 
        contTL.email = 'test@contact.com';        
        insert contTL;
        
        Contact contMgr = new Contact();
        contMgr.AccountId = accobj2.Id; 
        contMgr.LastName = 'Test Manager Contact'; 
        contMgr.Phone = '010-5678-9876'; 
        contMgr.email = 'test@contact.com';        
        insert contMgr;
        
        Contact contDlrHQ = new Contact();
        contDlrHQ.AccountId = accobj1.Id; 
        contDlrHQ.LastName = 'Test Manager Contact'; 
        contDlrHQ.Phone = '011-5678-9876'; 
        contDlrHQ.email = 'test@contact.com';        
        insert contDlrHQ;
        
        system.runAs(usrMBKSup)
        {
	        Profile mbkDealerSalesManager = [select Id from Profile where Name ='MBK  Dealer SR/SC - Mgr / Admin'];
	        usrMgr = new User();
	        usrMgr.UserName = 'test.Manager' + Math.rint(Math.random() * 9000000) + '@daimler.com.testuser';        
	        if(mbkDealerSalesManager != Null)
	        {
		       usrMgr.ProfileId = mbkDealerSalesManager.Id;
		    }
		       usrMgr.LastName = 'Test Manager';
		       usrMgr.Email = 'manager.test@daimler.com';
		       usrMgr.ContactId = contMgr.Id;
		       usrMgr.Alias = 'MBKMRUsr';
		       usrMgr.TimeZoneSidKey = 'Asia/Seoul';
		       usrMgr.EmailEncodingKey = 'UTF-8';
		       usrMgr.LanguageLocaleKey = 'en_US';
		       usrMgr.localesidkey='en_US';
		       usrMgr.isActive = true;
		       usrMgr.Market__C='KR'; 
		       usrMgr.MBK_Partner_Roles__c = 'Sales Manager';
		       usrMgr.MBK_Reporting_Partner_User__c = usrMBKSup.Id;
		       insert usrMgr;
		       
		    Profile mbkDealerTeamLead = [select Id from Profile where Name ='MBK Dealer SR/SC - SC/SA'];
	        usrTL = new User();
	        usrTL.UserName = 'test.TeamLead' + Math.rint(Math.random() * 6000000) + '@daimler.com.testuser';        
	        if(mbkDealerTeamLead != Null)
	        {
		       usrTL.ProfileId = mbkDealerTeamLead.Id;
		    }
		       usrTL.LastName = 'Test Team Lead';
		       usrTL.Email = 'TeamLead.test@daimler.com';
		       usrTL.ContactId = contTL.Id;
		       usrTL.Alias = 'MBKTLUsr';
		       usrTL.TimeZoneSidKey = 'Asia/Seoul';
		       usrTL.EmailEncodingKey = 'UTF-8';
		       usrTL.LanguageLocaleKey = 'en_US';
		       usrTL.localesidkey='en_US';
		       usrTL.isActive = true;
		       usrTL.Market__C='KR';  
		       usrTL.MBK_Partner_Roles__c = 'Team Leader';
		       usrTL.MBK_Reporting_Partner_User__c = usrMgr.Id;
		       insert usrTL;
		    
		    Profile mbkDealerSalesConsultant = [select Id from Profile where Name ='MBK Dealer SR/SC'];
	        usrSC = new User();
	        usrSC.UserName = 'test.SalesConsultant' + Math.rint(Math.random() * 3000000) + '@daimler.com.testuser';        
	        if(mbkDealerSalesConsultant != Null)
	        {
		       usrSC.ProfileId = mbkDealerSalesConsultant.Id;
		    }
		       usrSC.LastName = 'Test Sales Consultant';
		       usrSC.Email = 'SalesConsultant.test@daimler.com';
		       usrSC.ContactId = contSC.Id;
		       usrSC.Alias = 'MBKSCUsr';
		       usrSC.TimeZoneSidKey = 'Asia/Seoul';
		       usrSC.EmailEncodingKey = 'UTF-8';
		       usrSC.LanguageLocaleKey = 'en_US';
		       usrSC.localesidkey='en_US';
		       usrSC.isActive = true;
		       usrSC.Market__C='KR'; 
		       usrSC.MBK_Partner_Roles__c = 'Sales Consultant';
		       usrSC.MBK_Reporting_Partner_User__c = usrTL.Id;
		       insert usrSC;
		          
		    Profile mbkCCCRetailSupervisor = [select Id from Profile where Name ='MBK CCC Retail - Manager'];
	        usrSup = new User();
	        usrSup.UserName = 'test.dealer.callcenter' + Math.rint(Math.random() * 1000000) + '@daimler.com.testuser';        
	        if(mbkCCCRetailSupervisor != Null)
	        {
		       usrSup.ProfileId = mbkCCCRetailSupervisor.Id;
		    }
		       usrSup.LastName = 'Test Dealer Call Center User';
		       usrSup.Email = 'dealer.callcenter.test@daimler.com';
		       usrSup.ContactId = contDlrHQ.Id;
		       usrSup.Alias = 'MBKDCUsr';
		       usrSup.TimeZoneSidKey = 'Asia/Seoul';
		       usrSup.EmailEncodingKey = 'UTF-8';
		       usrSup.LanguageLocaleKey = 'en_US';
		       usrSup.localesidkey='en_US';
		       usrSup.isActive = true;
		       usrSup.Market__C='KR'; 
		       insert usrSup;
        }
	   Profile integrationProfile = [select Id from Profile where Name =:'IntegrationAPI'];
       User usrInt = new User();
       usrInt.UserName = 'testIntegration' + Math.rint(Math.random() * 400000) + '@daimler.com.integrationUser';        
       if(integrationProfile != Null)
       {
	       usrInt.ProfileId = integrationProfile.Id;
	   }
	       usrInt.LastName = 'Test Integration User';
	       usrInt.Email = 'test.integrarion@daimler.com.full';
	       usrInt.Alias = 'IntUsr';
	       usrInt.TimeZoneSidKey = 'Asia/Seoul';
	       usrInt.EmailEncodingKey = 'UTF-8';
	       usrInt.LanguageLocaleKey = 'en_US';
	       usrInt.localesidkey='en_US';
	       usrInt.isActive = true;
	       insert usrInt;
	    
	    group grpComp = new group();
	    grpComp.name = 'MBK963KR';
	    insert grpComp;
	    
	    group grpOlet = new group();
	    grpOlet.name = 'MBK369KR';
	    insert grpOlet;
	          
      	Test.startTest();
		system.runAs(usrSC)
		{
			Account personAccountSC = new Account();
         if (!KRSwitchEnabledFlag2) {
	        personAccountSC.RecordTypeId=personAccountRecordtypeid;
	        personAccountSC.LastName='Test Account';
	        personAccountSC.MBK_Data_Source__c='Email';
	        personAccountSC.Mobile__c='0130-5678-9876';
            }
            else{
             personAccountSC.RecordTypeId=personAccountRecordtypeid;
            personAccountSC.LastName='Test Account';
            personAccountSC.MBK_Data_Source__c='Email';
            personAccountSC.Mobile__c='+82-130-567-9876';
            }
	        insert personAccountSC;
	        
	        Address__c addrSC = new Address__c();
	        addrSC.Customer__c = personAccountSC.Id;
	        addrSC.Address_Type__c = 'Home';
	        insert addrSC;
        
			dmReqSC = new DM_Request__c();
	        dmReqSC.Customer_Name__c = personAccountSC.Id;
	        dmReqSC.Sending_Address__c = 'Home';
	        dmReqSC.TitleOfHonor__c = 'To Person';
	      	insert dmReqSC;
	      	
	      	DM_Request__Share dmReqShare = new DM_Request__Share();
			dmReqShare.ParentId = dmReqSC.Id;
			dmReqShare.AccessLevel = 'Edit';
			dmReqShare.UserOrGroupId = grpComp.Id;
			insert dmReqShare;
		} 
		system.runAs(usrTL)
		{
			Account personAccountTL = new Account();
              if (!KRSwitchEnabledFlag2) {
	        personAccountTL.RecordTypeId=personAccountRecordtypeid;
	        personAccountTL.LastName='Test Account';
	        personAccountTL.MBK_Data_Source__c='Email';
	        personAccountTL.Mobile__c='0130-5678-9876';
           }
           else{
           personAccountTL.RecordTypeId=personAccountRecordtypeid;
            personAccountTL.LastName='Test Account';
            personAccountTL.MBK_Data_Source__c='Email';
            personAccountTL.Mobile__c='+82-130-578-9876';
           }
	        insert personAccountTL;
	        
	        Address__c addrTL = new Address__c();
	        addrTL.Customer__c = personAccountTL.Id;
	        addrTL.Address_Type__c = 'Home';
	        insert addrTL;
	        
			dmReqTL = new DM_Request__c();
	        dmReqTL.Customer_Name__c = personAccountTL.Id;
	        dmReqTL.Sending_Address__c = 'Home';
	        dmReqTL.TitleOfHonor__c = 'To Person';
	      	insert dmReqTL;
	      	
	      	DM_Request__Share dmReqShare = new DM_Request__Share();
			dmReqShare.ParentId = dmReqTL.Id;
			dmReqShare.AccessLevel = 'Edit';
			dmReqShare.UserOrGroupId = grpComp.Id;
			insert dmReqShare;
		} 
		system.runAs(usrMgr)
		{
			Account personAccountMgr = new Account();
         if (!KRSwitchEnabledFlag2) {
           
	        personAccountMgr.RecordTypeId=personAccountRecordtypeid;
	        personAccountMgr.LastName='Test Account';
	        personAccountMgr.MBK_Data_Source__c='Email';
	        personAccountMgr.Mobile__c='0130-5678-9876';
            }
            else{
           
            personAccountMgr.RecordTypeId=personAccountRecordtypeid;
            personAccountMgr.LastName='Test Account';
            personAccountMgr.MBK_Data_Source__c='Email';
            personAccountMgr.Mobile__c='+82-130-578-9876';
            }
	        insert personAccountMgr;
	        
	        Address__c addrMgr = new Address__c();
	        addrMgr.Customer__c = personAccountMgr.Id;
	        addrMgr.Address_Type__c = 'Home';
	        insert addrMgr;
	        
			dmReqMgr = new DM_Request__c();
	        dmReqMgr.Customer_Name__c = personAccountMgr.Id;
	        dmReqMgr.Sending_Address__c = 'Home';
	        dmReqMgr.TitleOfHonor__c = 'To Person';
	      	insert dmReqMgr;
	      	
	      	DM_Request__Share dmReqShare = new DM_Request__Share();
			dmReqShare.ParentId = dmReqMgr.Id;
			dmReqShare.AccessLevel = 'Edit';
			dmReqShare.UserOrGroupId = grpComp.Id;
			insert dmReqShare;
		} 
		system.runAs(usrSup)
		{
			Account personAccountSup = new Account();
         if (!KRSwitchEnabledFlag2) {
	        personAccountSup.RecordTypeId=personAccountRecordtypeid;
	        personAccountSup.LastName='Test Account';
	        personAccountSup.MBK_Data_Source__c='Email';
	        personAccountSup.Mobile__c='0130-5678-9876';
            }
            else{
              personAccountSup.RecordTypeId=personAccountRecordtypeid;
            personAccountSup.LastName='Test Account';
            personAccountSup.MBK_Data_Source__c='Email';
            personAccountSup.Mobile__c='+82-130-578-9876';
            }
	        insert personAccountSup;
	        
	        Address__c addrSup = new Address__c();
	        addrSup.Customer__c = personAccountSup.Id;
	        addrSup.Address_Type__c = 'Home';
	        insert addrSup;
	        
			dmReqRtlCCC = new DM_Request__c();
	        dmReqRtlCCC.Customer_Name__c = personAccountSup.Id;
	        dmReqRtlCCC.Sending_Address__c = 'Home';
	        dmReqRtlCCC.TitleOfHonor__c = 'To Person';
	      	insert dmReqRtlCCC;
		}  
		system.runAs(usrMBKSup)
		{
			dmReqSC.OwnerId = usrTL.Id;
	      	update dmReqSC;
		}
		system.runAs(usrInt)
		{
			Account personAccountInt = new Account();
             if (!KRSwitchEnabledFlag2) {
           
	        personAccountInt.RecordTypeId=personAccountRecordtypeid;
	        personAccountInt.LastName='Test Account';
	        personAccountInt.MBK_Data_Source__c='Email';
	        personAccountInt.Mobile__c='0130-5678-9876';
            }
            else{
             personAccountInt.RecordTypeId=personAccountRecordtypeid;
            personAccountInt.LastName='Test Account';
            personAccountInt.MBK_Data_Source__c='Email';
            personAccountInt.Mobile__c='0130-5678-9876';
            }
	        insert personAccountInt;
	        
	        Address__c addrInt = new Address__c();
	        addrInt.Customer__c = personAccountInt.Id;
	        addrInt.Address_Type__c = 'Home';
	        insert addrInt;
	        
			dmReqIntUsr = new DM_Request__c();
	        dmReqIntUsr.Customer_Name__c = personAccountInt.Id;
	        dmReqIntUsr.Sending_Address__c = 'Home';
	        dmReqIntUsr.TitleOfHonor__c = 'To Person';
	      	insert dmReqIntUsr;
		}
		Test.stopTest();
    }
}