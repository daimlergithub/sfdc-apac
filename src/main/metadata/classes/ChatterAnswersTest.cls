@isTest
public with sharing class ChatterAnswersTest {
    static testMethod void testcreateAccount(){
    List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
    insert updatecustomsettings;
    Test.startTest();
        ChatterAnswers obj= new ChatterAnswers();
        obj.createAccount('firstname', 'lastname', userInfo.getUserId());
        Test.stopTest();
        system.assertNotEquals(null,userInfo.getUserId());
    }
}