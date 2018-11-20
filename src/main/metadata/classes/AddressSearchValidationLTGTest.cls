@isTest
public class AddressSearchValidationLTGTest {
    public static user userSetup(String Profile, String Market) {
        // Create common Users
        Profile p = [SELECT Id FROM Profile WHERE Name =: Profile];
        User u = new User(
            Alias = 'testu',
            Email = 'test@unitingambition.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'Test',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey='America/Los_Angeles',
            ProfileId = p.Id,
            UserName='test@unitingamb.com'+String.valueof(DateTime.now().getTime()),
            Market__c=Market
        );
        insert u;  
        return u;		
    }
    
    public static Account personAccSetup(Id RecordTypeIdAcc, String firstname, String lastname, String mobile, String market) {
        // Create common test accounts
        Account acc= new Account(firstname=firstname, lastname=lastname,Mobile__c=mobile,recordtypeID=RecordTypeIdAcc,Market__c=market);
	return acc;		
    }
    public static Account compAccSetup(Id RecordTypeIdAcc, String name, String mobile, String market) {
        // Create common test accounts
        Account dealeracc= new Account(Name=name, Mobile__c=mobile,recordtypeID=RecordTypeIdAcc,Market__c=market);
        dealeracc.Corporate_Category__c='Rental';
	return dealeracc;		
    }
    public static Address__c addressSetup(String market) {
        // Create common test accounts
        Address__c address= new Address__c(Market__c=market);
	return address;		
    }
    
