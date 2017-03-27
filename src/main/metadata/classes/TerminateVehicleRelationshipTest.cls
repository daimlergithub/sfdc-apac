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
      TerminateVehicleRelationshipExtension extveh=new TerminateVehicleRelationshipExtension();
      // Start Test
        Test.startTest();
                   
       PageReference redirectSuccess=extveh.SaveRecords();         
       // Stop Test 
       Test.stopTest();
       String vehicleId=objVehicle.Id;
     system.assertNotequals(vehicleId,null);  
     
    }
  // Calling "cancel method
    public static testMethod void cancelTest()
     {
       init();
        ApexPages.currentPage().getParameters().put(system.label.Id,objVehicle.id);     
       TerminateVehicleRelationshipExtension objVehicleController = new TerminateVehicleRelationshipExtension();
       TerminateVehicleRelationshipExtension extob=new TerminateVehicleRelationshipExtension();
       // Start Test
       Test.startTest();
       PageReference redirectSuccess=extob.cancelpage();         
       // Stop Test 
       Test.stopTest();
       String vehicleId=objVehicle.Id;  
            system.assertNotequals(vehicleId,null); 
     }  
 // creating records 
  public static void init()
    {  
       /* List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
         insert updatecustomsettings;*/
        // Create Account
        objAccount=new Account(RecordTypeId=personRecordtypeid,LastName='Pref chck test',Gender__c = 'Male',Occupation__c = 'Others',Phone = '09088767547',Province__c = 'Province1',Primary_Address__c = 'sdfsdfsdfsdf',
                                City__c = 'asdfsf',ZipCode__c = '1234567',MBK_Data_Source__c='Email',Mobile__c = '09908832174');
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
        objVehicleRelship.End_Reason__c='None';
        objVehicleRelship= (Vehicle_Relationship__c)UtilViewHierarchyTestData.createSobject(objVehicleRelship,UtilViewHierarchyTestData.VEHICLE_RELATIONSHIP);
   }   
   public static testMethod void endReasonTest()
   {
        
        /* List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
         insert updatecustomsettings;*/
         
          init();
        ApexPages.currentPage().getParameters().put(system.label.Id,objVehicle.id);
   List<SelectOption> countryOptions = new List<SelectOption>();
        countryOptions.add(new SelectOption('','-None-'));
        countryOptions.add(new SelectOption('Replacement','Replacement'));
        countryOptions.add(new SelectOption('Bought Competitors','Bought Competitors'));
        countryOptions.add(new SelectOption('Sold','Sold'));
        countryOptions.add(new SelectOption('Handover','Handover'));
        countryOptions.add(new SelectOption('Warranty system','Warranty system'));
         countryOptions.add(new SelectOption('MB Online','MB Online'));
          countryOptions.add(new SelectOption('DMS','DMS'));
          countryOptions.add(new SelectOption('Others','Others'));
        TerminateVehicleRelationshipExtension tr = new TerminateVehicleRelationshipExtension();
       Test.startTest();
       List<SelectOption> method_options = tr.getEndReason();
       Test.stopTest();
     
     system.assertEquals(method_options.size(),countryOptions.size());
   
   }
}