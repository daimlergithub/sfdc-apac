@isTest
public class ScheduleCampCompletionTest{
public static Id parentCampaign_RecordTypeID = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
public static Id childCampaign_RecordTypeID= Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();

     public static testMethod void unitTest()
     {
         Test.startTest();
             Campaign parentCamp=new Campaign(
             Name='test par',
            EndDate=System.Today(),
            StartDate=System.Today(),
            RecordtypeID=parentCampaign_RecordTypeID,
            Status='Draft');
            insert parentCamp;
                     
             Campaign ChildCamp=new Campaign(
             Name='Sam',
             EndDate=System.Today(),
             StartDate=System.Today(),
             RecordtypeID=childCampaign_RecordTypeID,
             Child_Campaign_Status__c='Execution');
             insert ChildCamp;
            
             Campaign_Member__c cmm=new Campaign_Member__c(     
             Status__c='Not Responded');
             insert cmm;
                   
           System.assertEquals(parentCamp.Status,'Draft');
           System.assertEquals(ChildCamp.Child_Campaign_Status__c,'Execution');
           System.assertEquals(cmm.Status__c,'Not Responded');
                   
           System.assertEquals(parentCamp.Status,'Draft'); 
           System.assertEquals(ChildCamp.Child_Campaign_Status__c,'Execution');
           System.assertEquals(cmm.Status__c,'Not Responded');
           
           
            ScheduleCampCompletion CampSch = new ScheduleCampCompletion();
            String sch = '0 36 18 * * ?'; 
            System.schedule('Test Campaign completion', sch, CampSch); 

        Test.stopTest(); 
    }
}