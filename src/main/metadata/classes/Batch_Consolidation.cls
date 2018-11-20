global class Batch_Consolidation implements Database.Batchable<sObject> ,Database.stateful{
    global final String query;
      global  Campaign camprec=new  Campaign();
      global Map<Id, String> errorMap {get; set;}
  global Map<Id, String> successMap {get; set;}
   global list<Id> successlist=new list<ID>();
  global Map<Id, SObject> IdToSObjectMap {get; set;}
    global Batch_Consolidation  (String q){
        query = q;
        system.debug('++++++++++++++++++'+query);
         errorMap = new Map<Id, String>();
    successMap= new Map<Id, String>();
    IdToSObjectMap = new Map<Id, SObject>();
        
    }
     global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([Select id,Campaign__c ,(Select id,Name,NewAccount__c,List_Maintenance_CM_Status__c,Campaign_Member__c From Dealer_List_Members__r) From Participating_Dealer__c Where Campaign__c =:query  ] );
    }
    global void execute(Database.BatchableContext BC, List<Participating_Dealer__c> scope){
    
    Set<Id> sid = New Set<Id>();
   Set<Id> mid = New Set<Id>();
   Set<String> aid = New Set<String>();  
   Set<id> parId = New Set<Id>();
   Set<Id> dupliCheck = New Set<Id>(); 
  // List<Campaign_Member__c> camInsertList = New List<Campaign_Member__c>();
Map<id,Campaign_Member__c > camInsertList = New Map<id,Campaign_Member__c >();
   List<Campaign> CampaignList = New List<Campaign>();
    Boolean DupeChecker = true ;
   For(Participating_Dealer__c participate :scope){
   
       parId.add(participate.id);
   
   }
   
   List<Dealer_List_Member__c> DealList = [Select id,Name,NewAccount__c,VehicleRelationship__c,VehicleRelationship_New__r.Vehicle_Id__c,List_Maintenance_CM_Status__c,Participating_Dealer__c,Campaign_Member__c From Dealer_List_Member__c Where Participating_Dealer__c =:parId];
   
   For(Participating_Dealer__c par : scope){
       
       For(Dealer_List_Member__c deal : DealList  ){
           
           if(deal.Participating_Dealer__c == par.id){
           if(deal.List_Maintenance_CM_Status__c == 'Removed'){
               
               
                   sid.add(deal.Campaign_Member__c);
                }
           
           if(deal.List_Maintenance_CM_Status__c == 'New'){
               
                    aid.add(deal.NewAccount__c);
                    mid.add(deal.Id);
               
                }
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
       
       If(aid.size()>0){
       List<Campaign_Member__c> campDuplicate = [select id ,Name,Contact_Id__c  From Campaign_Member__c where Contact_Id__c=:aid AND Campaign_ID__c =:query];
       for(Campaign_Member__c cDupliCheck : campDuplicate ){
       
              dupliCheck.add(cDupliCheck.Contact_Id__c  );
       
       } 
       
      
         
       list<Dealer_List_Member__c> dealerListDupe = [select id,Name,VehicleRelationship__c,VehicleRelationship_New__r.Vehicle_Id__c,NewAccount__c From Dealer_List_Member__c Where NewAccount__c =:aid AND Campaign__c =: query];
       
            If(dealerListDupe.Size()>1){
            
                DupeChecker = false;
            }
       
       
       list<Dealer_List_Member__c> dealerListNew = [select id,Name,VehicleRelationship__c,VehicleRelationship_New__r.Vehicle_Id__c,NewAccount__c,List_Maintenance_CM_Status__c,Participating_Dealer__r.Dealer__c From Dealer_List_Member__c where Id =: mid AND List_Maintenance_CM_Status__c = 'New' ];
       
          for(Dealer_List_Member__c dlistMem : dealerListNew  ){
              
             Campaign_Member__c camInsert = New Campaign_Member__c();
             //camInsert.Name = dlistMem.Name;
             camInsert.Campaign_ID__c = query;
             camInsert.Status__c ='Ready';
             camInsert.List_Maitenence_Retail_CM_Flag__c = true;
             camInsert.Contact_Id__c = dlistMem.NewAccount__c;
             //if(DupeChecker == true){
             camInsert.Preferred_Dealer__c = dlistMem.Participating_Dealer__r.Dealer__c; 
             //}
             
             if(dlistMem.VehicleRelationship_New__c != null){
             
             camInsert.Vehicle_Relationship__c = dlistMem.VehicleRelationship_New__c;
             camInsert.Vehicle__c = dlistMem.VehicleRelationship_New__r.Vehicle_Id__c;
             
             }
             
              if(!dupliCheck.contains(dlistMem.NewAccount__c ))
              {
                  
            //  camInsertList.add(camInsert);
                camInsertList.put(dlistMem.id,camInsert);  
                         
              }      
              
              
          }
          
          
          }
    //   if(camInsertList.size()>0 && !camInsertList.isEmpty()){
  //     Database.insert(camInsertList,false);
  //     }
       
       
           if(camInsertList.size()>0)
    {
        List<Database.SaveResult> dsrs = Database.Insert(camInsertList.Values(), false);
            Integer index = 0;
            for(Database.SaveResult dsr : dsrs){
                if(dsr.issuccess())
                {
                successlist.add(dsr.id);            
                }
                if(!dsr.isSuccess()){
                    for(Id key: camInsertList.keySet())
                    {
                  String errMsg = dsr.getErrors()[0].getMessage();
                    errorMap.put(key, errMsg);
                    IdToSObjectMap.put(key, camInsertList.values());                        
                    }
                    
                }
                index++;
            }
    }
    
    }
    
    global void finish(Database.BatchableContext BC){
   
         if(!errorMap.isEmpty() || !successlist.isempty())
     {
         AsyncApexJob a = [SELECT id, ApexClassId,JobItemsProcessed, TotalJobItems,NumberOfErrors, CreatedBy.Email FROM AsyncApexJob WHERE id = :BC.getJobId()];
        camprec=[Select id,name from campaign where id=:query Limit 1];
         String body = 'Your batch job '
             + 'Batch_Consolidation '
             + 'has finished. and' 
             + 'There were '
             +successlist.size() 
             +'Sucess and '
             + errorMap.size()
             + ' errors. Please find the error list attached to the Case.';
         
         // Creating the CSV file
            String finalstr = 'Id, Name, Error \n';
            String subject = 'Consolidation List for'+camprec.Name+' - Apex Batch Error List';
           // String subject = 'Campaign member Insertion for'+camprec.Name+' - Apex Batch Error List';
            String attName = 'Consolidation List.csv';
            for(Id id  : errorMap.keySet()){
                string err = errorMap.get(id);
                Campaign_Member__c acct = (Campaign_Member__c) IdToSObjectMap.get(id);
                string recordString = '"'+id+'","'+acct.Name+'","'+err+'"\n';
                finalstr = finalstr +recordString;
            } 
         // Define the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
 
            // Create the email attachment    
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(attName);
            efa.setBody(Blob.valueOf(finalstr));
 
            // Sets the paramaters of the email
            email.setSubject( subject );
            //email.setToAddresses( new String[] {'dinesh.govindaswamy@nttdata.com'} );
            email.setToAddresses( new String[] {'NTT_Daimler_SO_Team@nttdata.com'} );
           email.setCcAddresses( new String[] {'atsushi.ogihara@nttdata.com'} );
            email.setPlainTextBody( body );
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
 
            // Sends the email
            Messaging.SendEmailResult [] r = 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
 
     }
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
     
          // Commented as part of changes related to JIRA 3317
       // Batch_JointDrivenCampaign  batcher = new Batch_JointDrivenCampaign(aid, camList,parentCampaignList);
           // Database.executeBatch(batcher, 1);  
            
            }  
    
    }
    }