/*
  Description : This Class will incresase the coverage for LeadDealerAssignmentProcess.
  Created By: Kiran
  Date: 2016-12-20
*/  
@isTest
public class LeadDealerAssignmentProcessTest{
    public static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static String AfterSalesRecordId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
    //public static String DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static testMethod void LeadDealerAssignmentProcess_MT(){
        
        Account objAccount= new Account();
            objAccount.RecordtypeId=personAccRecordTypeId;
            objAccount.LastName='Test Person 1st';
            //objAccount.Type='Personal';
            objAccount.Status__c='Active';
            objAccount.Province__c='Province1';
            objAccount.City__c='Test';
            objAccount.ZipCode__c = '1004235';
            objAccount.Email__c='test@mbj.com';
            objAccount.Mobile__c ='0435488899';
            objAccount.Phone = '08022420181';
            //objAccount.Main_Dealer__c = DealerAccount.id;
            objAccount.Customer_Lifecycle_Phase__c = 'Care';
        
        insert objAccount;
        lead__C lead2 = new lead__C();
        lead2.MD__c = 'JP';
        lead2.Contact__c = objAccount.id;
        //lead2.Assigned_Dealer__c = DealerAccount.id;
        lead2.CAC_Lead_Status__c = 'New';
        insert lead2;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(lead2);
        LeadDealerAssignmentProcess testAccPlan = new LeadDealerAssignmentProcess(sc);
        testAccPlan.leadid = lead2.id;
        testAccPlan.userid1 = UserInfo.getUserId();
        testAccPlan.getDealerAssignment();
        //testAccPlan.doCancel();
        testAccPlan.AssignLeadtoDealer();
        
        LeadDealerAssignmentProcess.Wrapperuser wrUser = new LeadDealerAssignmentProcess.Wrapperuser();
    }
    public static testMethod void LeadDealerAssignmentProcess_MT1(){
        
        Account objAccount= new Account();
            objAccount.RecordtypeId=personAccRecordTypeId;
            objAccount.LastName='Test Person 1st';
            //objAccount.Type='Personal';
            objAccount.Status__c='Active';
            objAccount.Province__c='Province1';
            objAccount.City__c='Test';
            objAccount.ZipCode__c = '1004235';
            objAccount.Email__c='test@mbj.com';
            objAccount.Mobile__c ='0435488899';
            objAccount.Phone = '08022420181';
            //objAccount.Main_Dealer__c = DealerAccount.id;
            objAccount.Customer_Lifecycle_Phase__c = 'Care';
        
        insert objAccount;
        lead__C lead2 = new lead__C();
        lead2.MD__c = 'JP';
        lead2.Contact__c = objAccount.id;
        lead2.RecordTypeId = AfterSalesRecordId;
        //lead2.Assigned_Dealer__c = DealerAccount.id;
        lead2.CAC_Lead_Status__c = 'New';
        insert lead2;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(lead2);
        LeadDealerAssignmentProcess testAccPlan = new LeadDealerAssignmentProcess(sc);
        testAccPlan.leadid = lead2.id;
        testAccPlan.userid1 = UserInfo.getUserId();
        testAccPlan.getDealerAssignment();
        //testAccPlan.doCancel();
        testAccPlan.AssignLeadtoDealer();
        
        LeadDealerAssignmentProcess.Wrapperuser wrUser = new LeadDealerAssignmentProcess.Wrapperuser();
    }
}