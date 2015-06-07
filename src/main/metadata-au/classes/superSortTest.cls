@istest
public class superSortTest
{
public static testMethod void sortAscendingTest() {
Id Owner;

List<Account> accs = new List<Account>();
Owner = [SELECT id FROM User LIMIT 1].id;

for(integer i = 0; i<1000; i++) {
Account a = new Account();
a.Name='Test' + i;
a.AnnualRevenue=1000 * Math.random();
a.OwnerId = Owner;
accs.add(a);
}

// accs.add(new Account(Name = 'test' + i, Annualized_Revenue__c = 1000 * Math.random()));

Test.startTest();
Long start = system.currentTimeMillis();

TrialCustomerPortalHomePageController trial=new TrialCustomerPortalHomePageController();
         superSort.sortList(accs,'OwnerId','asc');
system.debug(system.currentTimeMillis() - start);
Test.stopTest();

//Assert the list was sorted correctly


}
}