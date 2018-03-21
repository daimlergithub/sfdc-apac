/**
** Class: Util_getPermissionsTest
** Description: Test Class for Util_getPermissions
** Created By: Prem Kumar
** Date: 2018/03/14
**/
@IsTest
public class Util_getPermissionsTest {
    @testsetup
    static void testSetupMethod(){
        User usr = TestUtils.IntegrationAPIUser();
        User usr1 = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata','IN');
        ID pId = [select id from profile where Name='IntegrationAPI' limit 1].Id;
        User u = [Select id from user where profileid=:pId limit 1];
        User u1 = [select id from user where profile.name = 'System Administrator' and isActive=true limit 1];
        // Create PermissionSet with Custom Permission and assign to test user
        PermissionSet ps = new PermissionSet(Name = 'Test', Label = 'Test');
        insert ps;
        SetupEntityAccess sea = new SetupEntityAccess();
        sea.ParentId = ps.Id;
        sea.SetupEntityId = [select Id from CustomPermission where DeveloperName = 'INGeneric'][0].Id;
        insert sea;
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = u.Id;
        psa.PermissionSetId = ps.Id;
        insert psa;

    }
    
    @IsTest
    private static void testCheckCustomPermission() {
        User u = [Select id from user where profile.name = 'IntegrationAPI' limit 1];
        Boolean flag = false;
        test.startTest();
        System.runAs(u){
          flag = Util_getPermissions.checkCustomPermission('INGeneric');            
        }
        test.stopTest();
        System.assertEquals(True, flag); 
    }
  @IsTest
    private static void testCheckCustomPermission1() {
        User u1 = [select id from user where profile.name = 'System Administrator' and isActive=true limit 1];
        Boolean flag2 = false;
        test.startTest();
        System.runAs(u1){
          flag2 = Util_getPermissions.checkCustomPermission('testGeneric');            
        }
        test.stopTest();
        System.assertEquals(false, flag2);
    }
}