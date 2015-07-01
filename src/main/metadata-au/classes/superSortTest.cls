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



Test.startTest();
Long start = system.currentTimeMillis();


         superSort.sortList(accs,'OwnerId','asc');
system.debug(system.currentTimeMillis() - start);
Test.stopTest();
system.assert(!accs.isEmpty());


}
}