@isTest
public class RetailTask2Test
{
private static Id contractid=Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Contract').getRecordTypeId();
public static Retail_Task__c retailobj;
public static Testmethod void ValidateRetailTask2()
{
init();
test.startTest();
ApexPages.StandardController retaill = new ApexPages.StandardController(retailobj);
RetailTask2 trobj  = new RetailTask2(retaill);   
test.stopTest();
}
public static void init()
{
retailobj=new Retail_Task__c();
retailobj.Latest_Sales_Person__c='Test';
retailobj.Contractor_Name__c='Test1';
retailobj.Contractor_Name_Native__c='Test2';
retailobj.Vehicle_Registration_No__c='Test3';
retailobj.Contractor_ZipCode1__c='Test4';
retailobj.Contractor_Address1__c='Test5';
retailobj.MOT_User_Name__c='Test6';
retailobj.MOT_User_Name_Native__c='Test7';
retailobj.MOT_User_Postal__c='Test8';
retailobj.MOT_User_Address__c='Test9';
retailobj.MOT_User_Phone__c='Test10';
retailobj.MOT_Owner_Name__c='Test11';
retailobj.MOT_Owner_Name_Native__c='Test12';
retailobj.MOT_Owner_Address__c='Test123';
insert retailobj;
}
}