    @isTest
    public static void getFieldsTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'AU');
        User usr=[Select alias,Market__c from User where id=:u.id];
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> fetchFields=AddressSearchValidationLTG.getFields('AU', 'Person Account', 'AddressSearchValidation');
                Map<String,List<String>> fetchFieldsDefault=AddressSearchValidationLTG.getFields('AU', 'Person Account', 'AddressSearchValidationTest');	
            }catch(Exception e){}
            test.stopTest();
        }
        
    }
    @isTest
    public static void getFieldsDefaultTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'SA');
        User usr=[Select alias,Market__c from User where id=:u.id]; 
        System.runAs(usr) {
            test.startTest();
            try{               
                Map<String,List<String>> fetchFields=AddressSearchValidationLTG.getFields('SA', 'Person Account', 'AddressSearchValidation');
            }catch(Exception e){}
            test.stopTest();
        }
        
    }
    
    @isTest
    public static void getRecordTypeTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'AU');
        User usr=[Select alias,Market__c from User where id=:u.id]; 
        system.debug('ALias'+usr.Alias);
        
        System.runAs(usr) {
            test.startTest();
            try{
                User uderTest=AddressSearchValidationLTG.getUserMarket();
                AddressSearchValidationDefault addDefault=new AddressSearchValidationDefault();
                addDefault.onLineDeduplicationCheck(null,null);
                addDefault.saveForm(null,null);
                Factory_Fields__mdt ffRec=addDefault.getmdRec();
                String recordTypeName=AddressSearchValidationLTG.getRecTypeId('Person Account');
                String recordTypeNameExcep=AddressSearchValidationLTG.getRecTypeId('Person'); 
            }catch(Exception e){}
            test.stopTest();
        }
    }
    
    @isTest
    public static void DataTableTest(){
         Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'AU');
        User usr=[Select alias,Market__c from User where id=:u.id]; 
        system.debug('ALias'+usr.Alias);
        
        System.runAs(usr) {
            test.startTest();
            try{
                User uderTest=AddressSearchValidationLTG.getUserMarket();
                String recordTypeName=AddressSearchValidationLTG.getRecTypeId('Person Account');
                List<LightningDataTableWrapper.DataTableColumns> recordTypeNameExcep=AddressSearchValidationLTG.getDataTableColumns('Account','AU','Person Account','AddressSearchValidation'); 
            }catch(Exception e){}
            test.stopTest();
        }
    }
    
    @isTest
    public static void onLineDeduplicationPersonTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'AU');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();        
        Account acc=AddressSearchValidationLTGTest.personAccSetup(RecordTypeIdAcc,'Test','Tom','+61456789432','AU');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('AU');
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult=AddressSearchValidationLTG.onLineDedpulication(acc,address,'AddressSearchValidation','AU');
            }catch(Exception e){}
            test.stopTest();
        }
    }
    
    @isTest
    public static void onLineDeduplicationExpTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'AU');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();        
        Account acc=AddressSearchValidationLTGTest.personAccSetup(RecordTypeIdAcc,null,'Tom',null,'AU');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('AU');
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult=AddressSearchValidationLTG.onLineDedpulication(acc,address,'AddressSearchValidation','AU');
            }catch(Exception e){}
            test.stopTest();
        }
    }
    
    @isTest
    public static void onLineDeduplicationExpTest1(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'AU');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();        
        Account acc=AddressSearchValidationLTGTest.personAccSetup(RecordTypeIdAcc,'Test','Tom',null,'AU');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('AU');
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult=AddressSearchValidationLTG.onLineDedpulication(acc,address,'AddressSearchValidation','AU');
            }catch(Exception e){}
            test.stopTest();
        }
    }
    @isTest
    public static void onLineDeduplicationCompanyTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'AU');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();        
        Account acc=AddressSearchValidationLTGTest.compAccSetup(RecordTypeIdAcc,'Tom','+61456789432','AU');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('AU');
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult=AddressSearchValidationLTG.onLineDedpulication(acc,address,'AddressSearchValidation','AU');
            }catch(Exception e){}
            test.stopTest();
        }
    }
    @isTest
    public static void onLineDeduplicationCompExpTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'AU');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();        
        Account acc=AddressSearchValidationLTGTest.compAccSetup(RecordTypeIdAcc,null,null,'AU');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('AU');
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult=AddressSearchValidationLTG.onLineDedpulication(acc,address,'AddressSearchValidation','AU');
            }catch(Exception e){}
            test.stopTest();
        }
    }
    
    @isTest
    public static void onLineDeduplicationCompExpTest1(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'AU');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();        
        Account acc=AddressSearchValidationLTGTest.compAccSetup(RecordTypeIdAcc,'Test',null,'AU');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('AU');
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult=AddressSearchValidationLTG.onLineDedpulication(acc,address,'AddressSearchValidation','AU');
            }catch(Exception e){}
            test.stopTest();
        }
    }
    
    @isTest
    public static void saveAccPersonTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'AU');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();        
        Account acc=AddressSearchValidationLTGTest.personAccSetup(RecordTypeIdAcc,'Test','Tom','+61456789432','AU');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('AU');
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult=AddressSearchValidationLTG.submitForm(acc,address,'AddressSearchValidation','AU');
            }catch(Exception e){}
            test.stopTest();
        }
    }
    
    @isTest
    public static void saveAccExpTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'AU');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();        
        Account acc=AddressSearchValidationLTGTest.personAccSetup(RecordTypeIdAcc,null,'Tom',null,'AU');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('AU');
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult=AddressSearchValidationLTG.submitForm(acc,address,'AddressSearchValidation','AU');
            }catch(Exception e){}
            test.stopTest();
        }
    }
    
    @isTest
    public static void saveAccExpTest1(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'AU');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();        
        Account acc=AddressSearchValidationLTGTest.personAccSetup(RecordTypeIdAcc,'Test','Tom',null,'AU');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('AU');
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult=AddressSearchValidationLTG.submitForm(acc,address,'AddressSearchValidation','AU');
            }catch(Exception e){}
            test.stopTest();
        }
    }
    @isTest
    public static void saveAccCompanyTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'AU');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();        
        Account acc=AddressSearchValidationLTGTest.compAccSetup(RecordTypeIdAcc,'Tom','+61456789432','AU');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('AU');
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult=AddressSearchValidationLTG.submitForm(acc,address,'AddressSearchValidation','AU');
            }catch(Exception e){}
            test.stopTest();
        }
    }
    @isTest
    public static void saveAccCompExpTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'AU');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();        
        Account acc=AddressSearchValidationLTGTest.compAccSetup(RecordTypeIdAcc,null,null,'AU');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('AU');
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult=AddressSearchValidationLTG.submitForm(acc,address,'AddressSearchValidation','AU');
            }catch(Exception e){}
            test.stopTest();
        }
    }
    
    @isTest
    public static void saveAccCompExpTest1(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'AU');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();        
        Account acc=AddressSearchValidationLTGTest.compAccSetup(RecordTypeIdAcc,'Test',null,'AU');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('AU');
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult=AddressSearchValidationLTG.submitForm(acc,address,'AddressSearchValidation','AU');
            }catch(Exception e){}
            test.stopTest();
        }
    }
    
    @isTest
    public static void onlineDeDuplicationFMTest()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'ID');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();        
        Account acc=AddressSearchValidationLTGTest.compAccSetup(RecordTypeIdAcc,'Tom','+61456789432','ID');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('ID');
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult=AddressSearchValidationLTG.onLineDedpulication(acc,address,'AddressSearchValidation','ID');
            }catch(Exception e){}
            test.stopTest();
        }
    }
    
    @isTest
    public static void onlineDeDuplicationFMExpTest()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'ID');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();        
        Account acc=AddressSearchValidationLTGTest.compAccSetup(RecordTypeIdAcc,'Test',null,'ID');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('ID');
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult=AddressSearchValidationLTG.onLineDedpulication(acc,address,'AddressSearchValidation','ID');
            }catch(Exception e){}
            test.stopTest();
        }
    }
    
    @isTest
    public static void saveAccCompanyFMTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'ID');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();        
        Account acc=AddressSearchValidationLTGTest.compAccSetup(RecordTypeIdAcc,'Tom','+61456789432','ID');
        Account acc2=AddressSearchValidationLTGTest.compAccSetup(RecordTypeIdAcc,'Bill','+61456789431','ID');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('ID');
        Address__c halfAddress=AddressSearchValidationLTGTest.addressSetup('ID');
        halfAddress.Address_Type__c='Home';
        Address__c fullAddress=AddressSearchValidationLTGTest.addressSetup('ID');
        fullAddress.Address_Type__c='Home';
        fullAddress.Address_Line_1__c='test';
        fullAddress.Address_Line_2__c='test';
        fullAddress.Address_Line_3__c='test';
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult=AddressSearchValidationLTG.submitForm(acc,address,'AddressSearchValidation','ID');
                //Map<String,List<String>> onLineDedupResult2=AddressSearchValidationLTG.submitForm(acc,halfAddress,'AddressSearchValidation','ID');
                Map<String,List<String>> onLineDedupResult3=AddressSearchValidationLTG.submitForm(acc,fullAddress,'AddressSearchValidation','ID');
            }catch(Exception e){}
            test.stopTest();
        }
    }
   
     @isTest
    public static void saveAccCompanyExpFMTest2(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'ID');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();        
        Account acc=AddressSearchValidationLTGTest.compAccSetup(RecordTypeIdAcc,'Tom','+61456789432','ID');
        Address__c fullAddress=AddressSearchValidationLTGTest.addressSetup('ID');
        fullAddress.Address_Type__c='Home';
        fullAddress.Address_Line_1__c='test';
        fullAddress.Address_Line_2__c='test';
        fullAddress.Address_Line_3__c='test';
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult3=AddressSearchValidationLTG.submitForm(acc,fullAddress,'AddressSearchValidation','ID');
            }catch(Exception e){}
            test.stopTest();
        }
    }
    @isTest
    public static void saveAccCompFMExpTest1(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'ID');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();        
        Account acc=AddressSearchValidationLTGTest.compAccSetup(RecordTypeIdAcc,'Test',null,'ID');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('ID');
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult=AddressSearchValidationLTG.submitForm(acc,address,'AddressSearchValidation','ID');
            }catch(Exception e){}
            test.stopTest();
        }
    }
    @isTest
    public static void saveAccCompFMExpTest3(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'ID');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();        
        Account acc=AddressSearchValidationLTGTest.compAccSetup(RecordTypeIdAcc,'Test','+61456789432','ID');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('ID');
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult=AddressSearchValidationLTG.onLineDedpulication(acc,address,'AddressSearchValidation','ID');
            }catch(Exception e){}
            test.stopTest();
        }
    }
    
     @isTest
    public static void savePersonAccFMExpNameNull(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'ID');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();        
        Account acc=AddressSearchValidationLTGTest.personAccSetup(RecordTypeIdAcc,null,null,null,'ID');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('ID');
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult=AddressSearchValidationLTG.onLineDedpulication(acc,address,'AddressSearchValidation','ID');
            }catch(Exception e){}
            test.stopTest();
        }
    }
     @isTest
    public static void saveCompanyAccFMExpNameNull(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'ID');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAccCompany = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();        
        Account acc2=AddressSearchValidationLTGTest.compAccSetup(RecordTypeIdAccCompany,null,'+61456789432','ID');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('ID');
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult2=AddressSearchValidationLTG.onLineDedpulication(acc2,address,'AddressSearchValidation','ID');
            }catch(Exception e){}
            test.stopTest();
        }
    }
     @isTest
    public static void saveAccPersonFMExpContactNull(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = AddressSearchValidationLTGTest.userSetup('System Administrator', 'ID');
        User usr=[Select alias,Market__c from User where id=:u.id];
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();         
        Account acc=AddressSearchValidationLTGTest.personAccSetup(RecordTypeIdAcc,'Tom','Dom',null,'ID');
        Address__c address=AddressSearchValidationLTGTest.addressSetup('ID');
        System.runAs(usr) {
            test.startTest();
            try{
                Map<String,List<String>> onLineDedupResult2=AddressSearchValidationLTG.onLineDedpulication(acc,address,'AddressSearchValidation','ID');
            }catch(Exception e){}
            test.stopTest();
        }
    }
}