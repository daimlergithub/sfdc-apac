@isTest
public class campaignMemberHelperMYTest {
    static testmethod void  beforeupdateinserttest(){
        List<CampaignMember> campMemList = new List<CampaignMember>();
        List<Campaign_member__c> cmlist = new list<Campaign_member__c>();
        User user1 = TestUtils.createAdminUser();
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

            campMemList.add(campMbr);
            campaignMemberHelperMY.beforeInsertevents(campMemList);

        }
    }
}