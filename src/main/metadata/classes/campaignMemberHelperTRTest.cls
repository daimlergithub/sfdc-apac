@isTest
public class campaignMemberHelperTRTest {
    static testmethod void  beforeupdateinserttest(){
        List<CampaignMember> campMemList = new List<CampaignMember>();
        List<Campaign_member__c> cmlist = new list<Campaign_member__c>();
        User user1 = TestUtils.createAdminUser();
		user1.market__c='TR';
        update user1;
        Trigger__c TriggerAccountTH = new Trigger__c(Name='TriggerCMTR',Trigger_Name__c='TriggerCampaignMember',Trigger_Handler__c='TriggerCampaignMembersTriggerHandlerTR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TR');
        insert TriggerAccountTH;					 
        System.runAs (user1) {
            test.starttest();
            Campaign top1 = new Campaign(          
            Name = 'top', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today(),
			Market__c='TR'
            );
            insert top1;            

            contact c=new Contact();
            c.lastName='abc';
			c.Market__c='TR';
            insert c;

            Campaignmember campMbr=new CampaignMember();
            campMbr.CampaignId = top1.Id;
            campMbr.ContactId =c.Id;           
            campMbr.Task_Generated__c = false;
			campMbr.Market__c='TR';
            insert campMBR;
            campMbr.Status = 'Planned';
            update campMbr;
            
			

        }
    }
}