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
private class TestMBKBulkMessageCreateKRDFW {
	private static String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
	public static Id OBTaskRecordTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId();
	public static string campPlngRecTypId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    public static String campDsgRecTypId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CAC Campaign').getRecordTypeId();
    public static String campExcRecTypId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution - Complex').getRecordTypeId();
    public static Id dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    final static String CHRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chrysler Complaint').getRecordTypeId();
    public static list<CampaignMember> campMembrList;
    public static list<Contact> contList;
    
    static testMethod void myUnitTestAcc() {
        // TO DO: implement unit test
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
		contList = new list<Contact>();
		campMembrList = new list<CampaignMember>();

		Survey__c survey = new Survey__c();
		survey.Name = '테스트설문';
		insert survey;
		
		Campaign campPlng = new Campaign();
	    campPlng.RecordTypeId = campPlngRecTypId;
	    campPlng.Name = 'Test Campaign Planning';
	    campPlng.Type = 'Other';
	    campPlng.Status = 'Planning';
	    campPlng.StartDate = System.today();
	    campPlng.EndDate = System.today()+30;
	    campPlng.Campaign_Executer__c='Retail';
	    campPlng.Campaign_Objectives__c = 'camobjectives';
	    campPlng.Description = 'Test Campaign Planning Description';
	    campPlng.Campaign_Execution_Channels__c='eMail';
	    campPlng.Campaign_Type__c = 'After Sales';
		campPlng.Questionnaire__c = survey.Id;
	    insert campPlng;
	    
	    Campaign campDsgn = new Campaign();
	    campDsgn.Name = 'Test Campaign Design'; 
	    campDsgn.CAC_Frequency_Category__c = 'Ad Hoc';
	    campDsgn.Repeat_From__c = System.today(); 
	    campDsgn.Repeat_End__c = System.today()+30;           
	    campDsgn.RecordTypeId = campDsgRecTypId;
		campDsgn.Questionnaire__c = survey.Id;
	    insert campDsgn;
	    
	    Campaign campExec = new Campaign();
	    campExec.IsActive = true; 
	    campExec.Name = 'Test Campaign'; 
	    campExec.Task_Created_By__c = 'Contact';
	    campExec.Execution_Type__c = 'OB Call';
	    campExec.StartDate = System.today(); 
	    campExec.EndDate = System.today()+30;        
	    campExec.RecordTypeId = campExcRecTypId;
		campExec.Questionnaire__c = survey.Id;
	    insert campExec;
	    
	    Account dealer = new Account();
	    dealer.RecordTypeId=dealerRecordtypeid;
	    dealer.Name='Test Dealer Account';
	    dealer.MBK_Data_Source__c='Email';
	    dealer.Mobile__c='0130-5678-9876';
		dealer.Personal_Agreement__c = 'Yes';
		dealer.Personal_Information_Third_Party_Release__c = 'Yes';
		dealer.Personal_Abroad_Agreement__c = 'Yes';
		dealer.Agreement_to_commit_info_processing__c = 'Yes';          
	    insert dealer;
	    
	    for(integer i=0; i<=5; i++)
	    {
	    	Contact cont = new Contact();
	        cont.AccountId = dealer.Id; 
	        cont.LastName = 'Test Contact'; 
	        cont.Phone = '1234-5678-9876'; 
	        cont.email = 'test@contact.com';
	        contList.add(cont);
	    }
	   insert contList;
	   
	   for(contact con : contList)
	   { 
	        CampaignMember campMbr = new CampaignMember();
	        campMbr.CampaignId = campExec.Id;
	        campMbr.ContactId = con.Id;           
	        campMbr.Status = 'Send';
	        campMbr.Task_Generated__c = false;
	        campMembrList.add(campMbr);
	   }
	   insert campMembrList;
		

        MBK_Bulk_Message__c temp = new MBK_Bulk_Message__c();
		temp.channel__c = 'M';
		temp.Message__c = '안녕하세요, 벤츠코리아 입니다.\n온라인회원으로 가입해주셔서 감사합니다.\n신차 정보 및 프로모션 정보\n많이 이용해 주세요.\n고맙습니다.\nMBK.....';
		temp.Processed__c = false;
		temp.Set_Sending_Time__c = system.now().addhours(1);
		temp.Subject__c = '온라인 회원 가입을 환영 합니다.';
		temp.Source_Object__c = 'Campaign';
		temp.Source_Object_Id__c = campExec.Id;
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
		Account personAcc14 = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Work_Phone__c = '010-999-0000',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing', Gender__c = 'Male', Phone = '0801801110', Area_code__c = '0101', LastName = 'galaxy1', FirstName = 'First Name',
                               Salutation = 'Unknown',Province__c = 'Shanghai',ZipCode__c= '1002347',Mobile__c = '010-999-0000',Mobile2__c = '035456232',
                               Primary_Email__c = 'Email1',Primary_Fax__c = 'FAX2',Fax='035456232',Primary_Phone__c ='Other2',Allow_Data_Sharing2__c='No Choice Yet',  
                               MD__c = 'KR',Industry = 'Other',MBK_Data_Source__c='Circle of excellence ',Dealer_Rollout_Status__c ='Done',
								Personal_Agreement__c = 'Yes', Personal_Information_Third_Party_Release__c = 'Yes', Personal_Abroad_Agreement__c = 'Yes',
								Agreement_to_commit_info_processing__c = 'Yes' ,                        
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
                               
		insert personAcc14;
                                   	
        Lead__c lead = new Lead__c();
        lead.Contact__c = personAcc14.Id;
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
        
		Lead__c lead2 = new Lead__c();
        lead2.Contact__c = personAcc14.Id;
        lead2.recordTypeId =afterSalesRecordTypeId;
        lead2.CAC_Lead_Status__c = 'Qualified';
        lead2.Lead_Type__c = 'New Car';
        lead2.Relation_With_The_Leads__c = 'testR';
        lead2.Lead_Desired_Service__c = 'Trade-In';
        lead2.Purchase_Time__c = '0 - 3 months';
        lead2.Interested_Vehicle_Brand__c = 'testI';
        lead2.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead2.Trade_In_Vehicle_Brand__c = 'c230';
        lead2.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead2.Trade_In_Other_Vehicle_Model__c = 'testT';
        lead2.Interested_Vehicle_Brand__c = 'Smart';
        insert lead2;           

		Lead__c lead3 = new Lead__c();
        lead3.Contact__c = personAcc14.Id;
        lead3.recordTypeId =afterSalesRecordTypeId;
        lead3.CAC_Lead_Status__c = 'Qualified';
        lead3.Lead_Type__c = 'New Car';
        lead3.Relation_With_The_Leads__c = 'testR';
        lead3.Lead_Desired_Service__c = 'Trade-In';
        lead3.Purchase_Time__c = '0 - 3 months';
        lead3.Interested_Vehicle_Brand__c = 'testI';
        lead3.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead3.Trade_In_Vehicle_Brand__c = 'c230';
        lead3.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead3.Trade_In_Other_Vehicle_Model__c = 'testT';
        lead3.Interested_Vehicle_Brand__c = 'Smart';
        insert lead3;           
        
        String pages = lead.Id+','+lead2.Id+','+lead3.Id+',';
        
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


	static testMethod void myUnitTestCase() {
		// TO DO: implement unit test
		//Page Bulk
		Account personAcc14 = new Account(Dealer_Default_Flag__c=false,
				Dealer_DMS_SR_Code__c='test code 2',Work_Phone__c = '010-999-0000',
				Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
				City__c='Beijing', Gender__c = 'Male', Phone = '0801801110', Area_code__c = '0101', LastName = 'galaxy1', FirstName = 'First Name',
				Salutation = 'Unknown',Province__c = 'Shanghai',ZipCode__c= '1002347',Mobile__c = '010-999-0000',Mobile2__c = '035456232',
				Primary_Email__c = 'Email1',Primary_Fax__c = 'FAX2',Fax='035456232',Primary_Phone__c ='Other2',Allow_Data_Sharing2__c='No Choice Yet',
				MD__c = 'KR',Industry = 'Other',MBK_Data_Source__c='Circle of excellence ',Dealer_Rollout_Status__c ='Done',
				Personal_Agreement__c = 'Yes', Personal_Information_Third_Party_Release__c = 'Yes', Personal_Abroad_Agreement__c = 'Yes',
				Agreement_to_commit_info_processing__c = 'Yes' ,
				RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());

		insert personAcc14;

		Contact cont = [SELECT Id FROM Contact WHERE AccountId =: personAcc14.Id limit 1];


		Case myCase = new Case( ContactId = cont.Id, RecordTypeId = CHRecordtypeid,Problem1__c='ttt');
		insert myCase;

		Case myCase2 = new Case( ContactId = cont.Id, RecordTypeId = CHRecordtypeid,Problem1__c='tt234234234234234234234t');
		insert myCase2;

		String pages = myCase.Id+','+myCase2.Id;

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


	static testMethod void myUnitTestTask() {
        // TO DO: implement unit test
        //Page Bulk
				
		List<Task> tasks = new List<Task>();
		Task temp1 = new Task(); 										        
        temp1.Account_Name__c = '이정우';
        temp1.PersonMobilePhone__c = '01055104746';
        temp1.UCID__c = '213asdsfd1';
        tasks.add(temp1);       
                
        Task temp2 = new Task();
        temp2.Account_Name__c = '임유진';
        temp2.PersonMobilePhone__c = '01055104746';
        temp2.UCID__c = '244234234234';
        tasks.add(temp2);
        
        Task temp3 = new Task();
        temp2.Account_Name__c = '탁소영';
        temp2.PersonMobilePhone__c = '01055104746';
        temp2.UCID__c = '214323234324';
        tasks.add(temp3);        
        insert tasks; 
           
        String pages = '';
        for(Task temp:tasks){
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