/************************************************************************************
* Project:RCP Indonesia : Dealer Community Indonesia
* Created By:Narendra.I
* Created Date:06-Aug-2018
* Company:Infosys Ltd
* Description:trigger to restrict users by deleting the file other than owner.
* **********************************************************************************/
trigger restrictFiledeletion on ContentDocument (before delete) {
    if(trigger.isBefore && trigger.isDelete){
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        if(profileName != 'System Administrator'){
            Id usId = UserInfo.getUserId();
            Set<Id> docIdsobjIds = new Set<Id>();
            System.debug('delete '+usId);
            set<Id> cdIds = trigger.oldMap.keySet();
            map<Id,string> cdinfo = new map<Id,string>();
            for(ContentDocument CD : trigger.old){                
                cdinfo.put(CD.Id,CD.OwnerId);
            }            
            List<ContentDocumentLink> cdlList = [select id,LinkedEntityId,ContentDocumentId from ContentDocumentLink where ContentDocumentId IN:cdIds];
            for(ContentDocumentLink cdl : cdlList){
                String objName = String.valueOf(cdl.LinkedEntityId.getsobjecttype());
                if(objName == Label.Community_Files_Object_Name_RCP){
                    if(cdinfo.get(cdl.ContentDocumentId) != usId){                    
                        trigger.old[0].Title.addError('you do not have access to delete.');
                    }
                }
            }  
        }
    }
}