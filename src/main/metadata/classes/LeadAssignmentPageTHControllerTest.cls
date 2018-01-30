@isTest
private class LeadAssignmentPageTHControllerTest{
 public static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static String AfterSalesRecordId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
    //public static String DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    
    public static testMethod void LeadAssignmentPageTH_1(){
        User user1 = TestUtils.createAdminUser();
         System.runAs (user1) {
         test.starttest();        
        Account objAccount= new Account();
            objAccount.RecordtypeId=personAccRecordTypeId;
            objAccount.LastName='Test Person 1st';
            //objAccount.Type='Personal';
            objAccount.Status__c='Active';
            objAccount.Province__c='Province1';
            objAccount.City__c='Test';
            objAccount.ZipCode__c = '12345';
            objAccount.Email__c='test@mbj.com';
            objAccount.Mobile__c ='0435488899';
            objAccount.Phone = '08022420181';
            //objAccount.Main_Dealer__c = DealerAccount.id;
            objAccount.Customer_Lifecycle_Phase__c = 'Care';        
        insert objAccount;
        
        Retail_Campaign__c parentCampaignObj=new Retail_Campaign__c(Name='Test Parent Campaign',RecordTypeId=Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId());
      insert parentCampaignObj;
      
        lead__C lead2 = new lead__C();
        lead2.MD__c = 'TH';
        lead2.Contact__c = objAccount.id;
        //lead2.Assigned_Dealer__c = DealerAccount.id;
        lead2.CAC_Lead_Status__c = 'New';
        lead2.ownerid=user1.id;
        lead2.Retail_Campaign_Name__c=parentCampaignObj.id;
        insert lead2;
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(lead2);
        //Test.setCurrentPageReference(new PageReference(sc)); 
        System.currentPageReference().getParameters().put('objIds', lead2.id);
        LeadDealerAssignmentProcess testAccPlan = new LeadDealerAssignmentProcess(sc);
        
        
        LeadAssignmentPageTHController  lap= new LeadAssignmentPageTHController ();
        lap.le.ownerid=user1.id ;
        lap.assignToOwnerClick();
        test.stopTest();
        }
        
}
}