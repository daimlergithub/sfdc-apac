@istest
public with sharing class superSortTest
{
private static Account a= new Account();
private static List<Account> accs;
private static TrialCustomerPortalHomePageController trial;
public static testMethod void sortAscendingTest() {
Id Owner;

accs = new List<Account>();
Owner = [SELECT id FROM User LIMIT 1].id;

for(integer i = 0; i<1000; i++) {

a.Name='Test' + i;
a.AnnualRevenue=1000 * Math.random();
a.OwnerId = Owner;
accs.add(a);
}

Test.startTest();
trial=new TrialCustomerPortalHomePageController();
superSort.sortList(accs,'OwnerId','asc');
Test.stopTest();
system.assert(!accs.isEmpty());
system.assertNotEquals(null,trial);
}
}