/*
  Name                 : SettlementHelperTest
  Object               : Settlement_Management__c
  Requirement          : Test Class for US-DPCR-001
                         1. Calculate Total amount when settlement is changed
  Refer classes        : 
  Author               : Barney Lai
  Create Date          : 2013-07-16
  Modify History       : 
*/

@isTest
public class SettlementHelperTest 
{
    Private Static  Account dealer;
    Private Static  Case c1;
    Private Static  Settlement_Management__c sm;
    Private Static  Settlement_Management__c ssold;
    Private Static  Settlement_Management__c sm1;
    Private Static  Settlement_Management__c sm2;
    Private Static  Settlement_Management__c ss1;
    Private Static  Settlement_Management__c ss2;
    Private Static  Settlement_Management__c smamountzero;

    Private Static  String MBRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
    Private Static  String CHRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chrysler Complaint').getRecordTypeId();
    Private Static  String INQUIRYRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get(UtilConstant.Enquiry).getRecordTypeId();
    Private Static  String DealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    
    public static testMethod void testupdateSettlementTotalAmount() 
    {
        Test.startTest();
        PrepareTestData(); 
        PrepareTestDataElsePart(); 
        ID i1 = sm1.id;
        ID i2 = sm2.id;       
        Test.stopTest();    
        system.assert([select id from Settlement_Management__c where (id = :i1 OR id = :i2)].size() == 0);
        system.assert(ssold.Customer_Settlement_Amount__c+1100 == ss1.Customer_Settlement_Amount__c);
        system.assert(ssold.Dealer_Settlement_Amount__c+2200 == ss1.Dealer_Settlement_Amount__c);
        system.assert(ssold.MB_Settlement_Amount__c+3300 == ss1.MB_Settlement_Amount__c);
        system.assert(ssold.Customer_Settlement_Amount__c == ss2.Customer_Settlement_Amount__c);
        system.assert(ssold.Dealer_Settlement_Amount__c == ss2.Dealer_Settlement_Amount__c);
        system.assert(ssold.MB_Settlement_Amount__c == ss2.MB_Settlement_Amount__c);
    }
    
   
    public static void PrepareTestData()
    {
    
    
            List<Trigger__c> triggerRetailCampaignMembers = [select Id from Trigger__c where Trigger_Name__c = 'TriggerSettlementManagement'];
            if (triggerRetailCampaignMembers == null || triggerRetailCampaignMembers.size() == 0) {
                upsert new Trigger__c(Name = 'TriggerSettlementManagement', Trigger_Name__c = 'TriggerSettlementManagement', Trigger_Handler__c = 'TriggerSettlementManagementHandler', enabled__c = true, before__c = true, after__c = true, insert__c = true, update__c = true, delete__c = true,Market__c='AU');
            }
            
            dealer = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58392243', Name = 'testdealer');
            insert dealer;
            
            c1 = new Case(RecordTypeId = MBRecordtypeid, Case_Dealer__c = dealer.Id);
            insert c1;
        
            sm = new Settlement_Management__c(Customer_Settlement_Amount__c = 1,
            Dealer_Settlement_Amount__c = 2, MB_Settlement_Amount__c = 3);
            sm.Case__c = c1.id;
            insert sm;
            
            ssold = [select id, Customer_Settlement_Amount__c, Dealer_Settlement_Amount__c, MB_Settlement_Amount__c 
            from Settlement_Management__c where Settlement_Type__c = 'Total Complaint Settlement' and Case__c = :c1.id];
            
            
            sm1 = new Settlement_Management__c(Customer_Settlement_Amount__c = 100,
            Dealer_Settlement_Amount__c = 200, MB_Settlement_Amount__c = 300);
            sm2 = new Settlement_Management__c(Customer_Settlement_Amount__c = 1000,
            Dealer_Settlement_Amount__c = 2000, MB_Settlement_Amount__c = 3000);
            sm1.Case__c = c1.id;
            sm2.Case__c = c1.id;
            insert sm1;
            insert sm2;
            
            
           ss1 = [select id, Customer_Settlement_Amount__c, Dealer_Settlement_Amount__c, MB_Settlement_Amount__c 
           from Settlement_Management__c where Settlement_Type__c = 'Total Complaint Settlement' and Case__c = :c1.id];
           delete sm1;
           delete sm2;
       
           ss2 = [select id, Customer_Settlement_Amount__c, Dealer_Settlement_Amount__c, MB_Settlement_Amount__c 
           from Settlement_Management__c where Settlement_Type__c = 'Total Complaint Settlement' and Case__c = :c1.id];
            
    } 
    public static void PrepareTestDataElsePart()
    {
            dealer = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58392243', Name = 'testdealer');
            insert dealer;
            
            c1 = new Case(RecordTypeId = MBRecordtypeid, Case_Dealer__c = dealer.Id);
            insert c1;
            
            smamountzero= new Settlement_Management__c(Customer_Settlement_Amount__c = 0,
            Dealer_Settlement_Amount__c = 0, MB_Settlement_Amount__c = 0);
            smamountzero.Case__c = c1.id;
           
            insert smamountzero;
            
    }
    
}