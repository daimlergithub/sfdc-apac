public class communityFileReport {
    @AuraEnabled
    public map<Id,Community_Files__c> communityFileMap;    
    @AuraEnabled
    public map<Id,List<ContentDocument>> cfIdcdListMap;
    @AuraEnabled
    public static communityFileReport getfileDetails(){
        communityFileReport cfr = new communityFileReport();
        Community_Files__c c = new Community_Files__c();       
        cfr.communityFileMap = new map<Id,Community_Files__c>([select id,Name,Expiration_Date__c,SelectedUsers__c,SelectedGroups__c,Related_Files__c,Expired__c  from Community_Files__c]);
        set<Id> cfIds = cfr.communityFileMap.keySet();
        map<Id,ContentDocumentLink> cdlMap = new map<Id,ContentDocumentLink>([select Id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId IN:cfIds]);
        set<Id> cdIds = new set<Id>();
        map<Id,set<Id>> cfcdIds = new map<Id,set<Id>>();
        for(Id key:cdlMap.keySet()){
            cdIds.add(cdlMap.get(key).ContentDocumentId);
            if(cfcdIds.containsKey(cdlMap.get(key).LinkedEntityId)){
                set<Id> ids = cfcdIds.get(cdlMap.get(key).LinkedEntityId);
                ids.add(cdlMap.get(key).ContentDocumentId);
                cfcdIds.put(cdlMap.get(key).LinkedEntityId,ids);
            }
            else{
                set<Id> ids = new set<Id>();
                ids.add(cdlMap.get(key).ContentDocumentId);
                cfcdIds.put(cdlMap.get(key).LinkedEntityId,ids);
            }
        }       
        map<Id,ContentDocument> cdMap = new map<Id,ContentDocument>([SELECT Id,ContentSize,FileType,Title FROM ContentDocument where Id IN:cdIds]);
        map<Id,List<ContentDocument>> cfIdcdListMap = new map<Id,List<ContentDocument>>();
        for(Id key:cfcdIds.keySet()){
            set<Id> cdids_1 = cfcdIds.get(key);
            List<ContentDocument> cdlist = new List<ContentDocument>();
            for(Id cid : cdids_1){
                if(cdMap.containsKey(cid))
                    cdlist.add(cdMap.get(cid));
            }
            cfIdcdListMap.put(key,cdlist);
        }
        cfr.cfIdcdListMap = cfIdcdListMap;
        return cfr;
    }
}