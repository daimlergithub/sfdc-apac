@isTest
public class GlobalUtilityDFWDemoTest {
    //test debug
    public static testmethod void test1(){
        Test.startTest(); 
        Id i = GlobalUtilityDFW.getProfileId(Id.valueOf(UserInfo.getUserId()));
        User usr =[select id, name from user where Email='testUser@testorg.com' AND isActive=true limit 1];
        System.runAs(usr){
        GlobalUtilityDFWDemo.divideNum(10,20);
        GlobalUtilityDFWDemo.divideNum(100,20);
        GlobalUtilityDFWDemo.divideNum(0,20);
        Test.stopTest();
        }
    }
    //test schedulable class to delete record
    public static testmethod void test2(){
        Test.startTest();
        GlobalUtilityScheduleDFW als= new GlobalUtilityScheduleDFW();
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        String jobID = system.schedule('Job', CRON_EXP, als);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                FROM CronTrigger WHERE Id = :jobID];
        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));
        Test.stopTest();    
    }
    
    
    //test webservice
    public static testmethod void test3(){
        Test.startTest();
        Id retId= GlobalUtilityDFWDemo.webServiceDemoTest('Test',new Account(Name='TestAccount'));
        //String resBody= GlobalUtilityDFWDemo.calloutTest('https://salesforce.com');
        Test.stopTest();    
    }
    public static testmethod void testCallout() {
    Test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        HttpResponse res = GlobalUtilityDFWDemo.getInfoFromExternalService();
        system.debug('@@@ res :'+res);
        // Verify response received contains fake values
        String contentType = res.getHeader('Content-Type');
        
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        String expectedValue = '{"foo":"bar"}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());
        expectedValue = '{"foo"}';
        System.assertNotEquals(actualValue, expectedValue);
        Test.stopTest();
    }
    
    @testsetup
    public static void testData(){
        ApplicationLogTHDFW__c appLog = new ApplicationLogTHDFW__c();
        appLog.Age__c = 10;
        appLog.Debug_Level__c ='ERROR';
        appLog.Message__c='Test Error Message';
        appLog.Name = '';
        appLog.Stack_Trace__c ='Test Error Message Stack Trace';
        appLog.Integration_Payload__c='Test Error Message Payload';
        appLog.Error_Picklist__c ='Interface related';
        appLog.Timer__c = datetime.now().addDays(Integer.valueOf(-10));
        appLog.Source__c='';
        appLog.Source_Function__c='';
        DMLManagerService.insertAsSystem(appLog);
        Profile p = [SELECT Id,Name FROM Profile WHERE Name='System Administrator']; 
        SystemSettingsDFW__c sysSet = new SystemSettingsDFW__c();
        sysSet.Debug__c =true;
        sysSet.Error__c = true;
        sysSet.Info__c= true;
        sysSet.Warning__c = true;
        sysSet.Log_Purge__c =10;
        sysSet.Name=p.Name;
        DMLManagerService.insertAsSystem(sysSet);
        
        User u = new User(Alias = 'standt', Email='testUser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com', isActive=true);
        DMLManagerService.insertAsSystem(u);
    }
}