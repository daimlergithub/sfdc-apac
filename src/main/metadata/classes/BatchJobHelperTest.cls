@isTest
public class BatchJobHelperTest
{
    static String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    static String cacCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CAC Campaign').getRecordTypeId();
    
    public static testMethod void testAfterInsert()
    {
        Test.startTest();
        
        Campaign top = new Campaign(
            IsActive = true, 
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = topCampRecordTypeId
        );
        
        insert top;
        
        Campaign cac = new Campaign(
            Name = 'cac', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
            RecordTypeId = cacCampRecordTypeId,
            ParentId = top.Id
        );
        insert cac;
      
        Batch_Job__c objBatch1= new Batch_Job__c();
        objBatch1.Batch_Type__c='Lead';
        objBatch1.Campaign_Set__c=top.Id+';'+cac.id;
        objBatch1.Fail_Reason__c='Test Fail';
        objBatch1.Recipient_Eamil__c='test@email.com';
        objBatch1.Status__c='Pending';
        insert objBatch1;
        // We have below line of code since Batchjobs 
        //in production org weren't getting kicked off.
        BatchJobHelper.afterInsertEvents();
         Test.stopTest();
         System.assertEquals(objBatch1.Status__c,'Pending');
    }
}