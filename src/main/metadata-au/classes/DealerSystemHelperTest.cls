@isTest
public class DealerSystemHelperTest 
{
    private static Account dealer;
    private static Dealer_System__c dealersystem;
    private static String dealerRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    private static void createDealer()
    {         
        dealer = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58396243', Name = 'testdealer',Active__c='yes',Dealer_Allocation__c='MBAuP',Activation_Date__c=system.today(),Business_Unit__c='Alliance');
        insert dealer;
    }
    @isTest
	public static void shareWithDealerTest()
    {
        createDealer();
        test.startTest();
        	dealersystem = new Dealer_System__c(Dealer__c = dealer.id, Customer_No__c = '12345');
        	insert dealersystem;
        test.stopTest();        
    }
}