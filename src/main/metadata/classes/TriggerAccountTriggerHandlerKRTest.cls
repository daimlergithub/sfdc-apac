/**
* Test class for TriggerAccountTriggerHandlerKR
* Author : Chethan A
* Created date : 23-AUG-2016
*/

@isTest
public class TriggerAccountTriggerHandlerKRTest{
 private static List<Account> accountList = new List<Account>();
 private static Account personAcc;
 private static Map<id,Account> accountMap =  new map<id,Account>();
 
 public static void prepareTestData(String testCase){
  Trigger__c TriggerAccountKR = new Trigger__c(Name='TriggerAccountKR',Trigger_Name__c='TriggerAccount',Trigger_Handler__c='TriggerAccountTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
  insert TriggerAccountKR;
  
  personAcc = new Account(Data_Source__c = 'Event',
                          Dealer_Default_Flag__c=false,
                           Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                           Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                           City__c='Beijing',
                           Gender__c = 'Male',
                           Phone = '0801801110',
                           Area_code__c = '0101',
                           MD__c = 'KR',
                           LastName = 'galaxy1',
                           FirstName = 'First Name',
                           Salutation = 'Unknown',      
                           Province__c = 'Shanghai',
                           ZipCode__c= '1002347',
                           Mobile__c = '023482832',
                           Mobile2__c = '035456232',
                           Primary_Email__c = 'Email1',
                           Primary_Fax__c = 'FAX2',
                           Primary_Phone__c ='Other2',
                           RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
   
   accountList.add(personAcc); 
   
   for(Account a:accountList){
       accountMap.put(a.Id,a);
   }
  
 }
 
 public static testMethod void testHandleTriggerCase2(){
    prepareTestData('');
    insert accountList;
    update accountList; 
 } 
 
 
 
 

}