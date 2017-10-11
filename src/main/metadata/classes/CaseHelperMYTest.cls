/**
* Test class for CaseHelperMY
* Author:Sushma Bharti
* Created Date : 9th Oct 2017
*/


//SB2017
@istest
public class CaseHelperMYTest {

 //SB2017
    /*
      Name:Sushma Bharti
      Description:Added to setup test data for MY
      Modified Date: 2017-09-13
  */
  
    @testSetup
    static void setupTestData(){    
    List<String> AccountFields=new List<String>();
    AccountFields.add('Lastname');
    AccountFields.add('Individual_Home_Phone__c');
    AccountFields.add('Work_Phone__c');
    AccountFields.add('fax');
    AccountFields.add('Mobile__c');
    AccountFields.add('MD__c');
    List<Account> AccountFieldsList=DataFactoryServices.createRecords('Account',AccountFields,'',1);
    AccountFieldsList[0].RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    AccountFieldsList[0].Lastname='Lastname1';
    AccountFieldsList[0].Individual_Home_Phone__c='+6003123654789';
    AccountFieldsList[0].Work_Phone__c='+60825634789541';
    AccountFieldsList[0].fax='+60827896541';
    AccountFieldsList[0].Mobile__c='+609856321478';
    AccountFieldsList[0].MD__c='MY';
    insert AccountFieldsList;
    List<String> CaseFields=new List<String>();
    CaseFields.add('Status');
    CaseFields.add('Case_RepeatCause__c');
    CaseFields.add('accountid');
    CaseFields.add('Recordtypeid');   
    CaseFields.add('MD__c');
    CaseFields.add('priority');
    List<Case> CaseFieldsList=DataFactoryServices.createRecords('Case',CaseFields,'',2);
    CaseFieldsList[0].RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Inquiry').getRecordTypeId();
    CaseFieldsList[0].accountid=AccountFieldsList[0].id;
    CaseFieldsList[0].MD__c='MY';
    CaseFieldsList[0].status='Open';
    CaseFieldsList[0].Case_RepeatCause__c='';
    CaseFieldsList[0].priority='A';
    CaseFieldsList[1].RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
    CaseFieldsList[1].accountid=AccountFieldsList[0].id;
    CaseFieldsList[1].MD__c='MY';
    CaseFieldsList[1].status='Open';
    CaseFieldsList[1].Case_RepeatCause__c='';
    CaseFieldsList[1].priority='Green <= 2';
    insert CaseFieldsList;
    }
    
    //SB2017
    /*
      Name:Sushma Bharti
      Description:Added to update the code coverage of the method for MY
      Modified Date: 2017-10-09
  */
    static testmethod void testCaseHelperMY1(){
     List<Case> CaseList  =  [SELECT RecordTypeid,accountid,parentid,status,Case_RepeatCause__c,priority,MD__c from Case];
     CaseHelperMY ch = new CaseHelperMY();
     ch.updateCaseDeadLineAmount(caselist,'MY',null);
     ch.calculateComplaintAmount(caselist,'MY');
     ch.countRepeatComplaintCase(caselist,true,'MY');
     List<Case> childCaseList=new List<Case>();
     Case child=new Case();
     child.parentid=caselist[1].id;
     child.MD__c='MY';
     child.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
     child.Case_RepeatCause__c='2=Others';
     childCaseList.add(child);
     insert childCaseList;
     List<Case> childCaseList1=[SELECT recordtypeid,parentid,Case_RepeatCause__c,MD__c from Case];
     ch.countRepeatComplaintCase(childCaseList1,true,'MY');
    }
}