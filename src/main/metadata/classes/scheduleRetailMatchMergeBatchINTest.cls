/* test class for scheduler class fo retail match merge for India*/
@isTest
public class scheduleRetailMatchMergeBatchINTest{
    public static testmethod void test1(){
        test.startTest();
        scheduleRetailMatchMergeBatchIN rmm=new scheduleRetailMatchMergeBatchIN();
        String sch = '0 0 23 * * ?'; 
        system.schedule('RetailMatchMergeJob', sch, rmm);
        test.stopTest();
    }
}