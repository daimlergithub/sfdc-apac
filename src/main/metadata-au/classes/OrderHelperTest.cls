/*
  Type:  Test Class for OrderHelper
  Purpose: To Autopopulate Vehicle Model class based on the Selected Vehicle Model Code 
*/


@isTest
public with sharing class OrderHelperTest {
Private static Account Customer;

private static String PersonRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

private static void createCustomerAccount(){
            Customer = new Account();
            Customer.RecordTypeId = PersonRecordtypeid;
			Customer.Salutation='Mr';
			Customer.FirstName='Satish';
			Customer.LastName = 'kumar';
			Customer.City__c='salem';
			Customer.Phone = '58396243'; 
			 
            insert Customer;
}
        
@istest(seealldata = false)	    
public static void OrderHelper2(){
   createCustomerAccount();
    
   Account Customer1=new Account();
   Customer1.RecordTypeId = PersonRecordtypeid;
   Customer1.Salutation='Lord';
   Customer1.FirstName='Mount';
   Customer1.LastName='Batten';
   Customer1.City__c='England';
   Customer1.Phone='58396200';
   
   insert Customer1;
   
   Vehicle_Class_mapping__c CusData=new Vehicle_Class_mapping__c();
   CusData.Name='W176';
   CusData.Vehicle_Model_Class__c='A-Class';
   insert CusData; 
    
   PreOrder__c po=new PreOrder__c();
   po.Customer__c=Customer.id;
   po.Vehicle_Model_Code__c='W176';
   po.Vehicle_Type__c='New-Corporate';
   po.Order_Type__c='In Stock';
   po.Status__c='Open';
   insert po;
   
   test.startTest();
    
   CusData.Name='W246';
   CusData.Vehicle_Model_Class__c='B-Class';
   update CusData;
 
   po.Customer__c=Customer1.id;
   po.Vehicle_Model_Code__c='W246';
   po.Vehicle_Type__c='New-Private';
   po.Order_Type__c='Back Order';
   po.Status__c='Open - Awaiting Allocation';
   update po;
   
   test.stopTest();
    }    
}