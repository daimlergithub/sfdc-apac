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
 
    public static testMethod void testMyController() {
      
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
            con.query();
            con.clear();
            con.selectedUserId = selectedUser.Id;
            con.assign();
            Test.stopTest();
            system.assert(user1!=null);
            System.assertEquals(c.Case_Dealer__c, portalUser.AccountId);
            System.assertEquals(con.assignCase.ownerId, selectedUser.Id);
            System.assertEquals(con.assignCase.Case_Dealer__c, selectedUser.AccountId);
         }
    }
}