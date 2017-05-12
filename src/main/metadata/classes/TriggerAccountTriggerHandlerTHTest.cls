@isTest
public class TriggerAccountTriggerHandlerTHTest{

 private static List<Account> accountList = new List<Account>();
 private static Account personAcc1;
 private static Map<id,Account> accountMap =  new map<id,Account>();
 
 public static void prepareTestData(String testCase){
  Trigger__c TriggerAccountTH = new Trigger__c(Name='TriggerAccountTH',Trigger_Name__c='TriggerAccount',Trigger_Handler__c='TriggerAccountTriggerHandlerTH',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TH');
  insert TriggerAccountTH;
  
  personAcc1 = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',
                               //Individual_Home_Phone__c = '02-202-2456',
                               Home_Phone_2__c = '02-202-2457',Work_Phone__c = '+66-12-123-789',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               MD__c = 'TH',
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
    insert accountList;
 } 
 public static testMethod void testHandleTriggerUpdate(){
 List<Trigger__c> updatecustomsettings =  UtilCustomSettingskernel.customSettingDetails();
      insert updatecustomsettings;
    prepareTestData('');
    insert accountList;
    update accountList; 
 } 
 public static testMethod void testHandleTriggerDelete(){
 List<Trigger__c> updatecustomsettings =  UtilCustomSettingskernel.customSettingDetails();
      insert updatecustomsettings;
    prepareTestData('');
    insert personAcc1;
    List<Account> accList = [SELECT Id,Name FROM Account WHERE Id =:personAcc1.Id];
    delete accList;
 } 
 
 
 
 


 

}