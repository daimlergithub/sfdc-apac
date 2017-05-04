global class CampaignMemberDisribution{


    webservice static void cmDistributionToDealer(String camid){
    
               Set<Id> sid = New Set<Id>();
               List<Dealer_List_Member__c> dealerMainList = New List<Dealer_List_Member__c>();
               List<Campaign> camNewList = New List<Campaign>();
        
         system.debug('++++++++camid++++++++++++++'+camid);
         
         
         List<Campaign> camList = [Select id,Name,(Select Id ,Name,Preferred_Dealer__c From Campaign_Members1__r) From Campaign Where Id =: camid];
         
         system.debug('++++++++++camList++++++++++++'+camList);
         For(Campaign CamNew : camList){
         
         For(Campaign_Member__c CamMem : CamNew.Campaign_Members1__r){
            
                   sid.add(camMem.Preferred_Dealer__c);
         
         }
         } 
    
         
         List<Campaign_Member__c> CamMemList = [Select id ,Name,Preferred_Dealer__c,Campaign_ID__c  From Campaign_Member__c Where Preferred_Dealer__c =:sid AND Campaign_ID__c =: camid]; 
         
         
         List<Participating_Dealer__c> ParticipateDealer = [Select id,Name,Campaign__c,Dealer__c From Participating_Dealer__c Where Campaign__c =: camid And Dealer__c =:sid];
         
          For(Campaign CamNew : camList){
         
         For(Participating_Dealer__c par :ParticipateDealer){
         
         
         For(Campaign_Member__c CamMem : CamNew.Campaign_Members1__r){
            
                   if(CamMem.Preferred_Dealer__c == par.Dealer__c){
                   
                      Dealer_List_Member__c dlist = New Dealer_List_Member__c();
                      dlist.Campaign__c = camNew.id;
                      dlist.Participating_Dealer__c = par.id;
                      dlist.Campaign_Member__c = CamMem.id;
                      dlist.Name = CamMem.Name; 
                   dealerMainList.add(dlist);
                   
                   }
         
         }
         
         
         }
         CamNew.Distribution_is_completed__c =true;
         
         camNewList.add(CamNew);
         } 
    
      insert dealerMainList;
      update camNewList;
    }






}