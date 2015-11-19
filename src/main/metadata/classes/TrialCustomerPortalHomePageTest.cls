@isTest
Public  with sharing class TrialCustomerPortalHomePageTest
{
    
 public static string Crtid='createdbyid';
 
  @isTest static void TestTrialCustomerHomePageController()
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
                            for(integer i = 0; i<1000; i++) 
                            {
                            Solution sol=new Solution();
                          sol.SolutionName='test';
                          sol.OwnerId = Owner;
                          listsol.add(sol);
                           } 
                        insert listsol;                           
                  
Test.startTest();
 TrialCustomerPortalHomePageController trial=new TrialCustomerPortalHomePageController();  
 trial.sortField3 = Crtid;
 trial.sortField1= Crtid;
 trial.sortField2= Crtid;
 trial.sortField4= Crtid;
  trial.previousSortField1=Crtid;
  trial.previousSortField2= Crtid;
  trial.previousSortField4= Crtid;
  trial.SortSolutions();
     Test.stopTest();
    System.assert(!listsol.isempty());
    System.assertNotEquals(null,accs);
 }
}