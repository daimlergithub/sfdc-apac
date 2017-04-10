/***********************************************************************************
Created By          :    Abhishekh Dasepalle   
Company             :    NTT Data,Inc.
Usage               :    The functionality of this Class is to Do Consolidation List Maintenance
                         Business Conditions :
                          * Updating Campaign Member Status Based on Dealer List Member                     
                                         
************************************************************************************/
Public Class ConsolidationContorller {

Public  Id camId {set;get;} 
Public Set<Id> sid {set;get;} 
Public Set<Id> mid {set;get;}
Public List<String> aid {set;get;} 
Public List<Campaign_Member__c> camMemList {set;get;}
Public List<Campaign_Member__c> camInsertList {set;get;}
Public Static Boolean DupeChecker = true ;

public ConsolidationContorller(){
   
   camId =ApexPages.currentPage().getParameters().get('id');
   system.debug('++++++++++++++++'+camId);
    
    
    }
    
    public  PageReference   consolidationMaintenance()
    {
    
    List<Participating_Dealer__c> paDealer = [ Select id ,(Select id,Name,NewAccount__c,List_Maintenance_CM_Status__c,Campaign_Member__c From Dealer_List_Members__r) From Participating_Dealer__c Where Campaign__c =:camId ];
    List<Campaign> consolidatedCheck = [Select id,Name,Consolidated_List_Completed__c From Campaign Where Id =: camId];
   Set<Id> sid = New Set<Id>();
   Set<Id> mid = New Set<Id>();
   Set<String> aid = New Set<String>();  
   Set<Id> dupliCheck = New Set<Id>(); 
   List<Campaign_Member__c> camInsertList = New List<Campaign_Member__c>();
   List<Campaign> CampaignList = New List<Campaign>();
   
   
   For(Participating_Dealer__c par : paDealer){
       
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
       update camMemList;
       }
       
       List<Campaign_Member__c> campDuplicate = [select id ,Name,Contact_Id__c  From Campaign_Member__c where Contact_Id__c=:aid AND Campaign_ID__c =: camID];
       for(Campaign_Member__c cDupliCheck : campDuplicate ){
       
              dupliCheck.add(cDupliCheck.Contact_Id__c  );
       
       } 
       
       list<Dealer_List_Member__c> dealerListDupe = [select id,Name,NewAccount__c From Dealer_List_Member__c Where NewAccount__c =:aid AND Campaign__c =: camID];
       
            If(dealerListDupe.Size()>1){
            
                DupeChecker = false;
            }
       
       
       list<Dealer_List_Member__c> dealerListNew = [select id,Name,NewAccount__c,List_Maintenance_CM_Status__c,Participating_Dealer__r.Dealer__c From Dealer_List_Member__c where Id =: mid AND List_Maintenance_CM_Status__c = 'New' ];
       
          for(Dealer_List_Member__c dlistMem : dealerListNew  ){
              
             Campaign_Member__c camInsert = New Campaign_Member__c();
             //camInsert.Name = dlistMem.Name;
             camInsert.Campaign_ID__c = camId;
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
       insert camInsertList;
       }
       
       For(Campaign cam : consolidatedCheck ){
       
          cam.Consolidated_List_Completed__c =true;
          CampaignList.add(cam);
       }
       if(CampaignList.size()>0 && !CampaignList.isEmpty()){
       update CampaignList;
       }
       
       PageReference nextPage = new PageReference('/' +camId );
        return nextPage;
       
       
       
        }
    
    
    
    
    
    
    
}