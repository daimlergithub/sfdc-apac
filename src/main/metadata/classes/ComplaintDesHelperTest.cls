@isTest
private class ComplaintDesHelperTest {

    //MB Complaint record type
    static String MB_COMPLAINT_RECORD_TYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();

    static case c1 = null;

    //main test
    static testMethod void myUnitTest() {

        String personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        String dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        User user1 = UtilTestData.createUser('Regional CRM Mgr (S)','Regional CRM Manager');
        User user2 = UtilTestData.createUser('Regional CRM Mgr (S)','Regional CRM Manager');


        system.runAs(user1){
            Test.startTest();
            Account acc = new Account(LastName='acme', Phone='11111222', Area_Code__c = '010' ,RecordTypeId = personRecordtypeid);
            insert acc;
            Account dealer = new Account(Name = 'dealer', RecordTypeId = dealerRecordtypeid);
            insert dealer;
            c1 = new Case( AccountId = acc.Id, RecordTypeId = MB_COMPLAINT_RECORD_TYPE,
                               Case_SubType__c='Dealer-after sales service attitude',
                               Urgent__c = true,Ref_No_Regional__c='SOUTH', Case_Dealer__c = dealer.Id,Ref_No_Central__c='SOUTH');

            insert c1;

            CaseTeamRole  memberRole = new CaseTeamRole(Name='fortest',AccessLevel='Edit');
            insert memberRole;

            CaseTeamMember member1 = new CaseTeamMember(ParentId=c1.id,MemberId = user1.id,TeamRoleId=memberRole.id);
            CaseTeamMember member2 = new CaseTeamMember(ParentId=c1.id,MemberId = user2.id,TeamRoleId=memberRole.id);
            insert member1;
            insert member2;
            test_method_one();
            test_method_two();
            Test.stopTest();
            system.assert([select id from Account where id=:dealer.id].size()>0);
            system.assert([select id from Case where id=:c1.id].size()>0);
            system.assertEquals(member1.ParentId,c1.id); 
            system.assertEquals(member2.ParentId,c1.id);
            system.assertEquals(member1.MemberId,user1.id);
            system.assertEquals(member2.MemberId,user2.id);
            system.assertEquals(member1.TeamRoleId,memberRole.id);
            system.assertEquals(member2.TeamRoleId,memberRole.id);
        }

    }

    /**
         As the case team member, when a  team member
         create  a complaint description/ resolution on MB Complaint ,
         and the ?Urgent? field of the case is ticked,
         an notify email will be sent to other case team members.
    */
    static void test_method_one() {
        Complaint_Description__c cdc= new Complaint_Description__c(Case__c=c1.id);
        //system.debug('#########'+cdc);
        insert cdc;
        // Implement test code
    }

    /**
        As the case team member, when a  team member  create  a attachment on MB Complaint ,
        and the ?Urgent? field of the case is ticked,
        an notify email will be sent to other case team members.
    */
    static void test_method_two() {
        Attachment a = new Attachment(ParentId = c1.id , Name='testFile' , body=Blob.valueOf('Unit Test Attachment Body'));
        insert a;
        // Implement test code
    }
    
    public static testMethod void testTriggerComplaintDescAfterInsertUpdateDelete() {
    	Test.startTest();
        Case cas = (Case)UtilTestData.createSobject(new Case(), UtilTestData.CASE_RT_MB_COMPLAINT);
        Complaint_Description__c sm = new Complaint_Description__c (
            Case__c = cas.id
        );
        try {
            insert sm;
        } catch (DMLException e) {
            System.debug('new description error : ' + e.getDMLMessage(0));
        }
        sm.Description__c = 'ddd';
        try {
            update sm;
        } catch  (DMLException e) {
            System.debug('update description error : ' + e.getDMLMessage(0));
        }
        system.assert([select id from Complaint_Description__c where Id=:sm.id].size()>0); 
        system.assertEquals(sm.Description__c,'ddd'); 
        try {
            delete sm;
        } catch  (DMLException e) {
            System.debug('delete description error : ' + e.getDMLMessage(0));
        }
        Test.stopTest();   
        system.assert([select id from Case where id=:cas.id].size()>0);       
       }
}