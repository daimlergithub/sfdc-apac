/**
* Test class for AccountLink Helper class for MY(Malayasia)
* Author: Pratyasha Mishra 
* Created Date : 2017-01-04
*/

@isTest
public class AccountlinkhelperMYTest {
    public static id contacttocontactid = RecordTypeAccessService.getRecordTypeId('Account_Link__c', 'Contact2Contact'); //Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
    public static id personaccountid = RecordTypeAccessService.getRecordTypeId('Account', 'Person Account');
    Private static String dealerType = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
    public static User user_Obj; 
    static testMethod void testAccAssignment() {
    
        Trigger__C casetrigger=new Trigger__C(name='TriggerAccountLink',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='MY',Trigger_Handler__c='TriggerAccountlinkHandlerMY',Trigger_Name__c='TriggerAccountLink',update__c=true);
        insert casetrigger;
        
        User user1 = TestUtils.createMYAdminUser();
        String market='MY';
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
            Account_Link__c acclnk = new Account_Link__c(Name = 'Test', ToRole__c = Acc.Id, fromRole__c = acc2.id, ReCordTypeId = C2C_RecordTypeId);
            insert acclnk; 
            Map<id,sobject> aclist= new Map<id,sobject>(); 
            List<Account_Link__c> acclinklist = new List<Account_Link__c>();
            acclinklist.add(acclnk);
            
            aclist.put(acclnk.id,acclnk);
            AccountlinkhelperMY my= new AccountlinkhelperMY();
            my.ValidateC2CAfterUpdateInsert(acclinklist,Label.MY,false,true,aclist);
            test.stopTest();
    
    }
   }
   
    static testMethod void testAccLinkIntegrationSection() {
        Trigger__c TriggerAccountLinkMY =new Trigger__c(Name='TriggerAccountLink',Trigger_Name__c='TriggerAccountLink',Trigger_Handler__c='TriggerAccountlinkHandlerMY',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='MY');
        List<Trigger__c> lsttrg = new List<Trigger__C>();
        lsttrg.add(TriggerAccountLinkMY);
        insert lsttrg;
        
    	user_Obj = TestUtils.IntegrationAPIUser();
        system.runAs(user_Obj) {
        List < Account > acc = new List < Account > ();
        acc.add(new Account(Md__c = 'MY',Market__c = 'MY', UCID__c = '989898989', RecordTypeId = personaccountid, LastName = 'Mercedez', Allow_Data_Sharing__c = 'Yes', Phone = '09874760605', Individual_Home_Phone__c = '+66-9885857857',StouchUniqueId__c ='1234567890'));
        acc.add(new Account(Md__c = 'MY',Market__c = 'MY', RecordTypeId = personaccountid, LastName = 'Mercedez', Allow_Data_Sharing__c = 'Yes', Phone = '09874760605', Individual_Home_Phone__c = '+66-9885857857',StouchUniqueId__c ='1234567891'));
        insert acc;
       
        Account dealer = new Account(Dealer_Rollout_Status__c = 'Done',Market__c = 'MY', Dealer_DMS_CRM_Code__c = 'DealerCode', Md__c = 'MY', Individual_Home_Phone__c = '+66-9885857857', RecordTypeId = dealerType, Name = 'test dealer', Dealer_GC_Code__c = '123456', Dealer_nd_Code__C = '12345');
        insert dealer;
           
        List < Address__c > address = new List < Address__C > ();
        address.add(new Address__c(Address_Type__c = 'Home', Market__c = 'MY', Province__c = 'Shanghai', City__c = 'bangalore', District__c = 'test2', Block__c = 'test3', Customer__c = acc[0].id, Address_Line_1__c = 'testaddress1', Address_Line_2__c = 'testaddress2', ZipCode__c = '32703', TitleOfHonor__c = 'To Person', preferred__c = True, Opt_In_Hardcopy__c = True, MD__c = 'MY'));
        address.add(new Address__c(Address_Type__c = 'Home', Market__c = 'MY', Province__c = 'Shanghai', City__c = 'bangalore', District__c = 'test2', Block__c = 'test3', Customer__c = acc[0].id, Address_Line_1__c = 'testaddress1', Address_Line_2__c = 'testaddress2', ZipCode__c = '32703', TitleOfHonor__c = 'To Person', preferred__c = True, Opt_In_Hardcopy__c = True, MD__c = 'MY'));
        insert address;
        
        List<Account_Link__c> acclinklist = new List<Account_Link__c>();
       
            TriggerUtil.userCreate = false;
            acclinklist.add(new Account_Link__c(Retail_Address_Reference__c = address[0].id, Name = 'new al', Md__c = 'MY',Market__c = 'MY',  toRole__c = acc[0].id, fromrole__c = dealer.id, Retail_LastName__c = 'heii', Retail_Full_Name__c = 'dhanu', Retail_Full_Name_Title__c = 'Mrs', Retail_FirstName__c = 'Saru',
                                    RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId(), Retail_DMS_Customer_ID__c = '1122', Retail_Gender__c = 'Female'));
            insert acclinklist;
            
            Account_Link__c acclink = new Account_Link__c();
            acclink.Retail_Race__c = 'Thai';
            acclink.Id = acclinklist[0].id;
            acclink.Market__c = 'MY';
            acclink.Md__c = 'MY';
            system.debug('@@@TriggerRecursiveCheck@@'+TriggerRecursiveCheck.run2);
            TriggerRecursiveCheck.run = true;
            system.debug('@@@TriggerRecursiveCheck22222@@'+TriggerRecursiveCheck.run2);
            update acclink;
        }
    }      
  
}