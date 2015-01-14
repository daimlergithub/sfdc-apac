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
                                    
        User user1 = UtilTestData.createUser('AS Service Technical Director','BMBS Service Technical Manager');
        System.runAs ( user1 ) {
            Test.startTest(); 
        
            User portalUser = [select accountId , email from user 
                                    where contact.Dealer_Complaint_Gate_Keeper__c = true 
                                    and isActive = true limit 1];
            User selectedUser = [select accountId , email from user 
                                    where contact.Dealer_Complaint_Gate_Keeper__c = true 
                                    and isActive = true and id <> :portalUser.id limit 1];
                
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
            //System.assertEquals(con.users.size() > 0, true);
            
            con.clear();
            //System.assertEquals(con.users.size(), 0);
            
            con.selectedUserId = selectedUser.Id;
            con.assign();
            //System.assertEquals(con.assignCase.ownerId, selectedUser.Id);
            //System.assertEquals(con.assignCase.Case_Dealer__c, selectedUser.AccountId);
            
            Test.stopTest();
        }
    }
}