@isTest
 public class ConvertToDMRequestTest
 {
   public static Id parentCampaign_RecordTypeID = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
   public static testMethod void CampaignTest()
    {
       Test.startTest();
   
       Campaign parentCamp=new Campaign(
             Name='test par',
            EndDate=Date.Today().adddays(+10),
            StartDate=Date.Today(),
            Segmentation_Date__c=system.today(),
            RecordtypeID=parentCampaign_RecordTypeID,
            Status='Responded');
            insert parentCamp;       
              Campaign_Member__c cmm=new Campaign_Member__c(     
             Status__c='Responded',
             Campaign_ID__c=parentCamp.id);
             insert cmm;     
           ConvertToDMRequest controller = new ConvertToDMRequest();
            ConvertToDMRequest.wrapAccount newt =  new ConvertToDMRequest.wrapAccount(cmm); 
            newt.selected = True;
            controller.wrapAccountList.add(newt);
           controller.processSelected();
        List<Campaign_Member__c > SelectedAccounts=new List<Campaign_Member__c >();
          Campaign_Member__c CampMem=new Campaign_Member__c();
          CampMem.Status__c='Responded';
          SelectedAccounts.add(CampMem);
          insert SelectedAccounts;
          
          
          
        
          
       Test.stopTest();
     }
  }