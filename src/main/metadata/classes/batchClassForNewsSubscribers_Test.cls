/************************************************************************************
* Project:RCP Indonesia : Dealer Community Indonesia
* Created By:Narendra.I
* Created Date:26-Oct-2018
* Company:Infosys Ltd
* Description:Test class for batchClassForNewsSubscribers
* **********************************************************************************/
@istest
public class batchClassForNewsSubscribers_Test {
    @istest    
    public static void testschedule() {
        News__c news = new News__c();
        news.Title__c = 'Test News 1';
        news.Start_Date__c = Date.today();
        news.Expiration_Date__c= Date.today() +1;
        news.Description__c = 'test news';
        news.Share_With_Groups__c='RCP_NewsReader_Restricted_1';
        news.Need_approval__c = false;        
        news.Document_Status__c='Published';
        insert news;        
        Test.StartTest();
        batchClassForNewsSubscribers sh1 = new batchClassForNewsSubscribers();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();        
    }
}