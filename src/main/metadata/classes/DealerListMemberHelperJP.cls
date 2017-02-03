public class DealerListMemberHelperJP
{
/***********************************************************************************
Created By          :    Abhishekh Dasepalle   
Created Date        :    02.02.2017
Company             :    NTT Data,Inc.
Usage               :    The functionality of this Method is to sync the status between Campaign member and dealer list member
JIRA NO             :    SFDCJP-1026                                               
************************************************************************************/
public static void statusSyncWithCampaignMember (List<Dealer_List_Member__c> dealerList,Map<id,Dealer_List_Member__c> oldDealerList)  {

List<Campaign_Member__c> VarCampaignMem = New List<Campaign_Member__c>();
     
    
     
     Set<Id> sid = New Set<Id>();
     
     For(Dealer_List_Member__c deal : dealerList){
     
      
           if(deal.List_Maintenance_CM_Status__c != oldDealerList.get(deal.id).List_Maintenance_CM_Status__c && deal.List_Maintenance_CM_Status__c != 'New' ){
      
           sid.add(deal.Campaign_Member__c);
           
             system.debug('++++++++'+deal.Campaign_Member__c);
             system.debug('+++++++++++'+sid);
      }
      
      
      List<Campaign_Member__c> campMem = [Select id,Status__c,(select id,List_Maintenance_CM_Status__c From Dealer_List_Members__r) from Campaign_Member__c where id =:sid]; 
     
         For(Campaign_Member__c camp : campMem ){
            
         
            For(Dealer_List_Member__c dealerListMem : camp.Dealer_List_Members__r){
            
            system.debug('+++++++++++'+camp.Dealer_List_Members__r);
            
               if(dealerListMem.List_Maintenance_CM_Status__c == 'Removed'){
               
               camp.Status__c = 'Removed' ;
               } 
               
              
              
            
            }
         
         VarCampaignMem.add(camp);
              system.debug('++++++++++++'+VarCampaignMem);
         }
         
         system.debug('++++++++++++'+VarCampaignMem);
         update VarCampaignMem;
         
     
     }


}

/* End Of SFDCJP-1026 */

}