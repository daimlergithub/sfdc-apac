@isTest
public with sharing class caseHelperTHTest{
final static String MBRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
final static Id caseINquiryId = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.INQUIRY);
public List<Id> tmpCaseIds = new List<Id>();
public List<Account> updateAccount = new List<Account>();
public Map<Id, List<Id>> accountCaseMap = new Map<Id, List<Id>>();
public static Account personAcc;
public static Account dealerAccount;
public static Account dealerAccount2;
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
   List<Account> accLst=new List<Account>();     
   personAcc = new Account(Dealer_Default_Flag__c=false,
                           Dealer_DMS_SR_Code__c='test code 2',
                           Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                           City__c='Beijing',
                           Gender__c = 'Male',
                           Phone = '0801801110',
                           Area_code__c = '0101',
                           MD__c = 'TH',
                           LastName = 'galaxy11',
                           FirstName = 'First Name1',
                           Salutation = 'Unknown1',      
                           Province__c = 'Shanghai',
                           ZipCode__c= '12347',
                           Dealer_nd_code__c='465798',
                           Mobile2__c = '035456232678',
                           Primary_Email__c = 'Email1',
                           Primary_Fax__c = 'FAX2',
                           Primary_Phone__c ='Other2',
                           RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
                           
        
		accLst.add(personAcc);
		dealerAccount =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='TH', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId(), Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='1235');
     
    accLst.add(dealerAccount);
    dealerAccount2 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode',Md__c='TH', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId(), Name = 'test dealer1',Dealer_GC_Code__c = 'Test123',Dealer_nd_Code__C='123565');
      
     accLst.add(dealerAccount2);
    insert accLst;
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
    List<String> alpha=new list<String>{'A','B','C','D','E'};
        for(String s:alpha){
            Case c4 = new Case();
            c4.Subject='testing';
            c4.accountid=personAcc.id;
            c4.Recordtypeid=caseINquiryId ;
            c4.MD__c='TH';
            c4.Priority=s;
            insert c4;
			caselist.add(c4);            
        }



    CaseHelperTH cht = new CaseHelperTH();
    cht.calculateComplaintAmount(caselist);
    cht.countRepeatComplaintCase(caselist,true);
    cht.updateCaseDeadLineAmount(caselist);      
         system.assertequals([select id from case where id=:c1.id].size(),1);
         delete c1;
         system.assertequals([select id from case where id=:c1.id].size(),0);
         undelete c1;
         system.assertequals([select id from case where id=:c1.id].size(),1);

}
    static testMethod void ShareRecordswithDealers_Test()
    {
        init();
        Test.startTest();
        
        List<Group> groupLst=new List<Group>();
        groupLst.add(new Group(Name='123565'));
        insert groupLst;
        
        Case testCaseObj = new Case();
         testCaseObj.Subject='testing';
         testCaseObj.accountid=personAcc.id;
        testCaseObj.Recordtypeid=MBRecordtypeid ;
         testCaseObj.MD__c='TH';
        testCaseObj.Case_Dealer__c=dealerAccount.Id;
         insert testCaseObj;
        
        testCaseObj.Case_Dealer__c=null;
        update testCaseObj;
        
        testCaseObj.Case_Dealer__c=dealerAccount2.Id;
        update testCaseObj;
        
        testCaseObj.Case_Dealer__c=dealerAccount.Id;
        update testCaseObj;
        
        Test.stopTest();
    }
}