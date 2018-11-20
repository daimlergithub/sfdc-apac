/************************************************************************************
* Project:RCP Indonesia : Dealer Community Indonesia
* Created By:Narendra.I
* Created Date:31-Aug-2018
* Company:Infosys Ltd
* Date Changed:
* Description:Class to Search records like lookup.
* **********************************************************************************/
public without sharing class reUsableMultiSelectLookupCtrl {
    //Dynamic search based on object
    @AuraEnabled
    public static List < sObject > fetchLookUpValues(string cfid,String searchKeyWord, String ObjectName, List<sObject> ExcludeitemsList) {
        //Id profileId=userinfo.getProfileId();
        //String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        Id userId = UserInfo.getUserId();
        String userLicense = [Select Id,Profile.UserLicense.Name from user where Id=:userId].Profile.UserLicense.Name;
        system.debug('userLicense'+userLicense);
        
        String searchKey = '%' + searchKeyWord + '%';
        String sQuery='';
        
        List < sObject > returnList = new List < sObject > ();
        
        List<string> lstExcludeitems = new List<string>();
        for(sObject item : ExcludeitemsList ){
            lstExcludeitems.add(item.id);
        }
        //for user dynamic search        
        
        Community_Files__c CFR = [select id,SelectedUsers__c,SelectedGroups__c,OwnerId from Community_Files__c where Id=:cfid];
        if(ObjectName == 'User'){            
            List<User> usList = new List<User>();
            lstExcludeitems.add(CFR.OwnerId);
            if(CFR.SelectedUsers__c!=null && CFR.SelectedUsers__c!=''){ 
                Set<String> selUserList = new Set<String>();
                selUserList.addAll(CFR.SelectedUsers__c.split(','));  
                usList = [select id from user where Name IN:selUserList];
                for(user u : usList){
                    lstExcludeitems.add(u.Id);
                }
            }
            if(userLicense == 'Partner Community'){
                //set<Id> profileIdset = new set<Id>();
                //profileId = [SELECT Id,Name FROM Profile WHERE Name =: Label.Indonesia_System_Admin_RCP].Id;
                //profileIdset.add(profileId);
                List<string> licenseList = new List<string>();
                licenseList.add('Salesforce');
                sQuery = 'select id, Name from User where Name LIKE: searchKey AND Id NOT IN : lstExcludeitems AND Market__c=\'ID\' AND Profile.UserLicense.Name IN:licenseList order by createdDate DESC limit 5';            
            }
            else{               
                sQuery = 'select id, Name from User where Name LIKE: searchKey AND Id NOT IN : lstExcludeitems AND Market__c=\'ID\' order by createdDate DESC limit 5';            
            }
            
        }
        else if (ObjectName=='Group'){
            string condition='';
            if(userLicense == 'Partner Community')
                condition = 'MBDINA%';   
            else
                condition= 'MBDINA_RCP_MPC_FileShare%';
            
            if(CFR.SelectedGroups__c!=null && CFR.SelectedGroups__c!=''){
                List<Group> grpList = new List<Group>();
                Set<String> selGroupList = new Set<String>();
                selGroupList.addAll(CFR.SelectedGroups__c.split(','));  
                grpList = [select id from Group where Name IN:selGroupList];
                for(Group g : grpList){
                    lstExcludeitems.add(g.Id);
                }
            }
            sQuery = 'select id, Name from Group where Name LIKE: searchKey AND Id NOT IN : lstExcludeitems AND Name LIKE: condition order by createdDate DESC limit 5';            
        }
        // Create a Dynamic SOQL Query For Fetch Record List with LIMIT 5 and exclude already selected records  
        //String sQuery =  'select id, Name from ' +ObjectName + ' where Name LIKE: searchKey AND Id NOT IN : lstExcludeitems AND condition order by createdDate DESC limit 5';
        System.debug('sQuery '+sQuery);
        List < sObject > lstOfRecords = Database.query(sQuery);
        
        for (sObject obj: lstOfRecords) {
            returnList.add(obj);
        }
        return returnList;
    }
    @AuraEnabled
    public static Boolean getrecordDetails(String cfId){
        Community_Files__c cf = [select id,OwnerId from Community_Files__c where Id=:cfId];
        
        if(cf.OwnerId != UserInfo.getUserId()){
            return true;
        }
        return false;       
    }
    //Share Community File record with selected users and groups
    @AuraEnabled
    public static void shreRecord(String cfId,List<SObject> usrList,List<SObject> selgrps){
        System.debug('selgrps '+selgrps.size());
        String shrLevel = 'Viewer';
        if(usrList != null && usrList.size() > 0){
            set<Id> uId = new set<Id>();
            for(SObject obj:usrList){
                uId.add(obj.Id);
            }
            if(uId!=null && uId.size() > 0){
                sharewithUsersGroups(uId,cfId,shrLevel);
                sharerelatedFile(uId,cfId,shrLevel);
                List<User> userRec = [select id,Email,Name from user where id IN:uId];
                List<String> emailList = new List<String>();
                Community_Files__c CFR = [select Id,Expiration_Date__c,Name,SelectedUsers__c,SelectedGroups__c,Owner.Name from Community_Files__c where Id=:cfId];
                //String name = CFR.OwnerId.Name;
                String selUsers='';
                if(CFR.SelectedUsers__c!=null && CFR.SelectedUsers__c!='' ){
                    selUsers=CFR.SelectedUsers__c;
                }
                for(User u:userRec){           
                    if(selUsers==''){
                        selUsers=u.Name;
                    }
                    else
                        selUsers=selUsers+','+u.Name;                   
                    emailList.add(u.Email);                    
                }                
                updatecommunityFile(selUsers,'',CFR.Id);                
                sendMail(emailList,CFR);                
            }                       
        }
        if(selgrps != null && selgrps.size() > 0){
            set<Id> grpId = new set<Id>();
            for(SObject obj:selgrps){
                grpId.add(obj.Id);
            }
            if(grpId !=null && grpId.size() > 0){
                Community_Files__c rec = [select Id,Expiration_Date__c,Name,SelectedGroups__c,Owner.Name,OwnerId from Community_Files__c where Id=:cfId];
                sharewithUsersGroups(grpId,cfId,shrLevel);
                sharerelatedFile(grpId,cfId,shrLevel);
                List<Group> groupMemberList = [SELECT Id,Name, (select userOrGroupId from groupMembers where Id !=: rec.OwnerId) FROM group WHERE Id IN:grpId and Type = 'Regular'];
                set<Id> guids = new set<Id>();
                for(Group grp : groupMemberList){
                    
                    for(GroupMember GM : grp.groupMembers){
                        guids.add(GM.UserOrGroupId);
                    }
                }
                List<User> userRec = [select id,Email from user where id IN:guids];
                List<String> emailList = new List<String>();
                for(User u:userRec){
                    emailList.add(u.Email);
                }     
                
                String selGroup = '';
                if(rec.SelectedGroups__c != null && rec.SelectedGroups__c != ''){
                    selGroup = rec.SelectedGroups__c;
                }                
                for(Group g:groupMemberList){           
                    if(selGroup==''){
                        selGroup=g.Name;
                    }
                    else
                        selGroup=selGroup+','+g.Name;                 
                    
                }
                updatecommunityFile('',selGroup,rec.Id);  
                sendMail(emailList,rec);
            } 
        } 
    }
    //Share with Users and Groups
    public static void sharewithUsersGroups(set<Id> GrouporUserIds,Id recordId,String level){
        System.debug('GrouporUserIds '+GrouporUserIds);
        List<Community_Files__Share> communityshareList = new List<Community_Files__Share>();
        for(Id ugid : GrouporUserIds){            
            Community_Files__Share fileShr  = new Community_Files__Share();     
            fileShr.ParentId = recordId;            
            fileShr.UserOrGroupId = ugid;            
            if(level=='Viewer')
                fileShr.AccessLevel = 'Read'; 
            //else if(level == 'Collaborator')
            //fileShr.AccessLevel = 'Edit';            
            fileShr.RowCause = Schema.Community_Files__Share.RowCause.Manual;
            communityshareList.add(fileShr);            
        }    
        insert communityshareList;        
    }
    //Give access to related files
    public static void sharerelatedFile(Set<Id> uId,Id cfId,string shrLevel){
        List<ContentDocumentLink> CDLL = [select Id,Visibility,ShareType from ContentDocumentLink where LinkedEntityId=:cfId ];
        List<ContentDocumentLink> updateCDL = new List<ContentDocumentLink>();
        for(ContentDocumentLink CL : CDLL){
            if(CL != null){
                CL.Visibility='AllUsers';
                CL.ShareType ='V';
                updateCDL.add(CL);
            }
        }  
        if(updateCDL !=null && updateCDL.size()>0)
            update updateCDL;
        
    }
    //add selected users and groups
    public static void updatecommunityFile(String selUsers,String selGroup,Id cfId){
        System.debug('updatecommunityFile '+selGroup);
        Community_Files__c CFR = [select Id,Expiration_Date__c,Name,SelectedUsers__c,SelectedGroups__c from Community_Files__c where Id=:cfId];        
        if(selUsers !=''){
            CFR.SelectedUsers__c = selUsers;            
        }            
        else if(selGroup !=''){
            CFR.SelectedGroups__c = selGroup;            
        }            
        update CFR;
    }
    //To send mail to shared users regarding file sharing.
    public static void sendMail(List<String> emailList,Community_Files__c rec) {
        System.debug('emailList '+emailList);
        if(emailList != null && emailList.size() > 0){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();            
            mail.setToAddresses(emailList); 
            String ownerName = rec.owner.Name;
            mail.setSubject(' '+ownerName+' has shared a file with you on Daimler South East Asia Pte Ltd - Asia org');
            string body = 'Good Day <br/><br/> The file is shared with you.<br/><br/> Name :'+rec.Name+'<br/> Expiration Date :'+rec.Expiration_Date__c+'<br/> <a href="'+Label.Indonesia_Community_URL_RCP+rec.Id+'">Click here to access the file</a>';
            mail.setHtmlBody(body);
            System.debug('body '+body);            
            List<Messaging.SendEmailResult> mailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            if(mailResult != null && mailResult.size() > 0){
                for(Messaging.SendEmailResult result : mailResult){
                    if(!result.isSuccess()){
                        System.debug('Error Message '+result.getErrors()[0].getMessage());
                    }
                    else{
                        System.debug('Error Message '+result);
                    }
                }
            }
        }
    }
    //To send email notifications manually 
    @AuraEnabled
    public static Boolean emailNotification(String cfId){
        Community_Files__c CFR = [select Id,Expiration_Date__c,Name,SelectedUsers__c,SelectedGroups__c,Owner.Name from Community_Files__c where Id=:cfId];
        if((CFR.SelectedUsers__c!=null && CFR.SelectedUsers__c!='') || (CFR.SelectedGroups__c!=null && CFR.SelectedGroups__c!='')){         
            List<User> userList = new List<User>();
            if(CFR.SelectedUsers__c!=null && CFR.SelectedUsers__c!=''){
                String selUsers='';
                set<String> userSet = new set<String>();
                selUsers=CFR.SelectedUsers__c;            
                userSet.addAll(selUsers.split(','));
                userList = [select id,Email,Name from user where Name IN:userSet];
            }
            if(CFR.SelectedGroups__c!=null && CFR.SelectedGroups__c!=''){
                String selGroups='';
                set<String> groupSet = new set<String>();
                selGroups=CFR.SelectedUsers__c;            
                groupSet.addAll(selGroups.split(','));
                List<Group> groupMemberList = [SELECT Id,Name, (select userOrGroupId from groupMembers) FROM group WHERE Name IN:groupSet and Type = 'Regular'];
                set<Id> guids = new set<Id>();
                for(Group grp : groupMemberList){                
                    for(GroupMember GM : grp.groupMembers){
                        guids.add(GM.UserOrGroupId);
                    }
                }
                List<User> userRec = [select id,Email,Name from user where id IN:guids];
                userList.addAll(userRec);
            }
            if(userList.size() > 0 ){
                set<String> userEmail = new set<String>();
                List<String> emailList = new List<String>();
                for(User us:userList){
                    userEmail.add(us.Email);
                }
                emailList.addAll(userEmail);
                sendMail(emailList,CFR);
            }
            return true;
        }
        return false;
    }
}