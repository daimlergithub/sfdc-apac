@isTest
public with sharing class caseHelperTHTest{
final static String MBRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
public List<Id> tmpCaseIds = new List<Id>();
public List<Account> updateAccount = new List<Account>();
public Map<Id, List<Id>> accountCaseMap = new Map<Id, List<Id>>();
public static Account personAcc  ;
static void init( ){
Trigger__C casetrigger=new Trigger__C(name='TriggerCaseTH',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='CaseTriggerHandlerTH',Trigger_Name__c='CaseTrigger',update__c=true);
insert casetrigger;
User runUser = [select Id from User Where Id =: UserInfo.getUserId()];
        User usr=new User();
        System.runAs ( runUser ) {               
                usr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';
                usr.ProfileId=UtilTestData.getProfileId('CAC Data Manager');
                usr.UserRoleId=UtilTestData.getUserRoleId('Dealer User');
                usr.LastName = 'TestCreateUser';
                usr.Email = 'test001@daimler.com.full';
                usr.Alias = 'test1';
                usr.TimeZoneSidKey = 'Asia/Shanghai';
                usr.EmailEncodingKey = 'UTF-8';
                usr.LanguageLocaleKey = 'en_US';
                usr.localesidkey='en_US';
                usr.isActive = true;
                Database.insert(usr); 
               
        }
        
   personAcc = new Account(Dealer_Default_Flag__c=false,
                           Dealer_DMS_SR_Code__c='test code 2',
                           Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                           City__c='Beijing',
                           Gender__c = 'Male',
                           Phone = '0801801110',
                           Area_code__c = '0101',
                           MD__c = 'TH',
                           LastName = 'galaxy1',
                           FirstName = 'First Name',
                           Salutation = 'Unknown',      
                           Province__c = 'Shanghai',
                           ZipCode__c= '12347',
                           
                           Mobile2__c = '035456232678',
                           Primary_Email__c = 'Email1',
                           Primary_Fax__c = 'FAX2',
                           Primary_Phone__c ='Other2',
                           RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
                           insert personAcc;
        


}
@isTest
public static void calculateCaseAmountTest(){
init();
 List<case> caselist = new List<case>();
 		
    	Case c1 = new Case();
         c1.Subject='testing';
         c1.accountid=personAcc.id;
        c1.Recordtypeid=MBRecordtypeid ;
         c1.MD__c='TH';
         insert c1;
    	
         
         Case c3 = new Case();
         c3.Subject='testing';
        c3.parentId=c1.id;
        c3.Case_RepeatCause__c='2=Others';
         c3.accountid=personAcc.id;
        c3.Recordtypeid=MBRecordtypeid ;
         c3.MD__c='TH';
         
        insert c3;
         Case c2 = new Case();
          c2.Subject='testing';
         c2.accountid=personAcc.id;
        c2.Recordtypeid=MBRecordtypeid ;
         c2.MD__c='KR';
         insert c2;
         caselist.add(c1);
    	caselist.add(c2);
    	caselist.add(c3);
    CaseHelperTH cht = new CaseHelperTH();
    cht.calculateComplaintAmount(caselist);
    cht.countRepeatComplaintCase(caselist,true);
          
         system.assertequals([select id from case where id=:c1.id].size(),1);
         delete c1;
         system.assertequals([select id from case where id=:c1.id].size(),0);
         undelete c1;
         system.assertequals([select id from case where id=:c1.id].size(),1);

}
}