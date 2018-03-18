/**
** Class: Util_getPermissions 
** Description: Class to check custom permission of a user
** Created By: Shashi Goswami
** Date: 2018/02/19
**/

public class Util_getPermissions {
    public static String profileName;
    public static User u;
    public Boolean checkCustomPermission(String customPermission){
        u =[Select id,profileid, market__c from user where id=:UserInfo.getUserId()] ;
        profileName=[Select Id,Name from Profile where Id =: u.ProfileId].Name;
        List<String> customPermissionList = Util_getPermissions.getCustomPermissions(u.Id);
        if((customPermissionList != null && customPermissionList.size()>0 && customPermissionList.contains(customPermission)) || profileName.equals('IntegrationAPI')){
            return true; 
        }
        else
            return false;
    }
    //fetch custom permission of current user
    static List<String> getCustomPermissions(Id userId)
    {   
        List<String> UserCustomPermission = new List<String>();
        Set<Id> UpermissionSetIDs = new Map<Id, PermissionSet>([
            SELECT Id FROM PermissionSet
            WHERE Id IN (
                SELECT PermissionSetId
                FROM PermissionSetAssignment
                WHERE AssigneeId = :userId
            )
        ]).keySet();
        List<CustomPermission> Ucustompermission = [SELECT DeveloperName FROM CustomPermission
                                                    WHERE Id IN (
                                                    SELECT SetupEntityId
                                                    FROM SetupEntityAccess
                                                    WHERE SetupEntityType = 'CustomPermission'
                                                    AND ParentId IN :UpermissionSetIDs)];
        for(CustomPermission custPermission: Ucustompermission){
            UserCustomPermission.add(custPermission.DeveloperName);
        }
        return UserCustomPermission;
    }
    
}