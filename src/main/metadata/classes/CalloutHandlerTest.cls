@isTest
public class CalloutHandlerTest {
    
    static testMethod void testCallout(){    
        Test.startTest();   
        Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Map<string,CallOutHandlerSettingDFW__c> cohMap = CallOutHandlerSettingDFW__c.getAll();   
        user u=[select id, name from user where Email='testUser@testorg.com' and isActive=true limit 1];
        
        Account a = new account(Dealer_Default_Flag__c=false,
                                    Dealer_DMS_SR_Code__c='test code 1',
                                    Status__c='NoCustomer',
                                    City__c='Beijin',
                                    Gender__c = 'Male',
                                    Phone = '08080101',
                                    Area_code__c = '0100',
                                    LastName = 'galaxy1',
                                    FirstName = 'First Name',
                                    Salutation = 'Unknown',      
                                    Province__c = 'Shanghai',
                                    ZipCode__c='10043',
                                    Allow_Data_Sharing__c='no',
                                    Preferred_Language__c = 'English',
                                    Dealer_Lead_System__c = 'Salesforce',Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',
                                    Allow_Data_Sharing_Comment__c='Comments',RecordTypeId=accPerson_RecordTypeId);
        insert a;
        system.runAs(u){
            String method = 'GET';
            String endpoint = 'http://api.salesforce.com/foo/bar'; 
            Integer timeout= null;
            Integer timeout1=12000;  
			String market='TH';
            Map<String,String> headerKeyByValue =new Map<String,String>();            
            headerKeyByValue.put('Content-Type', 'application/json');
            headerKeyByValue.put('Accept', 'application/json');  
            String status = null; 
            continuation con = new continuation(120);
            //con = Continuation-1;
            List<Id> acclist = new list<Id>{a.Id};
            String body = EncodingUtil.URLENCODE(CDMInformatica_Services.generatejson(acclist),'UTF-8');
            // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            // Call method to test.
            // This causes a fake response to be sent
            // from the class that implements HttpCalloutMock. 
            //  HttpResponse res = CalloutHandlerService.sendCallout(method,endpoint,timeout,headerKeyByValue,status);
            HttpResponse res = CalloutHandlerService.sendCallout('GET','http://api.salesforce.com/foo/bar',null,headerKeyByValue,'200');
            
            res = CalloutHandlerService.sendCallout(method,endpoint,timeout1,headerKeyByValue,status);
            
            res = CalloutHandlerService.sendCalloutForPost(method,endpoint,timeout1,headerKeyByValue,status,body,market);
            
            String resString = CalloutHandlerService.processCalloutResponse(res, null);            
            res = CalloutHandlerService.sendCallout(method,null, timeout,headerKeyByValue,status);
            System.assertEquals(res.getBody(), '');  
            String s = CalloutHandlerService.onLineDeduplicationCDMCallout(endpoint,con);
            String r = CalloutHandlerService.onLineDeduplicationCDMTHCallout(endpoint,con);
            
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
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(u);
    }
    
}