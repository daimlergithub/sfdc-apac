@isTest
public class campaignMemberHelperMYTest {
    static testmethod void  beforeupdateinserttest(){
        List<CampaignMember> campMemList = new List<CampaignMember>();
        List<Campaign_member__c> cmlist = new list<Campaign_member__c>();
        User user1 = TestUtils.createAdminUser();
		user1.market__c='MY';
        update user1;
        Trigger__c TriggerAccountTH = new Trigger__c(Name='TriggerCMTH',Trigger_Name__c='TriggerCampaignMember',Trigger_Handler__c='TriggerCampaignMembersTriggerHandlerMY',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='MY');
        insert TriggerAccountTH;					 
        System.runAs (user1) {
            test.starttest();
            Campaign top1 = new Campaign(          
            Name = 'top', 
            Status = 'Started', 
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
			/* TriggerCampaignMembersTriggerHandlerMY cth = new TriggerCampaignMembersTriggerHandlerMY();
            cth.handleTrigger(true,true, true, true, true);
             cth.handleIntegrationTrigger(true,true, true, true, true);

            campMemList.add(campMbr);
            campaignMemberHelperMY.beforeInsertevents(campMemList);*/

        }
    }
}