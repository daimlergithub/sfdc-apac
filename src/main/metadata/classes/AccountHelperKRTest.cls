/**
* Test class for AccountHelperKR
* Author : Chethan A
* Created date : 23-AUG-2016
*/

@isTest
public class AccountHelperKRTest {

 private static List<Account> accountList = new List<Account>();
 private static Account personAcc;
 private static Map<id,Account> accountMap =  new map<id,Account>();
    
 
 public static void prepareTestData(String testCase){
  Trigger__c TriggerAccountKR = new Trigger__c(Name='TriggerAccountKR',Trigger_Name__c='TriggerAccount',Trigger_Handler__c='TriggerAccountTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
  insert TriggerAccountKR;
  
  personAcc = new Account(Dealer_Default_Flag__c=false,
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
   
   if(testCase.equals('DoNotCall')){
       personAcc.PersonDoNotCall = TRUE;
   }else if(testCase.equals('EmailOptout')){
       personAcc.PersonHasOptedOutOfEmail = TRUE;   
   }else if(testCase.equals('AgeRangeCase1')){
       personAcc.PersonBirthdate = Date.valueOf(String.valueOf(Integer.valueOf(System.today().year())-20)+'-01'+'-01');
   }else if(testCase.equals('AgeRangeCase2')){
       personAcc.PersonBirthdate = Date.valueOf(String.valueOf(Integer.valueOf(System.today().year())-30)+'-01'+'-01');   
   }else if(testCase.equals('AgeRangeCase3')){
       personAcc.PersonBirthdate = Date.valueOf(String.valueOf(Integer.valueOf(System.today().year())-40)+'-01'+'-01');   
   }else if(testCase.equals('AgeRangeCase4')){
       personAcc.PersonBirthdate = Date.valueOf(String.valueOf(Integer.valueOf(System.today().year())-50)+'-01'+'-01');   
   }else if(testCase.equals('AgeRangeCase5')){
       personAcc.PersonBirthdate = Date.valueOf(String.valueOf(Integer.valueOf(System.today().year())-60)+'-01'+'-01');   
   }else if(testCase.equals('AgeRangeCase6')){
       personAcc.PersonBirthdate = Date.valueOf(String.valueOf(Integer.valueOf(System.today().year())-70)+'-01'+'-01');   
   }else if(testCase.equals('AgeRangeCase7')){
       personAcc.PersonBirthdate = Date.valueOf(String.valueOf(Integer.valueOf(System.today().year())-10)+'-01'+'-01');   
   }
   
   accountList.add(personAcc); 
   
   for(Account a:accountList){
       accountMap.put(a.Id,a);
   }
  
 }

 public static testMethod void testUpdateAccountFieldsBeforeInsert(){
     prepareTestData('');
     Test.startTest();
     AccountHelperKR.updateAccountFieldsBeforeInsert(accountList,TRUE);
     Test.stopTest();
 }
 
 public static testMethod void testUpdateAccountFieldsBeforeUpdate(){
    prepareTestData('');
    Test.startTest();
    AccountHelperKR.updateAccountFieldsBeforeUpdate(accountList,accountMap,TRUE);
    Test.stopTest();
 }
 
 // ON HOLD
 public static testMethod void testUpdatePrimaryAddressdisplay(){
 }

 public static testMethod void testUpdateOnDoNotCall(){
     prepareTestData('DoNotCall');
     //PersonDoNotCall;
     AccountHelperKR.updateOnDoNotCall(accountList);
 }
 
 public static testMethod void testUpdateOnEmailOptout(){
     prepareTestData('EmailOptout');
     AccountHelperKR.updateOnEmailOptout(accountList);
 }
 
 // Case1 :
 public static testMethod void testUpdateAgeRangeCase1(){
     prepareTestData('AgeRangeCase1');
     AccountHelperKR.updateAgeRange(accountList); 
  }
 
 // Case2 :
 public static testMethod void testUpdateAgeRangeCase2(){
     prepareTestData('AgeRangeCase2');
     AccountHelperKR.updateAgeRange(accountList);
 }
 
 // Case3 :
 public static testMethod void testUpdateAgeRangeCase3(){
     prepareTestData('AgeRangeCase3');
     AccountHelperKR.updateAgeRange(accountList); 
 }
 
 //Case4 :
 public static testMethod void testUpdateAgeRangeCase4(){
     prepareTestData('AgeRangeCase4');
     AccountHelperKR.updateAgeRange(accountList); 
 }
  
  //Case5 :
 public static testMethod void testUpdateAgeRangeCase5(){
     prepareTestData('AgeRangeCase5');
     AccountHelperKR.updateAgeRange(accountList); 
 }
 
  //Case6 :
 public static testMethod void testUpdateAgeRangeCase6(){
     prepareTestData('AgeRangeCase6');
     AccountHelperKR.updateAgeRange(accountList); 
 }
 
 //Case7 :
 public static testMethod void testUpdateAgeRangeCase7(){
     prepareTestData('AgeRangeCase7');
     AccountHelperKR.updateAgeRange(accountList); 
 } 

}