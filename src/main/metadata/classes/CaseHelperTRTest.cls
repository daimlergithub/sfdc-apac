/**
* Test class for CaseHelperTR
* Author:Hildaa

*/


@istest
public class CaseHelperTRTest {
    
    @testSetup
    static void setupTestData(){    
        
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        
        User user1 = new User(LastName='User'+System.Today(),Market__c='TR',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01'+String.valueof(DateTime.now().getTime()));
        insert user1;
        System.runAs (user1) {  
            List<String> AccountFields=new List<String>();
            AccountFields.add('Lastname');
            AccountFields.add('firstname');
            AccountFields.add('Individual_Home_Phone__c');
            AccountFields.add('Work_Phone__c');
            AccountFields.add('fax');
            AccountFields.add('Mobile__c');
            AccountFields.add('MD__c');
            AccountFields.add('Data_Source__c');
            AccountFields.add('Market__c');
            List<Account> AccountFieldsList=DataFactoryServices.createRecords('Account',AccountFields,'',1);
            AccountFieldsList[0].RecordTypeId=RecordTypeAccessService.getRecordTypeId('Account',Label.PersonAccount);
            AccountFieldsList[0].Lastname='Lastname1';
            AccountFieldsList[0].Firstname='Lastname1';
            AccountFieldsList[0].Individual_Home_Phone__c='+6003123654789';
            AccountFieldsList[0].Work_Phone__c='+60825634789541';
            AccountFieldsList[0].fax='+60827896541';
            AccountFieldsList[0].Mobile__c='+609856321478';
            AccountFieldsList[0].MD__c='TR';
            AccountFieldsList[0].Data_Source__c='MBT Event';
            AccountFieldsList[0].Market__C='TR';
            insert AccountFieldsList;
            Account acc2 = TestUtils.createCompanyAccount(user1);
            contact ct = new contact();
            ct.lastname ='last name';
            ct.accountid = acc2.Id;
            ct.market__c='TR';
            insert ct;
            List<String> CaseFields=new List<String>();
            CaseFields.add('Status');
            CaseFields.add('Case_RepeatCause__c');
            CaseFields.add('accountid');
            CaseFields.add('Recordtypeid');   
            CaseFields.add('Market__c');
            CaseFields.add('priority');
            List<Case> CaseFieldsList=DataFactoryServices.createRecords('Case',CaseFields,'',2);
            CaseFieldsList[0].RecordTypeId=RecordTypeAccessService.getRecordTypeId('Case',Label.Inquiry);
            CaseFieldsList[0].accountid=AccountFieldsList[0].id;
            CaseFieldsList[0].Market__c='TR';
            CaseFieldsList[0].status='Open';
            CaseFieldsList[0].Case_RepeatCause__c='';
            CaseFieldsList[0].priority='A';
            CaseFieldsList[0].AccountId = acc2.Id;
            CaseFieldsList[0].contactId = ct.id;
            CaseFieldsList[0].subject ='case 1 ';
            CaseFieldsList[0].case_class__c = 'Satisfaction';
            CaseFieldsList[0].Case_Type__c = 'PRODUCT';
            CaseFieldsList[0].Case_SubType__c = 'Brake';
            CaseFieldsList[0].Case_Sub_Type_Detail__c ='ABS';
            
            CaseFieldsList[1].RecordTypeId=RecordTypeAccessService.getRecordTypeId('Case',Label.MB_Complaint);
            CaseFieldsList[1].accountid=AccountFieldsList[0].id;
            CaseFieldsList[1].Market__c='TR';
            CaseFieldsList[1].status='Open';
            CaseFieldsList[1].Case_RepeatCause__c='';
            CaseFieldsList[1].priority='Green <= 2';
            CaseFieldsList[1].AccountId = acc2.Id;
            CaseFieldsList[1].contactId = ct.id;
            CaseFieldsList[1].subject ='case 1 ';
            CaseFieldsList[1].case_class__c = 'Satisfaction';
            CaseFieldsList[1].Case_Type__c = 'PRODUCT';
            CaseFieldsList[1].Case_SubType__c = 'Brake';
            CaseFieldsList[1].Case_Sub_Type_Detail__c ='ABS';
            insert CaseFieldsList;
        }
    }
    
    static testmethod void testCaseHelperTR1(){
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        
        User user2 = new User(LastName='User2'+System.Today(),Market__c='TR',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='user2@infosys.com',UserName='user2@infosys.com'+String.valueof(DateTime.now().getTime()));
        insert user2;
        System.runAs (user2) {   
            test.startTest();
            Account acc2 = TestUtils.createCompanyAccount(user2);
            contact ct = new contact();
            ct.lastname ='last name';
            ct.accountid = acc2.Id;
            ct.market__c='TR';
            insert ct;
            List<Case> CaseList  =  [SELECT RecordTypeid,accountid,parentid,status,Case_RepeatCause__c,priority,Market__c, MD__c from Case];
            CaseHelperTR ch = new CaseHelperTR();
            ch.updateCaseDeadLineAmount(caselist,'TR',null);
            //ch.calculateComplaintAmount(caselist,'MY');
            ch.countRepeatComplaintCase(caselist,true,'TR');
            List<Case> childCaseList=new List<Case>();
            Case child=new Case();
            child.parentid=caselist[1].id;
            child.Market__c='TR';
            child.recordtypeid=RecordTypeAccessService.getRecordTypeId('Case',Label.MB_Complaint);
            child.Case_RepeatCause__c='2=Others';
            child.AccountId = acc2.Id;
            child.contactId = ct.id;
            child.subject ='case 1 ';
            child.case_class__c = 'Satisfaction';
            child.Case_Type__c = 'PRODUCT';
            child.Case_SubType__c = 'Brake';
            child.Case_Sub_Type_Detail__c ='ABS';
            childCaseList.add(child);
            insert childCaseList;
            List<Case> childCaseList1=[SELECT recordtypeid,parentid,Case_RepeatCause__c,Market__c from Case];
            //ch.calculateComplaintAmount(childCaseList1,'TR');
            ch.countRepeatComplaintCase(childCaseList1,true,'TR');
            
            test.stopTest();
        }
    }
}