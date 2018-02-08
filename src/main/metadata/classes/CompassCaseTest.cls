@isTest
public class CompassCaseTest {
public static User user1;
public static User user_Obj; 
public static List<Case> CaseFieldsList;    
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
    system.runAs(user1){
          List<String> AccountFields=new List<String>();
    AccountFields.add('Lastname');
    AccountFields.add('Individual_Home_Phone__c');
    AccountFields.add('Work_Phone__c');
    AccountFields.add('fax');
    AccountFields.add('Mobile__c');
    AccountFields.add('MD__c');
    List<Account> AccountFieldsList=DataFactoryServices.createRecords('Account',AccountFields,'',1);
    AccountFieldsList[0].RecordTypeId=RecordTypeAccessService.getRecordTypeId('Account',Label.PersonAccount);
    AccountFieldsList[0].Lastname='Lastname1';
    AccountFieldsList[0].Individual_Home_Phone__c='+6003123654789';
    AccountFieldsList[0].Work_Phone__c='+60825634789541';
    AccountFieldsList[0].fax='+60827896541';
    AccountFieldsList[0].Mobile__c='+609856321478';
    AccountFieldsList[0].MD__c='MY';
     AccountFieldsList[0].Market__C='MY';
    insert AccountFieldsList;
    List<String> CaseFields=new List<String>();
    CaseFields.add('Status');
    CaseFields.add('Case_RepeatCause__c');
    CaseFields.add('accountid');
    CaseFields.add('Recordtypeid');   
    CaseFields.add('MD__c');
    CaseFields.add('priority');
    CaseFieldsList=DataFactoryServices.createRecords('Case',CaseFields,'',2);
    CaseFieldsList[0].RecordTypeId=RecordTypeAccessService.getRecordTypeId('Case','S24h - MMC');
    CaseFieldsList[0].accountid=AccountFieldsList[0].id;
    CaseFieldsList[0].MD__c='MY';
    CaseFieldsList[0].status='Open';
    CaseFieldsList[0].Case_RepeatCause__c='';
    CaseFieldsList[0].priority='A';
    CaseFieldsList[1].RecordTypeId=RecordTypeAccessService.getRecordTypeId('Case','S24h - MMC');
    CaseFieldsList[1].accountid=AccountFieldsList[0].id;
    CaseFieldsList[1].MD__c='MY';
    CaseFieldsList[1].status='Open';
    CaseFieldsList[1].Case_RepeatCause__c='';
    CaseFieldsList[1].priority='Green <= 2';
    insert CaseFieldsList;
        
           }
}
    
       static testMethod void coverttolead1controller1() {
        try{
        
          setupTestData();
          System.runAs (user_Obj) {  
          //ApexPages.currentPage().getParameters().put('CampaignMemberId',campaignMemberObj.id);  
          //coverttolead1controller c = new coverttolead1controller();
          //system.assertEquals(false,c.displayPopup) ;    
          Trigger__c CaseTrigger=new Trigger__c(Name='CaseTrigger',Trigger_Name__c='CaseTrigger',Trigger_Handler__c='TriggerCaseTriggerHandlerMY',update__c=true,insert__c=true,delete__c=true,after__c=true,before__c=true,enabled__c=true,Market__c='MY');
          upsert CaseTrigger;
          test.startTest();
          CompassCase cc= new CompassCase();
          cc.updateOwnerwithDealer(CaseFieldsList);
          cc.updateOwner(CaseFieldsList); 
          system.assertEquals('S24h - MMC',CompassCase.Case_RecordTypeId) ;        
          test.stopTest();    
               
           }
          }
        catch(Exception e){}
    }    

    
}