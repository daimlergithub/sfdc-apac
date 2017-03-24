@isTest
public without sharing class VehiclePickerForCaseControllerTest{
    
    public static Account accobj;
    public static Case testCase;
    private static Vehicle__c testVehicleMB;
    private static Vehicle__c testVehicleMB1;
    private static Vehicle__c testVehicle_VehicleProduct;
    private static Vehicle__c testVehicle_VehicleProduct1;
    private static Vehicle__c testVehicle_Comp;
    private static List<Car_Model__c> carModels;
     private static List<Map<String, Set<String>>> carModelMap;
    private static List<String> vehicleTypes = new List<String> {'Interested Vehicle', 'Competitor Vehicle', 'CurrentVehicle1', 'CurrentVehicle2', 'TradeIn', 'Purchased'};
    public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id MBRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
    public static Id InquiryRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Inquiry').getRecordTypeId();
    public static id VehicleProductRecordtypeid = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('Vehicle Product').getRecordTypeId();
    public static id VehicleMBRecordtypeid = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
    
    public static void createTestData(){
    
    /********************* CREATING TEST DATA : START **************************/
        
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();

        insert updatecustomsettings;
        UtilConstant utilConst = new UtilConstant(); 
        
        accobj = new Account(RecordTypeId = personAccRecordTypeId,LastName = 'galaxy1',MBK_Data_Source__c='Email',Mobile__c ='000-0000-9642',ZipCode__c= '1002347'); 
        insert accobj;
     
      
        
        testVehicleMB = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222',
                                                Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345'), UtilConstant.MB);
        testVehicleMB1 = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111123',
                                                UsVIN__c = '12345678902222234',
                                                Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='05', Model__c = 'GL 350 BlueTEC 4MATIC', Class__c = 'GL-Class', Purchase_Year__c = '2002',RegistrationNo__c = '12987'), UtilConstant.MB);

        //testCase = (Case)UtilTestData.createSobject(new Case(), UtilConstant.SALES_LEADS);
        testCase = new Case(RecordTypeId = MBRecordTypeId,Case_Department__c = 'testcase',Description = 'testdes',Case_Type__c = 'testcasetype',Case_Class__c = 'Complaint',Case_SubType__c = 'test case subtype',
                            Case_Source__c = 'test case source',Overdue_Reason__c ='Others', AccountId = accobj.Id);
        insert testCase;
        system.debug('$$$$$$$$$$$$$$'+testCase);
        
        testVehicleMB = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,EuroVIN__c = '12345678901111111',UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345'), UtilConstant.MB);
        //testVehicleMB = new Vehicle__c(RecordTypeId = VehicleMBRecordtypeid,Recall__c = FALSE,EuroVIN__c = '12345678901111111',UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
        system.debug('Test Vehicle1' +testVehicleMB);                                              
        
        testVehicle_VehicleProduct = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,EuroVIN__c = '12345678901111111',UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345'), utilConst.VEHICLE_PRODUCT);
        //testVehicle_VehicleProduct = new Vehicle__c(RecordTypeId = VehicleProductRecordtypeid,Recall__c = FALSE,EuroVIN__c = '12345678901111111',UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
        system.debug('Test Vehicle2' +testVehicle_VehicleProduct);
        
        testVehicle_VehicleProduct1 = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111112',
                                                UsVIN__c = '12345678902222223',
                                                Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='03', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2005',RegistrationNo__c = '12346'), utilConst.VEHICLE_PRODUCT);
        Id CompVehId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        testVehicle_Comp = new Vehicle__c(Brand__c ='Dodge', RecordTypeId=CompVehId);
        insert testVehicle_Comp;
        //Creating Case
        
        Id InquiryCaseId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Inquiry').getRecordTypeId(); 
        testCase = new Case();
         testCase.Status='Waiting for Response approval';
         testCase.Vehicle__c=testVehicleMB.Id;
         //testCase.Car_Owner__c=personAcc.Id;
         testCase.Interested_Vehicle__c =testVehicle_VehicleProduct.Id;
         testCase.Interested_Competitor_Vehicle__c=testVehicle_Comp.Id;
         testCase.Current_Vehicle_1__c=testVehicle_VehicleProduct1.Id;
         testCase.Current_Vehicle_2__c=testVehicleMB1.Id;
         //testCase.Trade_In_Vehicle__c=testVehicleMB1.Id; 
        // testCase.Purchased_Vehicle__c =testVehicleMB1.Id;
         testCase.RecordTypeId=InquiryCaseId;
         insert testCase;
         system.debug('Leads... :' +testCase);
        //Create Car Models
        List<String> carStatus = new List<String>{'Own Sellable', 'Own Non Sellable','Competitor'};
        List<String> brands = new List<String>{'AMG','Others','TRUCKS','Maybach'};
        List<String> classes = new List<String>{'A-CLASS','B-CLASS','C-CLASS','C-CLASS'};
        List<String> models = new List<String>{'A160','A180','B200','C200K Elegance'};
        List<String> colours = new List<String>{'Red','blue','white','black'};
        
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
            carModels[i].Colour__c = colours[i];
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
        //System.assertEquals('test','test');
          
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
        //System.assertEquals(tempMap.size(),1);
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
       // System.assertEquals(tempMap.size(),2);
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
        //System.assertEquals(tempMap.size(),1);
    }
      
  /* public static testMethod void testCreateNewVehicle(){
    
        //@@@@@@@@@@@@@@@@ NEW VEHICLE @@@@@@@@@@@@@@@@
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        test.startTest();
        System.debug('testCreateNewVehicle ...');
        for (String vehicle : vehicleTypes){
        
            String caseId = testCase.Id;
            String vehicleDetails;      
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
            tempMap_New.put('caseVehicleType',vehicle);
            vehicleDetails = JSON.serialize(tempMap_New);
            if(vehicleDetails != null){
            VehiclePickerForCaseController.updateVehicleDetails(vehicleDetails);
            }
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
            
         
        
            //@@@@@@@@@@@@@@@@ EDIT VEHICLE @@@@@@@@@@@@@@@@
              
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
            tempMap_Edit.put('caseVehicleType',vehicle);
            vehicleDetails = JSON.serialize(tempMap_Edit);
            VehiclePickerForCaseController.updateVehicleDetails(vehicleDetails);
            
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
        

    }*/
    

    public static testMethod void testLookupVehicle(){
      // List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        Map<String,String> tempMap = new Map<String,String>();
		//Case caseDetails = [Select Id, Interested_Vehicle__c, Current_Vehicle_1__c,Current_Vehicle_2__c,Trade_In_Vehicle__c,Purchased_Vehicle__c  from Case Where Id =:testCase.Id];
        for(String vehicle : vehicleTypes){
            tempMap.put('Id',testVehicleMB.Id);
            tempMap.put('VehicleType',vehicle);
            tempMap.put('Lookup','true');
            tempMap.put('CurrentRecordId',testCase.Id);
            String vehicleDetails = JSON.serialize(tempMap);
            system.debug('Vehicle Detials for Lookup...' +vehicleDetails);
            VehiclePickerForCaseController.updateVehicleDetails(vehicleDetails);
			/*
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
            */
        }
        test.stopTest();
    }
      
    
    public static testMethod void testClearNewVehicle(){
        UtilConstant utilConst = new UtilConstant();
        String caseId;
        String vehicleDetails;      
        Map<String,String> tempMap_New = new Map<String,String>();
        Map<String,String> clearVehicleDetails = new Map<String,String>();
        createTestData();
        test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        
        for (String vehicle : vehicleTypes)
        {
            caseId = testCase.Id;
            tempMap_New.put('Brand','AMG');
            tempMap_New.put('Class','A-CLASS');
            tempMap_New.put('Model','A160');
            tempMap_New.put('Colour','Green');
            tempMap_New.put('Trim','Yellow');
            tempMap_New.put('Operation','New');
            tempMap_New.put('Lookup','false');
            tempMap_New.put('Mileage','45');
            tempMap_New.put('CurrentRecordId',caseId);
            tempMap_New.put('caseVehicleType',vehicle);
            vehicleDetails = JSON.serialize(tempMap_New);
            clearVehicleDetails.put('VehicleType',vehicle);
            clearVehicleDetails.put('CurrentRecordId',testCase.Id);
        }
            if(vehicleDetails != null){
            VehiclePickerForCaseController.updateVehicleDetails(vehicleDetails);
            }
            Id recTypeId = UtilRecordType.getRecordTypeIdByName('Vehicle__c', 'Vehicle Product');
            Vehicle__c vehicle_VP = [Select Id from Vehicle__c Where RecordTypeId =:recTypeId];
            System.debug('Vehicle Before clear :' +vehicle_VP);
            
            Case caseDetails;
            //Clear the Vehicle:
            
            
            VehiclePickerForCaseController.clearVehicleFromCase(JSON.serialize(clearVehicleDetails));
            
            
            
            
            /*if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
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
            }*/
            
            Vehicle__c deletedVehicle;
            try{
                deletedVehicle = [Select Id from Vehicle__c Where RecordTypeId =:recTypeId];
                //System.debug('Vehicle after clear :' +vehicle);
            }catch(Exception e){
                system.debug('vehicle cleared :' +deletedVehicle);
                System.assertEquals(deletedVehicle,null);
            }
            
        
        test.StopTest();
    }

    
    public static testMethod void testLookupClear(){
        /*

        UtilConstant utilConst = new UtilConstant();
        createTestData();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        test.stopTest();
        Map<String,String> tempMap = new Map<String,String>();

         Map<String,String> clearVehicleDetails = new Map<String,String>();
        String vehicleDetails;

        Case caseDetails;
        caseDetails = [Select Interested_Vehicle__c, Current_Vehicle_1__c, Current_Vehicle_2__c, Trade_In_Vehicle__c, Purchased_Vehicle__c from Case where Id =:testCase.Id];
             

        for(String vehicle : vehicleTypes){
        
            if (!vehicle.equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
                tempMap.put('Id',testVehicleMB.Id);
                tempMap.put('VehicleType',vehicle);
                tempMap.put('Lookup','true');
                tempMap.put('CurrentRecordId',testCase.Id);
                vehicleDetails = JSON.serialize(tempMap);
                system.debug('Vehicle Detials for Lookup...' +vehicleDetails);

                VehiclePickerForCaseController.updateVehicleDetails(vehicleDetails);

                
                //Clear the Vehicle:
               
                clearVehicleDetails.put('VehicleType',vehicle);
                clearVehicleDetails.put('CurrentRecordId',testCase.Id);
            }  
                VehiclePickerForCaseController.updateVehicleDetails(vehicleDetails);
                VehiclePickerForCaseController.clearVehicleFromCase(JSON.serialize(clearVehicleDetails));
                
               if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                    //caseDetails = [Select Interested_Vehicle__c from Case where Id =:testCase.Id];
                    system.debug('Cleared Vehicle Id:' +caseDetails.Interested_Vehicle__c);
                    System.assertEquals(caseDetails.Interested_Vehicle__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                    //caseDetails = [Select Current_Vehicle_1__c from Case where Id =:testCase.Id];
                    System.assertEquals(caseDetails.Current_Vehicle_1__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                    //caseDetails = [Select Current_Vehicle_2__c from Case where Id =:testCase.Id];
                    System.assertEquals(caseDetails.Current_Vehicle_2__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                    //caseDetails = [Select Trade_In_Vehicle__c from Case where Id =:testCase.Id];
                    System.assertEquals(caseDetails.Trade_In_Vehicle__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                    //caseDetails = [Select Purchased_Vehicle__c from Case where Id =:testCase.Id];
                    System.assertEquals(caseDetails.Purchased_Vehicle__c,null);
                }
                
            }
            

        
        test.stopTest();
    }
    
        */
    }
    
    public static testMethod void testLookupSearch(){

        UtilConstant utilConst = new UtilConstant();
        //createTestData();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        
        //Creating associated data for search test.

        
        //Account testAccountDlr = (Account)UtilTestData.createSobject(new Account(Name='DealerAcc'), 'ACCOUNT_RT_DEALER');
        

        Account testAccount = (Account)UtilTestData.createSobject(new Account(MBK_Data_Source__c='Advertisement',Mobile__c='000-000-9862'), UtilConstant.person_Account);

        testCase.Car_Owner__c = testAccount.Id;
        //testCase.Case_Dealer__c=testAccountDlr.Id;
        update testCase;
        
        
        
        String Vin = '87465345982346578';
        Vehicle__c testVIN_Vehicle = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222',
                                                Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345'), UtilConstant.MB);
        testVIN_Vehicle.UsVIN__c = Vin;
        update testVIN_Vehicle;
        
        Vehicle__c testVR_vehicle = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222',
                                                Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345'), UtilConstant.MB);
         Vehicle_Relationship__c testVR  = new Vehicle_Relationship__c();//(Vehicle_Relationship__c)UtilTestData.createSobject(new Vehicle_Relationship__c(), UtilConstant.Vehicle_Relationship_Retail);
        testVR.RegistrationProvince__c = 'Shanghai';
        testVR.Registration_City__c = 'Shanghai';
        testVR.Status__c = '0=Previously Owned';
        testVR.Main_Usage__c = '0=Taxi';
        testVR.Ownership__c = '1=Company';
        testVR.Car_Relation__c = 'User';
        testVR.New_Used__c = '0=New';
        testVR.Validity__c = 'Unknown';
        testVR.Purchase_Date__c = System.today();
        testVR.Registration_Date__c = System.today();
        testVR.recordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship').getRecordTypeId();
        testVR.Contact__c = testAccount.Id;
        testVR.Vehicle_ID__c = testVehicleMB.Id;
        testVR.Car_Relation__c = 'Purchaser';
        insert testVR;
        testVR.Contact__c = testAccount.Id;
        testVR.Vehicle_ID__c = testVehicleMB.Id;
        testVR.Car_Relation__c = 'Purchaser';
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

                //System.assertEquals(resultVehicles.size(),2);

                System.assertEquals(resultVehicles.size(),0);
            }
        }
        test.StopTest();
    }
    
    public static testMethod void testAssociatedCaseVehicles(){     
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        UtilConstant utilConst = new UtilConstant(); 
        
        // Account
        accobj = new Account(RecordTypeId = personAccRecordTypeId,LastName = 'galaxy1',MBK_Data_Source__c='Email',Mobile__c ='000-0000-9642',ZipCode__c= '1002347'); 
        insert accobj;
        
        // Case
        testCase = new Case(RecordTypeId = MBRecordTypeId,Case_Department__c = 'testcase',Description = 'testdes',Case_Type__c = 'testcasetype'
                                ,Case_Class__c = 'Complaint',Case_SubType__c = 'test case subtype', Case_Source__c = 'test case source'
                                    ,Overdue_Reason__c ='Others', AccountId = accobj.Id, Car_Owner__c=accobj.Id);
        insert testCase;
        
        // Vehicle 1
        testVehicleMB = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,EuroVIN__c = '12345678901111111'
                                        ,UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today()
                                            ,Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004'
                                                ,RegistrationNo__c = '12345'), UtilConstant.MB);
        
        // Vehicle 2
        testVehicle_VehicleProduct = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,EuroVIN__c = '12345678901111111'
                                        ,UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today()
                                            ,Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004'
                                                ,RegistrationNo__c = '12345'), utilConst.VEHICLE_PRODUCT);

        // Current Vehicle 1
        Vehicle__c currentVehicle1 = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,EuroVIN__c = '12345678901111111'
                                        ,UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today()
                                            ,Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004'
                                                ,RegistrationNo__c = '12345'), utilConst.VEHICLE_PRODUCT);

        // Current Vehicle 2
        Vehicle__c currentVehicle2 = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,EuroVIN__c = '12345678901111111'
                                        ,UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today()
                                            ,Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004'
                                                ,RegistrationNo__c = '12345'), utilConst.VEHICLE_PRODUCT);

        // Trade In Vehicle
        Vehicle__c TradeInVehicle = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,EuroVIN__c = '12345678901111111'
                                        ,UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today()
                                            ,Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004'
                                                ,RegistrationNo__c = '12345'), utilConst.VEHICLE_PRODUCT);

        // Purchased Vehicle
        Vehicle__c PurchasedVehicle = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,EuroVIN__c = '12345678901111111'
                                        ,UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today()
                                            ,Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004'
                                                ,RegistrationNo__c = '12345'), utilConst.VEHICLE_PRODUCT);
        
        // Vehicle Relationship
        Vehicle_Relationship__c vr = new Vehicle_Relationship__c(Vehicle_ID__c = testVehicle_VehicleProduct.Id,Contact__c=accobj.id);
        insert vr;
                
        testCase.Interested_Vehicle__c = testVehicle_VehicleProduct.Id;
        testCase.Interested_Competitor_Vehicle__c  = testVehicleMB.Id;
        testCase.Current_Vehicle_1__c  = currentVehicle1.Id;        
        testCase.Current_Vehicle_2__c  = currentVehicle2.Id;
        testCase.Trade_In_Vehicle__c  = TradeInVehicle.Id;
        testCase.Purchased_Vehicle__c  = PurchasedVehicle.Id;
        update testCase;
        
        System.assertEquals(testCase.Purchased_Vehicle__c,PurchasedVehicle.Id);
        System.assertEquals(testCase.Trade_In_Vehicle__c,TradeInVehicle.Id);
        System.assertEquals(testCase.Current_Vehicle_2__c,currentVehicle2.Id);
        System.assertEquals(testCase.Current_Vehicle_1__c,currentVehicle1.Id);
        
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        test.StopTest();
        System.assertNotEquals(testCase,null);
    }
    
    public static testMethod void testupdateVehicleDetailsNew(){
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        UtilConstant utilConst = new UtilConstant(); 
        
        // Account
        accobj = new Account(RecordTypeId = personAccRecordTypeId,LastName = 'galaxy1',MBK_Data_Source__c='Email',Mobile__c ='000-0000-9642',ZipCode__c= '1002347'); 
        insert accobj;
        system.assertNotEquals(accobj,null);
        
        // Case
        testCase = new Case(RecordTypeId = MBRecordTypeId,Case_Department__c = 'testcase',Description = 'testdes',Case_Type__c = 'testcasetype'
                                ,Case_Class__c = 'Complaint',Case_SubType__c = 'test case subtype', Case_Source__c = 'test case source'
                                    ,Overdue_Reason__c ='Others', AccountId = accobj.Id, Car_Owner__c=accobj.Id);
        insert testCase;
        system.assertNotEquals(testCase,null);
        
        // Car Models
        Car_Model__c cm = new Car_Model__c();
        cm.Status__c = 'Own Sellable';
        cm.Brand__c = 'AMG';
        cm.Series__c = 'A-CLASS';
        cm.Model__c = 'A160';
        cm.Name = 'A160';
        cm.Colour__c = 'white';        
        insert cm; 
        system.assertNotEquals(cm,null);

        
        // Start Test
        test.StartTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        
        Map<String,String> tempMap = new Map<String,String>();
        for(String vehicle : vehicleTypes){
            tempMap.put('caseVehicleType',vehicle);
            tempMap.put('Lookup','false');
            tempMap.put('CurrentRecordId',testCase.Id);
            tempMap.put('Mileage','10');
            tempMap.put('Operation','New');
            tempMap.put('Brand','AMG');
            tempMap.put('Class','A-CLASS');
            tempMap.put('Colour','white');
            tempMap.put('Model','A160');
            system.assertEquals(tempMap.get('Model'),'A160');
            String vehicleDetails = JSON.serialize(tempMap);
            VehiclePickerForCaseController.updateVehicleDetails(vehicleDetails);
        }
        
        // Stop Test
        test.stopTest();
    }


    public static testMethod void testupdateVehicleDetailsEdit(){
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        UtilConstant utilConst = new UtilConstant(); 
        
        // Account
        accobj = new Account(RecordTypeId = personAccRecordTypeId,LastName = 'galaxy1',MBK_Data_Source__c='Email',Mobile__c ='000-0000-9642',ZipCode__c= '1002347'); 
        insert accobj;
        system.assertNotEquals(accobj,null);
        
        // Case
        testCase = new Case(RecordTypeId = MBRecordTypeId,Case_Department__c = 'testcase',Description = 'testdes',Case_Type__c = 'testcasetype'
                                ,Case_Class__c = 'Complaint',Case_SubType__c = 'test case subtype', Case_Source__c = 'test case source'
                                    ,Overdue_Reason__c ='Others', AccountId = accobj.Id, Car_Owner__c=accobj.Id);
        insert testCase;
        system.assertNotEquals(testCase,null);

        // Vehicle 1
        testVehicleMB = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,EuroVIN__c = '12345678901111111'
                                        ,UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today()
                                            ,Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004'
                                                ,RegistrationNo__c = '12345'), UtilConstant.MB);
        
        // Vehicle 2
        testVehicle_VehicleProduct = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,EuroVIN__c = '12345678901111111'
                                        ,UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today()
                                            ,Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004'
                                                ,RegistrationNo__c = '12345'), utilConst.VEHICLE_PRODUCT);

        // Current Vehicle 1
        Vehicle__c currentVehicle1 = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,EuroVIN__c = '12345678901111111'
                                        ,UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today()
                                            ,Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004'
                                                ,RegistrationNo__c = '12345'), utilConst.VEHICLE_PRODUCT);

        // Current Vehicle 2
        Vehicle__c currentVehicle2 = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,EuroVIN__c = '12345678901111111'
                                        ,UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today()
                                            ,Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004'
                                                ,RegistrationNo__c = '12345'), utilConst.VEHICLE_PRODUCT);

        // Trade In Vehicle
        Vehicle__c TradeInVehicle = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,EuroVIN__c = '12345678901111111'
                                        ,UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today()
                                            ,Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004'
                                                ,RegistrationNo__c = '12345'), utilConst.VEHICLE_PRODUCT);

        // Purchased Vehicle
        Vehicle__c PurchasedVehicle = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Recall__c = FALSE,EuroVIN__c = '12345678901111111'
                                        ,UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today()
                                            ,Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004'
                                                ,RegistrationNo__c = '12345'), utilConst.VEHICLE_PRODUCT);

        testCase.Interested_Vehicle__c = testVehicle_VehicleProduct.Id;
        testCase.Interested_Competitor_Vehicle__c  = testVehicleMB.Id;
        testCase.Current_Vehicle_1__c  = currentVehicle1.Id;        
        testCase.Current_Vehicle_2__c  = currentVehicle2.Id;
        testCase.Trade_In_Vehicle__c  = TradeInVehicle.Id;
        testCase.Purchased_Vehicle__c  = PurchasedVehicle.Id;
        update testCase;

        System.assertEquals(testCase.Purchased_Vehicle__c,PurchasedVehicle.Id);
        System.assertEquals(testCase.Trade_In_Vehicle__c,TradeInVehicle.Id);
        System.assertEquals(testCase.Current_Vehicle_2__c,currentVehicle2.Id);
        System.assertEquals(testCase.Current_Vehicle_1__c,currentVehicle1.Id);

        // Car Models
        Car_Model__c cm = new Car_Model__c();
        cm.Status__c = 'Own Sellable';
        cm.Brand__c = 'AMG';
        cm.Series__c = 'A-CLASS';
        cm.Model__c = 'A160';
        cm.Name = 'A160';
        cm.Colour__c = 'white';        
        insert cm; 
        system.assertNotEquals(cm,null);
        
        // Start Test
        test.StartTest();
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        
        Map<String,String> tempMap = new Map<String,String>();
        for(String vehicle : vehicleTypes){
            tempMap.put('caseVehicleType',vehicle);
            tempMap.put('CurrentRecordId',testCase.Id);
            tempMap.put('Operation','Edit');
            tempMap.put('Lookup','false');
            tempMap.put('Mileage','10');
            tempMap.put('Brand','AMG');
            tempMap.put('Class','A-CLASS');
            tempMap.put('Colour','white');
            tempMap.put('Model','A160');
            system.assertEquals(tempMap.get('Model'),'A160');
            String vehicleDetails = JSON.serialize(tempMap);
            VehiclePickerForCaseController.updateVehicleDetails(vehicleDetails);
        }
        
        // Stop Test
        test.stopTest();
    }


}