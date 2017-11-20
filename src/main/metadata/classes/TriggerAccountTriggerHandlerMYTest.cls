@isTest
public class TriggerAccountTriggerHandlerMYTest{

 private static List<Account> accountList = new List<Account>();
 private static Account personAcc1;
 private static Map<id,Account> accountMap =  new map<id,Account>();
 private static user us1;
 public static void prepareTestData(String testCase){
  Trigger__c TriggerAccountTH = new Trigger__c(Name='TriggerAccountTH',Trigger_Name__c='TriggerAccount',Trigger_Handler__c='TriggerAccountTriggerHandlerMY',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='MY');
  insert TriggerAccountTH;
        system.debug('p--'+TriggerAccountTH);
        CallOutHandlerSettingDFW__c coh = new CallOutHandlerSettingDFW__c();
        coh.Name = 'CalloutValues';
        coh.DEFAULT_CALLOUT_TIME__c = '10000';
        coh.MAX_CALLOUT_TIME__c ='120000';  
        coh.FAILED_STATUS__c='failed';
        coh.JSON_CONTENT_TYPE__c ='application/json';
        coh.KO_STATUS__c='KO';       
        coh.OK_STATUS__c='OK';
        coh.PLAIN_TEXT_CONTENT_TYPE__c='text/plain';
        coh.QUEUED_STATUS__c='Queued';
        coh.REQUEST_BODY_NAME__c='request body';
        coh.REQUEST_CERT_NAME__c='request cert';
        coh.REQUEST_HEADERS_NAME__c='request headers';
        coh.RESPONSE_NAME__c='response';
        DMLManagerService.insertAsSystem(coh);       
        
        Profile p = [SELECT Id,Name FROM Profile WHERE Name='System Administrator']; 
        SystemSettingsDFW__c sysSet = new SystemSettingsDFW__c();
        sysSet.Debug__c =true;
        sysSet.Error__c = true;
        sysSet.Info__c= true;
        sysSet.Warning__c = true;
        sysSet.Log_Purge__c =10;
        sysSet.Name=p.Name;
        DMLManagerService.insertAsSystem(sysSet);
        
        us1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, Market__c='MY',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(us1);
  
  personAcc1 = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',
                               //Individual_Home_Phone__c = '02-202-2456',
                               Home_Phone_2__c = '02-202-2457',Work_Phone__c = '+601212378978',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '03',
                               MD__c = 'MY',
                              LastName = 'galaxy1',
                              FirstName = 'First Name',
                              Salutation = 'Unknown',
                               Postal_Opt_Out__c=True,     
                               Province__c = 'Shanghai',
                               ZipCode__c= '32703',
                               //Mobile__c = '918197597651',
                               //Mobile2__c = '918197597651',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Primary_Phone__c ='Other2',
                               PersonDoNotCall=True,
                              // ownerid=user1.id,
                               PersonHasOptedOutOfEmail=True,
                               Opt_In_Email__c=true,
                               //owner=user1,
                               PersonBirthdate=date.today(),
                               
                           RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
   
   accountList.add(personAcc1); 
   
   for(Account a:accountList){
       accountMap.put(a.Id,a);
   }
  
 }
 
 public static testMethod void testHandleTriggerInsert(){
  List<Trigger__c> updatecustomsettings =  UtilCustomSettingskernel.customSettingDetails();
      insert updatecustomsettings;
    prepareTestData('');
     system.runAs(us1 ){

    insert accountList;}
 } 
 
 public static testMethod void testHandleTriggerUpdate(){
     List<Trigger__c> updatecustomsettings =  UtilCustomSettingskernel.customSettingDetails();
    insert updatecustomsettings;
    prepareTestData('');
      system.runAs(us1 ){
    
    insert accountList;
	TriggerRecursiveCheck.run = true;								 
    update accountList; 
    }
 } 
 public static testMethod void testHandleTriggerDelete(){
 List<Trigger__c> updatecustomsettings =  UtilCustomSettingskernel.customSettingDetails();
      insert updatecustomsettings;
      
    prepareTestData('');
         system.runAs(us1 ){
     
    insert personAcc1;
    List<Account> accList = [SELECT Id,Name FROM Account WHERE Id =:personAcc1.Id];
    delete accList;
    }
 } 
 

}