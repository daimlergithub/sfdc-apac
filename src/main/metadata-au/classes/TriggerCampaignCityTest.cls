@isTest 
public class TriggerCampaignCityTest {
 @isTest static void testCampaignHelper(){
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
        Campaign_City__c campcity=new Campaign_City__c();
        campcity.Campaign__c=cac.id;
        campcity.Start_Date__c=system.today();
        campcity.End_Date__c=system.today()+1;
        insert campcity;
        delete campcity;
        Test.stopTest();
 }
 
}