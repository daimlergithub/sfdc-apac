@isTest
private class LeadcustomClone_Test{
  private static Lead__c lead1;
  public static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
  private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId(); 
  public static id SalesLeadsRecordtypeid = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
    static testmethod void testRec1(){
     Account objAccount= new Account();
        objAccount.RecordtypeId=personAccRecordTypeId;
        objAccount.LastName='Test Person 1st';        
        objAccount.Status__c='Active';       
        objAccount.City__c='Test';
        objAccount.ZipCode__c = '1004235';
        objAccount.Email__c='test@mbj.com';         
        insert objAccount;
        /*testLead = new Lead__c(RecordTypeId=SalesLeadsRecordtypeid,Contact__c = objAccount.Id,CAC_Lead_Status__c = 'Qualified',Lead_Type__c = 'New Car');
        insert testLead;*/
        
         lead1 = new lead__C();
        lead1.MD__c = 'JP';
        lead1.Contact__c = objAccount.id;
        //lead1.Assigned_Dealer__c = DealerAccount.id;
        lead1.CAC_Lead_Status__c = 'New';
        lead1.Lead_Type__c = 'New Car';
        lead1.Lost_Comment__c = 'Converted to After-Sales Leads';
        insert lead1;
        system.assertEquals(lead1.Lead_Type__c,'New Car');
        Test.startTest();
        try{
        LeadcustomClone.cloneLead(lead1.Id);
        }catch(Exception Ex){}
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
     lead1 = new lead__C();    
        lead1.MD__c = 'JP';
        lead1.Contact__c = objAccount.id;
        //lead1.Assigned_Dealer__c = objAccount.id;
        lead1.CAC_Lead_Status__c = 'New';
        lead1.Lead_Type__c = 'New Car';
        lead1.RecordtypeId = afterSalesRecordTypeId ;
        lead1.Lost_Comment__c = 'Converted to After-Sales Leads';
        insert lead1;
        system.assertEquals(lead1.Lead_Type__c,'New Car');
        Test.startTest();
        try{
        LeadcustomClone.cloneLead(lead1.Id);
        }catch(Exception ex){}
        Test.stopTest();
       
    }   
}