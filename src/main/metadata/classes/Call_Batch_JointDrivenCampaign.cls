/*
* Created by : Venky
*Created Date : 27/02/2017
* Changes related to SFDCJP-3317
*/

global class Call_Batch_JointDrivenCampaign{

public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id accCompany_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    webservice static void Batch_JointDrivenCampaign(Id camid){
    
     List<Campaign> camList=new List<Campaign>();
      List<Campaign> newcamlist = New List<campaign>();
      List<Campaign> parentCampaignList=new List<Campaign>();
      List<Campaign> CamlistCompleted=new List<Campaign>();
     Set<id> sid = New Set<id>();
     Set<id> aid = New Set<id>();
     if(camid !=null)
     {
       CamlistCompleted =[Select id,ParentId,Consolidated_List_Completed__c  From Campaign Where id =:camid];
     }
     
     if(CamlistCompleted !=null)
     {
     For(Campaign cam : CamlistCompleted ){
     
     if(cam.Consolidated_List_Completed__c  == true)
     {
       sid.add(cam.ParentId);
       aid.add(cam.Id);
     }
     
     }
     }
   
    // Checking Joint Driven 
    if(sid !=null)
    {
      camList =[Select id,Name,Campaign_Code__c,Campaign_Executer__c,Campaign_Type__c,Campaign_Sub_Type__c ,StartDate,EndDate,Status,Event_Type__c,Description,Campaign_Execution_Channels__c,ActualCost,Brand__c,Class__c,BudgetedCost  From Campaign Where Id =: sid];
     
    }
    if(camid !=null)
    {
      parentCampaignList = [Select id,Name,Execution_Start_Date__c,Execution_End_Date__c,DM_Material__c,Segmentation_Date__c,Child_Campaign_Status__c,Response_Date__c,Execution_Type__c,Segmentation_Base__c,DM_Template__c,Final_List_Approved__c,Survey__c,Add_Sales_Staff__c,Add_Service_Staff__c,Add_Campaign_Member_ID__c,Campaign_Member_Sharing_Rule__c From Campaign Where id =:camid];
      
    }
      If(camList.size() >0 && !camList.isEmpty() && aid !=null &&  parentCampaignList !=null){ 
     
          if(!Test.isRunningTest()){
          
        Batch_JointDrivenCampaign  batcher = new Batch_JointDrivenCampaign(aid, camList,parentCampaignList);
            Database.executeBatch(batcher, 1);  
            }
            }  
    
    }






}