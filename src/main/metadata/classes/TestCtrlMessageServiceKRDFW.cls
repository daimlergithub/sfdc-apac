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
private class TestCtrlMessageServiceKRDFW {
	private static final String FAKE_RESPONSE = '[{"sn":"20180419-093318976R202RS000015","custMsgSn":"benzkr_a2U0k00000011lkEAA","altCode":null,"code":"EW","altMsg":null,"smsCode":null,"smsMsg":"SMS/LMS/MMS Sending","sndDtm":"20180419093318","rcptDtm":null}]';
	public static Id parentCampaign_RecordTypeID = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
	public static Id OBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
	final static String CHRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chrysler Complaint').getRecordTypeId();
	private static String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
	
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
		Kakao_Talk_Integration_URL__c cs = new Kakao_Talk_Integration_URL__c();
		cs.Name = 'SfdcMBKMessageURL';
        cs.WebService_URL_1DR__c = 'https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/I2MaxKakao';
     	insert cs; 
     		
        // TO DO: implement unit test
		Account acc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing', Gender__c = 'Male', Phone = '0801801110', Area_code__c = '0101', LastName = '刈乾冠寒刊勘', FirstName = '刈乾冠寒刊勘',
                                Salutation = 'Unknown', Province__c = 'Shanghai', ZipCode__c= '1002347', Mobile__c = '023482832', Mobile2__c = '035456232',
                                Primary_Email__c = 'Email1', Primary_Fax__c = 'FAX2', Primary_Phone__c ='Other2', MD__c = 'JP', Industry = 'Other',
                                Personal_Agreement__c = 'Yes' ,Personal_Information_Third_Party_Release__c = 'Yes',
        						Personal_Abroad_Agreement__c = 'Yes' ,Agreement_to_commit_info_processing__c = 'Yes',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
        insert acc;				
        
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
		Kakao_Talk_Integration_URL__c cs = new Kakao_Talk_Integration_URL__c();
		cs.Name = 'SfdcMBKMessageURL';
        cs.WebService_URL_1DR__c = 'https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/I2MaxKakao';
     	insert cs; 
     	
