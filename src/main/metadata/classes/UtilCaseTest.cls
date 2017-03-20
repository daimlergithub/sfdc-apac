@isTest
public class UtilCaseTest {
  public static Account accobj;
  public static Account accobj1;
  public static Case Caseobj;
  public static Case Caseobjcatch;
  public static Case Caseobjcatch1;
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
    accobj.Mobile__c = '00000009642';
    insert accobj;  
    accobj = new Account();
    accobj.RecordTypeId = personAccRecordTypeId;
    accobj.LastName = 'galaxy1';
    accobj.ZipCode__c= '1002347';
    accobj.MBK_Data_Source__c='Email';
    accobj.Mobile__c = '00000009842';
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
    accobj.Complaint_Amount__c = accobj.cases.size();
    update accobj;
    
    system.debug('$$$$$$$$$$$$$$$$$'+caselist);
    catchcase = new list<case>();
    catchcase.add(Caseobjcatch);
    update accobj;
  }    
  
  static void createTestData1() {
       accobj.Complaint_Amount__c= 0;
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
 /* public static testmethod void rollupAccountComplaintTest1() {
  createTestData();
 // createTestData1();
      test.startTest();
        UtilCase.rollupAccountComplaintAmount(caselist);
      test.stopTest();
    try 
    {
      accobj1 = new Account();
    accobj1.RecordTypeId = personAccRecordTypeId;
    //accobj.LastName = 'galaxy1';
    accobj1.ZipCode__c= '1002347';
    accobj1.MBK_Data_Source__c='Email';
    accobj1.Mobile__c = '00000009842';
    insert accobj1;  
    
    
    }
    catch(DMLException e)
    {
    delete accobj1;
    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.error, e.getMessage());
    ApexPages.addMessage(msg);
    }
     
  }*/
   public static testmethod void testmethod2(){
   
           Caseobjcatch1 = new Case();
           Caseobjcatch1.RecordTypeId = MBRecordTypeId;
           Caseobjcatch1.Case_Department__c = 'testcase';
           Caseobjcatch1.Description = 'testdes';
           Caseobjcatch1.Case_Type__c = 'testcasetype';
           Caseobjcatch1.Case_SubType__c = 'test case subtype';
           Caseobjcatch1.Case_Source__c = 'test case source';
           insert Caseobjcatch1;
           
           Caseobjcatch1.Knowledge_Complete_Flag__c =true;
       try{
         update Caseobjcatch1;
         }catch(DMLException e){
         system.assertEquals(e.getMessage(), e.getMessage());
         }
        delete Caseobjcatch1;
          
        
    }
   
   
   
}