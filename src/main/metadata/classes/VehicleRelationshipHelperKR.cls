public without sharing class VehicleRelationshipHelperKR
{ 
    public static Id vehicleRelationship_VRRRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();
    public static Id vehicleRelationship_VRRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship').getRecordTypeId();
       
    public static void afterInsertEvent(List<Vehicle_Relationship__c> newList){
   
        Map<Id, List<Id>> map_AccountIdAndListVCId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> map_AccountIdAndListVCwithVRrecordtypeId = new Map<Id, List<Id>>();
        List<Vehicle_Relationship__Share> list_SharingRecord = new List<Vehicle_Relationship__Share>();
        Set<Id> currentVrId=new Set<Id>();
       
        for(Vehicle_Relationship__c vc : newList){
            if(vc.Owner_Dealer__c != null && vc.RecordTypeId == vehicleRelationship_VRRRecordTypeId){
                if(!map_AccountIdAndListVCId.containsKey(vc.Owner_Dealer__c)){
                      map_AccountIdAndListVCId.put(vc.Owner_Dealer__c, new List<Id>());
                      
                  }
                  map_AccountIdAndListVCId.get(vc.Owner_Dealer__c).add(vc.Id);
            }
            else
                if(vc.Contact__c != null && vc.RecordTypeId == vehicleRelationship_VRRecordTypeId){
                    if(!map_AccountIdAndListVCwithVRrecordtypeId.containsKey(vc.Contact__c)){
                        map_AccountIdAndListVCwithVRrecordtypeId.put(vc.Contact__c, new List<Id>());
                    }
                    map_AccountIdAndListVCwithVRrecordtypeId.get(vc.Contact__c).add(vc.Id);
                    currentVrId.add(vc.Id);
                }
        }
       
        if(map_AccountIdAndListVCId.size() > 0){
            list_SharingRecord.addAll(createDealerAccountSharing(map_AccountIdAndListVCId));
        }
         
        if(map_AccountIdAndListVCwithVRrecordtypeId.size() > 0){
            list_SharingRecord.addAll(createPersonOrCompanyAccountSharing(map_AccountIdAndListVCwithVRrecordtypeId,currentVrId));
        }
        system.debug('map_AccountIdAndListVCwithVRrecordtypeId :'+map_AccountIdAndListVCwithVRrecordtypeId);
        system.debug('list_SharingRecord:'+list_SharingRecord);
        if(list_SharingRecord.size() > 0){
            Database.insert(list_SharingRecord, false);
        }       
    }
    
    public static Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    
    public static void afterUpdateEvent(List<Vehicle_Relationship__c> newList, Map<Id, Vehicle_Relationship__c> oldMap){
        Set<Id> currentVrId=new Set<Id>();
        Map<Id, List<Id>> map_AccountIdAndListVCId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> map_AccountIdAndListVCwithVRrecordtypeId = new Map<Id, List<Id>>();
        List<Vehicle_Relationship__Share> list_SharingRecord = new List<Vehicle_Relationship__Share>();
        Set<Id> set_AccountId = new Set<Id>();
        List<Id> list_VehicleRelationId = new List<Id>();
        List<String> accNames=new List<String>();
        List<String> GcNames=new List<String>();
        List<Account_Link__c> ListAlk=new List<Account_Link__c>();
        Set<Id> DealerAccId=new Set<Id>();
        Set<Id> set_LinkId = new Set<Id>();
        //List<User> list_User = new List<User>();
        List<Vehicle_Relationship__Share> list_SharingDele = new List<Vehicle_Relationship__Share>();
         
        for(Vehicle_Relationship__c vc : newList){
            system.debug('+++++++++++'+vehicleRelationship_VRRRecordTypeId );
            system.debug('+++++++++++'+vehicleRelationship_VRRecordTypeId  );           
            if(vc.Owner_Dealer__c != null && vc.RecordTypeId == vehicleRelationship_VRRRecordTypeId && vc.Owner_Dealer__c != oldMap.get(vc.Id).Owner_Dealer__c){
                if(!map_AccountIdAndListVCId.containsKey(vc.Owner_Dealer__c)){
                    map_AccountIdAndListVCId.put(vc.Owner_Dealer__c, new List<Id>());
                }
                map_AccountIdAndListVCId.get(vc.Owner_Dealer__c).add(vc.Id);
                currentVrId.add(vc.Id);
                set_AccountId.add(oldMap.get(vc.Id).Owner_Dealer__c);
                list_VehicleRelationId.add(vc.Id);
            }
            else{
                if(vc.Contact__c != null && vc.RecordTypeId == vehicleRelationship_VRRecordTypeId  && vc.Contact__c != oldMap.get(vc.Id).Contact__c){
                    system.debug('+++++++++++'+'working');
                    if(!map_AccountIdAndListVCwithVRrecordtypeId.containsKey(vc.Contact__c)){
                        map_AccountIdAndListVCwithVRrecordtypeId.put(vc.Contact__c, new List<Id>());
                    }
                    if(map_AccountIdAndListVCwithVRrecordtypeId.get(vc.Contact__c)!=null){
                        map_AccountIdAndListVCwithVRrecordtypeId.get(vc.Contact__c).add(vc.Id);
                    }
                    currentVrId.add(vc.Id);               
                    set_AccountId.add(oldMap.get(vc.Id).Contact__c);
                    system.debug('+++++++++++'+set_AccountId);
                    list_VehicleRelationId.add(vc.Id);
                } 
            }
        }
       
        if(set_AccountId!=null){
            ListAlk=[select id,fromRole__c,toRole__c from Account_Link__c where toRole__c=:set_AccountId];
            if(ListAlk.size() > 0){
                for(Account_Link__c  alk:ListAlk)
                {
                    if(alk.fromRole__c!=null && alk.toRole__c!=null)
                    {
                        set_LinkId.add(alk.fromRole__c);
                    } 
                }
                List<Account> accName = [select Name,Dealer_GC_Code__c from Account where Id IN:set_LinkId];
                for(Account acc : accName){
                    // accNames.add(acc.Name);
                    GcNames.add(acc.Dealer_GC_Code__c );
                }
                List<Account> accGCode = [select Name,Dealer_GC_Code__c from Account where Dealer_GC_Code__c  IN: GcNames AND RecordTypeId =: Dealer_RecordTypeId];
                
                for(Account accs : accGCode ){
                    accNames.add(accs.Name);  
                }
            }
        }
        
        List<Group> list_User = new List<Group>( [select Id, Name, Type from Group where Name IN:accNames]);
        
        if(list_User!=null){
            list_SharingDele=[SELECT Id FROM Vehicle_Relationship__Share WHERE ParentId IN:list_VehicleRelationId AND UserOrGroupId IN :list_User];
        }
        if(list_SharingDele.size() > 0){             
            Database.delete(list_SharingDele, false);
            system.debug('+++++++++++'+list_SharingDele);
        }      
        
        if(map_AccountIdAndListVCId.size() > 0){
            list_SharingRecord.addAll(createDealerAccountSharing(map_AccountIdAndListVCId));
        }
       
        if(map_AccountIdAndListVCwithVRrecordtypeId.size() > 0){
            list_SharingRecord.addAll(createPersonOrCompanyAccountSharing(map_AccountIdAndListVCwithVRrecordtypeId,currentVrId));
        }
       
        if(list_SharingRecord.size() > 0){
            Database.insert(list_SharingRecord, false);
        }
    }
   
    private static List<Vehicle_Relationship__Share> createDealerAccountSharing(Map<Id, List<Id>> map_AccountIdAndListVCId){
       
        // START: Adding Similar GC Code related Account To Map which is sharing already.
        Set<Id> dealerAccIdSet = new Set<Id>();
        for(Id dealerAccId : map_AccountIdAndListVCId.keySet()) {
            dealerAccIdSet.add(dealerAccId);
        }
        Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = getAllDealerAccountWithSameGCCode(dealerAccIdSet);
       
        for(Id dealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.keySet()) {
            if(map_AccountIdAndListVCId.containsKey(dealerId)) {
                List<Id> vrIdList = map_AccountIdAndListVCId.get(dealerId);
                for(Id similarGCCodeDealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.get(dealerId)) {
                    map_AccountIdAndListVCId.put(similarGCCodeDealerId, vrIdList);
                }
            }
        }
        // END: Adding Similar GC Code related Account To Map which is sharing already.
        
        // Changing Sharing from User to Public Group
        List<Account> dealerAccList = [select Name from Account where Id IN: map_AccountIdAndListVCId.keySet()];
        Set<String> dealerAccNameSet = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        for(Account dealerRec : dealerAccList) {
            dealerAccNameSet.add(dealerRec.Name);
            accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
        }
       
        
        List<Vehicle_Relationship__Share> list_SharingRecord = new List<Vehicle_Relationship__Share>();
        for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]){
            if(accNameToAccIdMap.containsKey(groupRec.Name) && map_AccountIdAndListVCId.containsKey(accNameToAccIdMap.get(groupRec.Name))){
                for(Id accountLinkId : map_AccountIdAndListVCId.get(accNameToAccIdMap.get(groupRec.Name))){
                    Vehicle_Relationship__Share vehicleRelationShare = new Vehicle_Relationship__Share();
                    vehicleRelationShare.AccessLevel = 'Read';
                    vehicleRelationShare.UserOrGroupId = groupRec.Id;
                    vehicleRelationShare.ParentId = accountLinkId;
                    vehicleRelationShare.RowCause = Schema.Vehicle_Relationship__Share.RowCause.Manual;
                    list_SharingRecord.add(vehicleRelationShare);
                }
            }
        }
        return list_SharingRecord;
    }
    
    public static List<Vehicle_Relationship__Share> createPersonOrCompanyAccountSharing(Map<Id, List<Id>> map_AccountIdAndListVCwithVRrecordtypeId,Set<Id> currentVrId){
        system.debug('map_AccountIdAndListVCwithVRrecordtypeId :'+map_AccountIdAndListVCwithVRrecordtypeId);
        set<Id> toRoleIds = new Set<id>();
        for(id i : map_AccountIdAndListVCwithVRrecordtypeId.keySet()){
           system.debug(' >>> :'+i);
           toRoleIds.add(i);
        }
     
        Set<Id> DealerAccId=new Set<Id>();
        Set<Id> VrID=new Set<Id>();
        Map<id,Account_Link__c> ListAlk = new Map<id,Account_Link__c>([select id,fromRole__c,toRole__c from Account_Link__c where 
                                   toRole__c IN : toRoleIds]);
        system.debug('ListAlk  >> :'+ListAlk);
        for(Account_Link__c alk : ListAlk.values()) {
             system.debug(' >>> 1 :'+alk);                         
            DealerAccId.add(alk.fromRole__c);
        }
        DealerAccId.remove(null);
       
        // Start: Share with all Dealer Account with same GC Code
        Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = getAllDealerAccountWithSameGCCode(DealerAccId);
        system.debug('dealerIdToSimilarGCCodeDealerAccountIdsMap :'+dealerIdToSimilarGCCodeDealerAccountIdsMap);
        for(Id dealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.keySet()) {
            for(Id similarGCCodeDealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.get(dealerId)) {
                DealerAccId.add(similarGCCodeDealerId);
            }
        }
        // Finish: Share with all Dealer Account with same GC Code
        system.debug('DealerAccId :'+DealerAccId);
        
        // Changing Sharing from User to Public Group
        List<Account> dealerAccList = [select Name,Dealer_ND_Code__c from Account where Id IN: DealerAccId];
        system.debug('dealerAccList :'+dealerAccList);
        Set<String> dealerAccNameSet = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        for(Account dealerRec : dealerAccList) {
            dealerAccNameSet.add(dealerRec.Dealer_ND_Code__c);
            accNameToAccIdMap.put(dealerRec.Dealer_ND_Code__c, dealerRec.Id);
        }
       
        
        System.debug('DealerAccId  newList'+DealerAccId);
        System.debug('dealerAccNameSet : '+dealerAccNameSet);
        List<Vehicle_Relationship__Share> list_SharingRecord = new List<Vehicle_Relationship__Share>();
        for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]) {
            if(currentVrId != null) {
                for(Id ids:currentVrId) {
                    Vehicle_Relationship__Share vehicleRelationShare = new Vehicle_Relationship__Share();
                    vehicleRelationShare.AccessLevel = 'Edit';
                    vehicleRelationShare.UserOrGroupId = groupRec.Id;
                    vehicleRelationShare.ParentId =ids;
                    vehicleRelationShare.RowCause = Schema.Vehicle_Relationship__Share.RowCause.Manual;
                    list_SharingRecord.add(vehicleRelationShare);
                }
            }
        }
        return list_SharingRecord;
    }
    
    private static Map<Id, Set<Id>> getAllDealerAccountWithSameGCCode(Set<Id> dealerAccountIdSet) {
       
        system.debug('dealerAccountIdSet :'+dealerAccountIdSet);
        List<Account> dealerAccList = [select Id, Dealer_GC_Code__c from Account where Id =: dealerAccountIdSet AND RecordTypeId =: Dealer_RecordTypeId];
        system.debug('dealerAccList >> :'+dealerAccList);
        Map<String, Id> gcCodeToDealerAccIdMap = new Map<String, Id>();
        for(Account accRec : dealerAccList) {
            if(String.isNotBlank(accRec.Dealer_GC_Code__c)) {
                gcCodeToDealerAccIdMap.put(accRec.Dealer_GC_Code__c, accRec.Id);
            }
        }
       
        Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = new Map<Id, Set<Id>>();
        if(dealerAccList.size() > 0) {
            List<Account> similarGCCodeDealerAccountList = [select Id, Dealer_GC_Code__c from Account where Dealer_GC_Code__c IN: gcCodeToDealerAccIdMap.keySet()
                                                                    AND RecordTypeId =: Dealer_RecordTypeId AND Id NOT IN: gcCodeToDealerAccIdMap.values()];
            //system.assert(false, similarGCCodeDealerAccountList);
            for(Account accRec : similarGCCodeDealerAccountList) {
                if(!dealerIdToSimilarGCCodeDealerAccountIdsMap.containsKey(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c))) {
                    dealerIdToSimilarGCCodeDealerAccountIdsMap.put(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c), new Set<Id>());
                }
                dealerIdToSimilarGCCodeDealerAccountIdsMap.get(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c)).add(accRec.Id);
            }                                                       
        }
        //system.assert(false, dealerIdToSimilarGCCodeDealerAccountIdsMap);
        return dealerIdToSimilarGCCodeDealerAccountIdsMap;
    }
}