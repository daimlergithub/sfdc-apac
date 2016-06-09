@isTest
public class LeadProductDetailsInputControllerTest 
{
	public static Lead_Product__c ledprodt = new Lead_Product__c();
    public static Account acc = new Account();
    public static void createtestdata()
    {        
        acc.Name = 'account name';
        acc.Phone = '10786';
        acc.Area_Code__c = '010';
        acc.Fax = '10086';
        acc.BillingCity = 'San Francisco';
        acc.BillingCountry = 'USA';
        acc.BillingPostalCode = '94105';
        acc.BillingState = 'CA';
        acc.BillingStreet = 'SnapBi 55 New Montgomery Street Suite 525';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        insert acc;
        
        Lead__c lead = new Lead__c();
        lead.Company_Account__c=acc.Id;
        lead.Lead_Source__c = 'Web Form';
        lead.Nature_of_Request__c='General Enquiry';
        lead.Business_Unit__c= 'Vans';
        lead.Lead_Items__c = 'lead items';
        lead.Sub_BusinessUnit__c='Auto Body Repairer';
        lead.CAC_Lead_Status__c = 'Credit Review in Process';
        insert lead;
        
        ledprodt.Account__c = acc.id;
        ledprodt.Name = 'Testleadproduct';
        ledprodt.Lead__c = lead.id;
        insert ledprodt;
    }
    public static testmethod void unittest()
    {
        createtestdata();
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',ledprodt.id);
        LeadProductDetailsInputController detailsInputController = new LeadProductDetailsInputController(new ApexPages.StandardController(ledprodt));
        LeadProductDetailsInputController.wrappermultibrandclass wrapper = new LeadProductDetailsInputController.wrappermultibrandclass();
       	detailsInputController.getbrands();
        detailsInputController.addrow();
        detailsInputController.save();
        test.stopTest();
    }
    public static testmethod void unittest1()
    {
        createtestdata();
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',ledprodt.id);
        LeadProductDetailsInputController detailsInputController = new LeadProductDetailsInputController(new ApexPages.StandardController(ledprodt));
        LeadProductDetailsInputController.wrappermultibrandclass wrapper = new LeadProductDetailsInputController.wrappermultibrandclass();
        detailsInputController.addrow();
       	detailsInputController.save();
        test.stopTest();
    }
}