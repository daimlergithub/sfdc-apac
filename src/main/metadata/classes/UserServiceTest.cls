@isTest
public class UserServiceTest {
    public static id personaccountid=RecordTypeAccessService.getRecordTypeId('Account','Person Account');
	Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
	private static Account dealer;
	private static Account dealer1;
    public  static testmethod void  userServiceTest(){
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
    	profile p2=[select id from profile where Name='Dealer Community User'];
    	User user1 = new User(LastName='User',Market__c='TH',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01');
    	insert user1;
    	dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='TH', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer1',Dealer_GC_Code__c = '12345',Dealer_nd_Code__C='1235');
    	insert dealer1;
        Contact dealerContact = new Contact(FirstName = 'Test',Permission_Set_Settings__c='str',Md__c='TH', Lastname = 'Amit', AccountId = dealer1.Id, Email = 'test@test.com');
        insert dealerContact;
        User user2 = new User(LastName='GEORGE',contactid=dealerContact.id,country='Australia',ProfileId=p2.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev061');
        insert user2;
      System.runAs (user1) {
     dealer =  new Account(Dealer_Rollout_Status__c ='Done',Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c='TH',Individual_Home_Phone__c='+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = '123456',Dealer_nd_Code__C='12345');
       insert dealer;
         UserService usr=new UserService();
         Retail_Campaign__c ret=new Retail_Campaign__c(Y_Dealer_Name__c=dealer1.id);
         insert ret;
         List<Retail_Campaign__c> retcamplist=new List<Retail_Campaign__c>();
         retcamplist.add(new Retail_Campaign__c(Y_Dealer_Name__c=dealer1.id));
         retcamplist.add(new Retail_Campaign__c(Y_Dealer_Name__c=dealer1.id));
         retcamplist.add(new Retail_Campaign__c(Dealer_Name__c=dealer1.id));
        
         Campaign camp=new Campaign(name='test');
         insert camp;
         List<Participating_Dealer__c> partde=new List<Participating_Dealer__c>();
         partde.add(new Participating_Dealer__c(Campaign__c=camp.id));
         
         insert retcamplist;
          retcamplist.add(ret);
         retcamplist.add(ret);
         List<Tool_Kit__c> toolkit=new List<Tool_Kit__c>();
         toolkit.add(new Tool_Kit__c(Dealer_Name__c=dealer1.id));
         insert toolkit;
         List<Lead__c> leadlst=new List<Lead__c>();
         leadlst.add(new Lead__c(Assigned_Dealer__c=dealer1.id));
         insert leadlst;
         vehicle__c veh=new Vehicle__c(Related_Dealer__c=dealer1.id);
         insert veh;
         List<Retail_Task__c> rettask=new List<Retail_Task__c>();
         rettask.add(new Retail_Task__c(Related_Dealer__c=dealer1.id,Related_Vehicle__c=veh.id));
         insert rettask;
         List<Vehicle_Relationship__c> vehlist=new List<Vehicle_Relationship__c>();
         vehlist.add(new Vehicle_Relationship__c(Owner_Dealer__c=dealer1.id));
         insert vehlist;
         List<Account_Link__c> accountLinks=new List<Account_Link__c>();
         accountLinks.add(new Account_link__C());
         insert accountLinks;
         usr.mapRetailTaskContract2Users(rettask);
         usr.mapYearlyRetailCampaign2CampaignDealers(retcamplist,'str');
         usr.mapRetailCampaign2CampaignDealers(retcamplist,'str');
         usr.mapCampaign2DealerCampaignUsers(partde,'str');
         usr.mapToolKit2CampaignUsers(toolkit,'str');
         usr.mapLead2CampaignUsers(leadlst,new Set<ID>());
         usr.mapCrmCode2Users(rettask);
         usr.mapDealerNdCode2Grp(rettask);
         usr.mapCrmCode2Users(vehlist);
         usr.mapCrmCode2Users(accountLinks);
      
    }
        
    }
    
}