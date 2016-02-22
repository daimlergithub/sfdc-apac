@isTest
Public  with sharing class TrialCustomerPortalHomePageTest
{

Public Static User runAsUser;
Public Static User portalUser;
Public Static  Account acct; 
Public Static Contact contactObj;

 public static testMethod void createData(){
        Profile profileObj = [SELECT Id FROM Profile where Name ='System Administrator' Limit 1];
        UserRole roleObj = [Select Id From UserRole Where Name = 'IT Manager' Limit 1];
        runAsUser = new User(
        Username = System.now().millisecond() + 'test12Z34558@test.com',
        //ContactId = contactObj.Id,
        UserRoleId  = roleObj.Id,
        ProfileId = profileObj.Id,
        Alias = 'test1234',
        Email = 'test12345@test.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'McTesty',
        //UserType ='Portal',
        CommunityNickname = 'test123451085',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US'
        );
        insert runAsUser;
        system.runAs(runAsUser){
                
                    acct = new Account();
                    acct.Name='Test' + '0';
                    acct.AnnualRevenue=1000 * Math.random();
                    //a.OwnerId = Owner;
                    
                    insert acct;
                    
                    contactObj = new Contact(FirstName = 'Test',AccountId = acct.Id,LastName ='User');
                    insert contactObj;
                                
        }
        
        
        
        Profile portalProfile = [SELECT Id FROM Profile where Name ='Partner Community User' Limit 1];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        portalUser= new User(
        Username = System.now().millisecond() + 'test12Z345@test.com',
        ContactId = contactObj.Id,        
        ProfileId = portalProfile.Id,
        Alias = 'test1234',
        Email = 'test12345@test.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'McTesty',
        PortalRole = 'Manager',        
        CommunityNickname = 'test1234510',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US'
        );
        
        insert portalUser; 

}
  public static testMethod void SortProductstest()
    {
        createData();      
        system.runAs(runAsUser){
         Test.startTest();
             List<Asset> listsol=new List<Asset>();
             Asset assetObj = new Asset();
             assetObj.AccountId = acct.Id;
             assetObj.Name ='Test';              
             insert assetObj; 
                       
             TrialCustomerPortalHomePageController trial=new TrialCustomerPortalHomePageController();  
             
             trial.sortField3 = 'CreatedbyId3';
             trial.sortField1= 'CreatedbyId';
             trial.sortField2= 'CreatedbyId1';
             trial.sortField4= 'CreatedbyId4';
          
             trial.previousSortField3= 'CreatedbyId3';
             trial.previousSortField1= 'CreatedbyId';
             trial.previousSortField2= 'CreatedbyId1';
             trial.previousSortField4= 'CreatedbyId4';
             
             trial.SortProducts();
          
          Test.stopTest();
            //System.assert(!listsol.isempty());
            //System.assertNotEquals(null,accs);
      }
 }
   public static testMethod void SortCasestest()
      {
        createData();        
              
       system.runAs(portalUser){
        Test.startTest();
            List<Case> caselst = new List<Case>();
          
            Case caseObj = new Case(AccountId = acct.Id,ContactId =contactObj.Id,Subject ='This is a Test Case',Status ='New');
            caselst.add(caseObj);
            caseObj = new Case(AccountId = acct.Id);
            caselst.add(caseObj);
            insert caselst;
            system.debug('$$contactObj.Id##'+contactObj.Id);
           
             TrialCustomerPortalHomePageController trial=new TrialCustomerPortalHomePageController();  
             trial.sortField3 = 'CreatedbyId';
             trial.sortField1= 'CreatedbyId';
             trial.sortField2= 'CreatedbyId';
             trial.sortField4= 'CreatedbyId';
             trial.previousSortField3='CreatedbyId';
             trial.previousSortField1='CreatedbyId';
             trial.previousSortField2= 'CreatedbyId';
             trial.previousSortField4= 'CreatedbyId';
          
             trial.SortCases();
             
        Test.stopTest();
      }
 }
  public static testMethod void SortSolutionsTest()
    {
       List<Solution> listsol=new List<Solution>();
        for(integer i = 0; i<1000; i++) 
             {
               Solution sol=new Solution();
               sol.SolutionName='test';                             
                listsol.add(sol);
             } 
          insert listsol;                           
                  
        Test.startTest();
         TrialCustomerPortalHomePageController trial=new TrialCustomerPortalHomePageController();  
         trial.sortField3 = 'CreatedbyId';
         trial.sortField1= 'CreatedbyId';
         trial.sortField2= 'CreatedbyId';
         trial.sortField4= 'CreatedbyId';
         trial.previousSortField3='CreatedbyId';
         trial.previousSortField1='CreatedbyId';
         trial.previousSortField2= 'CreatedbyId';
         trial.previousSortField4= 'CreatedbyId';
         trial.SortSolutions();
  Test.stopTest();
    
 }
  
   
}