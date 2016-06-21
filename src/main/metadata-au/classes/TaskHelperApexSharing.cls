public class TaskHelperApexSharing {
    
    public static Map<Id,Id> mapAssigneToWhatId = new Map<Id,Id>();
    public static Map<String, Map<Id, Id>> mapWhatIdWithRecordOwner = new Map<String, Map<Id, Id>>();
    public static Map<String, String> mapObjectShare = new Map<String, String>();
    public static Set<Id > recordIds = new Set<Id >();
    public static Set<Id > userGroupIds = new Set<Id >();
    public static String sId;
    public static String sAccessLevel;

    public static String getStringFromSet(Set<Id> record){
        String SOQL_IDs = '';
        for (Id id : record) {
            String id_in_quotes = '\''+id+'\'';
            if (SOQL_IDs !='') { SOQL_IDs +=','; }
            SOQL_IDs += id_in_quotes;
        }
        return SOQL_IDs;
    }
    public static void mergeObjectWithRecord(String sObjectType, Id taskWhatId, Id whatIdOwner){
        if(mapWhatIdWithRecordOwner.containsKey(sObjectType)){
            Map<Id, Id> mapInsider = new Map<Id, Id>();
            mapInsider = mapWhatIdWithRecordOwner.get(sObjectType);
            mapInsider.put(taskWhatId, whatIdOwner);
            mapWhatIdWithRecordOwner.put(sObjectType, mapInsider);
        }else{
            Map<Id, Id> mapInsider = new Map<Id, Id>();
            mapInsider.put(taskWhatId, whatIdOwner);
            mapWhatIdWithRecordOwner.put(sObjectType, mapInsider);
        }
        System.debug('mapWhatIdWithRecordOwner=>'+mapWhatIdWithRecordOwner);
    }
    
    public static void shareRecordWithNewUser(List<Task> tasklst,Boolean isInsert, Boolean isUpdate){
        
        List<Task> tsklst = [SELECT Id, WhatId, What.Type, OwnerId FROM Task WHERE Id in :tasklst];
        System.debug('tsklst =>'+tsklst );
        for(Task taskObj : tsklst){
            System.debug('WhatType=>'+taskObj.What.Type);
            String sObjectType = taskObj.What.Type; //Get The Object Type
            mapAssigneToWhatId.put(taskObj.WhatId,taskObj.OwnerId); //Create a Map for Task and Task Owner
            mergeObjectWithRecord(sObjectType,taskObj.WhatId,taskObj.OwnerId); //Merge Object Type, WhatId, OwnerId together
        }
        
        if(mapWhatIdWithRecordOwner != null && mapWhatIdWithRecordOwner.size()>0){
            List<String> keys = new List<String>(mapWhatIdWithRecordOwner.keySet());
            if(keys != null && keys.size()>0){
            for(String sObjectKey : keys){
                if(sObjectKey.endsWith('__c')){
                    mapObjectShare.put(sObjectKey, sObjectKey.removeEndIgnoreCase('c')+'share');
                }else{
                    mapObjectShare.put(sObjectKey, sObjectKey+'share');
                }
            }
            System.debug('mapObjectShare =>'+mapObjectShare);

            for(String sObjectKey : keys){
                String listOfSobjectShare= 'List<' + mapObjectShare.get(sObjectKey) + '>';
                List<SObject> shareRecords = (List<SObject>)Type.forName(listOfSobjectShare).newInstance();
                System.debug('shareRecords '+shareRecords);
                    for(Id s : mapWhatIdWithRecordOwner.get(sObjectKey).keySet()){
                        if(mapWhatIdWithRecordOwner.get(sObjectKey).containsKey(s)){
                            Schema.SObjectType t = Schema.getGlobalDescribe().get(mapObjectShare.get(sObjectKey));
                            sObject newShare = t.newSObject();
                            System.debug('newShare'+newShare);
                            
                            if(sObjectKey.endsWith('__c')){
                                sId = 'ParentId';
                                sAccessLevel = 'AccessLevel';
                            }else{
                                sId = sObjectKey +'Id';
                                sAccessLevel = sObjectKey + 'AccessLevel';
                            }
                            
                            newShare.put(sId ,s);
                            newShare.put('UserOrGroupId',mapWhatIdWithRecordOwner.get(sObjectKey).get(s));
                            newShare.put(sAccessLevel ,'Edit');
                            if('AccountAccessLevel'.equals(sAccessLevel)){
                                newShare.put('OpportunityAccessLevel','Edit');
                            }
                            shareRecords.add(newShare);
                            recordIds.add(s);
                            userGroupIds.add(mapWhatIdWithRecordOwner.get(sObjectKey).get(s));
                        }
                    }
                    
                    if(shareRecords != null && shareRecords.size()>0){
                        String listOfSobjectRecord = 'List<' + mapObjectShare.get(sObjectKey) + '>';
                        List<SObject> recordWithUserAccess = (List<SObject>)Type.forName(listOfSobjectRecord).newInstance();

                        String query = 'SELECT '+sId+',UserOrGroupId FROM '+mapObjectShare.get(sObjectKey)+' WHERE '+sId+' IN ('+getStringFromSet(recordIds)+') AND UserOrGroupId IN ('+getStringFromSet(userGroupIds)+')';
                        System.debug('query =>'+query);
                        recordWithUserAccess = Database.query(query);
                        
                        for(sObject rm:recordWithUserAccess){
                            System.debug(rm.get('UserOrGroupId'));
                            for(integer i = 0; i<shareRecords.size(); i++){
                            System.debug(shareRecords.get(i).get('UserOrGroupId'));
                                if(shareRecords.get(i).get('UserOrGroupId').equals(rm.get('UserOrGroupId'))){
                                    shareRecords.remove(i);
                                }
                            }
                        }
                        System.debug(shareRecords);
                        if(shareRecords != null && shareRecords.size()>0){
                            insert shareRecords;
                        }
                    }
                }
            }
        }
    }
}