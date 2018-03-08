/* Purpose: Generic class hosting code to be executed in Batch class Batch_AutoTaskANDLead_MY
   Date: 01/02/2018
   Created By: Sushma */

global class Batch_AutoTaskANDLead_Generic{
 Date todaydate=System.today();
 List<Lead__c> existingLeadList=new List<Lead__C>();
 public static String sales='Sales Leads';
 public static String aftersales='Aftersales Leads';
 public static Id obCall = RecordTypeAccessService.getRecordTypeId('Task','OB Call');
String leadRTId= [SELECT Id, Name FROM RecordType WHERE SobjectType =: UtilConstant.LEAD and name = :sales].id;
String leadRTId1 = [SELECT Id, Name FROM RecordType WHERE SobjectType =: UtilConstant.LEAD and name = :aftersales].id;
  global Database.QueryLocator method1(Database.BatchableContext bc, string market) {
  if (market==System.Label.MarketMY){
        return DataBase.getQueryLocator('SELECT id,Contact_Id__r.Work_Phone__c,Retail_Campaign_Id__r.Campaign_Code__c,Contact_Id__r.Mobile__c,Contact_Id__r.Primary_Phone__c,Contact_Id__r.Individual_Home_Phone__c,Auto_creation_of_tasks__c,Retail_Campaign_Id__r.Parent_Campaign1__r.createdby.usertype,Name,Convert_To_Lead_Flag__c,Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c,Contract_Number__c,Contact_Id__r.Name,Campaign_ID__r.Name,UsVIN__c,Contact_Id__r.OwnerId,Model__c,Vehicle__c,Campaign_ID__r.Execution_Type__c,Campaign_ID__r.Segmentation_Base__c,Finance_Product__c,Campaign_ID__r.parent.Campaign_Type__c ,Campaign__r.Parent.Campaign_Type__c,Preferred_Dealer__c,Term__c,RV_Ballon__c,Total_Vehicle_Price_without_tax__c,Purchase_Timing__c,Lead_Desired_Service__c,Total_Vehicle_Price_with_tax__c,Interest_Rate__c,Cross_Point_Model__c,Monthly_Payment__c,Retail_Campaign_Id__r.Execution_Type__c,Campaign_ID__r.OwnerId,Contact_Id__r.personcontactid,Retail_Campaign_Id__c,Retail_Campaign_Id__r.OwnerId,Contract_Phone1_1__c,Contract_Phone2_2__c,Contact_Id__c,Company_Name__c,Contract__c ,Lead_Type__c, Lead_Sub_Type__c, Interested_Model__c FROM Campaign_Member__c WHERE  Retail_Campaign_Id__r.Execution_Start_Date__c=:todaydate and  (Status__c = \'Ready\' OR Status__c = \'Executed\' ) AND md__c=:market');
  }
  else{
        return DataBase.getQueryLocator('SELECT id,Contact_Id__r.Work_Phone__c,Retail_Campaign_Id__r.Campaign_Code__c,Contact_Id__r.Mobile__c,Contact_Id__r.Primary_Phone__c,Contact_Id__r.Individual_Home_Phone__c,Auto_creation_of_tasks__c,Retail_Campaign_Id__r.Parent_Campaign1__r.createdby.usertype,Name,Convert_To_Lead_Flag__c,Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c,Contract_Number__c,Contact_Id__r.Name,Campaign_ID__r.Name,UsVIN__c,Contact_Id__r.OwnerId,Model__c,Vehicle__c,Campaign_ID__r.Execution_Type__c,Campaign_ID__r.Segmentation_Base__c,Finance_Product__c,Campaign_ID__r.parent.Campaign_Type__c ,Campaign__r.Parent.Campaign_Type__c,Preferred_Dealer__c,Term__c,RV_Ballon__c,Total_Vehicle_Price_without_tax__c,Purchase_Timing__c,Lead_Desired_Service__c,Total_Vehicle_Price_with_tax__c,Interest_Rate__c,Cross_Point_Model__c,Monthly_Payment__c,Retail_Campaign_Id__r.Execution_Type__c,Campaign_ID__r.OwnerId,Contact_Id__r.personcontactid,Retail_Campaign_Id__c,Retail_Campaign_Id__r.OwnerId,Contract_Phone1_1__c,Contract_Phone2_2__c,Contact_Id__c,Company_Name__c,Contract__c ,Lead_Type__c,Retail_Campaign_Id__r.MBTH_Approval_Status__c, Lead_Sub_Type__c, Interested_Model__c FROM Campaign_Member__c WHERE  Retail_Campaign_Id__r.Execution_Start_Date__c=:todaydate and  (Status__c = \'Ready\' OR Status__c = \'Executed\' ) AND md__c=\'TH\' AND (Retail_Campaign_Id__r.MBTH_Approval_Status__c!=\'Submitted\' OR Retail_Campaign_Id__r.MBTH_Approval_Status__c!=\'Rejected\')');
  }
  }
  global void method2(Database.BatchableContext bc, List<Campaign_Member__c> scope) {
      List<Task> taskstoInsert=new List<Task>();
      set<Campaign_Member__c> camListToUpdate= new set<Campaign_Member__c>();
      LIst<Retail_campaign__c> retcamp=new List<Retail_Campaign__c>();
      List<Lead__c> duplicateLeadRec=new List<Lead__C>();
      List<Lead__c> leadList = new List<Lead__c>();
      for(Campaign_Member__c  campmember:scope){
      if(campmember.Retail_Campaign_Id__c!=null)
      retcamp.add(campmember.Retail_Campaign_Id__r);
      }
       existingLeadList = [Select Retail_Campaign_Name__c, Contact__c  from Lead__c where Retail_Campaign_Name__c =: retcamp];
      List<Lead__c> leadListToInsert = new List<Lead__c>();
      for(Campaign_Member__c  campmember:scope){
      if(campmember.Retail_Campaign_Id__r.Execution_Type__c=='OB Call'&&campmember.Auto_creation_of_tasks__c==false && ((campmember.Retail_Campaign_Id__r.Parent_Campaign1__r.createdby.usertype=='Standard'/*&& campmember.Retail_Campaign_Id__r.MBTH_Approval_Status__c=='Approved'*/)||campmember.Retail_Campaign_Id__r.Parent_Campaign1__r.createdby.usertype=='PowerPartner')){
      Task taskRec=new Task();
        taskRec.status= 'New';
        taskRec.Priority='Low';
        taskRec.subject = 'Campaign Executed';
        taskRec.Whatid = campmember.Retail_Campaign_Id__r.id;
        taskRec.OwnerId = campmember.Retail_Campaign_Id__r.OwnerId;
        taskRec.ActivityDate=System.today()+3;
        campmember.Auto_creation_of_tasks__c=true;
         taskRec.Campaign_Name__c=campmember.Retail_Campaign_Id__r.Campaign_Code__c;
        if(campmember.Contact_Id__r.personcontactid!=null){
            taskRec.whoid =campmember.Contact_Id__r.personcontactid;
        }
        taskRec.Related_Vehicle__c= campmember.Vehicle__c;    
        taskRec.Account_Name__c =campmember.Company_Name__c;
        taskRec.Phone__c = campmember.Contract_Phone1_1__c;
       taskRec.Phone_number__c=campmember.Contact_Id__r.Primary_Phone__c=='Home Phone'?campmember.Contact_Id__r.Individual_Home_Phone__c:campmember.Contact_Id__r.Primary_Phone__c=='Work Phone'?campmember.Contact_Id__r.Work_Phone__c:campmember.Contact_Id__r.Primary_Phone__c=='Mobile'?campmember.Contact_Id__r.Mobile__c:'';
        taskRec.Campaign_Member_ID__c = campmember.Name;
        taskRec.RecordTypeId = obCall;
        taskstoInsert.add(taskrec);
        campmember.Auto_creation_of_tasks__c= true;
        }
        else if(campmember.Retail_Campaign_Id__r.Execution_Type__c=='Lead' && campmember.Convert_To_Lead_Flag__c!=True &&(campmember.Retail_Campaign_Id__r.Parent_Campaign1__r.createdby.usertype=='Standard'||campmember.Retail_Campaign_Id__r.Parent_Campaign1__r.createdby.usertype=='PowerPartner')){
             Lead__c duplicate = checkDuplicate(campmember, existingLeadList);
              if(duplicate.Id == null){
                  leadListToInsert.add(setLeadRecordFields(campmember.Retail_Campaign_Id__c,campmember));
                  campmember.Convert_To_Lead_Flag__c = true;
              }
              else{
               leadList.add(duplicate);
               
              }
        }
        else if(campmember.Retail_Campaign_Id__r.Execution_Type__c=='Lead' && campmember.Convert_To_Lead_Flag__c!=True &&((campmember.Retail_Campaign_Id__r.Parent_Campaign1__r.createdby.usertype=='Standard' && campmember.md__c==System.Label.MarketMY)||campmember.Retail_Campaign_Id__r.Parent_Campaign1__r.createdby.usertype=='PowerPartner')){
             Lead__c duplicate = checkDuplicate(campmember, existingLeadList);
              if(duplicate.Id == null){
                  leadListToInsert.add(setLeadRecordFields(campmember.Retail_Campaign_Id__c,campmember));
                  campmember.Convert_To_Lead_Flag__c = true;
              }
              else{
               leadList.add(duplicate);
               
              }
        }
      }
      if(leadListToInsert.size() > 0){
      insert leadListToInsert;
      }
      if(taskstoInsert.size()>0)
      {
      insert taskstoInsert;
      }
      if(leadListToInsert.size() > 0||taskstoInsert.size()>0){
       
            update scope;  
       }
       
       insertCampaignLeadRecords(leadListToInsert, leadList);
  }
  public Lead__c setLeadRecordFields(String campaignId, Campaign_Member__c campaignMember) {
        Lead__c leadRec = new Lead__c();
        leadRec.Retail_Campaign_Name__c = campaignId;
        leadRec.CAC_Lead_Status__c = 'New';
        leadRec.Lead_DataSource__c='Dealer Outlet';
        leadRec.Contact__c = campaignMember.Contact_Id__c;
        leadRec.Lead_Type__c = campaignMember.Lead_Type__c;
        leadRec.Lead_Sub_Type__c = campaignMember.Lead_Sub_Type__c;
        leadRec.Existing_Contract__c=campaignMember.Contract__c;
        leadRec.Interested_Vehicle_Model__c = campaignMember.Interested_Model__c;
        leadRec.Assigned_Dealer__c=campaignMember.Preferred_Dealer__c;
        leadRec.Finance_Product_Name__c=campaignMember.Finance_Product__c;
        leadRec.Finance_Contract_Term__c=campaignMember.Term__c;
        leadRec.Finance_Monthly_Payment__c=campaignMember.Monthly_Payment__c;
        leadRec.Finance_Interest_Rate__c=campaignMember.Interest_Rate__c;
        leadRec.Finance_RV_Ballon__c=campaignMember.RV_Ballon__c;
        leadRec.Finance_Total_V_Price_NoTax__c=campaignMember.Total_Vehicle_Price_without_tax__c;
        leadRec.Finance_Total_V_Price_Tax__c=campaignMember.Total_Vehicle_Price_with_tax__c;
        leadRec.Purchase_Time__c=campaignMember.Purchase_Timing__c;
        leadRec.Lead_Desired_Service__c=campaignMember.Lead_Desired_Service__c;
        system.debug(campaignMember.Retail_Campaign_Id__r.OwnerId);
        leadRec.OwnerId = campaignMember.Retail_Campaign_Id__r.OwnerId;
        leadRec.UsVIN__c=campaignMember.UsVIN__c;
        if(campaignMember.Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c!=null){
        leadRec.RecordTypeId=campaignMember.Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c == 'Sales'?leadRTId:campaignMember.Retail_Campaign_Id__r.Parent_Campaign1__r.Campaign_Type__c == 'After Sales'?leadRTId1:leadRTId;
      }
        if(campaignMember.Campaign_ID__r.parent.Campaign_Type__c == 'Sales' || campaignMember.Campaign_ID__r.parent.Campaign_Type__c == 'Finance')
        {
         leadRec.Trade_In_Vehicle__c=campaignMember.Vehicle__c;
        }
        if(campaignMember.Campaign_ID__r.parent.Campaign_Type__c == 'Finance')
        {
          leadRec.Cross_Point_Model__c=campaignMember.Cross_Point_Model__c;
        }
        return leadRec;
    }
   public Lead__c checkDuplicate(Campaign_Member__c campaignMemberRec, List<Lead__c> existingLeadList) 
    {
        
        Lead__c duplicateLeadRec = new Lead__c();
        for(Lead__c leadRec : existingLeadList) 
        {
                    if(String.isNotBlank(leadRec.Contact__c)  &&  campaignMemberRec.Contact_Id__c == leadRec.Contact__c &&  String.isNotBlank(leadRec.Retail_Campaign_Name__c) && campaignMemberRec.Retail_Campaign_Id__c == leadRec.Retail_Campaign_Name__c)
                   {
                       duplicateLeadRec = leadRec;
                       break;
                   }    
         }
         return duplicateLeadRec;
     }
     
     public void insertCampaignLeadRecords(List<Lead__c> insertedLeadList, List<Lead__c> leadList) {
        List<Campaign_Lead__c> cLeadList = new List<Campaign_Lead__c>();
        for(Lead__c leadRec : insertedLeadList){
            cLeadList.add(setCampaignRec(leadRec));
        }
        
        for(Lead__c leadRec : leadList){
            cLeadList.add(setCampaignRec(leadRec));
        }
        
        if(cLeadList.size() > 0) {
            insert cLeadList;
        }
    }
     public Campaign_Lead__c setCampaignRec(Lead__c leadRec) {
        Campaign_Lead__c cLeadRec = new Campaign_Lead__c(); 
        cLeadRec.Lead__c = leadRec.Id;
        cLeadRec.Retail_Campaign__c = leadRec.Retail_Campaign_Name__c;
        cLeadRec.Contact__c = leadRec.Contact__c;
        if(leadRec.Source_Campaign__c != null){
             cLeadRec.Campaign__c = leadRec.Source_Campaign__c;
        }else if (leadRec.Retail_Campaign_Name__c != null){
            cLeadRec.Retail_Campaign__c = leadRec.Retail_Campaign_Name__c;
        }  
        return cLeadRec;
    }
}