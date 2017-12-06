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
	private static String FAKE_RESPONSE = '[{"sn": "20171117022834054000122RS01","custMsgSn": "benz_20171018090700","code": "EW","altCode": null,"altMsg": null,"smsCode": null,"smsMsg": "SMS/LMS/MMS Sending","sndDtm": "20171117022834","rcptDtm": null},{"sn": "20171117022834054000122RS01","custMsgSn": "benz_20171018090700","code": "EW","altCode": null,"altMsg": null,"smsCode": null,"smsMsg": "SMS/LMS/MMS Sending","sndDtm": "20171117022834","rcptDtm": null}]';

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

		MBK_Messages__c temp3 = new MBK_Messages__c();
		temp3.Set_Sending_Time__c = system.now().addMinutes(-29);
		temp3.processed__c = false;
		temp3.Status__c = 'Reserved';
		temp3.sn__c = '123123123123';
		temp3.channel__c = 'S';
		temp3.Set_Sending_Time__c = Datetime.now().addYears(-1);
		temp3.custGubun__c = 'test';
		temp3.subject__c = 'test';
		temp3.senderKey__c = 'test';
		temp3.templateCode__c = system.label.MBK_Message_Survey;
		temp3.phoneNum__c = 'test';
		temp3.message__c = 'test';
		temp3.custMsgSn__c = 'benz_20171018090700';
		insert temp3;

		MBK_Messages__c temp4 = new MBK_Messages__c();
		temp4.Set_Sending_Time__c = system.now().addMinutes(-29);
		temp4.processed__c = false;
		temp4.Status__c = 'Reserved';
		temp4.sn__c = '123123123123';
		temp4.channel__c = 'A';
		temp4.Set_Sending_Time__c = Datetime.now().addYears(-1);
		temp4.custGubun__c = 'test';
		temp4.subject__c = 'test';
		temp4.senderKey__c = 'test';
		temp4.templateCode__c = system.label.MBK_Message_Survey;
		temp4.phoneNum__c = 'test';
		temp4.message__c = 'test';
		temp4.custMsgSn__c = 'benz_20171018090700';
		insert temp4;

		Test.setMock(HttpCalloutMock.class, new Mock());
        test.starttest();
        MBKMessagScheduleSendKaKaoKRDFWSchedule myClass1 = new MBKMessagScheduleSendKaKaoKRDFWSchedule();   
	    String chron = '0 0 23 * * ?';  
	    system.schedule('Test Sched1', chron, myClass1);   

	    MBKMessagScheduleSendMMSKRDFWSchedule myClass2 = new MBKMessagScheduleSendMMSKRDFWSchedule();
	    String chron2 = '0 0 22 * * ?';     
	    system.schedule('Test Sched2', chron2, myClass2);    

        MBKMessagScheduleSendSMSKRDFWSchedule myClass3 = new MBKMessagScheduleSendSMSKRDFWSchedule();   
	    String chron3 = '0 0 21 * * ?';  
	    system.schedule('Test Sched3', chron3, myClass3);

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
		insert temp2;

		MBK_Messages__c temp3 = new MBK_Messages__c();
		temp3.Set_Sending_Time__c = system.now().addMinutes(-29);
		temp3.processed__c = false;
		temp3.Status__c = 'Reserved';
		temp3.sn__c = '123123123123';
		temp3.channel__c = 'S';
		temp3.Set_Sending_Time__c = Datetime.now().addYears(-1);
		temp3.custGubun__c = 'test';
		temp3.subject__c = 'test';
		temp3.senderKey__c = 'test';
		temp3.templateCode__c = system.label.MBK_Message_Survey;
		temp3.phoneNum__c = 'test';
		temp3.message__c = 'test';
		temp3.custMsgSn__c = 'benz_20171018090700';
		insert temp3;

		MBK_Messages__c temp4 = new MBK_Messages__c();
		temp4.Set_Sending_Time__c = system.now().addMinutes(-29);
		temp4.processed__c = false;
		temp4.Status__c = 'Reserved';
		temp4.sn__c = '123123123123';
		temp4.channel__c = 'A';
		temp4.Set_Sending_Time__c = Datetime.now().addYears(-1);
		temp4.custGubun__c = 'test';
		temp4.subject__c = 'test';
		temp4.senderKey__c = 'test';
		temp4.templateCode__c = system.label.MBK_Message_Survey;
		temp4.phoneNum__c = 'test';
		temp4.message__c = 'test';
		temp4.custMsgSn__c = 'benz_20171018090700';
		insert temp4;
		
		Test.setMock(HttpCalloutMock.class, new MockFail());
		test.starttest();
		MBKMessageScheduleSendKRDFWBatch batch = new MBKMessageScheduleSendKRDFWBatch();
		batch.channel = 'M';
		Database.executeBatch(batch);

		MBKMessageScheduleSendKRDFWBatch batch1 = new MBKMessageScheduleSendKRDFWBatch();
		batch1.channel = 'S';
		Database.executeBatch(batch1);

		MBKMessageScheduleSendKRDFWBatch batch2 = new MBKMessageScheduleSendKRDFWBatch();
		batch2.channel = 'A';
		Database.executeBatch(batch2);
		test.stopTest();				
	}
}