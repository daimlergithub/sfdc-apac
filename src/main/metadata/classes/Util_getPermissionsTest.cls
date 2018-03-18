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
    }
    
    @IsTest
    private static void testCheckCustomPermission() {
        ID pId = [select id from profile where Name='IntegrationAPI' limit 1].Id;
        User u = [Select id from user where profileid=:pId limit 1];
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
        Util_getPermissions utGetpermission = new Util_getPermissions();
        test.startTest();
        Boolean flag = utGetpermission.checkCustomPermission('INGeneric');
        Boolean flag2 = utGetpermission.checkCustomPermission('MYGeneric');
        test.stopTest();
        System.assertEquals(True, flag); 
        System.assertEquals(false, flag2);
    }
}