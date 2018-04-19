/************************************************************************************
* Created By:Sarath M
* Created Date:23-Sept-2017
* Company:Infosys Ltd
* Description: Testclass for CustomSelfRegController 
* **********************************************************************************/
@isTest
private class CustomSelfRegControllerTest{
  static testMethod void test_registerUser_UseCase1(){
    List<Registered_Users__c> registered_users_Obj  =  [SELECT id,first_name__c,last_name__c from Registered_Users__c limit 1];
    Registered_Users__c regUser=new Registered_Users__c(last_Name__c='test1',emailId__c='test@infy.com',first_Name__c='test');
    system.assertNotEquals(null, regUser!=null);
    CustomSelfRegController obj01 = new CustomSelfRegController(new ApexPages.StandardController(regUser));
    obj01.registerUser();
    obj01.navigateurl();
    obj01.getPickListValues('Registered_Users__c','region__c');
  }
 
}