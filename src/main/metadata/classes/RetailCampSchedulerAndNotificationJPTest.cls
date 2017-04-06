@isTest 
private class RetailCampSchedulerAndNotificationJPTest{
    Private Static Retail_Campaign__c rc;
     Private Static Retail_Campaign__c rc1;
     public static Campaign_Member__c cm;
      public static Campaign_Member__c cm1;
   public static Id segmentationRTId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    public static testMethod void RetailCampSchedulerAndNotificationJPTest()
    {    
      rc = new Retail_Campaign__c(Name = 'testCampaign',RecordTypeId=segmentationRTId ,Campaign_Execution_Channels__c ='DM',Execution_Start_Date__c = Date.Today(),Execution_Type__c = 'OB Call');
                insert rc;
                rc.Child_Campaign_Status__c = 'Segmentation';
                update rc;
    cm=new Campaign_Member__c();
    cm.Retail_Campaign_Id__c=rc.id;
    cm.Status__c = 'Executed';
   
    insert cm;    
     Test.startTest();
    RetailCampaignSchedulerAndNotificationJP batcher = new RetailCampaignSchedulerAndNotificationJP();
        Database.executeBatch(batcher, 300);
    Test.stopTest();
  }  
    public static testMethod void RetailCampSchedulerAndNotificationJPTest1()
    {    
      rc = new Retail_Campaign__c(Name = 'testCampaign',RecordTypeId=segmentationRTId ,Campaign_Execution_Channels__c ='DM',Execution_Start_Date__c = Date.Today(),Execution_Type__c = 'DM');
                insert rc;
       rc.Child_Campaign_Status__c = 'Segmentation';
       update rc;
    cm=new Campaign_Member__c();
    cm.Retail_Campaign_Id__c=rc.id;
    cm.Status__c = 'Executed';
   
    insert cm;    
      rc1 = new Retail_Campaign__c(Name = 'testCampaign',RecordTypeId=segmentationRTId ,Campaign_Execution_Channels__c ='DM',Execution_Start_Date__c = Date.Today(),Execution_Type__c = 'Lead');
                insert rc1;
       rc1.Child_Campaign_Status__c = 'Segmentation';
       update rc1;
    cm1=new Campaign_Member__c();
    cm1.Retail_Campaign_Id__c=rc1.id;
    cm1.Status__c = 'Executed';
   
    insert cm1;    
     Test.startTest();
    RetailCampaignSchedulerAndNotificationJP batcher = new RetailCampaignSchedulerAndNotificationJP();
        Database.executeBatch(batcher, 300);
    Test.stopTest();
  }  
 
}