/*
    Type:       Test Class
    Purpose:    Test On AssignCaseToDealerController
    ---------------------------------------------------------------
    History:
    
    1. Chaos Created on 2014-02-24

*/
@isTest(seeAllData=true) 
public class AssignCaseToDealerControllerTest {
    
    final static String MBRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
    static Case cas;
    static AssignCaseToDealerController extension;
    static User currentDelegateUsr;
    static User portalCommunityUsr;
    static User currentUsr;
    static User portalUser;
    static User selectedUser;
    static{
       currentUsr=[select id from user where id=:UserInfo.getuserId()];
    }
   
   private static void init() {
         portalCommunityUsr=UtilTestData.createPortalUser('Dealer','Dealer Community User');
         currentDelegateUsr=UtilTestData.createPortalUser('Dealer','Dealer Delegate Admin');         
         portalUser = [select accountId,email from user 
                                    where contact.Dealer_Complaint_Gate_Keeper__c = true and id =:portalCommunityUsr.Id
                                    and isActive = true limit 1];   
         selectedUser = [select accountId,email from user where id =:currentDelegateUsr.Id and contact.Dealer_Complaint_Gate_Keeper__c = true 
                                    and isActive = true limit 1];                                    
         cas = new Case(Subject='For Controller test', RecordTypeId = MBRecordtypeid,Ref_No_Central__c = 'test',
                        Case_Dealer__c = portalUser.AccountId,Dealer_Contact__c = 'YES');
         insert cas;
         Test.setCurrentPage(Page.AssignCaseToDealer);
         ApexPages.currentPage().getParameters().put('caseId', cas.Id);
         extension = new AssignCaseToDealerController(); 
    }
    public static testMethod void testquery() { 
         init();
        System.runAs(currentUsr){
            Test.startTest();       
            extension.query();          
            Test.stopTest();
            system.assert(portalCommunityUsr!=null);
            System.assertEquals(portalUser.AccountId,cas.Case_Dealer__c);
            System.assertEquals(selectedUser.Id,extension.assignCase.ownerId);
            System.assertEquals(selectedUser.AccountId,extension.assignCase.Case_Dealer__c); 
         }
    }
        public static testMethod void testclear() {
        init();
        System.runAs(currentUsr) {
            Test.startTest(); 
            extension.clear();         
            Test.stopTest();
            system.assert(portalCommunityUsr!=null);
            system.assertEquals(portalUser.AccountId,cas.Case_Dealer__c);
            system.assertEquals(selectedUser.Id,extension.assignCase.ownerId);
            system.assertEquals(selectedUser.AccountId,extension.assignCase.Case_Dealer__c);
            system.assertEquals(extension.hasQueryResult,false); 
            
         }
    }
      public static testMethod void testassign() {
        init();
        System.runAs(currentUsr) {
            Test.startTest();           
            extension.selectedUserId = selectedUser.Id;
            extension.assign();
            Test.stopTest();
            system.assert(portalCommunityUsr!=null);
            system.assertEquals(portalUser.AccountId,cas.Case_Dealer__c);
            system.assertEquals(selectedUser.Id,extension.assignCase.ownerId);
            system.assertEquals(cas.OwnerId,selectedUser.Id); 
            system.assertEquals(cas.Case_Dealer__c,[select AccountId from User where id = :selectedUser.Id].AccountId);
            system.assertEquals(cas.SendEmailToGateKeeper__c,true);    
         }
    }
}