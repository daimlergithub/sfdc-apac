/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestMBKMessageStatusKRDFW {
	private static final String FAKE_RESPONSE = '[{"sn": "20171117022834054000122RS01","custMsgSn": "benz_20171018090700","code": "EW","altCode": null,"altMsg": null,"smsCode": null,"smsMsg": "SMS/LMS/MMS Sending","sndDtm": "20171117022834","rcptDtm": null},{"sn": "20171117022834054000122RS01","custMsgSn": "benz_20171018090700","code": "EW","altCode": null,"altMsg": null,"smsCode": null,"smsMsg": "SMS/LMS/MMS Sending","sndDtm": "20171117022834","rcptDtm": null}]';
	
	private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // You could assert the request content here
            HTTPResponse res = new HTTPResponse();
            res.setBody(FAKE_RESPONSE);
            res.setStatusCode(200);
            return res;
        }
    }
    
    private class MockFail implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // You could assert the request content here
            HTTPResponse res = new HTTPResponse();
            res.setBody(FAKE_RESPONSE);
            res.setStatusCode(500);
            return res;
        }
    }
    
    static testMethod void myUnitTest() {
		Kakao_Talk_Integration_URL__c cs = new Kakao_Talk_Integration_URL__c();
		cs.Name = 'SfdcMBKMessageURL';
        cs.WebService_URL_1DR__c = 'https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/I2MaxKakao';
     	insert cs; 
    	
    	MBK_Messages__c temp = new MBK_Messages__c();
    	temp.Set_Sending_Time__c = system.now().addMinutes(-29);
    	temp.processed__c = false;
    	temp.Status__c = 'Send';
    	temp.sn__c = '123123123123';
    	insert temp;

		Test.setMock(HttpCalloutMock.class, new Mock());
		test.starttest();
        MBKMessagStatusKRDFWSchedule myClass = new MBKMessagStatusKRDFWSchedule();   
        String chron = '0 0 23 * * ?';        
        system.schedule('Test Sched', chron, myClass);
        test.stopTest();     
    }
    
    static testMethod void myUnitTest1() {
		Kakao_Talk_Integration_URL__c cs = new Kakao_Talk_Integration_URL__c();
		cs.Name = 'SfdcMBKMessageURL';
        cs.WebService_URL_1DR__c = 'https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/I2MaxKakao';
     	insert cs; 
    	
    	MBK_Messages__c temp = new MBK_Messages__c();
    	temp.Set_Sending_Time__c = system.now().addMinutes(-29);
    	temp.processed__c = false;
    	temp.Status__c = 'Send';
    	temp.sn__c = '123123123123';
    	insert temp;

		Test.setMock(HttpCalloutMock.class, new MockFail());
		test.starttest();
        MBKMessagStatusKRDFWSchedule myClass = new MBKMessagStatusKRDFWSchedule();   
        String chron = '0 0 23 * * ?';        
        system.schedule('Test Sched', chron, myClass);
        test.stopTest();     
    }    
}