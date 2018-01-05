global class CampaignMemberDisribution{

public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id accCompany_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    webservice static void cmDistributionToDealer(String camid){
    
               Set<Id> sid = New Set<Id>();
               List<Dealer_List_Member__c> dealerMainList = New List<Dealer_List_Member__c>();
               List<Campaign> camNewList = New List<Campaign>();
        
         system.debug('++++++++camid++++++++++++++'+camid);
         
        List<Campaign> camList = [Select id,Name,(Select Id ,Name,Preferred_Dealer__c,Contact_Id__c,Contact_Id__r.Recordtype.Name,Contact_Id__r.RecordtypeId From Campaign_Members1__r where ( (Contact_Id__r.RecordtypeId=:accPerson_RecordTypeId) OR (Contact_Id__r.RecordtypeId=:accCompany_RecordTypeId )) ) From Campaign Where Id =: camid];
         
         system.debug('++++++++++camList++++++++++++'+camList);
         For(Campaign CamNew : camList){
         
         For(Campaign_Member__c CamMem : CamNew.Campaign_Members1__r){
            
                   sid.add(camMem.Preferred_Dealer__c);
         
         }
         } 
      
             
List<Campaign_Member__c> CamMemList = [Select id ,Name,Preferred_Dealer__c,Campaign_ID__c, Contact_Id__c,Contact_Id__r.Recordtype.Name,Contact_Id__r.RecordtypeId  From Campaign_Member__c Where ((Preferred_Dealer__c =:sid )AND (Campaign_ID__c =: camid) AND ((Contact_Id__r.RecordtypeId=:accPerson_RecordTypeId) OR (Contact_Id__r.RecordtypeId=:accCompany_RecordTypeId) ) )]; 
         
         
         List<Participating_Dealer__c> ParticipateDealer = [Select id,Name,Campaign__c,Dealer__c From Participating_Dealer__c Where Campaign__c =: camid And Dealer__c =:sid];
         
          For(Campaign CamNew : camList){
         
         For(Participating_Dealer__c par :ParticipateDealer){
         
         
         For(Campaign_Member__c CamMem : CamNew.Campaign_Members1__r){
            
                   if(CamMem.Preferred_Dealer__c == par.Dealer__c){
                   
                      Dealer_List_Member__c dlist = New Dealer_List_Member__c();
                      dlist.Campaign__c = camNew.id;
                      dlist.Participating_Dealer__c = par.id;
                      dlist.Campaign_Member__c = CamMem.id;
                      //dlist.Name = CamMem.Name;
                      dlist.List_Maintenance_CM_Status__c ='Ready';
                      dlist.NewAccount__c =CamMem.Contact_Id__c;
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