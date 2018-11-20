/**
* Test class for TriggerAccountTriggerHandlerKR
* Author : Chethan A
* Created date : 23-AUG-2016
*/

@isTest
public class TriggerAccountTriggerHandlerKRTest {
    public static User user_Obj; 
    public static User intgnuser_Obj;
    
    
    public static void prepareTestData(String case1){
        UserRole portalRole1 = [Select Id From UserRole Where name='Call Center' Limit 1];           
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        User user_Obj1 = new User(Alias = 'standt', Email='testUser@testorg.com',
                                  EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',UserRoleId = portalRole1.Id, 
                                  LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='KR',
                                  TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true); 
        system.runas(user_Obj1){    
            Trigger__c TriggerAccountKR = new Trigger__c(Name='TriggerAccountKR',Trigger_Name__c='TriggerAccount',Trigger_Handler__c='TriggerAccountTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
            insert TriggerAccountKR;
            Boolean flag = True;
            if(case1 =='1')
                flag = false;
            KR_Switch__c krswitch=new KR_Switch__c(Name='Disable UCID Creation',Enable_Flag__c=flag);
            KR_Switch__c krswitch1=new KR_Switch__c(Name='CDM Customer Creation and Update',Enable_Flag__c=flag);
            
            List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
            lsttrgt.add(krswitch);
            lsttrgt.add(krswitch1);
            //DMLManagerService.insertAsSystem(lsttrg);    
            insert lsttrgt;
            
            // UserRole portalRole1 = [Select Id From UserRole Where name='Call Center' Limit 1];           
            // Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
            user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com',
                                EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',UserRoleId = portalRole1.Id, 
                                LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='KR',
                                TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);   
            //DMLManagerService.insertAsSystem(user_Obj);   
            insert user_Obj;
            Profile p2 = [select id,name from profile WHERE Name='IntegrationAPI'];      
            intgnuser_Obj= new User(Alias = 'stawdt', Email='testUser@testorg.com',
                                    EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',UserRoleId = portalRole1.Id, 
                                    LocaleSidKey='en_US', ProfileId = p2.Id, Market__c='KR',
                                    TimeZoneSidKey='America/Los_Angeles', UserName='testuser21@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);   
            //DMLManagerService.insertAsSystem(user_Obj);   
            insert intgnuser_Obj;
            
        }    
    }  

    public static testMethod void testInsert_Case()
    { 
        try{
            prepareTestData('');
            system.runAs(user_Obj)
            {
                Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
                Boolean CDMRCCreation = false;  
                if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('Disable UCID Creation')){
                    CDMRCCreation  = KRSwitchMap.get('Disable UCID Creation').Enable_Flag__c;
                }
                List<Account> AccList= new list<Account>();                
                Account personAccount;
                if (!CDMRCCreation) {
                    personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='KR',MBK_Data_Source__c='Mercedes-Benz',Mobile__c = '000-000-0000', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
                }
                else{
                    personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='KR',MBK_Data_Source__c='Mercedes-Benz',Mobile__c = '+82-00-000-0000', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
                }       
                AccList.add(personAccount);           
                insert AccList;               
            } 
        }       
        catch(Exception e){
        }
    }
    public static testMethod void testAfterDelete_Case()
    { 
        try{
            prepareTestData('');
            system.runAs(user_Obj)
            {
                Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
                Boolean CDMRCCreation = false;  
                if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('Disable UCID Creation')){
                    CDMRCCreation  = KRSwitchMap.get('Disable UCID Creation').Enable_Flag__c;
                }
                List<Account> AccList= new list<Account>();                
                Account personAccount;
                 Account personAccount1;
                if (!CDMRCCreation) {
                    personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='KR',MBK_Data_Source__c='Mercedes-Benz',Mobile__c = '000-000-0000', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
                }
                else{
                    personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='KR',MBK_Data_Source__c='Mercedes-Benz',Mobile__c = '+82-00-000-0000', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
                } 
                if (!CDMRCCreation) {
                    personAccount1 =  new Account(FirstName='Test1',LastName='Person Account1',Md__c='KR',MBK_Data_Source__c='Mercedes-Benz',Mobile__c = '000-000-0000', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
                }
                else{
                    personAccount1 =  new Account(FirstName='Test1',LastName='Person Account1',Md__c='KR',MBK_Data_Source__c='Mercedes-Benz',Mobile__c = '+82-00-000-0000', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
                } 
                AccList.add(personAccount);
                AccList.add(personAccount1);
                insert AccList;
                Test.startTest();               
                TriggerRecursiveCheck.run = true;       
                update AccList;        
                List<Account> lstD = [Select Id From Account Where Id =:AccList[0].Id];
                System.debug('lstD: '+lstD);
                delete lstD;
                Test.stopTest();
            } 
        }       
        catch(Exception e){
            System.debug('Exception: '+e);
        }
    }
    public static testMethod void testAfterInsertReverse_Case()
    { 
        try{
            prepareTestData('1');
            system.runAs(user_Obj)
            {
                Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
                Boolean CDMRCCreation = false;  
                if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('Disable UCID Creation')){
                    CDMRCCreation  = KRSwitchMap.get('Disable UCID Creation').Enable_Flag__c;
                }                
                List<Account> AccList= new list<Account>();                 
                Account personAccount;
                if (CDMRCCreation) {
                    personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='KR',MBK_Data_Source__c='Mercedes-Benz',Mobile__c = '000-000-0000', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
                }
                else{
                    personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='KR',MBK_Data_Source__c='Mercedes-Benz',Mobile__c = '+82-00-000-0000', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
                }                              
                AccList.add(personAccount);               
                insert AccList; 
            } 
        }       
        catch(Exception e){
        }
    }
    public static testMethod void testInsertIntgnUser_Case()
    {   
        try{
            prepareTestData('');
            system.runAs(intgnuser_Obj)
            {
                TriggerUtil.userCreate=false;
                List<Account> AccList= new list<Account>();
                KR_Switch__c krswitch=new KR_Switch__c(Name='CDM RC Creation and Update',Enable_Flag__c=True);           
                List<KR_Switch__c> lsttrgt = new List<KR_Switch__c>();
                lsttrgt.add(krswitch);
                insert lsttrgt;
                Map<String, KR_Switch__c> KRSwitchMap = KR_Switch__c.getAll();
                Boolean CDMRCCreation = false;  
                if(!KRSwitchMap.isEmpty() && KRSwitchMap.containsKey('Disable UCID Creation')){
                    CDMRCCreation  = KRSwitchMap.get('Disable UCID Creation').Enable_Flag__c;
                }
                Account personAccount;
                if (!CDMRCCreation) {
                    personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='KR',MBK_Data_Source__c='Mercedes-Benz',Mobile__c = '000-000-0000', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
                }
                else{
                    personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='KR',MBK_Data_Source__c='Mercedes-Benz',Mobile__c = '+82-00-000-0000', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());
                } 
                AccList.add(personAccount);                     
                insert AccList;                           
            }
        }
        catch(Exception e){
        }
    } 
}