@isTest
public class RetailtaskInlineControllerGenericTest {
    
    public static testMethod void invokemeth(){
        
		Account acc = new Account(name='TestAccount');
		insert acc;
		
        Retail_Task__c retailtaskref = new Retail_Task__c ();
		insert retailtaskref;

		ApexPages.StandardController sc = new ApexPages.StandardController(retailtaskref);
		ApexPages.currentPage().getParameters().put('id', retailtaskref.Id);

		RetailtaskInlineEditControllerGeneric rec = new RetailtaskInlineEditControllerGeneric (sc);
	}

}