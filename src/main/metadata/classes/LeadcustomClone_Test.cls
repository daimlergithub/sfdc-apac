@isTest
private class LeadcustomClone_Test{
  public static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
  private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId(); 
    static testmethod void testRec1(){
     Account objAccount= new Account();
        objAccount.RecordtypeId=personAccRecordTypeId;
        objAccount.LastName='Test Person 1st';        
        objAccount.Status__c='Active';       
        objAccount.City__c='Test';
        objAccount.ZipCode__c = '1004235';
        objAccount.Email__c='test@mbj.com';         
        insert objAccount;
    lead__C lead1 = new lead__C();    
        lead1.MD__c = 'JP';
        lead1.Contact__c = objAccount.id;
        //lead1.Assigned_Dealer__c = objAccount.id;
        lead1.CAC_Lead_Status__c = 'New';
        insert lead1;
        
        Test.startTest();
        LeadcustomClone.cloneLead(lead1.Id);
        Test.stopTest();
       
    }   
    
    static testmethod void testRec2(){
     Account objAccount= new Account();
        objAccount.RecordtypeId=personAccRecordTypeId;
        objAccount.LastName='Test Person 1st';        
        objAccount.Status__c='Active';       
        objAccount.City__c='Test';
        objAccount.ZipCode__c = '1004235';
        objAccount.Email__c='test@mbj.com';         
        insert objAccount;
    lead__C lead1 = new lead__C();    
        lead1.MD__c = 'JP';
        lead1.Contact__c = objAccount.id;
        //lead1.Assigned_Dealer__c = objAccount.id;
        lead1.CAC_Lead_Status__c = 'New';
        lead1.RecordtypeId = afterSalesRecordTypeId ;
        insert lead1;
        
        Test.startTest();
        LeadcustomClone.cloneLead(lead1.Id);
        Test.stopTest();
       
    }   
}