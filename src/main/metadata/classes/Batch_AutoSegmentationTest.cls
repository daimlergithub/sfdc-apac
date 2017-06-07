@isTest
public class Batch_AutoSegmentationTest  {

      public static Id camIdExec= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
      public static Id camIdPlan= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
      public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
       //public static Retail_Campaign__c  rcobj1;
    
   static testmethod void batchAugment()
   {
   
   
      //String mainQuery = ;
     Test.startTest(); 
    Account accobj = new Account();
    accobj.FirstName = 'testaccount';
    accobj.lastName = 'testaccount';
    accobj.Email__c = 'Test@test.com';
    accobj.RecordTypeId = personAccRecordTypeId;
    //accobj.Name = 'testaccount';
    accobj.Phone = '012310086';
    accobj.MBK_Data_Source__c='Email';
    accobj.Mobile__c = '00000009642';
    
    insert accobj;

    Segmentation_Criteria__c scb = New Segmentation_Criteria__c();
   scb.Name = 'sample';
   //scb.Criteria__c = 'Select id,Name From Account' ;
   insert scb ;
   
   
   Segmentation_Criteria__c scb1 = New Segmentation_Criteria__c();
   scb1.Name = 'sample123';
   //scb1.Criteria__c = 'Select id,Name From abc ';
   insert scb1 ;
   
   Retail_Campaign__c rcobj1=new Retail_Campaign__c();
    rcobj1.Name='Test Campaign1';
    rcobj1.Child_Campaign_Status__c='Segmentation';
    rcobj1.Status__c='Draft';
    rcobj1.Execution_Start_Date__c=system.today()+1;
    rcobj1.Segmentation_Date__c=system.today();
    rcobj1.Execution_Type__c='eMail';
    rcobj1.RecordTypeId=camIdExec;
    rcobj1.Auto_Segmentation__c = true;
    rcobj1.Segmentation_Criteria__c = scb.id;
    rcobj1.IsAutoSegmentationExecuted__c = false;
    
    
    insert rcobj1;
    
  /* Retail_Campaign__c rcobj2=new Retail_Campaign__c();
    rcobj2.Name='Test Campaign123';
    rcobj2.Child_Campaign_Status__c='Segmentation';
    rcobj2.Status__c='Draft';
    rcobj2.Execution_Start_Date__c=system.today()+1;
    rcobj2.Segmentation_Date__c=system.today();
    rcobj2.Execution_Type__c='eMail';
    rcobj2.RecordTypeId=camIdExec;
    rcobj2.Auto_Segmentation__c = true;
    rcobj2.Segmentation_Criteria__c = scb1.id;
    rcobj2.IsAutoSegmentationExecuted__c = false;
    
    insert rcobj2;  */
    
    
    Batch_AutoSegmentation batchSch = New Batch_AutoSegmentation();
           
       
        Database.executeBatch(new Batch_AutoSegmentation());
    

         Test.stopTest();
         

}



}