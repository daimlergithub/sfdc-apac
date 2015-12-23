/*
  Name                 : SettlementHelperTest
  Object               : Settlement_Management__c
  Requirement          : Test Class for US-DPCR-001
                         1. Calculate Total amount when settlement is changed
  Author               : Barney Lai
  Create Date          : 2013-07-16
*/

@isTest 
public with sharing class SettlementHelperTest 
{
Private static String TriggerSettlementManagement='TriggerSettlementManagement';
Private static String MBRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
Private static String DealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static testMethod void testupdateSettlementTotalAmount1() 
    {
        List<Trigger__c> triggerRetailCampaignMembers = [select Id from Trigger__c where Trigger_Name__c = 'TriggerSettlementManagement'];
        if (triggerRetailCampaignMembers == null || triggerRetailCampaignMembers.isEmpty()) {
            upsert new Trigger__c(Name = TriggerSettlementManagement,Market__c='NA', Trigger_Name__c = TriggerSettlementManagement, Trigger_Handler__c = 'TriggerSettlementManagementHandler', enabled__c = true, before__c = true, after__c = true, insert__c = true, update__c = true, delete__c = true);
        }

        
        Test.startTest();
        Account dealer = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58392243', Name = 'testdealer');
        insert dealer;
        
        Case c1 = new Case(RecordTypeId = MBRecordtypeid, Case_Dealer__c = dealer.Id);
        insert c1;
        Settlement_Management__c sm = new Settlement_Management__c(Customer_Settlement_Amount__c = 1,
            Dealer_Settlement_Amount__c = 2, MB_Settlement_Amount__c = 3);
        sm.Case__c = c1.id;
        insert sm;
        Settlement_Management__c ssold = [select id, Customer_Settlement_Amount__c, Dealer_Settlement_Amount__c, MB_Settlement_Amount__c 
            from Settlement_Management__c where Settlement_Type__c = 'Total Complaint Settlement' and Case__c = :c1.id];
        
        Settlement_Management__c sm1 = new Settlement_Management__c(Customer_Settlement_Amount__c = 100,
            Dealer_Settlement_Amount__c = 200, MB_Settlement_Amount__c = 300);
        Settlement_Management__c sm2 = new Settlement_Management__c(Customer_Settlement_Amount__c = 1000,
            Dealer_Settlement_Amount__c = 2000, MB_Settlement_Amount__c = 3000);
        sm1.Case__c = c1.id;
        sm2.Case__c = c1.id;
        insert sm1;
        insert sm2;
        ID i1 = sm1.id;
        ID i2 = sm2.id;
        Settlement_Management__c ss1 = [select id, Customer_Settlement_Amount__c, Dealer_Settlement_Amount__c, MB_Settlement_Amount__c 
            from Settlement_Management__c where Settlement_Type__c = 'Total Complaint Settlement' and Case__c = :c1.id];
        delete sm1;
        delete sm2;
        system.assert([select id from Settlement_Management__c where (id = :i1 OR id = :i2)].size() == 0);
        Settlement_Management__c ss2 = [select id, Customer_Settlement_Amount__c, Dealer_Settlement_Amount__c, MB_Settlement_Amount__c 
            from Settlement_Management__c where Settlement_Type__c = 'Total Complaint Settlement' and Case__c = :c1.id];
        Test.stopTest();    
        system.assert(ssold.Customer_Settlement_Amount__c+1100 == ss1.Customer_Settlement_Amount__c);
        system.assert(ssold.Dealer_Settlement_Amount__c+2200 == ss1.Dealer_Settlement_Amount__c);
        system.assert(ssold.MB_Settlement_Amount__c+3300 == ss1.MB_Settlement_Amount__c);
        system.assert(ssold.Customer_Settlement_Amount__c == ss2.Customer_Settlement_Amount__c);
        system.assert(ssold.Dealer_Settlement_Amount__c == ss2.Dealer_Settlement_Amount__c);
        system.assert(ssold.MB_Settlement_Amount__c == ss2.MB_Settlement_Amount__c);
    }
    
    public static testMethod void testTriggerSettlementAfterInsertUpdateDelete() 
    {
        List<Trigger__c> triggerRetailCampaignMembers = [select Id from Trigger__c where Trigger_Name__c =:TriggerSettlementManagement];
        if (triggerRetailCampaignMembers == null || triggerRetailCampaignMembers.isEmpty()) {
            upsert new Trigger__c(Name = 'TriggerSettlementManagement',Market__c='NA', Trigger_Name__c = 'TriggerSettlementManagement', Trigger_Handler__c = 'TriggerSettlementManagementHandler', enabled__c = true, before__c = true, after__c = true, insert__c = true, update__c = true, delete__c = true);
        }

        Test.startTest();
        Case cas = (Case)UtilTestData.createSobject(new Case(), UtilTestData.CASE_RT_MB_COMPLAINT);
        Settlement_Management__c sm = new Settlement_Management__c(
            Settlement_Type__c = 'No Settlement Require',
            Case__c = cas.id
        );
       
            insert sm;      
            sm.Other_Settlement_Type__c = 'os';       
            update sm;     
            delete sm;      
        Test.stopTest();
        system.assertequals(sm.Case__c,cas.id);
    }
}