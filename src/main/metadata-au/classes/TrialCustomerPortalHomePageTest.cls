@isTest
Public class TrialCustomerPortalHomePageTest
{
    private static string sortField3Value ='createdbyid';
 public static testMethod void TestTrialCustomerHomePageController()
 {
 Id Owner;
List<Account> accs = new List<Account>();
Owner = [SELECT id FROM User  where isactive=true LIMIT 1].id;

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
//Long start = system.currentTimeMillis();

 TrialCustomerPortalHomePageController trial=new TrialCustomerPortalHomePageController();
 trial.sortField3 = sortField3Value;
 trial.sortField1= sortField3Value;
 trial.sortField2= sortField3Value;
 trial.sortField4= sortField3Value;
 trial.previousSortField1= sortField3Value;
 trial.previousSortField2= sortField3Value;
 trial.previousSortField4= sortField3Value;
 
  trial.SortSolutions();
     

  Test.stopTest();
    
     system.assert(!listsol.isEmpty());
 }
}