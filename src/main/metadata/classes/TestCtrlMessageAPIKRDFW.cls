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
private class TestCtrlMessageAPIKRDFW {
    private static final String FAKE_RESPONSE = '[{"sn":"20180419-093318976R202RS000015","custMsgSn":"benzkr_a2U0k00000011lkEAA","altCode":null,"code":"EW","altMsg":null,"smsCode":null,"smsMsg":"SMS/LMS/MMS Sending","sndDtm":"20180419093318","rcptDtm":null}]';
    private static final String FAKE_RESPONSE_FAIL = '{dasdasdasdasdsadasd}';
    
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

    private class MockFail2 implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // You could assert the request content here
            HTTPResponse res = new HTTPResponse();
            res.setBody(FAKE_RESPONSE_FAIL);
            res.setStatusCode(500);
            return res;
        }
    }    
    
    static testMethod void myUnitTest() {
        Kakao_Talk_Integration_URL__c cs = new Kakao_Talk_Integration_URL__c();
        cs.Name = 'SfdcMBKMessageURL';
        cs.WebService_URL_1DR__c = 'https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/I2MaxKakao';
        insert cs;  

        Account personAcc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing', Gender__c = 'Male', Phone = '0801801110', Area_code__c = '0101', LastName = '刈乾冠寒刊勘', FirstName = '刈乾冠寒刊勘',
                                Salutation = 'Unknown', Province__c = 'Shanghai', ZipCode__c= '1002347', Mobile__c = '023482832', Mobile2__c = '035456232',
                                Primary_Email__c = 'Email1', Primary_Fax__c = 'FAX2', Primary_Phone__c ='Other2', MD__c = 'JP', Industry = 'Other',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
        insert personAcc;       
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
        Kakao_Talk_Integration_URL__c cs = new Kakao_Talk_Integration_URL__c();
        cs.Name = 'SfdcMBKMessageURL';
        cs.WebService_URL_1DR__c = 'https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/I2MaxKakao';
        insert cs;  

        Account personAcc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing', Gender__c = 'Male', Phone = '0801801110', Area_code__c = '0101', LastName = '刈乾冠寒刊勘', FirstName = '刈乾冠寒刊勘',
                                Salutation = 'Unknown', Province__c = 'Shanghai', ZipCode__c= '1002347', Mobile__c = '023482832', Mobile2__c = '035456232',
                                Primary_Email__c = 'Email1', Primary_Fax__c = 'FAX2', Primary_Phone__c ='Other2', MD__c = 'JP', Industry = 'Other',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
        insert personAcc;               
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
        temp.templateCode__c = 'benz05';
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