/************************************************************************************
* Project:RCP Indonesia : Dealer Community Indonesia
* Created By:Narendra.I
* Created Date:12-July-2018
* Company:Infosys Ltd
* Description:Class to return recent published News records and used as server side controller for RCPNewscmp
* **********************************************************************************/
public with sharing class newsController {
    @AuraEnabled
    public List<News__c> newsList;
    @AuraEnabled
    public Boolean Subscribe;    
    
    private static boolean firstRun = true;    
    public static boolean isFirstRun(){
        if(firstRun){
            firstRun = false;
            return true;
        }else{
            return firstRun;
        }
    }
    
    @AuraEnabled
    public static newsController recentNews(){
        newsController newsContr = new newsController();
        Date dt = Date.today();        
        newsContr.newsList = [select id,name,Title__c from News__c WHERE Document_Status__c = 'Published' and Start_Date__c <=:dt ORDER BY Start_Date__c DESC NULLS FIRST LIMIT 5];
        Id userId = UserInfo.getUserId();
        newsContr.Subscribe = [select Subscribe__c from User where Id=:userId].Subscribe__c;        
        return newsContr;
    }
    @AuraEnabled
    public static void SubscribeNews(Boolean Subs){
        System.debug('Subs '+Subs);
        Id userId = UserInfo.getUserId();
        User usr = [select id,Subscribe__c from User where Id=:userId];
        usr.Subscribe__c = Subs;
        update usr;        
    } 
    @AuraEnabled
    public static List<ContentDocument> getFiles(String newsid){         
        List<ContentDocumentLink> CDLs = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId = :newsid];
        if (CDLs.size() < 1) return new List<ContentDocument>();         
        // Make a List of ContentDocument IDs
        List <Id> CDIdList = new List <Id> ();
        for (ContentDocumentLink nextCDL : CDLs) {
            CDIdList.add(nextCDL.ContentDocumentId); }        
        
        List<ContentDocument> entries = [SELECT Id,Title, FileType, ContentSize  FROM ContentDocument WHERE ContentDocument.Id IN :CDIdList];
        System.debug('entries '+entries);
        return entries;
    } 
    @AuraEnabled
    public static List<ContentDocument> detailedFile(String fileId,String newsid){
        System.debug('fileId '+fileId);
        ContentDocument cDOC = [SELECT Id FROM ContentDocument where Id =:fileId ];
        if(cDOC !=null){
            delete cDOC;
            return newsController.getFiles(newsid);
        }
        return null;
    }
    
    //Trigger call
    //Description: to inform Approver to change details for Approved News if required before approval .
    //RCP-29 : As MPC, if the approver approves the document after the start date, then give approver the option to revise the start date
    public static void onBeforeupdate(List<News__c> newslst) {
        String recTypeId=Schema.SObjectType.News__c.getRecordTypeInfosByName().get('News Approval').getRecordTypeId();
        for(News__c news:newslst){
            List <ProcessInstance> pi = [SELECT Id, CreatedDate from ProcessInstance where TargetObjectId = :news.Id ORDER BY CreatedDate DESC limit 1];
            //checking for approval process initiated
            If(pi.size()>0){
                List <ProcessInstanceStep> n = [SELECT Id, StepStatus, ActorId, OriginalActorId, CreatedDate FROM ProcessInstanceStep where ProcessInstanceId = :pi[0].Id ORDER BY CreatedDate DESC limit 1];
                //and its status
                if(n.size()>0 && news.Approval_Status__c=='Approved'){
                    if(news.Start_Date__c < system.today()){
                        //news.RecordTypeId=recTypeId;
                        news.addError('Please change Start Date in News to future or present date.');
                    }
                }
            }       
        }       
    }
    //used for RCPNewsCmp to update News
    @AuraEnabled
    public static void updateNews(Id recordId){
        News__c n= new News__c();
        n.Id=recordId;
        n.DocStatus_FileUpload__c=false;
        update n; 
    }
    
    //Trigger call
    // To update files count on News. This field will be used to show Message on Next Steps field   
    public static void onAfterupdate(List<News__c> newslst) {        
        if(isFirstRun()){
            Set<Id> newsIds = new Set<Id>();
            List<News__c> updateNews = new List<News__c>();
            for(News__c n:newslst){
                newsIds.add(n.Id);
            }
            System.debug('newsIds '+newsIds);
            List<ContentDocumentLink> CDLs = [SELECT Id,ContentDocumentId,LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId IN: newsIds];
            if(CDLs.size() > 0){
                for(News__c n:newslst){
                    Integer count = 0;
                    News__c news=new News__c();
                    for(ContentDocumentLink cdl:CDLs){            
                        if(n.Id==cdl.LinkedEntityId){
                            news.Id = n.Id;
                            news.Files_Info__c = Label.MBDINA_RCP_Files_Info;
                            updateNews.add(news);
                            break;
                        }
                    }
                    
                }
            }            
            if(updateNews.size() > 0){
                update updateNews;
            }
        }
    }
}