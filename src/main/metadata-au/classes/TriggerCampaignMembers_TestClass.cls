/*
    Type:       Test Class
    Purpose:    TriggerCampaignMembers 
    User Story:     
    Used By:    
    ---------------------------------------------------------------
    History:
    
    10-July-2013 Stephano Shi (Breakingpoint)    Created
*/
@isTest
public class TriggerCampaignMembers_TestClass{
    static testmethod void runTriggerCampaignMembers(){
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap_test = Schema.SObjectType.Campaign.getRecordTypeInfosByName();
        Map<String, Schema.RecordTypeInfo> accRecordTypeMap_test = Schema.SObjectType.Account.getRecordTypeInfosByName();
        Id caeSim_RecordTypeId = cpRecordTypeMap_test.get('Campaign Execution - Simple').getRecordTypeId();                       // CAC Campaign
        Id accPerson_RecordTypeId = accRecordTypeMap_test.get('Person Account').getRecordTypeId();      // Person Account.
        
        // Execution Campaign Inital
        Campaign TestData_CAE_OBC = new Campaign(Name='TestData_CAE_OB_SIM_C',
                                                Campaign_Code__c='code exe ob sim testc',
                                                Execution_Type__c='OB Call',
                                                Task_Created_By__c='Contact',
                                                RecordTypeId=caeSim_RecordTypeId);
        Database.insert(TestData_CAE_OBC);

        // Contact                
        Account testPerAcc = new Account(LastName='TEST ACC',
                                      Type='Company',
                                      Status__c='VIP',
                                      Province__c='Shanghai',
                                      City__c='Baoshan district',
                                      ZipCode__c='123456',
                                      PersonMobilePhone='1235678910',
                                      RecordTypeId=accPerson_RecordTypeId,
                                      Salutation='Brother',FirstName='Test',Email__c='test@mbau.com',Email2__c = 'testemail2@test.com',Home_Phone_2__c = '98765413'
                                     );        
        insert(testPerAcc);
                                         
        testPerAcc = [Select Id, PersonContactId From Account Where Id = :testPerAcc.Id];
        
        // Campaign Member Initial
        CampaignMember cm1 = new CampaignMember(CampaignId = TestData_CAE_OBC.Id,
                                                Status ='Sent',
                                                ContactId = testPerAcc.PersonContactId
                                                );  
        insert cm1;
    }
        
}