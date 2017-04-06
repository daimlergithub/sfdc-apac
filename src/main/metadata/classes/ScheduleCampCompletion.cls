/*
Description   :     When End date reach, automatically update the parent campaign status to “Completed”. 
                    All Child Campaign that are still in “Execution” and no response has been uploaded will be updated as well to “Not Responded”.
Date          :     31/01/2017
Company       :     NTT Data,Inc.                    
JIRA Ticket   :     SFDCJP-1025

*/


global Class ScheduleCampCompletion implements Schedulable
{

Public List<Campaign> parentCamp;
Public List<Campaign> ChildCamp;
Public List<Campaign> ChildCampmain;
Public List<Campaign> UpdateCampmain;
Public List<Campaign> addparentCamp;
Public List<Campaign_Member__c> Campaignmember;
Public List<Campaign_Member__c> UpdateCampaignmember;
Public List<Campaign> addChildCamp;
Public Set<Id> ParentCamId;
Public Set<Id> ChildCamId;
Public Map<Id, Campaign> updateparentCamp;
Public Map<Id, Campaign> updateChildCamp;
public static Id parentCampaign_RecordTypeID = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
public static Id childCampaign_RecordTypeID= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();

 global ScheduleCampCompletion()
 {
 
 }
 
 global void execute(SchedulableContext ctx)
 {
  ParentCamId=new Set<Id>();
 ChildCamId=new Set<Id>();
 parentCamp=new List<Campaign>();
 ChildCamp=new List<Campaign>();
 updateparentCamp=new  Map<Id, Campaign>();
 updateChildCamp= new Map<Id, Campaign>();
 Campaignmember=new List<Campaign_Member__c> ();
 UpdateCampaignmember=new List<Campaign_Member__c>();
 UpdateCampmain = new List<Campaign>();
 Date d=date.Today();
 system.debug('#$#$#$#$#$#$#$ d'+d);
 if(d!=null)
 {
 parentCamp=[Select EndDate,Id,StartDate,Status from Campaign where recordtypeid=:parentCampaign_RecordTypeID and EndDate=:date.Today()];
 }
 system.debug('#$#$# parentCamp#$#$ d'+parentCamp);
 if(parentCamp!=null && !parentCamp.isempty())
 {
 for(Campaign pcam:parentCamp)
 {
 if(pcam.EndDate== date.today())
 {
 pcam.Status='Completed';
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
 ChildCamp=[Select Id,EndDate,StartDate,Child_Campaign_Status__c from Campaign where ParentId=:ParentCamId and recordtypeid=:childCampaign_RecordTypeID ];
 
 system.debug('#$#$# ChildCamp#$#$ d'+ChildCamp);
 if(ChildCamp!=null)
 {
 for(Campaign  Child:ChildCamp)
 {
 
 ChildCamId.add(Child.Id);
 
 }
 }
 }
  system.debug('#$#$# ChildCamId#$#$ d'+ChildCamId);
  
  
 if(ChildCamId!=null)
 {
 Campaignmember=[select id,Status__c from Campaign_Member__c where Campaign_ID__c=:ChildCamId AND Status__c = 'Executed' ];
 

 
  system.debug('#$#$# Campaignmember #$#$ d'+Campaignmember);
 if(Campaignmember!=null)
 {
 
 for(Campaign_Member__c cmm:Campaignmember)
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