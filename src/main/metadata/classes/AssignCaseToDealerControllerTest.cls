/*
    Type:       Test Class
    Purpose:    Test On AssignCaseToDealerController
    1. Chaos Created on 2014-02-24

*/
@isTest
public Without Sharing class AssignCaseToDealerControllerTest {  
    
    final static String MBRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().
                                                get('MB Complaint').getRecordTypeId();
    private static user user1;
    private static user user2;
    private static User Usr;
    private static User portalUser;
    private static user selectedUser;
    Private static Case c;  
    Private static Community_License_Switch__c cls;
   
    public static void preparedTestData()
    {
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        //insert updatecustomsettings;
        Trigger__c newtrg = new Trigger__c(Name= 'TriggerDMRequest1',Trigger_Name__c = 'TriggerAccountLink',Trigger_Handler__c = 'TriggerAccountLinkTriggerHandlerJP',Market__c ='JP',
                               enabled__c = False,after__c= False,before__c= False,delete__c= False,update__c= False,insert__c= False);
        insert newtrg;
       //Creating User   
        user1=UtilTestData.createPortalUser('Dealer User','Dealer Community User');
        user2=UtilTestData.createPortalUser('Dealer User','Dealer Delegate Admin'); 
       //creating custom setting  
       cls=new Community_License_Switch__c();
       cls.Enable__c=true;
       cls.name='Community Enabled';
       insert cls;  
       //AssignCaseToDealerController.userName=user2.name;
        portalUser = [select name,accountId,email from user where contact.Dealer_Complaint_Gate_Keeper__c = true and id =:user1.Id and isActive = true limit 1];  
     
       selectedUser = [select name,accountId,email from user where id =:user2.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];                               
    
       //Creating Case       
        c = new Case(Subject='For Controller test',
                                  RecordTypeId = MBRecordtypeid, 
                                  Ref_No_Central__c = 'test',
                                  Case_Dealer__c = portalUser.AccountId,
                                  Dealer_Contact__c = 'YES');
       insert c; 
     
    }
    
    public static testMethod void testquery() 
    {
      
        //Added community license switching mechanism     
          preparedTestData();
            Usr=[select id from user where id=:UserInfo.getuserId()];
            System.runAs(usr) {
                Test.startTest();         
               
                Test.setCurrentPage(Page.AssignCaseToDealer);
                ApexPages.currentPage().getParameters().put('caseId', c.Id);
                AssignCaseToDealerController con = new AssignCaseToDealerController();
                con.userName=selectedUser.name;
                con.query();          
                Test.stopTest();
               system.assert(user1!=null);
               System.assertEquals(portalUser.AccountId,c.Case_Dealer__c); 
             }
       
    } 
      
    public static testMethod void testclear() 
    { 
        preparedTestData();
            Usr=[select id from user where id=:UserInfo.getuserId()];
            System.runAs(usr) {
                Test.startTest(); 
                Test.setCurrentPage(Page.AssignCaseToDealer);
                ApexPages.currentPage().getParameters().put('caseId', c.Id);
                AssignCaseToDealerController con = new AssignCaseToDealerController();    
                con.clear();         
                Test.stopTest();
                system.assert(user1!=null);
                system.assertEquals(portalUser.AccountId,c.Case_Dealer__c);
                system.assertEquals(con.hasQueryResult,false); 
                
             }       
    }
    public static testMethod void testassign() 
    {
       preparedTestData();
            Usr=[select id from user where id=:UserInfo.getuserId()];
            System.runAs(usr) {
                Test.startTest(); 
                Test.setCurrentPage(Page.AssignCaseToDealer);
                ApexPages.currentPage().getParameters().put('caseId', c.Id);
                AssignCaseToDealerController con = new AssignCaseToDealerController();       
                con.selectedUserId = selectedUser.Id;
                con.assign();
                Test.stopTest();
               system.assert(user1!=null);
                system.assertEquals(portalUser.AccountId,c.Case_Dealer__c);
                system.assertEquals(selectedUser.Id,con.assignCase.ownerId);
                system.assertEquals(c.SendEmailToGateKeeper__c,false);   
             }
    }
}