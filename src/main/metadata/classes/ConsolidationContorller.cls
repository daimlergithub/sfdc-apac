/***********************************************************************************
Created By          :    Abhishekh Dasepalle   
Company             :    NTT Data,Inc.
Usage               :    The functionality of this Class is to Do Consolidation List Maintenance
                         Business Conditions :
                          * Updating Campaign Member Status Based on Dealer List Member                     
                                         
************************************************************************************/
Public Class ConsolidationContorller {

    

Public String camId {set;get;} 
Public Set<Id> sid {set;get;} 
Public Set<Id> mid {set;get;}
Public List<String> aid {set;get;} 
Public List<Campaign_Member__c> camMemList {set;get;}
Public List<Campaign_Member__c> camInsertList {set;get;}
Public Static Boolean DupeChecker = true ;
public List<Participating_Dealer__c> displayDealer {set;get;}

public ConsolidationContorller(){
   
   camId =ApexPages.currentPage().getParameters().get('id');
   system.debug('++++++++++++++++'+camId);
   
    displayDealer = [Select id,Dealer__c,Name,Approve_the_List__c,Campaign__c From Participating_Dealer__c WHERE Campaign__c =: camId AND Approve_the_List__c= false];
    
    
    }
    
    public  PageReference   consolidationMaintenance()
    {
    
         Batch_Consolidation   batcher12 = new Batch_Consolidation(camId);
            Database.executeBatch(batcher12, 20);  
       
       PageReference nextPage = new PageReference('/' +camId );
        return nextPage;
       
       
       
        }
    
    
    
    
    
    
    
}