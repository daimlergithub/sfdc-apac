@isTest
public class TestRelatedDealerLease{

public static testmethod void testinit(){

String DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
//Id leaserecordtypeid= Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Lease Contract').getRecordTypeId();

Profile p1 = [select id,name from profile where name='Japan CRM'];
        User u = new User(alias = 'test123', email='test123@noemail.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p1.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='test123@noemail.com');
        insert u;
Account a=new Account();
a.name='vineet';
a.RecordTypeId=DealerAccRecordTypeId;
a.Dealer_GC_Code__c='123';
insert a; 
Retail_Task__c rt=new Retail_Task__c();
rt.Account__c=a.id; 

rt.Related_Dealer__c=a.id;
RT.Supporting_Dealer__c=a.id; 
rt.Name='test retail dealer';
insert rt;
Retail_Task__c ret=[select id,name from Retail_Task__c  where id=:rt.id ];
ApexPages.StandardController std=new ApexPages.StandardController(ret); 
RelatedDealerLease rdl=new RelatedDealerLease(std);
 user ur=rdl.currentuser;
 List<Retail_Task__c> retlst=rdl.rettsk;
 List<profile> profilenames=rdl.japanprofiles;
 

 
 system.assertEquals(17,profilenames.size());

}

}