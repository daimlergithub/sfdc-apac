@isTest
public With Sharing class UtilDealerOfferingTest
{
     public static Participating_Dealer__c pDealerObj;
     public static Campaign_Package__c campaignPackageObj;
     public static Account accObj;
     public static Campaign  campaignObj;
     public static Campaign_Offering__c campaignOffering;
     public static Package_Item__c pacakegeItem;
     public static Dealer_Offering__c dealerOfferingObj;
     
     
     public static testmethod void querycpPackageList_test()
    {
        createData();
        Test.startTest();
            List<Participating_Dealer__c> participatinglst = new List<Participating_Dealer__c>();
            participatinglst.add(pDealerObj);
            UtilDealerOffering.querycpPackageList(participatinglst);
            participatinglst.clear();
            UtilDealerOffering.querycpPackageList(participatinglst);
            List<Campaign_Package__c> campaignPackagelst = new List<Campaign_Package__c>();
            campaignPackageObj.Package_Items__r.add(pacakegeItem);
            update campaignPackageObj;
            campaignPackagelst.add(campaignPackageObj);
            UtilDealerOffering.InsertDealerOfferingRecords(participatinglst,campaignPackagelst);
            participatinglst.clear();
            campaignPackagelst.clear();
            UtilDealerOffering.InsertDealerOfferingRecords(participatinglst,campaignPackagelst);
            system.assertNotEquals(participatinglst,null);
           
        Test.stopTest();
    }
    public static testmethod void DelDealerOfferingRecords_test(){
        createData();
        Test.startTest();
            List<Participating_Dealer__c> participatinglst = new List<Participating_Dealer__c>();
            participatinglst.add(pDealerObj);
            List<Campaign_Package__c> campaignPackagelst = new List<Campaign_Package__c>();
            campaignPackageObj.Package_Items__r.add(pacakegeItem);
            update campaignPackageObj;
            campaignPackagelst.add(campaignPackageObj);
            UtilDealerOffering.DelDealerOfferingRecords(participatinglst,campaignPackagelst);
            campaignPackagelst.clear();
            UtilDealerOffering.DelDealerOfferingRecords(participatinglst,campaignPackagelst);
            system.assertNotEquals(participatinglst,null);
        Test.stopTest();
    }
    public static testmethod void DelDealerOffering_Test()
    {
        createData();
        Test.startTest();
            List<Participating_Dealer__c> participatinglst = new List<Participating_Dealer__c>();
            participatinglst.add(pDealerObj);
            UtilDealerOffering.DelDealerOfferingRecords(participatinglst);
            system.assertNotEquals(participatinglst,null);
        Test.stopTest();
    }
    public static testmethod void UpdateDOByPackageItem_Test()
    {
        createData();
        Test.startTest();
            List<Package_Item__c> packeageItemlst = new List<Package_Item__c>();
            packeageItemlst.add(pacakegeItem);
            UtilDealerOffering.UpdateDOByPackageItem(packeageItemlst,'insert');
             UtilDealerOffering.UpdateDOByPackageItem(packeageItemlst,'delete');
             packeageItemlst.clear();
             UtilDealerOffering.UpdateDOByPackageItem(packeageItemlst,'delete');
             system.assertNotEquals(packeageItemlst ,null);
        Test.stopTest();
    }
    public static testMethod void InsertDealerOfferingRecords_Part(){
        createData();
        Test.startTest();
            List<Campaign_Package__c> campaignPackageNewList = [Select Id,Campaign__c,Package_Description__c,Package_Items__c,(Select Id, Offering__r.Campaign__c, Package_Name__c,Related_Campaign_ID__c from Package_Items__r) FROM Campaign_Package__c];
            List<Participating_Dealer__c> participatingDealerlst = [Select Id,Campaign__c,Campaign_Package__c,Dealer__c,Session_End_Date__c,Session_Start_Date__c FROM Participating_Dealer__c];
            
            
            UtilDealerOffering.InsertDealerOfferingRecords(participatingDealerlst,campaignPackageNewList );
            system.assertNotEquals(participatingDealerlst ,null);
        Test.stopTest();
        
    }
    public static void createData(){
        
        Id recordTypeAccDealerObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        accObj = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez');
       // accList.add(accObj);
        insert accObj;
        Id recordTypeCampaignDealerObjId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
        campaignObj = new Campaign(Name = 'Test Campaign',CAC_Frequency_Category__c= 'Ad Hoc',Repeat_From__c= System.now(),Repeat_End__c=system.now(),RecordTypeId=recordTypeCampaignDealerObjId,Segmentation_Date__c=system.today());
        insert campaignObj;
        campaignOffering = new Campaign_Offering__c(Campaign__c = campaignObj.Id,Description__c= 'Test',End_Date__c=system.today(),Start_Date__c=system.today());
        insert campaignOffering;
        campaignPackageObj = new Campaign_Package__c(Campaign__c = campaignObj.Id,Package_Description__c ='Test Data');
        insert campaignPackageObj;
        
        pacakegeItem = new Package_Item__c(Offering__c = campaignOffering.Id,Package_Name__c=campaignPackageObj.Id);
        insert pacakegeItem;
       
        pDealerObj = new Participating_Dealer__c(Campaign__c = campaignObj.Id,Campaign_Package__c =campaignPackageObj.Id,Dealer__c=accObj.Id,Session_End_Date__c = system.today(),Session_Start_Date__c = system.today());
        insert pDealerObj;
        dealerOfferingObj = new Dealer_Offering__c(Campaign_Offering__c = campaignOffering.Id,Comments__c ='Test',Dealer__c= accObj.Id,Package_Item__c = pacakegeItem.Id,Session_End_Date__c= system.today(),Session_Start_Date__c= system.today());
        insert dealerOfferingObj;
       // Participating_Dealer__c participatingDealerObj = new
    }
}