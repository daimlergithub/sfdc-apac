@isTest
public class Batch_BounceStatusretailretailTest   {

    public static Id camIdExec= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
      public static Id camIdPlan= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
      //public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
       
    
   static testmethod void batchBounceStatus()
   {
   
   
      //String mainQuery = ;
     Test.startTest(); 
    
   Retail_Campaign__c camobj = new Retail_Campaign__c();
    camobj.RecordTypeId = camIdPlan;
    camobj.Name = 'camptest1';
    camobj.Campaign_Sub_Type__c= 'Sales';
    camobj.Status__c= 'Draft';
    camobj.Start_Date__c= System.today();
    camobj.Close_Date__c= System.today()+30;
    //camobj.Campaign_Executer__c='Retail';
    camobj.Child_Campaign_Status__c='Response collection';
   // camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Description__c= 'testdescrip';
    camobj.Campaign_Execution_Channels__c='eMail';
    camobj.Campaign_Type__c = 'After Sales';
    insert camobj;
  
  
    
        Retail_Campaign__c camobj1 = new Retail_Campaign__c();
        camobj1.RecordTypeId = camIdExec;
        camobj1.Parent_Campaign1__c=camobj.id;
        camobj1.Child_Campaign_Status__c='Response collection';
      
        camobj1.MD__c='JP';
        camobj1.Name = 'camptest1';
        camobj1.Campaign_Type__c='After Sales';
      //  camobj1.Type = 'Other';
        camobj1.Segmentation_Date__c= System.today()+4;
        camobj1.Execution_Start_Date__c = System.today()+10;
        camobj1.Execution_Type__c= 'eMail';
       // camobj1.Description = 'testdescrip';
        insert camobj1;
   
    Campaign_Member__c camMem = New Campaign_Member__c();
     camMem.Retail_Campaign_Id__c = camobj1.id;
     camMem.Status__c = 'Ready';

      insert camMem;
      
     Campaign_Member__c camMem1 = New Campaign_Member__c();
     camMem1.Retail_Campaign_Id__c = camobj1.id;
     camMem1.Status__c = 'Ready';

      insert camMem1;
      
      
      system.debug('+++++++++'+camMem1);
      system.debug('+++++++++'+camobj1);
      system.debug('+++++++++'+camobj);
  
    
    
    Batch_BounceStatusretail batchSch = New Batch_BounceStatusretail();
           
       
        Database.executeBatch(new Batch_BounceStatusretail());
    

         Test.stopTest();
         

}





}