/*
  Name                 : ScheduleCreateMonthlyOutboundEmails
  Object               : Account(Dealer), Lead__c
  Requirement          : Test Class for 
                         1. BatchCalcAmountOfAssignedLeads
                         2. ScheduleCalcAmountOfAssignedLeads
  Refer classes        : 
  Author               : Mouse Liu
  Create Date          : 2013-06-14
  Modify History       : 
 */
@isTest(seeAllData = false)
public class ScheduleCalcAmountOfAssignedLeadsTest {
                static{
                                upsert new Trigger__c(Name = 'TriggerAccount'+string.valueOf(System.Now()), Trigger_Name__c = 'TriggerAccount', Trigger_Handler__c = 'TriggerAccountHandler', 
                                enabled__c = true, before__c = true, after__c = true, insert__c = true, update__c = true, delete__c = true,Market__c='AU');
        upsert new App_Setting__c(Name = 'DailyAssignedLeadsReport eMail Address',Value__c='customer_care@daimler.com');
                }
    public static testMethod void testHasAssignedDealer() {
        Account dealer = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);

       Lead__c lead = new Lead__c(CAC_Lead_Status__c='New Enquiry',Assigned_Dealer__c = dealer.Id);

        lead = (Lead__c)UtilTestData.createSobject(lead, 
            UtilTestData.LEAD_RT_SALES_LEADS);

        Test.startTest();
        ScheduleCalcAmountOfAssignedLeads schClass = new ScheduleCalcAmountOfAssignedLeads();
        Date next10thDay = System.today().addDays(10);

        String myDateTime = String.Valueof(datetime.now().addseconds(10));
        String[] strs =myDateTime.split('-',5); 
        String[] strs2=strs[2].split(':',5); 
        String[] strs3=strs2[0].split(' ',3); 
        String schdul= strs2[2]+' '+strs2[1]+' '+strs3[1]+' '+strs3[0]+' '+strs[1]+' '+'?'; 
    
        String jobName = 'Calc Assigned Leads' + Math.rint(Math.random() * 1000000);
        
        System.schedule(jobName, schdul, schClass);
        
        //Call the batch apex
        String query = 'SELECT Id, Name, Assigned_Lead_Amount_of_Everyday__c, ' + 
            '(SELECT OwnerId, Id FROM Lead_Assigned_Dealer__r WHERE CreatedDate = TODAY) ' + 
            'FROM Account WHERE RecordType.Name = \'Dealer\' AND Name = \'test dealer\'';
            
        BatchCalcAmountOfAssignedLeads calcAssignedLeads = new BatchCalcAmountOfAssignedLeads(query);

        Database.executeBatch(calcAssignedLeads, 200);
        
        Test.stopTest();
        
         dealer = [SELECT Assigned_Lead_Amount_of_Everyday__c
                  FROM Account WHERE Id = :dealer.Id];
        system.assertEquals(1, dealer.Assigned_Lead_Amount_of_Everyday__c);
    }

    public static testMethod void testNoAssignedDealer() {
        Account dealer = (Account)UtilTestData.createSobject(
            new Account(Assigned_Lead_Amount_of_Everyday__c = 1), 
            UtilTestData.ACCOUNT_RT_DEALER);

        Test.startTest();
       
     
              
        //Call the batch apex
        String query = 'SELECT Id, Name, Assigned_Lead_Amount_of_Everyday__c, ' + 
            '(SELECT OwnerId, Id FROM Lead_Assigned_Dealer__r WHERE CreatedDate = TODAY) ' + 
            'FROM Account WHERE RecordType.Name = \'Dealer\' AND Name = \'test dealer\'';
            
        BatchCalcAmountOfAssignedLeads calcAssignedLeads = new BatchCalcAmountOfAssignedLeads(query);

        Database.executeBatch(calcAssignedLeads, 2000);
        
        Test.stopTest();
        
        dealer = [SELECT Assigned_Lead_Amount_of_Everyday__c
                  FROM Account WHERE Id = :dealer.Id];
        
        system.assertEquals(0, dealer.Assigned_Lead_Amount_of_Everyday__c);
    }
}