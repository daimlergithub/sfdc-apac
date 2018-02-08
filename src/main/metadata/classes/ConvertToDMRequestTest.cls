@isTest
public class ConvertToDMRequestTest {
  public static User user1;
  public static User user_Obj;   
  public static Campaign parentCamp;  
  public static Campaign_Member__c cmm ; 
  public static Id parentCampaign_RecordTypeID = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
  @testSetup    
static void setupTestData(){ 
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        
        user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user1 );
        user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user_Obj );
        system.runAs(user_Obj){
       parentCamp=new Campaign(Name='test par', EndDate=Date.Today().adddays(+10), StartDate=Date.Today(), Segmentation_Date__c=system.today(), 
                                     RecordtypeID=parentCampaign_RecordTypeID, Status='Responded');
      insert parentCamp;       
      
    cmm=new Campaign_Member__c(Status__c='Responded',Campaign_ID__c=parentCamp.id);
      insert cmm;  
      
      List<Campaign_Member__c > SelectedAccounts=new List<Campaign_Member__c >();
      Campaign_Member__c CampMem=new Campaign_Member__c();
      CampMem.Status__c='Responded';
      SelectedAccounts.add(CampMem);
      insert SelectedAccounts;
            
            
        }
}
static testMethod void ConvertToDMRequestTest1() {
  //  try{
        
      setupTestData();      
      System.runAs (user_Obj) {  
      test.startTest();  
      ApexPages.currentPage().getParameters().put('Id',parentCamp.id );  
     // ConvertToDMRequest.objectAPIName='Campaign';    
    ConvertToDMRequest controller = new ConvertToDMRequest();
      system.assertNotEquals(null,ConvertToDMRequest.camId);
      controller.processSelected();
      controller.cancel();    
      controller.setDMRequestRecordFields(parentCamp.id,cmm);  
      system.assertEquals(true,controller.campaignMembers.size()>0 );
          
      test.stopTest();
          }
       //}catch(Exception e){}
     


  }
}