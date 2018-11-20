public class reportForGroups {
    @AuraEnabled
    public map<Id,Group> groupDetails;
    @AuraEnabled
    public map<Id,List<User>> userDetails;
    
    @AuraEnabled
    public static reportForGroups getGroupUserDetails(){
        //List<String,List<String>> getusrgrpList = new List<String,List<String>>();
        map<Id,set<Id>> grpusrMap = new map<Id,set<Id>>();
        set<Id> usrIds = new set<Id>();
        reportForGroups rfg = new reportForGroups();
        List<Group> grpList = [Select Id,DeveloperName,(select id,GroupId,UserOrGroupId from GroupMembers) from Group where  Group.Type='Regular' and DeveloperName like '%MBDINA%'];
        rfg.groupDetails = new map<Id,Group>([Select Id,DeveloperName,Group.Type from Group where Group.Type='Regular' and DeveloperName like '%MBDINA%']);        
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
        for(Id key : grpIduserListMap.keySet()){             
           Group gr = rfg.groupDetails.get(key);
            String grp = gr.DeveloperName;            
            List<String> nameList = new List<String>();            
        }
        System.debug('rfg '+rfg.groupDetails.size());
        return rfg;
    }
}