/**
** Test class for ViewHierarchyController  
** Created By: Sneha Chail
** Date: 2015-12-11(yyyy-mm-dd)
**/
@isTest
Public class ViewHierarchyControllerTest{
//Variable Declaration
Public static Retail_Task__c objRetailTask;
Public static Vehicle__c objVehicle;
Public static Vehicle_Relationship__c objVehicleRelship;
Public static Account objAccount;
Public static Account_Link__c objAccountLink;

// "getmainnodes" method will be called
  public static testMethod void getmainnodesTest()
     {
      init();
      ApexPages.currentPage().getParameters().put(system.label.Id,objAccount.id);     
      ApexPages.StandardController objAcc = new ApexPages.StandardController(objAccount);
      ViewHierarchyController objAccountController = new ViewHierarchyController(objAcc);
      // Start Test
        Test.startTest();
         objAccountController.getmainnodes();         
       // Stop Test 
       Test.stopTest();  
       system.assert(objAccountController.getmainnodes()!=Null);    
    }
   // "getAccountRelation" method will be called....
   public static testMethod void getAccountRelationTest()
     {
      init();
      ApexPages.currentPage().getParameters().put(system.label.Id,objAccount.id);     
      ApexPages.StandardController objAcc = new ApexPages.StandardController(objAccount);
      ViewHierarchyController objAccountController = new ViewHierarchyController(objAcc);
      // Start Test
        Test.startTest();
         objAccountController.getAccountRelation();         
       // Stop Test 
       Test.stopTest();    
       system.assert(objAccountController.getAccountRelation()!=Null);      
    }
 
// creating records 
  public static void init()
    {  
        // Create Account
        objAccount=new Account();
        objAccount=(Account)UtilViewHierarchyTestData.createSobject(new Account(Mobile__c ='09865234112'),UtilViewHierarchyTestData.ACCOUNT_RT_PERSON_ACCOUNT);
        // Create Vehicle 
        objVehicle=new Vehicle__c();                    
        objVehicle=(Vehicle__c)UtilViewHierarchyTestData.createSobject(new Vehicle__c(Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345'), UtilViewHierarchyTestData.VEHICLE_MB);        
        // Create Vehicle Relationship
        objVehicleRelship= new Vehicle_Relationship__c();
        objVehicleRelship.Vehicle_ID__c = objVehicle.Id;
        objVehicleRelship.Contact__c = objAccount.Id;
        objVehicleRelship.Car_Relation__c='Owner';
        objVehicleRelship= (Vehicle_Relationship__c)UtilViewHierarchyTestData.createSobject(objVehicleRelship,UtilViewHierarchyTestData.VEHICLE_RELATIONSHIP);
        objRetailTask= new Retail_Task__c();
        objRetailTask.Related_Vehicle__c = objVehicle.Id;
        objRetailTask.Name = 'Test Retail Task';
        objRetailTask= (Retail_Task__c)UtilViewHierarchyTestData.createSobject(objRetailTask,UtilConstant.RECORDTYPE_CONTRACT);
        objAccountLink= new Account_Link__c();
        objAccountLink.toRole__c=objAccount.Id;
        objAccountLink= (Account_Link__c)UtilViewHierarchyTestData.createSobject(objAccountLink,UtilConstant.Contact2Contact);       
   }   
}