/************************************************************************************
* Created By:Kavya Bondada
* Project: RCP INDONESIA
* Modified Date:27-sep-2018
* Company:Infosys Ltd
* Description: Report on News with all details
* **********************************************************************************/
public class newsReport {
   	@AuraEnabled
    public map<Id,News__c> newsMap;    
    @AuraEnabled
    public map<Id,List<ContentDocument>> newsIdcdListMap;
    @AuraEnabled
    public static newsReport getDetails(){
        newsReport nR = new newsReport();
        //map<News__c,List<ContentDocument>> newsDetails = new map<News__c,List<ContentDocument>>();
        nR.newsMap= new map<Id,News__c>([select Id,Name,Owner_Name__c,Start_Date__c,Expiration_Date__c,Document_Status__c,Title__c,Share_With_Groups__c,Category_Type__c,createdDate from News__c order by createdDate desc  ]);
        Set<Id> newsIds = nR.newsMap.keySet();
        
        map<Id,ContentDocumentLink> cdlMap = new map<Id,ContentDocumentLink>([select Id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where LinkedEntityId IN:newsIds  ]);
        Map<Id,Id> cdnewsIds = new  Map<Id,Id>();
        Set<Id> cdIds =new Set<Id>();
        
        for (Id cdl : cdlMap.keySet()){
            cdnewsIds.put(cdlMap.get(cdl).ContentDocumentId,cdlMap.get(cdl).LinkedEntityId);
            cdIds.add(cdlMap.get(cdl).ContentDocumentId);
        }
        map<Id,ContentDocument> cdMap = new map<Id,ContentDocument> ([SELECT Id,Title, FileType, ContentSize  FROM ContentDocument where Id IN:cdIds]);
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
        //system.debug('det'+newsDetails);
        return nR;
    }
    
}