/**
* Test class for AccountLink Helper class for FM markets.
* Author: Tejbir Singh 
* Created Date : 22nd Oct 2018
*/

@isTest
public class AccountlinkhelperFMTest {
    public static id contacttocontactid = RecordTypeAccessService.getRecordTypeId('Account_Link__c', 'Contact2Contact'); //Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
    public static id personaccountid = RecordTypeAccessService.getRecordTypeId('Account', 'Person Account');
    Private static String dealerType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
    public static User user_Obj; 
    static testMethod void testAccAssignment() {
    
        Trigger__C accLinktrigger=new Trigger__C(name='TriggerAccountLinkVN',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='VN',Trigger_Handler__c='TriggerAccountlinkHandlerFM',Trigger_Name__c='TriggerAccountLink',update__c=true);
        insert accLinktrigger;
        
        Profile p1 = [select id, name from profile where Name='System Administrator' limit 1];
        User user1 = TestUtils.createFMUser('VN');
        user1.ProfileId=p1.Id;
        insert user1;
        String market='VN';
        Id accPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account');
        Id accCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Company');
        Id C2C_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
        
        System.runAs (user1) {
            test.starttest(); 
            Account Acc = TestUtils.createPersonAccountAsUserAsOwner(user1);
            list<Account> list2=new list<Account>();
            list2.add(Acc);
            Account acc2 = TestUtils.createCompanyAccount(user1);
            list<Account> list3=new list<Account>();
            list3.add(acc2);
            Account_Link__c acclnk = new Account_Link__c(Name = 'Test',role__c='Parent',role2__c='Child',ToRole__c = Acc.Id, fromRole__c = acc2.id, ReCordTypeId = C2C_RecordTypeId);
            insert acclnk; 
            Account dealer = new Account(Dealer_Rollout_Status__c = 'Done',Market__c = 'VN', Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c = 'MY', Individual_Home_Phone__c = '+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer', Dealer_GC_Code__c = '123456', Dealer_nd_Code__C = '12345');
        	insert dealer;
            Account_link__c accLinkCompany= new Account_Link__c(Name = 'new al', Md__c = 'VN',Market__c = 'VN', Retail_Foundation_Month__c='5', toRole__c = acc.id, fromrole__c = dealer.id, Retail_LastName__c = 'heii', Retail_Full_Name__c = 'dhanu', Retail_Full_Name_Title__c = 'Mrs', Retail_FirstName__c = 'Saru',
                                    RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId(), Retail_DMS_Customer_ID__c = '1122', Retail_Gender__c = 'Female');
            insert accLinkCompany;
            Map<id,sobject> aclist= new Map<id,sobject>(); 
            List<Account_Link__c> acclinklist = new List<Account_Link__c>();
            acclinklist.add(acclnk);
            
            aclist.put(acclnk.id,acclnk);
            AccountlinkhelperFM fm= new AccountlinkhelperFM();
            fm.ValidateC2CAfterUpdateInsert(acclinklist,user1.Market__c,false,true,aclist);
            test.stopTest();
    
    }
   }
   
    static testMethod void testAccLinkIntegrationSection() {
        Trigger__C accLinktrigger=new Trigger__C(name='TriggerAccountLinkVN',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='VN',Trigger_Handler__c='TriggerAccountlinkHandlerFM',Trigger_Name__c='TriggerAccountLink',update__c=true);
        List<Trigger__c> lsttrg = new List<Trigger__C>();
        lsttrg.add(accLinktrigger);
        insert lsttrg;
        
    	user_Obj = TestUtils.IntegrationAPIUser();
        system.runAs(user_Obj) {
        List < Account > acc = new List < Account > ();
        acc.add(new Account(Md__c = 'VN',Market__c = 'VN', UCID__c = '989898989', RecordTypeId = personaccountid, LastName = 'Mercedez', Allow_Data_Sharing__c = 'Yes', Phone = '09874760605', Individual_Home_Phone__c = '+66-9885857857',StouchUniqueId__c ='1234567890'));
        acc.add(new Account(Md__c = 'VN',Market__c = 'VN', RecordTypeId = personaccountid, LastName = 'Mercedez', Allow_Data_Sharing__c = 'Yes', Phone = '09874760605', Individual_Home_Phone__c = '+66-9885857857',StouchUniqueId__c ='1234567891'));
        insert acc;
       
        Account dealer = new Account(Dealer_Rollout_Status__c = 'Done',Market__c = 'VN', Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c = 'MY', Individual_Home_Phone__c = '+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer', Dealer_GC_Code__c = '123456', Dealer_nd_Code__C = '12345');
        insert dealer;
           
        List < Address__c > address = new List < Address__C > ();
        address.add(new Address__c(Address_Type__c = 'Home', Market__c = 'VN', Province__c = 'Shanghai', City__c = 'bangalore', District__c = 'test2', Block__c = 'test3', Customer__c = acc[0].id, Address_Line_1__c = 'testaddress1', Address_Line_2__c = 'testaddress2', ZipCode__c = '32703', TitleOfHonor__c = 'To Person', preferred__c = True, Opt_In_Hardcopy__c = True, MD__c = 'VN'));
        address.add(new Address__c(Address_Type__c = 'Home', Market__c = 'VN', Province__c = 'Shanghai', City__c = 'bangalore', District__c = 'test2', Block__c = 'test3', Customer__c = acc[0].id, Address_Line_1__c = 'testaddress1', Address_Line_2__c = 'testaddress2', ZipCode__c = '32703', TitleOfHonor__c = 'To Person', preferred__c = True, Opt_In_Hardcopy__c = True, MD__c = 'VN'));
        insert address;
        
        List<Account_Link__c> acclinklist = new List<Account_Link__c>();
       
            TriggerUtil.userCreate = false;
            acclinklist.add(new Account_Link__c(Retail_Address_Reference__c = address[0].id, Name = 'new al', Md__c = 'VN',Market__c = 'VN',  toRole__c = acc[0].id, fromrole__c = dealer.id, Retail_LastName__c = 'heii', Retail_Full_Name__c = 'dhanu', Retail_Full_Name_Title__c = 'Mrs', Retail_FirstName__c = 'Saru',
                                    RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(), Retail_DMS_Customer_ID__c = '1122', Retail_Gender__c = 'Female'));
            insert acclinklist;
            
            Account_Link__c acclink = new Account_Link__c();
            acclink.Retail_Race__c = 'Thai';
            acclink.Id = acclinklist[0].id;
            acclink.Market__c = 'VN';
            acclink.Md__c = 'VN';
            system.debug('@@@TriggerRecursiveCheck@@'+TriggerRecursiveCheck.run2);
            TriggerRecursiveCheck.run = true;
            system.debug('@@@TriggerRecursiveCheck22222@@'+TriggerRecursiveCheck.run2);
            update acclink;
        }
    }      
  
}