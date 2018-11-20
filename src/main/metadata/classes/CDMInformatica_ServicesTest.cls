@isTest
public class CDMInformatica_ServicesTest {
public static User user1 = TestUtils.createAdminUser();
    //public static User user2 = TestUtils.IntegrationAPIUser();
    public static CDM_EP_Switch__c cdmswitch;
	public static Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id recordTypeFSInquiry_Id=Schema.SObjectType.Case.getRecordTypeInfosByName().get('FS Inquiry').getRecordTypeId();
    public static Account personAcc;
    public static void creatTestData() {
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
        CDM_Integration_URLs__c cdmIntePer= new CDM_Integration_URLs__c(Name='TH-Person Create',Context__c='Person Account',Country__c='TH',Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-TH-SARI-MaintainPersonAccount',Type__c='insert');
        CDM_Integration_URLs__c cdmInteCom= new CDM_Integration_URLs__c(Name='TH-Company Create',Context__c='Company',Country__c='TH',Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-TH-SARI-MaintainOrganizationAccount',Type__c='insert');
        CDM_Integration_URLs__c cdmInteALP= new CDM_Integration_URLs__c(Name='TH-Retail Person Create',Context__c='Retail Person',Country__c='TH',Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-TH-SARI-MaintainOrganizationAccount',Type__c='insert');
        CDM_Integration_URLs__c cdmInteALC= new CDM_Integration_URLs__c(Name='TH-Retail Company Create',Context__c='Retail Company',Country__c='TH',Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-TH-SARI-MaintainOrganizationAccount',Type__c='insert');
        CDM_Integration_URLs__c cdmIntesalessLead= new CDM_Integration_URLs__c(Name='TH-Sales Lead Create',Context__c='Lead',Country__c='TH',Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-TH-SARI-MaintainOrganizationAccount',Type__c='insert');
        insert new List<CDM_Integration_URLs__c>{cdmIntePer,cdmInteCom,cdmInteALP,cdmInteALC,cdmIntesalessLead};
        
        SystemSettingsDFW__c sysObj=new SystemSettingsDFW__c(Log_Purge__c=2);        
    	insert sysObj;
        
        List < Sobject > sobj = new List < sObject > ();
        Trigger__c tr = new Trigger__C(Name = 'TriggerAccountTH', after__c = true, before__c = true, delete__c = true, enabled__c = true, insert__c = true, update__c = true, Market__c = 'TH', Trigger_Handler__c = 'TriggerAccountTriggerHandlerTH', Trigger_Name__c = 'TriggerAccount');
        sobj.add(tr);
        Trigger__C alTR=new Trigger__C(name='TriggerAccountLinkTH',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='TriggerAccountlinkHandlerTH',Trigger_Name__c='TriggerAccountLink',update__c=true);
        sobj.add(alTR);
        Trigger__C leadTr=new Trigger__C(name='TriggerLeadTH',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='LeadTriggerHandlerTH',Trigger_Name__c='TriggerLead',update__c=true);
		sobj.add(leadTr);
        Trigger__C casetrigger=new Trigger__C(name='TriggerCaseTH',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='CaseTriggerHandlerTH',Trigger_Name__c='CaseTrigger',update__c=true);
    	sobj.add(casetrigger);
        Trigger__C caseCommenttrigger=new Trigger__C(name='CaseCommentTriggerTH',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='CaseCommentTriggerHandlerTH',Trigger_Name__c='CaseCommentTrigger',update__c=true);
    	sobj.add(caseCommenttrigger);
        
        cdmswitch= new CDM_EP_Switch__c();
        cdmswitch.name = 'Switch';
        cdmswitch.CDM__c = true;
        sobj.add(cdmswitch);
        insert sobj;
        Account Acc = TestUtils.createPersonAccountAsUserAsOwner(user1);
        acc.UCID__C='1234567809';
        update acc;
        Id dealerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
        Account dealer =  new Account(Dealer_Rollout_Status__c ='Done',Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c='TH',Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerId, Name = 'test dealer',Dealer_GC_Code__c = '123456',Dealer_nd_Code__C='12345');
		insert dealer;
        TriggerRecursiveCheck.run=true;
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test', ToRole__c = Acc.Id, ReCordTypeId = RetailPerson, fromRole__c=dealer.Id,Retail_DMS_Customer_ID__c='123454');
        insert acclnk;
        TriggerRecursiveCheck.run=true;
        Account acc2 = TestUtils.createCompanyAccount(user1);
        acc2.UCID__c='1236448';
        update acc2;
        TriggerRecursiveCheck.run=true;
        Id RetailCompany = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
        Account_Link__c acclnkComp = new Account_Link__c(Name = 'Test', ToRole__c = Acc2.Id, ReCordTypeId = RetailCompany, fromRole__c=dealer.Id);
        insert acclnkComp;
        
        String SalesLeadRType = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordtypeID();
        
        Lead__c lead = new Lead__c();
        lead.Contact__c = Acc.Id;
        lead.CAC_Lead_Status__c = 'Qualified';
        lead.Lead_Type__c = 'New Car';
        lead.md__c='TH';
        lead.RecordTypeId=SalesLeadRType;
        lead.Assigned_Dealer__c = dealer.Id;
        insert lead;
        LeadHelperTH.booleanCampaignUpdate=true;
        lead.CAC_Lead_Status__c='Accepted';
        lead.Retail_Contact__c=acclnk.id;
        update lead;
        
        String AfterSalesLeadRType = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordtypeID();
       	Lead__c alLead = new Lead__c();
        alLead.Contact__c = Acc.Id;
        alLead.CAC_Lead_Status__c = 'Qualified';
        alLead.Lead_Type__c = 'New Car';
        alLead.md__c='TH';
        alLead.RecordTypeId=AfterSalesLeadRType;
        alLead.Assigned_Dealer__c = dealer.Id;
        insert alLead;
        LeadHelperTH.booleanCampaignUpdate=true;
        alLead.CAC_Lead_Status__c='Accepted';
        alLead.Retail_Contact__c=acclnk.id;
        update alLead; 
    }

    public static testMethod void AccountHelperTHTestMethod2() {
        System.runAs(user1) {
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
        CDM_Integration_URLs__c cdmIntePer= new CDM_Integration_URLs__c(Name='TH-Person Create',Context__c='Person Account',Country__c='TH',Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-TH-SARI-MaintainPersonAccount',Type__c='insert');
        CDM_Integration_URLs__c cdmInteCom= new CDM_Integration_URLs__c(Name='TH-Company Create',Context__c='Company',Country__c='TH',Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-TH-SARI-MaintainOrganizationAccount',Type__c='insert');
        CDM_Integration_URLs__c cdmInteALP= new CDM_Integration_URLs__c(Name='TH-Retail Person Create',Context__c='Retail Person',Country__c='TH',Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-TH-SARI-MaintainOrganizationAccount',Type__c='insert');
        CDM_Integration_URLs__c cdmInteALC= new CDM_Integration_URLs__c(Name='TH-Retail Company Create',Context__c='Retail Company',Country__c='TH',Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-TH-SARI-MaintainOrganizationAccount',Type__c='insert');
        CDM_Integration_URLs__c cdmIntesalessLead= new CDM_Integration_URLs__c(Name='TH-Sales Lead Create',Context__c='Lead',Country__c='TH',Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-TH-SARI-MaintainOrganizationAccount',Type__c='insert');
        insert new List<CDM_Integration_URLs__c>{cdmIntePer,cdmInteCom,cdmInteALP,cdmInteALC,cdmIntesalessLead};
        
        SystemSettingsDFW__c sysObj=new SystemSettingsDFW__c(Log_Purge__c=2);        
    	insert sysObj;
        
        List < Sobject > sobj = new List < sObject > ();
        Trigger__c tr = new Trigger__C(Name = 'TriggerAccountTH', after__c = true, before__c = true, delete__c = true, enabled__c = true, insert__c = true, update__c = true, Market__c = 'TH', Trigger_Handler__c = 'TriggerAccountTriggerHandlerTH', Trigger_Name__c = 'TriggerAccount');
        sobj.add(tr);
        Trigger__C alTR=new Trigger__C(name='TriggerAccountLinkTH',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='TriggerAccountlinkHandlerTH',Trigger_Name__c='TriggerAccountLink',update__c=true);
        sobj.add(alTR);
        Trigger__C leadTr=new Trigger__C(name='TriggerLeadTH',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='LeadTriggerHandlerTH',Trigger_Name__c='TriggerLead',update__c=true);
		sobj.add(leadTr);
        Trigger__C casetrigger=new Trigger__C(name='TriggerCaseTH',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='CaseTriggerHandlerTH',Trigger_Name__c='CaseTrigger',update__c=true);
    	sobj.add(casetrigger);
        Trigger__C caseCommenttrigger=new Trigger__C(name='CaseCommentTriggerTH',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='CaseCommentTriggerHandlerTH',Trigger_Name__c='CaseCommentTrigger',update__c=true);
    	sobj.add(caseCommenttrigger);
        
        cdmswitch= new CDM_EP_Switch__c();
        cdmswitch.name = 'Switch';
        cdmswitch.CDM__c = true;
        sobj.add(cdmswitch);
        insert sobj;
        Account Acc = TestUtils.createPersonAccountAsUserAsOwner(user1);
        acc.UCID__C='1234567809';
        update acc;
        Id dealerId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
        Account dealer =  new Account(Dealer_Rollout_Status__c ='Done',Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c='TH',Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerId, Name = 'test dealer',Dealer_GC_Code__c = '123456',Dealer_nd_Code__C='12345');
		insert dealer;
        TriggerRecursiveCheck.run=true;
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test', ToRole__c = Acc.Id, ReCordTypeId = RetailPerson, fromRole__c=dealer.Id,Retail_DMS_Customer_ID__c='123454');
        insert acclnk;
        TriggerRecursiveCheck.run=true;
        Account acc2 = TestUtils.createCompanyAccount(user1);
        acc2.UCID__c='1236448';
        update acc2;
        TriggerRecursiveCheck.run=true;
        Id RetailCompany = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
        Account_Link__c acclnkComp = new Account_Link__c(Name = 'Test', ToRole__c = Acc2.Id, ReCordTypeId = RetailCompany, fromRole__c=dealer.Id);
        insert acclnkComp;
        test.startTest();
    	
        String SalesLeadRType = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordtypeID();
        
        Lead__c lead = new Lead__c();
        lead.Contact__c = Acc.Id;
        lead.CAC_Lead_Status__c = 'New';
        lead.Lead_Type__c = 'New Car';
        lead.md__c='TH';
        lead.RecordTypeId=SalesLeadRType;
        lead.Assigned_Dealer__c = dealer.Id;
        insert lead;
        LeadHelperTH.booleanCampaignUpdate=true;
        lead.CAC_Lead_Status__c='Accepted';
        lead.Retail_Contact__c=acclnk.id;
        update lead;
        
        String AfterSalesLeadRType = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordtypeID();
       	Lead__c alLead = new Lead__c();
        alLead.Contact__c = Acc.Id;
        alLead.CAC_Lead_Status__c = 'Qualified';
        alLead.Lead_Type__c = 'New Car';
        alLead.md__c='TH';
        alLead.RecordTypeId=AfterSalesLeadRType;
        alLead.Assigned_Dealer__c = dealer.Id;
        insert alLead;
        LeadHelperTH.booleanCampaignUpdate=true;
        alLead.CAC_Lead_Status__c='Accepted';
        alLead.Retail_Contact__c=acclnk.id;
        update alLead;         
        test.stopTest();
        }    
	}
     static testMethod void integrationSFDCToCOSTest(){
        Test.startTest();
        System.runAs(user1) {
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
            SystemSettingsDFW__c sysObj=new SystemSettingsDFW__c(Log_Purge__c=2);        
    		insert sysObj;
            Trigger__C casetrigger=new Trigger__C(name='TriggerCaseTH',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='CaseTriggerHandlerTH',Trigger_Name__c='CaseTrigger',update__c=true);
            insert casetrigger;
            Trigger__C caseCommenttrigger=new Trigger__C(name='CaseCommentTriggerTH',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='CaseCommentTriggerHandlerTH',Trigger_Name__c='CaseCommentTrigger',update__c=true);
            insert caseCommenttrigger;
            CDM_Integration_URLs__c caseUpdateUrl=new CDM_Integration_URLs__c(Name='TH-Case Update',Context__c='Case',Country__c='TH',Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-TH-FS-Salesforce-COS',Type__c='Update');
            insert caseUpdateUrl;
            personAcc = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Individual_Home_Phone__c='+66-12-123-789');
            insert personAcc;
            
            Case c1 = new Case(Subject='testing',accountid=personAcc.id,Recordtypeid=recordTypeFSInquiry_Id,MD__c='TH',COS_Ticket_Number__c='T56498');
            insert c1;
            c1.Description='test';
            update c1;
            CaseComment cc1=new CaseComment(CommentBody='test',parentId=c1.Id);
            insert cc1;
        }
        Test.stopTest();
    }
	public static testMethod  void createLeadInAL(){
        String personAccRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String AfterSalesLeadRType = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordtypeID();
        String SalesLeadRType = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordtypeID();
        Profile adminProfile = [SELECT id,name FROM profile WHERE Name='System Administrator'];  
        User jpUSer = new User(Alias = 'standt', Email='testUser@testorg.com', 
                             EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = adminProfile.Id, Market__c='JP',
                             TimeZoneSidKey='America/Los_Angeles', UserName='testuserJP@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        insert jpUSer;
        
        CallOutHandlerSettingDFW__c cs=new CallOutHandlerSettingDFW__c();
        cs.DEFAULT_CALLOUT_TIME__c='1000';
        cs.MAX_CALLOUT_TIME__c='5000';
        cs.Name='CalloutValues';
        insert cs;
        
        JP_Switch__c errorJPSwitch = new JP_Switch__c();
        errorJPSwitch.Enable_Flag__c = true;
        errorJPSwitch.Name = 'Error Handling';
        insert errorJpSwitch;
        
        SystemSettingsDFW__c sysObj=new SystemSettingsDFW__c(Log_Purge__c=2);        
        insert sysObj;
        
        CDM_Integration_URLs__c cdmALLead= new CDM_Integration_URLs__c(Name='JP Create Lead',Context__c='Lead',Country__c='JP',Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-CDM-JP-AL-LeadCreation',Type__c='Insert');
        insert cdmALLead;
        
        System.RunAs(jpUSer){
            //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForAddress());
            Account jpPersonAccount = new Account();
            jpPersonAccount.recordTypeId = personAccRT;
            jpPersonAccount.Data_source__C = 'Event';
            jpPersonAccount.LastName = 'ェネレータ';
            jpPersonAccount.LastName_Native_1__c = 'ェネレータ';
            jpPersonAccount.FirstName_Native_1__c = 'ェネレータ';
            jpPersonAccount.FirstName = 'ェネレータ';
            jpPersonAccount.Market__c = 'JP';
            jpPersonAccount.PersonBirthdate = System.Today().addYears(-20);
            jpPersonAccount.Email__c = 'test@gmail.com';
            jpPersonAccount.Email2__c = 'test21@gmail.com';
            insert jpPersonAccount;
            
            Lead__c alLead = new Lead__c();
            alLead.Contact__c = jpPersonAccount.Id;
            alLead.CAC_Lead_Status__c = 'Qualified';
            alLead.Lead_Type__c = 'New Car';
            alLead.md__c='JP';
            alLead.Market__c = 'JP';
            alLead.RecordTypeId=AfterSalesLeadRType;
            //alLead.Assigned_Dealer__c = dealer.Id;
            insert alLead;
            
            Lead__c salesLead = new Lead__c();
            salesLead.Contact__c = jpPersonAccount.Id;
            salesLead.CAC_Lead_Status__c = 'Qualified';
            salesLead.Lead_Type__c = 'New Car';
            salesLead.md__c='JP';
            salesLead.Market__c = 'JP';
            salesLead.RecordTypeId=SalesLeadRType;
            //alLead.Assigned_Dealer__c = dealer.Id;
            insert salesLead;
            
            Set<Id> leadIdSet = new Set<Id>();
            leadIdSet.add(alLead.Id);
            //leadIdSet.add(salesLead.Id);
            CDMInformatica_Services.createLeadInAL(leadIdSet, 'JP', 'Insert'); 
            
            leadIdSet.clear();
            leadIdSet.add(salesLead.Id);
            CDMInformatica_Services.createLeadInAL(leadIdSet, 'JP', 'Insert'); 
        }//end of run as
    }

 //Added by Sravani Koppaka -- Start
    public static testMethod  void createLeadInALKR(){
        String personAccRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String AfterSalesLeadRType = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordtypeID();
        String SalesLeadRType = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordtypeID();
        Profile adminProfile = [SELECT id,name FROM profile WHERE Name='System Administrator'];  
        User KRUSer = new User(Alias = 'standt', Email='testUser@testorg.com', 
                             EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = adminProfile.Id, Market__c='KR',
                             TimeZoneSidKey='America/Los_Angeles', UserName='testuserJP@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        insert KRUSer;
        
        CallOutHandlerSettingDFW__c cs=new CallOutHandlerSettingDFW__c();
        cs.DEFAULT_CALLOUT_TIME__c='1000';
        cs.MAX_CALLOUT_TIME__c='5000';
        cs.Name='CalloutValues';
        insert cs;
        
        KR_Switch__c errorKRSwitch = new KR_Switch__c();
        errorKRSwitch.Enable_Flag__c = true;
        errorKRSwitch.Name = 'Error Handling';
        insert errorKRSwitch;
        
        SystemSettingsDFW__c sysObj=new SystemSettingsDFW__c(Log_Purge__c=2);        
        insert sysObj;
        
        CDM_Integration_URLs__c cdmALLead= new CDM_Integration_URLs__c(Name='KR Create Lead',Context__c='Lead',Country__c='KR',Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-CDM-KR-AL-LeadCreation',Type__c='Insert');
        insert cdmALLead;
        
        System.RunAs(KRUSer){
        try{
        
            //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForAddress());
            Account KRPersonAccount = new Account();
            KRPersonAccount.recordTypeId = personAccRT;
            KRPersonAccount.LastName='Test Person 1st';
            KRPersonAccount.Status__c='Prospect';
            KRPersonAccount.Province__c='Province1';
            KRPersonAccount.City__c='Test';
            KRPersonAccount.ZipCode__c = '1004235';
            KRPersonAccount.Email__c='test@mbj.com';
            KRPersonAccount.Mobile__c ='+82-00-000-0000';
            //KRPersonAccount.Main_Dealer__c = dealerAccount.id;
            KRPersonAccount.Customer_Lifecycle_Phase__c = 'Care';
            KRPersonAccount.MBK_Data_Source__c='Mercedes-Benz';
            insert KRPersonAccount;
            
            Lead__c alLead = new Lead__c();
            alLead.Contact__c = KRPersonAccount.Id;
            alLead.CAC_Lead_Status__c = 'Qualified';
            alLead.Lead_Type__c = 'New Car';
            alLead.md__c='KR';
            alLead.Market__c = 'KR';
            alLead.RecordTypeId=AfterSalesLeadRType;
            //alLead.Assigned_Dealer__c = dealer.Id;
            insert alLead;
            
            Lead__c salesLead = new Lead__c();
            salesLead.Contact__c = KRPersonAccount.Id;
            salesLead.CAC_Lead_Status__c = 'Qualified';
            salesLead.Lead_Type__c = 'New Car';
            salesLead.md__c='KR';
            salesLead.Market__c = 'KR';
            salesLead.RecordTypeId=SalesLeadRType;
            //alLead.Assigned_Dealer__c = dealer.Id;
            insert salesLead;
            
            Set<Id> leadIdSet = new Set<Id>();
            leadIdSet.add(alLead.Id);
            //leadIdSet.add(salesLead.Id);
            CDMInformatica_Services.createLeadInAL(leadIdSet, 'KR', 'Insert'); 
            
            leadIdSet.clear();
            leadIdSet.add(salesLead.Id);
            CDMInformatica_Services.createLeadInAL(leadIdSet, 'KR', 'Insert'); 
       
        }//end of run as
       
        catch(Exception e)
        {
        }
        }
    }
   //Added by Sravani Koppaka -- End  
	
    public static testMethod  void createCustCdmSpo(){
        String personAccRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String companyAccRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        Profile adminProfile = [SELECT id,name FROM profile WHERE Name='System Administrator'];  
        User jpUSer = new User(Alias = 'st12', Email='testUser@testorg.com', 
                             EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = adminProfile.Id, Market__c='JP',
                             TimeZoneSidKey='America/Los_Angeles', UserName='testuserJP@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        insert jpUSer;
        
        
        
        CallOutHandlerSettingDFW__c cs=new CallOutHandlerSettingDFW__c();
        cs.DEFAULT_CALLOUT_TIME__c='1000';
        cs.MAX_CALLOUT_TIME__c='5000';
        cs.Name='CalloutValues';
        insert cs;
        
        JP_Switch__c errorJPSwitch = new JP_Switch__c();
        errorJPSwitch.Enable_Flag__c = true;
        errorJPSwitch.Name = 'Error Handling';
        insert errorJpSwitch;
        
        SystemSettingsDFW__c sysObj=new SystemSettingsDFW__c(Log_Purge__c=2);        
        insert sysObj;
        
        
        CDM_Integration_URLs__c cdmALLead= new CDM_Integration_URLs__c(Name='JP Create Person Account',Context__c='Person Account',Country__c='JP',Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-CDM-JP-AL-AccountCreation1',Type__c='Insert');
        insert cdmALLead;
        
        CDM_Integration_URLs__c cdmCompanyAcc= new CDM_Integration_URLs__c(Name='JP Create Company Account',Context__c='Company',Country__c='JP',Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-CDM-JP-AL-AccountCreation2',Type__c='Insert');
        insert cdmCompanyAcc;
    	Test.startTest();
        System.RunAs(jpUSer){
            //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForAddress());
            Account jpPersonAccount = new Account();
            jpPersonAccount.recordTypeId = personAccRT;
            jpPersonAccount.Data_source__C = 'Event';
            jpPersonAccount.LastName = 'ェネレータ';
            jpPersonAccount.LastName_Native_1__c = 'ェネレータ';
            jpPersonAccount.FirstName_Native_1__c = 'ェネレータ';
            jpPersonAccount.FirstName = 'ェネレータ';
            jpPersonAccount.Market__c = 'JP';
            jpPersonAccount.PersonBirthdate = System.Today().addYears(-20);
            jpPersonAccount.Email__c = 'test@gmail.com';
            jpPersonAccount.Email2__c = 'test21@gmail.com';
            insert jpPersonAccount;
            
            Account jpCompanyAccount = new Account();
            jpCompanyAccount.recordTypeId = companyAccRT;
            jpCompanyAccount.Data_source__C = 'Event';
            jpCompanyAccount.Name = 'ェネレータ';
            jpCompanyAccount.Market__c = 'JP';
            jpCompanyAccount.Email__c = 'test@gmail.com';
            jpCompanyAccount.Email2__c = 'test21@gmail.com';
            insert jpCompanyAccount;
            
            Set<Id> accountIdSet = new Set<Id>();
            accountIdSet.add(jpPersonAccount.Id);
            accountIdSet.add(jpCompanyAccount.Id);
            CDMInformatica_Services.createCustCdmSpo(accountIdSet,'JP', 'Insert', jpUSer.Id);
            
            
            //accountIdSet.clear();
            
            //CDMInformatica_Services.createCustCdmSpo(accountIdSet,'JP', 'Company', jpUSer.Id);
        }//end of run as
        Test.stopTest();
    }
    
    public static testMethod  void createCustCDMJPOS(){
        String personAccRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String companyAccRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        Profile adminProfile = [SELECT id,name FROM profile WHERE Name='System Administrator'];  
        User jpUSer = new User(Alias = 'st12', Email='testUser@testorg.com', 
                             EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = adminProfile.Id, Market__c='JP',
                             TimeZoneSidKey='America/Los_Angeles', UserName='testuserJP@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        insert jpUSer;
        
        
        
        CallOutHandlerSettingDFW__c cs=new CallOutHandlerSettingDFW__c();
        cs.DEFAULT_CALLOUT_TIME__c='1000';
        cs.MAX_CALLOUT_TIME__c='5000';
        cs.Name='CalloutValues';
        insert cs;
        
        JP_Switch__c errorJPSwitch = new JP_Switch__c();
        errorJPSwitch.Enable_Flag__c = true;
        errorJPSwitch.Name = 'Error Handling';
        insert errorJpSwitch;
        
        SystemSettingsDFW__c sysObj=new SystemSettingsDFW__c(Log_Purge__c=2);        
        insert sysObj;
        
        
        CDM_Integration_URLs__c cdmALLead= new CDM_Integration_URLs__c(Name='JP Create Person Account',Context__c='Person Account',Country__c='JP',Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-CDM-JP-AL-AccountCreation1',Type__c='Insert');
        insert cdmALLead;
        
        CDM_Integration_URLs__c cdmCompanyAcc= new CDM_Integration_URLs__c(Name='JP Create Company Account',Context__c='Company',Country__c='JP',Informatica_URL__c='https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/pd-CDM-JP-AL-AccountCreation2',Type__c='Insert');
        insert cdmCompanyAcc;
    	Test.startTest();
        System.RunAs(jpUSer){
            //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorForAddress());
            Account jpPersonAccount = new Account();
            jpPersonAccount.recordTypeId = personAccRT;
            jpPersonAccount.Data_source__C = 'Event';
            jpPersonAccount.LastName = 'ェネレータ';
            jpPersonAccount.LastName_Native_1__c = 'ェネレータ';
            jpPersonAccount.FirstName_Native_1__c = 'ェネレータ';
            jpPersonAccount.FirstName = 'ェネレータ';
            jpPersonAccount.Market__c = 'JP';
            jpPersonAccount.PersonBirthdate = System.Today().addYears(-20);
            jpPersonAccount.Email__c = 'test@gmail.com';
            jpPersonAccount.Email2__c = 'test21@gmail.com';
            insert jpPersonAccount;
            
            Id individualaddRecordtypeid = Schema.SObjectType.Address__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
            Address__c add=new Address__c();
            add.Customer__c=jpPersonAccount.id;
            add.Province__c='Test province';
            add.City__c='test city';
            add.Block__c='test block';
            add.RecordTypeId=individualaddRecordtypeid;
            add.Address_Line_1__c='test add line 1';
            add.Address_Line_2__c ='test add line 1';
            add.Address_Type__c='Business';
            add.Market__c='JP';
            insert add;
            
            
                 
            
            Account jpCompanyAccount = new Account();
            jpCompanyAccount.recordTypeId = companyAccRT;
            jpCompanyAccount.Data_source__C = 'Event';
            jpCompanyAccount.Name = 'ェネレータ';
            jpCompanyAccount.Market__c = 'JP';
            jpCompanyAccount.Email__c = 'test@gmail.com';
            jpCompanyAccount.Email2__c = 'test21@gmail.com';
            insert jpCompanyAccount;
            
            Id businessaddRecordtypeid = Schema.SObjectType.Address__c.getRecordTypeInfosByName().get('Company').getRecordTypeId();
            Address__c add2=new Address__c();
            add2.Customer__c=jpCompanyAccount.id;
            add2.Province__c='Test province';
            add2.City__c='test city';
            add2.Block__c='test block';
            add2.RecordTypeId=businessaddRecordtypeid;
            add2.Address_Line_1__c='test add line 1';
            add2.Address_Line_2__c ='test add line 1';
            add2.Address_Type__c='Business';
            add2.Market__c='JP';
            insert add2;
            
            Set<Id> accountIdSet = new Set<Id>();
            accountIdSet.add(jpPersonAccount.Id);
            accountIdSet.add(jpCompanyAccount.Id);
            
            
			Map< ID, ID > accAddMap = new Map<Id, Id>();
			accAddMap.put(jpPersonAccount.Id, add.Id);
            accAddMap.put(jpCompanyAccount.Id, add2.Id);
            CDMInformatica_Services.createCustCDMJPOS(accountIdSet, 'JP', 'Insert', accAddMap, jpUSer.Id);
            
        }//end of run as
        Test.stopTest();
    }
    
    public static testMethod  void errorHandlerRealtimeJP(){
        String personAccRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String companyAccRT = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        Profile adminProfile = [SELECT id,name FROM profile WHERE Name='System Administrator'];  
        User jpUSer = new User(Alias = 'st12', Email='testUser@testorg.com', 
                             EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                             LocaleSidKey='en_US', ProfileId = adminProfile.Id, Market__c='JP',
                             TimeZoneSidKey='America/Los_Angeles', UserName='testuserJP@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        insert jpUSer;
        System.runAs(jpUSer){
            HttpResponse res = new HttpResponse();
            res.setStatus('SUCCESS');
            res.setStatusCode(200);
            
            Account jpPersonAccount = new Account();
            jpPersonAccount.recordTypeId = personAccRT;
            jpPersonAccount.Data_source__C = 'Event';
            jpPersonAccount.LastName = 'ェネレータ';
            jpPersonAccount.LastName_Native_1__c = 'ェネレータ';
            jpPersonAccount.FirstName_Native_1__c = 'ェネレータ';
            jpPersonAccount.FirstName = 'ェネレータ';
            jpPersonAccount.Market__c = 'JP';
            jpPersonAccount.PersonBirthdate = System.Today().addYears(-20);
            jpPersonAccount.Email__c = 'test@gmail.com';
            jpPersonAccount.Email2__c = 'test21@gmail.com';
            insert jpPersonAccount;
            
            String realTimeRecordTypeId = Schema.SObjectType.Custom_Debug_Info__c.getRecordTypeInfosByName().get('RealTime').getRecordtypeID();
            Custom_Debug_Info__c cdiNew = new Custom_Debug_Info__c();
			cdiNew.RecordID__c = jpPersonAccount.Id;
            cdiNew.Market__c='JP';
            cdiNew.isSuccess__c=false;
            cdiNew.RecordTypeId = realTimeRecordTypeId;
            insert cdiNew;
            
            Set<Id> recordIDSet = new Set<Id>();
            recordIDSet.add(jpPersonAccount.Id);
            
            
            CDMInformatica_Services.errorHandlerRealtimeJP(res, recordIDSet, 'JP', 'Insert', 'SFDC');
        }
    }
	
}