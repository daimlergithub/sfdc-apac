/*
    Type:       Test Class
    Purpose:    Test Class for TriggerTask and UtilTask
    User Story: US-Cpn-026
    Used By:
    History:    
    1. Mouse Created on 2013-07-12
*/
@isTest
private class TriggerTaskTest {
private static CampaignMember member;
private static Task smsTask;
private static Campaign campaignExecution;
private static Account personAccount;
private static Id personContactId;
       public static void preparedTestData()
        {
         personAccount = (Account)UtilTestData.createSobject(new Account(Mobile__c ='09865855267'), 
       UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
                    
       Campaign centralMKTCampaign = new Campaign();
         UtilTestData.createSobject(centralMKTCampaign, 
          UtilTestData.CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN);
                    
        Campaign cacCampaign = new Campaign(ParentId = centralMKTCampaign.Id);
         UtilTestData.createSobject(cacCampaign, 
           UtilTestData.CAMPAIGN_RT_CENTRAL_MKT_CAMPAIGN);
                    
             campaignExecution = new Campaign(ParentId = cacCampaign.Id);
             UtilTestData.createSobject(campaignExecution, 
             UtilTestData.CAMPAIGN_RT_CAMPAIGN_EXECUTION);
             UtilTestData.createCampaignMemberStatus(campaignExecution);
                    
                            // Create CampaignMember for campaignExecution
           personContactId = [SELECT PersonContactId 
                                                  FROM Account WHERE Id = :personAccount.Id].PersonContactId;
               member = new CampaignMember(
                 ContactId = personContactId,
                  CampaignId = campaignExecution.Id
                            );
            UtilTestData.createSobject(member, null);
                    
                            // Create Task for campaignExecution
                              smsTask = new Task(
                                WhatId = campaignExecution.Id,
                                WhoId = personContactId,
                                Activity_Status__c = 'Sent'
                            );
                            UtilTestData.createSobject(smsTask, UtilTestData.TASK_RT_SMS);
                    }             

    static testMethod void testUpdateCampaignMemberStatus_OneAssignedTask() {
        preparedTestData();
        Test.startTest();
        member = [SELECT Status FROM CampaignMember WHERE Id = :member.Id];
        System.assert(member.Status == 'Sent');

        // Update Task Activity_Status__c
        smsTask.Activity_Status__c = 'Success';
        update smsTask;
        member = [SELECT Status FROM CampaignMember WHERE Id = :member.Id];
        System.assert(member.Status != 'Responded');

        // Update Task Activity_Status__c
        smsTask.Activity_Status__c = 'Fail-Blacklist';
        update smsTask;
        member = [SELECT Status FROM CampaignMember WHERE Id = :member.Id];
        Test.stopTest();
        System.assert(member.Status != 'Failed/No Response');
    }

    static testMethod void testUpdateCampaignMemberStatus_ManyAssignedTasks() 
    {
      preparedTestData();
      Test.startTest();
        // Create eDM Task for campaignExecution
        Task eDMTask = new Task(
            WhatId = campaignExecution.Id,
            WhoId = personContactId
        );
        UtilTestData.createSobject(eDMTask, UtilTestData.TASK_RT_EDM);

        // Update eDMTask to high priority
        eDMTask.Activity_Status__c = 'Subscribe';
        update eDMTask;
        member = [SELECT Status FROM CampaignMember WHERE Id = :member.Id];
        System.assert(member.Status != 'Registered');

        // Update eDMTask to lower priority
        eDMTask.Activity_Status__c = 'Unsubscribe';
        member = [SELECT Status FROM CampaignMember WHERE Id = :member.Id];
        Test.stopTest();
        System.assert(member.Status != 'Registered');
         
    }
}