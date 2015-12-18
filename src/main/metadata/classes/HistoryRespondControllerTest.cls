/*
    Type:       test class
    Purpose:    HistoryRespondController test class
    User Story: SMS
    Used By:    HistoryRespondController
    2013-12-09 lishuang (Nttdata)    Created
*/
@isTest
public with sharing class HistoryRespondControllerTest {
    
    public static testMethod void testHistoryRespondController1(){
        
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
         insert updatecustomsettings;

        Task t1 = new Task();
        Test.startTest();
        insert t1;
        ApexPages.standardController controller = new ApexPages.standardController(t1);
        HistoryRespondController c1= new HistoryRespondController(controller);
        c1.getTheResults();
        Test.stopTest();
        system.assertNotEquals(null,t1);
    }
    
   
}