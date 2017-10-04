@isTest
public class Batch_BounceStatusTest   {

    public static Id camIdExec= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
      public static Id camIdPlan= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
      //public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
       public static Id personaccRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    
   static testmethod void batchBounceStatus()
   {
   
   
      //String mainQuery = ;
     Test.startTest(); 
     
     account objMaster= new Account(RecordTypeId=personaccRecordTypeId,Master_Record__c = true,lastname = '雄志',DUPNumber__c='110',
                               Last_Successful_Call_Office_Phone__c = System.today() - 10,SMS_Last_Modified_Date__c= date.today(),MBK_Data_Source__c='Email',Mobile__c = '00000009642',DMS_Address__c = 'dmsaddress1');  
    
    insert objMaster;
    
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
      camobj1.Response_Date__c = date.today();
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
     camMem.Campaign_ID__c = camobj1.id;
     camMem.Contact_Id__c=objMaster.id;
     camMem.Status__c = 'Bounced';

      insert camMem;
      
     Campaign_Member__c camMem1 = New Campaign_Member__c();
     camMem1.Campaign_ID__c = camobj1.id;
     camMem1.Contact_Id__c=objMaster.id;
     camMem1.Status__c = 'Ready';

      insert camMem1;
      
      
      system.debug('+++++++++'+camMem1);
      system.debug('+++++++++'+camobj1);
      system.debug('+++++++++'+camobj);
  
    
    
    Batch_BounceStatus batchSch = New Batch_BounceStatus();
           
       
        Database.executeBatch(new Batch_BounceStatus());
    

         Test.stopTest();
         

}

static testmethod void batchBounceStatus1()
   {
   
   
      //String mainQuery = ;
     Test.startTest(); 
    
    account objMaster= new Account(RecordTypeId=personaccRecordTypeId,Master_Record__c = true,lastname = '雄志',DUPNumber__c='110',
                               Last_Successful_Call_Office_Phone__c = System.today() - 10,SMS_Last_Modified_Date__c= date.today(),MBK_Data_Source__c='Email',Mobile__c = '00000009642',DMS_Address__c = 'dmsaddress1');  
    
    insert objMaster;
    
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
      camobj1.Response_Date__c = date.today();
        camobj1.MD__c='JP';
        camobj1.Name = 'camptest1';
        camobj1.Campaign_Type__c='After Sales';
        camobj1.Type = 'Other';
        camobj1.Segmentation_Date__c= System.today()+4;
        camobj1.Execution_Start_Date__c = System.today()+10;
        camobj1.Execution_Type__c= 'OB Call';
        camobj1.Description = 'testdescrip';
        insert camobj1;
   
    Campaign_Member__c camMem = New Campaign_Member__c();
     camMem.Campaign_ID__c = camobj1.id;
     camMem.Contact_Id__c=objMaster.id;
     camMem.Status__c = 'Bounced';

      insert camMem;
      
     Campaign_Member__c camMem1 = New Campaign_Member__c();
     camMem1.Campaign_ID__c = camobj1.id;
     camMem1.Contact_Id__c=objMaster.id;
     camMem1.Status__c = 'Ready';

      insert camMem1;
      
      
      system.debug('+++++++++'+camMem1);
      system.debug('+++++++++'+camobj1);
      system.debug('+++++++++'+camobj);
  
    
    
    Batch_BounceStatus batchSch = New Batch_BounceStatus();
           
       
        Database.executeBatch(new Batch_BounceStatus());
    

         Test.stopTest();
         

}


static testmethod void batchBounceStatus2()
   {
   
   
      //String mainQuery = ;
     Test.startTest(); 
     
     account objMaster= new Account(RecordTypeId=personaccRecordTypeId,Master_Record__c = true,lastname = '雄志',DUPNumber__c='110',
                               Last_Successful_Call_Office_Phone__c = System.today() - 10,SMS_Last_Modified_Date__c= date.today(),MBK_Data_Source__c='Email',Mobile__c = '00000009642',DMS_Address__c = 'dmsaddress1');  
    
    insert objMaster;
    
     DM_Material__c dm = new DM_Material__c(Name = 'test');
      insert dm;
    
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
    camobj.Campaign_Execution_Channels__c='DM';
    camobj.Campaign_Type__c = 'After Sales';
    insert camobj;
  
  
    
        Campaign camobj1 = new Campaign();
        camobj1.RecordTypeId = camIdExec;
        camobj1.ParentId=camobj.id;
        camobj1.Child_Campaign_Status__c='Response collection';
      camobj1.Response_Date__c = date.today();
        camobj1.MD__c='JP';
        camobj1.Name = 'camptest1';
        camobj1.Campaign_Type__c='After Sales';
        camobj1.Type = 'Other';
        camobj1.Segmentation_Date__c= System.today()+4;
        camobj1.Execution_Start_Date__c = System.today()+10;
        camobj1.Execution_Type__c= 'DM';
        camobj1.DM_Material__c = dm.id;
        camobj1.Description = 'testdescrip';
        insert camobj1;
   
    Campaign_Member__c camMem = New Campaign_Member__c();
     camMem.Campaign_ID__c = camobj1.id;
     camMem.Contact_Id__c=objMaster.id;
     camMem.Status__c = 'Bounced';

      insert camMem;
      
     Campaign_Member__c camMem1 = New Campaign_Member__c();
     camMem1.Campaign_ID__c = camobj1.id;
     camMem.Contact_Id__c=objMaster.id;
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