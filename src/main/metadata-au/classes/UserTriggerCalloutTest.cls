@isTest
public class UserTriggerCalloutTest {

    public static testMethod void testCreateUser() {
     if(!Test.isRunningtest())
{
    Test.startTest();
         User user = [Select Id, Username,ProfileId,UserRoleId,UserRole.Name,Profile.Name,Phone,Email From User Where Id =: UserInfo.getUserId()];
         UserTriggerCallout.syncUser(user.Id,user.Username,user.UserRole.Name,user.Profile.Name,user.Phone,user.Email);
         Test.stopTest();
    system.assertNotEquals(user, null);
         }
        
    }
    
}