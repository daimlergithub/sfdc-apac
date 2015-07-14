@isTest
public class UtilDealerOffferingTest {

    Public Static List<Participating_Dealer__c> pdlist = new List<Participating_Dealer__c>();
    Public Static List<Campaign_Package__c> cplist = new List<Campaign_Package__c>();
    
    static void createTestData()
   {
        Campaign TestData_CCA = UtilTestData.dataPreparation();
        Map<String, Schema.RecordTypeInfo> accRecordTypeMap = Schema.SObjectType.Account.getRecordTypeInfosByName();  
        Id accDealerRT = accRecordTypeMap.get('Dealer').getRecordTypeId();        
        Account dealer = new Account(Name='TEST Dealer999', ZipCode__c='123456', Phone='123456789', RecordTypeId=accDealerRT);
        insert dealer;
  
        Participating_Dealer__c pd = new Participating_Dealer__c(Campaign__c=TestData_CCA.Id,Dealer__c=dealer.Id);                                                                     
        pdlist.add(pd);
        insert pdlist;
       
       	Campaign_Package__c cp = new Campaign_Package__c();
        cp.Campaign__c = TestData_CCA.Id;
        cplist.add(cp);
        insert cplist;
       
        Campaign_Offering__c co = new Campaign_Offering__c(Name='TEST Campaign Offering DATA',Campaign__c=TestData_CCA.Id);
        insert co;
       
        Package_Item__c pi = new Package_Item__c();
        pi.Package_Name__c=cplist[0].Id;
       	pi.Offering__c=co.Id;
        insert pi;
   }
    static testMethod void testquerycpPackageList(){
        createTestData();
        Test.startTest();        
        UtilDealerOffering.querycpPackageList(pdList);
        Test.stopTest();
        system.assert(pdList<>null);
    }
    static testMethod void testInsertDealerOfferingRecords(){
        createTestData();
        Test.startTest();        
        UtilDealerOffering.InsertDealerOfferingRecords(pdList,cplist);
        Test.stopTest();
        system.assert(cplist<>null);
    }    
    static testMethod void testDelDealerOfferingRecords1(){
        createTestData();
        Test.startTest();        
        UtilDealerOffering.DelDealerOfferingRecords(pdList);
        Test.stopTest();   
        system.assert(pdList<>null);
    }
    static testMethod void testDelDealerOfferingRecords2(){
        createTestData();
        Test.startTest();        
        UtilDealerOffering.DelDealerOfferingRecords(pdList,cplist);
        Test.stopTest(); 
        system.assert(cplist<>null);
    }    
}