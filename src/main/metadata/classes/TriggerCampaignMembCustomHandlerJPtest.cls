@isTest
public class TriggerCampaignMembCustomHandlerJPtest {
    
    
    
   public static User user_Obj; 
   public static User intgnuser_Obj;
   public static void prepareTestData(){
   UserRole portalRole1 = [Select Id From UserRole Where name='Call Center' Limit 1];           
    Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
    User user_Obj1 = new User(Alias = 'standt', Email='testUser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',UserRoleId = portalRole1.Id, 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='JP',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true); 
    system.runas(user_Obj1){    
   Trigger__c TriggerCampaignmembersCustom =new Trigger__c(Name='TriggerCampaignmembersCustom',Trigger_Name__c='TriggerCampaignmembersCustom',Trigger_Handler__c='TriggerCampaignMembersCustomHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
   List<Trigger__c> lsttrg = new List<Trigger__C>();
   lsttrg.add(TriggerCampaignmembersCustom);
   insert lsttrg;
   user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',UserRoleId = portalRole1.Id, 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='JP',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);   
    insert user_Obj;
    Profile p2 = [select id,name from profile WHERE Name='IntegrationAPI'];      
    intgnuser_Obj= new User(Alias = 'stawdt', Email='testUser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',UserRoleId = portalRole1.Id, 
                          LocaleSidKey='en_US', ProfileId = p2.Id, Market__c='JP',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser21@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);   
    insert intgnuser_Obj;
        
    }    
   }    
   
       public static testMethod void testAfterInsert()
    {   prepareTestData();
        system.runAs(user_Obj)
        {
       test.startTest();     
       Date todaydate=System.today();
       Vehicle__c vehicles = new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B200',
                  EuroVIN__c='11111222221111122', UsVIN__c='11111222221111122',Latest_Sales_Person__c='xxx',
                  Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'),Purchase_Month__c ='02',Purchase_Year__c='2004',RegistrationNo__c ='787878');
       insert vehicles;  
       List<Account> AccList= new list<Account>();    
       Account personAccount = new Account(Dealer_Default_Flag__c=false,  Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',  Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',  City__c='Beijing',  Gender__c = 'Male',  Phone = '0801801110',  Area_code__c = '0101', LastName = '刈乾冠寒刊勘',  FirstName = '刈乾冠寒刊勘',  Salutation = 'Unknown',Province__c = 'Shanghai',ZipCode__c= '1002347',Mobile__c = '023482832',Mobile2__c = '035456232',Primary_Email__c = 'Email1',Primary_Fax__c = 'FAX2',Primary_Phone__c ='Other2',MD__c = 'JP',Industry = 'Other',OwnerId = user_Obj.id,RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());     
      //  Account personAccount =  new Account(FirstName='刈乾冠寒刊勘',LastName='Person Account',Md__c='JP', Individual_Home_Phone__c='9885857857', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
        //insert personAccount;
       Account Dealer = new Account(Dealer_Default_Flag__c=true,Dealer_DMS_CRM_Code__c='test code',Dealer_GC_Code__c=user_Obj.Dealer_GC_Code__c,Status__c='xCustomer',City__c='Beijing',Phone = '0808001010',Name = 'test', Mobile__c = '0000000000',Area_code__c = '010',ZipCode__c='1234567',Allow_Data_Sharing_Comment__c = 'yes',RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId());
       //insert Dealer;  
       AccList.add(personAccount);
       AccList.add(Dealer);     
       insert AccList;     
       Vehicle_Relationship__c vRel = new Vehicle_Relationship__c(Recall__c = FALSE, Car_Relation__c = 'User', RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId());
       vRel.Contact__c = personAccount.id;
       vRel.Vehicle_ID__c = vehicles.id;
       insert vRel;  
       List<Account_Link__c> ALList=new List<Account_Link__c>();    
       Account_Link__c  accLink = new Account_Link__c(toRole__c =Dealer.Id,fromRole__c = personAccount.Id,RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId(),Name = 'contact2Contact', Vehicle__c = vehicles.Id);
      //insert accLink;      //Vehicle_External_Link
      ALList.add(accLink);
      insert ALList;    
      List<Retail_Campaign__c> RCList= new List<Retail_Campaign__c>();      
      Retail_Campaign__c parentCampaignObj=new Retail_Campaign__c(Name='Test Parent Campaign',Campaign_Type__c='Finance',RecordTypeId=Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId());
      insert parentCampaignObj;
      Retail_Campaign__c retailCampaignObj=new Retail_Campaign__c(Name='Test Retail Campaign',md__c='JP',Segmentation_Base__c ='Vehicle',Execution_Type__c='OB Call',Parent_Campaign1__c=parentCampaignObj.Id,Execution_Start_Date__c=todaydate,MBTH_Approval_Status__c='Approved',RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId());
      insert retailCampaignObj;
           
     Retail_Task__c objRtltask = new Retail_Task__c(Name='RTask',Account__c=personAccount.Id,Type__c='Service Program'
                                         ,Contractor_Address1_Native__c ='Address Native',Contractor_Address3_Native__c='Address3',recordTypeId=Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Contract').getRecordTypeId());
          insert objRtltask;
     
    Contact contobj = new Contact();
    contobj.LastName = 'Testutilcampaignlead';
    contobj.Phone = '1212313';
    contobj.Title = 'contact title';
    contobj.Name_English__c = 'c';
    contobj.AccountId = Dealer.Id;
    insert contobj;   
    Campaign_Member__c campaignMemberObj=new Campaign_Member__c(Retail_Campaign_Id__c=retailCampaignObj.Id,Contract__c=objRtltask.id,Auto_creation_of_tasks__c=false,Vehicle__c=vehicles.id,md__c='JP',Contact_Id__c=personAccount.Id);
    insert campaignMemberObj;
    Campaign campobj= new Campaign();
    campobj.RecordTypeId =  Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    campobj.Name = 'camptest1';
    campobj.Type = 'Other';
    campobj.Status = 'Planned';
    campobj.StartDate = System.today();
    campobj.EndDate = System.today();
    campobj.Campaign_Objectives__c = 'camobjectives';
    campobj.Description = 'testdescrip';
    insert campobj;        
            
    CampaignMember member = new CampaignMember();
    member.Status = 'New';
    member.ContactId = contobj.id;
    member.CampaignId = campobj.id;
    insert member; 
    system.assertNotEquals(null, campaignMemberObj.id);        
    test.stopTest();           
     }
    }
   public static testMethod void testAfterInsert1()
    {   prepareTestData();
       triggerUtil.userCreate=false;
        system.runAs(intgnuser_Obj)
        {
        test.startTest();       
         Date todaydate=System.today();
       Vehicle__c vehicles = new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B200',
                  EuroVIN__c='11111222221111122', UsVIN__c='11111222221111122',Latest_Sales_Person__c='xxx',
                  Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'),Purchase_Month__c ='02',Purchase_Year__c='2004',RegistrationNo__c ='787878');
       insert vehicles;  
       List<Account> AccList= new list<Account>();    
       Account personAccount = new Account(Dealer_Default_Flag__c=false,  Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',  Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',  City__c='Beijing',  Gender__c = 'Male',  Phone = '0801801110',  Area_code__c = '0101', LastName = '刈乾冠寒刊勘',  FirstName = '刈乾冠寒刊勘',  Salutation = 'Unknown',Province__c = 'Shanghai',ZipCode__c= '1002347',Mobile__c = '023482832',Mobile2__c = '035456232',Primary_Email__c = 'Email1',Primary_Fax__c = 'FAX2',Primary_Phone__c ='Other2',MD__c = 'JP',Industry = 'Other',OwnerId = user_Obj.id,RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());     
     
       Account Dealer = new Account(Dealer_Default_Flag__c=true,Dealer_DMS_CRM_Code__c='test code',Dealer_GC_Code__c=user_Obj.Dealer_GC_Code__c,Status__c='xCustomer',City__c='Beijing',Phone = '0808001010',Name = 'test', Mobile__c = '0000000000',Area_code__c = '010',ZipCode__c='1234567',Allow_Data_Sharing_Comment__c = 'yes',RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId());
     
       AccList.add(personAccount);
       AccList.add(Dealer);     
       insert AccList;     
       Vehicle_Relationship__c vRel = new Vehicle_Relationship__c(Recall__c = FALSE, Car_Relation__c = 'User', RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId());
       vRel.Contact__c = personAccount.id;
       vRel.Vehicle_ID__c = vehicles.id;
       insert vRel;  
       List<Account_Link__c> ALList=new List<Account_Link__c>();    
       Account_Link__c  accLink = new Account_Link__c(toRole__c =Dealer.Id,fromRole__c = personAccount.Id,RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId(),Name = 'contact2Contact', Vehicle__c = vehicles.Id);
      //insert accLink;      //Vehicle_External_Link
      ALList.add(accLink);
      insert ALList;    
      List<Retail_Campaign__c> RCList= new List<Retail_Campaign__c>();      
      Retail_Campaign__c parentCampaignObj=new Retail_Campaign__c(Name='Test Parent Campaign',Campaign_Type__c='Finance',RecordTypeId=Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId());
      insert parentCampaignObj;
      Retail_Campaign__c retailCampaignObj=new Retail_Campaign__c(Name='Test Retail Campaign',md__c='JP',Segmentation_Base__c ='Vehicle',Execution_Type__c='OB Call',Parent_Campaign1__c=parentCampaignObj.Id,Execution_Start_Date__c=todaydate,MBTH_Approval_Status__c='Approved',RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId());
      insert retailCampaignObj;
           
     Retail_Task__c objRtltask = new Retail_Task__c(Name='RTask',Account__c=personAccount.Id,Type__c='Service Program'
                                         ,Contractor_Address1_Native__c ='Address Native',Contractor_Address3_Native__c='Address3',recordTypeId=Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Contract').getRecordTypeId());
          insert objRtltask;
     
    Contact contobj = new Contact();
    contobj.LastName = 'Testutilcampaignlead';
    contobj.Phone = '1212313';
    contobj.Title = 'contact title';
    contobj.Name_English__c = 'c';
    contobj.AccountId = Dealer.Id;
    insert contobj;   
    Campaign_Member__c campaignMemberObj=new Campaign_Member__c(Retail_Campaign_Id__c=retailCampaignObj.Id,Contract__c=objRtltask.id,Auto_creation_of_tasks__c=false,Vehicle__c=vehicles.id,md__c='JP',Contact_Id__c=personAccount.Id);
    insert campaignMemberObj;
    Campaign campobj= new Campaign();
    campobj.RecordTypeId =  Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    campobj.Name = 'camptest1';
    campobj.Type = 'Other';
    campobj.Status = 'Planned';
    campobj.StartDate = System.today();
    campobj.EndDate = System.today();
    campobj.Campaign_Objectives__c = 'camobjectives';
    campobj.Description = 'testdescrip';
    insert campobj;        
            
    CampaignMember member = new CampaignMember();
    member.Status = 'New';
    member.ContactId = contobj.id;
    member.CampaignId = campobj.id;
    insert member; 
    system.assertNotEquals(null, campaignMemberObj.id);        
     test.stopTest();           

       
            
            
        }
   
    
    }      

    
}