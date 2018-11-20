/**
Type:       Apex Class    
Purpose:    This class used to get list of Approval List, Public group from Meta data and public group members

User Story: RCP-143
Used By: reportNewsApprovers lightning component   
---------------------------------------------------------------
History:

27-Sep-2018 Surendranath  Created
*/
public class reportNewsApprovers {
    @AuraEnabled
    public map<Id,Group> groupDetails;
    @AuraEnabled
    public map<Id,List<User>> userDetails;
    @AuraEnabled
    public map<String,String> listMetaData;
    
    @AuraEnabled
    public static reportNewsApprovers getGroupUserDetails(){
        //List<String,List<String>> getusrgrpList = new List<String,List<String>>();
       	reportNewsApprovers rfg = new reportNewsApprovers();
        Map<String,String> customMap=new Map<String,String>();        
        String[] newsPublicGroups = new List<String>();
        Public_Group_Labels__mdt[] mdtNames = [select MasterLabel,Public_Group_Name__c from Public_Group_Labels__mdt];
        for(Public_Group_Labels__mdt pg :mdtNames){
            customMap.put(pg.Public_Group_Name__c, pg.MasterLabel);
            newsPublicGroups.add(pg.Public_Group_Name__c);
        }
        rfg.listMetaData = customMap;
        System.debug('customMap:'+customMap);
        System.debug('newsPublicGroups:'+newsPublicGroups);
        map<Id,set<Id>> grpusrMap = new map<Id,set<Id>>();
        set<Id> usrIds = new set<Id>();
        
        List<Group> grpList = [Select Id,DeveloperName,(select id,GroupId,UserOrGroupId from GroupMembers) from Group where  Group.Type='Regular' and DeveloperName IN:newsPublicGroups];
        rfg.groupDetails = new map<Id,Group>([Select Id,DeveloperName,Group.Type from Group where Group.Type='Regular' and DeveloperName IN:newsPublicGroups]);        
        for(Group g : grpList){
            set<Id> gmIds = new set<Id>();
            for(GroupMember gm : g.GroupMembers){
                gmIds.add(gm.UserOrGroupId);
                usrIds.add(gm.UserOrGroupId);
            }
            grpusrMap.put(g.Id,gmIds);
        }
        map<Id,List<User>> grpIduserListMap = new map<Id,List<User>>();
        if(usrIds != null && usrIds.size() > 0){            
            map<Id,user> userMap = new map<Id,user>([select id,Name from user where Id IN:usrIds]);            
            for(Id key : grpusrMap.keySet()){
                set<Id> uIds = grpusrMap.get(key);
                List<User> userList = new List<User>();
                for(Id uid : uIds){
                    userList.add(userMap.get(uid));
                }
                grpIduserListMap.put(key,userList);
            }  
            rfg.userDetails = grpIduserListMap;
        }        
        return rfg;
    }
}