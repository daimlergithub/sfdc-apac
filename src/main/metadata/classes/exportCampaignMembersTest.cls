@isTest
public class exportCampaignMembersTest
{
   public static Id parentCampaign_RecordTypeID = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
   public static testMethod void CampaignTest()
    {
       Test.startTest();
   
       Campaign parentCamp=new Campaign(
             Name='test par',
            EndDate=System.Today(),
            StartDate=System.Today(),
            RecordtypeID=parentCampaign_RecordTypeID,
            Status='Responded');
            insert parentCamp;               
             ApexPages.currentPage().getParameters().put('Id',parentCamp.id);
              exportCampaignMembers controller = new exportCampaignMembers(); 
             Test.stopTest();
     }
     public static testMethod void CampaignTest2()
    {
       Test.startTest();
   
       Retail_Campaign__C parentCamp=new Retail_Campaign__C (
             Name='test par');
            insert parentCamp;      
              
             ApexPages.currentPage().getParameters().put('Id',parentCamp.id);
              exportCampaignMembers controller = new exportCampaignMembers(); 
             Test.stopTest();
     }
  }