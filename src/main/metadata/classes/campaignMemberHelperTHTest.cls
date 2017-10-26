@isTest
public class campaignMemberHelperTHTest{
static testmethod void  beforeupdateinserttest(){
 Trigger__C casetrigger=new Trigger__C(name='TriggerCampaignMembersTH',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='TriggerCampaignMembersCustomHandlerTH',Trigger_Name__c='TriggerCampaignMember',update__c=true);
insert casetrigger;
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
          TriggerCampaignMembersCustomHandlerTH ts=new TriggerCampaignMembersCustomHandlerTH();
          ts.handleIntegrationTrigger(true,true,true,true,true);
            }
}

}