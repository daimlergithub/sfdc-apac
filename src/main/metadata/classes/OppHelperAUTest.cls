/**
** Class: OppHelperAUTest 
** Description: Test Class for OppHelperAU
** Created By: Madhusudhan CS
** Date: 23/05/2018
**/
@IsTest
public class OppHelperAUTest {
    
    public static string salesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordTypeId();
    public static string afterSalesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Aftersales Lead').getRecordTypeId();
    public static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();  
    public static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
    public static String dealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    
    public static void initData(){
        Profile p1 = [SELECT Id,Name FROM Profile WHERE Name='System Administrator'];
        user usr = new User(Alias = 'standt', Email='testUser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='AU',
                            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(usr);
      
    }
    
    @IsTest
    private static void testOppHelperBaseMethods1() {
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('Australia', 'Asia/Kolkata', 'AU');
        System.runAs(usr){
            initData();
            Account acc = TestUtils.createGenericAccount(usr, '1236', companyAccRecordTypeId, '+61445789654'); 
           
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.StageName = 'New';
        opp.Market__c = 'AU';
        opp.Name = 'Generic Opportunity';
        opp.RecordTypeId = salesLeadRecordTypeId;
        opp.CloseDate = Date.newInstance(2018, 4, 17);
        opp.Selected_Car_Model__c ='CLA;A-Class'; 
        insert opp;   
        List<Opportunity> opp1 = new List<Opportunity>();
        opp1.add(opp);
        
            OppHelperAU oppObj = new OppHelperAU();
            Map<Id,Opportunity> oppMap = new Map<Id,Opportunity>();
            //for(Opportunity op : opp){
                oppMap.put(opp.Id, opp);
            //}
            oppObj.mapCarModelToOpporutnity(oppMap); 
         oppObj.updateOwnerwithDealer(opp1);
            
         id dealerType =RecordTypeAccessService.getRecordTypeid('Account','Dealer');
         Account dealerAcc = new Account(Name = 'Test India Dealer Account',Dealer_nd_code__c='1234', recordTypeId = dealerType);
         Opportunity oppA = new Opportunity();
       	 oppA.AccountId = acc.Id;
       	 oppA.StageName = 'New';
       	 oppA.Market__c = 'AU';
       	 oppA.Name = 'Generic Opportunity';
       	 oppA.RecordTypeId = salesLeadRecordTypeId;
       	 oppA.CloseDate = Date.newInstance(2018, 4, 17);
       	 oppA.Selected_Car_Model__c ='CLA;A-Class'; 
      	 oppA.assigned_dealer__c = dealerAcc.Id;
         insert oppA;   
         List<Opportunity> opp2 = new List<Opportunity>();
        	opp2.add(oppA);
      
        Map<Id,Opportunity> oppMap1 = new Map<Id,Opportunity>();
        //for(Opportunity op : opp){
           oppMap1.put(oppA.Id, oppA);
         //}  
         oppMap.put(dealerAcc.Id,opp);
			oppObj.ShareRecordswithDealers(opp1,false);      
           	oppObj.CreateRetailCopy(opp1,oppMap1,true,true,'AU');
           	oppObj.beforeInsertOpportunity(opp1,true);
			oppObj.beforeUpdateOpportunity(opp1,OppMap1,true);
         }
        test.stopTest();
    }
    
}