public class ParticipateDealerHandlerJP
{
/***********************************************************************************
Created By          :    Abhishekh Dasepalle   
Created Date        :    02.02.2017
Company             :    NTT Data,Inc.
Usage               :    The functionality of this Method is share record of participating dealer to respective dealer sales manager(Using Apex Managed Sharing)
JIRA NO             :    SFDCJP-1026                                               
************************************************************************************/


public static void afterInsertEvent(List<Participating_Dealer__c> newList){
        
        Map<Id, List<Id>> mapDealerpati = new Map<Id, List<Id>>();
        
        
        List<Participating_Dealer__Share> list_SharingRecord = new List<Participating_Dealer__Share>();
        
        for(Participating_Dealer__c pd : newList){
            if (pd.Dealer__c != null  ){
                if(!mapDealerpati.containsKey(pd.Dealer__c)){
                      mapDealerpati.put(pd.Dealer__c, new List<Id>());
                  }
                  mapDealerpati.get(pd.Dealer__c).add(pd.Id);
            system.debug('++++++++++++'+'working');
        
        if(mapDealerpati.size() > 0){
            list_SharingRecord.addAll(createDealerAccountSharing(mapDealerpati));
        }
        
        
        
        if(list_SharingRecord.size() > 0){
            Database.insert(list_SharingRecord, false);
        }
        }
        }
        }
    
    public static void afterUpdateEvent(List<Participating_Dealer__c> newList, Map<Id, Participating_Dealer__c> oldMap){
        
        Map<Id, List<Id>> mapDealerpati = new Map<Id, List<Id>>();
        
        List<Participating_Dealer__Share> list_SharingRecord = new List<Participating_Dealer__Share>();
        Set<Id> set_AccountId = new Set<Id>();
        List<Id> list_DmrequestId = new List<Id>();
        
        for(Participating_Dealer__c pd : newList){
             if(pd.Dealer__c != null && pd.Dealer__c != oldMap.get(pd.Id).Dealer__c){
                if(!mapDealerpati.containsKey(pd.Dealer__c)){
                      mapDealerpati.put(pd.Dealer__c, new List<Id>());
                  }
                  mapDealerpati.get(pd.Dealer__c).add(pd.Id);
                  set_AccountId.add(oldMap.get(pd.Id).Dealer__c);
                  list_DmrequestId.add(pd.Id);
            }
          }  
          
          system.debug('++++++++++++++++'+mapDealerpati );
            
        
        if(set_AccountId.size() > 0){
            List<User> list_User = new List<User>( [SELECT Id, AccountId FROM User WHERE AccountId IN:set_AccountId AND IsPortalEnabled = true]);
           List<Participating_Dealer__Share> list_SharingDele = new List<Participating_Dealer__Share>([SELECT Id FROM Participating_Dealer__Share
                                                                                            WHERE ParentId IN:list_DmrequestId AND UserOrGroupId IN :list_User]);
            if(list_SharingDele.size() > 0){
                delete list_SharingDele;
            } 
        }
        if(mapDealerpati.size() > 0){
            list_SharingRecord.addAll(createDealerAccountSharing(mapDealerpati));
        }
        
        if(list_SharingRecord.size() > 0){
            Database.insert(list_SharingRecord, false);
        }
        system.debug('++++++++++++++'+list_SharingRecord);
    }
    
    
    private static List<Participating_Dealer__Share> createDealerAccountSharing(Map<Id, List<Id>> mapDealerpati){
        List<Participating_Dealer__Share> list_SharingRecord = new List<Participating_Dealer__Share>();
        for(User usr : [SELECT Id, AccountId FROM User WHERE AccountId IN:mapDealerpati.keySet() AND IsPortalEnabled = true AND Account.RecordType.Name = 'Dealer']){
            if(mapDealerpati.containsKey(usr.AccountId)){
                for(Id acId : mapDealerpati.get(usr.AccountId)){
                    Participating_Dealer__Share participatingDeaShare = new Participating_Dealer__Share();
                    participatingDeaShare.AccessLevel = 'Edit';
                    participatingDeaShare.UserOrGroupId = usr.Id;
                    participatingDeaShare.ParentId = acId;
                    participatingDeaShare.RowCause = Schema.Participating_Dealer__Share.RowCause.Manual;
                    list_SharingRecord.add(participatingDeaShare);
                }
            }
        }
        return list_SharingRecord;
    }
    
    
    /* End Of SFDCJP-1026 */


}