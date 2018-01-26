global class Batch_Consolidation implements Database.Batchable<sObject> ,Database.stateful{
    global final String query;
    
    global Batch_Consolidation  (String q){
        query = q;
        system.debug('++++++++++++++++++'+query);
        
    }
     global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select id ,(Select id,Name,NewAccount__c,List_Maintenance_CM_Status__c,Campaign_Member__c From Dealer_List_Members__r) From Participating_Dealer__c Where Campaign__c =:query  ] );
    }
    global void execute(Database.BatchableContext BC, List<Participating_Dealer__c> scope){
    
    Set<Id> sid = New Set<Id>();
   Set<Id> mid = New Set<Id>();
   Set<String> aid = New Set<String>();  
   Set<Id> dupliCheck = New Set<Id>(); 
   List<Campaign_Member__c> camInsertList = New List<Campaign_Member__c>();
   List<Campaign> CampaignList = New List<Campaign>();
    Boolean DupeChecker = true ;
   
   
   For(Participating_Dealer__c par : scope){
       
       For(Dealer_List_Member__c deal : par.Dealer_List_Members__r ){
           
           if(deal.List_Maintenance_CM_Status__c == 'Removed'){
               
               
                   sid.add(deal.Campaign_Member__c);
                }
           
           if(deal.List_Maintenance_CM_Status__c == 'New'){
               
                    aid.add(deal.NewAccount__c);
                    mid.add(deal.Id);
               
                }
              }
        
      
    
    
    }
    
    
    
    List<Campaign_Member__c> camMemList = New List<Campaign_Member__c>();
    
     List<Campaign_Member__c> campMem =[select id,status__c From Campaign_Member__c where Id =:sid];
       
       For(Campaign_Member__c cam : campMem){
           
           if(cam.Status__c != 'Removed')
           {
               cam.Status__c = 'Removed';
           }
           
           
          camMemList.add(cam); 
       }
       if(camMemList.size()>0 && !camMemList.isEmpty()){
       Database.update(camMemList,false);
       }
       
       List<Campaign_Member__c> campDuplicate = [select id ,Name,Contact_Id__c  From Campaign_Member__c where Contact_Id__c=:aid AND Campaign_ID__c =:query];
       for(Campaign_Member__c cDupliCheck : campDuplicate ){
       
              dupliCheck.add(cDupliCheck.Contact_Id__c  );
       
       } 
       
       list<Dealer_List_Member__c> dealerListDupe = [select id,Name,NewAccount__c From Dealer_List_Member__c Where NewAccount__c =:aid AND Campaign__c =: query];
       
            If(dealerListDupe.Size()>1){
            
                DupeChecker = false;
            }
       
       
       list<Dealer_List_Member__c> dealerListNew = [select id,Name,NewAccount__c,List_Maintenance_CM_Status__c,Participating_Dealer__r.Dealer__c From Dealer_List_Member__c where Id =: mid AND List_Maintenance_CM_Status__c = 'New' ];
       
          for(Dealer_List_Member__c dlistMem : dealerListNew  ){
              
             Campaign_Member__c camInsert = New Campaign_Member__c();
             //camInsert.Name = dlistMem.Name;
             camInsert.Campaign_ID__c = query;
             camInsert.Status__c ='Ready';
             camInsert.List_Maitenence_Retail_CM_Flag__c = true;
             camInsert.Contact_Id__c = dlistMem.NewAccount__c;
             if(DupeChecker == true){
             camInsert.Preferred_Dealer__c = dlistMem.Participating_Dealer__r.Dealer__c; 
             }
              if(!dupliCheck.contains(dlistMem.NewAccount__c ))
              {
                  
              camInsertList.add(camInsert);
                
                         
              }      
              
              
          }
       if(camInsertList.size()>0 && !camInsertList.isEmpty()){
       Database.insert(camInsertList,false);
       }
    
    }
    
    global void finish(Database.BatchableContext BC){
    
     List<Campaign> newcamlist = New List<campaign>();
     Set<id> sid = New Set<id>();
     Set<id> aid = New Set<id>();
     List<Campaign> CamlistCompleted =[Select id,ParentId,Consolidated_List_Completed__c  From Campaign Where id =:query];
     For(Campaign cam : CamlistCompleted ){
     
     cam.Consolidated_List_Completed__c  = true;
       sid.add(cam.ParentId);
       aid.add(cam.Id);
     
     newcamlist.add(cam);
     }
     Update newcamlist;
    // Checking Joint Driven 
     List<Campaign> camList =[Select id,Name,Campaign_Code__c,Campaign_Executer__c,Campaign_Type__c,StartDate,EndDate,Status,Event_Type__c,Description,Campaign_Execution_Channels__c,ActualCost,Brand__c,Class__c,BudgetedCost  From Campaign Where Id =: sid];
    List<Participating_Dealer__c> parDeal = [Select id,Campaign__c,Campaign__r.Parent.Campaign_Type__c,Dealer__c,Dealer__r.Dealer_Sales_Manager_Email__c,Dealer__r.Dealer_Aftersales_Manager_Email__c From Participating_Dealer__c Where Campaign__c =: query];
     List<Campaign> parentCampaignList = [Select id,Name,Execution_Start_Date__c,Execution_End_Date__c,DM_Material__c,Segmentation_Date__c,Child_Campaign_Status__c,Response_Date__c,Execution_Type__c,Segmentation_Base__c,DM_Template__c,Final_List_Approved__c,Survey__c,Add_Sales_Staff__c,Add_Service_Staff__c,Add_Campaign_Member_ID__c,Campaign_Member_Sharing_Rule__c From Campaign Where id =:query];
      If(camList.size() >0 && !camList.isEmpty()){ 
     
          
        Batch_JointDrivenCampaign  batcher = new Batch_JointDrivenCampaign(aid, camList,parentCampaignList);
            Database.executeBatch(batcher, 50);  
            
            }  
    
    }
    }