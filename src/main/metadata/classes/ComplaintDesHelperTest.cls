@isTest
private class ComplaintDesHelperTest {

    //MB Complaint record type
    static String MB_COMPLAINT_RECORD_TYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
    static String personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    static String dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    static case c1;  
    static Case cas;   
    static Complaint_Description__c sm; 
    
    //main test  
    static testMethod void sendMailToCaseMember() {
        User user1 = UtilTestData.createUser('Regional CRM Mgr (S)','Regional CRM Manager');
        User user2 = UtilTestData.createUser('Regional CRM Mgr (S)','Regional CRM Manager');
         system.runAs(user1){
            Test.startTest();
           Account acc = new Account(LastName='acme', Phone='11111222', Area_Code__c = '010' ,RecordTypeId = personRecordtypeid);
           insert acc;           
            Account dealer = new Account(Name = 'dealer', RecordTypeId = dealerRecordtypeid);
            insert dealer;
            c1 = new Case( AccountId = dealer.Id, RecordTypeId = MB_COMPLAINT_RECORD_TYPE,
                               Case_SubType__c='Dealer-after sales service attitude',
                               Urgent__c = true,Ref_No_Regional__c='SOUTH', Case_Dealer__c = dealer.Id,Ref_No_Central__c='SOUTH');
            insert c1;                          
            CaseTeamRole  memberRole = new CaseTeamRole(Name='fortest',AccessLevel='Edit');
            insert memberRole;
            CaseTeamMember member1 = new CaseTeamMember(ParentId=c1.id,MemberId = user1.id,TeamRoleId=memberRole.id);
            CaseTeamMember member2 = new CaseTeamMember(ParentId=c1.id,MemberId = user2.id,TeamRoleId=memberRole.id);
            insert member1;
            insert member2;       
            Attachment at= new Attachment(ParentId = c1.id , Name='testFile' , body=Blob.valueOf('Unit Test Attachment Body'));
            insert at;       
            Test.stopTest();      
            System.assert(c1!=null);     
        }
    }
  
    public static void init(){
        upsert new Trigger__c(Name = 'TriggerComplaintDescription',Market__c='NA', Trigger_Name__c = 'TriggerComplaintDescription', Trigger_Handler__c = 'TriggerComplaintDescriptionHandler', enabled__c = true, before__c = true, after__c = true, insert__c = true, update__c = true, delete__c = true);
        cas = (Case)UtilTestData.createSobject(new Case(), UtilTestData.CASE_RT_MB_COMPLAINT);
        cas.Workflow_Order__c=true;
        update cas;   
        sm = new Complaint_Description__c ();
        sm.Case__c = cas.id;
        sm.Description__c='aaa';
        insert sm;          
    }

    public static testMethod void test_before_AfterInsertEvents_Insert() {
         Test.startTest();
              init();                        
        Test.stopTest();       
        system.assert(sm!=null);               
       }      
    public static testMethod void test_before_AfterInsertEvents_Update() {
        Test.startTest();
           init();                            
           sm.Description__c = 'ddd';
           update sm; 
           cas.Description_Changed__c=true;
           update cas;                
        Test.stopTest();   
        Case caseLst=[Select id,Description_Changed__c from case where Id=:cas.Id];   
        system.assertEquals(caseLst.Description_Changed__c,false);      
       }    
     public static testMethod void test_before_AfterInsertEvents_Delete() {
        Test.startTest();
        cas = (Case)UtilTestData.createSobject(new Case(), UtilTestData.CASE_RT_MB_COMPLAINT);
             init();     
            delete sm;        
        Test.stopTest();  
        Case caseLst=[Select id,Workflow_Order__c,Description_Changed__c from case where Id=:cas.Id];  
        system.assert(caseLst!=null);   
       }     
}