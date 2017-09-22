@isTest
public class Batch_BounceStatusretailretailTest   {

    public static Id camIdExec= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
      public static Id camIdPlan= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
      //public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
       public static Id personaccRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    
   static testmethod void batchBounceStatus()
   {
   
   
       account objMaster= new Account(RecordTypeId=personaccRecordTypeId,Master_Record__c = true,lastname = '雄志',DUPNumber__c='110',
                               Last_Successful_Call_Office_Phone__c = System.today() - 10,SMS_Last_Modified_Date__c= date.today(),MBK_Data_Source__c='Email',Mobile__c = '00000009642',DMS_Address__c = 'dmsaddress1');  
    
    insert objMaster;
    
   Retail_Campaign__c camobj = new Retail_Campaign__c();
    camobj.RecordTypeId = camIdPlan;
    camobj.Name = 'camptest1';
    camobj.Campaign_Sub_Type__c= 'Sales';
    camobj.Status__c= 'Draft';
    camobj.Response_Date__c = date.today();
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
        camobj1.Child_Campaign_Status__c='Planning';
         camobj1.Response_Date__c = date.today();
      
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
     camMem.Status__c = 'Bounced';
     camMem.Contact_Id__c = objMaster.id;

      insert camMem;
      //camMem.Status__c = 'Bounced';
      //update camMem;
     Campaign_Member__c camMem1 = New Campaign_Member__c();
     camMem1.Retail_Campaign_Id__c = camobj1.id;
     camMem1.Status__c = 'Bounced';
     camMem1.Contact_Id__c = objMaster.id;

      insert camMem1;
      //camMem1.Status__c = 'Bounced';
     // update camMem1;
      
      system.debug('+++++++++'+camMem1);
      system.debug('+++++++++'+camobj1);
      system.debug('+++++++++'+camobj);
  
    
    
    //Batch_BounceStatusretail batchSch = New Batch_BounceStatusretail();
            Test.startTest(); 
       
        Database.executeBatch(new Batch_BounceStatusretail(),200);
    

         Test.stopTest();
         

}


static testmethod void batchBounceStatus1()
   {
   
   
      //String mainQuery = ;
    
    
   Retail_Campaign__c camobj = new Retail_Campaign__c();
    camobj.RecordTypeId = camIdPlan;
    camobj.Name = 'camptest1';
    camobj.Campaign_Sub_Type__c= 'Sales';
    camobj.Status__c= 'Draft';
    camobj.Response_Date__c = date.today();
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
        camobj1.Child_Campaign_Status__c='Planning';
         camobj1.Response_Date__c = date.today();
      
        camobj1.MD__c='JP';
        camobj1.Name = 'camptest1';
        camobj1.Campaign_Type__c='After Sales';
      //  camobj1.Type = 'Other';
        camobj1.Segmentation_Date__c= System.today()+4;
        camobj1.Execution_Start_Date__c = System.today()+10;
        camobj1.Execution_Type__c= 'OB Call';
       // camobj1.Description = 'testdescrip';
        insert camobj1;
   
    Campaign_Member__c camMem = New Campaign_Member__c();
     camMem.Retail_Campaign_Id__c = camobj1.id;
     camMem.Status__c = 'Bounced';
     

      insert camMem;
      //camMem.Status__c = 'Bounced';
      //update camMem;
     Campaign_Member__c camMem1 = New Campaign_Member__c();
     camMem1.Retail_Campaign_Id__c = camobj1.id;
     camMem1.Status__c = 'Bounced';

      insert camMem1;
      //camMem1.Status__c = 'Bounced';
     // update camMem1;
      
      system.debug('+++++++++'+camMem1);
      system.debug('+++++++++'+camobj1);
      system.debug('+++++++++'+camobj);
  
    
    
    //Batch_BounceStatusretail batchSch = New Batch_BounceStatusretail();
            Test.startTest(); 
       
        Database.executeBatch(new Batch_BounceStatusretail(),200);
    

         Test.stopTest();
         

}
static testmethod void batchBounceStatus2()
   {
   
   
      DM_Material__c dm = new DM_Material__c(Name = 'test');
      insert dm;
    
    
   Retail_Campaign__c camobj = new Retail_Campaign__c();
    camobj.RecordTypeId = camIdPlan;
    camobj.Name = 'camptest1';
    camobj.Campaign_Sub_Type__c= 'Sales';
    camobj.Status__c= 'Draft';
    camobj.Response_Date__c = date.today();
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
        camobj1.Child_Campaign_Status__c='Planning';
         camobj1.Response_Date__c = date.today();
      
        camobj1.MD__c='JP';
        camobj1.Name = 'camptest1';
        camobj1.Campaign_Type__c='After Sales';
      //  camobj1.Type = 'Other';
        camobj1.Segmentation_Date__c= System.today()+4;
        camobj1.Execution_Start_Date__c = System.today()+10;
        camobj1.Execution_Type__c= 'DM';
        camobj1.DM_Template__c = dm.id;
       // camobj1.Description = 'testdescrip';
        insert camobj1;
   
    Campaign_Member__c camMem = New Campaign_Member__c();
     camMem.Retail_Campaign_Id__c = camobj1.id;
     camMem.Status__c = 'Bounced';
     

      insert camMem;
      //camMem.Status__c = 'Bounced';
      //update camMem;
     Campaign_Member__c camMem1 = New Campaign_Member__c();
     camMem1.Retail_Campaign_Id__c = camobj1.id;
     camMem1.Status__c = 'Bounced';

      insert camMem1;
      //camMem1.Status__c = 'Bounced';
     // update camMem1;
      
      system.debug('+++++++++'+camMem1);
      system.debug('+++++++++'+camobj1);
      system.debug('+++++++++'+camobj);
  
    
    
    //Batch_BounceStatusretail batchSch = New Batch_BounceStatusretail();
            Test.startTest(); 
       
        Database.executeBatch(new Batch_BounceStatusretail(),200);
    

         Test.stopTest();
         

}


}