/************************************************************************************
* Created By:Surendranath
* Project: RCP INDONESIA
* Modified Date:09-Oct-2018
* Company:Infosys Ltd
* Description: Report on Files with all details
* **********************************************************************************/
public class rcpFilesReport {
   	@AuraEnabled
    public map<Id,News__c> newsMap;    
    @AuraEnabled
    public map<Id,List<ContentDocument>> newsIdcdListMap;
    
    @AuraEnabled     
    public map<Id,Community_Files__c> communityFileMap;    
    @AuraEnabled
    public map<Id,List<ContentDocument>> cfIdcdListMap;
    
    @AuraEnabled
    public static rcpFilesReport getDetails(){
        rcpFilesReport nR = new rcpFilesReport();
        //map<News__c,List<ContentDocument>> newsDetails = new map<News__c,List<ContentDocument>>();
        nR.newsMap= new map<Id,News__c>([select Id,Name,Owner_Name__c,Start_Date__c,Expiration_Date__c,Document_Status__c,Title__c,Share_With_Groups__c,Category_Type__c,createdDate from News__c order by createdDate desc]);
        Set<Id> newsIds = nR.newsMap.keySet();
        
        map<Id,ContentDocumentLink> cdlMap = new map<Id,ContentDocumentLink>([select Id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId IN:newsIds  ]);
        Map<Id,Id> cdnewsIds = new  Map<Id,Id>();
        Set<Id> cdIds =new Set<Id>();
        
        for (Id cdl : cdlMap.keySet()){
            cdnewsIds.put(cdlMap.get(cdl).ContentDocumentId,cdlMap.get(cdl).LinkedEntityId);
            cdIds.add(cdlMap.get(cdl).ContentDocumentId);
        }
        map<Id,ContentDocument> cdMap = new map<Id,ContentDocument> ([SELECT Id,Title, FileType, ContentSize, CreatedDate, Owner.Name   FROM ContentDocument where Id IN:cdIds]);
        nR.newsIdcdListMap =new map<Id,List<ContentDocument>>();
        List<ContentDocument> lst ;
        for(Id itr: newsIds){
            lst = new List<ContentDocument>();
            for(Id itr2 : cdnewsIds.keySet()){
                if(cdnewsIds.get(itr2) == itr){
                    lst.add(cdMap.get(itr2));
                }
            }
            nR.newsIdcdListMap.put(itr,lst);
        }
        
        //For Community Files
        Community_Files__c c = new Community_Files__c();       
        nR.communityFileMap = new map<Id,Community_Files__c>([select id,Name,Expiration_Date__c,SelectedUsers__c,SelectedGroups__c from Community_Files__c]);
        set<Id> cfIds = nR.communityFileMap.keySet();
        map<Id,ContentDocumentLink> cdl1Map = new map<Id,ContentDocumentLink>([select Id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId IN:cfIds]);
        set<Id> cd1Ids = new set<Id>();
        map<Id,set<Id>> cfcdIds = new map<Id,set<Id>>();
        for(Id key:cdl1Map.keySet()){
            cd1Ids.add(cdl1Map.get(key).ContentDocumentId);
            if(cfcdIds.containsKey(cdl1Map.get(key).LinkedEntityId)){
                set<Id> ids = cfcdIds.get(cdlMap.get(key).LinkedEntityId);
                ids.add(cdl1Map.get(key).ContentDocumentId);
                cfcdIds.put(cdl1Map.get(key).LinkedEntityId,ids);
            }
            else{
                set<Id> ids = new set<Id>();
                ids.add(cdl1Map.get(key).ContentDocumentId);
                cfcdIds.put(cdl1Map.get(key).LinkedEntityId,ids);
            }
        }       
        map<Id,ContentDocument> cd1Map = new map<Id,ContentDocument>([SELECT Id,ContentSize,FileType,Title,CreatedDate,Owner.Name FROM ContentDocument where Id IN:cd1Ids]);
        map<Id,List<ContentDocument>> cfIdcdListMap = new map<Id,List<ContentDocument>>();
        for(Id key:cfcdIds.keySet()){
            set<Id> cdids_1 = cfcdIds.get(key);
            List<ContentDocument> cdlist = new List<ContentDocument>();
            for(Id cid : cdids_1){
                if(cd1Map.containsKey(cid))
                    cdlist.add(cd1Map.get(cid));
            }
            cfIdcdListMap.put(key,cdlist);
        }
        nR.cfIdcdListMap = cfIdcdListMap;
        return nR;
    }
    
}