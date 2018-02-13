public class UserHelperBase{
	public static void shareRecordsAfterInsertAndUpdate(List<User> triggerUserLst,string Market)
    {
        List<User> usersWithDNClst=new List<User>();
        List<Id> userIdLst=new List<Id>();
        Set<String> DealerCodesLst=new Set<String>();
        List<Id> triggerUserIdLst=new List<Id>();
        for(User usr:triggerUserLst)
        {
            triggerUserIdLst.add(usr.Id);
        }
        List<User> userLst=[select Id,ContactId,Contact.Account.Dealer_Nd_code__c,Market__c from User where Id IN:triggerUserIdLst];
        for(User usr:userLst)
        {
            //user who have dealer code and market is TH
            if(usr.ContactId!=null && usr.Contact.Account.Dealer_Nd_code__c!=null && usr.Market__c==market)
            {
                //String dealerCode=market+usr.Contact.Account.Dealer_Nd_code__c;
                String dealerCode=usr.Contact.Account.Dealer_Nd_code__c;
				DealerCodesLst.add(dealerCode);
                usersWithDNClst.add(usr);
                userIdLst.add(usr.Id);
            }
        }
       
        List<User> usersWOGrp=new List<User>();
        List<User> usersWHGrp=new List<User>();
        if(usersWithDNClst!=null && usersWithDNClst.size()>0)
        {
            Map<Id,Group> groupIdGroupObjMap=new Map<Id,Group>([select Id,Name from Group where Name IN: DealerCodesLst]);
            Set<String> groupNamesSet=new Set<String>();
            for(Id grpId:groupIdGroupObjMap.keySet())
            {
                groupNamesSet.add(groupIdGroupObjMap.get(grpId).Name);
            }
            for(User usr:usersWithDNClst)
            {
                //String DealerNCode=Market+usr.Contact.Account.Dealer_Nd_code__c;
                String DealerNCode=usr.Contact.Account.Dealer_Nd_code__c;
			   //if aready group is present for the user
                if(groupNamesSet.contains(DealerNCode))
                {
                    usersWHGrp.add(usr);
                }
                else //if group is not present
                {
                    usersWOGrp.add(usr);
                }
            }
            if(usersWOGrp!=null && usersWOGrp.size()>0)
            {
                //create group
                createGroup(usersWOGrp,Market);
            }
            if(usersWHGrp!=null && usersWHGrp.size()>0)
            {
                //add user to the group
                addUsersToGroup(usersWHGrp,market);
            }
         if(!Test.isRunningTest())
         {
            FlexQueue.moveJobToEnd(Database.Executebatch(new ShareALLRecordsToNewUserBatch(userIdLst,'Account_Link__c',Market))); 
            FlexQueue.moveJobToEnd(Database.Executebatch(new ShareALLRecordsToNewUserBatch(userIdLst,'Lead__c',Market)));
            FlexQueue.moveJobToEnd(Database.Executebatch(new ShareALLRecordsToNewUserBatch(userIdLst,'Case',Market)));
            FlexQueue.moveJobToEnd(Database.Executebatch(new ShareALLRecordsToNewUserBatch(userIdLst,'Vehicle_Relationship__c',Market)));
            FlexQueue.moveJobToEnd(Database.Executebatch(new ShareALLRecordsToNewUserBatch(userIdLst,'User',Market)));
         }
      else
        {
            Database.Executebatch(new ShareALLRecordsToNewUserBatch(userIdLst,'Account_Link__c',Market));
            Database.Executebatch(new ShareALLRecordsToNewUserBatch(userIdLst,'Lead__c',Market));
            Database.Executebatch(new ShareALLRecordsToNewUserBatch(userIdLst,'Case',Market));
            Database.Executebatch(new ShareALLRecordsToNewUserBatch(userIdLst,'Vehicle_Relationship__c',Market));
            Database.Executebatch(new ShareALLRecordsToNewUserBatch(userIdLst,'User',Market));
        }
            
        
        }
    }
    public static void createGroup(List<User> usersWOGrp,string market)
    {
        List<Group> grpLst=new List<Group>();
        Set<Group> grpSet=new Set<Group>();
        for(User usr:usersWOGrp)
        {
            Group grpObj=new Group();
            //grpObj.Name=market+usr.contact.Account.Dealer_Nd_code__c;
			grpObj.Name=usr.contact.Account.Dealer_Nd_code__c;
            grpObj.DoesIncludeBosses=true;
            grpSet.add(grpObj);
        }
        if(grpSet.size()>0)
        {
            grpLst.addAll(grpSet);
        }
        if(grpLst!=null && grpLst.size()>0)
            insert grpLst;
        
        //add users to group
        if(grpLst!=null && grpLst.size()>0)
        {
            addUsersToGroup(usersWOGrp,market);
        }
    }
    
    public static void addUsersToGroup(List<User> usersWHGrp,string market)
    {
        Set<String> groupNamesLst = new Set<String>(); 
        for(User usr:usersWHGrp)
        {
            //String groupName=market+usr.contact.Account.Dealer_Nd_code__c;
			String groupName=usr.contact.Account.Dealer_Nd_code__c;
            groupNamesLst.add(groupName);
        }
        List<Group> grpLst;
        if(groupNamesLst!=null && groupNamesLst.size()>0)
        {
            grpLst=new List<Group>([select ID,Name from Group where Name IN: groupNamesLst]);
        }
        Map<String,Id> grpNameGrpIdMap=new Map<String,Id>();
        for(Group gp:grpLst)
        {
            grpNameGrpIdMap.put(gp.Name, gp.Id);
        }
        List<GroupMember> grpMemberLst=new List<GroupMember>();
        for(User usr:usersWHGrp)
        {
            //String groupName=market+usr.contact.Account.Dealer_Nd_code__c;
			String groupName=usr.contact.Account.Dealer_Nd_code__c;
            grpMemberLst.add(new GroupMember(GroupId=grpNameGrpIdMap.get(groupName),UserOrGroupId = usr.id));
        }
        if(grpMemberLst!=null && grpMemberLst.size()>0)
        {
            DMLManagerService.insertassystem(grpMemberLst);
        }
        
    }
   
}