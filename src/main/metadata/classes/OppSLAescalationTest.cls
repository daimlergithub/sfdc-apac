@isTest
public class OppSLAescalationTest {
    static User usr;
    static Opportunity oppAfterSales;
    public static void prepareTestData(String testCase){
        Trigger__c TriggerAccountTR = new Trigger__c(Name='TriggerOpportunityTR',Trigger_Name__c='TriggerOpportunity',Trigger_Handler__c='TriggerOpportunityTriggerHandlerTR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TR');
        insert TriggerAccountTR;
         string afterSalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Aftersales Lead').getRecordTypeId();
         
        Profile p = [SELECT Id,Name FROM Profile WHERE Name='System Administrator']; 
        
         /*  usr = new User(Alias = 'standt', Email='testUser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id, Market__c='TR',
                            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(usr);*/
       
            // provide Turkey Specific permissions
           
      //  system.runAs(usr){
           Account personAcc = new Account(Dealer_Default_Flag__c=false,
                                 Dealer_DMS_SR_Code__c='test code 2',
                                 Status__c='NoCustomer',Email__c = 'testemail@test.com',
                                 City__c='Istanbul',
                                 Customer_Lifecycle_Phase__c='Care',
                                 Gender__c = 'Male',
                                 Phone = '0801801110',
                                 Area_code__c = '03',
                                 MD__c = 'TR',
                                 Market__c = 'TR',
                                 Data_Source__c = 'MBT Event',
                                 LastName = 'galaxy1',
                                 FirstName = 'First Name',
                                 Salutation = 'Unknown',
                                 Personal_Agreement__c = 'YES',
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
                                 //PersonBirthdate=date.today(),
                                 
                                 RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());         
            string dealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            Account dealerAcc = new Account(Name = 'Test Turkey Dealer Account', recordTypeId = dealerRecordTypeId, Market__c = 'TR');
            insert dealerAcc;
            Contact con = new Contact(FirstName = 'First', LastName = 'Last', AccountId = dealerAcc.Id);
            insert con;
             PermissionSet ps = new PermissionSet(Name = 'Test', Label = 'Test');
        Market__c  market_Obj = new Market__c(Market_Code__c = 'TR', Market__c = 'TR');
            Insert market_Obj; 
            Functionality_Access_Master__c functionality_access_master_Obj = new Functionality_Access_Master__c(Description__c = '12', Module_Name__c = 'Modul230', PermissionSet_Ids__c = ps.id, Permission_Sets__c = ps.name);
            Insert functionality_access_master_Obj; 
           Persona__c persona_Obj = new Persona__c(Market_Access__c = market_Obj.id, Functionality_Access__c = functionality_access_master_Obj.id, Active__c = true, PersonaName__c = 'IntegrationPerso111', ProfileId__c = p.id , Profiles__c = p.name);
            Insert persona_Obj; 
            insert ps;
            
             TestUtils.providePermissionsIN(usr, ps, 'TRGeneric'); 
             oppAfterSales = new Opportunity();
            oppAfterSales.AccountId = personAcc.Id;
            oppAfterSales.StageName = 'New';
            oppAfterSales.Market__c = 'TR';
            oppAfterSales.Name = 'Generic Opportunity AfterSales';
            oppAfterSales.RecordTypeId = afterSalesLeadRecordTypeId;
            oppAfterSales.CloseDate = Date.newInstance(2018, 4, 17);
            oppAfterSales.Lead_Type__c = 'Service';
            oppAfterSales.Lead_Sub_Type__c = 'Others';
            oppAfterSales.Lead_DataSource__c = 'Event';
            oppAfterSales.Purchase_Time__c = '0-1 month';
            oppAfterSales.assigned_dealer__c = dealerAcc.Id;
            insert oppAfterSales;
            
       
       // }
    }
         public static testMethod void testSLABatch(){
             
               usr = TestUtils.createTRAdminUser();
              system.runAs(usr){
                   test.startTest();
                  prepareTestData('');
                  oppAfterSales.Opp_SLA_Time__c = system.now();
                  system.debug('oppAfterSales.Opp_SLA_Time__c' +oppAfterSales.Opp_SLA_Time__c);
                  system.debug('oppAfterSales.Opp_SLA_Time__c current' +system.now());
                  update oppAfterSales;
             
             //first reminder
             database.executeBatch(new OppSLAescalation());
             //expiry notification
             database.executeBatch(new OppSLAescalation());
             //change owner
             test.stopTest();
                   }
         }
}