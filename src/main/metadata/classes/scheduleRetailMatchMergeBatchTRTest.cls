@isTest
public class scheduleRetailMatchMergeBatchTRTest{
    public static testmethod void test1(){
        test.startTest();
        scheduleRetailMatchMergeBatchTR rmm=new scheduleRetailMatchMergeBatchTR();
        String sch = '0 0 23 * * ?'; 
        system.schedule('RetailMatchMergeJob', sch, rmm);
        test.stopTest();
    }
}