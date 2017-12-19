@isTest
public class CampaignMemberHelperBaseTest{
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
            CampaignMemberHelperBase.updateCampaignMembermarket(campMemList);

            Id retailExecutionRecordId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
            Retail_campaign__c retcampchild=new Retail_Campaign__C(name='test123',recordtypeid=retailExecutionRecordId,Child_Campaign_Status__c='Planning',start_date__c=system.today()+2,close_Date__C=system.today()+2);
            insert retcampchild;

            Campaign_member__c campMember=new Campaign_member__c(Gaurantor_1_Name__c='TestMember',Retail_Campaign_Id__c=retcampchild.Id);
            insert campMember;

            cmlist.add(campMember);

            CampaignMemberHelperBase.updateCampaignMemberCustommarket(cmlist);
        }
    }
}