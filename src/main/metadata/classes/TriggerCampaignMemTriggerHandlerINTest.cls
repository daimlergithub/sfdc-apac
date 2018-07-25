/**
** Class: TriggerCampaignMemTriggerHandlerINTest
** Description: Test Class for TriggerCampaignMemTriggerHandlerIN
** Created By: Sravanthi Gudibandi
** Date: 22-05-2018
**/

@isTest
public class TriggerCampaignMemTriggerHandlerINTest{
    static testmethod void  beforeupdateinserttest(){
        List<CampaignMember> campMemList = new List<CampaignMember>();
        List<Campaign_member__c> cmlist = new list<Campaign_member__c>();
        User user1 =TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
    user1.market__c='IN';
        update user1;
        Trigger__c TriggerAccountIN = new Trigger__c(Name='TriggerCampaignMembersIN',Trigger_Name__c='TriggerCampaignMember',Trigger_Handler__c='TriggerCampaignMembersTriggerHandlerIN',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='IN');
        insert TriggerAccountIN;           
        System.runAs (user1) {
            test.starttest();
            Campaign top1 = new Campaign(          
            Name = 'top', 
            Status = 'Started', 
               IsActive=true,
            StartDate = System.today(), 
            EndDate = System.today()
            );
            insert top1;            

            contact c=new Contact();
            c.lastName='abc';
            insert c;

            Campaignmember campMbr=new CampaignMember();
            campMbr.CampaignId = top1.Id;
            campMbr.ContactId =c.Id;           
            campMbr.Task_Generated__c = false;
            insert campMBR;
             campMemList.add(campMbr);
           
    TriggerCampaignMembersTriggerHandlerIN cth = new TriggerCampaignMembersTriggerHandlerIN();
    
             cth.handleIntegrationTrigger(true,true, true, true, true);
              

        }
    }
}