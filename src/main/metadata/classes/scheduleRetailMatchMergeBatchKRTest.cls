/* Added by sravanthi gudibandi for KR Market*/
/* test class for scheduler class fo retail match merge for Korea*/
@isTest
public class scheduleRetailMatchMergeBatchKRTest{
    public static testmethod void test1(){
        test.startTest();
        scheduleRetailMatchMergeBatchKR rmm=new scheduleRetailMatchMergeBatchKR();
        String sch = '0 0 23 * * ?'; 
        system.schedule('RetailMatchMergeJob', sch, rmm);
        test.stopTest();
    }
}