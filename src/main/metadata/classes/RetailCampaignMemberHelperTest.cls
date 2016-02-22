@isTest
public class RetailCampaignMemberHelperTest {
    
  static Account thirdParty;
  static Account dealer;
  static Retail_Campaign__c rc;  
  static Retail_Campaign_Member__c rtm;
  static list<Retail_Campaign_Member__c>  listRCM;
  static String thirdPartyRTID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('3rd Party').getRecordTypeId();
  static String dealerType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();  
  static String RTId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('S&M Event Retail Campaign').getRecordTypeId();    
    
              public static testMethod void testRetailCampaignMemberDuplicateCheck()
              {
                 prepareTestData();
                 test.startTest();
                 RetailCampaignMemberHelper.retailCampaignMemberDuplicateCheck(listRCM); 
                 test.stopTest();
                 system.assert(rc!=null);
              }
              
            public static void prepareTestData()
            {
             List<Trigger__c> triggerRetailCampaignMembers = [select Id from Trigger__c where Trigger_Name__c = 'TriggerRetailCampaignMember'];
                   if (triggerRetailCampaignMembers == null || triggerRetailCampaignMembers.isEmpty()) {
                       upsert new Trigger__c(Name = 'TriggerRetailCampaignMember',Market__c='NA', Trigger_Name__c = 'TriggerRetailCampaignMember', Trigger_Handler__c = 'TriggerRetailCampaignMemberHandler', enabled__c = true, before__c = true, after__c = true, insert__c = true, update__c = true, delete__c = true);
                   }
                  thirdParty = new Account(LastName = 'Test Amit', RecordTypeId =thirdPartyRTID, Phone ='12345678921',PersonOtherPhone='0231456987',PersonHomePhone='0231456989',PersonMobilePhone='0231456439',Retail_Fax__c='0237456989',Retail_Home_Phone__c='0281456989',Retail_Mobile__c='0231456949',Retail_Work_Phone__c='0231056989');
                   insert thirdParty;
                   dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer');
                   insert dealer;
                   rc = new Retail_Campaign__c(RecordTypeId =RTId,Dealer_Name__c = dealer.Id, Apply_Status__c = 'Approved');
                   insert rc;      
                   rtm = new Retail_Campaign_Member__c(Retail_Campaign__c = rc.Id, Contact__c = thirdParty.Id, Status__c = 'Show up');
                   insert rtm; 
                  
                   listRCM = new list<Retail_Campaign_Member__c>();
                  listRCM.add(rtm);
            }
}