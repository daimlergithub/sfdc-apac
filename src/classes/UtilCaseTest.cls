@isTest
public class UtilCaseTest {
  public static Account accobj;
  public static Case Caseobj;
  public static Case Caseobjcatch;
  public static List<Case> caselist;
  public static List<Case> catchcase;
  public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
  public static Id MBRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
  
   static void createTestData() {
    accobj = new Account();
    accobj.RecordTypeId = personAccRecordTypeId;
    accobj.LastName = 'galaxy1';
    accobj.ZipCode__c= '1002347';
    accobj.MBK_Data_Source__c='Email';
    //accobj.Mobile__c = '000-0000-9642';
    insert accobj;  
    accobj = new Account();
    accobj.RecordTypeId = personAccRecordTypeId;
    accobj.LastName = 'galaxy1';
    accobj.ZipCode__c= '1002347';
    accobj.MBK_Data_Source__c='Email';
    //accobj.Mobile__c = '000-0000-9842';
    insert accobj; 
    
    Caseobj = new Case();
    Caseobj.RecordTypeId = MBRecordTypeId;
    Caseobj.Case_Department__c = 'testcase';
    Caseobj.Description = 'testdes';
    Caseobj.Case_Type__c = 'testcasetype';
    Caseobj.Case_SubType__c = 'test case subtype';
    Caseobj.Case_Source__c = 'test case source';
    Caseobj.Accountid = accobj.id;
    //insert Caseobj;
    system.debug('$$$$$$$$$$$$$$$$$'+Caseobj);
    system.debug('$$$$$$$$$$$$$$$$$'+accobj.id);
    
    Caseobjcatch = new Case();
    Caseobjcatch.RecordTypeId = MBRecordTypeId;
    Caseobjcatch.Case_Department__c = 'testcase';
    Caseobjcatch.Description = 'testdes';
    Caseobjcatch.Case_Type__c = 'testcasetype';
    Caseobjcatch.Case_SubType__c = 'test case subtype';
    Caseobjcatch.Case_Source__c = 'test case source';
    
    caselist = new list<case>();
    caselist.add(Caseobj);
    insert caselist;
    system.debug('$$$$$$$$$$$$$$$$$'+caselist);
    catchcase = new list<case>();
    catchcase.add(Caseobjcatch);
    update accobj;
  }    
  
  static void createTestData1() {
  /*Account accobj1 = new Account();
  accobj.RecordTypeId = personAccRecordTypeId;
    accobj.LastName = 'galaxy2';
    accobj.ZipCode__c= '1002454';
    accobj.MBK_Data_Source__c='Email1';
    accobj.Mobile__c = '000-0000-9632';
    insert accobj1;  */
    delete  accobj;
  }  
  
  public static testmethod void rollupAccountComplaintTest() {
  createTestData();
 // createTestData1();
      test.startTest();
        UtilCase.rollupAccountComplaintAmount(caselist);
      test.stopTest();
    try 
    {
      UtilCase.rollupAccountComplaintAmount(caselist);
    }
    catch(DMLException e)
    {
    Delete accobj;
    }
     
  }
}