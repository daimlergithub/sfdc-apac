@isTest
public without sharing class LeadMergeControllerTest1{
    @isTest
    static void LeadMergeControllerMethodTest(){
        
        Lead__c newLead = new Lead__c(Lead_Type__c = 'New Car', CAC_Lead_Status__c = 'New',Service_Advisor__c = userinfo.getUserId());
        insert newLead;
         Apexpages.currentPage().getParameters().put('id',newLead.id);
         Apexpages.currentPage().getParameters().put('selectedValue',newLead.id);
         ApexPages.StandardController sc = new ApexPages.StandardController(newLead);
        //newAccountPlan testAccPlan = new newAccountPlan(sc);
        LeadMergeController obj = new LeadMergeController(sc);
        obj.selectAllParam = 'Master';
        obj.rejectDup();
        obj.mergeDup();
        obj.MergeLead();
        obj.previous();
        //obj.cancel();
        obj.selectAll();
        obj.selectAllParam = 'Slave';
        obj.selectAll();
    }
}