@isTest
public class coverttolead1controllerTest{
 public static Id parentRetailCampaign_RecordTypeID = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
   public static Id parentCampaign_RecordTypeID = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    private static Account dealer;
    private static Account contact;
    private static Lead__c lead;
    public static testMethod void CampaignTest()
    { User user1 = TestUtils.createAdminUser();
        System.runAs (user1) {
        Test.StartTest();
        retail_campaign__c re=new Retail_Campaign__C(Name='test par',RecordtypeID=Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId(),Campaign_Type__c='Sales');
       insert re;
        Retail_Campaign__c parentCamp=new Retail_Campaign__c(
             Name='test par',
            //EndDate=System.Today(),
            //StartDate=System.Today(),
            RecordtypeID=parentRetailCampaign_RecordTypeID,
            Parent_Campaign1__c=re.id
           );
    insert parentcamp;
         Campaign_Member__c cmm=new Campaign_Member__c(     
             Status__c='Responded',OwnerId = userinfo.getuserId(),
             Retail_Campaign_Id__c=parentcamp.id,Convert_To_Lead_Flag__c=false);
             insert cmm;
            PageReference pageRef = Page.Converttolead1;
           pageRef.getParameters().put('campaignMemberId', cmm.Id);
          
            Test.setCurrentPage(pageRef);   
         coverttolead1controller controller = new coverttolead1controller ();   
         controller.recordtypevalue = 'Sales_leads';
        controller.interstmodel='c-class';
        controller.displayPopup=false;
           controller.objectAPIName = 'Retail_Campaign__c';
           try{
               controller.getItems();
               controller.showPopup();
                   controller.closePopup();
                   //controller
                   //controller
            controller.convertToLead();
            }catch(exception e){}
           controller.cancel();
          
       Test.stopTest();
     }
}
    public static testMethod void CampaignTest1()
    { User user1 = TestUtils.createAdminUser();
        System.runAs (user1) {
        Test.StartTest();
        campaign re=new Campaign(Name='test par',RecordtypeID=Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId(),Campaign_Type__c = 'Finance');
       insert re;
        Campaign parentCamp=new Campaign(
             Name='test par',
            //EndDate=System.Today(),
            //StartDate=System.Today(),
            RecordtypeID=parentCampaign_RecordTypeID,
            Parent=re
            //parent.Campaign_Type__c == 'Sales'
           );
    insert parentcamp;
         Campaign_Member__c cmm=new Campaign_Member__c(     
             Status__c='Responded',OwnerId = userinfo.getuserId(),
             Campaign_ID__c=parentCamp.id,Convert_To_Lead_Flag__c=false);
             insert cmm;
            PageReference pageRef = Page.Converttolead1;
           pageRef.getParameters().put('campaignMemberId', cmm.Id);
          
            Test.setCurrentPage(pageRef);   
         coverttolead1controller controller = new coverttolead1controller ();   
         controller.recordtypevalue = 'Sales_leads';
        controller.interstmodel='c-class';
        controller.displayPopup=false;
           controller.objectAPIName = 'Retail_Campaign__c';
           try{
               controller.getItems();
               controller.showPopup();
                   controller.closePopup();
                   //controller
                   //controller
            controller.convertToLead();
            }catch(exception e){}
           controller.cancel();
          
       Test.stopTest();
     }
}
    }