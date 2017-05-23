/*
Type:       Utility for Retail Campaign trigger
Purpose:    1.  Release1.2 Qulification Process
User Story: Release1.2
Used By:    
---------------------------------------------------------------
History:

1. Sinow Created on 2014-06-05
*/
public  class RetailCampaignHelper
{
    
    
    
    
    public static String ExceptionMsg = 'Exception message is :' ;
    public static string AfterSalesYearlyTa = 'Aftersales Yearly TA'; 
    public static string SalesMktYrTa = 'Sales & Marketing Yearly TA'; 
    public static string RetailMbBestPractice ='Retail MB Best Practice'; 
    public static string  RetailSmartBestPractice = 'Retail smart Best Practice';
    public static string parentCampaign ='Parent_Campaign__c';
    public static string expr0 = 'expr0';
    
    public static void updateParentCampaignStatus(Set<Id> campaignIds)
    {
        List<Campaign> ParentCampaigns = new List<Campaign>();
        
        for(Campaign cam : [select Id, Status from Campaign where Id in :campaignIds])
        {
            cam.Status = 'Closed';
            ParentCampaigns.add(cam);
        }
        if(!ParentCampaigns.IsEmpty())
        {
            try {
                update ParentCampaigns;
            }
            catch(Exception ex) {
                System.debug(ExceptionMsg + ex.getMessage());
            }
        }
    }
    
    public static void updateParentCampaignQuarter(Set<Id> campaignIds)
    {
        List<Campaign> ParentCampaigns = new List<Campaign>();
        
        for(Campaign cam : [select Id, BP_Quarter__c from Campaign where Id in :campaignIds])
        {
            cam.BP_Quarter__c = cam.BP_Quarter__c >=0 ? cam.BP_Quarter__c + 1 : 1;
            ParentCampaigns.add(cam);
        }
        if(!ParentCampaigns.IsEmpty())
        {
            try {
                update ParentCampaigns;
            }
            catch(Exception ex) {
                System.debug(ExceptionMsg + ex.getMessage());
            }
        }
    }
    /* 
    Description  : Retail Campaign Deletion- delete Parent and associated child.
    SFDCJP-      : 1024
    Date         :  13/02/2017
        
    */
    
    Public static void beforeDeleteRetailCampaignStatus(List<Retail_Campaign__c> CampDel)
{
Id parentCampaignId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
Id childCampaign= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
List<Retail_Campaign__c> childcamp=new List<Retail_Campaign__c>();
List<Retail_Campaign__c> Parentcamp=new List<Retail_Campaign__c>();
Set<Id> parecamId=new Set<Id>();

for(Retail_Campaign__c cmp: CampDel){
if(cmp.RecordTypeId == parentCampaignId && cmp.Status__c == 'Draft'){
  parecamId.add(cmp.id);
   } 
  }

  if(parecamId!=null)
  {
childcamp=[select Id from Retail_Campaign__c where Parent_Campaign1__c  =:parecamId];
}
if(childcamp!=null)
{
delete childcamp;
delete Parentcamp;
}
  
 
}

/*End of SFDCJP-1024  Retail Campaign */
    public static Task generateTask(User user ,Retail_Campaign__c rc,String strSubject)
    {
        Map<String, Schema.RecordTypeInfo> RecordTypeMap = Schema.SObjectType.task.getRecordTypeInfosByName();
        return   new Task(
            Subject= strSubject, 
            RecordTypeId = RecordTypeMap.get('General Task').getRecordTypeId(),
            OwnerId = user.ContactId,
            Status = 'open',
            WhoId = user.id,
            WhatId = rc.id,
            ActivityDate = rc.Y_Apply_Deadline__c.addDays(-3));
    }
    
    // Added by Cyril.[To generate High Priority Task]
    public static Task generateHighPrioTask(User user ,Retail_Campaign__c rc,String strSubject)
    {
        Map<String, Schema.RecordTypeInfo> RecordTypeMap = Schema.SObjectType.task.getRecordTypeInfosByName();
        return   new Task(
            Subject= strSubject, 
            RecordTypeId = RecordTypeMap.get('General Task').getRecordTypeId(),
            OwnerId = user.ContactId,
            Status = 'open',
            Priority = 'High',
            WhoId = user.id,
            WhatId = rc.id,
            ActivityDate = rc.Y_Apply_Deadline__c.addDays(-3));
    }
    // Copies record type name,
    //  status and dealer region to a "Monthly TA" campaign 
    //  from its linked "Yearly TA"
    public static void ShareRecordToDealer_BeforeInsert(list<Retail_Campaign__c> retailCampainsNew)
    {
        User currentUser = [select Id, Contact.AccountId from User where Id = :UserInfo.getUserId()];
        Map<String, String> campaignName2Abbr = new Map<String, String>{SalesMktYrTa => ' S&M', AfterSalesYearlyTa => ' AS'};
            
            String monthlyTARecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get(UtilConstant.MONTHLY_TA).getRecordTypeId();
        String smYearlyTARecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get(UtilConstant.SALES_MARKETING).getRecordTypeId();
        String asYearlyTARecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_YEARLY).getRecordTypeId();
        
        Set<Id> yearlyCampaignIds = new Set<Id>();
        Set<Id> dealerIds = new Set<Id>();
        
        for(Retail_Campaign__c retailCampaign : retailCampainsNew)
        {
            if(retailCampaign.RecordTypeId == monthlyTARecordTypeId)
            {
                yearlyCampaignIds.add(retailCampaign.M_YearlyTA__c);
            }
            if(retailCampaign.Dealer_Name__c == null && currentUser.Contact.AccountId != null)
            {
                retailCampaign.Dealer_Name__c = currentUser.Contact.AccountId;  
            }
            if(retailCampaign.RecordTypeId == smYearlyTARecordTypeId || retailCampaign.RecordTypeId == asYearlyTARecordTypeId)
            {
                dealerIds.add(retailCampaign.Y_Dealer_Name__c);
            }
        }
        
