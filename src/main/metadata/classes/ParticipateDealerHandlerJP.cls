public class ParticipateDealerHandlerJP
{
/***********************************************************************************
Created By          :    Abhishekh Dasepalle   
Created Date        :    02.02.2017
Company             :    NTT Data,Inc.
Usage               :    The functionality of this Method is share record of participating dealer to respective dealer sales manager(Using Apex Managed Sharing)
JIRA NO             :    SFDCJP-1026       


Modifications       :
Modified by         : Venky
JIRA NO             :SFDCJP-2731,SFDCJP-2801
Description         : Fixed AfterInsert caused by: System.ListException: Duplicate id in list: issue  
                                   
************************************************************************************/

 public static Id da=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Dealer').getRecordTypeId();
public static void afterInsertEvent(List<Participating_Dealer__c> newList){
        List<Participating_Dealer__Share> list_SharingRecord = new List<Participating_Dealer__Share>();
        Map<Id, List<Id>> mapDealerpati = new Map<Id, List<Id>>();
       
        
        for(Participating_Dealer__c pd : newList){
            if (pd.Dealer__c != null  ){
                if(!mapDealerpati.containsKey(pd.Dealer__c)){
                      mapDealerpati.put(pd.Dealer__c, new List<Id>());
                  }
                  mapDealerpati.get(pd.Dealer__c).add(pd.Id);
            system.debug('++++++++++++'+mapDealerpati);
        }
        }
        if(mapDealerpati.size() > 0){
        list_SharingRecord.addAll(createDealerAccountSharing(mapDealerpati)); 
        }
         
        
        
        if(list_SharingRecord.size() > 0){
         system.debug('list_SharingRecord?>?>?>?>?>'+list_SharingRecord);
         Database.insert(list_SharingRecord, false); 
        }
        }
    
    public static void afterUpdateEvent(List<Participating_Dealer__c> newList, Map<Id, Participating_Dealer__c> oldMap){
        List<Participating_Dealer__Share> list_SharingRecord = new List<Participating_Dealer__Share>();
        Map<Id, List<Id>> mapDealerpati = new Map<Id, List<Id>>();
        
         
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
            List<User> list_User = new List<User>( [SELECT Id, Contact.AccountId FROM User WHERE Contact.AccountId IN:set_AccountId AND IsPortalEnabled = true]);
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
    }
     
    
    private static List<Participating_Dealer__Share> createDealerAccountSharing(Map<Id, List<Id>> mapDealerpati){ 
         List<Participating_Dealer__Share> list_SharingRecord = new List<Participating_Dealer__Share>(); 
         system.debug('++++++++++++ mapDealerpati.keySet()'+mapDealerpati.keySet());
         Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = getAllDealerAccountWithSameGCCode(mapDealerpati.keySet());
          System.debug('samegccodeaccountlist<><><><><>'+dealerIdToSimilarGCCodeDealerAccountIdsMap.keySet());
          for(Id dealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.keySet()) {
            if(mapDealerpati.containsKey(dealerId)) {
               System.debug('Inserting>>>>>');
                List<Id> vrIdList = mapDealerpati.get(dealerId);
                for(Id similarGCCodeDealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.get(dealerId)) {
                    system.debug('simid'+similarGCCodeDealerId);
                    mapDealerpati.put(similarGCCodeDealerId, vrIdList);
                }
            }
        }
        List<Account> dealerAccList = [select Name from Account where Id IN: mapDealerpati.keySet() and RecordtypeID=:da];
         System.debug('dalist<<<<<<<'+dealerAccList);
        Set<String> dealerAccNameSet = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        for(Account dealerRec : dealerAccList) {
            dealerAccNameSet.add(dealerRec.Name);
            accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
        }
       List<Participating_Dealer__Share> list_participatingDealerSharingRecord = new List<Participating_Dealer__Share>();
        list<group>grouplist = [select Id, Name, Type from Group where Name IN: dealerAccNameSet];
        System.debug('grpList>>>>'+grouplist);
        for(Group groupRec : grouplist){
            if(accNameToAccIdMap.containsKey(groupRec.Name) && mapDealerpati.containsKey(accNameToAccIdMap.get(groupRec.Name))){
                    System.debug('Insering??????');
                for(Id acId : mapDealerpati.get(accNameToAccIdMap.get(groupRec.Name))){
                    Participating_Dealer__Share participatingDeaShare = new Participating_Dealer__Share();
                    participatingDeaShare.AccessLevel = 'Edit';
                    participatingDeaShare.UserOrGroupId = groupRec.Id;
                    participatingDeaShare.ParentId = acId;
                    participatingDeaShare.RowCause = Schema.Participating_Dealer__Share.RowCause.Manual;
                    list_participatingDealerSharingRecord.add(participatingDeaShare); 
                }
            }
        }
         return list_participatingDealerSharingRecord;
    }
    
    
   
    private static Map<Id, Set<Id>> getAllDealerAccountWithSameGCCode(Set<Id> dealerAccountIdSet) {
        
        List<Account> dealerAccList = [select Id, Dealer_GC_Code__c from Account where Id =: dealerAccountIdSet];
        Map<String, Id> gcCodeToDealerAccIdMap = new Map<String, Id>();
        for(Account accRec : dealerAccList) {
            gcCodeToDealerAccIdMap.put(accRec.Dealer_GC_Code__c, accRec.Id);
        }
        
        Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = new Map<Id, Set<Id>>();
        if(dealerAccList.size() > 0) {
            List<Account> similarGCCodeDealerAccountList = [select Id, Dealer_GC_Code__c from Account where Dealer_GC_Code__c IN: gcCodeToDealerAccIdMap.keySet()
                                                           and RecordtypeID=:da];
                                                                    
                       system.debug('+++++++++++++++++++'+similarGCCodeDealerAccountList);
            for(Account accRec : similarGCCodeDealerAccountList) {
                if(!dealerIdToSimilarGCCodeDealerAccountIdsMap.containsKey(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c))) {
                    dealerIdToSimilarGCCodeDealerAccountIdsMap.put(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c), new Set<Id>());
                }
                dealerIdToSimilarGCCodeDealerAccountIdsMap.get(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c)).add(accRec.Id);
            }                                                       
        }
        return dealerIdToSimilarGCCodeDealerAccountIdsMap;
    }

}