@isTest
public class UtilConstantTest {
    private static testmethod void testUtilConstantTest(){
       // UtilConstant.REGIONAL_CRM_MANAGER_E;
        id PId=UtilConstant.getProfileId('System Administrator');
        Profile pf =[select id from Profile where Name='System Administrator'];
        UtilConstant.getUserRoleId('test2');
        system.assertEquals(PId, pf.id);
    }
   

}