        Map<Id, Retail_Campaign__c> yearlyCampaigns = new Map<Id, Retail_Campaign__c>([select Id, RecordType.Name, Y_Status__c, Dealer_Region__c, Y_Dealer_Name__c from Retail_Campaign__c where Id in :yearlyCampaignIds]);
        Map<Id, Account> dealerAccounts = new Map<Id, Account>([select Id, Dealer_Region__c from Account where Id in:dealerIds]);
        for(Retail_Campaign__c retailCampaign : retailCampainsNew)
        {
            if(retailCampaign.RecordTypeId == monthlyTARecordTypeId)
            {
                Retail_Campaign__c yearlyCampaign = yearlyCampaigns.get(retailCampaign.M_YearlyTA__c);
                if(yearlyCampaign != null)
                {
                    retailCampaign.Name += campaignName2Abbr.get(yearlyCampaign.RecordType.Name);
                    retailCampaign.Y_Status__c = yearlyCampaign.Y_Status__c;
                    retailCampaign.Dealer_Region__c = yearlyCampaign.Dealer_Region__c;
                    retailCampaign.Y_Dealer_Name__c = yearlyCampaign.Y_Dealer_Name__c;
                }
            }
            if(retailCampaign.RecordTypeId == smYearlyTARecordTypeId || retailCampaign.RecordTypeId == asYearlyTARecordTypeId)
            {
                Account dealerAccount = dealerAccounts.get(retailCampaign.Y_Dealer_Name__c);
                if(dealerAccount != null)
                {
                    retailCampaign.Dealer_Region__c = dealerAccount.Dealer_Region__c;
                }
            }
        }
    }
    public static void beforeDeleteEvents(List<Retail_Campaign__c> campRet)
    {
    Id camIdExec = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    Id camIdPlan = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
       
       for(Retail_Campaign__c cam : campRet){

   if(cam.RecordTypeId == camIdExec && cam.Child_Campaign_Status__c != 'planning'){
          
            cam.addError(System.Label.deleting_campaign);
    
    }else if(cam.RecordTypeId == camIdPlan && cam.Status__c != 'Draft'){
   
            cam.addError(System.Label.deleting_campaign);
            
    
    }
    
    }
}
/***********************************************************************************
Created By          :    Abhishekh Dasepalle   
Created Date        :    30.01.2017
Company             :    NTT Data,Inc.
Usage               :    The functionality of this Class is to send email notification to the Dealer Sales Manager when a new retail campaign is created 
                         Business Conditions :
                          * It sends Email Notification to dealer sales manager to start their retail execution  
                          * It Adds Campaign Members and participating dealers to respective child retail campaign                         
JIRA NO             :    SFDCJP-1044                                              
************************************************************************************/
public static void emailNotificationRetail (List<Retail_Campaign__c > retCampList)  {
    
    Set<Id> sid = New Set<Id>();
  List<Id> userIds = new List<Id>();
  List<String> sDealerEmails = New List<String>();
  Id parentCampaignId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
Id childCampaign= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
  List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
   Set<Id> retId = New Set<Id>(); 
   String mailSales ;
  For(Retail_Campaign__c  camp : retCampList){
  
   if(camp.Parent_Campaign__c != null && camp.RecordTypeId == childCampaign ){
   
   
        sid.add(camp.Parent_Campaign__c);
        retId.add(camp.Id);
         }
  
    
    
  }
  EmailTemplate templateId = [Select id from EmailTemplate where name = 'Dealer Campaign Notification'];
  //List<Campaign> CamList = [Select id,Name,Parent.Campaign_Type__c,(Select id,Dealer__c,Dealer__r.Dealer_Sales_Manager_Email__c,Dealer__r.Dealer_Aftersales_Manager_Email__c,Dealer__r.Name,ownerId from Participating_Dealers__r) from Campaign Where Id =:sid];
     List<Retail_Campaign__c> retList =[Select id,owner.id From Retail_Campaign__c Where Id =: retId];
  
  For(Retail_Campaign__c reCampaign : retList ){
         if(!Test.isRunningTest()){
          
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.saveAsActivity = false;
        mail.setTargetObjectId(reCampaign.owner.Id);
        //mail.setToAddresses(toaddress);
        mail.setWhatId(reCampaign.Id);
        
        mail.setTemplateID(templateId.Id); 
        mail.setUseSignature(false);
        mail.setSaveAsActivity(false);
            
               
               
               
            mails.add(mail);   

            }
            }
  Messaging.sendEmail(mails);
  
  
   } 
   /**
  *@Description : Actions which are performed as a part of before Insert/Update. This gets called from Campaign TriggerHandler
  which gets invoked by Trigger on Campaign Object. This method change the status of parent based on child retail campaign
  
  *@Author : Abhishekh Dasepalle
  
  
  */ 
   
   
   
   public static void parentRetailCampaignSatusChange(List<Retail_Campaign__c> retMainList,map<id,Retail_Campaign__c> camOldMap){ 
  
    Id executionRecordId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    Id planningRecordId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
  Set<id> sid = New Set<Id>();
  Set<Id> aid = New Set<Id>();
  List<Retail_Campaign__c> camList = New List<Retail_Campaign__c>();
  List<Retail_Campaign__c> camListMain = New List<Retail_Campaign__c>();
  
            For(Retail_Campaign__c camMain : retMainList){
            
            If(camMain.RecordTypeId == executionRecordId && camMain.Child_Campaign_Status__c != 'Planning'){
                      
                      sid.add(camMain.Parent_Campaign1__c);
            
            } 
            If(CamMain.RecordTypeId == planningRecordId  && CamMain.Status__c != camOldMap.get(CamMain.id).Status__c && CamMain.Status__c == 'Completed'){
      
                    aid.add(camMain.Id);
                     }
            }
            
            if(sid.size()>0){
            List<Retail_Campaign__c> retCamMainList =[Select id,Status__c From Retail_Campaign__c where id =: sid];
            
            if(retCamMainList.size()>0){
            
               For(Retail_Campaign__c cam : retCamMainList ){
               
                 if(cam.Status__c != 'Ongoing' && cam.Status__c != 'Completed'){
                 
                      cam.Status__c = 'Ongoing';
                      
                      camList.add(cam);
                       }
               }}
  
        if(camList.size()>0){
           Update camList;
        
        }}
         if(aid.size()>0){
        List<Retail_Campaign__c> camChildList = [Select Id,Parent_Campaign1__c,Child_Campaign_Status__c  From Retail_Campaign__c Where Parent_Campaign1__c =: aid];
        
        if(camChildList.size()>0){
        
          For(Retail_Campaign__c cam : camChildList ){
          
             
             
                  if(cam.Child_Campaign_Status__c != 'Completed'){
                  
                    cam.Child_Campaign_Status__c = 'Completed';
                    
                    camListMain.add(cam);
                        
                  }
                 }} 
        
        } 
        if(camListMain.size()>0){
               Update camListMain;
               } 
  } 
  /**
  *@Description : Actions which are performed as a part of before Insert/Update. This gets called from Campaign TriggerHandler
  which gets invoked by Trigger on Campaign Object. This method contains Data validations of parent and child retail campaign
  
  *@Author : Abhishekh Dasepalle
  
  
  */ 
   
   public static void validationParentRetailCampaign(List<Retail_Campaign__c> retList,map<id,Retail_Campaign__c> camOldMap,boolean isInsert,boolean isUpdate){
   
   Id parentCampaignId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
          
          
           For(Retail_Campaign__c rect : retList){
           
           if(isInsert && rect.Parent_Campaign__c == null && rect.RecordTypeId == parentCampaignId || (isUpdate && rect.Parent_Campaign__c == null && rect.RecordTypeId == parentCampaignId  && (rect.Start_Date__c != camOldMap.get(rect.id).Start_Date__c || rect.Close_Date__c != camOldMap.get(rect.id).Close_Date__c))){
           
               
                 If(rect.Start_Date__c < System.Today()){
                 
                   rect.addError(system.Label.Campaign_Date_1 );   
                 
                 }
                 
                 If(rect.Close_Date__c < rect.Start_Date__c){
                 
                       rect.addError(system.Label.Campaign_Date_2);
                 }
                  
           
}


}
   
 }
 
 public static void validationChildRetailCampaign(List<Retail_Campaign__c> retListMain,map<id,Retail_Campaign__c> camOldMap,boolean isInsert,boolean isUpdate){
 
 Id childCampaign= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
 Set<Id> sid = New Set<Id>(); 
 Set<Id> aid = New Set<Id>();        
          
           For(Retail_Campaign__c rect : retListMain){
           
if(isInsert && rect.Parent_Campaign__c == null && rect.RecordTypeId == childCampaign || (isUpdate && rect.Parent_Campaign__c == null && rect.RecordTypeId == childCampaign && (rect.Segmentation_Date__c != camOldMap.get(rect.id).Segmentation_Date__c  || rect.Execution_Start_Date__c  != camOldMap.get(rect.id).Execution_Start_Date__c || rect.Response_Date__c   != camOldMap.get(rect.id).Response_Date__c ))){
                  
                    system.debug('+++++++++++++++'+'WORKING' );
                         sid.add(rect.Parent_Campaign1__c);
                         
                         
                         }
                         if( isInsert && rect.Parent_Campaign__c == null && rect.RecordTypeId == childCampaign){
       
                    aid.add(rect.Parent_Campaign1__c); 
        }
                  }
                  
                  
                  if(sid.size() > 0){
                  
                  
                  List<Retail_Campaign__c> retList = [Select id,Start_Date__c,Close_Date__c from Retail_Campaign__c Where Id =:sid];
                  
                  system.debug('+++++++++++++++'+retList );
                  For(Retail_Campaign__c rec : retlist){
                  
                     For(Retail_Campaign__c recta : retListMain ){
                     
                     system.debug('+++++++++++++++'+rec.Start_Date__c );
                     if(recta.Segmentation_Date__c < System.Today() ||recta.Segmentation_Date__c > rec.Close_Date__c ||recta.Segmentation_Date__c < rec.Start_Date__c  ){
                     
                         recta.addError(System.Label.Campaign_Date_3);
                         
                     
                     }
                     
                     if(recta.Execution_Start_Date__c < System.Today()  || recta.Execution_Start_Date__c > rec.Close_Date__c || recta.Execution_Start_Date__c <= recta.Segmentation_Date__c ){
                     
                     
                            recta.addError(System.Label.Campaign_Date_4);
                     }
                  if(recta.Response_Date__c < System.Today()  || recta.Response_Date__c  > rec.Close_Date__c ||recta.Response_Date__c < recta.Execution_Start_Date__c   ){
                     
                     
                            recta.addError(System.Label.Campaign_Date_5);
                     }
                  }
               }
     }
     if(aid.size()>0){
     
     List<Retail_Campaign__c> ParentCamp = [Select id, Status__c From Retail_Campaign__c   Where Id =: aid ];
      For(Retail_Campaign__c  cam : ParentCamp ){
      
      For(Retail_Campaign__c  childCam : retListMain){
         if(cam.Status__c == 'Completed'){
         childCam.addError('Cant add Child Campaign When Parent Status is Completed');
       
       }
      } 
     }
     
     } 
 
}

