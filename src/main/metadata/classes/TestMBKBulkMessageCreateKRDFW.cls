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
private class TestMBKBulkMessageCreateKRDFW {

    static testMethod void myUnitTestAcc() {
        // TO DO: implement unit test
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
		temp.Set_Sending_Time__c = system.now().addhours(1);
		temp.Subject__c = '온라인 회원 가입을 환영 합니다.';
		temp.Source_Object__c = 'Page';
		insert temp;

       	Attachment attachment = new Attachment();
  		attachment.Body = Blob.valueOf('2lj2j3l23j4l3j24lk23j4l2k3j4l2kj34lkj');
  		attachment.Name = String.valueOf('test.jpg');
  		attachment.ParentId = temp.Id;
  		insert attachment;

		MBKBulkMessageCreateKRDFWBatch batch = new MBKBulkMessageCreateKRDFWBatch();
		batch.batchId = temp.Id;
		batch.batchType = 'Page';
		Database.executeBatch(batch);
    }
    
    static testMethod void myUnitTestCampaign() {
        // TO DO: implement unit test
        //Campaign Bulk
		Campaign cam = [SELECT Id FROM Campaign WHERE HierarchyNumberOfContacts > 1 limit 1];
		

        MBK_Bulk_Message__c temp = new MBK_Bulk_Message__c();
		temp.channel__c = 'M';
		temp.Message__c = '안녕하세요, 벤츠코리아 입니다.\n온라인회원으로 가입해주셔서 감사합니다.\n신차 정보 및 프로모션 정보\n많이 이용해 주세요.\n고맙습니다.\nMBK.....';
		temp.Processed__c = false;
		temp.Set_Sending_Time__c = system.now().addhours(1);
		temp.Subject__c = '온라인 회원 가입을 환영 합니다.';
		temp.Source_Object__c = 'Campaign';
		temp.Source_Object_Id__c = cam.Id;
		insert temp;
       	
       	Attachment attachment = new Attachment();
  		attachment.Body = Blob.valueOf('2lj2j3l23j4l3j24lk23j4l2k3j4l2kj34lkj');
  		attachment.Name = String.valueOf('test.jpg');
  		attachment.ParentId = temp.Id;
  		insert attachment;
  				
		MBKBulkMessageCreateKRDFWBatch batch = new MBKBulkMessageCreateKRDFWBatch();
		batch.batchId = temp.Id;
		batch.batchType = 'Campaign';
		Database.executeBatch(batch);
    }   
    
	static testMethod void myUnitTestLead() {
        // TO DO: implement unit test
        //Page Bulk
        List<Lead__c> lists = [SELECT Id FROM Lead__c limit 3];        
        String pages = '';
        for(Lead__c temp:lists){
        	if(pages == '') pages = temp.Id;
        	else pages += ','+temp.Id;
        }
        
        MBK_Bulk_Message__c temp = new MBK_Bulk_Message__c();
		temp.channel__c = 'M';
		temp.Message__c = '안녕하세요, 벤츠코리아 입니다.\n온라인회원으로 가입해주셔서 감사합니다.\n신차 정보 및 프로모션 정보\n많이 이용해 주세요.\n고맙습니다.\nMBK.....';
		temp.PageSearchIDs__c = pages;
		temp.Processed__c = false;
		temp.Set_Sending_Time__c = system.now().addhours(1);
		temp.Subject__c = '온라인 회원 가입을 환영 합니다.';
		temp.Source_Object__c = 'Page';
		insert temp;

       	Attachment attachment = new Attachment();
  		attachment.Body = Blob.valueOf('2lj2j3l23j4l3j24lk23j4l2k3j4l2kj34lkj');
  		attachment.Name = String.valueOf('test.jpg');
  		attachment.ParentId = temp.Id;
  		insert attachment;

		MBKBulkMessageCreateKRDFWBatch batch = new MBKBulkMessageCreateKRDFWBatch();
		batch.batchId = temp.Id;
		batch.batchType = 'Page';
		Database.executeBatch(batch);
    }
     
}