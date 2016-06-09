@isTest
public with sharing class AttachmentAftertestclass {
    
    private static String Finance_Fleet_lead_RECORDTYPEID = Schema.Sobjecttype.Lead__c.getRecordTypeInfosByName().get('Fleet Finance Lead').getRecordTypeId();
    private static String dealerRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    @istest(seealldata = false)
    public static void AttachmentAftertest() {
        
        User userobj = UtilTestData.createUser('SSI Supervisor','Fleet');
        system.runAs( userobj ) {
            Test.startTest();
            Account acc = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58399243', Name = 'testacc');
            insert acc;
           Lead__c le1 = new Lead__c();
            //le1.Need_Assign_To_Dealer__c = 'Need';
            le1.Company_Account__c = acc.id;
            le1.RecordTypeId = Finance_Fleet_lead_RECORDTYPEID;
            le1.CAC_Lead_Status__c = 'Qualified';
            insert le1; 
            Attachment a = new Attachment(ParentId = le1.id , Name='testFile' , body=Blob.valueOf('Unit Test Attachment Body'));
            insert a; 
            delete a;
        Test.stopTest();
        system.assertEquals(le1.Attachment_Flag__c, false);
    }
       
    }

}