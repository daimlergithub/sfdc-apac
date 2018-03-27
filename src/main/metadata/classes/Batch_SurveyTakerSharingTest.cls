@isTest
public class Batch_SurveyTakerSharingTest
{
    static String DealerAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    static String PersonAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    static String SalesLead = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
    static String Addr = Schema.SObjectType.Address__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
    
    static void createTestData()
    {
        Account De=new Account();
        De.RecordtypeId=DealerAcc;
        De.Name = 'メルセ';
        De.Type='Personal';
        De.Status__c='Active';
        De.Province__c='Province1';
        De.City__c='Test';
        De.Email__c='test@mbj.com';
        De.Mobile__c ='0435488899';
        De.Dealer_Rollout_Status__c = 'Done';
        
        insert De;
        
        Account  Per= new Account();
        Per.RecordtypeId=PersonAcc;
        Per.LastName='Test Person 1st';
        //Per.Type='Personal';
        Per.Status__c='Active';
        Per.Province__c='Province1';
        Per.City__c='Test';
        Per.ZipCode__c = '1004235';
        Per.Email__c='test@mbj.com';
        Per.Mobile__c ='0435488899';
        Per.Phone = '08022420181';
        Per.Main_Dealer__c = De.id;
        Per.Customer_Lifecycle_Phase__c = 'Care';
        
        insert Per;
        
        Address__c addr = new Address__c();
        addr.Customer__c = Per.id; 
        addr.Address_Type__c = 'Home';
        addr.Province__c = 'Hokkaido';
        
        insert addr;
        
        Lead__c lead = new Lead__C();
        lead.MD__c = 'JP';
        lead.Contact__c = Per.id;
        lead.Assigned_Dealer__c = De.id;
        lead.CAC_Lead_Status__c = 'New';
        
        insert lead;
        
         SurveyTaker__c st = new SurveyTaker__c();
           st.Dealer_Account__c = De.id;
           st.lead__c = lead.id;
           st.MD__c = 'JP';
           insert st;
        
        
    }
    public static  testmethod void afterInsertEvent_test1()
  {
         
      
           test.starttest();
             
     createTestData();
     Batch_SurveyTakerSharing batcher = new Batch_SurveyTakerSharing ();
            Database.executeBatch(batcher, 200);
         
           test.stoptest();
  }
}