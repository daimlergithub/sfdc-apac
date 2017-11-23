/************************************************************************************
* Created By:Sarath M
* Created Date:22-sept-17
* Company:Infosys Ltd
* Description: 
1. method to count the vote.
2. Method to get the count from the ideasvoting object.
3. method to check whether the logged in user is RUG or Honorary member.
*************************************************************************************/
public class IdeasCommunityHelper {
    @AuraEnabled
    public static Integer getIdeaCount(Id ideaID) { 
        Integer numberOfVotes;
        //list<IdeasVoting__c> voteList = [SELECT id,IdeaLikeCount__c FROM IdeasVoting__c WHERE Ideas__c = :ideaID];
        list<ideas__c> voteList = [SELECT id,like_count__c FROM ideas__c WHERE id = :ideaID];
        if(voteList.isEmpty()){
            numberOfVotes=0;
        }else{
            //numberOfVotes = voteList.size();
            numberOfVotes = integer.valueOf(voteList[0].like_count__c);
        }
        return numberOfVotes;
    }    
    @AuraEnabled
    public static boolean getLikeEnableValue(Id ideaID) { 
        boolean iconValue=false;
        String honoraryPfid =[select Id,name from profile where name=:Label.Rug_CommunityuserProfile].id;
        list<IdeasVoting__c> voteList = [SELECT id,Likeuser__c,IdeaLikeCount__c FROM IdeasVoting__c WHERE Ideas__c = :ideaID AND Likeuser__c = :userinfo.getUserId()];
		if(honoraryPfid==userinfo.getProfileId() || !(voteList.isEmpty())){            
            iconValue=true;  
        }
        return iconValue;
    }
    
    @AuraEnabled
    public static Integer getIncrementCount(id ideaId){
        list<Ideas__c> ideaList;        
        List<IdeasVoting__c> existinguser=[select id,Likeuser__c from IdeasVoting__c where Likeuser__c =: userinfo.getUserId() AND Ideas__c=:ideaId];
        if(existinguser.isEmpty()){        
            IdeasVoting__c ideaVote=new IdeasVoting__c();
            ideaVote.Ideas__c=ideaId;
            ideaVote.IdeaLikeCount__c=true;
            ideaVote.Likeuser__c=userinfo.getUserId();
            insert ideaVote;       
            IdeaEditing__c vObj=[select id,EditingAccess__c from IdeaEditing__c LIMIT 1];
            vObj.EditingAccess__c=true;
            update vObj;        
			ideaList = [SELECT id,Like_Count__c FROM Ideas__c WHERE id = :ideaID];
            ideaList[0].like_count__c=ideaList[0].like_count__c+1;   
            update ideaList[0];
            vObj.EditingAccess__c=false;
            update vObj;
        }
        return integer.valueOf(ideaList[0].like_count__c);
    }
    @AuraEnabled
    public static List<ideas__C> getRecent5IdeaCount (){        
        return [SELECT id,Name,Status__c FROM Ideas__c WHERE Status__c = 'Open' order by createdDate desc limit 5];
    }    
    @AuraEnabled
    public static List<ideas__C> getTop5IdeaCount (){        
        return [SELECT id,Like_Count__c,Name,Status__c FROM Ideas__c WHERE Status__c = 'Open' AND Like_Count__c != null order by Like_Count__c desc limit 5];
    }
}