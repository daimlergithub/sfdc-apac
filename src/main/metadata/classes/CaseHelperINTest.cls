/**
* Test Class for Class CaseHelperIN and triggercaseHandlerIN
* Author: Shashi Goswami
* Created Date : 23rd May 2018
*/

@isTest
public class CaseHelperINTest {
    
    public static User u;
    public static Id RecordTypeId;
    public static Id RecordTypeIdPersonAccount;
    public static Account acc;
    public static Contact con;
    public static PermissionSet ps;
    public static Persona__c p;
    Public static Case caseInserted; 
    
    public static void testData(){
        u = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        ps = new PermissionSet(Name = 'Test', Label = 'Test');
        insert ps;
        CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.INGeneric];
        SetupEntityAccess sea = new SetupEntityAccess();
        sea.ParentId = ps.Id;
        sea.SetupEntityId = cps.id;
        insert sea;
        CustomPermission cps1 = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.INRetail];
        SetupEntityAccess sea1 = new SetupEntityAccess();
        sea1.ParentId = ps.Id;
        sea1.SetupEntityId = cps1.id;
        insert sea1;
        PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = u.Id,PermissionSetId = ps.Id);
        insert psa;
        RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
        RecordTypeIdPersonAccount=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        system.runAs(u){
            Trigger__C t= new Trigger__c(Name='CaseTriggerIN',Trigger_Handler__c='triggercaseHandlerIN',Market__c='IN',Trigger_Name__c='CaseTrigger',enabled__c=true,after__c=true,before__c=true,delete__c=true,insert__c=true,update__c=true);
            insert t;
            acc= new Account(FirstName = 'Person', LastName='Account', Mobile__c='1234567890',RecordTypeId= RecordTypeIdPersonAccount, Market__c='IN');
            insert acc;
            con= new contact(FirstName = 'Person', LastName='Account');
            insert con;
            Market__c m= new Market__c(Market__c='India',Market_Code__c='IN');
            insert m;
            Functionality_Access_Master__c fam= new Functionality_Access_Master__c(Module_Name__c='TestFAM',PermissionSet_Ids__c=String.ValueOf(ps.Id));
            insert fam;
            p = new Persona__c(Market_Access__c=m.Id, Functionality_Access__c=fam.Id, PersonaName__c='InGeneric', ProfileId__c=u.ProfileId);
            insert p;
        }    
        u.Persona_Assigned__c = p.PersonaName__c;
        update u;
    }
    
    @isTest
    public static void caseInsertAndUpdateTest(){
        testData();
        Case c = new Case();
        c.RecordTypeId = RecordTypeId;
        c.AccountId = acc.Id;
        c.Subject='Test MB Complaint Creation';
        c.Status = 'Open';
        c.Market__c='IN';
        c.ContactId= con.Id;
        
        system.runAs(u){
            test.startTest();
                insert c;
                INTriggerRecursionCheck.inCaseCustPhase = false;
                INTriggerRecursionCheck.inCaseCaseOwner = false;
                INTriggerRecursionCheck.inCaseRetCpy = false;
                INTriggerRecursionCheck.inCaseShare = false;
                INTriggerRecursionCheck.inCaseCompAmt = false;
                c.Subject='Test MB Complaint Updation';
                c.status='Closed';
                c.Resolved_Date__c=System.today();
                update c;
            test.stopTest();
            system.assertNotEquals(c.Id,null);
        }
    }
}