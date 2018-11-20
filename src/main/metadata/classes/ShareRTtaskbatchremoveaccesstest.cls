@isTest
public class ShareRTtaskbatchremoveaccesstest {
    public static User user1 = TestUtils.IntegrationAPIUser();
    static testmethod void test() {

        // Create test RetailTasks to be updated
        // by the batch job.
        System.runAs(user1)
        {
            Account Acc = TestUtils.createPersonAccountGeneric(user1, '+6612345678','JP',1990);
    
            Retail_task__c[] accList = new List < Retail_task__c > ();
            Retail_task__share[] rtshare = new List < Retail_task__share > ();
            for (Integer i = 0; i < 200; i++) {
                Retail_task__c m = new Retail_task__c(Name = 'rttask ' + i, Related_Contact__c = Acc.Id, MD__c= 'JP');
                accList.add(m);
            }
            insert accList;
    
            for (Retail_task__c a: accList) {
                Retail_Task__Share r1 = new Retail_Task__Share(ParentId = a.Id, UserOrGroupId = user1.Id, AccessLevel = 'Read', RowCause = 'Service_share__c');
                rtshare.add(r1);
            }
            insert rtshare;
    
            Test.startTest();
            scheduledShareRTtaskbatchremoveaccess  sc = new scheduledShareRTtaskbatchremoveaccess ();
            String sch = '0 0 2 * * ?'; 
            system.schedule('Test Territory Check', sch, sc);
            ShareRTtaskbatchremoveaccess c = new ShareRTtaskbatchremoveaccess();
            Database.executeBatch(c);
			Test.stopTest() ;
        }
       

    }
}