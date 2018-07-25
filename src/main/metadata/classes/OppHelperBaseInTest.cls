/**
** Class: OppHelperBaseInTest 
** Description: Test Class for OppHelperBase
** Created By: Prem Kumar
** Date: 16/04/2018
**/
@IsTest
public class OppHelperBaseInTest {
   
    public static string salesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordTypeId();
    public static string afterSalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Aftersales Lead').getRecordTypeId();
    public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();  
    public static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
    public static String dealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    
    public static void initData(){
        //CarModelMappingUtilityTest.initData();
        Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
        user usr = new User(Alias = 'standt', Email='testUser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
                            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(usr);
        System.runAs(usr){
            Account dealerAcc = new Account(Name = 'Test India Dealer Account', recordTypeId = dealerRecordTypeId, Market__c = 'IN');
            dealerAcc.Dealer_nd_code__c = 'DLRIN123';
            insert dealerAcc;
            Group gp = TestUtils.CreateTHGroup('INDLRIN123');
            Contact con = new Contact(FirstName = 'First', LastName = 'Last', AccountId = dealerAcc.Id);
            insert con;
            Account companyAcc = TestUtils.createGenericAccount(usr, '123456', companyAccRecordTypeId, '1234567890');
            Account personAcc = TestUtils.createGenericAccount(usr, '654321', personAccRecordTypeId, '9087654321');
            Address__c accAddress = TestUtils.createGenericAddressRecord(personAcc, '123456', 'IN', 'Pune', 'Maharashtra', 'India');
            List<Opportunity> oppAfterSalesList = TestUtils.createGenericBulkOpportunity(usr, personAcc, afterSalesLeadRecordTypeId, 'IN', 5);
            List<Opportunity> oppSalesList = TestUtils.createGenericBulkOpportunity(usr, personAcc, salesLeadRecordTypeId, 'IN', 5);
            List<Opportunity> oppAfterSalesWithPersonAccList = TestUtils.createGenericBulkOpportunity(usr, companyAcc, afterSalesLeadRecordTypeId, 'IN', 5);
            List<Opportunity> oppSalesWithPersonAccList = TestUtils.createGenericBulkOpportunity(usr, companyAcc, salesLeadRecordTypeId, 'IN', 5);
            Opportunity genericOpp = TestUtils.createGenericOpportunity(usr, companyAcc, salesLeadRecordTypeId, 'IN');
        }
    }
    
    @IsTest
    private static void testOppHelperBaseMethods1() {
        test.startTest();
        //CarModelMappingUtilityTest.initData();
        //User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        Profile p = [select id from profile where Name='System Administrator' limit 1];
        User usr = new User(LastName='User',country='India',firstName='GenericBCI',ProfileId=p.Id,Alias='aind123',EmailEncodingKey='UTF-8',TimeZoneSidKey='Asia/Kolkata',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='adminuserind@testing.com',UserName='admusrIN01@daimler.com',Market__c = 'IN');
        insert usr;
        System.runAs(usr){
            initData();
            Account acc = [Select Id, Name, Primary_Address_Reference__c From Account Where recordTypeId =: companyAccRecordTypeId limit 1];
            Account peracc = [Select Id, Primary_Address_Reference__c From Account Where recordTypeId =: personAccRecordTypeId limit 1];
            Account dlracc = [select id from Account where recordtypeid =: dealerRecordTypeId limit 1];
            Address__c accAddress = TestUtils.createGenericAddressRecord(acc, '123456', 'IN', 'Pune', 'Maharashtra', 'India');
            Address__c peraccAddress = TestUtils.createGenericAddressRecord(peracc, '123456', 'IN', 'Pune', 'Maharashtra', 'India');
            acc.Primary_Address_Reference__c = accAddress.Id;
            peracc.Primary_Address_Reference__c = peraccAddress.Id;
            update acc;
            update peracc;
            List<Opportunity> opptyList = [select Id, AccountId, Name, Sales_Consultant__c, recordTypeId, Assigned_Dealer__c, Createdby.usertype, 
                                           createdby.Dealer_nd_code__c, assigned_dealer__r.Dealer_nd_code__c, assigned_dealer__r.MD__c, Assigned_Service_Advisor__c,
                                           createdby.Market__c,MD__c From Opportunity where Sales_Consultant__c != null limit 20];
            system.debug('opporunty-->'+ opptyList[0].Sales_Consultant__c);
            OppHelperBase oppObj = new OppHelperBase();
           
            Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
            for(Opportunity op : opptyList){
                oppMap.put(op.Id, op);
            }
            oppObj.updateOwnerwithDealer(opptyList, 'IN');
           
            for(Opportunity opp : opptyList){
                opp.TrackingNumber__c = 'asdf'; 
                opp.md__c = 'IN';
                opp.assigned_dealer__c = dlracc.id;
            }
            oppObj.CdmLeadcreate(opptyList, oppMap, 'IN');
            oppObj.ShareRecordswithDealers(opptyList,false,'IN');
            OppHelperBase.updatemarket(opptyList);
            OppHelperBase.getCommunityURL();
            OppHelperBase.CheckRetailCopy(opptyList, oppMap, true, true, 'IN');
            OppHelperBase.mapCarModelToOpportunity(oppMap);
        }
        test.stopTest();
    }
    
    @IsTest
    private static void testOppHelperBaseMethods2() {
        test.startTest();
        //CarModelMappingUtilityTest.initData();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        System.runAs(usr){
            initData();
            List<Opportunity> opptyList = [select Id, AccountId, Name, Sales_Consultant__c, recordTypeId, Assigned_Dealer__c, Createdby.usertype, 
                                           createdby.Dealer_nd_code__c, assigned_dealer__r.Dealer_nd_code__c, assigned_dealer__r.MD__c, Assigned_Service_Advisor__c,
                                           createdby.Market__c,MD__c From Opportunity Where Name = 'Generic Opportunity' limit 1];
            OppHelperBase.updateRetailLookups(opptyList, 'IN');
        }
        test.stopTest();
    }
    