/**
  *@Description : Actions which are performed as a part of before Insert/Update. This gets called from Campaign TriggerHandler
  which gets invoked by Trigger on Campaign Object. This method insert the campaign Members of Retail campaign on Join Driven Campaign(SFDCJP-1044)
  
  *@Author : Abhishekh Dasepalle
  
  
  */ 
   
    public static void afterInsertCopyRetailCampaign(List<Retail_Campaign__c> retCamp){
    
    List<Participating_Dealer__c> newRetail = New List<Participating_Dealer__c>();
    List<Campaign_Member__c > retailMem = New List<Campaign_Member__c >();
    Id parentCampaignId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
    Id childCampaign= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();

     Set<Id> retailId = New Set<Id>();       
    Set<id> sid = New Set<id>();    
        
        for(Retail_Campaign__c retcam : retCamp){
            
            if(retcam.Parent_Campaign__c != null && retcam.RecordTypeId == childCampaign ){
                
                    sid.add(retcam.Parent_Campaign__c);
                    retailId.add(retcam.Id);
            }
            
            
            
        }
    
    
    
      //List<Campaign> camList =[Select id,Name,Consolidated_List_Completed__c,Set_List_Maintenance_Flag__c ,(Select Id,Name,Retail_Campaign__c From Participating_Dealers__r) From Campaign Where Id =: sid ];
      
      List<Campaign> caMemList =[Select id,Name,Set_List_Maintenance_Flag__c,Consolidated_List_Completed__c,(Select Id,Name,Retail_Campaign_Id__c,Status__c,Preferred_Dealer__c,contact_Id__c    From  Campaign_Members1__r ) From Campaign Where Id =: sid ];
      
      List<Retail_Campaign__c> retList = [Select id From Retail_Campaign__c Where Id =: retailId];
            
            For(Campaign caMem : caMemList ){
            
            if(caMem.Set_List_Maintenance_Flag__c == false || caMem.Consolidated_List_Completed__c == true ){
                
              For(Retail_Campaign__c retail : retList){
              For(Campaign_Member__c camo : caMem.Campaign_Members1__r){
                 
                 if(camo.Status__c !='Removed'){ 
                 
                 Campaign_Member__c newCamRetail = new Campaign_Member__c();
                // newCamRetail.Name = camo.Name;
                 newCamRetail.Retail_Campaign_Id__c = retail.Id;
                 newCamRetail.Status__c = camo.Status__c;
                 newCamRetail.Preferred_Dealer__c = camo.Preferred_Dealer__c;
                 newCamRetail.contact_Id__c = camo.contact_Id__c;
                  retailMem.add(newCamRetail);               
                  
               }   
              }

            }
                                                  
                
            }
            
            
        }  
        if(retailMem.size() >0 && !retailMem.isEmpty()){
            insert retailMem;   
            
            } 
                    
    
    
    
    
    
    
    
    
    
    }
    
    
    /* End Of SFDCJP-1044 */
    
    
    public static void ShareRecordToDealer_AfterUpdate(list<Retail_Campaign__c> retailCampainsNew,map<id,Retail_Campaign__c> retailCampainsNewMap,map<id,Retail_Campaign__c> retailCampainsOldMap, boolean isUpdate)
    {
        String aftersalesYearlyTARecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_YEARLY).getRecordTypeId();
        Set<Id> yearlyCampaignIds = new Set<Id>();
        for(Id yearlyCampaignId : retailCampainsNewMap.keySet())
        {
            if(retailCampainsNewMap.get(yearlyCampaignId).Y_Status__c != retailCampainsOldMap.get(yearlyCampaignId).Y_Status__c   && retailCampainsNewMap.get(yearlyCampaignId).RecordTypeId == aftersalesYearlyTARecordTypeId)
            {
                
                yearlyCampaignIds.add(yearlyCampaignId);
                
            }
        }
        Map<Id, Retail_Campaign__c> yearlyCampaigns = new Map<Id, Retail_Campaign__c>([select Id, Y_Status__c from Retail_Campaign__c where Id in :yearlyCampaignIds]);
        List<Retail_Campaign__c> monthlyCampaigns = [select Id, Y_Status__c, M_YearlyTA__c from Retail_Campaign__c where M_YearlyTA__c in :yearlyCampaignIds];
        if(monthlyCampaigns!=null && !monthlyCampaigns.isEmpty())
        {
            for(Retail_Campaign__c monthlyCampaign : monthlyCampaigns)
            {
                monthlyCampaign.Y_Status__c = yearlyCampaigns.get(monthlyCampaign.M_YearlyTA__c).Y_Status__c;
            }
            update monthlyCampaigns;
        }
        
        List<Retail_Campaign__c> changedRecords = new List<Retail_Campaign__c>();
        for(Id recordId : retailCampainsNewMap.keySet())
        {
            if(retailCampainsNewMap.get(recordId).Dealer_Name__c != retailCampainsOldMap.get(recordId).Dealer_Name__c 
               || retailCampainsNewMap.get(recordId).Y_Dealer_Name__c != retailCampainsOldMap.get(recordId).Y_Dealer_Name__c 
               || retailCampainsNewMap.get(recordId).BP_Status__c != retailCampainsOldMap.get(recordId).BP_Status__c)
            {
                changedRecords.add(retailCampainsNewMap.get(recordId));
            }
        }
        if(!changedRecords.isEmpty())
        {
            delete [select Id from Retail_Campaign__Share where ParentId = :changedRecords and RowCause = :Schema.Retail_Campaign__Share.RowCause.Dealer_Campaign_Share__c];
            RetailCampaignSharingWrapService wrapService = new RetailCampaignSharingWrapService();
            SharingService.shareRetailCampaigns(wrapService.wrapRetailCampaigns(changedRecords));
        }
    }
    
    public static void afterInsertUpdateEvents(list<Retail_Campaign__c> retailCampainsNew,map<id,Retail_Campaign__c> retailCampainsOldMap, boolean isInsert,boolean isUpdate)
    {
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName();
        List<Retail_Campaign__Share> csList = new List<Retail_Campaign__Share>();
        List<Retail_Campaign__Share> deleteCsList = new List<Retail_Campaign__Share>();
        if(isInsert)
        {
            List<Retail_Campaign__c> MonthlyTA = new List<Retail_Campaign__c >();
            List<MonthlyRule__c> MonthlyRule = [select Name, ATL_BTL__c, Brand__c, Driven__c, KPI_Type__c from MonthlyRule__c];
            Set<Id> dealerNameIds = new Set<Id>();
            for(Retail_Campaign__c cp : retailCampainsNew)
            {
                if(cpRecordTypeMap.get(UtilConstant.AFTER_SALES_YEARLY).getRecordTypeId()== cp.RecordTypeId )
                {
                    for (MonthlyRule__c eachMonthly : MonthlyRule)
                    {
                        MonthlyTA.add(new Retail_Campaign__c (
                            RecordTypeId = cpRecordTypeMap.get('Monthly TA').getRecordTypeId(), 
                            Name = cp.name + '-' + eachMonthly.name,
                            M_YearlyTA__c = cp.id,
                            M_ATL_BTL__c = eachMonthly.ATL_BTL__c,
                            M_Brand__c = eachMonthly.Brand__c,
                            Driven__c = eachMonthly.Driven__c,
                            M_KPI_Type__c = eachMonthly.KPI_Type__c,
                            Y_Dealer_Name__c = cp.Y_Dealer_Name__c
                        ));
                    }
                    dealerNameIds.add(cp.Y_Dealer_Name__c);
                }
            }
            
            
            if(!MonthlyTA.IsEmpty())
            {
                insert MonthlyTA;
                Set<Id> MonthlyTAIds = new Set<Id>();
                for (Retail_Campaign__c eachMonthly : MonthlyTA)
                {
                    MonthlyTAIds.add(eachMonthly.Id);
                }
                MonthlyTA = [select Id, Y_Dealer_Name__c from Retail_Campaign__c where Id in :MonthlyTAIds];
                List<User> users = [select Id, AccountId from User where isActive = true and AccountId in :dealerNameIds and Contact.Permission_Set_Settings__c includes ('S_M_Yearly_TA')];
                for (Retail_Campaign__c eachMonthly : MonthlyTA)
                {
                    for(User user : users)
                    {
                        if(eachMonthly.Y_Dealer_Name__c == user.AccountId)
                        {
                            csList.add(new Retail_Campaign__Share(ParentId = eachMonthly.id, UserOrGroupId = user.id, AccessLevel = 'Edit'));
                        }
                    }
                }
            }
        }
        Map<id, id> monthlyTAYearlyTAMap = new Map<id, id>();
        Map<id, id> aSRetailYearlyTAMap = new Map<id, id>();
        if(isUpdate || isInsert) {
            for(Retail_Campaign__c cp : retailCampainsNew) {    
                if(cpRecordTypeMap.get('Monthly TA').getRecordTypeId()== cp.RecordTypeId ){
                    monthlyTAYearlyTAMap.put(cp.id, cp.M_YearlyTA__c);
                }
                if(cpRecordTypeMap.get('AS Retail Campaign').getRecordTypeId()== cp.RecordTypeId ){
                    aSRetailYearlyTAMap.put(cp.id, cp.Yearly_TA__c);
                }
            }
        }
        if(!monthlyTAYearlyTAMap.IsEmpty())
        {
            Double S_MarketingBudget;
            Double A_MarketingBudget;
            Double M_MarketingBudget;
            Double M_J_MarketingBudget;
            Double M_D_MarketingBudget;
            List<Retail_Campaign__c> MonthlyList = [select M_Brand__c, Driven__c, Y_Total_Amount__c, M_YearlyTA__c from Retail_Campaign__c where M_YearlyTA__c in :monthlyTAYearlyTAMap.values()  and M_KPI_Type__c = 'Marketing Budget'];
            List<Retail_Campaign__c> YearlyList = [select id, Y_SMART_Marketing_Budget__c, Y_AMG_Marketing_Budget__c, Y_MB_Marketing_Budget__c, Y_MB_Joint_Marketing_Budget__c, Y_MB_Dealer_Driven_Marketing_Budget__c from Retail_Campaign__c where id in :monthlyTAYearlyTAMap.values() ];
            if(MonthlyList!=null && !MonthlyList.IsEmpty() && YearlyList!=null && !YearlyList.IsEmpty())
            {
                for(Retail_Campaign__c Year : YearlyList)
                {
                    S_MarketingBudget = 0;
                    A_MarketingBudget = 0;
                    M_MarketingBudget = 0;
                    M_J_MarketingBudget = 0;
                    M_D_MarketingBudget = 0;
                    for(Retail_Campaign__c Mon : MonthlyList)
                    {
                        if(Mon.M_YearlyTA__c == Year.id)
                        {
                            if(Mon.M_Brand__c == 'MB + StarElite')
                            {
                                M_MarketingBudget = M_MarketingBudget + Mon.Y_Total_Amount__c;
                                if(Mon.Driven__c == 'Joint')
                                {
                                    M_J_MarketingBudget = M_J_MarketingBudget + Mon.Y_Total_Amount__c;
                                }
                                else if (Mon.Driven__c == 'Dealer Driven')
                                {
                                    M_D_MarketingBudget = M_D_MarketingBudget + Mon.Y_Total_Amount__c;
                                }
                            }
                            else if(Mon.M_Brand__c == 'smart')
                            {
                                S_MarketingBudget = S_MarketingBudget + Mon.Y_Total_Amount__c;
                            }
                            else if(Mon.M_Brand__c == 'AMG')
                            {
                                A_MarketingBudget = A_MarketingBudget + Mon.Y_Total_Amount__c;
                            }
                        }
                    }
                    Year.Y_SMART_Marketing_Budget__c = S_MarketingBudget;
                    Year.Y_AMG_Marketing_Budget__c = A_MarketingBudget;
                    Year.Y_MB_Marketing_Budget__c = M_MarketingBudget;
                    Year.Y_MB_Joint_Marketing_Budget__c = M_J_MarketingBudget;
                    Year.Y_MB_Dealer_Driven_Marketing_Budget__c = M_D_MarketingBudget;
                }
                update YearlyList;
            }
        }
        
        if(!aSRetailYearlyTAMap.IsEmpty())
        {
            Double AS_MarketingCurrentPlannedBudget;
            Double Q1MarketingBudget = 0;
            Double Q2MarketingBudget = 0;
            Double Q3MarketingBudget = 0;
            Double Q4MarketingBudget = 0;
            Double Q1ActualExpense = 0;
            Double Q2ActualExpense = 0;
            Double Q3ActualExpense = 0;
            Double Q4ActualExpense = 0;
            Date Q1EndDate = Date.newInstance(Date.Today().year(), 3, 31);
            Date Q2EndDate = Date.newInstance(Date.Today().year(), 6, 30); 
            Date Q3EndDate = Date.newInstance(Date.Today().year(), 9, 30);
            List<Retail_Campaign__c> CampaignList = [select Plan_Start_Date__c, Actual_Start_Date__c, Actual_Expense__c, Yearly_TA__c, Plan_Expense__c, Apply_Status__c, Feedback_Status__c from Retail_Campaign__c where Yearly_TA__c in :aSRetailYearlyTAMap.values() ];
            List<Retail_Campaign__c> YearlyList = [select id, AS_Marketing_Current_Planned_Budget__c, Y_Year__c from Retail_Campaign__c where id in :aSRetailYearlyTAMap.values() ];
            if(CampaignList!=null && !CampaignList.IsEmpty() && YearlyList!=null && !YearlyList.IsEmpty())
            {
                for(Retail_Campaign__c Year : YearlyList)
                {
                    AS_MarketingCurrentPlannedBudget = 0;
                    if(Year.Y_Year__c != null && Integer.valueOf(Year.Y_Year__c) != Date.Today().year())
                    {
                        Q1EndDate = Date.newInstance(Integer.valueOf(Year.Y_Year__c), 3, 31);
                        Q2EndDate = Date.newInstance(Integer.valueOf(Year.Y_Year__c), 6, 30); 
                        Q3EndDate = Date.newInstance(Integer.valueOf(Year.Y_Year__c), 9, 30);
                    }
                    for(Retail_Campaign__c Campaign : CampaignList)
                    {
                        if(Campaign.Yearly_TA__c == Year.id){
                            if(Campaign.Plan_Expense__c != null && Campaign.Apply_Status__c == 'Approved')
                            {
                                AS_MarketingCurrentPlannedBudget = AS_MarketingCurrentPlannedBudget + Campaign.Plan_Expense__c;
                                
                                if(Campaign.Plan_Start_Date__c <= Q1EndDate)
                                { 
                                    Q1MarketingBudget += Campaign.Plan_Expense__c; 
                                } 
                                else if(Campaign.Plan_Start_Date__c <= Q2EndDate)
                                { 
                                    Q2MarketingBudget += Campaign.Plan_Expense__c; 
                                }
                                else if(Campaign.Plan_Start_Date__c <= Q3EndDate)
                                { 
                                    Q3MarketingBudget += Campaign.Plan_Expense__c; 
                                }
                                else
                                { 
                                    Q4MarketingBudget += Campaign.Plan_Expense__c; 
                                }
                            }
                            
                            if(Campaign.Actual_Expense__c != null && Campaign.Feedback_Status__c == 'Approved')
                            {
                                if(Campaign.Actual_Start_Date__c <= Q1EndDate)
                                { 
                                    Q1ActualExpense += Campaign.Actual_Expense__c; 
                                } 
                                else if(Campaign.Actual_Start_Date__c <= Q2EndDate) 
                                { 
                                    Q2ActualExpense += Campaign.Actual_Expense__c; 
                                }
                                else if(Campaign.Actual_Start_Date__c <= Q3EndDate)
                                { 
                                    Q3ActualExpense += Campaign.Actual_Expense__c; 
                                }
                                else
                                { 
                                    Q4ActualExpense += Campaign.Actual_Expense__c; 
                                }
                            }
                        }
                    }
                    Year.Q1_Actual_Expense__c = Q1ActualExpense; 
                    Year.Q2_Actual_Expense__c = Q2ActualExpense; 
                    Year.Q3_Actual_Expense__c = Q3ActualExpense; 
                    Year.Q4_Actual_Expense__c = Q4ActualExpense; 
                    Year.Q1_Marketing_Budget__c = Q1MarketingBudget; 
                    Year.Q2_Marketing_Budget__c = Q2MarketingBudget; 
                    Year.Q3_Marketing_Budget__c = Q3MarketingBudget; 
                    Year.Q4_Marketing_Budget__c = Q4MarketingBudget; 
                    Year.AS_Marketing_Current_Planned_Budget__c = AS_MarketingCurrentPlannedBudget;
                }
                update YearlyList;
            }
        }
        
        List<Task> taskList = new List<Task>();
        Map<id, id> SMyearlyTAMap = new Map<id, id>();
        Map<id, id> ASyearlyTAMap = new Map<id, id>();
        Map<id, id> ASdeleteMap = new Map<id, id>();
        Map<id, id> SMdeleteMap = new Map<id, id>();
        Map<id, Retail_Campaign__c> RCMap = new Map<id, Retail_Campaign__c>();
        for(Retail_Campaign__c cp : retailCampainsNew)
        {
            if(isInsert || (isUpdate && cp.Y_Dealer_Name__c != retailCampainsOldMap.get(cp.id).Y_Dealer_Name__c))
            {
                if( cpRecordTypeMap.get(AfterSalesYearlyTa).getRecordTypeId()== cp.RecordTypeId)
                {
                    ASyearlyTAMap.put(cp.Y_Dealer_Name__c, cp.id);
                    RCMap.put(cp.Y_Dealer_Name__c, cp);
                }
                else if(cpRecordTypeMap.get(SalesMktYrTa).getRecordTypeId()== cp.RecordTypeId)
                {
                    SMyearlyTAMap.put(cp.Y_Dealer_Name__c, cp.id);
                    RCMap.put(cp.Y_Dealer_Name__c, cp);
                }
                if(Trigger.isUpdate && cpRecordTypeMap.get(AfterSalesYearlyTa).getRecordTypeId()== cp.RecordTypeId)
                {
                    ASdeleteMap.put(retailCampainsOldMap.get(cp.id).Y_Dealer_Name__c, cp.id);
                }
                else if(Trigger.isUpdate && cpRecordTypeMap.get(SalesMktYrTa).getRecordTypeId()== cp.RecordTypeId)
                {
                    SMdeleteMap.put(retailCampainsOldMap.get(cp.id).Y_Dealer_Name__c, cp.id);
                }
                
            }
        }
        
        List<User> SMyearlyTAusers = [select AccountId, Id, ContactId from User 
                                      where  isActive = true and AccountId in  :SMyearlyTAMap.keySet() and Contact.Permission_Set_Settings__c includes ('S_M_Yearly_TA')];
        
        List<User> ASyearlyTAusers = [select AccountId, Id, ContactId from User 
                                      where  isActive = true and AccountId in  :ASyearlyTAMap.keySet() and Contact.Permission_Set_Settings__c includes ('AS_Yearly_TA')];
        
        for(User user : SMyearlyTAusers)
        {
            csList.add(new Retail_Campaign__Share(ParentId = SMyearlyTAMap.get(user.AccountId),
                                                  UserOrGroupId = user.id, 
                                                  AccessLevel = 'Edit'));
            if(RCMap.get(user.AccountId).Y_Apply_Deadline__c != NULL)
            {                                   
                taskList.add(RetailCampaignHelper.generateHighPrioTask(user, RCMap.get(user.AccountId), 'On the due deadline to submit annual plans'));
            }                
        }
        for(User user : ASyearlyTAusers)
        {
            csList.add(new Retail_Campaign__Share(ParentId = ASyearlyTAMap.get(user.AccountId),
                                                  UserOrGroupId = user.id,
                                                  AccessLevel = 'Edit'));
            if(RCMap.get(user.AccountId).Y_Apply_Deadline__c != NULL)
            {                                   
                taskList.add(RetailCampaignHelper.generateHighPrioTask(user, RCMap.get(user.AccountId), 'On the due deadline to submit annual plans'));
            }                
        }
        List<User> ASdUsers = [select AccountId, Id, ContactId from User 
                               where  isActive = true and AccountId in  :ASdeleteMap.keySet() and Contact.Permission_Set_Settings__c includes ('AS_Retail_Campaign')];
        List<User> SMdUsers = [select AccountId, Id, ContactId from User 
                               where  isActive = true and AccountId in  :SMdeleteMap.keySet() and Contact.Permission_Set_Settings__c includes ('S_M_Retail_Campaign')];
        
        deleteCsList = [select Id, UserOrGroupId, ParentId, AccessLevel, RowCause from Retail_Campaign__Share
                        where (ParentId = :ASdeleteMap.values() and UserOrGroupId in :ASdUsers) OR (ParentId = :SMdeleteMap.values() and UserOrGroupId in :SMdUsers)];
        if(csList!=null && !csList.IsEmpty()){
            try {
                insert csList;
            }
            catch(Exception ex) {
                System.debug(ExceptionMsg + ex.getMessage());
            }
        }
        
        if(!taskList.IsEmpty()){
            try {
                insert taskList;
            }
            catch(Exception ex) {
                System.debug(ExceptionMsg + ex.getMessage());
            }
        }
        
        if(deleteCsList!=null && !deleteCsList.IsEmpty()) {
            try {
                delete deleteCsList;
            }
            catch(Exception ex) {
                System.debug(ExceptionMsg + ex.getMessage());
            }
        }
        
        //Sinow update 2014-Jun-05 - Release1.2 Qulification Process
        if(isUpdate) {
            
            Set<Id> parentCampaignIds = new Set<Id>();
            Set<Id> parentCampaignIdsForUpdateQuarter = new Set<Id>();
            for(Retail_Campaign__c cp : retailCampainsNew)
            {
                if((cp.RecordTypeId == cpRecordTypeMap.get(RetailMbBestPractice).getRecordTypeId() || cp.RecordTypeId == cpRecordTypeMap.get(RetailSmartBestPractice).getRecordTypeId())
                   && cp.Parent_Campaign__c != null && ((cp.Final_Best_Practice__c && !retailCampainsOldMap.get(cp.id).Final_Best_Practice__c) || (cp.Final_Best_Practice_Forsmart__c&& !retailCampainsOldMap.get(cp.id).Final_Best_Practice_Forsmart__c)))
                {
                    parentCampaignIds.add(cp.Parent_Campaign__c);
                }
                if(cp.RecordTypeId == cpRecordTypeMap.get(RetailSmartBestPractice).getRecordTypeId()
                   && cp.Parent_Campaign__c != null && cp.BP_Status__c == 'Retail Submit' && cp.BP_Status__c != retailCampainsOldMap.get(cp.id).BP_Status__c) {
                       parentCampaignIdsForUpdateQuarter.add(cp.Parent_Campaign__c);
                   }
            }
            
            if(!parentCampaignIds.IsEmpty())
            {
                updateParentCampaignStatus(parentCampaignIds);
            }
            
            if(!parentCampaignIdsForUpdateQuarter.IsEmpty())
            {
                updateParentCampaignQuarter(parentCampaignIdsForUpdateQuarter);
            }
        }
    }
      /**
  *@Description :custom clone in campaign
  
  *@Author : Dinesh
  
  
  */
    
    Public static void updateLogic(List<Retail_Campaign__c> campgn){
Id camIdExec = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    Id camIdPlan = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
id recId;
 List<Retail_Campaign__c> camUpdateList = new List<Retail_Campaign__c>();

 set<Id> sid = New Set<Id>();
           
                                   
                                   For(Retail_Campaign__c cam :  campgn){
                                                   
                                                   
                                 if( cam.CloneCampaign__c!= null){
                                   sid.add(cam.CloneCampaign__c);
                                   system.debug('+++'+cam.CloneCampaign__c);
                                          
                                                                   
                                                   }
                                   }
             system.debug('++++++'+sid);

List<Retail_Campaign__c> CamList = [Select Id,Name,Parent_Campaign1__c,Segmentation_Date__c,Child_Campaign_Status__c ,Execution_Start_Date__c From Retail_Campaign__c Where Parent_Campaign1__c=: sid];
system.debug('++++++'+CamList);
For(Retail_Campaign__c came : campgn){
For(Retail_Campaign__c camp : CamList ){
                
                
                Retail_Campaign__c camm = New Retail_Campaign__c();
                camm.Name = camp.Name;
                camm.Parent_Campaign1__c= came.Id;
                camm.Segmentation_Date__c = camp.Segmentation_Date__c ;
                camm.Execution_Start_Date__c  = camp.Execution_Start_Date__c ;
                camm.Child_Campaign_Status__c   = camp.Child_Campaign_Status__c;
                camm.RecordTypeId = camIdExec;
                                                                        
       camUpdateList.add(camm);
                
}
}

insert camUpdateList;

system.debug('++++++'+camUpdateList);

}
    
    public static void beforeInsertUpdateEvents(list<Retail_Campaign__c> retailCampainsNew,map<id,Retail_Campaign__c> retailCampainsOldMap, boolean isInsert,boolean isUpdate)
    {
        List<Retail_Campaign__c> preRetailCampaign = new List<Retail_Campaign__c>();
        Map<Id, Id> RCIdDealerId = new Map<Id, Id>();
        Map<Id, Account> DealerIDAccount = new Map<Id, Account>();
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName();
        List<Retail_Campaign__Share> deleteCsList = new List<Retail_Campaign__Share>();
        
        Set<Id> dealerIds = new Set<Id>();
        Map<String, set<Id>> existDealerIdCampaignIds = new Map<String, set<Id>>();
        Set<Id> parentBPCampaigns = new Set<Id>();
        Map<String, Integer> parCampaignRetailCamNums = new Map<String, Integer>();
        Map<String, Integer> parCampaignBPNumbers = new Map<String, Integer>();
        Map<String, Integer> parCampaignRecommendCamNums = new Map<String, Integer>();
        Map<String, Integer> parCampaignRecommendBPNumbers = new Map<String, Integer>();
        Map<String, Integer> parentCamHasFinalBest = new Map<String, Integer>();
        Map<String, Integer> parentCamHasFinalBestForSmart = new Map<String, Integer>();
        
        //add the business logic to assign the delear as owner to the approver for the aftersales yearly TA for Release 1.3, zhongyang.si begin
        List<Retail_Campaign__c> asYearlyTAList = new List<Retail_Campaign__c>();
        Set<ID> dealerASID = new Set<ID>();
        Map<ID,Account> dealerAS = new Map<ID,Account>();
        for(Retail_Campaign__c rc : retailCampainsNew)
        {
            if(rc.Y_Dealer_Name__c != null && rc.RecordTypeId == cpRecordTypeMap.get(AfterSalesYearlyTa).getRecordTypeId())
            {
                asYearlyTAList.add(rc);
                dealerASID.add(rc.Y_Dealer_Name__c);
            }
        }
        if(!dealerASID.isEmpty())
        {
            for(Account a : [SELECT id, Ownerid, Retail_AS_Owner__c FROM Account WHERE id in :dealerASID])
            {
                dealerAS.put(a.id, a);
            }
        }
        for(Retail_Campaign__c rc : asYearlyTAList)
        {
            if(dealerAS.keyset().contains(rc.Y_Dealer_Name__c))
            {
                if ( dealerAS.get(rc.Y_Dealer_Name__c).Retail_AS_Owner__c != null)
                {
                    rc.Approver__c = dealerAS.get(rc.Y_Dealer_Name__c).Retail_AS_Owner__c;
                } 
                else 
                {
                    rc.Approver__c = dealerAS.get(rc.Y_Dealer_Name__c).ownerid;
                }
            }
        }
        //add the business logic to assign the delear as owner to the approver
        // for the aftersales yearly TA for Release 1.3, zhongyang.si end
        
        for(Retail_Campaign__c rc : retailCampainsNew)
        {
            if(isInsert) 
            {
                if(rc.Dealer_Name__c != null)
                {
                    preRetailCampaign.add(rc);
                    RCIdDealerId.put(rc.id, rc.Dealer_Name__c);
                }
                
                //Generation function, by sinow Release 1.2
                if((rc.RecordTypeId == cpRecordTypeMap.get(RetailMbBestPractice).getRecordTypeId()
                    || rc.RecordTypeId == cpRecordTypeMap.get(RetailSmartBestPractice).getRecordTypeId()) && rc.Y_Dealer_Name__c != null)
                {
                    dealerIds.add(rc.Y_Dealer_Name__c); 
                }
            }
            if(isUpdate)
            {
                preRetailCampaign.add(rc);
                if(rc.Dealer_Name__c != null && rc.Dealer_Name__c != retailCampainsOldMap.get(rc.Id).Dealer_Name__c)
                {
                    RCIdDealerId.put(rc.id, rc.Dealer_Name__c);
                }
                if(rc.Y_Status__c == 'Confirmed' &&
                   (cpRecordTypeMap.get(SalesMktYrTa).getRecordTypeId()== rc.RecordTypeId 
                    || cpRecordTypeMap.get(AfterSalesYearlyTa).getRecordTypeId()== rc.RecordTypeId))
                {
                    rc.OwnerId = userinfo.getUserId();
                }
                
                if((rc.Region_Best_Practice__c && ! retailCampainsOldMap.get(rc.Id).Region_Best_Practice__c) ||
                   (rc.Region_Recommendation__c && ! retailCampainsOldMap.get(rc.Id).Region_Recommendation__c) ||
                   (rc.Final_Best_Practice__c && ! retailCampainsOldMap.get(rc.Id).Final_Best_Practice__c) ||
                   (rc.Final_Best_Practice_Forsmart__c && ! retailCampainsOldMap.get(rc.Id).Final_Best_Practice_Forsmart__c))
                {
                    parentBPCampaigns.add(rc.Parent_Campaign__c);
                }
            }
        }
        
        if(RCIdDealerId.values().size() > 0) {
            for(Account a : [select id, Dealer_Region__c, Dealer_MB_Sub_Region__c, Retail_AMG_Owner__c, Ownerid, Retail_AS_Owner__c, Retail_Star_Elite_Owner__c, Retail_MB_Owner__c, Retail_smart_Owner__c from Account where id in :RCIdDealerId.values()]) {
                DealerIDAccount.put(a.id, a);
            }
        }
        
        if(!dealerIds.isEmpty()) {
            for(Retail_Campaign__c rcm : [select Y_Dealer_Name__c, Retail_Candidate__c, Parent_Campaign__c, Brand__c from Retail_Campaign__c where Y_Dealer_Name__c in :dealerIds]) {
                if(!existDealerIdCampaignIds.containsKey(rcm.Brand__c + rcm.Y_Dealer_Name__c + rcm.Parent_Campaign__c)) {
                    existDealerIdCampaignIds.put(rcm.Brand__c + rcm.Y_Dealer_Name__c + rcm.Parent_Campaign__c, new set<Id>());
                }
                existDealerIdCampaignIds.get(rcm.Brand__c + rcm.Y_Dealer_Name__c + rcm.Parent_Campaign__c).add(rcm.Retail_Candidate__c);
            }
        }
        
        if(!parentBPCampaigns.isEmpty()) {
            AggregateResult[] groupedResults = [SELECT count(Id), Parent_Campaign__c FROM Retail_Campaign__c where Parent_Campaign__c in :parentBPCampaigns and Region_Best_Practice__c = true GROUP BY Parent_Campaign__c]; 
            for(AggregateResult ar : groupedResults) {
                parCampaignRetailCamNums.put(String.valueOf(ar.get(parentCampaign)), Integer.valueOf(ar.get(expr0))); 
            }
            
            groupedResults = [SELECT count(Id), Parent_Campaign__c FROM Retail_Campaign__c where Parent_Campaign__c in :parentBPCampaigns and Region_Recommendation__c = true GROUP BY Parent_Campaign__c]; 
            for(AggregateResult ar : groupedResults) {
                parCampaignRecommendCamNums.put(String.valueOf(ar.get(parentCampaign)), Integer.valueOf(ar.get(expr0)));
            }
            
            groupedResults = [SELECT count(Id), Parent_Campaign__c FROM Retail_Campaign__c where Parent_Campaign__c in :parentBPCampaigns and Final_Best_Practice__c = true GROUP BY Parent_Campaign__c]; 
            for(AggregateResult ar : groupedResults) {
                parentCamHasFinalBest.put(String.valueOf(ar.get(parentCampaign)), Integer.valueOf(ar.get(expr0)));
            }
            
            groupedResults = [SELECT count(Id), Parent_Campaign__c FROM Retail_Campaign__c where Parent_Campaign__c in :parentBPCampaigns and Final_Best_Practice_Forsmart__c = true GROUP BY Parent_Campaign__c]; 
            for(AggregateResult ar : groupedResults) {
                parentCamHasFinalBestForSmart.put(String.valueOf(ar.get(parentCampaign)), Integer.valueOf(ar.get(expr0)));
            }
            
            for(Campaign cam : [select Id, Region_Best_Number__c, Region_Recommend_Number__c from Campaign where Id in :parentBPCampaigns and Region_Best_Number__c >= 0]) {
                parCampaignBPNumbers.put(cam.Id, Integer.valueOf(cam.Region_Best_Number__c));
                parCampaignRecommendBPNumbers.put(cam.Id, Integer.valueOf(cam.Region_Recommend_Number__c));
            }
        }
        
        for(Retail_Campaign__c rc : preRetailCampaign) {
            if(cpRecordTypeMap.get('S&M Event Retail Campaign').getRecordTypeId()== rc.RecordTypeId 
               || cpRecordTypeMap.get('S&M Media Retail Campaign').getRecordTypeId()== rc.RecordTypeId
               || cpRecordTypeMap.get('AS Retail Campaign').getRecordTypeId()== rc.RecordTypeId){
                   if(RCIdDealerId.keyset().contains(rc.id) && DealerIDAccount.keyset().contains(RCIdDealerId.get(rc.id))) {
                       rc.Dealer_Region__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Dealer_Region__c;
                       rc.Dealer_Sub_Region__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Dealer_MB_Sub_Region__c;
                       if(cpRecordTypeMap.get('AS Retail Campaign').getRecordTypeId()== rc.RecordTypeId ){
                           rc.Approver__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Retail_AS_Owner__c;
                       }else if(rc.Brand__c == 'MB'){
                           rc.Approver__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Retail_MB_Owner__c;
                       }else if (rc.Brand__c == 'smart'){
                           rc.Approver__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Retail_smart_Owner__c;
                       }else if (rc.Brand__c == 'AMG'){
                           rc.Approver__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Retail_AMG_Owner__c;
                       }else if (rc.Brand__c == 'StarElite'){
                           rc.Approver__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Retail_Star_Elite_Owner__c;
                       }
                   }
                   if(rc.Approver__c == null && DealerIDAccount.containsKey(RCIdDealerId.get(rc.id))){
                       rc.Approver__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Ownerid;
                   }
               }
            
            // Set the region and sub region for Yearly TA
            if((cpRecordTypeMap.get(AfterSalesYearlyTa).getRecordTypeId() == rc.RecordTypeId ||
               rc.RecordTypeId == cpRecordTypeMap.get(RetailSmartBestPractice).getRecordTypeId() ||
               rc.RecordTypeId == cpRecordTypeMap.get(RetailMbBestPractice).getRecordTypeId()) && (RCIdDealerId.keyset().contains(rc.id) && DealerIDAccount.keyset().contains(RCIdDealerId.get(rc.id))) ) 
            {
                
                       
                    rc.Dealer_Region__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Dealer_Region__c;
                    rc.Dealer_Sub_Region__c = DealerIDAccount.get(RCIdDealerId.get(rc.id)).Dealer_MB_Sub_Region__c;
             
                
            }
            
            if(isUpdate && rc.Region_Recommendation__c && !retailCampainsOldMap.get(rc.Id).Region_Recommendation__c) {
                if(rc.RecordTypeId == cpRecordTypeMap.get(RetailMbBestPractice).getRecordTypeId() && 
                   (parCampaignRecommendBPNumbers.containsKey(rc.Parent_Campaign__c) && parCampaignRecommendCamNums.containsKey(rc.Parent_Campaign__c)) &&
                   (parCampaignRecommendCamNums.get(rc.Parent_Campaign__c) >= parCampaignRecommendBPNumbers.get(rc.Parent_Campaign__c))) 
                {
                    
                    
                    rc.addError('You can not choose any more Region Recommendation.');
                    
                    
                }
                if(rc.RecordTypeId == cpRecordTypeMap.get(RetailSmartBestPractice).getRecordTypeId() && 
                   (parCampaignRecommendCamNums.containsKey(rc.Parent_Campaign__c) && parCampaignRecommendCamNums.get(rc.Parent_Campaign__c) >= 2)) 
                {
                    
                    rc.addError('You can not choose any more Region Recommendation.'); 
                    
                } 
            }
            
            if(isUpdate && rc.Final_Best_Practice__c && !retailCampainsOldMap.get(rc.Id).Final_Best_Practice__c 
               && parentCamHasFinalBest.containsKey(rc.Parent_Campaign__c) && parentCamHasFinalBest.get(rc.Parent_Campaign__c) > 1) {
                   rc.addError('You can not choose any more Final Best Practice.');  
               }
            
            if(isUpdate && rc.Final_Best_Practice_Forsmart__c && !retailCampainsOldMap.get(rc.Id).Final_Best_Practice_Forsmart__c 
               && parentCamHasFinalBestForSmart.containsKey(rc.Parent_Campaign__c) && parentCamHasFinalBestForSmart.get(rc.Parent_Campaign__c) > 1) {
                   rc.addError('You can not choose any more Final Best Practice.');  
               }
            
            if(isUpdate && rc.Region_Best_Practice__c && !retailCampainsOldMap.get(rc.Id).Region_Best_Practice__c ) 
            {
                if(rc.RecordTypeId == cpRecordTypeMap.get(RetailMbBestPractice).getRecordTypeId() && 
                   (parCampaignBPNumbers.containsKey(rc.Parent_Campaign__c) && parCampaignRetailCamNums.containsKey(rc.Parent_Campaign__c))
                   && (parCampaignRetailCamNums.get(rc.Parent_Campaign__c) >= parCampaignBPNumbers.get(rc.Parent_Campaign__c))) 
                {
                    
                    
                    rc.addError('You can not choose any more Retail best Practice.');
                    
                    
                }
                if(rc.RecordTypeId == cpRecordTypeMap.get(RetailSmartBestPractice).getRecordTypeId() 
                   && (parCampaignRetailCamNums.containsKey(rc.Parent_Campaign__c) && parCampaignRetailCamNums.get(rc.Parent_Campaign__c) >= 2)) 
                {
                    
                    rc.addError('You can not choose any more Retail best Practice.'); 
                    
                }
            }
        }
        
        if(isInsert){
            for(Retail_Campaign__c cp: retailCampainsNew){
                if(cpRecordTypeMap.get(AfterSalesYearlyTa).getRecordTypeId() == cp.RecordTypeId 
                   || cpRecordTypeMap.get(SalesMktYrTa).getRecordTypeId() == cp.RecordTypeId && (cp.Y_Status__c == null))
                {
                    
                    
                    cp.Y_Status__c = 'Planned';
                    
                }
                
                if((cp.RecordTypeId == cpRecordTypeMap.get(RetailMbBestPractice).getRecordTypeId()
                    || cp.RecordTypeId == cpRecordTypeMap.get(RetailSmartBestPractice).getRecordTypeId()) && cp.Y_Dealer_Name__c != null && 
                   (existDealerIdCampaignIds.containsKey(cp.Brand__c + cp.Y_Dealer_Name__c + cp.Parent_Campaign__c) && existDealerIdCampaignIds.get(cp.Brand__c + cp.Y_Dealer_Name__c + cp.Parent_Campaign__c).size() >= 3)) 
                {
                    
                    if(UserInfo.getLanguage() != 'English') {
                        cp.addError('You can create up to 3 candidates campaign, please check again.');
                    }
                    else {
                        cp.addError('You only can create up to 3 retail candidates, Please try again.');
                    }
                    
                }
            }
        }
    }
}