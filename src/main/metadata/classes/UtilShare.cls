public with sharing class UtilShare{
    
   public sObject createShareObject(Set<id> parentId, Set<id> UserOrGroupId,string Permission){
        Map<Id,AccountShare> mapShareObjAS = new  Map<Id,AccountShare>();     
        
        for(Id uid : UserOrGroupId){            
            for(id pid : parentId){   
                   
                if( pid != Null && uid != Null){
                AccountShare shareObjAS = new AccountShare();
                    shareObjAS.AccountId= pid;
                    shareObjAS.UserOrGroupId= uid;
                    shareObjAS.AccountAccessLevel= Permission;
                    shareObjAS.OpportunityAccessLevel= Permission;   
                    shareObjAS.RowCause='Manual';
                    mapShareObjAS.put(shareObjAS.id,shareObjAS);
                }
            }
        } 
        if(mapShareObjAS.size() > 0 ){
            insert mapShareObjAS.values();   
        }  
        system.debug('mapShareObjAS :'+mapShareObjAS);  
        return null;
    }
    public sObject VehicleRelationshipShare(Set<id> parentId, Set<id> UserOrGroupId,string Permission){
        Map<Id,Vehicle_Relationship__Share> mapshareObjVRS = new Map<Id,Vehicle_Relationship__Share>();
        for(Id uid : UserOrGroupId){           
            for(id pid : parentId){                   
                if( pid != Null && uid != Null){
                    Vehicle_Relationship__Share shareObjVRS = new Vehicle_Relationship__Share();
                    shareObjVRS.ParentId=pid;
                    shareObjVRS.UserOrGroupId= uid;
                    shareObjVRS.AccessLevel= Permission;                
                    shareObjVRS.RowCause='Manual';
                    mapshareObjVRS.put(shareObjVRS.id,shareObjVRS);
                }
             }
         }
                
         if(mapshareObjVRS.size() > 0 ){
            insert mapshareObjVRS.values(); 
         }  
         system.debug('mapshareObjVRS :'+mapshareObjVRS);    
         return null;
    }
    public sObject VehicleShare(Set<id> parentId, Set<id> UserOrGroupId,string Permission){
        Map<id,Vehicle__Share> MapShareObjVS = new Map<id,Vehicle__Share>();
        for(Id uid : UserOrGroupId){
            for(id pid : parentId){
                if( pid != Null && uid != Null){ 
                    Vehicle__Share shareObjVS = new Vehicle__Share();
                    shareObjVS.ParentId=pid;
                    shareObjVS.UserOrGroupId= uid;
                    shareObjVS.AccessLevel= Permission;
                    shareObjVS.RowCause='Manual';
                    MapShareObjVS.put(shareObjVS.id,shareObjVS); 
                }  
            }
        }     
        if(MapShareObjVS.size() > 0){
           insert MapShareObjVS.values();   
        }  
        system.debug('MapShareObjVS :'+MapShareObjVS);  
        return null;
    }
    @future
    public static void groupmembersadd(set<id> rtlst,Set<id> dealerAccountIds){
        
        List<Lead__c> listLead = [select id,Name,Assigned_Dealer__c,RecordTypeId,RecordType.Name,VehicleRel_No__c,AfterSales_Vehicle__c
            from Lead__c where id IN : rtlst];
        system.debug('listLead  << :'+listLead);        
        for (Lead__c Led : listLead) {
            dealerAccountIds.add(Led.Assigned_Dealer__C);
        } 
        Set<String> groupNames = new Set<String>();
        Map<id,Account> mapAccount = new Map<id,Account>([select id,Name from account where Id IN : dealerAccountIds]);
        system.debug('mapAccount  << :'+mapAccount);
        for (Account acc : mapAccount.Values()) {
            groupNames.add(acc.Name);
        }
        system.debug('groupNames  << :'+groupNames);
        Map<id,Group> newGroupMap = new Map<id,Group>();
        Map<id,Group> allGroups = new Map<id,Group>();       
        List<Group> groupsExisting = [Select Id, Name From Group where Name In : groupNames];
        system.debug('groupsExisting >> :'+groupsExisting);
        for (Lead__c Led : listLead) {
            account dealerName = mapAccount.get(Led.Assigned_Dealer__c);
            if(groupsExisting.size() > 0 && dealerName != Null){
                for(Group gp : groupsExisting){                    
                    if(gp.Name == dealerName.Name){
                        allGroups.put(gp.Id,gp);
                        dealerAccountIds.add(Led.Assigned_Dealer__c);
                    }
                    else{
                        Group newGroup = new Group();
                        newGroup.Name = dealerName.Name;
                        newGroup.DoesIncludeBosses = false; 
                        newGroupMap.put(newGroup.id,newGroup);
                        dealerAccountIds.add(Led.Assigned_Dealer__c);
                    }               
                }
            }
            if(groupsExisting.size() == 0 && dealerName != Null){
                 Group newGroup = new Group();
                 newGroup.Name = dealerName.Name;
                 newGroup.DoesIncludeBosses = false; 
                 newGroupMap.put(newGroup.id,newGroup);
                 dealerAccountIds.add(Led.Assigned_Dealer__c);
            }
        }
        if(newGroupMap.size() >0){
            upsert newGroupMap.values();
        }   
        system.debug('newGroupMap :'+newGroupMap);
        list<User> groupMembers= [Select id,UserRoleId,Contact.AccountId From User where Contact.AccountId In : dealerAccountIds];
        system.debug('groupMembers << :'+groupMembers);
        
        Map<id,Account> mapAccountall = new Map<id,Account>([select id,Name from account where Id IN : dealerAccountIds]);        
        system.debug('mapAccountall  << :'+mapAccountall );
        
        list<GroupMember> listGroupMembersToInsert= new list<GroupMember>();
      
        for (Lead__c Led : listLead ) {
            system.debug('test  << 1:'+Led );
            account dealerName = mapAccountall.get(Led.Assigned_Dealer__c);
            system.debug('test  << 2:'+dealerName );
            for(Group groupId : newGroupMap.Values()){
                system.debug('test  << 3:'+groupId );
                for(User gm : groupMembers){
                    system.debug('test  << 4:'+gm);
                    if(dealerName.Name == groupId.Name && gm.Contact.AccountId == dealerName.id){
                        system.debug('test  << 5:'+gm);
                        GroupMember newMember=new GroupMember();
                        newMember.GroupId = groupId.id;
                        newMember.UserOrGroupId=gm.Id;
                        listGroupMembersToInsert.add(newMember);
                    }
                }
            }
        }
        system.debug('listGroupMembersToInsert <<:'+listGroupMembersToInsert);
        if(listGroupMembersToInsert.size() > 0){            
            upsert listGroupMembersToInsert; 
        }
        
        Set<Id> accountIds = new Set<Id>();
        Set<Id> parentIdsVS = new Set<Id>();
        Set<Id> parentIdsVRS = new Set<Id>();
        Set<Id> groupIds = new Set<Id>();
        
        if(allGroups.size() > 0){
            system.debug('test 1 :');                     
            for (Lead__c Led : listLead ) {
                system.debug('test 2 :');
                account dealerName = mapAccountall.get(Led.Assigned_Dealer__c);   
                for(Group groupid : allGroups.values()){
                    system.debug('test 3 :'+dealerName);
                    if(Led.Recordtype.Name == 'Sales Leads' || Led.Recordtype.Name == 'Aftersales Leads'){
                        if (dealerName != NULL && dealerName.Name == groupid.Name) {
                            system.debug('test 4 :');
                            accountIds.add(Led.Assigned_Dealer__c);
                            parentIdsVS.add(Led.VehicleRel_No__c);
                            parentIdsVRS.add(Led.AfterSales_Vehicle__c);
                            groupIds.add(groupid.Id);                              
                        }    
                    }
                }
            }
            system.debug('accountIds>> :'+accountIds);
            system.debug('parentIdsVS>> :'+parentIdsVS);
            system.debug('parentIdsVRS>> :'+parentIdsVRS);
            system.debug('groupIds>> :'+groupIds); 
            UtilShare util = new UtilShare();
            if(accountIds != Null && groupIds != Null){    
                util.createShareObject(accountIds,groupIds,'Read');
            }
            if(parentIdsVRS!= Null && groupIds != Null){
                util.VehicleRelationshipShare(parentIdsVRS,groupIds,'Read');
            }
            if(parentIdsVS!= Null && groupIds != Null){
                util.VehicleShare(parentIdsVS,groupIds,'Read');
            }               
        }        
    }
    
    @future
    public static void DealerGroupCreation(Set<id> dealerAccountIds, Set<id> userIds){
        Set<String> groupNames = new Set<String>();
        Map<id,Account> mapAccount = new Map<id,Account>([select id,Name from account where Id IN : dealerAccountIds]);
        for (Account acc : mapAccount.Values()) {
            groupNames.add(acc.Name);
        }
        Map<id,User> userMap = new Map<Id,User>([Select Id,Name,Contact.AccountId from User where Id In : userIds]); 
        system.debug('groupNames  << :'+groupNames);
        Map<id,Group> newGroupMap = new Map<id,Group>();
        Map<id,Group> allGroups = new Map<id,Group>();       
        List<Group> groupsExisting = [Select Id, Name From Group where Name In : groupNames];
        system.debug('groupsExisting >> :'+groupsExisting);
        list<GroupMember> listGroupMembersToInsert= new list<GroupMember>();
        for(User usr : userMap.Values()) {
            account dealerName = mapAccount.get(usr.Contact.AccountId);
            if(groupsExisting.size() > 0 && dealerName != Null){
                for(Group groupId : groupsExisting){
                    if(dealerName.Name == groupId.Name && usr.Contact.AccountId == dealerName.id){
                        GroupMember newMember=new GroupMember();
                        newMember.GroupId = groupId.id;
                        newMember.UserOrGroupId=usr.Id;
                        listGroupMembersToInsert.add(newMember);
                    }
                }
            }
            if(groupsExisting.size() == 0 && dealerName != Null){
                 Group newGroup = new Group();
                 newGroup.Name = dealerName.Name;
                 newGroup.DoesIncludeBosses = false; 
                 newGroupMap.put(newGroup.id,newGroup);                
            }
        }
        if(newGroupMap.size() >0){
            upsert newGroupMap.values();
        }
        
        for(User usr : userMap.Values()) {
            account dealerName = mapAccount.get(usr.Contact.AccountId);
            for(Group groupId : newGroupMap.Values()){
                if(dealerName.Name == groupId.Name && usr.Contact.AccountId == dealerName.id){
                    GroupMember newMember=new GroupMember();
                    newMember.GroupId = groupId.id;
                    newMember.UserOrGroupId=usr.Id;
                    listGroupMembersToInsert.add(newMember);
                }
            }
        }
        system.debug('listGroupMembersToInsert <<:'+listGroupMembersToInsert);
        if(listGroupMembersToInsert.size() > 0){            
            upsert listGroupMembersToInsert; 
        }        
    }    
}