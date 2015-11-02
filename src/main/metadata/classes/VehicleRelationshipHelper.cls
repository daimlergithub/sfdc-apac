/**
** This is an utility for Vehicle Relationship trigger
** The following class shares the Vehicle Relationship, associated Account and Vehicle reocrds with the subordinate users 
** of the Record Owner user.
**
** Created By: CC
** Date: 2013-06-18 
*/

public with sharing class VehicleRelationshipHelper {

	/**
	*@Description :This mehtod shares the Vehicle Relationships, accounts and vehicle records to the associated users.
	*@Author :Shrinivas Desai.
	*@Date : 31/10/2015
	*@param:List of sObjects - Vehicle Relationships.
	*@return:This mehtod does not return any value.
	*@see:shareVR
	*/
    public static void shareVR(List<Vehicle_Relationship__c> vRelationshipNew)
    {
    	Map<ID, ID> shareid = new Map<ID, ID>();
        Map<ID, ID> vrIdcontactId = new Map<ID, ID>();
        Map<ID, ID> vrIdvehicleId = new Map<ID, ID>();
    
        for(Vehicle_Relationship__c vr : vRelationshipNew)
        {
            if(vr.Owner_Dealer__c != null && vr.RecordTypeId == Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId())
            {
                shareid.put(vr.id, vr.Owner_Dealer__c);
                vrIdcontactId.put(vr.id, vr.Contact__c);
                vrIdvehicleId.put(vr.id, vr.Vehicle_ID__c);
            }
        }
        if(shareid != null && !shareid.IsEmpty() && vrIdcontactId != null && !vrIdcontactId.IsEmpty() && vrIdvehicleId != null && !vrIdvehicleId.IsEmpty())
        {
	        List<SObject> vehicleRelationshipShareToInsert = new List<SObject>();
	        List<SObject> accountShareToInsert = new List<SObject>();
	        List<SObject> vehicleShareToInsert = new List<SObject>();
	        Map<ID, String> account = new Map<ID, String>();
	        Map<String, ID> userrole = new Map<String, ID>();
	        Map<ID, ID> user = new Map<ID, ID>();
	        Map<ID, Set<ID>> users = new Map<ID, Set<ID>>();
	
	        for(ACCOUNT a : [SELECT name, id FROM ACCOUNT WHERE id in : shareid.values()]){
	            String s = a.name + ' ' + 'Partner Executive';
	            account.put(a.id, s);
	        }
	                
	        for(UserRole ur : [SELECT id, name FROM UserRole WHERE name in : account.values()]){
	            userrole.put(ur.name, ur.id);
	        }
	        
	        for(User u : [SELECT id, userroleid FROM User WHERE userroleid in : userrole.values() AND isActive = true]){
	            user.put(u.userroleid, u.id);
	        }
	
	        for(ID a : user.keyset()){
	            Set<ID> s = getRoleSubordinateUsers(user.get(a));
	            users.put(a, s);
	        }    
	
	        for(ID share : shareid.keyset()){
	            if(shareid.containskey(share)){
	                if(account.containskey(shareid.get(share))){
	                    if(userrole.containskey(account.get(shareid.get(share)))){
	                        if(users.containskey(userrole.get(account.get(shareid.get(share))))){
	                            for(ID fid : users.get(userrole.get(account.get(shareid.get(share))))){
	                                vehicleRelationshipShareToInsert.add(new Vehicle_Relationship__Share(AccessLevel = UtilConstant.read_Access, ParentId = share , UserOrGroupId = fid));
	                                if(vrIdcontactId.containsKey(share))
	                                {
	                                    accountShareToInsert.add(new AccountShare(AccountAccessLevel = UtilConstant.read_Access, AccountId = vrIdcontactId.get(share), OpportunityAccessLevel = UtilConstant.read_Access, CaseAccessLevel = UtilConstant.read_Access, UserOrGroupId = fid));
	                                }
	                                if(vrIdvehicleId.containsKey(share))
	                                {
	                                    vehicleShareToInsert.add(new Vehicle__Share(AccessLevel = UtilConstant.read_Access, ParentId = vrIdvehicleId.get(share) , UserOrGroupId = fid));
	                                }
	                            }
	                        }
	                    }
	                }
	            }
	        }
	
	        if(vehicleRelationshipShareToInsert != null && !vehicleRelationshipShareToInsert.IsEmpty())
	        {
	            UtilSobject.insertSobjects(vehicleRelationshipShareToInsert);
	        }
	        
	        if(accountShareToInsert != null && !accountShareToInsert.IsEmpty())
	        {
	            UtilSobject.insertSobjects(accountShareToInsert);
	        }
	        
	        if(vehicleShareToInsert != null && !vehicleShareToInsert.IsEmpty())
	        {
	            UtilSobject.insertSobjects(vehicleShareToInsert);
	        }
        }
    }

	/**
	*@Description : This method creates a map of subordinate users with their Ids and returns the Ids.
	*@Author :Shrinivas Desai.
	*@Date : 31/10/2015
	*@param:List of sObjects - User Id.
	*@return:This mehtod returns Set of User Ids.
	*@see:getRoleSubordinateUsers
	*/
    public static Set<ID> getRoleSubordinateUsers(Id userId) {
        // get requested user's role
        Id roleId= [select UserRoleId from User where Id = :userId].UserRoleId;
        Map<Id,Id> roles= new Map<Id,Id>();
        for(UserRole ur : [select Id, parentroleid from UserRole where Name like '%Partner User' or Name like '%Partner Executive' or Name like '%Partner Manager']){
            roles.put(ur.id, ur.parentroleid);
        }
        
        // get all of the roles underneath the user
        Set<Id> allSubRoleIds = getAllSubRoleIds(new Set<ID>{roleId}, roles);
        allSubRoleIds.add(roleId);
        // get all of the ids for the users in those roles
        Map<Id,User> users = new Map<Id, User>([Select Id, Name From User where UserRoleId IN :allSubRoleIds and isActive = true]);
        // return the ids as a set so you can do what you want with them
        return users.keySet(); 
    }
    
    /**
	*@Description : This method fetches all the sub-ordinate roles for a given role.
	*@Author :Shrinivas Desai.
	*@Date : 31/10/2015
	*@param:List of sObjects - Set of Role Ids and Map of roled Ids and Parent role Ids.
	*@return:This mehtod returns Set of User Ids.
	*@see:getAllSubRoleIds
	*/
    private static Set<ID> getAllSubRoleIds(Set<ID> roleIds, Map<Id,Id> roles) {
 
        Set<ID> currentRoleIds = new Set<ID>();
     
        // get all of the roles underneath the passed roles
          
        for(ID crole: roles.keyset()){
            if(roleIds.contains(roles.get(crole))){
                 currentRoleIds.add(crole);
            }
        }
     
        // go fetch some more rolls!
        if(currentRoleIds.size() > 0)
        {
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds,roles));
        }     
        return currentRoleIds;
    }
}