@isTest
public with sharing class campaignHistoryLogGenerationTest{
    
    public static Campaign testCampaign;
    public static User testUser;
    
    static void init(){
        User thisUser = [ select Id,UserRoleId from User where Id = :UserInfo.getUserId() ];
        testCampaign = (Campaign)UtilTestData.createSobject(new Campaign(), UtilTestData.CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN);
        system.runAs(thisUser){
            testUser = (User)UtilTestData.createUser('Dealer User', 'System Administrator');
        }     
    }
    
    public static testmethod void testLogGeneration(){
        init();
        Test.startTest();
        campaignHistoryLogGeneration ch_LogGeneration = new campaignHistoryLogGeneration();
        ch_LogGeneration.logGeneration('','insert', testCampaign.Id, testUser.Id, 'Case');
        Audit_Trail__c auditTrail = [Select Campaign__c from Audit_Trail__c Where User__c =: testUser.Id];
        system.debug(auditTrail);
        
        system.assertEquals(auditTrail.Campaign__c, testCampaign.Id);
        Test.stopTest();
    }   
}