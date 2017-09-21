@isTest
public class CalloutHandlerTest {
    
    static testMethod void testCallout(){    
        Test.startTest();   
        Map<string,CallOutHandlerSettingDFW__c> cohMap = CallOutHandlerSettingDFW__c.getAll();   
        user u=[select id, name from user where Email='testUser@testorg.com' and isActive=true limit 1];
        system.runAs(u){
            String method = 'GET';
            String endpoint = 'http://api.salesforce.com/foo/bar'; 
            Integer timeout= null;
            Integer timeout1=12000;  
            Map<String,String> headerKeyByValue =new Map<String,String>();            
            headerKeyByValue.put('Content-Type', 'application/json');
            headerKeyByValue.put('Accept', 'application/json');  
            String status = null; 
            // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            // Call method to test.
            // This causes a fake response to be sent
            // from the class that implements HttpCalloutMock. 
            //  HttpResponse res = CalloutHandlerService.sendCallout(method,endpoint,timeout,headerKeyByValue,status);
            HttpResponse res = CalloutHandlerService.sendCallout('GET','http://api.salesforce.com/foo/bar',null,headerKeyByValue,'200');
            System.assertEquals(res.getBody(), '{"foo":"bar"}');
            res = CalloutHandlerService.sendCallout(method,endpoint,timeout1,headerKeyByValue,status);
            System.assertEquals(res.getBody(), '{"foo":"bar"}');
            String resString = CalloutHandlerService.processCalloutResponse(res, null);            
            res = CalloutHandlerService.sendCallout(method,null, timeout,headerKeyByValue,status);
            System.assertEquals(res.getBody(), '');  
            Test.stopTest(); 
            
        }
    }
    @testsetup
    public static void testData(){
        CallOutHandlerSettingDFW__c coh = new CallOutHandlerSettingDFW__c();
        coh.Name = 'CalloutValues';
        coh.DEFAULT_CALLOUT_TIME__c = '10000';
        coh.MAX_CALLOUT_TIME__c ='120000';  
        coh.FAILED_STATUS__c='failed';
        coh.JSON_CONTENT_TYPE__c ='application/json';
        coh.KO_STATUS__c='KO';       
        coh.OK_STATUS__c='OK';
        coh.PLAIN_TEXT_CONTENT_TYPE__c='text/plain';
        coh.QUEUED_STATUS__c='Queued';
        coh.REQUEST_BODY_NAME__c='request body';
        coh.REQUEST_CERT_NAME__c='request cert';
        coh.REQUEST_HEADERS_NAME__c='request headers';
        coh.RESPONSE_NAME__c='response';
        DMLManagerService.insertAsSystem(coh);       
        
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