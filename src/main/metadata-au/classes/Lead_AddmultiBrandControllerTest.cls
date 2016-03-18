@isTest
public with sharing class Lead_AddmultiBrandControllerTest 
{
    Public static Lead__c lead = new Lead__c();
    public static list<Lead__c> ledlist = new list<Lead__c>();
    public static List<SelectOption> listselops = new List<SelectOption>();
    public static void cretaetestdata()
    {
        Account acc = new Account();
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
        
        lead.Company_Account__c=acc.Id;
        lead.Assigned_Dealer__c = acc.Id;
        lead.Lead_Source__c = 'Web Form';
        lead.Nature_of_Request__c='General Enquiry';
        lead.Business_Unit__c= 'Vans';
        lead.Lead_Items__c = '';   
        lead.Sub_BusinessUnit__c='Auto Body Repairer';
        lead.CAC_Lead_Status__c = 'Credit Review in Process';
        insert lead;
        ledlist.add(lead);
    }
	public static testmethod void unittest()
    {
        cretaetestdata();
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',lead.id);
        Lead_AddmultiBrandController multibrandcntroller = new Lead_AddmultiBrandController(new ApexPages.StandardController(lead));
        Lead_AddmultiBrandController.wrappermultibrandclass wraper = new Lead_AddmultiBrandController.wrappermultibrandclass();
        wraper.vehiclebrand = 'BMW';
        wraper.vechmodel = 'Aclass';
        wraper.vechquanty = '2';
        wraper.brands = listselops;
        lead.Lead_Items__c = wraper.vehiclebrand + wraper.vechmodel + wraper.vechquanty;
        update lead;
        ledlist.add(lead);
        multibrandcntroller.getbrands();
        multibrandcntroller.save();
        multibrandcntroller.addrow();
        test.stopTest();
    }
}