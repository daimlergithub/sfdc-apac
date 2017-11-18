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
@isTest(SeeAllData=true)
private class TestCtrlMessageAPIKRDFW {
	private static final String FAKE_RESPONSE = '{"Out":{"custMsgSn":"benz_20171018090700","altCode":"1003","smsMsg":null}}';
	
	private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // You could assert the request content here
            HTTPResponse res = new HTTPResponse();
            res.setBody(FAKE_RESPONSE);
            res.setStatusCode(200);
            return res;
        }
    }
    
    private static final String FAKE_RESPONSE_Fail = '{"error":{"code":400,"details":{"extra":["smsMessage","smsKind","smsSndNum"]},"message":"Parameter validation failed"}}';
    private class MockFail implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // You could assert the request content here
            HTTPResponse res = new HTTPResponse();
            res.setBody(FAKE_RESPONSE_Fail);
            res.setStatusCode(500);
            return res;
        }
    }
    
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
		MBK_Messages__c temp = new MBK_Messages__c();
		temp.Account__c = [SELECT Id FROM Account limit 1].id; 
		temp.Account_Name__c = '이정우';
		temp.Set_Sending_Time__c = system.now();
		temp.channel__c = 'S'; 
		temp.custGubun__c = 'benzkr'; 
		temp.message__c = 'test';
		temp.phoneNum__c = '01055104746';
		temp.senderKey__c = 'c76dcff9ce0106edc23968bb52bb7728ecc36d25';
		temp.subject__c = 'test';
		temp.templateCode__c = 'test';
        insert temp;
        
		Attachment attachment = new Attachment();
  		attachment.Body = Blob.valueOf('2lj2j3l23j4l3j24lk23j4l2k3j4l2kj34lkj');
  		attachment.Name = String.valueOf('test.jpg');
  		attachment.ParentId = temp.Id;
  		insert attachment;
        
        List<String> MessageIds = new List<String>();
        MessageIds.add(temp.Id);
        
        Test.setMock(HttpCalloutMock.class, new Mock());
        CtrlMessageAPIKRDFW.MBKMessageDirectSender(MessageIds);
        CtrlMessageAPIKRDFW.MBKMessageLogging(MessageIds);
    }
    
    static testMethod void myUnitTest2() {
        // TO DO: implement unit test
		MBK_Messages__c temp = new MBK_Messages__c();
		temp.Account__c = [SELECT Id FROM Account limit 1].id; 
		temp.Account_Name__c = '이정우';
		temp.Set_Sending_Time__c = system.now();
		temp.channel__c = 'S'; 
		temp.custGubun__c = 'benzkr'; 
		temp.message__c = 'test';
		temp.phoneNum__c = '01055104746';
		temp.senderKey__c = 'c76dcff9ce0106edc23968bb52bb7728ecc36d25';
		temp.subject__c = 'test';
		temp.templateCode__c = 'test';
        insert temp;
        
       	Attachment attachment = new Attachment();
  		attachment.Body = Blob.valueOf('2lj2j3l23j4l3j24lk23j4l2k3j4l2kj34lkj');
  		attachment.Name = String.valueOf('test.jpg');
  		attachment.ParentId = temp.Id;
  		insert attachment;
  		
        List<String> MessageIds = new List<String>();
        MessageIds.add(temp.Id);

        Test.setMock(HttpCalloutMock.class, new MockFail());
        CtrlMessageAPIKRDFW.MBKMessageDirectSender(MessageIds);
    }    
}