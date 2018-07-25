@isTest
public with sharing class TriggerCaseHandlerTRTest{

public static User user1;
public static User user2;
public static Market__c market_Obj;
public static Functionality_Access_Master__c functionality_access_master_Obj ;
public static Persona__c persona_Obj; 

static testMethod void testTriggerCaseHandlerTR1() {
    Profile p1 = [select id, name from profile where Name='System Administrator' limit 1];
    user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
        EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='TR',
        TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
  
    System.runAs (user1) {
        group grp = new group(name = '123456', developername = 'testndgroup');
        insert grp;
        group grp1 = new group(name = '1234567', developername = 'testgcgroup');
        insert grp1;
        PermissionSet ps = new PermissionSet();
        ps.Name = 'Test';
        ps.Label = 'Test';
        insert ps;
        Set<String> customperms = new Set<String>{Label.TRRetail, Label.TRGeneric, Label.CreateRetailCopy};
        List<CustomPermission> lcps = new List<CustomPermission>([SELECT ID From CustomPermission WHERE MasterLabel IN :customperms]);
		List<SetupEntityAccess> lsetupentity = new List<SetupEntityAccess>();
        for(CustomPermission cps: lcps){
            SetupEntityAccess sea = new SetupEntityAccess();
        	sea.ParentId = ps.Id;
        	sea.SetupEntityId = cps.id;
            lsetupentity.add(sea);
        }
        
        if(!lsetupentity.isEmpty())
        insert lsetupentity;
        
        CallOutHandlerSettingDFW__c cs=new CallOutHandlerSettingDFW__c();
        cs.DEFAULT_CALLOUT_TIME__c='1000';
        cs.MAX_CALLOUT_TIME__c='5000';
        cs.Name='CalloutValues';
        insert cs;
    
        SystemSettingsDFW__c sysSet = new SystemSettingsDFW__c();
        sysSet.Debug__c =true;
        sysSet.Error__c = true;
        sysSet.Info__c= true;
        sysSet.Warning__c = true;
        sysSet.Log_Purge__c =10;
        sysSet.Name=p1.Name;
        DMLManagerService.insertAsSystem(sysSet);
        
        user2 = UtilTestData.createPersornaUserTR(ps, p1);
      }
        System.runAs (user2) {
        Trigger__c CaseTriggerMY= new Trigger__c(Name='CaseTriggerTR',Trigger_Name__c='CaseTrigger',Trigger_Handler__c='triggercaseHandlerTR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TR');
        insert CaseTriggerMY;
        test.starttest();
        
        List<String> AccountFields=new List<String>();
        AccountFields.add('Mobile__c');
        AccountFields.add('Market__c');
        List<Account> AccountFieldsList=DataFactoryServices.createRecords('Account',AccountFields,'',2);
        AccountFieldsList[0].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        AccountFieldsList[0].Lastname='Lastname1';
		AccountFieldsList[0].firstname='firstnamestname1';
        AccountFieldsList[0].Mobile__c='+609856321478';
        AccountFieldsList[0].Market__c='TR';
		AccountFieldsList[0].Data_Source__c='MBT Event';
        AccountFieldsList[1].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        AccountFieldsList[1].Name = 'test company';
        AccountFieldsList[1].Mobile__c='+609856321479';
        AccountFieldsList[1].Market__c='TR';
		AccountFieldsList[1].Data_Source__c='MBT Event';
        //AccountFieldsList[0].market__C='MY';
        insert AccountFieldsList;
        system.assertEquals(AccountFieldsList[0].id,[select id from account where id=:AccountFieldsList[0].id limit 1].id);
        
        Address__c address=new Address__c();
        address.Address_Type__c='Home';
        address.Province__c='Tokyo';
        address.City__c='bangalore';
        address.District__c='test2';
        address.Block__c='test3';
        address.Address_Line_1__c='testaddress1';
        address.Address_Line_2__c='testaddress2';
        address.Customer__c=AccountFieldsList[0].id;
        address.TitleOfHonor__c = 'To Person';             
		address.Market__c = 'TR';             
        insert address;
        
        AccountFieldsList[0].primary_address_reference__c = address.id;
        update AccountFieldsList[0];
        
        Account dealer = new Account();
        dealer.Dealer_Alternate_Name__c = 'Test Alternate';
        dealer.Phone = '12332121';
        dealer.Dealer_GC_Code__c = '1234567';
        dealer.Dealer_ND_Code__c = '123456';
        dealer.Name = 'test dealer';
        dealer.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        dealer.Star_Elite_Account_Owner__c = user1.Id;
        dealer.Smart_Account_Owner__c = user1.Id;
        dealer.Dealer_Lead_System__c = 'salesforce';
        dealer.Dealer_Lead_Gate_Keeper__c = user1.id;
        dealer.Allow_Data_Sharing__c = 'yes';
        dealer.Province__c = 'jiangsu';
        dealer.City__c = 'nanjing';
        dealer.Preferred_Language__c = 'english';
        dealer.Dealer_Lead_System__c = 'salesforce';
        dealer.Gender__c = '0=Male';
        dealer.ZipCode__c = '20023';
        dealer.Type = '0=Company';
        dealer.Status__c = '0=contac1';
        dealer.No_of_Dealer_Portal_Licenses__c = Decimal.valueOf(20);
        dealer.Dealer_Region__c = 'EAST';
        dealer.Dealer_Active__c = True;
        dealer.Dealer_Rollout_Status__c = 'Done';
		dealer.market__c='TR';
        insert dealer;
        
        List<String> CaseFields=new List<String>();
        CaseFields.add('Status');
        CaseFields.add('Case_RepeatCause__c');
        CaseFields.add('accountid');
        CaseFields.add('Recordtypeid');   
        CaseFields.add('Market__c');
        CaseFields.add('priority');
        List<Case> CaseFieldsList;
        CaseFieldsList=DataFactoryServices.createRecords('Case',CaseFields,'',2);
        CaseFieldsList[0].RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Inquiry').getRecordTypeId();
        CaseFieldsList[0].accountid=AccountFieldsList[0].id;
        CaseFieldsList[0].Market__c='TR';
        CaseFieldsList[0].status='Open';
        CaseFieldsList[0].Case_RepeatCause__c='';
        CaseFieldsList[0].priority='A';
        CaseFieldsList[0].case_dealer__c = dealer.id;
        //CaseFieldsList[0].market__C='MY';
        CaseFieldsList[1].RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
        CaseFieldsList[1].accountid=AccountFieldsList[1].id;
        CaseFieldsList[1].Market__c='TR';
        CaseFieldsList[1].status='Open';
        CaseFieldsList[1].Case_RepeatCause__c='';
        CaseFieldsList[1].priority='Green <= 2';
        CaseFieldsList[1].case_dealer__c = dealer.id;
        //CaseFieldsList[0].market__C='MY';
        insert CaseFieldsList;
        system.assertEquals(CaseFieldsList[0].id,[select id from Case where id=:CaseFieldsList[0].id limit 1].id);
        update CaseFieldsList;
        delete CaseFieldsList;
        test.stoptest();
    }     
    }
}