    @IsTest
    private static void testOppHelperBaseMethods3() {
        test.startTest();
        //CarModelMappingUtilityTest.initData();
        //User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        Profile p = [select id from profile where Name='IntegrationAPI' limit 1];
        User usr = new User(LastName='User',country='India',firstName='GenericBCI',ProfileId=p.Id,Alias='aind123',EmailEncodingKey='UTF-8',TimeZoneSidKey='Asia/Kolkata',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='adminuserind@testing.com',UserName='admusrIN01@daimler.com',Market__c = 'IN',User_Type__c='PowerPartner');
        insert usr;
        System.runAs(usr){
            Account dealerAcc = new Account(Name = 'Test India Dealer Account', recordTypeId = dealerRecordTypeId, Market__c = 'IN',Dealer_ND_Code__c='test');
            insert dealerAcc;
            
            contact con = new contact(LastName='test');
            con.accountId = dealerAcc.Id;
            insert con;
            
            Opportunity opprt = new Opportunity(
        	AccountId = dealerAcc.Id,
        	//RecordTypeId = '0120I000001Ht6kQAC',
        	Assigned_Dealer__c=dealerAcc.Id,
        	IsPrivate = false,
        	Sales_Consultant__c= con.Id,
        	Name = 'test',
        	StageName = 'Nurture',
        	Probability = 10.0,
        	CloseDate = Date.newInstance(2018,09,03),
        	LeadSource = 'IB',
        	ForecastCategoryName = 'Pipeline',
        	//OwnerId = '005N0000005RpFEIA0',
        	Entity__c = 'Cars',
        	Express_Service__c = false,
        	Lead_Mobile__c = '+61412345678',
        	Lead_Type__c = 'Sales Used Car',
        	Market__c = 'AU');
        	insert opprt;
                    
            List<Opportunity> opptyList = [select Id, AccountId, Name, Sales_Consultant__c, recordTypeId, Assigned_Dealer__c, Createdby.usertype, 
                                           createdby.Dealer_nd_code__c, assigned_dealer__r.Dealer_nd_code__c, assigned_dealer__r.MD__c, Assigned_Service_Advisor__c,
                                           createdby.Market__c,MD__c From Opportunity where Sales_Consultant__c != null limit 20];
                                           
           system.debug('size of list'+opptyList.size());
            /*
            for (Opportunity opp: opptyList)
            {
                opp.Sales_Consultant__c=con.Id;
            }
            update opptyList;
            system.debug('opptyList' + opptyList[0].Sales_Consultant__c );
            */
            OppHelperBase oppObj = new OppHelperBase();
            List<Account> accList = [Select Id, Name From Account limit 10];
            Set<Id> accIdSet = new Set<Id>();
            for(Account ac : accList){
                accIdSet.add(ac.Id);
            }
            Map<Id,Id> idMap = OppHelperBase.getAccountToDLGKUser(accIdSet);
            OppHelperBase.updateOwnership(accIdSet, opptyList, 'IN');
            //oppObj.updateOwner(opptyList, 'IN');
            oppObj.ShareRecordswithDealers(opptyList,false,'IN');
            
        }
        test.stopTest();
    }
    
    
    

}