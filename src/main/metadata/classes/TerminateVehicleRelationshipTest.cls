@isTest
Public class TerminateVehicleRelationshipTest{
Public static Vehicle__c objVehicle;
Public static Vehicle_Relationship__c objVehicleRelship;
Public static Account objAccount;

  // Calling "Save" method
   public static testMethod void SaveTest()
     {

      init();
      ApexPages.currentPage().getParameters().put(system.label.Id,objVehicle.id);     
      ApexPages.StandardController objSc = new ApexPages.StandardController(objVehicle);
      TerminateVehicleRelationshipExtension objVehicleController = new TerminateVehicleRelationshipExtension(objSc);
      // Start Test
        Test.startTest();
        objVehicleRelship.End_Date__c=system.today(); 
        objVehicleRelship.End_Setting_User__c=UserInfo.getUserId();
        objVehicleRelship.End_Setting_DateTime__c=system.now();            
        PageReference redirectSuccess=objVehicleController.Save();         
       // Stop Test 
       Test.stopTest();
       String vehicleId=objVehicle.Id;
       system.assertEquals(redirectSuccess.getURL(),'/'+vehicleId.substring(0,15));     
       system.assertEquals(objVehicleRelship.End_Setting_User__c,UserInfo.getUserId());
       system.assertEquals(Date.valueOf(objVehicleRelship.End_Setting_DateTime__c),Date.valueOf(system.now()));
    }
  // Calling "cancel method
    public static testMethod void cancelTest()
     {
       init();
       ApexPages.currentPage().getParameters().put(system.label.Id,objVehicle.id);     
       ApexPages.StandardController objSc = new ApexPages.StandardController(objVehicle);
       TerminateVehicleRelationshipExtension objVehicleController = new TerminateVehicleRelationshipExtension(objSc);
       // Start Test
       Test.startTest();
       PageReference redirectSuccess=objVehicleController.Cancel();         
       // Stop Test 
       Test.stopTest();
       String vehicleId=objVehicle.Id;
       system.assertEquals(redirectSuccess.getURL(),'/'+vehicleId.substring(0,15));      
     }  
 // creating records 
  public static void init()
    {  
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
		 insert updatecustomsettings;
        // Create Account
        objAccount=new Account();
        objAccount=(Account)UtilViewHierarchyTestData.createSobject(new Account(),UtilViewHierarchyTestData.ACCOUNT_RT_PERSON_ACCOUNT); 
        // Create Vehicle 
        objVehicle=new Vehicle__c();                    
        objVehicle=(Vehicle__c)UtilViewHierarchyTestData.createSobject(new Vehicle__c(), UtilViewHierarchyTestData.VEHICLE_MB); 
        // Create Vehicle Relationship
        objVehicleRelship= new Vehicle_Relationship__c();
        objVehicleRelship.Vehicle_ID__c = objVehicle.Id;
        objVehicleRelship.Contact__c = objAccount.Id;
        objVehicleRelship.Car_Relation__c='Owner';
        objVehicleRelship= (Vehicle_Relationship__c)UtilViewHierarchyTestData.createSobject(objVehicleRelship,UtilViewHierarchyTestData.VEHICLE_RELATIONSHIP);
   }   
}