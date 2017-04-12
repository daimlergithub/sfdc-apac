@isTest
public class Batch_BounceStatusTest   {

    public static Id camIdExec= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
      public static Id camIdPlan= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
      //public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
       
    
   static testmethod void batchBounceStatus()
   {
   
   
      //String mainQuery = ;
     Test.startTest(); 
    
   Campaign camobj = new Campaign();
    camobj.RecordTypeId = camIdPlan;
    camobj.Name = 'camptest1';
    camobj.Type = 'Other';
    camobj.Status = 'Draft';
    camobj.StartDate = System.today();
    camobj.EndDate = System.today()+30;
    camobj.Campaign_Executer__c='Retail';
    camobj.Child_Campaign_Status__c='Response collection';
    camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Description = 'testdescrip';
    camobj.Campaign_Execution_Channels__c='eMail';
    camobj.Campaign_Type__c = 'After Sales';
    insert camobj;
  
  
    
        Campaign camobj1 = new Campaign();
        camobj1.RecordTypeId = camIdExec;
        camobj1.ParentId=camobj.id;
        camobj1.Child_Campaign_Status__c='Response collection';
      
        camobj1.MD__c='JP';
        camobj1.Name = 'camptest1';
        camobj1.Campaign_Type__c='After Sales';
        camobj1.Type = 'Other';
        camobj1.Segmentation_Date__c= System.today()+4;
        camobj1.Execution_Start_Date__c = System.today()+10;
        camobj1.Execution_Type__c= 'eMail';
        camobj1.Description = 'testdescrip';
        insert camobj1;
   
    Campaign_Member__c camMem = New Campaign_Member__c();
     camMem.Campaign_ID__c = camobj.id;
     camMem.Status__c = 'Ready';

      insert camMem;
      
     Campaign_Member__c camMem1 = New Campaign_Member__c();
     camMem1.Campaign_ID__c = camobj.id;
     camMem1.Status__c = 'Ready';

      insert camMem1;
      
      
      system.debug('+++++++++'+camMem1);
      system.debug('+++++++++'+camobj1);
      system.debug('+++++++++'+camobj);
  
    
    
    Batch_BounceStatus batchSch = New Batch_BounceStatus();
           
       
        Database.executeBatch(new Batch_BounceStatus());
    

         Test.stopTest();
         

}





}