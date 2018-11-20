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
private class TestCtrlMessageSearchKRDFW {
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
      Account personAcc14 = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Work_Phone__c = '010-999-0000',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing', Gender__c = 'Male', Phone = '0801801110', Area_code__c = '0101', LastName = 'galaxy1', FirstName = 'First Name',
                               Salutation = 'Unknown',Province__c = 'Shanghai',ZipCode__c= '1002347',Mobile__c = '010-999-0000',Mobile2__c = '035456232',
                               Primary_Email__c = 'Email1',Primary_Fax__c = 'FAX2',Fax='035456232',Primary_Phone__c ='Other2',Allow_Data_Sharing2__c='No Choice Yet',  
                               MD__c = 'KR',Industry = 'Other',MBK_Data_Source__c='Circle of excellence ',Dealer_Rollout_Status__c ='Done',
								Personal_Agreement__c = 'Yes', Personal_Information_Third_Party_Release__c = 'Yes', Personal_Abroad_Agreement__c = 'Yes',
								Agreement_to_commit_info_processing__c = 'Yes',
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
                               
                               insert personAcc14;


		Id [] fixedSearchResults= new Id[1];
       	fixedSearchResults[0] = personAcc14.Id;
       	Test.setFixedSearchResults(fixedSearchResults);
    	
        CtrlMessageSearchKRDFW mbkTargets = new CtrlMessageSearchKRDFW();
        mbkTargets.searchStr = personAcc14.Work_Phone__c;
        mbkTargets.targetSearch();
        mbkTargets.allChecking();
        mbkTargets.viewTargetList();
        mbkTargets.removeTarget();
    }
    
    static testMethod void myTestLead(){
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
		Id [] fixedSearchResults= new Id[1];
       	fixedSearchResults[0] = lead.Id;
       	Test.setFixedSearchResults(fixedSearchResults);
       			
        CtrlMessageSearchKRDFW mbkTargets = new CtrlMessageSearchKRDFW();    	
    	mbkTargets.searchStr = personAcc14.Work_Phone__c;
        mbkTargets.targetSearch();
        mbkTargets.allChecking();
        mbkTargets.viewTargetList();
        mbkTargets.removeTarget();
    }
    
    static testMethod void myTestTask(){
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
        // TO DO: implement unit test
		Task taskobj = new Task();
	    taskobj.RecordTypeId = OBTaskRecordTypeId ;
	    taskobj.Subject = 'test';
	    taskobj.Status='open';
        taskobj.Phone__c = '01099990000';
	    taskobj.Activity_Status__c='Successful';
	    taskobj.Generate_QC__c = true;
	    taskobj.whatId = acc.Id;
		insert taskobj;
		Id [] fixedSearchResults= new Id[1];
       	fixedSearchResults[0] = taskobj.Id;
       	Test.setFixedSearchResults(fixedSearchResults);
       	    	
        CtrlMessageSearchKRDFW mbkTargets = new CtrlMessageSearchKRDFW();    	
    	mbkTargets.searchStr = taskobj.Subject;
        mbkTargets.targetSearch();
        mbkTargets.allChecking();
        mbkTargets.viewTargetList();
        mbkTargets.removeTarget();
    }
    
    static testMethod void myTestCampaign(){
		contList = new list<Contact>();
    	campMembrList = new list<CampaignMember>();
    	
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
	    insert campPlng;
	    
	    Campaign campDsgn = new Campaign();
        campDsgn.Name = 'Test Campaign Design'; 
        campDsgn.CAC_Frequency_Category__c = 'Ad Hoc';
        campDsgn.Repeat_From__c = System.today(); 
        campDsgn.Repeat_End__c = System.today()+30;           
        campDsgn.RecordTypeId = campDsgRecTypId;
        insert campDsgn;
        
        Campaign campExec = new Campaign();
        campExec.IsActive = true; 
        campExec.Name = 'Test Campaign'; 
        campExec.Task_Created_By__c = 'Contact';
        campExec.Execution_Type__c = 'OB Call';
        campExec.StartDate = System.today(); 
        campExec.EndDate = System.today()+30;        
        campExec.RecordTypeId = campExcRecTypId;
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
		Id [] fixedSearchResults= new Id[1];
       	fixedSearchResults[0] = campExec.Id;
       	Test.setFixedSearchResults(fixedSearchResults);
       	    	
        CtrlMessageSearchKRDFW mbkTargets = new CtrlMessageSearchKRDFW();    	
    	mbkTargets.searchStr = campExec.Name;
        mbkTargets.targetSearch();
        mbkTargets.allChecking();
        mbkTargets.viewTargetList();
        mbkTargets.removeTarget();
    }
    
    static testMethod void myTestCase(){
		Account acc = new Account();
        acc.RecordTypeId=dealerRecordtypeid;
        acc.Name='Test Dealer Account';
        acc.MBK_Data_Source__c='Email';
        acc.Mobile__c='0130-5678-9876';
		acc.Personal_Agreement__c = 'Yes';
		acc.Personal_Information_Third_Party_Release__c = 'Yes';
		acc.Personal_Abroad_Agreement__c = 'Yes';
		acc.Agreement_to_commit_info_processing__c = 'Yes';        
        insert acc;
          	
    	Contact cont = new Contact();
        cont.AccountId = acc.Id; 
        cont.LastName = 'Test Contact'; 
        cont.Phone = '1234-5678-9876'; 
        cont.email = 'test@contact.com';
	    insert cont;
       	
        Case myCase = new Case( ContactId = cont.Id, RecordTypeId = CHRecordtypeid, Problem1__c='ttt', Subject='trest');
        insert myCase;
            	
 		Id [] fixedSearchResults= new Id[1];
       	fixedSearchResults[0] = myCase.Id;
       	Test.setFixedSearchResults(fixedSearchResults);
       	   	
        CtrlMessageSearchKRDFW mbkTargets = new CtrlMessageSearchKRDFW();    	
    	mbkTargets.searchStr = myCase.Subject;
        mbkTargets.targetSearch();
        mbkTargets.allChecking();
        mbkTargets.viewTargetList();
        mbkTargets.removeTarget();
    }       
    
    static testMethod void myTestOther(){
    	CtrlMessageSearchKRDFW mbkTargets = new CtrlMessageSearchKRDFW();
		mbkTargets.allChecking();
        mbkTargets.hideTargetList();
        CtrlMessageSearchKRDFW.messageScheduling('asdf', '1');
    }    
}