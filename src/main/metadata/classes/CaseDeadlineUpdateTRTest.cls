/**
* Test class for CaseDeadlineUpdateTR
*/


@istest
public class CaseDeadlineUpdateTRTest {
    
    public static User user1;
    public static User user2;
    public static Market__c market_Obj;
    public static Functionality_Access_Master__c functionality_access_master_Obj ;
    public static Persona__c persona_Obj;
    @testSetup
    static void setupTestData(){    
        
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        
        User user1 = new User(LastName='User'+System.Today(),Market__c='TR',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01'+String.valueof(DateTime.now().getTime()));
        insert user1;
        System.runAs (user1) {  
            List<String> AccountFields=new List<String>();
            AccountFields.add('Lastname');
            AccountFields.add('firstname');
            AccountFields.add('Individual_Home_Phone__c');
            AccountFields.add('Work_Phone__c');
            AccountFields.add('fax');
            AccountFields.add('Mobile__c');
            AccountFields.add('MD__c');
            AccountFields.add('Data_Source__c');
            AccountFields.add('Market__c');
            List<Account> AccountFieldsList=DataFactoryServices.createRecords('Account',AccountFields,'',1);
            AccountFieldsList[0].RecordTypeId=RecordTypeAccessService.getRecordTypeId('Account',Label.PersonAccount);
            AccountFieldsList[0].Lastname='Lastname1';
            AccountFieldsList[0].Firstname='Lastname1';
            AccountFieldsList[0].Individual_Home_Phone__c='+6003123654789';
            AccountFieldsList[0].Work_Phone__c='+60825634789541';
            AccountFieldsList[0].fax='+60827896541';
            AccountFieldsList[0].Mobile__c='+609856321478';
            AccountFieldsList[0].MD__c='TR';
            AccountFieldsList[0].Data_Source__c='MBT Event';
            AccountFieldsList[0].Market__C='TR';
            insert AccountFieldsList;
            Address__c address=new Address__c();
            address.Address_Type__c='Home';
            address.Province__c='Istanbul';
            address.City__c='bangalore';
            address.District__c='test2';
            address.Block__c='test3';
            address.Address_Line_1__c='testaddress1';
            address.Address_Line_2__c='testaddress2';
            address.Customer__c=AccountFieldsList[0].id;
            address.TitleOfHonor__c = 'To Person';             
            address.Market__c = 'TR';        
			address.Country__c = 'Turkey';  			
            insert address;
            
            AccountFieldsList[0].primary_address_reference__c = address.id;
            update AccountFieldsList[0];
            
            contact ct = new contact();
            ct.lastname ='last name';
            ct.market__c='TR';
            insert ct;
            List<String> CaseFields=new List<String>();
            CaseFields.add('Status');
            CaseFields.add('Case_RepeatCause__c');
            CaseFields.add('accountid');
            CaseFields.add('Recordtypeid');   
            CaseFields.add('Market__c');
            CaseFields.add('priority');
            List<Case> CaseFieldsList;
            CaseFieldsList=DataFactoryServices.createRecords('Case',CaseFields,'',1);
            
            CaseFieldsList[0].RecordTypeId=Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
            CaseFieldsList[0].accountid=AccountFieldsList[0].id;
            CaseFieldsList[0].Market__c='TR';
            CaseFieldsList[0].status='Open';
            CaseFieldsList[0].Case_RepeatCause__c='';
            CaseFieldsList[0].priority='Green <= 2';
            CaseFieldsList[0].contactId = ct.id;
            CaseFieldsList[0].subject ='case 1 ';
            CaseFieldsList[0].Description = 'case 1 ';
            CaseFieldsList[0].case_class__c = 'Satisfaction';
            CaseFieldsList[0].Case_Type_tr__c = 'DAB';
            CaseFieldsList[0].Case_Sub_Type__c = 'Reklam teklifleri';
            CaseFieldsList[0].Case_Sub_Type_Detail_tr__c ='Sorular';
            insert CaseFieldsList;        }
    }
    
    static testmethod void testCaseDeadlineTR(){
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        
        User user2 = new User(LastName='User2'+System.Today(),Market__c='TR',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='user2@infosys.com',UserName='user2@infosys.com'+String.valueof(DateTime.now().getTime()));
        insert user2;
        System.runAs (user2) {   
            test.startTest();
            Account acc2 = TestUtils.createCompanyAccount(user2);
            contact ct = new contact();
            ct.lastname ='last name';
            ct.accountid = acc2.Id;
            ct.market__c='TR';
            insert ct;
            List<Case> CaseList  =  [SELECT RecordTypeid,accountid,parentid,status,Case_RepeatCause__c,priority,Market__c, MD__c from Case];
            CaseDeadlineUpdateTR.updateCaseDeadLineAmount(caselist);
                                   
            test.stopTest();
        }
    }
    
}