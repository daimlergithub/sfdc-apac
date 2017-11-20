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
private class TestCtrlMessageServiceKRDFW {
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
    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Account acc = [SELECT Id FROM Account limit 1];
        acc.Personal_Agreement__c = 'Yes';
        acc.Personal_Information_Third_Party_Release__c = 'Yes';
        acc.Personal_Abroad_Agreement__c = 'Yes';
        acc.Agreement_to_commit_info_processing__c = 'Yes';
        update acc;
        
        Apexpages.currentPage().getParameters().put('id', acc.Id);
        CtrlMessageServiceKRDFW cmsk = new CtrlMessageServiceKRDFW();
        cmsk.getTemplatesOrg();
        cmsk.TemplateFirst();
        cmsk.TemplateLast();
        cmsk.TemplatePrevious();
        cmsk.TemplateNext();   
        Boolean test1 = cmsk.TemplateHasNext;
        Boolean test2 = cmsk.TemplateHasPrevious;
        integer test3 = cmsk.TemplatePageNumber;
        
        Test.setMock(HttpCalloutMock.class, new Mock());
        
  		cmsk.mmsFile1.Body = Blob.valueOf('2lj2j3l23j4l3j24lk23j4l2k3j4l2kj34lkj');
  		cmsk.mmsFile1.Name = String.valueOf('test1.jpg');        
        
  		cmsk.mmsFile2.Body = Blob.valueOf('2lj2j3l23j4l3j24lk23j4l2k3j4l2kj34lkj');
  		cmsk.mmsFile2.Name = String.valueOf('test2.jpg');   
  		
  		cmsk.mmsFile3.Body = Blob.valueOf('2lj2j3l23j4l3j24lk23j4l2k3j4l2kj34lkj');
  		cmsk.mmsFile3.Name = String.valueOf('test3.jpg');       
        
        cmsk.SendingMessage(); 
        cmsk.BulkSendingMessage();
    }
    
    static testMethod void myUnitTest1() {
        // TO DO: implement unit test
        Lead__c lead = [SELECT Id, Contact__r.Personal_Agreement__c, Contact__r.Personal_Information_Third_Party_Release__c,
        						Contact__r.Personal_Abroad_Agreement__c, Contact__r.Agreement_to_commit_info_processing__c
          				FROM Lead__c limit 1];
		Account acc = lead.Contact__r;
        acc.Personal_Agreement__c = 'Yes';
        acc.Personal_Information_Third_Party_Release__c = 'Yes';
        acc.Personal_Abroad_Agreement__c = 'Yes';
        acc.Agreement_to_commit_info_processing__c = 'Yes';
        update acc;     
        
        Apexpages.currentPage().getParameters().put('id', lead.Id);
        CtrlMessageServiceKRDFW cmsk = new CtrlMessageServiceKRDFW();  

        Case myCase = [SELECT Id, ContactId FROM Case limit 1];
    	Contact con = [SELECT Id, Account.Id, Account.Personal_Agreement__c, Account.Personal_Information_Third_Party_Release__c,
    						Account.Personal_Abroad_Agreement__c, Account.Agreement_to_commit_info_processing__c 
    						FROM Contact WHERE Id =: myCase.ContactId];
    					
		Account acc2 = con.Account;
        acc2.Personal_Agreement__c = 'Yes';
        acc2.Personal_Information_Third_Party_Release__c = 'Yes';
        acc2.Personal_Abroad_Agreement__c = 'Yes';
        acc2.Agreement_to_commit_info_processing__c = 'Yes';
        update acc2;  

        Apexpages.currentPage().getParameters().put('id', myCase.Id);
        CtrlMessageServiceKRDFW cmsk1 = new CtrlMessageServiceKRDFW();
        
    }    
    static testMethod void myUnitTest2() {
        // TO DO: implement unit test
        Campaign camp = [SELECT Id FROM Campaign limit 1];
        
        Apexpages.currentPage().getParameters().put('id', camp.Id);
        CtrlMessageServiceKRDFW cmsk = new CtrlMessageServiceKRDFW();
        
        // TO DO: implement unit test
        Survey__c sur = [SELECT Id FROM Survey__c limit 1];
        
        Apexpages.currentPage().getParameters().put('id', sur.Id);
        CtrlMessageServiceKRDFW cmsk2 = new CtrlMessageServiceKRDFW();
       
        // TO DO: implement unit test
        Task task = [SELECT Id FROM Task limit 1];
        
        Apexpages.currentPage().getParameters().put('id', task.Id);
        CtrlMessageServiceKRDFW cmsk3 = new CtrlMessageServiceKRDFW();          
    }       
    
    static testMethod void myTestOrder(){
		//Page Bulk
        List<Account> lists = [SELECT Id FROM Account limit 3];        
        String pages = '';
        for(Account temp:lists){
        	if(pages == '') pages = temp.Id;
        	else pages += ','+temp.Id;
        }
        
        MBK_Bulk_Message__c temp = new MBK_Bulk_Message__c();
		temp.channel__c = 'M';
		temp.Message__c = '안녕하세요, 벤츠코리아 입니다.\n온라인회원으로 가입해주셔서 감사합니다.\n신차 정보 및 프로모션 정보\n많이 이용해 주세요.\n고맙습니다.\nMBK.....';
		temp.PageSearchIDs__c = pages;
		temp.Processed__c = false;
		temp.PageSearchCount__c = 3;
		temp.Set_Sending_Time__c = system.now().addhours(1);
		temp.Subject__c = '온라인 회원 가입을 환영 합니다.';
		temp.Source_Object__c = 'Page';
		insert temp;

    	Apexpages.currentPage().getParameters().put('bulkMessageId', temp.Id);
        CtrlMessageServiceKRDFW cmsk2 = new CtrlMessageServiceKRDFW();
    }

    static testMethod void myTestOrder2(){
        // TO DO: implement unit test
		MBK_Messages__c temp = new MBK_Messages__c();
		temp.Account__c = [SELECT Id FROM Account limit 1].id; 
		temp.Account_Name__c = '이정우';
		temp.Set_Sending_Time__c = system.now().addHours(1);
		temp.channel__c = 'S'; 
		temp.custGubun__c = 'benzkr'; 
		temp.message__c = 'test';
		temp.phoneNum__c = '01055104746';
		temp.senderKey__c = 'c76dcff9ce0106edc23968bb52bb7728ecc36d25';
		temp.subject__c = 'test';
		temp.templateCode__c = 'test';
        insert temp;

    	Apexpages.currentPage().getParameters().put('id', temp.Id);
        Apexpages.currentPage().getParameters().put('action', system.label.MBK_MessageType_Edit);
        CtrlMessageServiceKRDFW cmsk2 = new CtrlMessageServiceKRDFW();
		
		Test.setMock(HttpCalloutMock.class, new Mock());
        cmsk2.updateMessage();
    }    
}