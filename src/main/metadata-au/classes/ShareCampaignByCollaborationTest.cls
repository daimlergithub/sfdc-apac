@isTest 
public class ShareCampaignByCollaborationTest {
 @isTest static void testShareCampaignByCollaboration (){
 String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
        String cacCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CAC Campaign').getRecordTypeId();
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
        Collaboration_Team__c Colla=new Collaboration_Team__c();
        Colla.Campaign__c=cac.id;
        Colla.Access_Type__c='Read/Write';
        Colla.Resource_Required__c='no';
       insert Colla;
       Colla.Access_Type__c='Read/Write';
        Colla.Resource_Required__c='Yes';
        update Colla;
        delete Colla;
        Test.stopTest();
 }
 
}