/*
    Type:       Test Class
    Purpose:    Test On Campaign Planning VF
    ---------------------------------------------------------------
    History:

    27-June-2013 Stephano Shi (Breakingpoint)    Created

*/
@isTest
public class CampaignPlanningController_TestClass{
    
    /* Campaign Planning VF */
    static testmethod void runCampaignPlanningController(){
        // Campaign Record Type Id Search
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap_test = Schema.SObjectType.Campaign.getRecordTypeInfosByName();
        Id cca_RecordTypeId = cpRecordTypeMap_test.get('Central Marketing Campaign').getRecordTypeId();         // Central Campaign   
        Map<String, Schema.RecordTypeInfo> accRecordTypeMap = Schema.SObjectType.Account.getRecordTypeInfosByName();  
        Id accDealerRT = accRecordTypeMap.get('Dealer').getRecordTypeId();        
           
        Test.startTest();
        // Central Campaign Inital
        Campaign TestData_CCA = new Campaign(Name='TestData_CCA_Campaign',
                                             Campaign_Code__c='Code_CCA',
                                             Type='Other',
                                             Campaign_Objectives__c='Objectives',
                                             Description='Description',
                                             Status='Confirmed',
                                             Participating_Region_Province__c ='E All',
                                             StartDate=date.newinstance(2013, 5, 17),
                                             EndDate=date.newinstance(2013, 10, 17),
                                             RecordTypeId=cca_RecordTypeId);     
        
        insert TestData_CCA;
        
        Account dealerSh = new Account(Name='Shanghai Dealer TEST', ZipCode__c='123456', Phone='123456789', Dealer_City_EN__c='Shanghai', RecordTypeId=accDealerRT);
        Account dealerHf = new Account(Name='Hefei Dealer TEST', ZipCode__c='123456', Phone='123456789', Dealer_City_EN__c='Hefei', RecordTypeId=accDealerRT);
        insert dealerSh;
        insert dealerHf;
        
        Participating_Dealer__c pdSh = new Participating_Dealer__c(Campaign__c=TestData_CCA.Id, Dealer__c=dealerSh.Id);
        Participating_Dealer__c pdHf = new Participating_Dealer__c(Campaign__c=TestData_CCA.Id, Dealer__c=dealerHf.Id);
        insert pdSh;  
        insert pdHf;        
        
        Campaign_city__c ccc = new Campaign_city__c(Campaign__c=TestData_CCA.Id,Dealer_City__c=dcHf.Id);
        insert ccc;
  
        PageReference acctPage = Page.CampaignPlanning;
		Test.setCurrentPage(acctPage);        
        String paraId = String.valueOf(TestData_CCA.Id);
        ApexPages.currentPage().getParameters().put('id',paraId);
        
        CampaignPlanningController cpc = new CampaignPlanningController();
        
        System.debug('Parameter >>>' + ApexPages.currentPage().getParameters().get('id'));
        
        cpc.selectRegion();
        cpc.queryDealers();
        
        CampaignPlanningController.clsDealerCity cdcSH;// = new CampaignPlanningController.clsDealerCity(dcSh,true);
        CampaignPlanningController.clsDealerCity cdcHF;// = new CampaignPlanningController.clsDealerCity(dcHf,false);
        CampaignPlanningController.clsDealer cdSH = new CampaignPlanningController.clsDealer(dealerSh,true);
        CampaignPlanningController.clsDealer cdHF = new CampaignPlanningController.clsDealer(dealerHf,false); 
        
        cpc.DealerCityList.add(cdcSH);
        cpc.DealerCityList.add(cdcSH);
        cpc.partiDealerList.add(cdSH);
        cpc.partiDealerList.add(cdHF);
        
        cpc.Save();
        cpc.cancel();
        
        TestData_CCA.Participating_Region_Province__c='E Shanghai';
        update TestData_CCA;
           
        //CampaignPlanningController cpc2 = new CampaignPlanningController();
       
        TestData_CCA.Participating_Region_Province__c='';
        update TestData_CCA;
        CampaignPlanningController cpc3 = new CampaignPlanningController();
        //PageReference pg = new PageReference(TestData_CCA.view());
        Test.stopTest();
    }
}