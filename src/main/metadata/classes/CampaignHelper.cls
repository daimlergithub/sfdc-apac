/*
    Type:       helper class 
    ---------------------------------------------------------------
    History:
    
    2014-2-18 Created by Justin Yu
*/
public class CampaignHelper {
    
    private static String pending ='Pending';
    public static Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Campaign.getRecordTypeInfosByName();    // Campaign Record Type MAP
    public static Map<String, Schema.RecordTypeInfo> tkRecordTypeMap = Schema.SObjectType.Task.getRecordTypeInfosByName();
    public static string CacCampaign ='CAC Campaign';
    
    /**
  *@Description : Actions which are performed as a part of before Delete. This gets called from Campaign TriggerHandler
  which gets invoked by Trigger on Campaign Object. This method show error message when user try to delete if status is not planning
  and parent campaign is not Draft
  *@Date : 20/01/2017
  *@Author : Abhishekh Dasepalle
  
  
  */
  public static void beforeDeleteEvents(List<Campaign> campNew)
    {
    Id camIdExec = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    Id camIdPlan = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
       system.debug('++++++'+campNew);
       for(Campaign cam : campNew){

   if(cam.RecordTypeId == camIdExec && cam.Child_Campaign_Status__c != 'planning'){
          system.debug('+++++++++'+'checking');
            cam.addError(System.Label.deleting_campaign);
    
    }else if(cam.RecordTypeId == camIdPlan && cam.Status != 'Draft'){
   
            cam.addError(System.Label.deleting_campaign);
            system.debug('+++++++++'+'checking');
    
    }
    
    }
}
    
/***********************************************************************************
Created By          :    Abhishekh Dasepalle   
Created Date        :    30.01.2017
Company             :    NTT Data,Inc.
Usage               :    The functionality of this Class is to send email notification to the Dealer Sales Manager when List maintenance button is clicked 
                         Business Conditions :
                          * It sends Email Notification to dealer sales manager to start their list maintenance                           
JIRA NO             :    SFDCJP-1026                                               
************************************************************************************/
 public static void emailNotificationToDealer (List<Campaign > campList,Map<id,Campaign > oldCampList)  {
    
    Set<Id> sid = New Set<Id>();
    Set<Id> DealerIds = New Set<Id>();
    Set<Id> ParticipateIds = New Set<Id>();
  List<Id> userIds = new List<Id>();
  List<String> sDealerEmails = New List<String>();
  Set<String> mailSales = New Set<String>() ;
  Id camIdExec = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
  List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
  
  For(Campaign camp : campList){
  
   if(Camp.RecordTypeId == camIdExec && Camp.Ready_for_List_Maintenance__c == true && Camp.Ready_for_List_Maintenance__c != oldCampList.get(camp.id).Ready_for_List_Maintenance__c ){
   
   
        sid.add(Camp.Id);
         }
  
    
    
  }
  if(!System.isFuture() && !System.isBatch()){
     Batch_EmailNotification   batcher = New Batch_EmailNotification(sid);
           Database.executeBatch(batcher, 50);
       }
   }

   
    
   /* End Of SFDCJP-1026 */
   
   
   
   
   
  /*************************************************************************************************************************
Created Date        :    31.01.2017
Company             :    NTT Data,Inc.
Usage               :   On clicking on the Delete button Parent Campaign and associated Child execution campaign will be deleted,
                        if only child execution campaign will be in planning state else system will block the deletion process.
JIRA NO             :    SFDCJP-1024 */
/********************************************************************************************************************/
   
   Public static void beforeDeleteCampaignStatus(List<Campaign> CampDel)
{
Id parentCampaign = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
Id childCampaign= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
List<Campaign> childcamp=new List<Campaign>();
List<Campaign> Parentcamp=new List<Campaign>();
Set<Id> parecamId=new Set<Id>();

for(Campaign cmp: CampDel){
if(cmp.RecordTypeId == parentCampaign && cmp.Status == 'Draft'){
  parecamId.add(cmp.id);
   } 
  }

  if(parecamId!=null)
  {
childcamp=[select id from Campaign where ParentId=:parecamId];
}
if(childcamp!=null)
{
delete childcamp;
}
  
  if(Parentcamp!=null && childcamp.size()==0)
  {
  Parentcamp=[select id from Campaign where ID=:parecamId];
    delete Parentcamp;
    }
    
}

/*End of SFDCJP-1024   */
/***********************************************************************************
Created By          :    Abhishekh Dasepalle   
Created Date        :    8.01.2017
Company             :    NTT Data,Inc.
Usage               :    The functionality of this Class to make a copy of a campaign to Retail Campaign
                         Business Conditions :
                          Required For Joint Driven Campaign Implementaion                          
JIRA NO             :    SFDCJP-1044                                              
************************************************************************************/
   public static void copyCampaignToRetailCampaign(List<Campaign> campaignIds,Map<id,Campaign > oldCampList){
   
   List<Campaign> camListCheck = New List<Campaign>();
List<Retail_Campaign__c> retailCamParentList = New List<Retail_Campaign__c>();
List<Retail_Campaign__c> ret   = New List<Retail_Campaign__c>();
List<Retail_Campaign__c> tail    = New List<Retail_Campaign__c>();
List<Campaign> parentCampaignList = New List<Campaign>();
           
Set<id> sid = New Set<id>();
Set<id> aid = New Set<id>();
 Set<String> mailSales = New Set<String>(); 
    Id executionRecordId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    Id planningRecordId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
    Id executionRetailRecordId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    Id planningRecordRetailId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
        For(Campaign campNew : campaignIds){
            
            if( campNew.RecordTypeId==executionRecordId && campNew.Child_Campaign_Status__c =='Execution' && campNew.Set_List_Maintenance_Flag__c == false ){
            
                 sid.add(campNew.ParentId);
                 aid.add(campNew.Id);  
                 parentCampaignList.add(campNew);
            
        }else if (campNew.RecordTypeId==executionRecordId && campNew.Consolidated_List_Completed__c == true && campNew.Consolidated_List_Completed__c != oldCampList.get(campNew.id).Consolidated_List_Completed__c){
        
          sid.add(campNew.ParentId);
                 aid.add(campNew.Id); 
                 parentCampaignList.add(campNew);
        
        } 
        
        
       } 
       
       system.debug('+++++++++++'+sid);
       system.debug('++++++++++'+aid);
        if(sid.size() > 0){
      
      List<Campaign> camList =[Select id,Name,Campaign_Code__c,Campaign_Executer__c,Campaign_Type__c,StartDate,EndDate,Status,Event_Type__c,Description,Campaign_Execution_Channels__c,ActualCost,Brand__c,Class__c,BudgetedCost  From Campaign Where Id =: sid];
      List<Participating_Dealer__c> parDeal = [Select id,Campaign__c,Campaign__r.Parent.Campaign_Type__c,Dealer__c,Dealer__r.Dealer_Sales_Manager_Email__c,Dealer__r.Dealer_Aftersales_Manager_Email__c From Participating_Dealer__c Where Campaign__c =: aid];
     
        system.debug('+++++++++++'+camList);
        system.debug('++++++++++++'+ parDeal);
     
     If(camList.size() >0 && !camList.isEmpty()){ 
     
          
        Batch_JointDrivenCampaign  batcher = new Batch_JointDrivenCampaign(aid, camList,parentCampaignList);
            Database.executeBatch(batcher, 50);  
     
     
     
   
    
   
   
   
   }
   }
   }
         /**
  *@Description : Custom Clone button logic for campaign 
  *@Date : 30/03/2017
  *@Author : Dinesh Govindaswamy
  
  
  */

Public static void updateLogic(List<Campaign> campgn){
Id camIdExec = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    Id camIdPlan = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
id recId;
 List<Campaign> camUpdateList = new List<Campaign>();

 set<Id> sid = New Set<Id>();
           
                                   
                                   For(Campaign cam : campgn){
                                                   
                                                   
                                 if( cam.CloneCampaign__c!= null){
                                   sid.add(cam.CloneCampaign__c);
                                   system.debug('+++'+cam.CloneCampaign__c);
                                          
                                                                   
                                                   }
                                   }
             system.debug('++++++'+sid);

List<Campaign> CamList = [Select Id,Name,ParentId,StartDate,Use_Segmentation_Criteria__c,Segmentation_Date__c,Campaign_Status__c,Execution_Start_Date__c From Campaign Where ParentId =: sid];
system.debug('++++++'+CamList);
For(Campaign came : campgn){
For(Campaign camp : CamList ){
                
                
                Campaign camm = New Campaign();
                camm.Name = camp.Name;
                camm.ParentId = came.Id;
              camm.Segmentation_Date__c = came.StartDate+1;              
               camm.Execution_Start_Date__c = came.StartDate+2 ; 
                camm.Campaign_Status__c = camp.Campaign_Status__c;
              
               
                camm.RecordTypeId = camIdExec;
                                                                        
                camUpdateList.add(camm);
                
}
}

insert camUpdateList;

system.debug('++++++'+camUpdateList);

}
   
