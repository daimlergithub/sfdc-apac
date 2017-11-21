@isTest
public without sharing class VehiclePickerForCaseControllerTests{
    
    private static Case testCase;
    private static Vehicle__c testVehicleMB;
    private static Vehicle__c testVehicle_VehicleProduct;
    private static List<Car_Model__c> carModels;
    private static List<Map<String, Set<String>>> carModelMap;
    /*private static List<String> vehicleTypes = new List<String> {'Interested Vehicle', 'Competitor Vehicle', 'CurrentVehicle1', 'CurrentVehicle2', 'TradeIn', 'Purchased'};*/
    private static List<String> vehicleTypes = new List<String> {'Interested Vehicle', 'Competitor Vehicle', 'CurrentVehicle1'};
   // public static id SalesLeadsRecordtypeid = Schema.SObjectType.Case .getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
    public static id VehicleProductRecordtypeid = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('Vehicle Product').getRecordTypeId();
    public static id VehicleMBRecordtypeid = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
    public static id VehicleselfregRecordtypeid = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('Self Registered').getRecordTypeId();
    public static id personRecordtypeid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id MBRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
    
    public static void createTestData(){
    
    /********************* CREATING TEST DATA : START **************************/
        
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;

        UtilConstant utilConst = new UtilConstant();     
        //testCase = (Case )UtilTestData.createSobject(new Case (), UtilConstant.SALES_LEADS);
        Account ta = new Account(RecordTypeId=personRecordtypeid,LastName='test123',MBK_Data_Source__c='Email',Mobile__c ='00000009842');
        insert ta;
        system.debug('Accounts... :' +ta );
        
       testCase = new Case(RecordTypeId = MBRecordTypeId,Case_Department__c = 'testcase',Description = 'testdes',Case_Type__c = 'testcasetype',Case_Class__c = 'Complaint',Case_SubType__c = 'test case subtype',               //testCase = (Case )UtilTestData.createSobject(new Case (), UtilConstant.SALES_LEADS);
                            Case_Source__c = 'test case source',Overdue_Reason__c ='Others', AccountId = ta.Id);               
                            
                            
        insert testCase;              
        system.debug('$$$$$$$$$$$$$$'+testCase);
        system.debug('Accounts... :' +ta );
        
        testVehicleMB = new Vehicle__c(RecordTypeId=VehicleMBRecordtypeid,Recall__c = FALSE,EuroVIN__c = '12345678901111111',UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',
                                                                              FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', 
                                                                              Purchase_Year__c = '2004',RegistrationNo__c = '12345');
        insert testVehicleMB;
        system.debug('Test Vehicle1' +testVehicleMB);                                              
        
        //testVehicle_VehicleProduct = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(), utilConst.VEHICLE_PRODUCT);
        testVehicle_VehicleProduct = new Vehicle__c(RecordTypeid=VehicleProductRecordtypeid );
        system.debug('Test Vehicle2' +testVehicle_VehicleProduct);
        
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
            carModels[i].Colour__c = models[i];
        }
        update carModels;
        system.debug('Updated Car Models...' +carModels);
    }
    public static void getdata()
    {
         Account ta = new Account(RecordTypeId=personRecordtypeid,LastName='test123',MBK_Data_Source__c='Email',Mobile__c ='00000009842');
        insert ta;
        system.debug('Accounts... :' +ta );
        
       testCase = new Case(RecordTypeId = MBRecordTypeId,Case_Department__c = 'testcase',Description = 'testdes',Case_Type__c = 'testcasetype',Case_Class__c = 'Complaint',Case_SubType__c = 'test case subtype',               //testCase = (Case )UtilTestData.createSobject(new Case (), UtilConstant.SALES_LEADS);
                            Case_Source__c = 'test case source',Overdue_Reason__c ='Others', AccountId = ta.Id);               
                            
                            
        insert testCase;              
        system.debug('$$$$$$$$$$$$$$'+testCase);
        
          testVehicleMB = new Vehicle__c(RecordTypeId=VehicleMBRecordtypeid,Recall__c = FALSE,EuroVIN__c = '12345678901111111',UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',
                                                                              FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', 
                                                                              Purchase_Year__c = '2004',RegistrationNo__c = '12345');
        insert testVehicleMB;
        system.debug('Test Vehicle1' +testVehicleMB);                                              
        
        //testVehicle_VehicleProduct = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(), utilConst.VEHICLE_PRODUCT);
        testVehicle_VehicleProduct = new Vehicle__c(RecordTypeid=VehicleProductRecordtypeid );
        system.debug('Test Vehicle2' +testVehicle_VehicleProduct);
        
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
            carModels[i].Colour__c = models[i];
        }
        update carModels;
        system.debug('Updated Car Models...' +carModels);
    }
    
    
    
   public static testMethod void testCarModels(){
        
        UtilConstant utilConst = new UtilConstant();
        getdata();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        
        carModelMap = VehiclePickerForCaseController.getCarModels('None');
        system.debug('All Car Models :' +carModelMap);
        Map<String, Set<String>> tempMap = carModelmap[0];
        System.debug('Size of the Car Model Map :' +tempMap.size());
        test.StopTest();
        //System.assertEquals(tempMap.size(),4);
          
    }
     public static testMethod void testCarModels1(){
        UtilConstant utilConst = new UtilConstant();
        getdata();
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
        getdata();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        carModelMap = VehiclePickerForCaseController.getCarModels('Own Sellable');
        system.debug('Own Sellable Car Models :' +carModelMap);
        Map<String, Set<String>> tempMap = carModelmap[0];
        System.debug('Size of the Car Model Map :' +tempMap.size());
        test.StopTest();
        //System.assertEquals(tempMap.size(),1);
    }
    public static testMethod void testCarModels3(){
        UtilConstant utilConst = new UtilConstant();
        getdata();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        carModelMap = VehiclePickerForCaseController.getCarModels('Own Non Sellable');
        system.debug('Own Non Sellable Car Models :' +carModelMap);
        Map<String, Set<String>> tempMap = carModelmap[0];
        System.debug('Size of the Car Model Map :' +tempMap.size());
        test.StopTest();
       // System.assertEquals(tempMap.size(),1);
    }
    
     public static testMethod void testLookupVehicle(){
        UtilConstant utilConst = new UtilConstant();
        getdata();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        Map<String,String> tempMap = new Map<String,String>();
        /*Case caseDetails = [Select Interested_Vehicle__c,Interested_Competitor_Vehicle__c,Current_Vehicle_1__c,Current_Vehicle_2__c,Trade_In_Vehicle__c,Purchased_Vehicle__c from Case where Id =:testCase.Id];*/
        for(String vehicle : vehicleTypes){
            tempMap.put('Id',testVehicleMB.Id);
            tempMap.put('VehicleType',vehicle);
            tempMap.put('Lookup','true');
            tempMap.put('CurrentRecordId',testCase.Id);
            system.debug('%%%%%%%%%%%%%%%%%%' +testCase.Id);
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
    
    
    
    
        /* public static testMethod void testClearNewVehicle(){
        UtilConstant utilConst = new UtilConstant();
         getdata();
         test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        Map<String,String> tempMap = new Map<String,String>();

        for(String vehicle : vehicleTypes)
        {
            tempMap.put('Id',testVehicleMB.Id);
            tempMap.put('VehicleType',vehicle);
            tempMap.put('Lookup','true');
            tempMap.put('CurrentRecordId',testCase.Id);
            system.debug('%%%%%%%%%%%%%%%%%%' +testCase.Id);
            String vehicleDetails = JSON.serialize(tempMap);
            system.debug('Vehicle Detials for Lookup...' +vehicleDetails);
            VehiclePickerForCaseController.updateVehicleDetails(vehicleDetails);
            Case caseDetails;
          
         
            Map<String,String> clearVehicleDetails = new Map<String,String>();
            
            clearVehicleDetails.put('VehicleType',vehicle);
            system.debug('clearVehicleDetailsclearVehicleDetails'+clearVehicleDetails);
            clearVehicleDetails.put('CurrentRecordId',testCase.Id);
            system.debug('clearVehicleDetailsclearVehicleDetails'+clearVehicleDetails);
            //VehiclePickerForCaseController.clearVehicleFromCase(test);
          
           
      }
      test.StopTest();
} 
*/
 public static testMethod void testLookupSearch(){
        
        UtilConstant utilConst = new UtilConstant();
       
        
        Account ta = new Account(RecordTypeId=personRecordtypeid,LastName='test123',MBK_Data_Source__c='Email',Mobile__c ='00000009842');
        insert ta;
        system.debug('Accounts... :' +ta );
        
       testCase = new Case(RecordTypeId = MBRecordTypeId,Case_Department__c = 'testcase',Description = 'testdes',Case_Type__c = 'testcasetype',Case_Class__c = 'Complaint',Case_SubType__c = 'test case subtype',               //testCase = (Case )UtilTestData.createSobject(new Case (), UtilConstant.SALES_LEADS);
                            Case_Source__c = 'test case source',Overdue_Reason__c ='Others', AccountId = ta.Id);               
                            
                            
        insert testCase;              
        system.debug('$$$$$$$$$$$$$$'+testCase);
        
         ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        
        String Vin = '87465345982346578';
        //Vehicle__c testVIN_Vehicle = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(), UtilConstant.MB); 
        Vehicle__c testVIN_Vehicle = new Vehicle__c(RecordTypeId=VehicleMBRecordtypeid,Vehicle_Name__c ='Test1',UsVIN__c ='abchgdtrsghtredfr',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),
                                                    Purchase_Month__c ='02',Model__c = 'R350L 4MATIC',Class__c = 'A-Class',Purchase_Year__c = '2004',RegistrationNo__c = '333');
        insert testVIN_Vehicle;
        testVIN_Vehicle.UsVIN__c = Vin;
        update testVIN_Vehicle;
        
        //Vehicle__c testVR_vehicle = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(), UtilConstant.MB);
        Vehicle__c testVR_vehicle = new Vehicle__c(RecordTypeId=VehicleselfregRecordtypeid ,Vehicle_Name__c ='Test1',UsVIN__c ='abchgdtrsghtredfr',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),
                                                    Purchase_Month__c ='02',Model__c = 'R350L 4MATIC',Class__c = 'A-Class',Purchase_Year__c = '2004',RegistrationNo__c = '333');    
                                                    insert testVR_vehicle;                                               
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
        testVR.Vehicle_ID__c = testVR_vehicle.id;
        testVR.Car_Relation__c = 'Purchaser';
        insert testVR;
        testVR.Contact__c = ta.Id;
        testVR.Vehicle_ID__c = testVR_vehicle.Id;
        testVR.Car_Relation__c = 'Purchaser';
        update testVR;
        
       
        testVR_vehicle.Related_contact__c = ta.Id;
        update testVR_vehicle;
        
       
        for (String vehicle : vehicleTypes){
            if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE) || vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                //Search With VIN : Interested and Purchased:
                Map<String,String> searchDetails = new Map<String,String>();
                searchDetails.put('VIN',Vin);
                searchDetails.put('VehicleType',vehicle);
                searchDetails.put('RecordId',testCase.Id);
                List<Vehicle__c> resultVehicles = VehiclePickerForCaseController.searchVehicles(JSON.serialize(searchDetails));
                system.debug('Searched Vehicle :' +resultVehicles[0]);
                
                Vehicle__c tmpVehicle = [Select UsVIN__c from Vehicle__c Where Id =:resultVehicles[0].Id limit 1];
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
                System.assertEquals(resultVehicles.size(),1);
            }
        }
       
    }    
    
       public static testMethod void testupdateVehicleDetailsEdit(){
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingskernel.customSettingDetails();
        insert updatecustomsettings;

        UtilConstant utilConst = new UtilConstant();
      
         Account ta = new Account(RecordTypeId=personRecordtypeid,LastName='test123',MBK_Data_Source__c='Email',Mobile__c ='00000009842');
         insert ta;
        
         testCase = new Case(RecordTypeId = MBRecordTypeId,Case_Department__c = 'testcase',Description = 'testdes',Case_Type__c = 'testcasetype',Case_Class__c = 'Complaint',Case_SubType__c = 'test case subtype',               //testCase = (Case )UtilTestData.createSobject(new Case (), UtilConstant.SALES_LEADS);
                            Case_Source__c = 'test case source',Overdue_Reason__c ='Others', AccountId = ta.Id); 
                            
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
   
   public static testMethod void testLookupClear(){
        UtilConstant utilConst = new UtilConstant();
        getdata();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseController vpc = new VehiclePickerForCaseController(sc);
        
        Map<String,String> tempMap = new Map<String,String>();
        Case leadDetails;
        leadDetails = [Select Interested_Vehicle__c, Current_Vehicle_1__c, Current_Vehicle_2__c, Trade_In_Vehicle__c, Purchased_Vehicle__c from Case where Id =:testCase.Id];
   
        for(String vehicle : vehicleTypes){
        
            if (!vehicle.equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
                tempMap.put('Id',testVehicleMB.Id);
                tempMap.put('VehicleType',vehicle);
                tempMap.put('Lookup','true');
                tempMap.put('CurrentRecordId',testCase.Id);
                String vehicleDetails = JSON.serialize(tempMap);
                system.debug('Vehicle Detials for Lookup...' +vehicleDetails);
                VehiclePickerForCaseController.updateVehicleDetails(vehicleDetails);
                
                
                //Clear the Vehicle:
                Map<String,String> clearVehicleDetails = new Map<String,String>();
                clearVehicleDetails.put('VehicleType',vehicle);
                clearVehicleDetails.put('CurrentRecordId',testCase.Id);
                VehiclePickerForCaseController.clearVehicleFromCase(JSON.serialize(clearVehicleDetails));
                
               if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                    //leadDetails = [Select Interested_Vehicle__c from Case where Id =:testCase.Id];
                    system.debug('Cleared Vehicle Id:' +leadDetails.Interested_Vehicle__c);
                    System.assertEquals(leadDetails.Interested_Vehicle__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                    //leadDetails = [Select Current_Vehicle_1__c from Case where Id =:testCase.Id];
                    System.assertEquals(leadDetails.Current_Vehicle_1__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                    //leadDetails = [Select Current_Vehicle_2__c from Case where Id =:testCase.Id];
                    System.assertEquals(leadDetails.Current_Vehicle_2__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                    //leadDetails = [Select Trade_In_Vehicle__c from Case where Id =:testCase.Id];
                    System.assertEquals(leadDetails.Trade_In_Vehicle__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                    //leadDetails = [Select Purchased_Vehicle__c from Case where Id =:testCase.Id];
                    System.assertEquals(leadDetails.Purchased_Vehicle__c,null);
                }
                
                
                
            }
            
        }
        test.stopTest();
    }
   
}