@isTest
public class Batch_RefreshButtonRetailTest {

    
    public static testMethod void testAfterInsert()
    {
      UserRole portalRole1 = [Select Id From UserRole Where name='Call Center' Limit 1];           
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        User user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',UserRoleId = portalRole1.Id, 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='JP',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
         system.runAs(user_Obj)
        {
        Date todaydate=System.today();
       Vehicle__c vehicles = new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B200',
                  EuroVIN__c='11111222221111122', UsVIN__c='11111222221111122',Latest_Sales_Person__c='xxx',
                  Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'),Purchase_Month__c ='02',Purchase_Year__c='2004',RegistrationNo__c ='787878');
       insert vehicles;  
       List<Account> AccList= new list<Account>();     
        Account personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='TH', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
        //insert personAccount;
       Account Dealer = new Account(Dealer_Default_Flag__c=true,Dealer_DMS_CRM_Code__c='test code',Dealer_GC_Code__c=user_Obj.Dealer_GC_Code__c,Status__c='xCustomer',City__c='Beijing',Phone = '0808001010',Name = 'test dealer1', Mobile__c = '0000000000',Area_code__c = '010',ZipCode__c='1234567',Allow_Data_Sharing_Comment__c = 'yes',RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId());
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
      Account_Link__c  accLink1 = new Account_Link__c(toRole__c =personAccount.Id,fromRole__c = Dealer.Id,Retail_Delete_Flag__c = false,Retail_Duplicate_Flag__c = false,RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(),Name = 'contact2Contact', Vehicle__c = vehicles.Id);
      //insert accLink1;      //Vehicle_External_Link
      ALList.add(accLink);
      ALList.add(accLink1);
      insert ALList;    
      List<Retail_Campaign__c> RCList= new List<Retail_Campaign__c>();      
      Retail_Campaign__c parentCampaignObj=new Retail_Campaign__c(Name='Test Parent Campaign',Campaign_Type__c='Finance',RecordTypeId=Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId());
      insert parentCampaignObj;
      Retail_Campaign__c retailCampaignObj=new Retail_Campaign__c(Name='Test Retail Campaign',md__c='TH',Segmentation_Base__c ='Vehicle',Execution_Type__c='OB Call',Parent_Campaign1__c=parentCampaignObj.Id,Execution_Start_Date__c=todaydate,MBTH_Approval_Status__c='Approved',RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId());
      insert retailCampaignObj;
           
     Retail_Task__c objRtltask = new Retail_Task__c(Name='RTask',Account__c=personAccount.Id,Type__c='Service Program'
                                         ,Contractor_Address1_Native__c ='Address Native',Contractor_Address3_Native__c='Address3',recordTypeId=Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Contract').getRecordTypeId());
          insert objRtltask;
     Retail_Task__c objRtltask1 = new Retail_Task__c(Name='RTask1',Account__c=personAccount.Id,Type__c='Service Program'
                                         ,Contractor_Address1_Native__c ='Address Native',recordTypeId=Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Contract').getRecordTypeId());
          insert objRtltask1; 
     Retail_Task__c objRtltask2 = new Retail_Task__c(Name='RTask',Account__c=personAccount.Id,Type__c='Service Program'
                                         ,Contractor_Address3_Native__c='Address3',recordTypeId=Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Contract').getRecordTypeId());
          insert objRtltask2;
           
     Campaign_Member__c campaignMemberObj=new Campaign_Member__c(Retail_Campaign_Id__c=retailCampaignObj.Id,Contract__c=objRtltask.id,Auto_creation_of_tasks__c=false,Vehicle__c=vehicles.id,Status__c='Ready',md__c='TH',Contact_Id__c=personAccount.Id);
     insert campaignMemberObj;
     Campaign_Member__c campaignMemberObj1=new Campaign_Member__c(Retail_Campaign_Id__c=retailCampaignObj.Id,Contract__c=objRtltask1.id,Auto_creation_of_tasks__c=false,Vehicle__c=vehicles.id,Status__c='Ready',md__c='TH',Contact_Id__c=personAccount.Id);
     insert campaignMemberObj1; 
     Campaign_Member__c campaignMemberObj2=new Campaign_Member__c(Retail_Campaign_Id__c=retailCampaignObj.Id,Contract__c=objRtltask2.id,Auto_creation_of_tasks__c=false,Vehicle__c=vehicles.id,Status__c='Ready',md__c='TH',Contact_Id__c=personAccount.Id);
     insert campaignMemberObj2;   
     
     test.startTest();
     Batch_RefreshButtonRetail batcher = new Batch_RefreshButtonRetail(retailCampaignObj.id);           
     Database.executeBatch(batcher, 300);
     system.assertEquals(campaignMemberObj.Service_Advisor__c ,accLink.Service_Advisor__c)  ;     
     test.stopTest();
            
            
        }
    }    
    
    
}