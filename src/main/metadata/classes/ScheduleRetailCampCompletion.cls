/*
Description   :     When End date reach, automatically update the parent campaign status to “Completed”. 
                    All Child Campaign that are still in “Execution” and no response has been uploaded will be updated as well to “Not Responded”.
Date          :     31/01/2017
Company       :     NTT Data,Inc.                    
JIRA Ticket   :     SFDCJP-1025

*/


global Class ScheduleRetailCampCompletion implements Schedulable
{

Public List<Retail_Campaign__c> parentCamp;
Public List<Retail_Campaign__c> ChildCamp;
Public List<Retail_Campaign__c> addparentCamp;
Public List<Campaign_Member__c> Campaignmember;
Public List<Campaign_Member__c> UpdateCampaignmember;
Public List<Campaign> addChildCamp;
Public Set<Id> ParentCamId;
Public Set<Id> ChildCamId;
Public Map<Id, Retail_Campaign__c> updateparentCamp;
Public Map<Id, Retail_Campaign__c> updateChildCamp;
public static Id parentCampaign_RecordTypeID = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
public static Id childCampaign_RecordTypeID= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();

 global ScheduleRetailCampCompletion()
 {
 
 }
 
 global void execute(SchedulableContext ctx)
 {
  ParentCamId=new Set<Id>();
 ChildCamId=new Set<Id>();
 parentCamp=new List<Retail_Campaign__c>();
 ChildCamp=new List<Retail_Campaign__c>();
 updateparentCamp=new  Map<Id, Retail_Campaign__c>();
 updateChildCamp= new Map<Id, Retail_Campaign__c>();
 Campaignmember=new List<Campaign_Member__c> ();
 UpdateCampaignmember=new List<Campaign_Member__c>();
 Date d=date.Today();
 system.debug('#$#$#$#$#$#$#$ d'+d);
 if(d!=null)
 {
 parentCamp=[Select Execution_End_Date__c,Close_Date__c,Parent_Campaign1__c,Id,Execution_Start_Date__c,Status__c from Retail_Campaign__c where recordtypeid=:parentCampaign_RecordTypeID and Close_Date__c=:date.Today()];
 }
 system.debug('#$#$# parentCamp#$#$ d'+parentCamp);
 if(parentCamp!=null && !parentCamp.isempty())
 {
 for(Retail_Campaign__c pcam:parentCamp)
 {
 if(pcam.Close_Date__c== date.today())
 {
 pcam.Status__c='Completed';
 system.debug('#$#$# parentCamp#$#$ d'+pcam.id);
 if(pcam.id !=null)
 { 
 updateparentCamp.Put(pcam.Id,pcam);      
 ParentCamId.add(pcam.Id);
 }
 }
 }
 }
 system.debug('#$#$# parentCamp#$#$ d'+ParentCamId);
 
 update updateparentCamp.values();
 
 system.debug('#$#$# updateparentCamp #$#$ d'+updateparentCamp);
 
 if(ParentCamId!=null)
 {
 ChildCamp=[Select Execution_End_Date__c,Id,Execution_Start_Date__c,Child_Campaign_Status__c,Parent_Campaign1__c from Retail_Campaign__c where Parent_Campaign1__c=:ParentCamId and recordtypeid=:childCampaign_RecordTypeID   ];
 
 system.debug('#$#$# ChildCamp#$#$ d'+ChildCamp);
 if(ChildCamp!=null)
 {
 for(Retail_Campaign__c  Child:ChildCamp)
 {
 
 ChildCamId.add(Child.Id);
 
 }
 }
 }
  system.debug('#$#$# ChildCamId#$#$ d'+ChildCamId);
  
  
 if(ChildCamId!=null)
 {
 Campaignmember=[select id,Status__c,Retail_Campaign_Id__c from Campaign_Member__c where Retail_Campaign_Id__c=:ChildCamId AND Status__c = 'Executed' ];
 
  system.debug('#$#$# Campaignmember #$#$ d'+Campaignmember);
 if(Campaignmember!=null)
 {
 for(Campaign_Member__c  cmm:Campaignmember)
 {
 cmm.Status__c='Not Responded';
 UpdateCampaignmember.add(cmm);
 }
 }
 }
 
 Update UpdateCampaignmember;
 
 system.debug('#$#$# UpdateCampaignmember#$#$ d'+UpdateCampaignmember);
 }
}