@isTest
public without sharing class VehiclePickerForCaseControllerTest{
    
    
	private static Case testCase;
    private static Vehicle__c testVehicleMB;
    private static Vehicle__c testVehicle_VehicleProduct;
    private static List<Car_Model__c> carModels;
    private static List<Map<String, Set<String>>> carModelMap;
    private static List<String> vehicleTypes = new List<String> {'Interested Vehicle', 'Competitor Vehicle', 'CurrentVehicle1', 'CurrentVehicle2', 'TradeIn', 'Purchased'};
    
    
    public static void createTestData(){
    
    /********************* CREATING TEST DATA : START **************************/
        
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;

        UtilConstant utilConst = new UtilConstant();     
        testCase = (Case)UtilTestData.createSobject(new Case(), UtilConstant.SALES_LEADS);
        system.debug('Leads... :' +testCase);
        
        testVehicleMB = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(), UtilConstant.MB);
        system.debug('Test Vehicle1' +testVehicleMB);                                              
        
        testVehicle_VehicleProduct = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(), utilConst.VEHICLE_PRODUCT);
        system.debug('Test Vehicle2' +testVehicle_VehicleProduct);
        
        //Create Car Models
        List<String> carStatus = new List<String>{'Own Sellable', 'Own Non Sellable','Competitor'};
        List<String> brands = new List<String>{'AMG','Others','TRUCKS','Maybach'};
        List<String> classes = new List<String>{'A-CLASS','B-CLASS','C-CLASS','C-CLASS'};
        List<String> models = new List<String>{'A160','A180','B200','C200K Elegance'};
        
        carModels = new List<Car_Model__c>();
        for (Integer i=0; i<4; i++){
            carModels.add(new Car_Model__c());
        }
        carModels = (List<Car_Model__c>)UtilTestData.createSobjects(carModels, '');
        system.debug('Car Models :' +carModels);
        
        for (Integer i=0; i<4; i++){
        
            if (i<3){
                carModels[i].Status__c = carStatus[i];
            }
            carModels[i].Brand__c = brands[i];
            carModels[i].Series__c = classes[i];
            carModels[i].Model__c = models[i];
            carModels[i].Name = models[i];
        }
        update carModels;
        system.debug('Updated Car Models...' +carModels);
    }
    
    
    public static testMethod void testCarModels(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        
        carModelMap = VehiclePickerForCaseController.getCarModels('None');
        system.debug('All Car Models :' +carModelMap);
        Map<String, Set<String>> tempMap = carModelmap[0];
        System.debug('Size of the Car Model Map :' +tempMap.size());
        test.StopTest();
        System.assertEquals(tempMap.size(),4);
          
    }
    public static testMethod void testCarModels1(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        carModelMap = VehiclePickerForCaseController.getCarModels('Competitor');
        system.debug('Competitor Car Models :' +carModelMap);
        Map<String, Set<String>> tempMap = carModelmap[0];
        System.debug('Size of the Car Model Map :' +tempMap.size());
        test.StopTest();
        System.assertEquals(tempMap.size(),1);
    }
    public static testMethod void testCarModels2(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        carModelMap = VehiclePickerForCaseController.getCarModels('Own Sellable');
        system.debug('Own Sellable Car Models :' +carModelMap);
        Map<String, Set<String>> tempMap = carModelmap[0];
        System.debug('Size of the Car Model Map :' +tempMap.size());
        test.StopTest();
        System.assertEquals(tempMap.size(),1);
    }
    public static testMethod void testCarModels3(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        carModelMap = VehiclePickerForCaseController.getCarModels('Own Non Sellable');
        system.debug('Own Non Sellable Car Models :' +carModelMap);
        Map<String, Set<String>> tempMap = carModelmap[0];
        System.debug('Size of the Car Model Map :' +tempMap.size());
        test.StopTest();
        System.assertEquals(tempMap.size(),1);
    }
       
    public static testMethod void testCreateNewVehicle(){
    
        /***************** NEW VEHICLE ****************/
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        test.startTest();
        for (String vehicle : vehicleTypes){
        
            String caseId = testCase.Id;
            String vehicleDetials;      
            Map<String,String> tempMap_New = new Map<String,String>();
            tempMap_New.put('Brand','AMG');
            tempMap_New.put('Class','A-CLASS');
            tempMap_New.put('Model','A160');
            tempMap_New.put('Colour','Green');
            tempMap_New.put('Trim','Yellow');
            tempMap_New.put('Operation','New');
            tempMap_New.put('Lookup','false');
            tempMap_New.put('Mileage','45');
            tempMap_New.put('CurrentRecordId',caseId);
            tempMap_New.put('CaseVehicleType',vehicle);
            vehicleDetials = JSON.serialize(tempMap_New);
            VehiclePickerForCaseController.updateVehicleDetails(vehicleDetials);
            
            Case caseDetails;
            Vehicle__c case_VehicleDetails;
            if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                caseDetails = [Select Interested_Vehicle__c from Case where Id =:testCase.Id];
                case_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:caseDetails.Interested_Vehicle__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
                caseDetails = [Select Interested_Competitor_Vehicle__c from Case where Id =:testCase.Id];
                case_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:caseDetails.Interested_Competitor_Vehicle__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                caseDetails = [Select Current_Vehicle_1__c from Case where Id =:testCase.Id];
                case_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c from Vehicle__c Where Id =:caseDetails.Current_Vehicle_1__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                caseDetails = [Select Current_Vehicle_2__c from Case where Id =:testCase.Id];
                case_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:caseDetails.Current_Vehicle_2__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                caseDetails = [Select Trade_In_Vehicle__c from Case where Id =:testCase.Id];
                case_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:caseDetails.Trade_In_Vehicle__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                caseDetails = [Select Purchased_Vehicle__c from Case where Id =:testCase.Id];
                case_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:caseDetails.Purchased_Vehicle__c];
            }
                
            
            System.assertEquals(case_VehicleDetails.Brand__c,'AMG');
            System.assertEquals(case_VehicleDetails.Class__c,'A-Class');
            System.assertEquals(case_VehicleDetails.Model_Description__c,'A160');
            System.assertEquals(case_VehicleDetails.Colour__c,'Green');
            System.assertEquals(case_VehicleDetails.Trim__c,'Yellow');
            System.assertEquals(case_VehicleDetails.NextMileage__c,45);
            
            
            /************** EDIT VEHICLE **************/
            Map<String,String> tempMap_Edit = new Map<String,String>();
            tempMap_Edit.put('Brand','Maybach');
            tempMap_Edit.put('Class','C-CLASS');
            tempMap_Edit.put('Model','C200K Elegance');
            tempMap_Edit.put('Colour','Green');
            tempMap_Edit.put('Trim','Yellow');
            tempMap_Edit.put('Operation','Edit');
            tempMap_Edit.put('Lookup','false');
            tempMap_Edit.put('Mileage','55');
            tempMap_Edit.put('CurrentRecordId',caseId);
            tempMap_Edit.put('CaseVehicleType',vehicle);
            vehicleDetials = JSON.serialize(tempMap_Edit);
            VehiclePickerForCaseController.updateVehicleDetails(vehicleDetials);
            
            if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                caseDetails = [Select Interested_Vehicle__c from Case where Id =:testCase.Id];
                case_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:caseDetails.Interested_Vehicle__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
                caseDetails = [Select Interested_Competitor_Vehicle__c from Case where Id =:testCase.Id];
                case_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:caseDetails.Interested_Competitor_Vehicle__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                caseDetails = [Select Current_Vehicle_1__c from Case where Id =:testCase.Id];
                case_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c from Vehicle__c Where Id =:caseDetails.Current_Vehicle_1__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                caseDetails = [Select Current_Vehicle_2__c from Case where Id =:testCase.Id];
                case_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:caseDetails.Current_Vehicle_2__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                caseDetails = [Select Trade_In_Vehicle__c from Case where Id =:testCase.Id];
                case_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:caseDetails.Trade_In_Vehicle__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                caseDetails = [Select Purchased_Vehicle__c from Case where Id =:testCase.Id];
                case_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c, Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:caseDetails.Purchased_Vehicle__c];
            }
            
            System.assertEquals(case_VehicleDetails.Brand__c,'Maybach');
            System.assertEquals(case_VehicleDetails.Class__c,'C-Class');
            System.assertEquals(case_VehicleDetails.Model_Description__c,'C200K Elegance');
            System.assertEquals(case_VehicleDetails.Colour__c,'Green');
            System.assertEquals(case_VehicleDetails.Trim__c,'Yellow');
            System.assertEquals(case_VehicleDetails.NextMileage__c,55);
    
        }
        test.stopTest();
        
    }
    
    public static testMethod void testLookupVehicle(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        Map<String,String> tempMap = new Map<String,String>();
        for(String vehicle : vehicleTypes){
            tempMap.put('Id',testVehicleMB.Id);
            tempMap.put('VehicleType',vehicle);
            tempMap.put('Lookup','true');
            tempMap.put('CurrentRecordId',testCase.Id);
            String vehicleDetails = JSON.serialize(tempMap);
            system.debug('Vehicle Detials for Lookup...' +vehicleDetails);
            VehiclePickerForCaseController.updateVehicleDetails(vehicleDetails);
            Case caseDetails;
            
            if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                caseDetails = [Select Interested_Vehicle__c from Case where Id =:testCase.Id];
                System.assertEquals(caseDetails.Interested_Vehicle__c,testVehicleMB.Id);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                caseDetails = [Select Current_Vehicle_1__c from Case where Id =:testCase.Id];
                System.assertEquals(caseDetails.Current_Vehicle_1__c,testVehicleMB.Id);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                caseDetails = [Select Current_Vehicle_2__c from Case where Id =:testCase.Id];
                System.assertEquals(caseDetails.Current_Vehicle_2__c,testVehicleMB.Id);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                caseDetails = [Select Trade_In_Vehicle__c from Case where Id =:testCase.Id];
                System.assertEquals(caseDetails.Trade_In_Vehicle__c,testVehicleMB.Id);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                caseDetails = [Select Purchased_Vehicle__c from Case where Id =:testCase.Id];
                System.assertEquals(caseDetails.Purchased_Vehicle__c,testVehicleMB.Id);
            }
            
        }
        test.stopTest();
    }
    

    public static testMethod void testClearNewVehicle(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        test.startTest();
        for (String vehicle : vehicleTypes){
            String caseId = testCase.Id;
            String vehicleDetials;      
            Map<String,String> tempMap_New = new Map<String,String>();
            tempMap_New.put('Brand','AMG');
            tempMap_New.put('Class','A-CLASS');
            tempMap_New.put('Model','A160');
            tempMap_New.put('Colour','Green');
            tempMap_New.put('Trim','Yellow');
            tempMap_New.put('Operation','New');
            tempMap_New.put('Lookup','false');
            tempMap_New.put('Mileage','45');
            tempMap_New.put('CurrentRecordId',caseId);
            tempMap_New.put('CaseVehicleType',vehicle);
            vehicleDetials = JSON.serialize(tempMap_New);
            VehiclePickerForCaseController.updateVehicleDetails(vehicleDetials);
            
            Id recTypeId = UtilRecordType.getRecordTypeIdByName('Vehicle__c', 'Vehicle Product');
            Vehicle__c vehicle_VP = [Select Id from Vehicle__c Where RecordTypeId =:recTypeId];
            System.debug('Vehicle Before clear :' +vehicle_VP);
            
            Case caseDetails;
            //Clear the Vehicle:
            Map<String,String> clearVehicleDetails = new Map<String,String>();
            clearVehicleDetails.put('VehicleType',vehicle);
            clearVehicleDetails.put('CurrentRecordId',testCase.Id);
            VehiclePickerForCaseController.clearVehicleFromCase(JSON.serialize(clearVehicleDetails));
            
            if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                caseDetails = [Select Interested_Vehicle__c from Case where Id =:testCase.Id];
                system.debug('Cleared Vehicle Id:' +caseDetails.Interested_Vehicle__c);
                System.assertEquals(caseDetails.Interested_Vehicle__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
                caseDetails = [Select Interested_Competitor_Vehicle__c from Case where Id =:testCase.Id];
                System.assertEquals(caseDetails.Interested_Competitor_Vehicle__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                caseDetails = [Select Current_Vehicle_1__c from Case where Id =:testCase.Id];
                System.assertEquals(caseDetails.Current_Vehicle_1__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                caseDetails = [Select Current_Vehicle_2__c from Case where Id =:testCase.Id];
                System.assertEquals(caseDetails.Current_Vehicle_2__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                caseDetails = [Select Trade_In_Vehicle__c from Case where Id =:testCase.Id];
                System.assertEquals(caseDetails.Trade_In_Vehicle__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                caseDetails = [Select Purchased_Vehicle__c from Case where Id =:testCase.Id];
                System.assertEquals(caseDetails.Purchased_Vehicle__c,null);
            }
            
            Vehicle__c deletedVehicle;
            try{
                deletedVehicle = [Select Id from Vehicle__c Where RecordTypeId =:recTypeId];
                System.debug('Vehicle after clear :' +vehicle);
            }catch(Exception e){
                system.debug('vehicle cleared :' +deletedVehicle);
                System.assertEquals(deletedVehicle,null);
            }
            
        }
        test.StopTest();
    }
    
    
    
    public static testMethod void testLookupClear(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        Map<String,String> tempMap = new Map<String,String>();
        for(String vehicle : vehicleTypes){
        
            if (!vehicle.equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
                tempMap.put('Id',testVehicleMB.Id);
                tempMap.put('VehicleType',vehicle);
                tempMap.put('Lookup','true');
                tempMap.put('CurrentRecordId',testCase.Id);
                String vehicleDetails = JSON.serialize(tempMap);
                system.debug('Vehicle Detials for Lookup...' +vehicleDetails);
                VehiclePickerForCaseController.updateVehicleDetails(vehicleDetails);
                Case caseDetails;
                
                //Clear the Vehicle:
                Map<String,String> clearVehicleDetails = new Map<String,String>();
                clearVehicleDetails.put('VehicleType',vehicle);
                clearVehicleDetails.put('CurrentRecordId',testCase.Id);
                VehiclePickerForCaseController.clearVehicleFromCase(JSON.serialize(clearVehicleDetails));
                
               if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                    caseDetails = [Select Interested_Vehicle__c from Case where Id =:testCase.Id];
                    system.debug('Cleared Vehicle Id:' +caseDetails.Interested_Vehicle__c);
                    System.assertEquals(caseDetails.Interested_Vehicle__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                    caseDetails = [Select Current_Vehicle_1__c from Case where Id =:testCase.Id];
                    System.assertEquals(caseDetails.Current_Vehicle_1__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                    caseDetails = [Select Current_Vehicle_2__c from Case where Id =:testCase.Id];
                    System.assertEquals(caseDetails.Current_Vehicle_2__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                    caseDetails = [Select Trade_In_Vehicle__c from Case where Id =:testCase.Id];
                    System.assertEquals(caseDetails.Trade_In_Vehicle__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                    caseDetails = [Select Purchased_Vehicle__c from Case where Id =:testCase.Id];
                    System.assertEquals(caseDetails.Purchased_Vehicle__c,null);
                }
                
                Vehicle__c clearedVehicle;
                try{
                    clearedVehicle = [Select Id from Vehicle__c Where Id =:testVehicleMB.Id];
                    System.debug('Vehicle after clear :' +clearedVehicle);
                }catch(Exception e){
                    system.debug('Exeption encoutered :' +e.getMessage());
                }
            }
            
        }
        test.stopTest();
    }
    
    
    public static testMethod void testLookupSearch(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        
        //Creating associated data for search test.
        Account testAccount = (Account)UtilTestData.createSobject(new Account(), UtilConstant.person_Account);
        testCase.Contact__c = testAccount.Id;
        update testCase;
        
        String Vin = '87465345982346578';
        Vehicle__c testVIN_Vehicle = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(), UtilConstant.MB);
        testVIN_Vehicle.UsVIN__c = Vin;
        update testVIN_Vehicle;
        
        Vehicle__c testVR_vehicle = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(), UtilConstant.MB);
        Vehicle_Relationship__c testVR  = (Vehicle_Relationship__c)UtilTestData.createSobject(new Vehicle_Relationship__c(), UtilConstant.Vehicle_Relationship_Retail);
        testVR.Contact__c = testAccount.Id;
        testVR.Vehicle_ID__c = testVehicleMB.Id;
        update testVR;
        
        testVR_vehicle.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Vehicle__c', 'Self Registered');
        testVR_vehicle.Related_contact__c = testAccount.Id;
        update testVR_vehicle;
        
        test.startTest();
        for (String vehicle : vehicleTypes){
            if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE) || vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                //Search With VIN : Interested and Purchased:
                Map<String,String> searchDetails = new Map<String,String>();
                searchDetails.put('VIN',Vin);
                searchDetails.put('VehicleType',vehicle);
                searchDetails.put('RecordId',testCase.Id);
                List<Vehicle__c> resultVehicles = VehiclePickerForCaseController.searchVehicles(JSON.serialize(searchDetails));
                system.debug('Searched Vehicle :' +resultVehicles[0]);
                
                Vehicle__c tmpVehicle = [Select UsVIN__c from Vehicle__c Where Id =:resultVehicles[0].Id];
                system.debug('Vehicle VIn number :' +tmpVehicle.UsVIN__c);
                System.assertEquals(tmpVehicle.UsVIN__c,'87465345982346578');
                
            }else{
                Map<String,String> searchDetails = new Map<String,String>();
                searchDetails.put('VIN','');
                searchDetails.put('VehicleType',vehicle);
                searchDetails.put('RecordId',testCase.Id);
                List<Vehicle__c> resultVehicles = VehiclePickerForCaseController.searchVehicles(JSON.serialize(searchDetails));
                system.debug('Searched Other Vehicles:' +resultVehicles);
                system.debug('Searched Other Vehicles count:' +resultVehicles.size());
                System.assertEquals(resultVehicles.size(),2);
            }
        }
        test.StopTest();
    }
        
}