  /**
  *@Description : Actions which are performed as a part of before Insert/Update. This gets called from Campaign TriggerHandler
  which gets invoked by Trigger on Campaign Object. This method auto calculate Segementation date based on Working day and working month
  
  *@Author : Abhishekh Dasepalle
  
  
  */ 
   
 public static void useSegmentationCampaign(List<Campaign> campaignIdsBefore,map<id,Campaign> camOldMap,boolean isInsert,boolean isUpdate){      
        
   String rect ; 
   Integer Day;       
   String mont; 
   Integer NewDay;
   Set<Date> sid = New Set<Date>();
      
   Id executionRecordId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();       
        
   For(Campaign camp : campaignIdsBefore ){     
        
        
   if(isInsert && camp.RecordTypeId == executionRecordId   && camp.Use_Segmentation_Criteria__c == true || (isUpdate && camp.RecordTypeId == executionRecordId   && camp.Use_Segmentation_Criteria__c == true && (camp.SegWorkingDay__c != camOldMap.get(camp.id).SegWorkingDay__c || camp.SegWorkingMonth__c != camOldMap.get(camp.id).SegWorkingMonth__c ))){           
             rect = camp.SegWorkingDay__c ;  
             day =  Integer.valueOf(camp.SegWorkingDay__c);      
             //NewDay = 1;       
             if(camp.SegWorkingMonth__c == 'Jan'){      
                        
                 mont = '1';        
              }else if(camp.SegWorkingMonth__c == 'Feb'){       
                    
                 mont = '2';        
              } else if(camp.SegWorkingMonth__c == 'Mar'){      
                    
              mont = '3';       
              } else if(camp.SegWorkingMonth__c == 'Apr'){      
                    
              mont = '4';       
              } else if(camp.SegWorkingMonth__c == 'May'){      
                    
              mont = '5';       
              } else if(camp.SegWorkingMonth__c == 'Jun'){      
                    
              mont = '6';       
              } else if(camp.SegWorkingMonth__c == 'Jul'){      
                    
              mont = '7';       
              } else if(camp.SegWorkingMonth__c == 'Aug'){      
                    
              mont = '8';       
              } else if(camp.SegWorkingMonth__c == 'Sep'){      
                    
              mont = '9';       
              }else if(camp.SegWorkingMonth__c == 'Oct'){       
                    
              mont = '10';      
              }else if(camp.SegWorkingMonth__c == 'Nov'){       
                    
              mont = '11';      
              }else if(camp.SegWorkingMonth__c == 'Dec'){       
                    
              mont = '12';      
              }     
             String SampDate = String.ValueOf(datetime.now().year());       
             //String year = '2017';        
             String year = SampDate ; 
             Integer yearint = Integer.valueOf(SampDate);      
              Integer month = Integer.valueOf(mont);      
              Integer N = Integer.valueOf(rect );      
            /*  for ( NewDay = 1; NewDay  < day ; NewDay ++) {
           
           
            string stringDate = year + '-' + mont + '-' + NewDay ;                
             
             //Map<Date,List<Holiday>> holidayCheck = new Map<Date,List<Holiday>>([Select id,Name,ActivityDate From Holiday]);
 
             
             Camp.Segmentation_Date__c = dte ;
             }   */
             
             
             for(Holiday hol :[Select id,Name,ActivityDate From Holiday ]){
             
                //String DateFormat = String.ValueOf(hol.ActivityDate );
                 
                 sid.add(hol.ActivityDate);
             
             
             }
             
             Integer NewDays = 1;
             String stringDate = year + '-' + mont + '-' + NewDays ;
             Date dte = Date.valueOf(stringDate );   
           
             
             for(Integer k=1;k<N ;k++ ){
             
             Holidaychecker(dte,sid);
               dte = Holidaychecker(dte,sid);

               system.debug('+++++ return date +++++++'+dte); 
                dte = dte.addDays(1);                     
                        
                      
                    }
              Datetime dt = DateTime.newInstance(dte, Time.newInstance(0, 0, 0, 0));

             String dayOfWeek=dt.format('EEEE');
             System.debug('+++++++++++++++++++++++++++' + dayOfWeek);  
             
             if(dayOfWeek == 'Saturday'){
             
                  dte = dte+2;
             }else if(dayOfWeek == 'Sunday'){
             
                  dte = dte+1;
             
             }else {
                 dte = dte;
             
             } 
          

           if(sid.contains(dte)){
           
          dte = dte+1;
              
               Holidaychecker(dte,sid);
               
               dte=Holidaychecker(dte,sid);
               
              camp.Segmentation_Date__c = dte ; 
              }else{
                
             Camp.Segmentation_Date__c = dte ;
             
             system.debug('++++++++++++day+++++++'+dte);
             
             
                
}       
        
} 
}
}

Private static Date Holidaychecker( Date dte, set<Date> sid){

Datetime dt = DateTime.newInstance(dte, Time.newInstance(0, 0, 0, 0));

             String dayOfWeek=dt.format('EEEE');
             System.debug('+++++++++++++++++++++++++++' + dayOfWeek);  
             
             if(dayOfWeek == 'Saturday'){
             
                  dte = dte+2;
             }else if(dayOfWeek == 'Sunday'){
             
                  dte = dte+1;
             
             }else {
                 dte = dte;
             
             }
             
             system.debug('+++++++dayof week result+++++++'+dte );

           if(sid.contains(dte)){
           
           dte = dte+1;
           } else {
           
            dte = dte;
           }
           
           system.debug('+++ returnstatement+++++++'+dte);
           return dte;
          
           
}


/**
  *@Description : Actions which are performed as a part of before Delete. This gets called from Campaign TriggerHandler
  which gets invoked by Trigger on Campaign Object. This method updates the status of parent based on child campaign
  
  *@Author : Abhishekh Dasepalle
  
  
  */ 

