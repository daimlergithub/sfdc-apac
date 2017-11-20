/*********************************************************************************
Name         : taskRecordViewOnCampaignControllerTest
Created By   : NTT Data
Modified BY  : 
Company Name : NTT Data
Project      : Daimler APAC  
Created Date : 18th November 2017
Modified Date:
Requirement  : SFDCKR - 1558
Usages       : Test class for code coverage related to taskRecordViewOnCampaignController class.
*********************************************************************************/
@isTest
private class taskRecordViewOnCampaignControllerTest 
{
	public static string campPlngRecTypId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    public static String campDsgRecTypId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CAC Campaign').getRecordTypeId();
    public static String campExcRecTypId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution - Complex').getRecordTypeId();
    public static Id dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static Id personAccountRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id kakaoTaskRecordtypeid = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
    public static list<CampaignMember> campMembrList;
    public static list<Contact> contList;
    public static list<Account> accountList;
    public static list<Task> taskList;
    public static Campaign campExec;

    static testMethod void testDataPreparation() 
    {
    	contList = new list<Contact>();
    	accountList = new list<Account>();
      	campMembrList = new list<CampaignMember>();
      	taskList = new list<Task>();
      
		Campaign campPlng = new Campaign();
		campPlng.RecordTypeId = campPlngRecTypId;
		campPlng.Name = 'Test Campaign Planning';
		campPlng.Type = 'Other';
		campPlng.Status = 'Planning';
		campPlng.StartDate = System.today();
		campPlng.EndDate = System.today()+30;
		campPlng.Campaign_Executer__c='Retail';
		campPlng.Campaign_Objectives__c = 'camobjectives';
		campPlng.Description = 'Test Campaign Planning Description';
		campPlng.Campaign_Execution_Channels__c='eMail';
		campPlng.Campaign_Type__c = 'After Sales';
		insert campPlng;
      
        Campaign campDsgn = new Campaign();
	    campDsgn.Name = 'Test Campaign Design'; 
	    campDsgn.CAC_Frequency_Category__c = 'Ad Hoc';
	    campDsgn.Repeat_From__c = System.today(); 
	    campDsgn.Repeat_End__c = System.today()+30;           
	    campDsgn.RecordTypeId = campDsgRecTypId;
	    insert campDsgn;
        
        campExec = new Campaign();
        campExec.IsActive = true; 
        campExec.Name = 'Test Campaign Execution'; 
        campExec.Task_Created_By__c = 'Contact';
        campExec.Execution_Type__c = 'OB Call';
        campExec.StartDate = System.today(); 
        campExec.EndDate = System.today()+30;        
        campExec.RecordTypeId = campExcRecTypId;
        insert campExec;
        
        for(integer i=0; i<=5; i++)
        {
        	Account personAccount = new Account();
	        personAccount.RecordTypeId=personAccountRecordtypeid;
	        personAccount.LastName='Test Account';
	        personAccount.MBK_Data_Source__c='Email';
	        personAccount.Mobile__c='0130-5678-9876';
	        accountList.add(personAccount);
        }
       insert accountList;
       
       contList = [select Id,AccountId from COntact where name like '%Test Account%'];

       for(contact con : contList)
       { 
       	system.debug('*$*$*$* con.AccountId  ' + con.AccountId);
          CampaignMember campMbr = new CampaignMember();
          campMbr.CampaignId = campExec.Id;
          campMbr.ContactId = con.Id;           
          campMbr.Status = 'Send';
          campMbr.Task_Generated__c = false;
          campMembrList.add(campMbr);
       }
       insert campMembrList; 
       
       Group grp = [Select Id, Name from Group where name like '%MBK0%' limit 1];
       
       list<AccountShare> accShrList = new list<AccountShare>();
       for(Account accnt: accountList)
       {
       	   AccountShare accshr = new AccountShare();
		   accshr.AccountId = accnt.Id;
		   accshr.AccountAccessLevel = 'Edit';
		   accshr.CaseAccessLevel = 'None';
		   accshr.OpportunityAccessLevel = 'None';
		   accshr.UserOrGroupId = grp.Id;
		   accShrList.add(accshr);
       }
	   insert accShrList;
    }
    static testMethod void showCampaignTaskListWsUsrTest() 
    {
    	testDataPreparation();
    	
       Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
       Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId,Name='Dealer',Phone ='09874760605',Dealer_Rollout_Status__c='Done',MD__c='KR',Dealer_GC_Code__c='1234',Dealer_ND_Code__c='1234');
       insert accobj2;
       
