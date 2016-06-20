@isTest
public with sharing class LeadProudctAttendeescontrollerTest 
{
	public static Lead_Product__c ledprodt = new Lead_Product__c();
    public static Account acc = new Account();
    public static User usr;
    public static profile admin = [select Id from Profile where Name = 'System Administrator' limit 1];
    public static void createtestdata()
    {
			usr = new User(
            Username = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com',
            FirstName = 'firstname',
            ProfileId = admin.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty3',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
        insert usr;
        
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
        ledprodt.OwnerId = usr.Id;
        insert ledprodt;
    }
    public static testmethod void unittest()
    {
        createtestdata();
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',ledprodt.id);
        leadProudctAttendeescontroller attendeescontroller = new leadProudctAttendeescontroller(new ApexPages.StandardController(ledprodt));
        leadProudctAttendeescontroller.wrapperattendeesclass wrapper = new leadProudctAttendeescontroller.wrapperattendeesclass();
        //wrapper.ledprdt.OwnerId = usr.Id;
        wrapper.attendees = '';
       	attendeescontroller.addrow();
        attendeescontroller.save();
        test.stopTest();
    }
    public static testmethod void unittest1()
    {
        createtestdata();
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',ledprodt.id);
        leadProudctAttendeescontroller attendeescontroller = new leadProudctAttendeescontroller(new ApexPages.StandardController(ledprodt));
        leadProudctAttendeescontroller.wrapperattendeesclass wrapper = new leadProudctAttendeescontroller.wrapperattendeesclass();
        wrapper.attendees = '';
        wrapper.ledprdt = acc;
        wrapper.ledprdt.OwnerId = usr.id;
        attendeescontroller.addrow();
       	attendeescontroller.save();
        test.stopTest();
    }
}