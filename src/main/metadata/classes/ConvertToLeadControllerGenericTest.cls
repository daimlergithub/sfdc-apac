@isTest
public class ConvertToLeadControllerGenericTest
{
   public static Id parentRetailCampaign_RecordTypeID = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
   public static Id parentCampaign_RecordTypeID = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    private static Account dealer;
    private static Account contact;
    private static Lead__c lead;
   public static testMethod void CampaignTest()
    {
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        
      User user1 = new User(Alias = 's121Cam', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                          TimeZoneSidKey='America/Los_Angeles', UserName='Campaigntestuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user1 );
     system.runAs(user1){   
     RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer', MBK_Data_Source__c ='Email');
        insert dealer;
        contact = (Account)UtilTestData.createSobject(new Account(Mobile__c ='0001234567'), 
                UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        RecordType retailLeadType = [select Id, developername from recordtype where sobjecttype = 'lead__c' and developername = 'Retail_Sales_Leads'];
       
       Test.startTest();
   
       Campaign parentCamp=new Campaign(
             Name='test par',
            EndDate=System.Today()+10,
            StartDate=System.Today(),
            Segmentation_Date__c=system.today(),
            RecordtypeID=parentCampaign_RecordTypeID,
            Status='Responded',
            Campaign_Type__c='Finance' );
            insert parentCamp;       
              Campaign_Member__c cmm=new Campaign_Member__c(     
             Status__c='Responded',OwnerId = userinfo.getuserId(),
             Campaign_ID__c=parentCamp.id , Lead_Type__c = 'Used Car',Lead_Sub_Type__c = 'Demo Car',Interested_Model__c= 'A 180 Hatchback',Contact_Id__c= contact.Id);
             insert cmm;     
              lead = new Lead__c(Assigned_Dealer__c = dealer.Id, Contact__c = contact.Id, RecordTypeId = retailLeadType.Id,Source_Campaign__c =parentCamp.id,
              Lead_Type__c = 'Used Car',Lead_Sub_Type__c = 'Demo Car',Interested_Vehicle_Model__c = 'A 180 Hatchback');
        insert lead;
        List<lead__c> LeadList=new List<lead__c>();
        LeadList.add(lead);
            PageReference pageRef = Page.ConvertToLead;
            pageRef.getParameters().put('CampaignId', parentCamp.Id);
           
            Test.setCurrentPage(pageRef);   
           ConvertToLeadControllerGeneric controller = new ConvertToLeadControllerGeneric ();   
           ConvertToLeadControllerGeneric.CampaignMemberInfo newt = new ConvertToLeadControllerGeneric.CampaignMemberInfo(cmm);
           newt.isSelected= True;
           controller.campaignMembers.add(newt);
           controller.objectAPIName = 'Campaign';
           try{
            controller.convertToLead();
            controller.closePopup();
            system.assertEquals(false,controller.displayPopup) ;   
            controller.showPopup();   
           system.assertEquals(true,controller.displayPopup) ;    
            controller.getItems();
            controller.objectAPIName = 'Account';
            controller.convertToLead();
            controller.checkDuplicate(cmm,LeadList);   
               
            }catch(exception e){}
          controller.cancel();
         
       Test.stopTest();
      } 
     }
     public static testMethod void CampaignTest1()
    {
      Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        
      User user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testusertest11@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user1 );
     system.runAs(user1){   
       Test.startTest();
   
       Retail_Campaign__c parentCamp=new Retail_Campaign__c(
             Name='test par',
            //EndDate=System.Today(),
            //StartDate=System.Today(),
            RecordtypeID=parentRetailCampaign_RecordTypeID
           );
            insert parentCamp;       
              Campaign_Member__c cmm=new Campaign_Member__c(     
             Status__c='Responded',OwnerId = userinfo.getuserId(),
             Retail_Campaign_Id__c=parentCamp.id);
             insert cmm;     
            PageReference pageRef = Page.ConvertToLead;
           pageRef.getParameters().put('CampaignId', parentCamp.Id);
          
            Test.setCurrentPage(pageRef);   
         ConvertToLeadControllerGeneric controller = new ConvertToLeadControllerGeneric ();   
           ConvertToLeadControllerGeneric.CampaignMemberInfo newt = new ConvertToLeadControllerGeneric.CampaignMemberInfo(cmm);
           newt.isSelected= True;
           controller.campaignMembers.add(newt);
           controller.objectAPIName = 'Retail_Campaign__c';
           try{
            controller.convertToLead();
            //controller.checkDuplicate(cmm, Lead);
            system.assertNotEquals(Null, controller.campaignMembers ) ;   
           }catch(exception e){}
           controller.cancel();
          
       Test.stopTest();
     }
    }    
  }