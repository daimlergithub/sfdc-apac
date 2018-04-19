/*********************************************************************************
Name         : campaignMemberHelperKRTest
Created By   : 
Modified BY  : 
Company Name : NTT Data
Project      : Daimler APAC  
Created Date : 27th July 2017
Modified Date:
Requirement  : SFDCKR - 1388
Usages       : Test class for code coverage related to campaignMemberHelperKR class.
*********************************************************************************/
@isTest
private class campaignMemberHelperKRTest 
{
    public static string campPlngRecTypId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    public static String campDsgRecTypId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CAC Campaign').getRecordTypeId();
    public static String campExcRecTypId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution - Complex').getRecordTypeId();
    public static Id dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static list<CampaignMember> campMembrList=new list<CampaignMember>();
    public static list<Contact> contList;
    public static Campaign campExec;
    public static map<Id, CampaignMember> campMembrMap = new map<Id, CampaignMember>();
    
    public static void testDataPreparation()
    {
        contList = new list<Contact>();
       // campMembrList = new list<CampaignMember>();
        
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
        
        campExec = new Campaign();
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
            campMbr.Status = 'Responded';
            campMbr.Status__c = '발송함';
            campMbr.MD__c = 'KR';
            campMbr.Task_Generated__c = false;
            campMembrList.add(campMbr);
         }
       insert campMembrList;
	   CampaignMember listCampaignm =[select id,status,status__c from CampaignMember where id IN:campMembrList limit 1];
         list<CampaignMember> oldList = new  list<CampaignMember>();
         oldList.add(listCampaignm);
        campMembrMap.put(listCampaignm.id, listCampaignm);
		
       
    }
    public static testMethod void updateCampaignMemberTest() 
    {
        Test.startTest();
        testDataPreparation();
        campaignMemberHelperKR.setCreateTaskFieldFalseOrTrueOnCampaign(campExec.Id);
        system.debug('list>>>>'+campMembrList);
        system.debug('map>>>>'+campMembrMap);
		generateTaskClass.taskGenerationForCM(campExec.Id);
        try{
        campaignMemberHelperKR.updatecustomstatus(campMembrList,campMembrMap);        
        }catch(Exception e){}
        Test.stopTest();        
    }
}