@isTest
Public  with sharing class TrialCustomerPortalHomePageTest
{
    
public static string Crtid='createdbyid';
public static string Crtid1='createdbyid1';
public static string Crtid3='createdbyid3';
public static string Crtid4='createdbyid4';
  @isTest static void TestTrialCustomerHomePageController()
 {
        Id Owner; 
        Account a;
        Contact contactObj;
        Profile profileObj = [SELECT Id FROM Profile where Name ='System Administrator' Limit 1];
        UserRole roleObj = [Select Id From UserRole Where Name = 'IT Manager' Limit 1];
        User runAsUser = new User(
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
                
                    a = new Account();
                    a.Name='Test' + '0';
                    a.AnnualRevenue=1000 * Math.random();
                    //a.OwnerId = Owner;
                    
                    insert a;
                    
                    contactObj = new Contact(FirstName = 'Test',AccountId = a.Id,LastName ='User');
                    insert contactObj;
                                
        }
        
        
        
        Profile portalProfile = [SELECT Id FROM Profile where Name ='Dealer Community User' Limit 1];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User portalUser1 = new User(
        Username = System.now().millisecond() + 'test12Z345@test.com',
        ContactId = contactObj.Id,
        //UserRoleId  = portalRole.Id,
        ProfileId = portalProfile.Id,
        Alias = 'test1234',
        Email = 'test12345@test.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'McTesty',
        PortalRole = 'Manager',
        //UserType ='Portal',
        CommunityNickname = 'test1234510',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US'
        );
        
        insert portalUser1; 
        
     
       
      system.runAs(runAsUser){
         Test.startTest();
             List<Asset> listsol=new List<Asset>();
             Asset assetObj = new Asset();
             assetObj.AccountId = a.Id;
             assetObj.Name ='Test';              
             insert assetObj; 
          
                       
             TrialCustomerPortalHomePageController trial=new TrialCustomerPortalHomePageController();  
             
             trial.sortField3 = Crtid3;
             trial.sortField1= Crtid;
             trial.sortField2= Crtid1;
             trial.sortField4= Crtid4;
          
             trial.previousSortField3=Crtid3;
             trial.previousSortField1=Crtid;
             trial.previousSortField2= Crtid1;
             trial.previousSortField4= Crtid4;
             
            // trial.SortProducts();
          
          Test.stopTest();
            //System.assert(!listsol.isempty());
            //System.assertNotEquals(null,accs);
      }
 }
    @isTest static void TestTrialCustomerHomePageController1()
    {
        Id Owner; 
        Account a;
        Contact contactObj;
        Profile profileObj = [SELECT Id FROM Profile where Name ='System Administrator' Limit 1];
        UserRole roleObj = [Select Id From UserRole Where Name = 'IT Manager' Limit 1];
        User runAsUser = new User(
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
                
                    a = new Account();
                    a.Name='Test' + '0';
                    a.AnnualRevenue=1000 * Math.random();
                    //a.OwnerId = Owner;
                    
                    insert a;
                    
                    contactObj = new Contact(FirstName = 'Test',AccountId = a.Id,LastName ='User');
                    insert contactObj;
                                
        }
        
        
        
        Profile portalProfile = [SELECT Id FROM Profile where Name ='Dealer Community User' Limit 1];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        User portalUser1 = new User(
        Username = System.now().millisecond() + 'test12Z345@test.com',
        ContactId = contactObj.Id,
        //UserRoleId  = portalRole.Id,
        ProfileId = portalProfile.Id,
        Alias = 'test1234',
        Email = 'test12345@test.com',
        EmailEncodingKey = 'UTF-8',
        LastName = 'McTesty',
        PortalRole = 'Manager',
        //UserType ='Portal',
        CommunityNickname = 'test1234510',
        TimeZoneSidKey = 'America/Los_Angeles',
        LocaleSidKey = 'en_US',
        LanguageLocaleKey = 'en_US'
        );
        
        insert portalUser1; 
        
     
       
      system.runAs(portalUser1){
         
                                                  
                  
        Test.startTest();
            List<Case> caselst = new List<Case>();
          
            Case caseObj = new Case(AccountId = a.Id,ContactId =contactObj.Id,Subject ='This is a Test Case',Status ='New');
            caselst.add(caseObj);
            caseObj = new Case(AccountId = a.Id);
            caselst.add(caseObj);
            insert caselst;
            system.debug('$$contactObj.Id##'+contactObj.Id);
           
             TrialCustomerPortalHomePageController trial=new TrialCustomerPortalHomePageController();  
             trial.sortField3 = Crtid;
             trial.sortField1= Crtid;
             trial.sortField2= Crtid;
             trial.sortField4= Crtid;
             trial.previousSortField3=Crtid;
             trial.previousSortField1=Crtid;
             trial.previousSortField2= Crtid;
             trial.previousSortField4= Crtid;
             trial.SortCases();
             
        Test.stopTest();
      }
 }
@isTest static void TestTrialCustomerHomePageController3()
    {
                         List<Solution> listsol=new List<Solution>();
                            for(integer i = 0; i<1000; i++) 
                            {
                              Solution sol=new Solution();
                              sol.SolutionName='test';
                              //sol.OwnerId = Owner;
                              listsol.add(sol);
                           } 
                        insert listsol;                           
                  
        Test.startTest();
         TrialCustomerPortalHomePageController trial=new TrialCustomerPortalHomePageController();  
         trial.sortField3 = Crtid;
         trial.sortField1= Crtid;
         trial.sortField2= Crtid;
         trial.sortField4= Crtid;
         trial.previousSortField3=Crtid;
         trial.previousSortField1=Crtid;
         trial.previousSortField2= Crtid;
         trial.previousSortField4= Crtid;
        // trial.SortSolutions();
  Test.stopTest();
    
 }
    @isTest static void TestTrialCustomerHomePageController4()
    {/*
        
                         List<Ideas> listide=new List<Ideas>();
                            for(integer i = 0; i<1000; i++) 
                            {
                          Ideas ide=new Ideas();
                          //ide.Body    = 'Test';
                          //sol.OwnerId = Owner;
                          listide.add(ide);
                           } 
                        insert listide;                           
                  
Test.startTest();
 TrialCustomerPortalHomePageController trial=new TrialCustomerPortalHomePageController();  
 trial.sortField3 = Crtid3;
 trial.sortField1= Crtid;
 trial.sortField2= Crtid1;
 trial.sortField4= Crtid4;
 trial.previousSortField3=Crtid3;
 trial.previousSortField1=Crtid;
 trial.previousSortField2= Crtid1;
 trial.previousSortField4= Crtid4;
 trial.SortIdeas();
  Test.stopTest();*/
   
 }
}