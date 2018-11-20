@isTest
public class scheduleRetailMatchMergeBatchMYTest{
    public static testmethod void test1(){
        test.startTest();
        scheduleRetailMatchMergeBatchMY rmm=new scheduleRetailMatchMergeBatchMY();
        String sch = '0 0 23 * * ?'; 
        system.schedule('RetailMatchMergeJob', sch, rmm);
        test.stopTest();
    }
}