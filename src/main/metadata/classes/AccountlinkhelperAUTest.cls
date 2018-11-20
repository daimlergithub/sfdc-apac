@isTest
public class AccountlinkhelperAUTest {
    
    
    static testMethod void testAccAssignment() {
    
        Trigger__C casetrigger=new Trigger__C(name='TriggerAccountLink',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='AU',Trigger_Handler__c='TriggerAccountlinkHandlerAU',Trigger_Name__c='TriggerAccountLink',update__c=true);
        insert casetrigger;
        
           Profile p = [select id from profile where Name='System Administrator' limit 1];
        User user1 = new User(LastName='User',country='Australia',firstName='BCI',ProfileId=p.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='adminuser01@testing.com',UserName='admusr@daimler.com'+String.valueof(DateTime.now().getTime()),Market__c = 'AU');
        insert user1;
        String market='AU';
        Id accPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account');
        Id accCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Company');
        Id C2C_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
        
        System.runAs (user1) {
            test.starttest(); 
            
			
			              Account Acc = new Account(FirstName = user1.FirstName,LastName = user1.LastName);
        Acc.Dealer_Default_Flag__c   = false;
        Acc.Dealer_DMS_SR_Code__c    = 'test code 2';
        Acc.Home_Phone_2__c          = '02202123626';
        Acc.Work_Phone__c            = '+6612123799';
        Acc.Status__c                = 'NoCustomer';
        Acc.Email__c                 = 'testmail@test.com';
        Acc.Email2__c                = 'teemail2@test.com';
        Acc.Email3__c                = 'temail3@test.com';
        Acc.City__c                  = 'Beijing';
        Acc.Gender__c                = 'Male';
        Acc.Individual_Home_Phone__c = '+6328748569';
        Acc.Area_code__c             = '0101';
        Acc.MD__c                    = user1.market__c;  // Modified by Laqshay Arora
        Acc.Market__c                = user1.market__c;  // Modified by Hildaa
        Acc.Postal_Opt_Out__c        = True;
        Acc.Province__c              = 'Shanghai';
        Acc.ZipCode__c               = '3203';
        Acc.Primary_Email__c         = 'Email1';
        Acc.Primary_Fax__c           = 'FAX2';
        Acc.Primary_Phone__c         = 'Other2';
        Acc.PersonDoNotCall          = True;
        Acc.ownerid                  = user1.id;
        Acc.PersonHasOptedOutOfEmail = true;
        Acc.Opt_In_Email__c          = true;
        Acc.ID_Number__c             = '1234567891011';   // Added by Laqshay Arora
        Acc.ID_Type__c = 'National ID';
        Acc.PersonBirthdate          = date.newInstance(1991,03,18); // Modified By laqshay Arora
        Acc.Foundation_Date__c       = date.today();
        Acc.RecordTypeId             = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        insert Acc;
			
			
            Acc.Market__C= 'AU';
            list<Account> list2=new list<Account>();
            list2.add(Acc);

			
			           account acc2 = new account(FirstName = user1.FirstName,LastName = user1.LastName);
        acc2.Dealer_Default_Flag__c   = false;
        acc2.Dealer_DMS_SR_Code__c    = 'test code 2';
        acc2.Home_Phone_2__c          = '02202123626';
        acc2.Work_Phone__c            = '+6612123799';
        acc2.Status__c                = 'NoCustomer';
        acc2.Email__c                 = 'testmail@test.com';
        acc2.Email2__c                = 'teemail2@test.com';
        acc2.Email3__c                = 'temail3@test.com';
        acc2.City__c                  = 'Beijing';
        acc2.Gender__c                = 'Male';
        acc2.Individual_Home_Phone__c = '+6328748569';
        acc2.Area_code__c             = '0101';
        acc2.MD__c                    = user1.market__c;  // Modified by Laqshay Arora
        acc2.Market__c                = user1.market__c;  // Modified by Hildaa
        acc2.Postal_Opt_Out__c        = True;
        acc2.Province__c              = 'Shanghai';
        acc2.ZipCode__c               = '3203';
        acc2.Primary_Email__c         = 'Email1';
        acc2.Primary_Fax__c           = 'FAX2';
        acc2.Primary_Phone__c         = 'Other2';
        acc2.PersonDoNotCall          = True;
        acc2.ownerid                  = user1.id;
        acc2.PersonHasOptedOutOfEmail = true;
        acc2.Opt_In_Email__c          = true;
        acc2.ID_Number__c             = '1234567891011';   // Added by Laqshay Arora
        acc2.ID_Type__c = 'National ID';
        acc2.PersonBirthdate          = date.newInstance(1991,03,18); // Modified By laqshay Arora
        acc2.Foundation_Date__c       = date.today();
        acc2.RecordTypeId             = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        insert acc2; 
			
            acc2.Market__C= 'AU';
            list<Account> list3=new list<Account>();
            list3.add(acc2);
            Account_Link__c acclnk = new Account_Link__c(Name = 'Test', ToRole__c = Acc.Id, fromRole__c = acc2.id, ReCordTypeId = C2C_RecordTypeId);
            insert acclnk; 
            Map<id,sobject> aclist= new Map<id,sobject>(); 
            Map<id,Account_Link__c> acMapList = new Map<id,Account_Link__c>();
            Map<id,Account_Link__c> acMap = new Map<id,Account_Link__c>();
            List<Account_Link__c> acclinklist = new List<Account_Link__c>();
            acclinklist.add(acclnk);
            aclist.put(acclnk.id,acclnk);
            acMapList.put(acclnk.id,acclnk);
                        
            AccountlinkhelperAU my= new AccountlinkhelperAU();
          // my.RevokeApexSharingAfterUpdate(acclinklist,acMapList, acclinklist);
			 my.ValidateC2CAfterUpdateInsert(acclinklist,Label.AU,false,true,aclist);
             my.addressupdateRT(acclinklist,acMapList);
			 my.InvokeCDMAccountlinkContaxt(acclinklist,Label.AU,'Context');
             my.afterInsertEventShareRetailCopy(acclinklist);
             my.afterInsertEventShareAccount(acclinklist);
			 my.RemoveAccessofUsers(acclinklist);

            test.stopTest();
    
    }
   }
}