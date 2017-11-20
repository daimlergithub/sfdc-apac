/*********************************************************************************
Name         : TriggerDMMaterialTriggerHandlerKRTest
Created By   : NTT Data
Modified BY  : 
Company Name : NTT Data
Project      : Daimler APAC  
Created Date : 19th November 2017
Modified Date:
Requirement  : SFDCKR - 1558
Usages       : Test class for code coverage related to TriggerDMMaterial trigger flow classes.
*********************************************************************************/
@isTest
private class TriggerDMMaterialTriggerHandlerKRTest 
{
    static testMethod void testDataPreparation() 
    {
    	DM_Material__c dmMtrlSC;
      	DM_Material__c dmMtrlTL;
      	DM_Material__c dmMtrlMgr;
      	DM_Material__c dmMtrlRtlCCC;
      	DM_Material__c dmMtrlIntUsr;
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
      	
    	Trigger__c TriggerDMMaterialKR = new Trigger__c();
    	TriggerDMMaterialKR.Name='TriggerDMMaterialKR';
    	TriggerDMMaterialKR.Trigger_Name__c='TriggerDMMaterial';
    	TriggerDMMaterialKR.Trigger_Handler__c='TriggerDMMaterialTriggerHandlerKR';
    	TriggerDMMaterialKR.update__c=True;
    	TriggerDMMaterialKR.insert__c=True;
    	TriggerDMMaterialKR.delete__c=True;
    	TriggerDMMaterialKR.after__c=True;
    	TriggerDMMaterialKR.before__c=True;
    	TriggerDMMaterialKR.enabled__c=True;
    	TriggerDMMaterialKR.Market__c='KR';
  		insert TriggerDMMaterialKR;
  		
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
			dmMtrlSC = new DM_Material__c();
	        dmMtrlSC.Name = 'Test DM Material SC Created';
	      	insert dmMtrlSC;
	      	
	      	DM_Material__Share dmMtrlShare = new DM_Material__Share();
			dmMtrlShare.ParentId = dmMtrlSC.Id;
			dmMtrlShare.AccessLevel = 'Edit';
			dmMtrlShare.UserOrGroupId = grpComp.Id;
			insert dmMtrlShare;
		} 
		system.runAs(usrTL)
		{
			dmMtrlTL = new DM_Material__c();
	        dmMtrlTL.Name = 'Test DM Material TL Created';
	      	insert dmMtrlTL;
	      	
	      	DM_Material__Share dmMtrlShare = new DM_Material__Share();
			dmMtrlShare.ParentId = dmMtrlTL.Id;
			dmMtrlShare.AccessLevel = 'Edit';
			dmMtrlShare.UserOrGroupId = grpComp.Id;
			insert dmMtrlShare;
		} 
		system.runAs(usrMgr)
		{
			dmMtrlMgr = new DM_Material__c();
	        dmMtrlMgr.Name = 'Test DM Material Mgr Created';
	      	insert dmMtrlMgr;
	      	
	      	DM_Material__Share dmMtrlShare = new DM_Material__Share();
			dmMtrlShare.ParentId = dmMtrlMgr.Id;
			dmMtrlShare.AccessLevel = 'Edit';
			dmMtrlShare.UserOrGroupId = grpComp.Id;
			insert dmMtrlShare;
		} 
		system.runAs(usrSup)
		{
			dmMtrlRtlCCC = new DM_Material__c();
	        dmMtrlRtlCCC.Name = 'Test DM Material Retail HQ Created';
	      	insert dmMtrlRtlCCC;
		}  
		system.runAs(usrMBKSup)
		{
			dmMtrlSC.OwnerId = usrTL.Id;
	      	update dmMtrlSC;
		}
		system.runAs(usrInt)
		{
			dmMtrlIntUsr = new DM_Material__c();
	        dmMtrlIntUsr.Name = 'Test DM Material Ingration Created';
	      	insert dmMtrlIntUsr;
		}
		Test.stopTest();
    }
}