/**
Type:       Trigger for User After Update    
Purpose:    1. To add users to public groupBy:    
---------------------------------------------------------------
History:

20-August-2018 Narendra  Created
*/
public class UserTriggerSubscribeHandler {
    /*@future
    public static void addUsersTosubscribegroup(set<Id> userIds){
        //Get the groups that the user should be added to
        Group g=[select Id from Group Where DeveloperName=:Label.News_Subscribed_Users_Group_Name_RCP and Type='Regular'];
        
        Set<Id> GrpuserIdSet = new Set<Id>();
        GrpuserIdSet = userIds;
        for( GroupMember gm : [select id from GroupMember  WHERE groupId =: g.Id ]) {              
            
            userIds.remove(gm.id);
        }       
        System.debug('userIds '+userIds);
        // add your profile name here or store them in Customsetting and use them
        List<User> users=[select id from user where id IN: userIds AND isActive = true and Subscribe__c = true ]; 
        System.debug('users '+users);
        List<GroupMember>listGroupMember =new List<GroupMember>();  
        List<GroupMember>removelistGroupMember =new List<GroupMember>(); 
        // loop the users that have been created
        for (User user : users) {
            GroupMember gm= new GroupMember(); 
            gm.GroupId=g.id;
            gm.UserOrGroupId = user.id;
            listGroupMember.add(gm);   
        }        
        if(listGroupMember.size() > 0)
            insert listGroupMember;
        
        Map<Id,User> usersToremove = new Map<Id,User> ([select id from user where id IN: GrpuserIdSet AND isActive = true and Subscribe__c = false ]); 
        System.debug('usersToremove '+usersToremove);
        if(usersToremove != null && usersToremove.size()>0){
            Set<Id> uidToremove = usersToremove.keySet();
            removelistGroupMember = [select Id from GroupMember where GroupId=:g.Id and UserOrGroupId IN:uidToremove ];
            
            if(removelistGroupMember.size() > 0)
                delete removelistGroupMember;
        }   
    }*/
    public static void defaultSubscribefeature(List<User> lstUsers){
        for(User usr:lstUsers){
            if(usr.Market__c == 'ID'){
                usr.Subscribe__c = true;
                usr.Subscribed_To_Event__c = true;
            }
        }
    }
    /*public static void addusersToGroup(List<User> lstUsers){
        List<User> usrList = new List<User>();
        for(User usr:lstUsers){
            if(usr.Market__c == 'ID'){
                usrList.add(usr);
            }
        }
        if(usrList != null && usrList.size() > 0){
            Group newsgrp=[select Id from Group Where DeveloperName=:Label.News_Subscribed_Users_Group_Name_RCP and Type='Regular'];
            Group eventsgrp=[select Id from Group Where DeveloperName=:Label.MBDINA_RCP_Events_Subscribe and Type='Regular'];
            List<GroupMember>newslistGroupMember =new List<GroupMember>();
            List<GroupMember>eventslistGroupMember =new List<GroupMember>();
            for (User user : usrList) {
                GroupMember newsgm= new GroupMember();
                GroupMember eventsgm= new GroupMember();
                //news subscribers
                newsgm.GroupId=newsgrp.id;
                newsgm.UserOrGroupId = user.id;
                newslistGroupMember.add(newsgm);   
                //events subscribers
                eventsgm.GroupId=eventsgrp.id;
                eventsgm.UserOrGroupId = user.id;
                eventslistGroupMember.add(eventsgm); 
            }        
            if(newslistGroupMember.size() > 0)
                insert newslistGroupMember;
            if(eventslistGroupMember.size() > 0)
                insert eventslistGroupMember;
        }
    }*/
}