@isTest
public without sharing class LeadMergeControllerTest1{
    @isTest
    static void LeadMergeControllerMethodTest(){
         
         Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        
        User user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user1 );
        User user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
        DMLManagerService.insertAsSystem(user_Obj );
        test.startTest();
        Account testAccount = new Account(Name='Test Account 123',UCID__c='UCIDtest3394510');
        insert testAccount;
        
        Retail_Task__c testContract = new Retail_Task__c(Name='Test Contract',Account__c =testaccount.id,ContractNumber__c='1234567890');
        insert testContract;
        List<Lead__c> LeadList = new List<Lead__c>();
        Lead__c newLead = new Lead__c(Lead_Type__c = 'New Car', CAC_Lead_Status__c = 'New',Dealer_Lead_Status__c='Invoiced',AfterSales_VIN__c='abcd',Existing_Contract__c=testContract.id,Service_Advisor__c=user1.id);
        LeadList.add(newLead);
        //insert newLead;
        Lead__c newLead1 = new Lead__c(Lead_Type__c = 'New Car', CAC_Lead_Status__c = 'New',AfterSales_VIN__c='abcd',Existing_Contract__c=testContract.id,Service_Advisor__c=user1.id);
        //insert newLead;
        LeadList.add(newLead1);
        Lead__c newLead2 = new Lead__c(Lead_Type__c = 'New Car', CAC_Lead_Status__c = 'New',Dealer_Lead_Status__c='Invoiced',AfterSales_VIN__c='abcd',Service_Advisor__c=user1.id);
        //insert newLead;
        LeadList.add(newLead2);
        Lead__c newLead3 = new Lead__c(Lead_Type__c = 'New Car', CAC_Lead_Status__c = 'New',Dealer_Lead_Status__c='Invoiced',Existing_Contract__c=testContract.id,Service_Advisor__c=user1.id);
        LeadList.add(newLead3);
        Lead__c newLead4 = new Lead__c(Lead_Type__c = 'New Car', CAC_Lead_Status__c = 'New',Dealer_Lead_Status__c='Invoiced',Service_Advisor__c=user1.id);
        LeadList.add(newLead4);
        insert LeadList;
         Apexpages.currentPage().getParameters().put('id',newLead.id);
         Apexpages.currentPage().getParameters().put('selectedValue',newLead.id);
         ApexPages.currentPage().getParameters().put('idselected',newLead.id);  
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
        obj.getSelected();
        obj.cancel1();
        boolean b= obj.hasSuspectLeads;
        String c=obj.radioHidden;
        boolean d=obj.SelectmasterHide; 
        system.assertNotEquals(null, obj.leads );
        //obj.getParameter('abcd');
        Apexpages.currentPage().getParameters().put('id',newLead1.id);
         Apexpages.currentPage().getParameters().put('selectedValue',newLead1.id);
         ApexPages.currentPage().getParameters().put('idselecteds',newLead2.id);
         ApexPages.currentPage().getParameters().put('idselected',newLead1.id);
         ApexPages.StandardController sc1 = new ApexPages.StandardController(newLead1);
        //newAccountPlan testAccPlan = new newAccountPlan(sc);
        LeadMergeController obj1 = new LeadMergeController(sc1);
        obj1.selectAllParam = 'Master';
        obj1.rejectDup();
        obj1.getMasterAndslaveId();
        obj1.mergeDup() ;
        obj1.getSelectedMaster();
        Apexpages.currentPage().getParameters().put('id',newLead2.id);
         Apexpages.currentPage().getParameters().put('selectedValue',newLead2.id);
         ApexPages.currentPage().getParameters().put('idselecteds',newLead2.id);
         ApexPages.currentPage().getParameters().put('idselected',newLead2.id);
         ApexPages.StandardController sc2 = new ApexPages.StandardController(newLead2);
        //newAccountPlan testAccPlan = new newAccountPlan(sc);
        LeadMergeController obj2 = new LeadMergeController(sc2);
        obj2.selectAllParam = 'Master';
         Apexpages.currentPage().getParameters().put('id',newLead3.id);
         Apexpages.currentPage().getParameters().put('selectedValue',newLead3.id);
         ApexPages.currentPage().getParameters().put('idselecteds',newLead3.id);
         ApexPages.currentPage().getParameters().put('idselected',newLead3.id);
         ApexPages.StandardController sc3 = new ApexPages.StandardController(newLead3);
        //newAccountPlan testAccPlan = new newAccountPlan(sc);
        LeadMergeController obj3 = new LeadMergeController(sc3);
        obj3.selectAllParam = 'Master';
        Apexpages.currentPage().getParameters().put('id',newLead4.id);
         Apexpages.currentPage().getParameters().put('selectedValue',newLead4.id);
         ApexPages.currentPage().getParameters().put('idselecteds',newLead4.id);
         ApexPages.currentPage().getParameters().put('idselected',newLead4.id);
         ApexPages.StandardController sc4 = new ApexPages.StandardController(newLead4);
        //newAccountPlan testAccPlan = new newAccountPlan(sc);
        LeadMergeController obj4 = new LeadMergeController(sc4);
        obj4.selectAllParam = 'Master';
        system.assertNotEquals(null, obj4.leads );
        test.stopTest();
    }
}