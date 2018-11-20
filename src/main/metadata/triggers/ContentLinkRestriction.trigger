/************************************************************************************
* Project:RCP Indonesia : Dealer Community Indonesia
* Created By:Narendra.I
* Created Date:06-Aug-2018
* Company:Infosys Ltd
* Description:trigger to restrict 'Indonesia Dealer' profile users to uploading the files related to News.
* **********************************************************************************/
trigger ContentLinkRestriction on ContentDocumentLink (before insert) {
    
    
    if(trigger.isBefore && trigger.isInsert){
        
        Id profileId=userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
        //if(Test.isRunningTest())
            //profileName = Label.Indonesia_Dealer_RCP;
        System.debug('LinkedEntity.Type '+ profileName); 
        Set<Id> newsIds = new Set<Id>();
        Set<Id> communityIds = new Set<Id>();
        for(ContentDocumentLink CDL : trigger.new){            
            String objName = String.valueOf(CDL.LinkedEntityId.getsobjecttype());
            System.debug('objName '+objName);
            if(objName == Label.News_Object_Name_RCP){
                newsIds.add(CDL.LinkedEntityId);
                if(profileName == Label.Indonesia_Dealer_RCP){                
                    CDL.ContentDocumentId.addError('You do not have access to upload Files under News.');
                }
            }
            else if(objName == Label.Community_Files_Object_Name_RCP){
                communityIds.add(CDL.LinkedEntityId);
                CDL.ShareType='V';
                CDL.Visibility='AllUsers';                
            }        
        }
        if(communityIds.size() > 0){
            Id uId = UserInfo.getUserId();
            List<Community_Files__c> filesList = [select Id,OwnerId from Community_Files__c where Id IN:communityIds];
            for(Community_Files__c cf:filesList){
                if(cf.OwnerId != uId)
                    trigger.new[0].ContentDocumentId.addError('You do not have access to upload Files under News.');
            }            
        }
    }       
}