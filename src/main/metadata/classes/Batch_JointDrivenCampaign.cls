global class Batch_JointDrivenCampaign implements Database.Batchable<sObject>,Database.stateful{
    global final String campaignId;
    global final Set<Id> campid;
    global final List<Campaign> NewCamList;
    global final List<Campaign> ParentCamList;
    global  final List<Retail_Campaign__c> retailCampaign = New List<Retail_Campaign__c>();
    
    global Batch_JointDrivenCampaign (set<id> exeId, List<Campaign> camList,List<Campaign> parentList){
    
      campid = exeId;
      
      NewCamList = camList; 
      ParentCamList = parentList;
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select id,Campaign__c,Campaign__r.Parent.Campaign_Type__c,Dealer__c,Dealer__r.Dealer_Sales_Manager_Email__c,Dealer__r.Dealer_Aftersales_Manager_Email__c From Participating_Dealer__c Where Campaign__c =: campid  ]);
    }
    
    global void execute(Database.BatchableContext BC, List<Participating_Dealer__c> scope){
    
    List<Retail_Campaign__c> retailCamParentList = New List<Retail_Campaign__c>();
    List<Retail_Campaign__c> ret   = New List<Retail_Campaign__c>();
    List<Retail_Campaign__c> tail    = New List<Retail_Campaign__c>();
    Id executionRetailRecordId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    Id planningRecordRetailId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
    
     For(Participating_Dealer__c par : scope ){
      
    
    for(Campaign cam : NewCamList  ){
    For(Campaign campNew : ParentCamList ){    
    
               
        
       if(Cam.Campaign_Executer__c == 'Retail'){
       Retail_Campaign__c newChildRetail = new Retail_Campaign__c();
            newChildRetail.Name = campNew.Name;
            //newChildRetail.OwnerId = u.Id;
            newChildRetail.Dealer_Name__c = par.Dealer__c;
           newChildRetail.Parent_Campaign__c = campNew.Id;
            newChildRetail.Execution_Start_Date__c = campNew.Execution_Start_Date__c;
            newChildRetail.Execution_End_Date__c = campNew.Execution_End_Date__c;
            newChildRetail.Segmentation_Date__c = campNew.Segmentation_Date__c;
            newChildRetail.Child_Campaign_Status__c = campNew.Child_Campaign_Status__c;
            newChildRetail.Response_Date__c = campNew.Response_Date__c;
            newChildRetail.Execution_Type__c = campNew.Execution_Type__c;
            newChildRetail.Segmentation_Base__c = campNew.Segmentation_Base__c;
            newChildRetail.DM_Template__c = campNew.DM_Material__c;
            newChildRetail.Final_List_Approved__c = campNew.Final_List_Approved__c;
            newChildRetail.Survey__c = campNew.Survey__c;
            newChildRetail.Add_Sales_Staff__c = campNew.Add_Sales_Staff__c;
            newChildRetail.Add_Service_Staff__c = campNew.Add_Service_Staff__c;
            newChildRetail.Add_Campaign_Member_ID__c = campNew.Add_Campaign_Member_ID__c;
            newChildRetail.Campaign_Member_Sharing_Rule__c = campNew.Campaign_Member_Sharing_Rule__c;
            newChildRetail.RecordTypeId = executionRetailRecordId;
            newChildRetail.Campaign_Execution_Channels__c = 'DM';
            
            ret.add(newChildRetail);
            retailCampaign.add(newChildRetail);
         }
         } 
         }
         }
         if(ret.size() > 0){
         insert ret;
         }
         For(Participating_Dealer__c par : scope ){
         for(Campaign cam : NewCamList   ){
        if(Cam.Campaign_Executer__c == 'Retail'){          
       Retail_Campaign__c newRetail = new Retail_Campaign__c(); 
        newRetail.Name = cam.Name; 
        //newRetail.Campaign_Code__c = cam.Campaign_Code__c; 
        newRetail.Campaign_Type__c  = cam.Campaign_Type__c ;
        newRetail.Parent_Campaign__c = cam.Id;
        //newRetail.OwnerId = u.Id;
        newRetail.Dealer_Name__c = par.Dealer__c;
        newRetail.Start_Date__c = cam.StartDate; 
        newRetail.Close_Date__c = cam.EndDate;  
        newRetail.Status__c = cam.Status ; 
        newRetail.Event_Type__c = cam.Event_Type__c  ;
        newRetail.Description__c  = cam.Description ;
        newRetail.Campaign_Execution_Channels__c = cam.Campaign_Execution_Channels__c ; 
        newRetail.Actual_Cost__c = cam.ActualCost;  
        newRetail.Brand__c  = cam.Brand__c ;
        newRetail.Class__c = cam.Class__c ;
        newRetail.Budgeted_Cost__c = cam.BudgetedCost;      
        newRetail.RecordTypeId = planningRecordRetailId;
      
        retailCamParentList.add(newRetail);
        }
        }
        }
        
        
        
        
        system.debug('++++++++++'+retailCamParentList);
     
     //insert retailCamParentList; 
     Database.SaveResult[] srList = Database.insert(retailCamParentList, false);
     integer i=0;
     for(Database.SaveResult sr :srList){
     if(sr.isSuccess()){
     
     ret[i].Parent_Campaign1__c = sr.getId();
     i++;
     } 
     
     
     }
    system.debug('++++++++++++'+srList );
     
    integer k=0;
    for(Retail_Campaign__c  cam : ret){
    
    cam.Parent_Campaign1__c = ret[k].Parent_Campaign1__c ;
    k++;
    system.debug('++++++++++++'+cam.Parent_Campaign1__c );
    update cam;
    
    }
    
    
    
        
    }
    
    global void finish(Database.BatchableContext BC){
    
     Set<id> retailId = New Set<id>();
       Map<Id,Retail_Campaign__c> maplist = New Map<Id,Retail_Campaign__c>();
       For(Retail_Campaign__c remain : retailCampaign){
       
          retailId.add(remain.id);
          maplist.put(remain.Dealer_Name__c,remain);
       
       }   
     Batch_CampaignmemberInsertion   batcher = new Batch_CampaignmemberInsertion (maplist,campid);
            Database.executeBatch(batcher, 10);  
    
    
    
    }

}