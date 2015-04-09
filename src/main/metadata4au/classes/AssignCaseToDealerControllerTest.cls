/*
    Type:       Test Class
    Purpose:    Test On AssignCaseToDealerController
    ---------------------------------------------------------------
    History:
    
    1. Chaos Created on 2014-02-24

*/
@isTest(seeAllData=true) 
public class AssignCaseToDealerControllerTest {
    
    final static String MBRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().
                                                get('MB Complaint').getRecordTypeId();
 
    public static testMethod void testquery() {
      
        User user1=UtilTestData.createPortalUser('Dealer','Dealer Community User');
        User user2=UtilTestData.createPortalUser('Dealer','Dealer Delegate Admin');     
        User Usr=[select id from user where id=:UserInfo.getuserId()];
        System.runAs(usr) {
            Test.startTest();         
            User portalUser = [select accountId,email from user 
                                    where contact.Dealer_Complaint_Gate_Keeper__c = true and id =:user1.Id
                                    and isActive = true limit 1];   
            User selectedUser = [select accountId,email from user where id =:user2.Id and contact.Dealer_Complaint_Gate_Keeper__c = true 
                                    and isActive = true limit 1];                               
       
            Case c = new Case(Subject='For Controller test',
                              RecordTypeId = MBRecordtypeid, 
                              Ref_No_Central__c = 'test',
                              Case_Dealer__c = portalUser.AccountId,
                              Dealer_Contact__c = 'YES');
            insert c; 
           
            Test.setCurrentPage(Page.AssignCaseToDealer);
            ApexPages.currentPage().getParameters().put('caseId', c.Id);
            AssignCaseToDealerController con = new AssignCaseToDealerController();
            con.query();          
            Test.stopTest();
            system.assert(user1!=null);
            System.assertEquals(portalUser.AccountId,c.Case_Dealer__c);
            System.assertEquals(selectedUser.Id,con.assignCase.ownerId);
            System.assertEquals(selectedUser.AccountId,con.assignCase.Case_Dealer__c); 
         }
    }
        public static testMethod void testclear() {
      
        User user1=UtilTestData.createPortalUser('Dealer','Dealer Community User');
        User user2=UtilTestData.createPortalUser('Dealer','Dealer Delegate Admin');     
        User Usr=[select id from user where id=:UserInfo.getuserId()];
        System.runAs(usr) {
            Test.startTest();         
            User portalUser = [select accountId,email from user 
                                    where contact.Dealer_Complaint_Gate_Keeper__c = true and id =:user1.Id
                                    and isActive = true limit 1];   
            User selectedUser = [select accountId,email from user where id =:user2.Id and contact.Dealer_Complaint_Gate_Keeper__c = true 
                                    and isActive = true limit 1];                               
       
            Case c = new Case(Subject='For Controller test',
                              RecordTypeId = MBRecordtypeid, 
                              Ref_No_Central__c = 'test',
                              Case_Dealer__c = portalUser.AccountId,
                              Dealer_Contact__c = 'YES');
            insert c; 
           
            Test.setCurrentPage(Page.AssignCaseToDealer);
            ApexPages.currentPage().getParameters().put('caseId', c.Id);
            AssignCaseToDealerController con = new AssignCaseToDealerController();    
            con.clear();         
            Test.stopTest();
            system.assert(user1!=null);
            system.assertEquals(portalUser.AccountId,c.Case_Dealer__c);
            system.assertEquals(selectedUser.Id,con.assignCase.ownerId);
            system.assertEquals(selectedUser.AccountId,con.assignCase.Case_Dealer__c);
            system.assertEquals(con.hasQueryResult,false); 
            
         }
    }
      public static testMethod void testassign() {
      
        User user1=UtilTestData.createPortalUser('Dealer','Gold Partner User');
        User user2=UtilTestData.createPortalUser('Dealer','Dealer Delegate Admin');     
        User Usr=[select id from user where id=:UserInfo.getuserId()];
        System.runAs(usr) {
            Test.startTest();         
            User portalUser = [select accountId,email from user 
                                    where contact.Dealer_Complaint_Gate_Keeper__c = true and id =:user1.Id
                                    and isActive = true limit 1];   
            User selectedUser = [select accountId,email from user where id =:user2.Id and contact.Dealer_Complaint_Gate_Keeper__c = true 
                                    and isActive = true limit 1];                               
       
            Case c = new Case(Subject='For Controller test',
                              RecordTypeId = MBRecordtypeid, 
                              Ref_No_Central__c = 'test',
                              Case_Dealer__c = portalUser.AccountId,
                              Dealer_Contact__c = 'YES');
            insert c; 
           
            Test.setCurrentPage(Page.AssignCaseToDealer);
            ApexPages.currentPage().getParameters().put('caseId', c.Id);
            AssignCaseToDealerController con = new AssignCaseToDealerController();       
            con.selectedUserId = selectedUser.Id;
            con.assign();
            Test.stopTest();
            system.assert(user1!=null);
            system.assertEquals(portalUser.AccountId,c.Case_Dealer__c);
            system.assertEquals(selectedUser.Id,con.assignCase.ownerId);
            system.assertEquals(c.OwnerId,selectedUser.Id); 
            system.assertEquals(c.Case_Dealer__c,[select AccountId from User where id = :selectedUser.Id].AccountId);
            system.assertEquals(c.SendEmailToGateKeeper__c,true);    
         }
    }
}