       Profile koreaCallCenter = [select Id from Profile where Name =:'Korea Call Center'];
       User usr = new User();
       usr.UserName = 'test' + Math.rint(Math.random() * 500000) + '@daimler.com.TestUser';        
       if(koreaCallCenter != Null)
       {
	       usr.ProfileId = koreaCallCenter.Id;
	   }
	       usr.LastName = 'Test User';
	       usr.Email = 'test001@daimler.com.full';
	       usr.Alias = 'Atest';
	       usr.TimeZoneSidKey = 'Asia/Seoul';
	       usr.EmailEncodingKey = 'UTF-8';
	       usr.LanguageLocaleKey = 'en_US';
	       usr.localesidkey='en_US';
	       usr.isActive = true;
	       usr.Market__C='KR';    
	       insert usr;
        
       Test.startTest();
		system.runAs(usr)
		{
			ApexPages.StandardController sc = new ApexPages.StandardController(campExec);
	        taskRecordViewOnCampaignController taskRecContrl = new taskRecordViewOnCampaignController(sc);
		}
		Test.stopTest();
    }
    static testMethod void showCampaignTaskListDlrUsrTest() 
    {
    	testDataPreparation();
    	
       Id recordTypeAccDealerAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
       Account accObj2 = new Account(RecordTypeId = recordTypeAccDealerAccountObjId,Name='Dealer',Phone ='09874760605',Dealer_Rollout_Status__c='Done',MD__c='KR',Dealer_GC_Code__c='GC1234',Dealer_ND_Code__c='MBK32KR');
       insert accobj2;
       
        Contact cont = new Contact();
        cont.AccountId = accobj2.Id; 
        cont.LastName = 'Test Contact'; 
        cont.Phone = '1234-5678-9876'; 
        cont.email = 'test@contact.com';        
        insert cont;
        
        Profile mbkCCCRetailOperator = [select Id from Profile where Name ='MBK CCC Retail Operator'];
        User usr = new User();
        usr.UserName = 'test' + Math.rint(Math.random() * 600000) + '@daimler.com.TestUser';        
        if(mbkCCCRetailOperator != Null)
        {
	       usr.ProfileId = mbkCCCRetailOperator.Id;
	    }
	       usr.LastName = 'Test User';
	       usr.Email = 'test001@daimler.com.testUser';
	       usr.ContactId = cont.Id;
	       usr.Alias = 'AUsrtest';
	       usr.TimeZoneSidKey = 'Asia/Seoul';
	       usr.EmailEncodingKey = 'UTF-8';
	       usr.LanguageLocaleKey = 'en_US';
	       usr.localesidkey='en_US';
	       usr.isActive = true;
	       usr.Market__C='KR'; 
	       insert usr;
	       
	       group grp = new group();
	       grp.name = 'MBK32KR';
	       insert grp;
	     
	     list<AccountShare> accShrList = new list<AccountShare>();
	      for(Account accnt: accountList)
	       {
	       	   AccountShare accShrUsr = new AccountShare();
			   accShrUsr.AccountId = accnt.Id;
			   accShrUsr.AccountAccessLevel = 'Edit';
			   accShrUsr.CaseAccessLevel = 'None';
			   accShrUsr.OpportunityAccessLevel = 'None';
			   accShrUsr.UserOrGroupId = usr.Id;
			   accShrList.add(accShrUsr);
			   
			   AccountShare accShrGrp = new AccountShare();
			   accShrGrp.AccountId = accnt.Id;
			   accShrGrp.AccountAccessLevel = 'Edit';
			   accShrGrp.CaseAccessLevel = 'None';
			   accShrGrp.OpportunityAccessLevel = 'None';
			   accShrGrp.UserOrGroupId = grp.Id;
			   accShrList.add(accShrGrp);
	       }
		   insert accShrList;
		   
	     CampaignShare campShare = new CampaignShare();
		 campShare.CampaignId = campExec.Id;
		 campShare.CampaignAccessLevel = 'Read';
		 campShare.UserOrGroupId  = usr.Id;
		 insert campShare;
		 
		  for(CampaignMember camMembr : campMembrList)
	       {
	       	Task tsk = new Task();
	       	tsk.subject = 'OB Call';
	       	tsk.RecordTypeId = kakaoTaskRecordtypeid;
	       	tsk.WhoId = camMembr.ContactId;
	       	tsk.WhatId = campExec.Id;
	       	tsk.status = 'Open';
	       	taskList.add(tsk);       	
	       } 
	       insert taskList;
       
       Test.startTest();
		system.runAs(usr)
		{
			ApexPages.StandardController sc = new ApexPages.StandardController(campExec);
			apexpages.currentpage().getparameters().put('Id' , campExec.Id);
	        system.debug('*$*$*$ camMbrList   ' + campMembrList);
            list<CampaignMember> memberList = [select Id from CampaignMember where CampaignId =: campExec.Id];
            system.debug('*$*$*$ memberList   ' + memberList);
	        taskRecordViewOnCampaignController taskRecContrl = new taskRecordViewOnCampaignController(sc);
		}
		Test.stopTest();
    }
}