        // TO DO: implement unit test
		Account acc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing', Gender__c = 'Male', Phone = '0801801110', Area_code__c = '0101', LastName = '刈乾冠寒刊勘', FirstName = '刈乾冠寒刊勘',
                                Salutation = 'Unknown', Province__c = 'Shanghai', ZipCode__c= '1002347', Mobile__c = '023482832', Mobile2__c = '035456232',
                                Primary_Email__c = 'Email1', Primary_Fax__c = 'FAX2', Primary_Phone__c ='Other2', MD__c = 'JP', Industry = 'Other',
                                Personal_Agreement__c = 'Yes' ,Personal_Information_Third_Party_Release__c = 'Yes',
        						Personal_Abroad_Agreement__c = 'Yes' ,Agreement_to_commit_info_processing__c = 'Yes',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());        
		insert acc;               
		                 
        Lead__c lead = new Lead__c();
        lead.Contact__c = acc.Id;
        lead.recordTypeId =afterSalesRecordTypeId;
        lead.CAC_Lead_Status__c = 'Qualified';
        lead.Lead_Type__c = 'New Car';
        lead.Relation_With_The_Leads__c = 'testR';
        lead.Lead_Desired_Service__c = 'Trade-In';
        lead.Purchase_Time__c = '0 - 3 months';
        lead.Interested_Vehicle_Brand__c = 'testI';
        lead.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead.Trade_In_Vehicle_Brand__c = 'c230';
        lead.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead.Trade_In_Other_Vehicle_Model__c = 'testT';
        lead.Interested_Vehicle_Brand__c = 'Smart';
        insert lead;

        Apexpages.currentPage().getParameters().put('id', lead.Id);
        CtrlMessageServiceKRDFW cmsk = new CtrlMessageServiceKRDFW();  

        Case myCase = new Case( AccountId = acc.Id, RecordTypeId = CHRecordtypeid,Problem1__c='ttt');
        insert myCase;         
            					
        Apexpages.currentPage().getParameters().put('id', myCase.Id);
        CtrlMessageServiceKRDFW cmsk1 = new CtrlMessageServiceKRDFW();
        
    }    
    static testMethod void myUnitTest2() {
		Kakao_Talk_Integration_URL__c cs = new Kakao_Talk_Integration_URL__c();
		cs.Name = 'SfdcMBKMessageURL';
        cs.WebService_URL_1DR__c = 'https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/I2MaxKakao';
     	insert cs; 
     	   	
        // TO DO: implement unit test
       Campaign camp = new Campaign(Name='test par', EndDate=System.Today()+10, StartDate=System.Today(), Segmentation_Date__c=system.today(),
            						RecordtypeID=parentCampaign_RecordTypeID, Status='Responded');
		insert camp;            
        
        Apexpages.currentPage().getParameters().put('id', camp.Id);
        CtrlMessageServiceKRDFW cmsk = new CtrlMessageServiceKRDFW();
        
        // TO DO: implement unit test
        Survey__c survey = new Survey__c();
        insert survey;
        
        Apexpages.currentPage().getParameters().put('id', survey.Id);
        CtrlMessageServiceKRDFW cmsk2 = new CtrlMessageServiceKRDFW();

		Account acc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing', Gender__c = 'Male', Phone = '0801801110', Area_code__c = '0101', LastName = '刈乾冠寒刊勘', FirstName = '刈乾冠寒刊勘',
                                Salutation = 'Unknown', Province__c = 'Shanghai', ZipCode__c= '1002347', Mobile__c = '023482832', Mobile2__c = '035456232',
                                Primary_Email__c = 'Email1', Primary_Fax__c = 'FAX2', Primary_Phone__c ='Other2', MD__c = 'JP', Industry = 'Other',
                                Personal_Agreement__c = 'Yes' ,Personal_Information_Third_Party_Release__c = 'Yes',
        						Personal_Abroad_Agreement__c = 'Yes' ,Agreement_to_commit_info_processing__c = 'Yes',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());      
       
        // TO DO: implement unit test
		Task taskobj = new Task();
	    taskobj.RecordTypeId = OBTaskRecordTypeId ;
	    taskobj.Status='open';
	    taskobj.Activity_Status__c='Successful';
	    taskobj.Generate_QC__c = true;
	    taskobj.whatId = acc.Id;
		insert taskobj;
        
        Apexpages.currentPage().getParameters().put('id', taskobj.Id);
        CtrlMessageServiceKRDFW cmsk3 = new CtrlMessageServiceKRDFW();          
    }       
    
    static testMethod void myTestOrder(){
		Kakao_Talk_Integration_URL__c cs = new Kakao_Talk_Integration_URL__c();
		cs.Name = 'SfdcMBKMessageURL';
        cs.WebService_URL_1DR__c = 'https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/I2MaxKakao';
     	insert cs; 
     	    	
		//Page Bulk
		List<Account> acclist = new List<Account>();
		Account acc1 = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing', Gender__c = 'Male', Phone = '0801801110', Area_code__c = '0101', LastName = '刈乾冠寒刊勘', FirstName = '刈乾冠寒刊勘',
                                Salutation = 'Unknown', Province__c = 'Shanghai', ZipCode__c= '1002347', Mobile__c = '023482832', Mobile2__c = '035456232',
                                Primary_Email__c = 'Email1', Primary_Fax__c = 'FAX2', Primary_Phone__c ='Other2', MD__c = 'JP', Industry = 'Other',
                                Personal_Agreement__c = 'Yes' ,Personal_Information_Third_Party_Release__c = 'Yes',
        						Personal_Abroad_Agreement__c = 'Yes' ,Agreement_to_commit_info_processing__c = 'Yes',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());   
		Account acc2 = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing', Gender__c = 'Male', Phone = '0801801110', Area_code__c = '0101', LastName = '刈乾冠寒刊勘', FirstName = '刈乾冠寒刊勘',
                                Salutation = 'Unknown', Province__c = 'Shanghai', ZipCode__c= '1002347', Mobile__c = '023482832', Mobile2__c = '035456232',
                                Primary_Email__c = 'Email1', Primary_Fax__c = 'FAX2', Primary_Phone__c ='Other2', MD__c = 'JP', Industry = 'Other',
                                Personal_Agreement__c = 'Yes' ,Personal_Information_Third_Party_Release__c = 'Yes',
        						Personal_Abroad_Agreement__c = 'Yes' ,Agreement_to_commit_info_processing__c = 'Yes',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());   
		Account acc3 = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing', Gender__c = 'Male', Phone = '0801801110', Area_code__c = '0101', LastName = '刈乾冠寒刊勘', FirstName = '刈乾冠寒刊勘',
                                Salutation = 'Unknown', Province__c = 'Shanghai', ZipCode__c= '1002347', Mobile__c = '023482832', Mobile2__c = '035456232',
                                Primary_Email__c = 'Email1', Primary_Fax__c = 'FAX2', Primary_Phone__c ='Other2', MD__c = 'JP', Industry = 'Other',
                                Personal_Agreement__c = 'Yes' ,Personal_Information_Third_Party_Release__c = 'Yes',
        						Personal_Abroad_Agreement__c = 'Yes' ,Agreement_to_commit_info_processing__c = 'Yes',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
		acclist.add(acc1);
		acclist.add(acc2);
		acclist.add(acc3);                                                                                                           
        insert acclist;      
        String pages = acc1.Id+','+acc2.Id+','+acc3.Id;
        
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
		Kakao_Talk_Integration_URL__c cs = new Kakao_Talk_Integration_URL__c();
		cs.Name = 'SfdcMBKMessageURL';
        cs.WebService_URL_1DR__c = 'https://ps1w2.rt.informaticacloud.com/active-bpel/public/rt/001FL6/I2MaxKakao';
     	insert cs; 
     	     	
        // TO DO: implement unit test
		Account acc1 = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing', Gender__c = 'Male', Phone = '0801801110', Area_code__c = '0101', LastName = '刈乾冠寒刊勘', FirstName = '刈乾冠寒刊勘',
                                Salutation = 'Unknown', Province__c = 'Shanghai', ZipCode__c= '1002347', Mobile__c = '023482832', Mobile2__c = '035456232',
                                Primary_Email__c = 'Email1', Primary_Fax__c = 'FAX2', Primary_Phone__c ='Other2', MD__c = 'JP', Industry = 'Other',
                                Personal_Agreement__c = 'Yes' ,Personal_Information_Third_Party_Release__c = 'Yes',
        						Personal_Abroad_Agreement__c = 'Yes' ,Agreement_to_commit_info_processing__c = 'Yes',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());           
        
		MBK_Messages__c temp = new MBK_Messages__c();
		temp.Account__c = acc1.id; 
		temp.Account_Name__c = '이정우';
		temp.Set_Sending_Time__c = system.now().addHours(1);
		temp.channel__c = 'S'; 
		temp.custGubun__c = 'benzkr'; 
		temp.Message__c = 'MBK Test Sandbox Message';
		temp.phoneNum__c = '01055104746';
		temp.senderKey__c = 'c76dcff9ce0106edc23968bb52bb7728ecc36d25';
		temp.subject__c = 'test';
        insert temp;

    	Apexpages.currentPage().getParameters().put('id', temp.Id);
        Apexpages.currentPage().getParameters().put('action', system.label.MBK_MessageType_Edit);
        CtrlMessageServiceKRDFW cmsk2 = new CtrlMessageServiceKRDFW();
		
		Test.setMock(HttpCalloutMock.class, new Mock());
        cmsk2.updateMessage();
    }    
}