@isTest
public class AccountHelperFMTest {

    static User fmUser;
    static User fmUser2;
    static User intAPIUser;
    static Id retailPerson_RecordTypeId;
    static Id retailCompany_RecordTypeId;
    public static Market__c market_Obj;
    public static Functionality_Access_Master__c functionality_access_master_Obj ;
    public static Persona__c persona_Obj; 
    
    public static void TestData()
    {
        PermissionSet ps = new PermissionSet();
        ps.Name = 'Test';
        ps.Label = 'Test';
        insert ps;
        
        CustomPermission cps = [SELECT ID From CustomPermission WHERE MasterLabel =: Label.FMGeneric ];
        SetupEntityAccess sea = new SetupEntityAccess();
        sea.ParentId = ps.Id;
        sea.SetupEntityId = cps.id;
        insert sea;
        Profile p1 = [select id, name from profile where Name='System Administrator' limit 1];
        fmUser = TestUtils.createFMUser('VN');
        fmUser.ProfileId=p1.Id;
        insert fmUser;
        System.runAs(fmUser)
        {
            market_Obj = new Market__c(Market_Code__c = 'VN', Market__c = 'Vietnam');
            Insert market_Obj; 
            functionality_access_master_Obj = new Functionality_Access_Master__c(Description__c = '12', Module_Name__c = 'Modul230', PermissionSet_Ids__c = ps.id, Permission_Sets__c = ps.name);
            Insert functionality_access_master_Obj; 
            persona_Obj = new Persona__c(Market_Access__c = market_Obj.id, Functionality_Access__c = functionality_access_master_Obj.id, Active__c = true, PersonaName__c = 'FMPersona', ProfileId__c = p1.id , Profiles__c = p1.name);
            Insert persona_Obj; 
            fmUser2 = TestUtils.createFMUser('VN');
            fmUser2.ProfileId=p1.Id;
            fmUser2.Persona_Assigned__c='FMPersona';
            //insert fmUser;
            intAPIUser=TestUtils.IntegrationAPIUser();
            retailPerson_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
            retailCompany_RecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
            Trigger__c triggerObj=new Trigger__c(Name='TriggerAccountVN',Market__c='VN',Trigger_Handler__c='TriggerAccountTriggerHandlerFM',Trigger_Name__c='TriggerAccount',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,update__c=true);
            insert triggerObj;
        }
        
    }
    
    /*Method to check the update AcountField Before Insert,update On NotCall, updateOn PostalOptout,updateOn EmailOptout,update AgeRange */
    
    static testMethod void testAccAssignment() {
        TestData();
        System.runAs (fmUser2) {
           
            test.starttest();   
            Account Acc = TestUtils.createPersonAccountAsUserAsOwner(fmUser);
            
            acc.Email__c='update@test.com';
            update acc;
            test.stopTest();
        }
    }
    
/* This method is used to test Methods called in TriggerAccountTriggerHandlerFM using Integration User.*/

    
    static testMethod void testAccAssignmentInt() 
    {
        	TestData();
      		test.startTest();
        	intAPIUser=TestUtils.IntegrationAPIUser();
        	System.runAs(intAPIUser)
            {
                TriggerUtil.userCreate=false;
                Account Acc = TestUtils.createPersonAccountAsUserAsOwner(fmUser);
                acc.Email__c='update@test.com';
                update acc;
            }
            test.stopTest();   
    }
}