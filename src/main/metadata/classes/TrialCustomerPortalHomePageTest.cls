@isTest(seealldata=true)
Public class TrialCustomerPortalHomePageTest
{
 public static testMethod void TestTrialCustomerHomePageController()
 {
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
                  List<Solution> listsol=new List<Solution>();
                            for(integer i = 0; i<1000; i++) {
                            Solution sol=new Solution();
                          sol.SolutionName='test';
                          sol.OwnerId = Owner;
                          listsol.add(sol);
                        } 
                        insert listsol;
                           
                  
Test.startTest();
Long start = system.currentTimeMillis();

 TrialCustomerPortalHomePageController trial=new TrialCustomerPortalHomePageController();
 trial.sortField3 = 'createdbyid';
 trial.sortField1= 'createdbyid';
 trial.sortField2= 'createdbyid';
 trial.sortField4= 'createdbyid';
  trial.sortField5= 'createdbyid';
  trial.sortField6= 'createdbyid';
 
 
  trial.previousSortField1= 'createdbyid';
  trial.previousSortField2= 'createdbyid';
  trial.previousSortField4= 'createdbyid';
   trial.previousSortField5= 'createdbyid';
   trial.previousSortField6= 'createdbyid';
 
 
  trial.SortSolutions();
     Test.stopTest();
    
 }
}