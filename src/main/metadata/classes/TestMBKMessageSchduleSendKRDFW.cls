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
private class TestMBKMessageSchduleSendKRDFW {
	private static String FAKE_RESPONSE = '[{"sn":"20180419-093318976R202RS000015","custMsgSn":"benzkr_a2U0k00000011lkEAA","altCode":null,"code":"EW","altMsg":null,"smsCode":null,"smsMsg":"SMS/LMS/MMS Sending","sndDtm":"20180419093318","rcptDtm":null}]';

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
    	temp.Set_Sending_Time__c = system.now().addDays(-40);
    	temp.processed__c = true;
    	insert temp;

		MBK_Messages__c temp2 = new MBK_Messages__c();
		temp2.Set_Sending_Time__c = system.now().addMinutes(-29);
		temp2.processed__c = false;
		temp2.Status__c = 'Reserved';
		temp2.sn__c = '123123123123';
		temp2.channel__c = 'M';
		temp2.Set_Sending_Time__c = Datetime.now().addYears(-1);
		temp2.custGubun__c = 'test';
		temp2.subject__c = 'test';
		temp2.senderKey__c = 'test';
		temp2.templateCode__c = system.label.MBK_Message_Survey;
		temp2.phoneNum__c = 'test';
		temp2.message__c = 'test';
		temp2.custMsgSn__c = 'benz_20171018090700';
		insert temp2;

		Test.setMock(HttpCalloutMock.class, new Mock());
        test.starttest();
        MBKMessageScheduleSendKRDFWSchedule myClass1 = new MBKMessageScheduleSendKRDFWSchedule();   
	    String chron = '0 0 23 * * ?';  
	    system.schedule('Test Sched1', chron, myClass1);   

		MBKMessageScheduleSendKRDFWBatch batch = new MBKMessageScheduleSendKRDFWBatch();
		batch.channel = 'M';
		Database.executeBatch(batch);

	    test.stopTest();
    }

	static testMethod void myUnitTest2() {
		Kakao_Talk_Integration_URL__c cs = new Kakao_Talk_Integration_URL__c();
		cs.Name = 'SfdcMBKMessageURL';
        cs.WebService_URL_1DR__c = 'https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/I2MaxKakao';
     	insert cs; 
     			
		MBK_Messages__c temp2 = new MBK_Messages__c();
		temp2.Set_Sending_Time__c = system.now().addMinutes(-29);
		temp2.processed__c = false;
		temp2.Status__c = 'Reserved';
		temp2.sn__c = '123123123123';
		temp2.channel__c = 'M';
		temp2.Set_Sending_Time__c = Datetime.now().addYears(-1);
		temp2.custGubun__c = 'test';
		temp2.subject__c = 'test';
		temp2.senderKey__c = 'test';
		temp2.templateCode__c = system.label.MBK_Message_Survey;
		temp2.phoneNum__c = 'test';
		temp2.message__c = 'test';
		temp2.custMsgSn__c = 'benz_20171018090700';
		temp2.AttachmentImages__c = true;
		insert temp2;
		
		Attachment att = new Attachment();
		att.Body = Blob.valueOf('fasdsfsdf234k2j3lk4jl324l23j4l23j4lj23l4l324j2l3kjl'); 
		att.Name = 'test';
		att.ParentId = temp2.Id;
		insert att;
		
		Test.setMock(HttpCalloutMock.class, new MockFail());
		test.starttest();

		MBKMessageScheduleSendKRDFWBatch batch = new MBKMessageScheduleSendKRDFWBatch();
		batch.channel = 'M';
		Database.executeBatch(batch);

		test.stopTest();
	}
	
	static testMethod void myUnitTest3() {
		Kakao_Talk_Integration_URL__c cs = new Kakao_Talk_Integration_URL__c();
		cs.Name = 'SfdcMBKMessageURL';
        cs.WebService_URL_1DR__c = 'https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/I2MaxKakao';
     	insert cs; 
     			
		MBK_Messages__c temp2 = new MBK_Messages__c();
		temp2.Set_Sending_Time__c = system.now().addMinutes(-29);
		temp2.processed__c = false;
		temp2.Status__c = 'Reserved';
		temp2.sn__c = '123123123123';
		temp2.channel__c = 'A';
		temp2.Set_Sending_Time__c = Datetime.now().addYears(-1);
		temp2.custGubun__c = 'test';
		temp2.subject__c = 'test';
		temp2.senderKey__c = 'test';
		temp2.templateCode__c = system.label.MBK_Message_Survey;
		temp2.phoneNum__c = 'test';
		temp2.message__c = 'test';
		temp2.custMsgSn__c = 'benz_20171018090700';
		insert temp2;
		
		Test.setMock(HttpCalloutMock.class, new MockFail());
		test.starttest();

		MBKMessageScheduleSendKRDFWBatch batch = new MBKMessageScheduleSendKRDFWBatch();
		batch.channel = 'A';
		Database.executeBatch(batch);

		test.stopTest();
	}	
}