/*
    Type:       test class
    Purpose:    CACFieldsExtension test class
    User Story: US-DPCR-002 - View and edit CAC Fields
    Used By:    CACFieldsExtension
    History:16-Jul-2013 Barney Lai (Nttdata)    Created
*/
@isTest
public with sharing class CACFieldsExtensionTest {
    public static testMethod void testCACFieldsExtension1(){
		List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
		insert updatecustomsettings;
        Case c1 = new Case();
        Test.startTest();
        insert c1;
        ApexPages.standardController controller = new ApexPages.standardController(c1);
        CACFieldsExtension extension = new CACFieldsExtension(controller);
        extension.isEdit = true; 
        extension.edit();       
        extension.cancel();
        extension.save();
        Test.stopTest();
        system.assertequals(extension.isEdit,false);
    }
}