  public static void parentCampaignSatus(List<Campaign> campaignparent,map<id,Campaign> camOldMap){ 
  
    Id executionRecordId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    Id planningRecordId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
  Set<id> sid = New Set<Id>();
  Set<id> aid = New Set<Id>();
  List<Campaign> camList = New List<Campaign>();
  List<Campaign> camListMain = New List<Campaign>();
  
            For(Campaign camMain : campaignparent){
            
            If(camMain.RecordTypeId == executionRecordId && camMain.Child_Campaign_Status__c != 'Planning' && CamMain.Child_Campaign_Status__c != camOldMap.get(CamMain.id).Child_Campaign_Status__c ){
                      
                      sid.add(camMain.ParentId);
            
            } 
            
        If(CamMain.RecordTypeId == planningRecordId  && CamMain.Status != camOldMap.get(CamMain.id).Status && CamMain.Status == 'Completed'){
      
                    aid.add(camMain.Id);
                    
   
   }
            
            
            }
              system.debug('++++++++++++++'+aid);
            if(sid.size()>0){
            List<Campaign> camMainList =[Select id,Status From Campaign where id =: sid];
            
            if(camMainList.size()>0){
            
               For(Campaign cam : camMainList ){
               
                 if(cam.Status != 'Ongoing' && cam.Status != 'Completed' ){
                 
                      cam.Status = 'Ongoing';
                      
                      camList.add(cam);
                 }
               }
            }
  
        if(camList.size()>0){
           Update camList;
        
        }
        }
        
        if(aid.size()>0){
        system.debug('++++++++++'+'Im In For Loop');
        
        List<Campaign> camChildList = [Select Id,ParentId,Child_Campaign_Status__c  From Campaign Where ParentId =: aid];
        system.debug('++++++++++++'+camChildList );
        
        if(camChildList.size()>0){
        
          For(Campaign cam : camChildList ){
          
             
             
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
   
    public static void copyTopCampaignStatusValueToSavedCampaign(Set<String> campaignIds){
        
 /**
  *@Description : Copies Top Campaigns Status value to Saved Campaign.
  *@Date : 3/11/2015
  *@param:Set of Campaign Ids.
  *@return:This mehtod does not return any value.
  */
        
        Set<String> topCampaignIds = new Set<String>();
        List<Campaign> campaigns = [select ParentId, Parent.ParentId from Campaign where Id in:campaignIds];
        for(Campaign cam : campaigns){
            if(cam.ParentId != null){
                topCampaignIds.add(cam.Parent.ParentId);
            }
        }
        
        List<CampaignMemberStatus> savedStatus = new List<CampaignMemberStatus>();
        for(CampaignMemberStatus status : [select CampaignId, HasResponded, IsDefault, Label, SortOrder from CampaignMemberStatus 
                                            where CampaignId in :topCampaignIds]){
                                            
            
            for(Campaign cam : campaigns){
                if(cam.Parent.ParentId == status.CampaignId){
                    CampaignMemberStatus newStatus = status.clone();
                    newStatus.CampaignId = cam.Id;
                    savedStatus.add(newStatus);
                }
            }
        }
        
        CampaignMemberStatus[] statuses = [select IsDefault, HasResponded from CampaignMemberStatus where CampaignId in :campaignIds];
        for(CampaignMemberStatus status : statuses){
            status.IsDefault = false;
            status.HasResponded = false;
        }
        update statuses;
        delete statuses;
        
        if(!savedStatus.isEmpty()){
            insert savedStatus;
        }
    }
    
    
    /**
      *@Description : Updates Campaign Member status to Related Campaigns.
      *@Date : 3/11/2015
      *@param:List of Campaign Members.
      *@return:This mehtod does not return any value.   
      */
    public static void updateCampaignMemberStatusToRelatedCampaign(List<CampaignMember> members){  
        Set<String> topCampaignIds = new Set<String>();
        Set<String> obcallCampaignIds = new Set<String>();
        Set<String> unknownCampaignIds = new Set<String>();
        Map<String, String> statusMap = new Map<String, String>();
        
        for(CampaignMember member : members){
            statusMap.put(member.ContactId, member.Status);
            
            if(member.Campaign_Execution_Type__c == 'OB Call' && member.Campaign.ParentId != null){
                topCampaignIds.add(member.Campaign.Parent.ParentId);
                obcallCampaignIds.add(member.CampaignId);
            }
            else{
                unknownCampaignIds.add(member.CampaignId);
            }
        }
        
        for(Campaign camp : [select Id, Parent.ParentId from Campaign where Parent.ParentId = :unknownCampaignIds and Execution_Type__c = 'OB Call']){
            topCampaignIds.add(camp.Parent.ParentId);
            obcallCampaignIds.add(camp.Id);
        }
        for(Campaign camp : [select Id from Campaign where Parent.ParentId = :topCampaignIds and Execution_Type__c = 'OB Call']){
            obcallCampaignIds.add(camp.Id);
        }
        
        Set<String> campaignIds = new Set<String>();
        campaignIds.addAll(topCampaignIds);
        campaignIds.addAll(obcallCampaignIds);
        campaignIds.remove(null);
        
        List<CampaignMember> updatedMembers = new List<CampaignMember>();
        for(CampaignMember mem : [select Status, ContactId from CampaignMember where CampaignId in :campaignIds and ContactId in :statusMap.keySet()]){
            String status = statusMap.get(mem.ContactId) ;
            if(status != null){
                mem.Latest_Status__c = status;
            }
            updatedMembers.add(mem);
        }
        
        if(!updatedMembers.isEmpty()){
            update updatedMembers;
        }
    }
    
    /**
      *@Description : Actions which are performed as a part of After Insert/Update. This gets called from Campaign TriggerHandler
                      which gets invoked by Trigger on Campaign Object.
      *@Date : 3/11/2015
      *@param:List of campaign.New. Campaign.Oldmap and indicator for Update.
      *@return:This mehtod does not return any value.
    
      */
    public static void afterInsertUpdateEvents(list<Campaign> campaignNew,map<id,Campaign> campaignOldMap, boolean isUpdate)
    {

        /* START Variable Definition    */
        Set<ID> cpIdSet = new Set<ID>(); // Campaign ID Set       
        List<Campaign> cpAccList = new List<Campaign>(); // Campaign Exection List by Contact 
        List<Campaign> cpLeadList = new List<Campaign>();  // Campaign Exection List by Lead 
        List<Campaign> cpVehicleList = new List<Campaign>(); // Campaign Exection List by Vehicle
        List<Campaign> cpCaseList = new List<Campaign>(); // Campaign Exection List by Case
        
        // Batch Job String Ids
        String cpAccIds = UtilConstant.Empty; // Campaign Id String
        String cpLeadIds = UtilConstant.Empty;
        String cpVehicleIds = UtilConstant.Empty;
        String cpCaseIds = UtilConstant.Empty;
        Batch_Job__c accJob = new Batch_Job__c(Batch_Type__c='Contact', Status__c=pending);
        Batch_Job__c leadJob = new Batch_Job__c(Batch_Type__c='Lead', Status__c=pending);
        Batch_Job__c vehJob = new Batch_Job__c(Batch_Type__c='Vehicle', Status__c=pending);
        Batch_Job__c caseJob = new Batch_Job__c(Batch_Type__c='Case', Status__c=pending);
        /* END Variable Definition  */
         System.debug('campaignNew>>>' + campaignNew);
        /* START Iterate Campaign to relevant campaign list */
        for(Campaign cp : campaignNew) {
            // All Activated Campaign Execution
            System.debug('campaignNew>>>' + campaignNew);
            if(cp.Create_Task__c && (isUpdate && !campaignOldMap.get(cp.Id).Create_Task__c) && 
                (cp.RecordTypeId == cpRecordTypeMap.get('Campaign Execution - Complex').getRecordTypeId() || 
                cp.RecordTypeId == cpRecordTypeMap.get('Campaign Execution - Simple').getRecordTypeId())) {
                
                if(cp.Task_Created_By__c == 'Contact') {
                    // Campaign Exection List by Contact 
                    cpAccList.add(cp); 
                    System.debug('cpAccList>>>' + cpAccList);
                    // Batch Job Ids String
                    cpAccIds = cpAccIds + ';' + String.valueof(cp.Id);
                } else if(cp.Task_Created_By__c == 'Lead') {
                    // Campaign Exection List by Lead
                    cpLeadList.add(cp);
                    // Batch Job Ids String
                    cpLeadIds = cpLeadIds + ';' + String.valueof(cp.Id);
                } else if(cp.Task_Created_By__c == 'Vehicle') {
                    // Campaign Exection List by Vehicle
                    cpVehicleList.add(cp);
                    // Batch Job Ids String
                    cpVehicleIds = cpVehicleIds + ';' + String.valueof(cp.Id);
                } else if(cp.Task_Created_By__c == 'Case') {
                    // Campaign Exection List by Case
                    cpCaseList.add(cp);
                    // Batch Job Ids String
                    cpCaseIds = cpCaseIds + ';' + String.valueof(cp.Id);
                }
            } else if (isUpdate && cp.isActive && !campaignOldMap.get(cp.Id).isActive && cp.RecordTypeId == cpRecordTypeMap.get(CacCampaign).getRecordTypeId()) {
                // CAC Campaign List
                cpIdSet.add(cp.id);
                List<Campaign> childCmpList = new List<Campaign>(); 
                for(Campaign childCAC : [Select Id From Campaign Where ParentId=:cp.Id And isActive=false And RecordTypeId=:cpRecordTypeMap.get(CacCampaign).getRecordTypeId()]){
                    childCAC.isActive = true;
                    childCmpList.add(childCAC);
                }
                
                try{
                    update childCmpList;
                }catch(DmlException ex){
                    cp.addError('You can not activate a campaign without any execution.');
                }

            }
        }
        /* END Iterate Campaign to relevant campaign list */
        
        /* START Campaign Excution create task update */
        List<Campaign> cpExeList = new List<Campaign>();
        
        if(!cpIdSet.isEmpty()) {
            for(Campaign cpExe : [select id, Create_Task__c from Campaign where ParentId in :cpIdSet ]) {
                cpExeList.add(new Campaign(id = cpExe.Id, Create_Task__c = true));
            }
        }

        if(!cpExeList.IsEmpty()) update cpExeList;
        /* END Campaign Excution create task update */
        
        System.debug('cpVehicleList >>>' + cpVehicleList);
             System.debug('cpAccList>>>' + cpAccList);
        /* START Batch Execution */
        if(!cpAccList.isEmpty()) {          
            database.executeBatch(new UtilCampaignTaskGenerationByAccount(cpAccList), 200);
            accJob.Campaign_Set__c = cpAccIds;
            if(accJob!=Null){
            insert accJob;
            }
        }
        
        if(!cpLeadList.isEmpty()) {         
            //database.executeBatch(new UtilCampaignTaskGenerationByLeads(cpLeadList), 200);
            leadJob.Campaign_Set__c = cpLeadIds;
            if(leadJob!=Null){
             insert leadJob;       
            }  
        }
        if(!cpVehicleList.isEmpty()) {          
            //database.executeBatch(new UtilCampaignTaskGenerationByVehicle(cpVehicleList), 200); 
            vehJob.Campaign_Set__c = cpVehicleIds;
            insert vehJob; 
        }
        if(!cpCaseList.isEmpty()) {          
            //database.executeBatch(new UtilCampaignTaskGenerationByCase(cpCaseList), 200); 
            caseJob.Campaign_Set__c = cpCaseIds;
            insert caseJob; 
        }
        /* END Batch Execution */
    
    }
	
	public static void updateDueDateOnCampaignTask(list<Campaign> campaignList, map<Id, Campaign> campaignOldMap)
	{
		list<Task> taskList = new list<Task>();
		list<Task> updateTaskList = new list<Task>();
		Id obCallTaskId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
    	Id obTaskId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Task').getRecordTypeId();
		if(campaignOldMap != null && !campaignOldMap.isEMpty())
		{
			taskList = [select Id,ActivityDate, Status, RecordtypeId from Task where WhatId in : campaignOldMap.keySet()];
		}
		if(campaignList != null && !campaignList.isEmpty() && taskList != null && !taskList.isEmpty())
		{
			for(Campaign campgn: campaignList)
			{
				if(campgn.EndDate != campaignOldMap.get(campgn.Id).EndDate)
				{
					for(Task tsk : taskList)
					{
						if((tsk.RecordtypeId != obCallTaskId || tsk.RecordtypeId != obTaskId) && tsk.Status != 'Cancelled')
						{
							tsk.ActivityDate = campgn.EndDate;
							updateTaskList.add(tsk);
						}
					}
				}				
			}
		}
		if(updateTaskList != null && !updateTaskList.isEmpty())
		{
			update updateTaskList;
		}		
	}
    
    
     /**
      *@Description : Actions which are performed as a part of Before Insert/Update. This gets called from Campaign TriggerHandler
      which gets invoked by Trigger on Campaign Object.
      *@Date : 3/11/2015
      *@param:List of campaign.New. Campaign.Oldmap.
      *@return:This mehtod does not return any value.
      */ 
    public static void beforeUpdateEvents(list<Campaign> campaignNew,map<id,Campaign> campaignOldMap)
    {
      
        Id cmpExeReTpIdS = cpRecordTypeMap.get('Campaign Execution - Simple').getRecordTypeId();
        Id cmpExeReTpIdC = cpRecordTypeMap.get('Campaign Execution - Complex').getRecordTypeId();
        Set<Id> campaignIds = new Set<Id>();
        for(Campaign cp : campaignNew) {
            if (cp.isActive && !campaignOldMap.get(cp.Id).isActive && cp.RecordTypeId == cpRecordTypeMap.get(CacCampaign).getRecordTypeId())
            {
                 campaignIds.add(cp.Id);
            }
        }
        
        Map<Id, Integer> CampaignCMPExes = new Map<Id, Integer>();
        for(Campaign cmp : [Select Id, ParentId from Campaign Where ParentId in :campaignIds And (RecordTypeId=:cmpExeReTpIdS Or RecordTypeId=:cmpExeReTpIdC)])
        {
            if(!CampaignCMPExes.containsKey(cmp.ParentId))
            {
                 CampaignCMPExes.put(cmp.ParentId, 0);
            }
            CampaignCMPExes.put(cmp.ParentId, CampaignCMPExes.get(cmp.ParentId) + 1);
        }
        
        for(Campaign cp : campaignNew) {
            if ((cp.isActive && !campaignOldMap.get(cp.Id).isActive && cp.RecordTypeId == cpRecordTypeMap.get(CacCampaign).getRecordTypeId()) && (CampaignCMPExes.get(cp.Id) < 1))
            {
                
                    cp.addError('You can not activate a campaign without any execution.');
                                
            }
        }
    }
    /**
  *@Description : Actions which are performed as a part of before Delete. This gets called from Campaign TriggerHandler
  which gets invoked by Trigger on Campaign Object. This method contains Date validations on Parent and Child Campaign
  
  *@Author : Abhishekh Dasepalle
  
  
  */
      public static void validationParentCampaign(List<Campaign> CamList,map<id,Campaign> camOldMap,boolean isInsert,boolean isUpdate){
   
   Id parentCampaignId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
    Set<Id> sid =  New Set<Id>();      
          
           For(Campaign Camp : CamList){
           
           if(isInsert && Camp.RecordTypeId == parentCampaignId || (isUpdate && Camp.RecordTypeId == parentCampaignId  && (Camp.StartDate  != camOldMap.get(Camp.id).StartDate ))){
           
               
                 If(Camp.StartDate < System.Today()){
                 
                   Camp.addError(system.Label.Campaign_Date_1);   
                 
                 }
                 
                 If(Camp.EndDate < Camp.StartDate){
                 
                       Camp.addError(system.Label.Campaign_Date_2);
                 }
                  
           
}
   


}
   
 }
 
 public static void validationChildCampaign(List<Campaign> campListMain,map<id,Campaign> camOldMap,boolean isInsert,boolean isUpdate){
 
 Id childCampaign= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
 Set<Id> sid = New Set<Id>(); 
 Set<Id> aid = New Set<Id>(); 
         
          
           For(Campaign Camp : campListMain){
           
if( isInsert && Camp.RecordTypeId == childCampaign || (isUpdate && Camp.RecordTypeId == childCampaign && (Camp.Segmentation_Date__c != camOldMap.get(Camp.id).Segmentation_Date__c  || Camp.Execution_Start_Date__c  != camOldMap.get(Camp.id).Execution_Start_Date__c || Camp.Response_Date__c   != camOldMap.get(Camp.id).Response_Date__c ))){
                  
                    system.debug('+++++++++++++++'+'WORKING' );
                         sid.add(Camp.ParentId);
                         
                         
                         }
       if( isInsert && Camp.RecordTypeId == childCampaign){
       
                    aid.add(Camp.ParentId); 
        }
                         
                  }
                  
                  
                  if(sid.size() > 0){
                  
                  
                  List<Campaign> CamList = [Select id,StartDate,EndDate from Campaign Where Id =:sid];
                  
                  system.debug('+++++++++++++++'+CamList );
                  For(Campaign ca : CamList){
                  
                     For(Campaign campan : campListMain ){
                     
                     system.debug('+++++++++++++++'+ca.StartDate );
                     if(isInsert &&(campan.Segmentation_Date__c < System.Today() ||campan.Segmentation_Date__c > ca.EndDate || campan.Segmentation_Date__c < ca.StartDate )|| isUpdate && campan.Segmentation_Date__c  !=camOldMap.get(campan.id).Segmentation_Date__c  && (campan.Segmentation_Date__c < System.Today() ||campan.Segmentation_Date__c > ca.EndDate || campan.Segmentation_Date__c < ca.StartDate)  ){
                     
                         campan.addError(System.Label.Campaign_Date_3);
                         
                     
                     }
                     
                     if(isInsert && (campan.Execution_Start_Date__c < System.Today() || campan.Execution_Start_Date__c > ca.EndDate || campan.Execution_Start_Date__c <= campan.Segmentation_Date__c  )||isUpdate && campan.Execution_Start_Date__c !=camOldMap.get(campan.id).Execution_Start_Date__c && (campan.Execution_Start_Date__c < System.Today() || campan.Execution_Start_Date__c > ca.EndDate || campan.Execution_Start_Date__c <= campan.Segmentation_Date__c  )){
                     
                     
                            campan.addError(System.Label.Campaign_Date_4);
                     }
                  if(isInsert &&(campan.Response_Date__c < System.Today() || campan.Response_Date__c  > ca.EndDate || campan.Response_Date__c <= campan.Execution_Start_Date__c ) || isUpdate && campan.Response_Date__c  !=camOldMap.get(campan.id).Response_Date__c && (campan.Response_Date__c < System.Today() || campan.Response_Date__c  > ca.EndDate || campan.Response_Date__c <= campan.Execution_Start_Date__c)) {
                     
                     
                            campan.addError(System.Label.Campaign_Date_5);
                     }
                  }
               }
     }
     
     
     if(aid.size()>0){
     
     List<Campaign> ParentCampaign = [Select id, Status From Campaign Where Id =: aid ];
      For(Campaign cam : ParentCampaign ){
      
      For(Campaign childCam :campListMain){
         if(cam.Status == 'Completed'){
         childCam.addError('Cant add Child Campaign When Parent Status is Completed');
       
       }
      } 
     }
     
     }
 
}
    /**
     * 2014-2-17 added by Justin for copying the status
     *  in the top level campaign to the OB campaign
     */
     
 /**
  *@Description : Actions which are performed as a part of After Insert. This gets called from Campaign TriggerHandler
  This method sends the campaigns with execution type = OB Call  to method copyTopCampaignStatusValueToSavedCampaign().
  which gets invoked by Trigger on Campaign Object.
  *@Date : 3/11/2015
  *@param:List of campaign.New. 
  *@return:This mehtod does not return any value.
  */
    public static void afterInsertEvents(list<Campaign> campaignNew)
    {
        Set<String> campaignIds = new Set<String>();
        for(Campaign campaign : campaignNew){
            if(campaign.Execution_Type__c == 'OB Call')
            {
                campaignIds.add(campaign.Id);
            }
        }
        if(campaignIds!=null && !campaignIds.isEmpty())
            copyTopCampaignStatusValueToSavedCampaign(campaignIds);
    }
    
    /**
  *@Description : Avoiding Duplication of Campaign Members 
  *@Date : 3/11/2015
  *@param:List of campaign.New. 
  *@return:This mehtod does not return any value.
  */
    public static void blankUpdateCM(list<Campaign> campaignNew,map<id,Campaign> campaignOldMap)
    {
        
       Set<Id> Campid=new Set<Id>();
       List<Campaign_Member__c> campmemlist =new List<Campaign_Member__c>();
        system.debug('###Update is called');
        for(Campaign campp: campaignNew)
        { 
           
          if(campp.MD__c == 'JP' && campp.Segmentation_Base__c != campaignOldMap.get(campp.Id).Segmentation_Base__c)
           {
             Campid.add(campp.id);
             system.debug('campp####'+Campid);
           }
        }
        
         campmemlist = [Select id,Campaign_ID__c from Campaign_Member__c where Campaign_ID__c = :Campid];
         try{
         update campmemlist;
         }catch(Exception Ex){
             System.debug('Duplicate Campaign Error Exception Message'+Ex.getMessage());
         }
        

    }
    
 /**
  *@Description : Actions which are performed as a part of After Update. This gets called from Campaign TriggerHandler
  which gets invoked by Trigger on Campaign Object. This method picks up the campaigns with SMS Task verified = true and updates it to flase if their parent campaign is a 
  repeated campaign.  
  *@Date : 3/11/2015
  *@param:List of campaign.New and Campaign.Old.
  *@return:This mehtod does not return any value.
  */
    public static void afterUpdateEvents(list<Campaign> campaignNew,list<Campaign> campaignOld)
    { 
        List<Id> cpSIds = new List<Id>();
        
        
        
        for(Integer j=0; j<campaignNew.size(); j++)
        {
            if(campaignNew[j].SMS_Task_Verified__c != campaignOld[j].SMS_Task_Verified__c && campaignNew[j].SMS_Task_Verified__c )
            {
                cpSIds.add(campaignNew[j].Id);
            }
        }
        if(!cpSIds.isEmpty())
        {
            List<Campaign> cpExes = [SELECT Id, SMS_Task_Verified__c, Parent.Repeated_Campaign__c FROM Campaign WHERE Id in :cpSIds AND Parent.Repeated_Campaign__c = true];
            if(cpExes!=null && !cpExes.isEmpty())
            {
                for(Campaign cpe : cpExes)
                {
                    cpe.SMS_Task_Verified__c = false;
                }
                update cpExes;
            }
        }
    }
    
     
 /**
  *@Description : Actions which are performed as a part of After Insert/Update. This gets called from Campaign TriggerHandler
  which gets invoked by Trigger on Campaign Object.
  This method updates the campaignshares. Shares campaign to Participating Dealers.
  *@Date : 3/11/2015
  *@param:List of campaign.New. Map Campaign.Oldmap.
  *@return:This mehtod does not return any value.
  */
    public static void afterInsertEvents_CampaignShare(list<Campaign> campaignNew,map<id,Campaign> campaignOldMap)
    {
        //Added community license switching mechanism
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
        {
            Id pIdDealerUser = null;
            Id pIdDealerAdmin = null;
            for (Profile pro : [select Id, Name from Profile where Name = 'Dealer Community User' or Name = 'Dealer Delegate Admin'])
            {
                if (pro.Name == 'Dealer Community User')
                {
                    pIdDealerUser = pro.Id;
                } else
                {
                    pIdDealerAdmin = pro.Id;
                }
            }
            
            Id rtIdMbBp = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('MB Best Practice').getRecordTypeId();
            Id rtIdSmartBp = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('smart Best Practice').getRecordTypeId();
            Id rtIdSmEvent = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Event Central Campaign').getRecordTypeId();
            Id rtIdSmMedia = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('S&M Media Central Campaign').getRecordTypeId();
            Id rtIdAs = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('AS Central Campaign').getRecordTypeId();
            Set<Id> cpnRtIds = new Set<Id>{rtIdMbBp, rtIdSmartBp, rtIdSmEvent, rtIdSmMedia, rtIdAs};
            Set<Id> cpnIds = new Set<Id>();
            Set<Id> dealerIds = new Set<Id>();
            Map<Id, String> cpnPermSetMap = new Map<Id, String>();
            Map<Id, Set<Id>> cpnDealerMap = new Map<Id, Set<Id>>();
            List<CampaignShare> cpnShares = new List<CampaignShare>();
            List<Task> taskList = new List<Task>();
            Set<Id> mbBpCampaignIds = new Set<Id>();
            Map<Id, Id> dealerBrandOwnerIds = new Map<Id, Id>();
            String pSetAsRetail = 'AS_Retail_Campaign';
            String pSetSmRetail = 'S_M_Retail_Campaign';
            String pSetBp = 'Best_Practise';
            
            for(Campaign cpNew : campaignNew)
            {
                if (cpnRtIds.contains(cpNew.RecordTypeId) && cpNew.Status == 'Published' && campaignOldMap.get(cpNew.Id).Status != 'Published')
                {
                    cpnIds.add(cpNew.Id);
                    if (cpNew.RecordTypeId == rtIdAs)
                    {
                        cpnPermSetMap.put(cpNew.Id, pSetAsRetail);
                    } 
                    else if (cpNew.RecordTypeId == rtIdSmEvent || cpNew.RecordTypeId == rtIdSmMedia)
                    {
                        cpnPermSetMap.put(cpNew.Id, pSetSmRetail);
                    } 
                    else 
                    {
                        cpnPermSetMap.put(cpNew.Id, pSetBp);
                    }
                    if (cpNew.RecordTypeId == rtIdMbBp)
                    {
                        mbBpCampaignIds.add(cpNew.Id);
                    }
                }
            }
            
            if (cpnIds.isEmpty()) {
                return;
            }
            
            for (Participating_Dealer__c pd : [Select Campaign__c, Dealer__c, Dealer__r.Retail_MB_Owner__c from Participating_Dealer__c Where Campaign__c In :cpnIds])
            {
                if (cpnDealerMap.get(pd.Campaign__c) == null)
                {
                    cpnDealerMap.put(pd.Campaign__c, new Set<Id>());
                }
                cpnDealerMap.get(pd.Campaign__c).add(pd.Dealer__c);
                dealerIds.add(pd.Dealer__c);
                if (pd.Dealer__r.Retail_MB_Owner__c != null)
                {
                    dealerBrandOwnerIds.put(pd.Dealer__c, pd.Dealer__r.Retail_MB_Owner__c);
                }
            }
            
            for (User u : [select Id, ProfileId, AccountId, ContactId, Contact.Permission_Set_Settings__c from User where AccountId in :dealerIds and isActive = true and (ProfileId = :pIdDealerAdmin or (ProfileId = :pIdDealerUser and Contact.Permission_Set_Settings__c includes(:pSetAsRetail, :pSetSmRetail, :pSetBp)))])
            {
                for (Id cpnId : cpnIds)
                {
                    if (cpnDealerMap.get(cpnId) != null && cpnDealerMap.get(cpnId).contains(u.AccountId) && (u.ProfileId == pIdDealerAdmin || (u.Contact.Permission_Set_Settings__c != null && u.Contact.Permission_Set_Settings__c.contains(cpnPermSetMap.get(cpnId)))))
                    {
                        CampaignShare share = new CampaignShare();
                        share.CampaignAccessLevel = UtilConstant.read_Access;
                        share.CampaignId = cpnId;
                        share.UserOrGroupId = u.id;
                        cpnShares.add(share);
                        taskList.add(new Task(
                            Subject= 'You have new joint marketing activities to participate in.', 
                            RecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('General Task').getRecordTypeId(),
                            OwnerId = u.id,
                            Status = 'open',
                            WhoId = u.ContactId,
                            WhatId = cpnId,
                            ActivityDate = date.today()));
                    }
                }
            }
            
            for (Id cpnId : mbBpCampaignIds)
            {
                if (cpnDealerMap.get(cpnId) != null)
                {
                    for (Id dealerId : cpnDealerMap.get(cpnId))
                    {
                        if (dealerBrandOwnerIds.get(dealerId) != null)
                        {
                            CampaignShare share = new CampaignShare();
                            share.CampaignAccessLevel = UtilConstant.read_Access;
                            share.CampaignId = cpnId;
                            share.UserOrGroupId = dealerBrandOwnerIds.get(dealerId);
                            cpnShares.add(share);
                        }
                    }
                }
            }
            
            // Insert sharing records
            if (!cpnShares.isEmpty()) {
                try {
                    insert cpnShares;
                } catch (DMLException e) {
                    System.debug('DMLException Exception occured when sharing Campaign to Participating Dealer: ' + e);
                }
            }
            if(!taskList.isEmpty()){
                try {
                    insert taskList;
                }
                catch(Exception ex) {
                    System.debug('Exception message is :' + ex.getMessage());
                }
            }
        }
    }
   
  /*********************************************************************************
	Method Name  : shareCampaignPlainingAndDesignRecordsWithDealers
	Created By   : 
	Created Date : 13th November 2017
	Project      : Daimler APAC
	Usages       : This method would share the Campaign records to the dealer based on below 2 conditions.
				   1. Campaign Planning and Campaign Design records will be shared with all Dealers.
				   2. Campaign Execution will be shared with Dealers who have retail copy of the customer 
				      who are associated as campaign member to the Campaign Exection. Dealer company as well gets the access.
	
	***********************************************************************************/
	   
    public static void shareCampaignPlainingAndDesignRecordsWithDealers (list<Campaign> campaignList)
    {
    	if(userinfo.getUserType()!= 'PowerPartner')
    	{
    		Id campPlngRecTypId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
	        Id campDsgnRecTypId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CAC Campaign').getRecordTypeId();
	        Id campExeRecTypId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution MBK - Wholesale to Dealer').getRecordTypeId();
			Id dealerAccntRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
	    	list<CampaignShare> insertCampaignShareList = new list<CampaignShare>();
	    	set<string> dealerNDCodeSet = new set<string>();
	    	set<string> dealerCompNDCodeSet = new set<string>();
	    	set<Id> dealerCompGroupIdSet = new set<Id>();
	    	list<Group> dealerGroupList = new list<Group>();
	    	list<Account> dealerAccountList = [select Id, Dealer_ND_Code__c, Dealer_Type__c from Account where recordtypeId =: dealerAccntRecTypId and MD__c = 'KR'];
	    	
	    	if(!dealerAccountList.isEmpty() && dealerAccountList != null)
	    	{
	    		for(Account dlrAcnt : dealerAccountList)
		    	{
		    		if(dlrAcnt.Dealer_Type__c == 'Company')
		    		{
		    			dealerCompNDCodeSet.add(dlrAcnt.Dealer_ND_Code__c);
		    		}
		    		dealerNDCodeSet.add(dlrAcnt.Dealer_ND_Code__c);
		    	}
	    	}
	    	if(!dealerNDCodeSet.isEmpty() && dealerNDCodeSet != null)
	    	{
	    		dealerGroupList = [select Id, Name from Group where Name in : dealerNDCodeSet];
	    	}
	    	
	    	for(Campaign campn: campaignList)
	    	{
	    		if(campn.recordtypeId == campPlngRecTypId || campn.recordtypeId == campDsgnRecTypId)
	    		{
	    			for(Group dlrGrp : dealerGroupList)
	    			{
	    				CampaignShare campShare = new CampaignShare();
	    				campShare.CampaignId = campn.Id;
	    				campShare.CampaignAccessLevel = 'Read';
	    				campShare.UserOrGroupId  = dlrGrp.Id;
	    				insertCampaignShareList.add(campShare);
	    			}
	    		}
	    		else if(campn.recordtypeId == campExeRecTypId)
	    		{
	    			for(Group dlrGrp : dealerGroupList)
	    			{
	    				if(dealerCompNDCodeSet.contains(dlrGrp.Name))
	    				{
	    					CampaignShare campShare = new CampaignShare();
		    				campShare.CampaignId = campn.Id;
		    				campShare.CampaignAccessLevel = 'Read';
		    				campShare.UserOrGroupId  = dlrGrp.Id;
		    				insertCampaignShareList.add(campShare);
	    				}
	    			}
	    		}
	    	}
	    	if(!insertCampaignShareList.isEmpty() && insertCampaignShareList != null)
	    	{
	    		insert insertCampaignShareList;
	    	}
    	}
    }
	
	/*
	   Description : SFDCKR-1558 campaign sharing for dealers
	   Release-K10
	*/
	
public static void afterInsertSharefromSCtoMan(list<Campaign> campaignNew)
{
if(userinfo.getUserType()== 'PowerPartner')
{
Set<ID> getownerId = new Set<ID>();
set<id> tlid= new set<id>();
set<string> DHQshare= new set<String>();
Set<String> getDealerGCCode= new Set<String>();
Set<String> getDealerNDCode= new Set<String>();
Set<String> getDealerRoleCode= new Set<String>();
List<CampaignShare> campshare = new List<CampaignShare>();
map<string,id> assgroupMap = new map<string,id>();
List<Group> grplist=new List<Group>();
List<User> Toptobotshare =new list<user>();
List<User> dealerhqshare =new list<user>();
 Id campPlngRecTypId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
 Id campDsgnRecTypId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CAC Campaign').getRecordTypeId();
 Id campExeRecTypId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution - Complex').getRecordTypeId();
 Id dealerRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            
system.debug('i am here');

system.debug('i am here');
   for(Campaign cp : campaignNew) {
   if(cp.MD__c == 'KR')
   {
    getownerId.add(cp.OwnerId);
    }
    }
    
    System.debug('getDealerRoleCode---'+getownerId);
   
    Map<ID, User> usershare = new Map<ID, User>([Select Id,Dealer_ND_Code__c,Contact.Account.Dealer_Type__c,Contact.Account.Dealer_GC_Code__c,Dealer_GC_Code__c,MBK_Partner_Roles__c,MBK_Reporting_Partner_User__c,MBK_Reporting_Partner_User__r.MBK_Reporting_Partner_User__c, Contact.Dealer_Complaint_Gate_Keeper__c, Contact.Dealer_Lead_Gate_Keeper__c from User where id in: getownerId and Market__c = 'KR']);
    System.debug('ownerlist---'+usershare);
    
    

    if(usershare != null)
    {
      for(User u : usershare.values())
      {
         getDealerGCCode.add(u.Dealer_GC_Code__c);
        if(u.MBK_Partner_Roles__c == 'Team Leader' || u.MBK_Partner_Roles__c == 'Sales Manager')
        {
          tlid.add(u.id);
        }
        else if(u.Contact.Account.Dealer_Type__c == 'Company' && u.Contact.Account.Dealer_GC_Code__c !=null)
        {
          DHQshare.add(u.Contact.Account.Dealer_GC_Code__c);
        }
      }
    }
    system.debug('tliddd----'+tlid);
    List<Account> acc =[Select id,Dealer_ND_Code__c,Dealer_GC_Code__c,Dealer_Type__c from Account where Dealer_GC_Code__c IN: getDealerGCCode and Dealer_Type__c='Company' and MD__c = 'KR' and recordtypeid =: dealerRecTypId];
    system.debug('acc---'+acc);
    for(Account acclis : acc)
    {
      if(acclis.Dealer_Type__c == 'Company')
       {
       getDealerNDCode.add(acclis.Dealer_ND_Code__c);
       }
    }
    
    
    if(!tlid.isEmpty() && tlid != null)
    {
    Toptobotshare=[Select Id,Dealer_ND_Code__c,Dealer_GC_Code__c,MBK_Partner_Roles__c,MBK_Reporting_Partner_User__c,MBK_Reporting_Partner_User__r.MBK_Reporting_Partner_User__c from User where (MBK_Reporting_Partner_User__c in: tlid or MBK_Reporting_Partner_User__r.MBK_Reporting_Partner_User__c in: tlid) and Market__c = 'KR' and IsActive=true];
    }
    if(DHQshare != null && !DHQshare.isEmpty())
    {
    dealerhqshare = [Select Id,Dealer_ND_Code__c,Contact.Account.Dealer_Type__c,Dealer_GC_Code__c,MBK_Partner_Roles__c,MBK_Reporting_Partner_User__c,MBK_Reporting_Partner_User__r.MBK_Reporting_Partner_User__c from User where Dealer_GC_Code__c in: DHQshare and Market__c = 'KR' and Contact.Account.Dealer_Type__c = 'Outlet' and IsActive=true];
    }
    system.debug('Toptobotshare---'+Toptobotshare);
    
    if(!getDealerNDCode.isEmpty() && getDealerNDCode != null)
     {
    grplist = [select id ,Name ,Type from Group where Name IN: getDealerNDCode];
     }
    if(grplist != null)
     {
     for(Group assg:grplist)
      {               
    assgroupMap.put(assg.Name, assg.id);
    system.debug('assg.Name'+assg.Name);
      }
     }
     //If sales consultant creates record
     
     for(Campaign cams : campaignNew) {
          if(!usershare.containsKey(cams.ownerid))continue;
            user u = usershare.get(cams.ownerid);
           if(u.MBK_Partner_Roles__c != '' || u.MBK_Partner_Roles__c != 'Null')
           {
          if(u.MBK_Partner_Roles__c == 'Sales Consultant') {
        system.debug('Team Leader' +u.MBK_Reporting_Partner_User__c);
            if(u.MBK_Reporting_Partner_User__c!=null) {
                CampaignShare shareRec = new CampaignShare();
                shareRec.CampaignId = cams.Id;
                shareRec.UserOrGroupId  = u.MBK_Reporting_Partner_User__c;
                shareRec.CampaignAccessLevel  = 'Edit';
                campshare.add(shareRec);
            }
            if(u.MBK_Reporting_Partner_User__r.MBK_Reporting_Partner_User__c!=null) {
                CampaignShare shareRec1 = new CampaignShare();
                shareRec1.CampaignId = cams.Id;
                shareRec1.UserOrGroupId  = u.MBK_Reporting_Partner_User__r.MBK_Reporting_Partner_User__c;
                shareRec1.CampaignAccessLevel  = 'Edit';
                campshare.add(shareRec1);  
            }  
           
             for(id NDgroup:assgroupMap.values())
             { 
               CampaignShare shareRec1 = new CampaignShare();
                shareRec1.CampaignId = cams.Id;
                shareRec1.UserOrGroupId  = NDgroup;
                shareRec1.CampaignAccessLevel  = 'Edit';
                campshare.add(shareRec1); 
             
             }
        }   
        }
     if(u.Contact.Account.Dealer_Type__c == 'Outlet' && u.Contact.Dealer_Complaint_Gate_Keeper__c == true && u.Contact.Dealer_Lead_Gate_Keeper__c == true)
           {
             for(id NDgroup:assgroupMap.values())
             { 
               CampaignShare shareRec1 = new CampaignShare();
                shareRec1.CampaignId = cams.Id;
                shareRec1.UserOrGroupId  = NDgroup;
                shareRec1.CampaignAccessLevel  = 'Edit';
                campshare.add(shareRec1); 
             
             }
           }    		
      }
     
     // IF Team Leader Share Process  
    
    for(Campaign camstl : campaignNew) {
        if(!usershare.containsKey(camstl.ownerid))continue;
            user tlu = usershare.get(camstl.ownerid);
        if(tlu.MBK_Partner_Roles__c == 'Team Leader' || tlu.MBK_Partner_Roles__c == 'Sales Manager') {
        system.debug('Sales Manager' +tlu.MBK_Reporting_Partner_User__c);
        
            if((tlu.MBK_Reporting_Partner_User__c!=null)) 
            {
                CampaignShare tlshareRec = new CampaignShare();
                tlshareRec.CampaignId = camstl.Id;
                tlshareRec.UserOrGroupId  = tlu.MBK_Reporting_Partner_User__c;
                tlshareRec.CampaignAccessLevel = 'Edit';
                campshare.add(tlshareRec);  
             }
            for(id NDgroup:assgroupMap.values())
             { 
               CampaignShare shareRec1 = new CampaignShare();
                shareRec1.CampaignId = camstl.Id;
                shareRec1.UserOrGroupId  = NDgroup;
                shareRec1.CampaignAccessLevel  = 'Edit';
                campshare.add(shareRec1); 
             }
         
            if(camstl.recordtypeId == campPlngRecTypId || camstl.recordtypeId == campDsgnRecTypId)
            {
            system.debug('camstl.recordtypeId---'+camstl.recordtypeId);
            for(User topdown : Toptobotshare)
            {
               CampaignShare topshareRec = new CampaignShare();
                topshareRec.CampaignId = camstl.Id;
                topshareRec.UserOrGroupId  = topdown.id;
                topshareRec.CampaignAccessLevel = 'Edit';
                campshare.add(topshareRec);
            }
            }
            
      }
    } 
    
    //Delaer company share
     for(Campaign camsdq : campaignNew) {
     if(!usershare.containsKey(camsdq.ownerid))continue;
            user dqshare = usershare.get(camsdq.ownerid);
         if((camsdq.recordtypeId == campPlngRecTypId || camsdq.recordtypeId == campDsgnRecTypId) && dqshare.Contact.Account.Dealer_Type__c == 'Company')
            {
               for(User topdownhq : dealerhqshare)
               {
                 CampaignShare topDqshareRec = new CampaignShare();
                 topDqshareRec.CampaignId = camsdq.Id;
                 topDqshareRec.UserOrGroupId  = topdownhq.id;
                 topDqshareRec.CampaignAccessLevel = 'Edit';
                 campshare.add(topDqshareRec);
               }
			    
            }  
        if((camsdq.recordtypeId == campPlngRecTypId || camsdq.recordtypeId == campDsgnRecTypId || camsdq.recordtypeId == campExeRecTypId) && dqshare.Contact.Account.Dealer_Type__c == 'Company')
               {
                for(id NDgroup:assgroupMap.values())
               { 
               CampaignShare shareRec1 = new CampaignShare();
                shareRec1.CampaignId = camsdq.Id;
                shareRec1.UserOrGroupId  = NDgroup;
                shareRec1.CampaignAccessLevel  = 'Edit';
                campshare.add(shareRec1); 
               }
               }  			
            
     }  
     system.debug('campshare --'+campshare);
     If(campshare != null & campshare.size() > 0) {
        insert campshare;
    }    
     
 
}
}
}