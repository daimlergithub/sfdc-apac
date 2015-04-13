@isTest
public class DeploymentUtilTest
{
    public static testMethod void DeploymentUtilTest()
    {
        Test.startTest();
        DeploymentUtil objOperation= new DeploymentUtil();
        list<string> lstString= new list<string>();
        DeploymentUtil.refreshUpdateStamps(lstString);
        Field objField= new Field();
        Test.stopTest();
    }
}