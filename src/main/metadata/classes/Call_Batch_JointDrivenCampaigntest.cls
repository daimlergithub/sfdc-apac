/*
* Created by : Venky
*Created Date : 27/02/2017
* Changes related to SFDCJP-3317
*/
@isTest

Public class Call_Batch_JointDrivenCampaigntest
{
public static Campaign camobj;
 public static Campaign_Member__c cm;
  public static Campaign camobj1;
 public static Campaign_Member__c cm1;
 
  public static Id centmarcampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
   public static Id camIdPlan= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();

   static testMethod void testcmpAssignment() {
            test.starttest();

      camobj = new Campaign();
    camobj.RecordTypeId = centmarcampRecordTypeId;
    camobj.Name = 'camptest1';
    camobj.Type = 'Other';
    camobj.Status = 'Planned';
    camobj.StartDate = System.today();
    camobj.EndDate = System.today()+10;
    camobj.Campaign_Objectives__c = 'camobjectives';
    camobj.Execution_Start_Date__c = Date.Today()+4;
    camobj.Segmentation_Date__c= Date.Today();
    camobj.Execution_Type__c =  'OB Call';
    camobj.Child_Campaign_Status__c = 'Segmentation';
    camobj.Response_Date__c=system.today();
    camobj.Description = 'testdescrip';
    camobj.Campaign_CCC_Manager__c = Userinfo.getuserid();
    insert camobj;
   //camobj.Child_Campaign_Status__c = 'Segmentation';
   //update camobj;
    cm=new Campaign_Member__c();
    cm.Campaign_ID__c =camobj.id;
    cm.Status__c = 'Ready';
    //cm.contact_Id__c = accobj.Id;   
    insert cm;    
    
   Call_Batch_JointDrivenCampaign cmp=new Call_Batch_JointDrivenCampaign();
   Call_Batch_JointDrivenCampaign.Batch_JointDrivenCampaign(cm.id);
     Test.stopTest();
   
   }
}