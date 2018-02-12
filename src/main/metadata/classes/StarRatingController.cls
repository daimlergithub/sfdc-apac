/************************************************************************************
* Created By:Sarath M
* Created Date:11-Nov-17
* Company:Infosys Ltd
* Description: 1. Display star rating and count the number of points.
* ***********************************************************************************/
public without sharing class StarRatingController { 
    
    @AuraEnabled
    public static Void createRatingDB(Decimal ratingDB,String AssigneeId){      
        try{
            List<IdeasVoting__c> feedreqId=new list<IdeasVoting__c>();
            feedreqId = [select id, rating__c from IdeasVoting__c where Ideas__c=:AssigneeId and Likeuser__c=:userinfo.getUserId()];
            if(feedreqId.size()>0){
                feedreqId[0].rating__c=ratingDB;
                update feedreqId;   
            }
            else{
                IdeasVoting__c rating=new IdeasVoting__c();
                rating.Rating__c=ratingDB;
                rating.Likeuser__c=userinfo.getUserId();
                rating.Ideas__c=AssigneeId;
                insert rating;
            }
        }     
        catch(Exception ex){
            system.debug('Exception-->'+ex);
        }
    }
    
    @AuraEnabled
    public static Integer getRatingOnLoad(String fId){      
        Integer numRating;
        try{ 
            List<IdeasVoting__c> ideasVotingList=new list<IdeasVoting__c>();
            ideasVotingList = [select id,rating__c from IdeasVoting__c where Ideas__c=:fId and Likeuser__c=:userinfo.getUserId() limit 1];
            if(ideasVotingList.size()>0){
                numRating =Integer.valueOf(ideasVotingList[0].Rating__c);
            }
            else{
                numRating=0;
            }
        }     
        catch(Exception ex){
            system.debug('Exception-->'+ex);
        }
        return numRating;
    }
    
    @AuraEnabled
    public static Integer getPointsCount(String ideaId){
        integer ideaScore=0;
        AggregateResult[] groupedResults = [SELECT ideas__c,sum(rating__c) score FROM IdeasVoting__c where ideas__c=:ideaId group by ideas__c];
        list<ideas__c> ideaList = [SELECT id,like_count__c FROM ideas__c WHERE id = :ideaID];
        
        if(ideaList.size()>0 && groupedResults.size()>0 && ideaList[0].like_count__c != integer.valueOf(groupedResults[0].get('score'))){
        ideaList[0].like_count__c=integer.valueOf(groupedResults[0].get('score'));        
            update ideaList;
        }
        if(groupedResults.size()>0 && integer.valueOf(groupedResults[0].get('score'))==null){
             return 0;
        }else if(groupedResults.size()>0){                           
            return integer.valueOf(groupedResults[0].get('score'));
        }
        return 0;
    }
    @AuraEnabled
    public static boolean getRatingEnableValue(Id ideaID) { 
        boolean iconValue=true;
        String honoraryPfid =[select Id,name from profile where name=:Label.Rug_CommunityuserProfile].id;  
        list<PermissionSetAssignment> honoraryPset=[SELECT AssigneeId,PermissionSet.name FROM PermissionSetAssignment WHERE AssigneeId = :userinfo.getUserId() AND PermissionSet.name = :Label.HonoraryCommunityPermissionSet];           
		if(honoraryPfid==userinfo.getProfileId() && honoraryPfid != null || honoraryPset.size()>0){          
            iconValue=false; 
        }       
        return iconValue;
    }
}