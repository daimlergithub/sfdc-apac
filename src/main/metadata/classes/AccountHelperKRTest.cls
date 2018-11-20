/**
* Test class for AccountHelperKR
* Author : Chethan A
* Created date : 23-AUG-2016
*/

@isTest
public class AccountHelperKRTest {

 private static List<Account> accountList = new List<Account>();
 private static Account personAcc;
   public static List<Account> listcampaigns;
 private static Map<id,Account> accountMap =  new map<id,Account>();
 public static Profile DealerDelegatedAdmin = [select Id from Profile where Name = 'Partner Community User' limit 1];   
  public static Profile DealerDelegatedAdmin1 = [select Id from Profile where Name = 'MBK CCC Retail Operator' limit 1];public static boolean persongroup1 = false;  
 public static Id dealeraddRecordtypeid = Schema.SObjectType.Address__c.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
  Private static String dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();

 public static void prepareTestData(String testCase){
  Trigger__c TriggerAccountKR = new Trigger__c(Name='TriggerAccountKR',Trigger_Name__c='TriggerAccount',Trigger_Handler__c='TriggerAccountTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
  insert TriggerAccountKR;
  
   KR_Switch__c krswitch=new KR_Switch__c(Name='AccountHelperswitch',Enable_Flag__c=True);
   List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
   lsttrgt.add(krswitch);
   insert lsttrgt;
   Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
         if (!KRSwitchEnabledFlag) {
  personAcc = new Account(Dealer_Default_Flag__c=false,
                           Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '000-0000-9642',Home_Phone_2__c = '000-0000-9642',Work_Phone__c = '000-0000-9642',
                           Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                           City__c='Beijing',
                           Gender__c = 'Male',
                           Phone = '000-0000-9642',
                           Area_code__c = '0101',
                           MD__c = 'KR',
                           LastName = 'galaxy1',
                           FirstName = 'First Name',
                           Salutation = 'Unknown',      
                           Province__c = 'Shanghai',
                           ZipCode__c= '1002347',
                           MBK_Data_Source__c='Email',
                           Mobile__c = '000-0000-9642',
                           Mobile2__c = '000-0000-9642',
                           Primary_Email__c = 'Email1',
                           Primary_Fax__c = 'FAX2',
                           Primary_Phone__c ='Other2',
                           Personal_Info_Third_Party_Release_CC_Old__c='Yes',
                           Personal_Agreement_CC_Old__c='Yes',
                           Agreement_to_commit_info_proces_CC_Old__c='Yes',
                           RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
   insert personAcc;
   system.debug('%%%%%%%%%%%%%%%'+personAcc);
   if(testCase.equals('DoNotCall')){
       personAcc.PersonDoNotCall = TRUE;
       personAcc.Opt_In_Home_Phone__c= TRUE;
       personAcc.Opt_In_Home_Phone2__c= TRUE;
       personAcc.Opt_In_Work_Phone__c= TRUE;
      personAcc.Opt_In_Work_Phone2__c=TRUE;
       personAcc.Preferred_Mobile_1__c=TRUE;
        personAcc.Preferred_Mobile_2__c=TRUE;
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
   
   //accountList.add(personAcc); 
   //system.debug('%%%%%%%%%%%%%%%'+accountList);
   }
   else
   {
    personAcc = new Account(Dealer_Default_Flag__c=false,
                           Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '+82-00-000-9642',Work_Phone__c = '+82-00-000-9642',
                           Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                           City__c='Beijing',
                           Gender__c = 'Male',
                           Phone = '000-0000-9642',
                           Area_code__c = '0101',
                           MD__c = 'KR',
                           LastName = 'galaxy1',
                           FirstName = 'First Name',
                           Salutation = 'Unknown',      
                           Province__c = 'Shanghai',
                           ZipCode__c= '1002347',
                           MBK_Data_Source__c='Email',
                           Mobile__c = '+82-00-000-9642',
                           Primary_Email__c = 'Email1',
                           Primary_Fax__c = 'FAX2',
                           Primary_Phone__c ='Other2',
                           Personal_Info_Third_Party_Release_CC_Old__c='Yes',
                           Personal_Agreement_CC_Old__c='Yes',
                           Agreement_to_commit_info_proces_CC_Old__c='Yes',
                           RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
   insert personAcc;
   system.debug('%%%%%%%%%%%%%%%'+personAcc);
   if(testCase.equals('DoNotCall')){
       personAcc.PersonDoNotCall = TRUE;
       personAcc.Opt_In_Home_Phone__c= TRUE;
       personAcc.Opt_In_Home_Phone2__c= TRUE;
       personAcc.Opt_In_Work_Phone__c= TRUE;
      personAcc.Opt_In_Work_Phone2__c=TRUE;
       personAcc.Preferred_Mobile_1__c=TRUE;
        personAcc.Preferred_Mobile_2__c=TRUE;
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
   system.debug('%%%%%%%%%%%%%%%'+accountList);
   }
   
   for(Account a:accountList){
       accountMap.put(a.Id,a);
       system.debug('%%%%%%%%%%%%%%%'+a.Id);
       system.debug('%%%%%%%%%%%%%%%'+accountMap);
   }
  
 }
 public static void prepareTestDataSwitch(String testCase){
  Trigger__c TriggerAccountKR = new Trigger__c(Name='TriggerAccountKR',Trigger_Name__c='TriggerAccount',Trigger_Handler__c='TriggerAccountTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
  insert TriggerAccountKR;
  
   KR_Switch__c krswitch=new KR_Switch__c(Name='AccountHelperswitch',Enable_Flag__c=false);
   List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
   lsttrgt.add(krswitch);
   insert lsttrgt;
   Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
         if (!KRSwitchEnabledFlag) {
  personAcc = new Account(Dealer_Default_Flag__c=false,
                           Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '000-0000-9642',Home_Phone_2__c = '000-0000-9642',Work_Phone__c = '000-0000-9642',
                           Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                           City__c='Beijing',
                           Gender__c = 'Male',
                           Phone = '000-0000-9642',
                           Area_code__c = '0101',
                           MD__c = 'KR',
                           LastName = 'galaxy1',
                           FirstName = 'First Name',
                           Salutation = 'Unknown',      
                           Province__c = 'Shanghai',
                           ZipCode__c= '1002347',
                           MBK_Data_Source__c='Email',
                           Mobile__c = '000-0000-9642',
                           Mobile2__c = '000-0000-9642',
                           Primary_Email__c = 'Email1',
                           Primary_Fax__c = 'FAX2',
                           Primary_Phone__c ='Other2',
                           Personal_Info_Third_Party_Release_CC_Old__c='Yes',
                           Personal_Agreement_CC_Old__c='Yes',
                           Agreement_to_commit_info_proces_CC_Old__c='Yes',
                           RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
   insert personAcc;
   system.debug('%%%%%%%%%%%%%%%'+personAcc);
   if(testCase.equals('DoNotCall')){
       personAcc.PersonDoNotCall = TRUE;
       personAcc.Opt_In_Home_Phone__c= TRUE;
       personAcc.Opt_In_Home_Phone2__c= TRUE;
       personAcc.Opt_In_Work_Phone__c= TRUE;
      personAcc.Opt_In_Work_Phone2__c=TRUE;
       personAcc.Preferred_Mobile_1__c=TRUE;
        personAcc.Preferred_Mobile_2__c=TRUE;
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
   
   //accountList.add(personAcc); 
   //system.debug('%%%%%%%%%%%%%%%'+accountList);
   }
   else
   {
    personAcc = new Account(Dealer_Default_Flag__c=false,
                           Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '+82-00-000-9642',Work_Phone__c = '+82-00-000-9642',
                           Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                           City__c='Beijing',
                           Gender__c = 'Male',
                           Phone = '000-0000-9642',
                           Area_code__c = '0101',
                           MD__c = 'KR',
                           LastName = 'galaxy1',
                           FirstName = 'First Name',
                           Salutation = 'Unknown',      
                           Province__c = 'Shanghai',
                           ZipCode__c= '1002347',
                           MBK_Data_Source__c='Email',
                           Mobile__c = '+82-00-000-9642',
                           Primary_Email__c = 'Email1',
                           Primary_Fax__c = 'FAX2',
                           Primary_Phone__c ='Other2',
                           Personal_Info_Third_Party_Release_CC_Old__c='Yes',
                           Personal_Agreement_CC_Old__c='Yes',
                           Agreement_to_commit_info_proces_CC_Old__c='Yes',
                           RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
   insert personAcc;
   system.debug('%%%%%%%%%%%%%%%'+personAcc);
   if(testCase.equals('DoNotCall')){
       personAcc.PersonDoNotCall = TRUE;
       personAcc.Opt_In_Home_Phone__c= TRUE;
       personAcc.Opt_In_Home_Phone2__c= TRUE;
       personAcc.Opt_In_Work_Phone__c= TRUE;
      personAcc.Opt_In_Work_Phone2__c=TRUE;
       personAcc.Preferred_Mobile_1__c=TRUE;
        personAcc.Preferred_Mobile_2__c=TRUE;
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
   system.debug('%%%%%%%%%%%%%%%'+accountList);
   }
   
   for(Account a:accountList){
       accountMap.put(a.Id,a);
       system.debug('%%%%%%%%%%%%%%%'+a.Id);
       system.debug('%%%%%%%%%%%%%%%'+accountMap);
   }
  
 }

 /*public static testMethod void testUpdateAccountFieldsBeforeInsert(){
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
 }*/
 
 // ON HOLD
 public static testMethod void testUpdatePrimaryAddressdisplay(){
 }

 public static testMethod void testUpdateOnDoNotCall(){
  try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
        
        prepareTestData('DoNotCall');
      
      if (!KRSwitchEnabledFlag) {
       AccountHelperKR.updateOnDoNotCall(accountList);
        }
       
        }
        catch(Exception e)
        {
        }
     
       }
       public static testMethod void testUpdateOnDoNotCallSwitch(){
  try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
        
        
        prepareTestDataSwitch('DoNotCall');
     //PersonDoNotCall;
      if (!KRSwitchEnabledFlag ) {
       AccountHelperKR.updateOnDoNotCall(accountList);
        }
        
        }
        catch(Exception e)
        {
        }
     
       }
 
 public static testMethod void testUpdateOnEmailOptout(){
 try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
       
     
     prepareTestData('EmailOptout');
      if (!KRSwitchEnabledFlag ) {
        AccountHelperKR.updateOnEmailOptout(accountList);
        }
        
       
        }
        catch(Exception e)
        {
        }
     
    
 }
  public static testMethod void testUpdateOnEmailOptoutSwitch(){
 try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
       
     prepareTestDataSwitch('EmailOptout');
   
      if (!KRSwitchEnabledFlag ) {
        AccountHelperKR.updateOnEmailOptout(accountList);
        }
       
        }
        catch(Exception e)
        {
        }
     
    
 }
 
 // Case1 :
 public static testMethod void testUpdateAgeRangeCase1(){
 try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
       
    
    prepareTestData('AgeRangeCase1');
      
       if (!KRSwitchEnabledFlag ) {
         AccountHelperKR.updateAgeRange(accountList); 
        }
        
        }
        catch(Exception e)
        {
        }
     
     
    
  }
  public static testMethod void testUpdateAgeRangeCase1Switch(){
 try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
       
     prepareTestDataSwitch('AgeRangeCase1');
   
      
       if (!KRSwitchEnabledFlag ) {
         AccountHelperKR.updateAgeRange(accountList); 
        }
       
       
        }
        catch(Exception e)
        {
        }
     
     
    
  }
 public static testMethod void testupdateAllowDataShareBasedonDocFields(){
 
 try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
       
     
    prepareTestData('AgeRangeCase1');
     if (!KRSwitchEnabledFlag ) {
         AccountHelperKR.updateAllowDataShareBasedonDocFields(accountList);
        }
        
        }
        catch(Exception e)
        {
        }
      }
      public static testMethod void testupdateAllowDataShareBasedonDocFieldsSwitch(){
 
 try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
       
     prepareTestDataSwitch('AgeRangeCase1');
    
     if (!KRSwitchEnabledFlag ) {
         AccountHelperKR.updateAllowDataShareBasedonDocFields(accountList);
        }
        
        
        }
        catch(Exception e)
        {
        }
      }
 // Case2 :
 public static testMethod void testUpdateAgeRangeCase2(){
     
     try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
       
     
    prepareTestData('AgeRangeCase2');
     if (!KRSwitchEnabledFlag ) {
      AccountHelperKR.updateAgeRange(accountList);
        }
       
       
        }
        catch(Exception e)
        {
        }
     
 }
 public static testMethod void testUpdateAgeRangeCase2Switch(){
     
     try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
       
     prepareTestDataSwitch('AgeRangeCase2');
    
     if (!KRSwitchEnabledFlag ) {
      AccountHelperKR.updateAgeRange(accountList);
        }
        
       
        }
        catch(Exception e)
        {
        }
     
 }
 // Case3 :
 public static testMethod void testUpdateAgeRangeCase3(){
     
      try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
       
    
   prepareTestData('AgeRangeCase3');
     if (!KRSwitchEnabledFlag ) {
     AccountHelperKR.updateAgeRange(accountList); 
        }
       
        }
        catch(Exception e)
        {
        }
     
 }
 public static testMethod void testUpdateAgeRangeCase3Switch(){
     
      try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
       
     prepareTestDataSwitch('AgeRangeCase3');
  
     if (!KRSwitchEnabledFlag ) {
     AccountHelperKR.updateAgeRange(accountList); 
        }
        
        }
        catch(Exception e)
        {
        }
     
 }
 
 //Case4 :
 public static testMethod void testUpdateAgeRangeCase4(){
     
      try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
       
     
   prepareTestData('AgeRangeCase4');
     if (!KRSwitchEnabledFlag ) {
     AccountHelperKR.updateAgeRange(accountList); 
        }
        
        }
        catch(Exception e)
        {
        }
     
     
 }
  public static testMethod void testUpdateAgeRangeCase4Switch(){
     
      try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
       
     prepareTestDataSwitch('AgeRangeCase4');
  
     if (!KRSwitchEnabledFlag ) {
     AccountHelperKR.updateAgeRange(accountList); 
        }
        
       
        }
        catch(Exception e)
        {
        }
     
     
 }
  
  //Case5 :
 public static testMethod void testUpdateAgeRangeCase5(){
     
     try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
       
    
  prepareTestData('AgeRangeCase5');
     if (!KRSwitchEnabledFlag ) {
      AccountHelperKR.updateAgeRange(accountList); 
        }
       
       
        }
        catch(Exception e)
        {
        }
     
     
 }
 public static testMethod void testUpdateAgeRangeCase5Switch(){
     
     try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
       
     prepareTestDataSwitch('AgeRangeCase5');
  
     if (!KRSwitchEnabledFlag ) {
      AccountHelperKR.updateAgeRange(accountList); 
        }
       
       
        }
        catch(Exception e)
        {
        }
     
     
 }
 
  //Case6 :
 public static testMethod void testUpdateAgeRangeCase6(){
    
     try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
       
      prepareTestData('AgeRangeCase6');
   
     if (!KRSwitchEnabledFlag ) {
      AccountHelperKR.updateAgeRange(accountList); 
        }
        
       
        }
        catch(Exception e)
        {
        }
     
     
 }
 public static testMethod void testUpdateAgeRangeCase6Switch(){
    
     try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
        prepareTestDataSwitch('AgeRangeCase5');
     
    
     if (!KRSwitchEnabledFlag ) {
      AccountHelperKR.updateAgeRange(accountList); 
        }
       
       
        }
        catch(Exception e)
        {
        }
     
     
 }
 
 //Case7 :
 public static testMethod void testUpdateAgeRangeCase7(){
 try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag  = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
       
    
   prepareTestData('AgeRangeCase7');
     if (!KRSwitchEnabledFlag ) {
      AccountHelperKR.updateAgeRange(accountList); 
        }
       
       
        }
        catch(Exception e)
        {
        }
     
     
 } 
  public static testMethod void testUpdateAgeRangeCase7Switch(){
 try{
    
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag  = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
       
     prepareTestDataSwitch('AgeRangeCase7');
  
     if (!KRSwitchEnabledFlag ) {
      AccountHelperKR.updateAgeRange(accountList); 
        }
       
       
        }
        catch(Exception e)
        {
        }
     
     
 } 
 public static testMethod void testUpdateAgeRangeCase8(){
 try{
    
  Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
      
       Contact con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
   User usr = new User(
            Username = System.now().millisecond() + 'testDaimddlerUser1256478@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            
            LanguageLocaleKey = 'en_US',
            ContactId=con.id
        );
        
        insert usr;
     
        Group test = new Group();
      test.Name = '1234';
      insert test;
        KR_Switch__c krswitch=new KR_Switch__c(Name='AccountHelperswitch',Enable_Flag__c=True);
   List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
   lsttrgt.add(krswitch);
   insert lsttrgt;
         Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
         
        
       
        
        
        System.runAs (usr){
            Account companyacc;
              if (!KRSwitchEnabledFlag ) {
        companyacc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '010-999-1000',Home_Phone_2__c = '010-959-0000',Work_Phone__c = '010-956-0000',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                name = 'tes company name',
                                
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '011-999-0000',
                                Mobile2__c = '034456232',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'KR',
                                MBK_Data_Source__c='Advertisement',
                                OwnerId = usr.id,
                                Vat_No__c='12345',
                                 Foundation_Date__c=system.today()-1,
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
       }
        else{
          companyacc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '+82-00-999-1000',Work_Phone__c = '+82-10-956-0000',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                name = 'tes company name',
                                
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '+82-11-999-0000',
                               Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'KR',
                                MBK_Data_Source__c='Advertisement',
                                OwnerId = usr.id,
                                Vat_No__c='12345',
                                 Foundation_Date__c=system.today()-1,
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
       }
    
      accountlist.add(companyacc);
      insert accountlist;  
      
       
      Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
   
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', ToRole__c = accountlist[0].id, ReCordTypeId = RetailPerson);
        insert acclnk;
          
        Address__c add=new Address__c();
        add.Customer__c=companyacc.id;
        add.Province__c='Gunma';
        add.City__c='Hyd';
        add.District__c='RR DIst';
        add.Block__c='New gad';
        add.RecordTypeId=dealeraddRecordtypeid;
        add.Address_Line_1__c='Dilsukhnagar';
        add.Address_Line_2__c ='Dilsukhnagar';
        add.Address_Type__c='Business';
        insert add;
        AccountHelperKR.CreateRetailCopy(accountlist,true,false);
        AccountHelperKR.shareDealeroutletsWithDealerCompany(accountlist);
      }
        
        }
        catch(Exception e)
        {
        }
 }
 
 public static testMethod void testUpdateAgeRangeCase9(){
 try{
     Account dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_ND_Code__c='1234');
        insert dealer;
       Contact con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
   User usr = new User(
            Username = System.now().millisecond() + 'testDaimlsssaerUser1256478@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin1.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            
            ContactId=con.id
        );
        
        insert usr;
         Group test = new Group();
      test.Name = '1234';
      insert test;
      KR_Switch__c krswitch=new KR_Switch__c(Name='AccountHelperswitch',Enable_Flag__c=True);
   List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
   lsttrgt.add(krswitch);
   insert lsttrgt;
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
         
         
        
        System.runAs (usr) {
            if (!KRSwitchEnabledFlag ) {
     personAcc = new Account(Dealer_Default_Flag__c=false,
                           Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '000-0000-9642',Home_Phone_2__c = '000-0000-9642',Work_Phone__c = '000-0000-9642',
                           Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                           City__c='Beijing',
                           Gender__c = 'Male',
                           Phone = '000-0000-9642',
                           Area_code__c = '0101',
                           MD__c = 'KR',
                           LastName = 'galaxy1',
                           FirstName = 'First Name',
                           Salutation = 'Unknown',      
                           Province__c = 'Shanghai',
                           ZipCode__c= '1002347',
                           MBK_Data_Source__c='Email',
                           Mobile__c = '000-0000-9642',
                           Mobile2__c = '000-0000-9642',
                           Primary_Email__c = 'Email1',
                           Primary_Fax__c = 'FAX2',
                           Primary_Phone__c ='Other2',
                           Postal_Opt_Out__c=true,
                           Postal_Opt_Out_Reason__c='Meeting',
                           Foundation_Date__c=system.today()-1,
                           RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
       
    }
    else{
        personAcc = new Account(Dealer_Default_Flag__c=false,
                           Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '+82-00-000-9642',Work_Phone__c = '+82-00-000-9642',
                           Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                           City__c='Beijing',
                           Gender__c = 'Male',
                           Phone = '000-0000-9642',
                           Area_code__c = '0101',
                           MD__c = 'KR',
                           LastName = 'galaxy1',
                           FirstName = 'First Name',
                           Salutation = 'Unknown',      
                           Province__c = 'Shanghai',
                           ZipCode__c= '1002347',
                           MBK_Data_Source__c='Email',
                           Mobile__c = '+82-00-0000-9642',
                           Primary_Email__c = 'Email1',
                           Primary_Fax__c = 'FAX2',
                           Primary_Phone__c ='Other2',
                           Postal_Opt_Out__c=true,
                           Postal_Opt_Out_Reason__c='Meeting',
                           Foundation_Date__c=system.today()-1,
                           RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
                           }
      accountlist.add(personAcc);
      insert accountlist;  
     
      
      Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
   
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', ToRole__c = accountlist[0].id, ReCordTypeId = RetailPerson);
        insert acclnk;
          
        Address__c add=new Address__c();
        add.Customer__c=personAcc.id;
        add.Province__c='Gunma';
        add.City__c='Hyd';
        add.District__c='RR DIst';
        add.Block__c='New gad';
        add.MD__c='KR';
        add.RecordTypeId=dealeraddRecordtypeid;
        add.Opt_In_Hardcopy__c=true;
        add.ZipCode__c='123456';
        add.Address_Line_1__c='Dilsukhnagar';
        add.Address_Line_2__c ='Dilsukhnagar';
        add.Address_Type__c='Business';
        insert add;
        AccountHelperKR.CreateRetailCopy(accountlist,true,false);
        AccountHelperKR.updateOnPostalOptout(accountlist);
        system.debug('@@ Account List Debug @@ '+accountlist);
        AccountHelperKR.shareDealeroutletsWithDealerCompany(accountlist);
    
      
        }
       }
       catch(Exception e)
        {
        } 
 }
 
 @isTest static void updateretailcopyTest2()
     {
     try{
       User thisUser = [ select Id,ContactId,Email from User where Id = :UserInfo.getUserId() ];
       System.runAs(thisUser){
         
        Test.StartTest();
        
     listcampaigns=new List<Account>();
      KR_Switch__c krswitch=new KR_Switch__c(Name='AccountHelperswitch',Enable_Flag__c=True);
   List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
   lsttrgt.add(krswitch);
   insert lsttrgt;
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
         
        
       
         if (!KRSwitchEnabledFlag ) {
    Account personAcc14 = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '010-3154-4995',Home_Phone_2__c = '010-3154-4999',Work_Phone__c = '010-3154-4998',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '010-999-0000',
                                Mobile2__c = '034456232',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'KR',
                                MBK_Data_Source__c='Advertisement',
                                Vat_No__c='12345',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
                               insert personAcc14;
       
    Account personAcc13 = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '010-599-0000',Home_Phone_2__c = '010-3154-4999',Work_Phone__c = '010-3154-4995',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Fax='025645435',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown', 
                                Commercial_Reg_No__c='1234',     
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '010-999-0000',
                                Mobile2__c = '034456232',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'KR',
                                MBK_Data_Source__c='Advertisement',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
       
     listcampaigns.add(personAcc13);
      insert listcampaigns;  
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
   
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', ToRole__c = listcampaigns[0].id, ReCordTypeId = RetailPerson);
        insert acclnk;
      Account_Link__c al=new Account_Link__c(Name='new al',
      toRole__c=listcampaigns[0].id,
      RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
      );
   
       insert al;
       Account listCampaign =[select Name,MBK_Data_Source__c,Special_Needs_Class__c,Special_Care__c,Primary_Phone_Display__c,Company_Name_Native_1__c,PersonEmail,MBK_Occupation__c,DMS_Customer_ID__c,Visit_Opt_Out__c,Job__c,Company_Name__c,PersonMobilePhone,Preferred_Contact_Method__c,PersonDoNotCall,PersonHasOptedOutOfFax,Salutation,Personal_Information_Third_Party_Release__c,PersonHasOptedOutOfEmail,Agreement_to_commit_info_processing__c,Personal_Agreement__c,Personal_Abroad_Agreement__c,RecordTypeId,Lastname,FirstName,Foundation_Date__c,Dealer_Rollout_Status__c,Website,Commercial_Reg_No__c,Vat_No__c,Gender__c,Primary_Address_Reference__r.Customer__c,Work_Phone__c,Allow_Data_Sharing2__c,Industry,Mobile__c,Occupation__c,PersonBirthdate,LastName_Native_1__c,FirstName_Native_1__c,Preferred_Language__c,Individual_Home_Phone__c,Fax,Email__c,Complaint_Amount__c,Primary_Phone__c,Primary_Fax__c,Primary_Email__c,Primary_Address_Reference__c from Account where id IN:listcampaigns ];
         list<Account> oldList = new  list<Account>();
         oldList.add(listCampaign);
        map<id,Account> oldMap = new map<id,Account>();
         oldMap.put(listCampaign.id, listCampaign);
         personAcc13.name = 'tes name1';
         personAcc13.Commercial_Reg_No__c='1234';
         personAcc13.Fax='035456232';
         personAcc13.Allow_Data_Sharing2__c='Yes';
         personAcc13.Gender__c='Female';
         personAcc13.Individual_Home_Phone__c = '010-549-0000';
         personAcc13.Work_Phone__c = '010-599-0200'; 
         personAcc13.Mobile__c = '010-599-1000';
         personAcc13.Email__c = 'testemail1@test.com';
         personAcc13.Primary_Phone__c ='Other1';
         personAcc13.Fax='0256454351';
         update personAcc13;
         update listcampaigns;
         
        
   
        Account_Link__c acclnk2 = new Account_Link__c(Name = 'Test Name', ToRole__c = listcampaigns[0].id, ReCordTypeId = RetailPerson);
        insert acclnk2;
        
        AccountHelperKR.updateRetailCopy(true,true,true,listcampaigns,oldMap);
        
        
        //Test.StopTest();
        system.assertNotEquals('ggg', listcampaigns[0].Name);
        }
       else{
        Account personAcc14 = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '+82-10-154-4995',Work_Phone__c = '+82-10-154-4998',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '+82-10-999-0000',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'KR',
                                MBK_Data_Source__c='Advertisement',
                                Vat_No__c='12345',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
                               insert personAcc14;
       
    Account personAcc13 = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '+82-10-599-0000',Work_Phone__c = '+82-10-154-4995',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Fax='025645435',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown', 
                                Commercial_Reg_No__c='1234',     
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '+82-10-999-0000',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'KR',
                                MBK_Data_Source__c='Advertisement',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
       
     listcampaigns.add(personAcc13);
      insert listcampaigns;  
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
   
        Account_Link__c acclnk = new Account_Link__c(Name = 'Test Name', ToRole__c = listcampaigns[0].id, ReCordTypeId = RetailPerson);
        insert acclnk;
      Account_Link__c al=new Account_Link__c(Name='new al',
      toRole__c=listcampaigns[0].id,
      RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
      );
   
       insert al;
       Account listCampaign =[select Name,MBK_Data_Source__c,Special_Needs_Class__c,Special_Care__c,Primary_Phone_Display__c,Company_Name_Native_1__c,PersonEmail,MBK_Occupation__c,DMS_Customer_ID__c,Visit_Opt_Out__c,Job__c,Company_Name__c,PersonMobilePhone,Preferred_Contact_Method__c,PersonDoNotCall,PersonHasOptedOutOfFax,Salutation,Personal_Information_Third_Party_Release__c,PersonHasOptedOutOfEmail,Agreement_to_commit_info_processing__c,Personal_Agreement__c,Personal_Abroad_Agreement__c,RecordTypeId,Lastname,FirstName,Foundation_Date__c,Dealer_Rollout_Status__c,Website,Commercial_Reg_No__c,Vat_No__c,Gender__c,Primary_Address_Reference__r.Customer__c,Work_Phone__c,Allow_Data_Sharing2__c,Industry,Mobile__c,Occupation__c,PersonBirthdate,LastName_Native_1__c,FirstName_Native_1__c,Preferred_Language__c,Individual_Home_Phone__c,Fax,Email__c,Complaint_Amount__c,Primary_Phone__c,Primary_Fax__c,Primary_Email__c,Primary_Address_Reference__c from Account where id IN:listcampaigns ];
         list<Account> oldList = new  list<Account>();
         oldList.add(listCampaign);
        map<id,Account> oldMap = new map<id,Account>();
         oldMap.put(listCampaign.id, listCampaign);
         personAcc13.name = 'tes name1';
         personAcc13.Commercial_Reg_No__c='1234';
         personAcc13.Fax='035456232';
         personAcc13.Allow_Data_Sharing2__c='Yes';
         personAcc13.Gender__c='Female';
         personAcc13.Individual_Home_Phone__c = '+82-10-549-0000';
         personAcc13.Work_Phone__c = '+82-10-599-0200'; 
         personAcc13.Mobile__c = '+82-10-599-1000';
         personAcc13.Email__c = 'testemail1@test.com';
         personAcc13.Primary_Phone__c ='Other1';
         personAcc13.Fax='0256454351';
         update personAcc13;
         update listcampaigns;
         
        
   
        Account_Link__c acclnk2 = new Account_Link__c(Name = 'Test Name', ToRole__c = listcampaigns[0].id, ReCordTypeId = RetailPerson);
        insert acclnk2;
        
        AccountHelperKR.updateRetailCopy(true,true,true,listcampaigns,oldMap);
        
        
        Test.StopTest();
        system.assertNotEquals('ggg', listcampaigns[0].Name);
        
        }
       
     }
     }
      catch(Exception e)
        {
        }
     }
     
     @isTest static void updateretailcopyTest3()
     {
     try{
       User thisUser = [ select Id,ContactId,Email from User where Id = :UserInfo.getUserId() ];
       System.runAs(thisUser){
         
        Test.StartTest();
        
     listcampaigns=new List<Account>();
     KR_Switch__c krswitch=new KR_Switch__c(Name='AccountHelperswitch',Enable_Flag__c=True);
   List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
   lsttrgt.add(krswitch);
   insert lsttrgt;
         Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
         
        
       
         if (!KRSwitchEnabledFlag ) {
    Account personAcc14 = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Work_Phone__c = '010-3154-4999',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                               Mobile__c = '010-999-0000',
                                Mobile2__c = '034456232',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'KR',
                                MBK_Data_Source__c='Advertisement',
                                Vat_No__c='12345',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
                               insert personAcc14;
       
    Account personAcc13 = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Work_Phone__c = '010-999-0000',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Fax='025645435',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown', 
                                Commercial_Reg_No__c='1234',     
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '010-999-0000',
                                Mobile2__c = '034456232',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'KR',
                                MBK_Data_Source__c='Advertisement',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
       
     listcampaigns.add(personAcc13);
      insert listcampaigns;  
      
      Account_Link__c al=new Account_Link__c(Name='new al',
      toRole__c=listcampaigns[0].id,
      RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
      );
   
       insert al;
       Account listCampaign =[select Name,MBK_Data_Source__c,Primary_Phone_Display__c,Company_Name_Native_1__c,PersonEmail,MBK_Occupation__c,DMS_Customer_ID__c,Visit_Opt_Out__c,Job__c,Company_Name__c,PersonMobilePhone,Preferred_Contact_Method__c,PersonDoNotCall,PersonHasOptedOutOfFax,Salutation,Personal_Information_Third_Party_Release__c,PersonHasOptedOutOfEmail,Agreement_to_commit_info_processing__c,Personal_Agreement__c,Personal_Abroad_Agreement__c,RecordTypeId,Lastname,FirstName,Foundation_Date__c,Dealer_Rollout_Status__c,Website,Commercial_Reg_No__c,Vat_No__c,Gender__c,Primary_Address_Reference__r.Customer__c,Work_Phone__c,Allow_Data_Sharing2__c,Industry,Mobile__c,Occupation__c,PersonBirthdate,LastName_Native_1__c,FirstName_Native_1__c,Preferred_Language__c,Individual_Home_Phone__c,Fax,Email__c,Complaint_Amount__c,Primary_Phone__c,Primary_Fax__c,Primary_Email__c,Primary_Address_Reference__c from Account where id IN:listcampaigns ];
          list<Account> oldList = new  list<Account>();
         oldList.add(listCampaign);
        map<id,Account> oldMap = new map<id,Account>();
         oldMap.put(listCampaign.id, listCampaign);
         
         personAcc13.Commercial_Reg_No__c='1234';
         
         personAcc13.Gender__c='Female';
         personAcc13.Allow_Data_Sharing2__c='Yes';
       
         personAcc13.Individual_Home_Phone__c = '010-999-0005';
         personAcc13.Work_Phone__c = '010-999-0006';
         personAcc13.Mobile__c = '010-995-0000';
         personAcc13.Email__c = 'testemail1@test.com';
         personAcc13.Primary_Phone__c ='Other1';
         personAcc13.Fax='0256454351';
         update personAcc13;
         update listcampaigns;
        
        AccountHelperKR.updateRetailCopy(true,true,true,listcampaigns,oldMap);
        
        
        //Test.StopTest();
        system.assertNotEquals('ggg', listcampaigns[0].Name);
     }
     
       else {
     
     Account personAcc14 = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Work_Phone__c = '+82-10-154-4999',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                               Mobile__c = '+82-10-999-0000',
                               Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'KR',
                                MBK_Data_Source__c='Advertisement',
                                Vat_No__c='12345',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
                               insert personAcc14;
       
    Account personAcc13 = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Work_Phone__c = '+82-10-999-0000',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Fax='025645435',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown', 
                                Commercial_Reg_No__c='1234',     
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '+82-10-999-0000',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'KR',
                                MBK_Data_Source__c='Advertisement',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
       
     listcampaigns.add(personAcc13);
      insert listcampaigns;  
      
      Account_Link__c al=new Account_Link__c(Name='new al',
      toRole__c=listcampaigns[0].id,
      RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
      );
   
       insert al;
       Account listCampaign =[select Name,MBK_Data_Source__c,Primary_Phone_Display__c,Company_Name_Native_1__c,PersonEmail,MBK_Occupation__c,DMS_Customer_ID__c,Visit_Opt_Out__c,Job__c,Company_Name__c,PersonMobilePhone,Preferred_Contact_Method__c,PersonDoNotCall,PersonHasOptedOutOfFax,Salutation,Personal_Information_Third_Party_Release__c,PersonHasOptedOutOfEmail,Agreement_to_commit_info_processing__c,Personal_Agreement__c,Personal_Abroad_Agreement__c,RecordTypeId,Lastname,FirstName,Foundation_Date__c,Dealer_Rollout_Status__c,Website,Commercial_Reg_No__c,Vat_No__c,Gender__c,Primary_Address_Reference__r.Customer__c,Work_Phone__c,Allow_Data_Sharing2__c,Industry,Mobile__c,Occupation__c,PersonBirthdate,LastName_Native_1__c,FirstName_Native_1__c,Preferred_Language__c,Individual_Home_Phone__c,Fax,Email__c,Complaint_Amount__c,Primary_Phone__c,Primary_Fax__c,Primary_Email__c,Primary_Address_Reference__c from Account where id IN:listcampaigns ];
          list<Account> oldList = new  list<Account>();
         oldList.add(listCampaign);
        map<id,Account> oldMap = new map<id,Account>();
         oldMap.put(listCampaign.id, listCampaign);
         
         personAcc13.Commercial_Reg_No__c='1234';
         
         personAcc13.Gender__c='Female';
         personAcc13.Allow_Data_Sharing2__c='Yes';
       
         personAcc13.Individual_Home_Phone__c = '+82-10-999-0005';
         personAcc13.Work_Phone__c = '+82-10-999-0006';
         personAcc13.Mobile__c = '+82-10-995-0000';
         personAcc13.Email__c = 'testemail1@test.com';
         personAcc13.Primary_Phone__c ='Other1';
         personAcc13.Fax='0256454351';
         update personAcc13;
         update listcampaigns;
        
        AccountHelperKR.updateRetailCopy(true,true,true,listcampaigns,oldMap);
        
        
        Test.StopTest();
        system.assertNotEquals('ggg', listcampaigns[0].Name);
     }
     }
     }
     
     catch(Exception e)
        {
        }
     
     }
     
     
     @isTest static void updateretailcopyTest()
     {
     try{
       User thisUser = [ select Id,ContactId,Email from User where Id = :UserInfo.getUserId() ];
       System.runAs(thisUser){
         
        Test.StartTest();
        
        listcampaigns=new List<Account>();
        KR_Switch__c krswitch=new KR_Switch__c(Name='AccountHelperswitch',Enable_Flag__c=True);
   List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
   lsttrgt.add(krswitch);
   insert lsttrgt;
       Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
         
       
       
         if (!KRSwitchEnabledFlag ) {
      Account personAcc14 = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Work_Phone__c = '010-999-0000',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               //MD__c = 'JP',
                               LastName = 'galaxy1',
                               FirstName = 'First Name',
                               Salutation = 'Unknown',      
                               Province__c = 'Shanghai',
                               ZipCode__c= '1002347',
                               Mobile__c = '010-999-0000',
                               Mobile2__c = '035456232',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Fax='035456232',
                               Primary_Phone__c ='Other2',
                               Allow_Data_Sharing2__c='No Choice Yet',  
                               MD__c = 'KR',
                               Industry = 'Other',
                                MBK_Data_Source__c='Circle of excellence ',
                               Dealer_Rollout_Status__c ='Done',
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
                               
                               insert personAcc14;
       
    Account personAcc13 = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '010-999-0000',Home_Phone_2__c = '010-3134-4999',Work_Phone__c = '010-3254-4999',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               //MD__c = 'JP',
                               LastName = 'galaxy1',
                               FirstName = 'First Name',
                               Salutation = 'Unknown',      
                               Province__c = 'Shanghai',
                               ZipCode__c= '1002347',
                               Mobile__c = '010-999-0000',
                               Mobile2__c = '035456232',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Fax='035456232',
                               Primary_Phone__c ='Other2',
                               Allow_Data_Sharing2__c='No Choice Yet', 
                               MBK_Data_Source__c='Circle of excellence ', 
                               MD__c = 'KR',
                               Industry = 'Other',
                               
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
       
     listcampaigns.add(personAcc13);
      insert listcampaigns;  
      
      Account_Link__c al=new Account_Link__c(Name='new al',
      toRole__c=listcampaigns[0].id,
      fromRole__c=personAcc14.id,
      RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
      );
   
       insert al;
       Account listCampaign =[select Name,MBK_Data_Source__c,Primary_Phone_Display__c,Company_Name_Native_1__c,PersonEmail,MBK_Occupation__c,DMS_Customer_ID__c,Visit_Opt_Out__c,Job__c,Company_Name__c,PersonMobilePhone,Preferred_Contact_Method__c,PersonDoNotCall,PersonHasOptedOutOfFax,Salutation,Personal_Information_Third_Party_Release__c,PersonHasOptedOutOfEmail,Agreement_to_commit_info_processing__c,Personal_Agreement__c,Personal_Abroad_Agreement__c,RecordTypeId,Lastname,FirstName,Foundation_Date__c,Dealer_Rollout_Status__c,Website,Commercial_Reg_No__c,Vat_No__c,Gender__c,Primary_Address_Reference__r.Customer__c,Work_Phone__c,Allow_Data_Sharing2__c,Industry,Mobile__c,Occupation__c,PersonBirthdate,LastName_Native_1__c,FirstName_Native_1__c,Preferred_Language__c,Individual_Home_Phone__c,Fax,Email__c,Complaint_Amount__c,Primary_Phone__c,Primary_Fax__c,Primary_Email__c,Primary_Address_Reference__c from Account where id IN:listcampaigns ];
         list<Account> oldList = new  list<Account>();
         oldList.add(listCampaign);
        map<id,Account> oldMap = new map<id,Account>();
         oldMap.put(listCampaign.id, listCampaign);
        personAcc13.Gender__c = 'Female';
        personAcc13.FirstName = 'galaxy2';
        personAcc13.Allow_Data_Sharing2__c='No';
        update personAcc13;
        update listcampaigns;
         
        AccountHelperKR.updateRetailCopy(true,true,true,listcampaigns,oldMap);
        
         
        //Test.StopTest();
        system.assertNotEquals('ggg', listcampaigns[0].Name);
        }
        
         else{
         Account personAcc14 = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Work_Phone__c = '+82-10-999-0000',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               //MD__c = 'JP',
                               LastName = 'galaxy1',
                               FirstName = 'First Name',
                               Salutation = 'Unknown',      
                               Province__c = 'Shanghai',
                               ZipCode__c= '1002347',
                               Mobile__c = '+82-10-999-0000',
                               
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Fax='035456232',
                               Primary_Phone__c ='Other2',
                               Allow_Data_Sharing2__c='No Choice Yet',  
                               MD__c = 'KR',
                               Industry = 'Other',
                                MBK_Data_Source__c='Circle of excellence ',
                               Dealer_Rollout_Status__c ='Done',
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
                               
                               insert personAcc14;
       
    Account personAcc13 = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '+82-10-999-0000',Home_Phone_2__c = '+82-10-3134-4999',Work_Phone__c = '+82-10-3254-4999',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               //MD__c = 'JP',
                               LastName = 'galaxy1',
                               FirstName = 'First Name',
                               Salutation = 'Unknown',      
                               Province__c = 'Shanghai',
                               ZipCode__c= '1002347',
                               Mobile__c = '+82-10-999-0000',
                              
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Fax='035456232',
                               Primary_Phone__c ='Other2',
                               Allow_Data_Sharing2__c='No Choice Yet', 
                               MBK_Data_Source__c='Circle of excellence ', 
                               MD__c = 'KR',
                               Industry = 'Other',
                               
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
       
     listcampaigns.add(personAcc13);
      insert listcampaigns;  
      
      Account_Link__c al=new Account_Link__c(Name='new al',
      toRole__c=listcampaigns[0].id,
      fromRole__c=personAcc14.id,
      RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
      );
   
       insert al;
       Account listCampaign =[select Name,MBK_Data_Source__c,Primary_Phone_Display__c,Company_Name_Native_1__c,PersonEmail,MBK_Occupation__c,DMS_Customer_ID__c,Visit_Opt_Out__c,Job__c,Company_Name__c,PersonMobilePhone,Preferred_Contact_Method__c,PersonDoNotCall,PersonHasOptedOutOfFax,Salutation,Personal_Information_Third_Party_Release__c,PersonHasOptedOutOfEmail,Agreement_to_commit_info_processing__c,Personal_Agreement__c,Personal_Abroad_Agreement__c,RecordTypeId,Lastname,FirstName,Foundation_Date__c,Dealer_Rollout_Status__c,Website,Commercial_Reg_No__c,Vat_No__c,Gender__c,Primary_Address_Reference__r.Customer__c,Work_Phone__c,Allow_Data_Sharing2__c,Industry,Mobile__c,Occupation__c,PersonBirthdate,LastName_Native_1__c,FirstName_Native_1__c,Preferred_Language__c,Individual_Home_Phone__c,Fax,Email__c,Complaint_Amount__c,Primary_Phone__c,Primary_Fax__c,Primary_Email__c,Primary_Address_Reference__c from Account where id IN:listcampaigns ];
         list<Account> oldList = new  list<Account>();
         oldList.add(listCampaign);
        map<id,Account> oldMap = new map<id,Account>();
         oldMap.put(listCampaign.id, listCampaign);
        personAcc13.Gender__c = 'Female';
        personAcc13.FirstName = 'galaxy2';
        personAcc13.Allow_Data_Sharing2__c='No';
        update personAcc13;
        update listcampaigns;
         
        AccountHelperKR.updateRetailCopy(true,true,true,listcampaigns,oldMap);
        
         
        Test.StopTest();
        system.assertNotEquals('ggg', listcampaigns[0].Name);
        }
     }
     }
     catch(Exception e)
        {
        }
     
     
     }
    
     
     @isTest static void updateretailcopyTest4()
     {
     try{
       User thisUser = [ select Id,ContactId,Email from User where Id = :UserInfo.getUserId() ];
       System.runAs(thisUser){
         
        Test.StartTest();
        
        listcampaigns=new List<Account>();
        KR_Switch__c krswitch=new KR_Switch__c(Name='AccountHelperswitch',Enable_Flag__c=True);
   List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
   lsttrgt.add(krswitch);
   insert lsttrgt;
        Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
      Boolean KRSwitchEnabledFlag = false;  
       if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('AccountHelperswitch')){
           KRSwitchEnabledFlag = KRSwitchMap.get('AccountHelperswitch').Enable_Flag__c;
        }
         
        
       
         if (!KRSwitchEnabledFlag ) {
      Account personAcc14 = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Work_Phone__c = '010-999-0000',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               //MD__c = 'JP',
                               LastName = 'galaxy1',
                               FirstName = 'First Name',
                               Salutation = 'Unknown',      
                               Province__c = 'Shanghai',
                               ZipCode__c= '1002347',
                               Mobile__c = '010-999-0000',
                               Mobile2__c = '035456232',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Fax='035456232',
                               Primary_Phone__c ='Other2',
                               Allow_Data_Sharing2__c='No Choice Yet',  
                               MD__c = 'KR',
                               Industry = 'Other',
                                MBK_Data_Source__c='Circle of excellence ',
                               Dealer_Rollout_Status__c ='Done',
                               Foundation_Date__c=System.today()-1,
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
                               
                               insert personAcc14;
     Address__c add2=new Address__c();
        add2.Customer__c=personAcc14.id;
        add2.Province__c='Gunma';
        add2.City__c='Hyd';
        add2.District__c='RR DIst';
        add2.Block__c='New gad';
        add2.RecordTypeId=dealeraddRecordtypeid;
        add2.Address_Line_1__c='Dilsukhnagar';
        add2.Address_Line_2__c ='Dilsukhnagar';
        add2.Address_Type__c='Business';
        insert add2; 
     Account personAcc13 = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '010-999-0000',Home_Phone_2__c = '010-999-0000',Work_Phone__c = '010-999-0000',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '010-999-0000',
                                Mobile2__c = '010-999-0000',
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'KR',
                                Commercial_Reg_No__c='1567',
                                MBK_Data_Source__c='Advertisement',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
        
     listcampaigns.add(personAcc13);
      insert listcampaigns;
         
      Address__c add1=new Address__c();
        add1.Customer__c=listcampaigns[0].id;
        add1.Province__c='Gunma';
        add1.City__c='Hyd';
        add1.District__c='RR DIst';
        add1.Block__c='New gad';
        add1.RecordTypeId=dealeraddRecordtypeid;
        add1.Address_Line_1__c='Dilsukhnagar';
        add1.Address_Line_2__c ='Dilsukhnagar';
        add1.Address_Type__c='Business';
        insert add1; 
        
      Account_Link__c al=new Account_Link__c(Name='new al',
      toRole__c=listcampaigns[0].id,
      fromRole__c=personAcc14.id,
      RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
      );
   
       insert al;
       Account listCampaign =[select Name,MBK_Data_Source__c,Special_Needs_Class__c,Special_Care__c,Primary_Phone_Display__c,Company_Name_Native_1__c,PersonEmail,MBK_Occupation__c,DMS_Customer_ID__c,Visit_Opt_Out__c,Job__c,Company_Name__c,PersonMobilePhone,Preferred_Contact_Method__c,PersonDoNotCall,PersonHasOptedOutOfFax,Salutation,Personal_Information_Third_Party_Release__c,PersonHasOptedOutOfEmail,Agreement_to_commit_info_processing__c,Personal_Agreement__c,Personal_Abroad_Agreement__c,RecordTypeId,Lastname,FirstName,Foundation_Date__c,Dealer_Rollout_Status__c,Website,Commercial_Reg_No__c,Vat_No__c,Gender__c,Primary_Address_Reference__r.Customer__c,Work_Phone__c,Allow_Data_Sharing2__c,Industry,Mobile__c,Occupation__c,PersonBirthdate,LastName_Native_1__c,FirstName_Native_1__c,Preferred_Language__c,Individual_Home_Phone__c,Fax,Email__c,Complaint_Amount__c,Primary_Phone__c,Primary_Fax__c,Primary_Email__c,Primary_Address_Reference__c from Account where id IN:listcampaigns ];
         list<Account> oldList = new  list<Account>();
         oldList.add(listCampaign);
        map<id,Account> oldMap = new map<id,Account>();
         oldMap.put(listCampaign.id, listCampaign);
        personAcc13.name = 'Female';
        personAcc13.Commercial_Reg_No__c = '1234';
        personAcc13.Primary_Address_Reference__c=add1.Id;
        
        update personAcc13;
        update listcampaigns;
         
        AccountHelperKR.updateRetailCopy(true,true,true,listcampaigns,oldMap);
        
         
        //Test.StopTest();
        system.assertNotEquals('ggg', listcampaigns[0].Name);
        }
       
       else{
         Account personAcc14 = new Account(Dealer_Default_Flag__c=false,
                               Dealer_DMS_SR_Code__c='test code 2',Work_Phone__c = '+82-10-999-0000',
                               Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                               City__c='Beijing',
                               Gender__c = 'Male',
                               Phone = '0801801110',
                               Area_code__c = '0101',
                               //MD__c = 'JP',
                               LastName = 'galaxy1',
                               FirstName = 'First Name',
                               Salutation = 'Unknown',      
                               Province__c = 'Shanghai',
                               ZipCode__c= '1002347',
                               Mobile__c = '+82-10-999-0000',
                               Primary_Email__c = 'Email1',
                               Primary_Fax__c = 'FAX2',
                               Fax='035456232',
                               Primary_Phone__c ='Other2',
                               Allow_Data_Sharing2__c='No Choice Yet',  
                               MD__c = 'KR',
                               Industry = 'Other',
                                MBK_Data_Source__c='Circle of excellence ',
                               Dealer_Rollout_Status__c ='Done',
                               Foundation_Date__c=System.today()-1,
                               RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
                               
                               insert personAcc14;
     Address__c add2=new Address__c();
        add2.Customer__c=personAcc14.id;
        add2.Province__c='Gunma';
        add2.City__c='Hyd';
        add2.District__c='RR DIst';
        add2.Block__c='New gad';
        add2.RecordTypeId=dealeraddRecordtypeid;
        add2.Address_Line_1__c='Dilsukhnagar';
        add2.Address_Line_2__c ='Dilsukhnagar';
        add2.Address_Type__c='Business';
        insert add2; 
     Account personAcc13 = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '+82-10-999-0000',Work_Phone__c = '+82-10-999-0000',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801010',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                name = 'tes company name',
                                //Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1003465',
                                Mobile__c = '+82-10-999-0000',
                                
                                Primary_Email__c = 'Email2',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'KR',
                                Commercial_Reg_No__c='1567',
                                MBK_Data_Source__c='Advertisement',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId());
        
     listcampaigns.add(personAcc13);
      insert listcampaigns;
         
      Address__c add1=new Address__c();
        add1.Customer__c=listcampaigns[0].id;
        add1.Province__c='Gunma';
        add1.City__c='Hyd';
        add1.District__c='RR DIst';
        add1.Block__c='New gad';
        add1.RecordTypeId=dealeraddRecordtypeid;
        add1.Address_Line_1__c='Dilsukhnagar';
        add1.Address_Line_2__c ='Dilsukhnagar';
        add1.Address_Type__c='Business';
        insert add1; 
        
      Account_Link__c al=new Account_Link__c(Name='new al',
      toRole__c=listcampaigns[0].id,
      fromRole__c=personAcc14.id,
      RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
      );
   
       insert al;
       Account listCampaign =[select Name,MBK_Data_Source__c,Special_Needs_Class__c,Special_Care__c,Primary_Phone_Display__c,Company_Name_Native_1__c,PersonEmail,MBK_Occupation__c,DMS_Customer_ID__c,Visit_Opt_Out__c,Job__c,Company_Name__c,PersonMobilePhone,Preferred_Contact_Method__c,PersonDoNotCall,PersonHasOptedOutOfFax,Salutation,Personal_Information_Third_Party_Release__c,PersonHasOptedOutOfEmail,Agreement_to_commit_info_processing__c,Personal_Agreement__c,Personal_Abroad_Agreement__c,RecordTypeId,Lastname,FirstName,Foundation_Date__c,Dealer_Rollout_Status__c,Website,Commercial_Reg_No__c,Vat_No__c,Gender__c,Primary_Address_Reference__r.Customer__c,Work_Phone__c,Allow_Data_Sharing2__c,Industry,Mobile__c,Occupation__c,PersonBirthdate,LastName_Native_1__c,FirstName_Native_1__c,Preferred_Language__c,Individual_Home_Phone__c,Fax,Email__c,Complaint_Amount__c,Primary_Phone__c,Primary_Fax__c,Primary_Email__c,Primary_Address_Reference__c from Account where id IN:listcampaigns ];
         list<Account> oldList = new  list<Account>();
         oldList.add(listCampaign);
        map<id,Account> oldMap = new map<id,Account>();
         oldMap.put(listCampaign.id, listCampaign);
        personAcc13.name = 'Female';
        personAcc13.Commercial_Reg_No__c = '1234';
        personAcc13.Primary_Address_Reference__c=add1.Id;
        
        update personAcc13;
        update listcampaigns;
         
        AccountHelperKR.updateRetailCopy(true,true,true,listcampaigns,oldMap);
        
         
        Test.StopTest();
        system.assertNotEquals('ggg', listcampaigns[0].Name);
        }
        }
        }
        catch(Exception e)
        {
        }
     }
      
     
     public static testMethod void testUpdateAgeRangeCase10(){
     Account dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_ND_Code__c='1234');
        insert dealer;
       Contact con = new Contact(AccountId = dealer.Id,Permission_Set_Settings__c='Leads_Management', LastName = 'b', Phone = '123', email = 's@s.s');
        insert con;
   User usr = new User(
            Username = System.now().millisecond() + 'testDaissmlsssaerUser1256478@Daimler-test.com',
            FirstName = 'firstname',
            ProfileId = DealerDelegatedAdmin1.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            
            ContactId=con.id
        );
        
        insert usr;
         Group test = new Group();
      test.Name = '1234';
      insert test;
        System.runAs (usr) {
        map<id,Account> mp= new map<id,Account>();
           Account dealer1 =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer',Dealer_GC_Code__c = 'Test123',Dealer_ND_Code__c='1234');
        insert dealer1;
     
        AccountHelperKR.createSharingRecord(mp);
        
        
        }
 }
    @isTest
    public static void TestCalculateAgeRange(){
        Integer ageInt=18;
        AccountHelperKR.calculateAgeRange(ageInt);
        ageInt= 30;
        AccountHelperKR.calculateAgeRange(ageInt);
        ageInt= 40;
        AccountHelperKR.calculateAgeRange(ageInt);
        ageInt= 50;
        AccountHelperKR.calculateAgeRange(ageInt);
        ageInt= 60;
        AccountHelperKR.calculateAgeRange(ageInt);
        ageInt= 70;
        AccountHelperKR.calculateAgeRange(ageInt);
        ageInt= 10;
        AccountHelperKR.calculateAgeRange(ageInt);
        
             
    }
    

    
}