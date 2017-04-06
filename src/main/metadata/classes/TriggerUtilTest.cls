/*
    Type:       Test Class for TriggerLead
    Purpose:    Test Logic in TriggerLead
    User Story: US-Lead-016, US-Lead-009
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-04-26
    2. Mouse Updated on 2013-07-04 for US-Lead-009

*/
@isTest
private class TriggerLeadTest {
Private Static Account personAccount;
Private Static Lead__c lead;
Private Static Account customer;
Private Static Id personRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
Private Static Id salesleadsRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
Private Static Vehicle_Relationship__c vr;
Private Static Id aftersalesRecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead__c', 'Aftersales Leads');
Private Static String Accepted='Accepted';
public static void preparedTestData()
{
        personAccount = new Account(RecordTypeId=personRecordtypeid,Allow_Data_Sharing__c = 'Yes',LastName='testacc',MBK_Data_Source__c='Email',Mobile__c='000-0000-9842');
        //UtilTestData.createSobject(personAccount, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);

        lead = new Lead__c(RecordTypeId=salesleadsRecordTypeId ,Contact__c = personAccount.Id,Assigned_Date_Time__c = null,Dealer_Audit__c = false,Dealer_Lead_Status__c = Accepted);
        //UtilTestData.createSobject(lead, UtilTestData.LEAD_RT_SALES_LEADS);
        insert lead;
            //lead = new Lead__c(Assigned_Date_Time__c = null,Dealer_Audit__c = false,Dealer_Lead_Status__c = Accepted);
            
            //lead = (Lead__c)UtilTestData.createSobject(lead,UtilTestData.LEAD_RT_SALES_LEADS);
            
            lead.Assigned_Date_Time__c = System.now();
            update lead;
        
        customer = new Account();       
        customer.Allow_Data_Sharing__c = 'Yes'; 
        customer.Province__c = 'jiangsu'; 
        customer.City__c = 'nanjing';
        customer.Preferred_Language__c = 'English';
        customer.Dealer_Lead_System__c = 'Salesforce';
        customer.LastName = 'Customer';
        customer.Gender__c = '0=Male';
        customer.ZipCode__c = '1002345';
        customer.Type = '0=Company';
        customer.Phone = '0123321117'; 
        customer.Status__c = '0=Customer';
        customer.RecordTypeId = personRecordTypeId;
        customer.Area_Code__c = '010';
        //customer.MBK_Data_Source__c = 'Email';
        customer.Mobile__c = '09865234112';
        insert customer;
        
        vr = new Vehicle_Relationship__c(Contact__c=customer.Id, Car_Relation__c='user');
        insert vr;

}
   
    
    public static testMethod void testTriggerLead_add() {
    
        preparedTestData();    
        // Start Test
        Test.startTest();    
          lead = new Lead__c(
            VehicleRel_No__c = vr.Id,
            RecordTypeId = aftersalesRecordTypeId,
            Dealer_Audit__c = false,
            Dealer_Lead_Status__c = Accepted,
            CAC_Lead_Status__c = Accepted,
            Assigned_Date_Time__c = System.now(),
            Contact__c = customer.Id
        );
                                       
        // Stop Test
        Test.stopTest();
        System.assertEquals(lead.Allow_Data_Sharing__c, false);
        System.assertEquals(lead.CAC_Lead_Status__c, Accepted);
    }

    public static testMethod void testTriggerLead_PopulateIsQualify1() {
        preparedTestData();

        // Start Test
        Test.startTest();
        // Update CAC_Lead_Status__c from New to 'Lost(CAC)'
        lead.Lost_To__c = 'test';
        lead.CAC_Lead_Status__c = 'Lost(CAC)';
        lead.CAC_Lost_Reason__c='Interest Lost';
        lead.Lost_Comment__c='hello';
        lead.Lost_CAC_Date__c = System.today();
        update lead;
        Test.stopTest(); 

        lead = [SELECT Is_Qualify__c FROM Lead__c WHERE Id = :lead.Id];
        System.assertEquals(lead.Is_Qualify__c, 'Qualified');

    }

    public static testMethod void testTriggerLead_PopulateIsQualify2() {
       preparedTestData();
        // Start Test
        Test.startTest();
        // Update CAC_Lead_Status__c from New to 'Lost(CAC)'
        lead.Lost_To__c = 'test';
        lead.CAC_Lead_Status__c = 'Purchased(Only Non BDC)';
        lead.Bought_Vehicle_Brand__c = 'MB';
        lead.Bought_Vehicle_Class__c = 'A-Class';
        lead.Bought_Vehicle_Model__c = 'A160';
        lead.CAC_Lead_Status__c = 'Qualified';
        lead.Purchased_CAC_Date__c = System.today();
        update lead;        
        // Stop Test
        Test.stopTest();
        lead = [SELECT Is_Qualify__c FROM Lead__c WHERE Id = :lead.Id];
        System.assertEquals(lead.Is_Qualify__c, 'Qualified');

    }
}