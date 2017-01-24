@isTest
Public class TerminateVehicleRelationshipTest{
Public static Vehicle__c objVehicle;
Public static Vehicle_Relationship__c objVehicleRelship;
Public static Account objAccount;
public static Id personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
public static Id VehicleMBRecordtypeid = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
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
        objAccount=new Account(RecordTypeId=personRecordtypeid,LastName='Pref chck test',Gender__c = 'Male',Occupation__c = 'Others',Phone = '09088767547',Province__c = 'Province1',Primary_Address__c = 'sdfsdfsdfsdf',
                                City__c = 'asdfsf',ZipCode__c = '1234567',MBK_Data_Source__c='Email',Mobile__c = '000-0000-9642');
        //objAccount=(Account)UtilViewHierarchyTestData.createSobject(new Account(),UtilViewHierarchyTestData.ACCOUNT_RT_PERSON_ACCOUNT); 
        insert objAccount;
        // Create Vehicle 
        objVehicle=new Vehicle__c(RecordTypeId=VehicleMBRecordtypeid,Brand__c = 'Maybach',Class__c = 'A-Class',Model__c = 'A160',UsVIN__c = '46578934237654873',EuroVIN__c = '362534778873636924',Latest_Sales_Person__c = 'Shantaram',
                                   Warranty_Start_Date__c = Date.today(),FirstRegistrationDate__c = Date.today(),Purchase_Month__c ='02',Purchase_Year__c = '2004',RegistrationNo__c = '12345');                    
        //objVehicle=(Vehicle__c)UtilViewHierarchyTestData.createSobject(new Vehicle__c(), UtilViewHierarchyTestData.VEHICLE_MB); 
        insert objVehicle;
        // Create Vehicle Relationship
        objVehicleRelship= new Vehicle_Relationship__c();
        objVehicleRelship.Vehicle_ID__c = objVehicle.Id;
        objVehicleRelship.Contact__c = objAccount.Id;
        objVehicleRelship.Car_Relation__c='Owner';
        objVehicleRelship= (Vehicle_Relationship__c)UtilViewHierarchyTestData.createSobject(objVehicleRelship,UtilViewHierarchyTestData.VEHICLE_RELATIONSHIP);
   }   
}