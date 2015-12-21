@isTest

public with sharing class SharingDataHandlerBaseTest {

public static testMethod void testSharingDataHandlerBase() 
{
  List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
  insert updatecustomsettings;

   String AccessLevel = 'Read';    
    String  originalTypeName='led';   
    List<sObject> scope=new list<sObject>();
    List<sObject> crmCodeList=new list<sObject>();
    Test.startTest();
    SharingDataHandlerBase sh=new SharingDataHandlerBase(originalTypeName,AccessLevel);
    sh.filterDealer(scope);
    sh.executeProcessByCRMCode(crmCodeList);
    Test.stopTest();
   system.assertNotEquals(null, sh);
}
}