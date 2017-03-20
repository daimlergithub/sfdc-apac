@isTest
public class TestRelatedDealerLease{

public static testmethod void testinit(){

String DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
 
String leaseRecordTypeId = Schema.SObjectType.Retail_Task__c .getRecordTypeInfosByName().get('Lease Contract').getRecordTypeId();


Profile p1 = [select id,name from profile where name='Japan CRM'];
        User u = new User(alias = 'test123', email='test123@noemail.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p1.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='test123@noemail.com');
        insert u;
 
Account DealerAccount= new Account();
DealerAccount.RecordtypeId=DealerAccRecordTypeId;
DealerAccount.Name='Test Person 1st';
DealerAccount.Type='Personal';
DealerAccount.Dealer_GC_Code__c='123';
DealerAccount.Status__c='Active';
DealerAccount.Province__c='Province1';
DealerAccount.City__c='Test';
DealerAccount.Email__c='test@mbj.com';
insert DealerAccount;
Retail_Task__c rt=new Retail_Task__c();
rt.Account__c=DealerAccount.id; 
rt.recordtypeId=leaseRecordTypeId ;
rt.type__c='lease';
rt.Related_Dealer__c=dealerAccount.id;
rt.Supporting_Dealer__c=dealerAccount.id; 
rt.Name='test retail dealer';
rt.MD__c = 'JP';
insert rt;
system.assertequals('Japan CRM' , p1.name  );
Retail_Task__c ret=[select id,name,Related_Dealer__r.Dealer_GC_Code__c,Supporting_Dealer__r.Dealer_GC_Code__c from Retail_Task__c  where id=:rt.id ];

Account acc=[select id,Name, Dealer_GC_Code__c from Account where id=:DealerAccount.id];
id recid=ApexPages.CurrentPage().getparameters().put('Id',rt.id);
string dealercode=ret.Related_Dealer__r.Dealer_GC_Code__c;
string suppdealer=ret.Supporting_Dealer__r.Dealer_GC_Code__c;
Retail_Task__c rettsk=[select id,name,Related_Dealer__r.Dealer_GC_Code__c,Supporting_Dealer__r.Dealer_GC_Code__c from Retail_Task__c where Related_Dealer__r.Dealer_GC_Code__c=:dealercode  And Supporting_Dealer__r.Dealer_GC_Code__c=:suppdealer AND id=:ret.id ]; 
ApexPages.StandardController std=new ApexPages.StandardController(rettsk); 
RelatedDealerLease rdl=new RelatedDealerLease(std);
 //user ur=rdl.currentuser;
// List<Retail_Task__c> retlst1=rdl.rettsk;
// List<profile> profilenames=rdl.japanprofiles;
// system.assertEquals(8,profilenames.size());

}

}