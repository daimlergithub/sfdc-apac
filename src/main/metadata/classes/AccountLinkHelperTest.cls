@isTest
private class AccountLinkHelperTest {

  public static testMethod void test_nameParsing()
  {
	  List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
      insert updatecustomsettings;
	  
      string crmcode ;
      string name =  'nameDMS-';
      test.startTest();
      String testStr = AccountLinkHelper.nameParsing('nameDMS-');
      test.stopTest();
      name = name.substring(name.indexOf('DMS-'));
      crmCode = name.substring(name.lastIndexOf('-') - 2, name.lastIndexOf('-'));
      system.assertEquals(crmCode, testStr);
  }

}