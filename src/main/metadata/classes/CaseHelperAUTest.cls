//SB2017
@istest
public class CaseHelperAUTest {

    @testSetup
    static void setupTestData(){    
    
    Profile p1 = [select id from profile where Name='System Administrator' limit 1];
    
    User user1 = new User(LastName='User'+System.Today(),Market__c='AU',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01'+String.valueof(DateTime.now().getTime()));
    insert user1;
   System.runAs (user1) {  
    List<String> AccountFields=new List<String>();
    AccountFields.add('Lastname');
    AccountFields.add('Individual_Home_Phone__c');
    AccountFields.add('Work_Phone__c');
    AccountFields.add('fax');
    AccountFields.add('Mobile__c');
    AccountFields.add('MD__c');
    List<Account> AccountFieldsList=DataFactoryServices.createRecords('Account',AccountFields,'',1);
    AccountFieldsList[0].RecordTypeId=RecordTypeAccessService.getRecordTypeId('Account',Label.PersonAccount);
    AccountFieldsList[0].Lastname='Lastname1';
    AccountFieldsList[0].Individual_Home_Phone__c='+6003123654789';
    AccountFieldsList[0].Work_Phone__c='+60825634789541';
    AccountFieldsList[0].fax='+60827896541';
    AccountFieldsList[0].Mobile__c='+609856321478';
    AccountFieldsList[0].MD__c='AU';
    AccountFieldsList[0].Market__C='AU';
    insert AccountFieldsList;
    List<String> CaseFields=new List<String>();
    CaseFields.add('Status');
    CaseFields.add('Case_RepeatCause__c');
    CaseFields.add('accountid');
    CaseFields.add('Recordtypeid');   
    CaseFields.add('MD__c');
    CaseFields.add('priority');
    List<Case> CaseFieldsList=DataFactoryServices.createRecords('Case',CaseFields,'',2);
    CaseFieldsList[0].RecordTypeId=RecordTypeAccessService.getRecordTypeId('Case',Label.Inquiry);
    CaseFieldsList[0].accountid=AccountFieldsList[0].id;
    CaseFieldsList[0].MD__c='AU';
    CaseFieldsList[0].status='Open';
    CaseFieldsList[0].Case_RepeatCause__c='';
    CaseFieldsList[0].priority='A';
    CaseFieldsList[1].RecordTypeId=RecordTypeAccessService.getRecordTypeId('Case',Label.MB_Complaint);
    CaseFieldsList[1].accountid=AccountFieldsList[0].id;
    CaseFieldsList[1].MD__c='AU';
    CaseFieldsList[1].status='Open';
    CaseFieldsList[1].Case_RepeatCause__c='';
    CaseFieldsList[1].priority='Green <= 2';
    insert CaseFieldsList;
    }
    }
    //SB2017
    /*
      Name:Sushma Bharti
      Description:Added to update the code coverage of the method for MY
      Modified Date: 2017-10-09
  */
    static testmethod void testCaseHelperAU1(){
    Profile p1 = [select id from profile where Name='System Administrator' limit 1];
    
    User user2 = new User(LastName='User2'+System.Today(),Market__c='AU',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='user2@infosys.com',UserName='user2@infosys.com'+String.valueof(DateTime.now().getTime()));
    insert user2;
    System.runAs (user2) {   
     test.startTest();
     List<Case> CaseList  =  [SELECT RecordTypeid,accountid,parentid,status,Case_RepeatCause__c,priority,MD__c from Case];
     CaseHelperAU ch = new CaseHelperAU();
     ch.updateCaseDeadLineAmount(caselist,'AU',null);
     //ch.calculateComplaintAmount(caselist,'AU');
     ch.countRepeatComplaintCase(caselist,true,'AU');
     List<Case> childCaseList=new List<Case>();
     Case child=new Case();
     child.parentid=caselist[1].id;
     child.MD__c='AU';
     child.recordtypeid=RecordTypeAccessService.getRecordTypeId('Case',Label.MB_Complaint);
     child.Case_RepeatCause__c='2=Others';
     childCaseList.add(child);
     insert childCaseList;
     List<Case> childCaseList1=[SELECT recordtypeid,parentid,Case_RepeatCause__c,MD__c from Case];
     ch.countRepeatComplaintCase(childCaseList1,true,'AU');
     test.stopTest();
    }
    }
}