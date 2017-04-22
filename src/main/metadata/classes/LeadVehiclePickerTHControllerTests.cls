@isTest
public without sharing class LeadVehiclePickerTHControllerTests{
    
    private static Lead__c testLead;
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
        testLead = (Lead__c)UtilTestData.createSobject(new Lead__c(), UtilConstant.SALES_LEADS);
        system.debug('Leads... :' +testLead);
        
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
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerTHController vpc = new LeadVehiclePickerTHController(sc);
        
        carModelMap = LeadVehiclePickerTHController.getCarModels('None');
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
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerTHController vpc = new LeadVehiclePickerTHController(sc);
        carModelMap = LeadVehiclePickerTHController.getCarModels('Competitor');
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
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerTHController vpc = new LeadVehiclePickerTHController(sc);
        carModelMap = LeadVehiclePickerTHController.getCarModels('Own Sellable');
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
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerTHController vpc = new LeadVehiclePickerTHController(sc);
        carModelMap = LeadVehiclePickerTHController.getCarModels('Own Non Sellable');
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
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerTHController vpc = new LeadVehiclePickerTHController(sc);
        test.startTest();
        for (String vehicle : vehicleTypes){
        
            String leadId = testLead.Id;
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
            tempMap_New.put('CurrentRecordId',leadId);
            tempMap_New.put('LeadVehicleType',vehicle);
            vehicleDetials = JSON.serialize(tempMap_New);
            LeadVehiclePickerTHController.updateVehicleDetails(vehicleDetials);
            
            Lead__c leadDetails;
            Vehicle__c lead_VehicleDetails;
            if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                leadDetails = [Select Interested_Vehicle__c from Lead__c where Id =:testLead.Id limit 10];
                lead_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:leadDetails.Interested_Vehicle__c limit 10];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
                leadDetails = [Select Interested_Competitor_Vehicle__c from Lead__c where Id =:testLead.Id limit 10];
                lead_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:leadDetails.Interested_Competitor_Vehicle__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                leadDetails = [Select Current_Vehicle_1__c from Lead__c where Id =:testLead.Id];
                lead_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c from Vehicle__c Where Id =:leadDetails.Current_Vehicle_1__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                leadDetails = [Select Current_Vehicle_2__c from Lead__c where Id =:testLead.Id];
                lead_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:leadDetails.Current_Vehicle_2__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                leadDetails = [Select Trade_In_Vehicle__c from Lead__c where Id =:testLead.Id];
                lead_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:leadDetails.Trade_In_Vehicle__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                leadDetails = [Select Purchased_Vehicle__c from Lead__c where Id =:testLead.Id];
                lead_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:leadDetails.Purchased_Vehicle__c];
            }
                
            
            System.assertEquals(lead_VehicleDetails.Brand__c,'AMG');
            System.assertEquals(lead_VehicleDetails.Class__c,'A-Class');
            System.assertEquals(lead_VehicleDetails.Model_Description__c,'A160');
            System.assertEquals(lead_VehicleDetails.Colour__c,'Green');
            System.assertEquals(lead_VehicleDetails.Trim__c,'Yellow');
            System.assertEquals(lead_VehicleDetails.NextMileage__c,45);
            
            
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
            tempMap_Edit.put('CurrentRecordId',leadId);
            tempMap_Edit.put('LeadVehicleType',vehicle);
            vehicleDetials = JSON.serialize(tempMap_Edit);
            LeadVehiclePickerTHController.updateVehicleDetails(vehicleDetials);
            
            if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                leadDetails = [Select Interested_Vehicle__c from Lead__c where Id =:testLead.Id];
                lead_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:leadDetails.Interested_Vehicle__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
                leadDetails = [Select Interested_Competitor_Vehicle__c from Lead__c where Id =:testLead.Id];
                lead_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:leadDetails.Interested_Competitor_Vehicle__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                leadDetails = [Select Current_Vehicle_1__c from Lead__c where Id =:testLead.Id];
                lead_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c from Vehicle__c Where Id =:leadDetails.Current_Vehicle_1__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                leadDetails = [Select Current_Vehicle_2__c from Lead__c where Id =:testLead.Id];
                lead_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:leadDetails.Current_Vehicle_2__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                leadDetails = [Select Trade_In_Vehicle__c from Lead__c where Id =:testLead.Id];
                lead_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:leadDetails.Trade_In_Vehicle__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                leadDetails = [Select Purchased_Vehicle__c from Lead__c where Id =:testLead.Id];
                lead_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c, Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:leadDetails.Purchased_Vehicle__c];
            }
            
            System.assertEquals(lead_VehicleDetails.Brand__c,'Maybach');
            System.assertEquals(lead_VehicleDetails.Class__c,'C-Class');
            System.assertEquals(lead_VehicleDetails.Model_Description__c,'C200K Elegance');
            System.assertEquals(lead_VehicleDetails.Colour__c,'Green');
            System.assertEquals(lead_VehicleDetails.Trim__c,'Yellow');
            System.assertEquals(lead_VehicleDetails.NextMileage__c,55);
    
        }
        test.stopTest();
        
    }
    
    public static testMethod void testLookupVehicle(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerTHController vpc = new LeadVehiclePickerTHController(sc);
        Map<String,String> tempMap = new Map<String,String>();
        for(String vehicle : vehicleTypes){
            tempMap.put('Id',testVehicleMB.Id);
            tempMap.put('VehicleType',vehicle);
            tempMap.put('Lookup','true');
            tempMap.put('CurrentRecordId',testLead.Id);
            String vehicleDetails = JSON.serialize(tempMap);
            system.debug('Vehicle Detials for Lookup...' +vehicleDetails);
            LeadVehiclePickerTHController.updateVehicleDetails(vehicleDetails);
            Lead__c leadDetails;
            
            if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                leadDetails = [Select Interested_Vehicle__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Interested_Vehicle__c,testVehicleMB.Id);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                leadDetails = [Select Current_Vehicle_1__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Current_Vehicle_1__c,testVehicleMB.Id);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                leadDetails = [Select Current_Vehicle_2__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Current_Vehicle_2__c,testVehicleMB.Id);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                leadDetails = [Select Trade_In_Vehicle__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Trade_In_Vehicle__c,testVehicleMB.Id);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                leadDetails = [Select Purchased_Vehicle__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Purchased_Vehicle__c,testVehicleMB.Id);
            }
            
        }
        test.stopTest();
    }
    

    public static testMethod void testClearNewVehicle(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerTHController vpc = new LeadVehiclePickerTHController(sc);
        test.startTest();
        for (String vehicle : vehicleTypes){
            String leadId = testLead.Id;
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
            tempMap_New.put('CurrentRecordId',leadId);
            tempMap_New.put('LeadVehicleType',vehicle);
            vehicleDetials = JSON.serialize(tempMap_New);
            LeadVehiclePickerTHController.updateVehicleDetails(vehicleDetials);
            
            Id recTypeId = UtilRecordType.getRecordTypeIdByName('Vehicle__c', 'Vehicle Product');
            Vehicle__c vehicle_VP = [Select Id from Vehicle__c Where RecordTypeId =:recTypeId];
            System.debug('Vehicle Before clear :' +vehicle_VP);
            
            Lead__c leadDetails;
            //Clear the Vehicle:
            Map<String,String> clearVehicleDetails = new Map<String,String>();
            clearVehicleDetails.put('VehicleType',vehicle);
            clearVehicleDetails.put('CurrentRecordId',testLead.Id);
            LeadVehiclePickerTHController.clearVehicleFromLead(JSON.serialize(clearVehicleDetails));
            
            if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                leadDetails = [Select Interested_Vehicle__c from Lead__c where Id =:testLead.Id];
                system.debug('Cleared Vehicle Id:' +leadDetails.Interested_Vehicle__c);
                System.assertEquals(leadDetails.Interested_Vehicle__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
                leadDetails = [Select Interested_Competitor_Vehicle__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Interested_Competitor_Vehicle__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                leadDetails = [Select Current_Vehicle_1__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Current_Vehicle_1__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                leadDetails = [Select Current_Vehicle_2__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Current_Vehicle_2__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                leadDetails = [Select Trade_In_Vehicle__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Trade_In_Vehicle__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                leadDetails = [Select Purchased_Vehicle__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Purchased_Vehicle__c,null);
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
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerTHController vpc = new LeadVehiclePickerTHController(sc);
        Map<String,String> tempMap = new Map<String,String>();
        for(String vehicle : vehicleTypes){
        
            if (!vehicle.equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
                tempMap.put('Id',testVehicleMB.Id);
                tempMap.put('VehicleType',vehicle);
                tempMap.put('Lookup','true');
                tempMap.put('CurrentRecordId',testLead.Id);
                String vehicleDetails = JSON.serialize(tempMap);
                system.debug('Vehicle Detials for Lookup...' +vehicleDetails);
                LeadVehiclePickerTHController.updateVehicleDetails(vehicleDetails);
                Lead__c leadDetails;
                
                //Clear the Vehicle:
                Map<String,String> clearVehicleDetails = new Map<String,String>();
                clearVehicleDetails.put('VehicleType',vehicle);
                clearVehicleDetails.put('CurrentRecordId',testLead.Id);
                LeadVehiclePickerTHController.clearVehicleFromLead(JSON.serialize(clearVehicleDetails));
                
               if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                    leadDetails = [Select Interested_Vehicle__c from Lead__c where Id =:testLead.Id];
                    system.debug('Cleared Vehicle Id:' +leadDetails.Interested_Vehicle__c);
                    System.assertEquals(leadDetails.Interested_Vehicle__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                    leadDetails = [Select Current_Vehicle_1__c from Lead__c where Id =:testLead.Id];
                   System.assertEquals(leadDetails.Current_Vehicle_1__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                    leadDetails = [Select Current_Vehicle_2__c from Lead__c where Id =:testLead.Id];
                    System.assertEquals(leadDetails.Current_Vehicle_2__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                    leadDetails = [Select Trade_In_Vehicle__c from Lead__c where Id =:testLead.Id];
                    System.assertEquals(leadDetails.Trade_In_Vehicle__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                    leadDetails = [Select Purchased_Vehicle__c from Lead__c where Id =:testLead.Id];
                    System.assertEquals(leadDetails.Purchased_Vehicle__c,null);
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
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerTHController vpc = new LeadVehiclePickerTHController(sc);
        
        //Creating associated data for search test.
        Account testAccount = (Account)UtilTestData.createSobject(new Account(), UtilConstant.person_Account);
        testLead.Contact__c = testAccount.Id;
        update testLead;
        
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
                searchDetails.put('RecordId',testLead.Id);
                List<Vehicle__c> resultVehicles = LeadVehiclePickerTHController.searchVehicles(JSON.serialize(searchDetails));
                system.debug('Searched Vehicle :' +resultVehicles[0]);
                
                Vehicle__c tmpVehicle = [Select UsVIN__c from Vehicle__c Where Id =:resultVehicles[0].Id];
                system.debug('Vehicle VIn number :' +tmpVehicle.UsVIN__c);
                System.assertEquals(tmpVehicle.UsVIN__c,'87465345982346578');
                
            }else{
                Map<String,String> searchDetails = new Map<String,String>();
                searchDetails.put('VIN','');
                searchDetails.put('VehicleType',vehicle);
                searchDetails.put('RecordId',testLead.Id);
                List<Vehicle__c> resultVehicles = LeadVehiclePickerTHController.searchVehicles(JSON.serialize(searchDetails));
                system.debug('Searched Other Vehicles:' +resultVehicles);
                system.debug('Searched Other Vehicles count:' +resultVehicles.size());
                System.assertEquals(resultVehicles.size(),2);
            }
        }
        test.StopTest();
    }
    
    static testMethod void testAccAssignment() {
    Profile p1 = [select id from profile where Name='System Administrator' limit 1];
    User user1 = new User(LastName='User',Market__c='TH',country='Australia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01');
    insert user1;
     User user2 = new User(LastName='GEORGE',Market__c='TH',country='Australia',ProfileId=p1.Id,Alias='ain1234',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='george@usgboral.com.dev01');
    insert user2;
   
    
   
    System.runAs (user2) {
   

        test.starttest();
        set<id> accid=new set<id>();
        Account dealer = new Account();
        dealer.Dealer_Alternate_Name__c = 'Test Alternate';
        dealer.Phone = '12332121';
        dealer.Dealer_GC_Code__c = 'gc code';
        dealer.Dealer_GS_Code__c = 'gs code';
        dealer.Name = 'test dealer';
        dealer.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        dealer.Star_Elite_Account_Owner__c = user1.Id;
        dealer.Smart_Account_Owner__c = user1.Id;
        dealer.Dealer_Lead_System__c = 'salesforce';
        dealer.Dealer_Lead_Gate_Keeper__c = user1.id;
        dealer.Allow_Data_Sharing__c = 'yes';
        dealer.Province__c = 'jiangsu';
        dealer.City__c = 'nanjing';
        dealer.Preferred_Language__c = 'english';
        dealer.Dealer_Lead_System__c = 'salesforce';
        dealer.Gender__c = '0=Male';
        //dealer.ZipCode__c = '20235';
        dealer.Type = '0=Company';
        dealer.Status__c = '0=contac1';
        dealer.No_of_Dealer_Portal_Licenses__c = Decimal.valueOf(20);
        dealer.Dealer_Region__c = 'EAST';
       insert dealer;
     
       
        
        Account perAcc= new Account();
        perAcc.Allow_Data_Sharing__c = 'yes'; 
        perAcc.Province__c = 'jiangsu'; 
        perAcc.City__c = 'nanjing';
        perAcc.Preferred_Language__c = 'english';
        perAcc.Dealer_Lead_System__c = 'salesforce';
        perAcc.LastName = 'Customer';
        perAcc.Gender__c = '0=Male';
        perAcc.Type = '0=Company';
        perAcc.Phone = '01233214'; 
        perAcc.Status__c = '0=Customer';
        perAcc.RecordTypeId =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        perAcc.Dealer_Lead_Gate_Keeper__c = user1.Id;
        perAcc.Area_Code__c = '030';
       
        insert perAcc;

        accid.add(perAcc.id);
        
        
        
        Lead__c lead = new Lead__c();
        lead.Contact__c = perAcc.Id;
        //lead.recordTypeId =Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Aftersales Leads').getRecordTypeId();
        lead.CAC_Lead_Status__c = 'Qualified';
        lead.Lead_Type__c = 'New Car';
        lead.Relation_With_The_Leads__c = 'testR';
        lead.Lead_Desired_Service__c = 'Trade-In';
        lead.Purchase_Time__c = '0 - 3 months';
        lead.Interested_Vehicle_Brand__c = 'testI';
        lead.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead.Trade_In_Vehicle_Brand__c = 'c230';
        lead.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead.Trade_In_Other_Vehicle_Model__c = 'testT';
        lead.Interested_Vehicle_Brand__c = 'Smart';
        lead.md__c='TH';
        lead.RecordTypeId='012280000006I7s';
        lead.Assigned_Dealer__c = dealer.Id;
        insert lead;
    
        
        list<Lead__c> ld=new  list<Lead__c>();
        ld.add(lead);
        system.debug('+++' + ld);
       
        
        Car_Model__c  objCarmodel = new Car_Model__c ();
        objCarmodel.Name='Daimler';
        objCarmodel.Brand__c='Smart';
        objCarmodel.Series__c='A-CLASS';
        objCarmodel.Model__c='A160';
        objCarmodel.Colour__c='Red';
        objCarmodel.Status__c = 'Own Sellable';
        insert objCarmodel;
        
     Vehicle__c vehicleObj =new Vehicle__c();
        Id recordTypeVehicleObjId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
        vehicleObj = new Vehicle__c(car_model__c=objCarmodel.id,RecordTypeId = recordTypeVehicleObjId,Brand__c = 'Maybach',UsVIN__c ='12369854789632147',EuroVIN__c ='tlikkkkkkkklllllkl',CurrentMileage__c=5000,NextMileage__c=6000);
        insert vehicleObj;
       
        
        list<Vehicle_Relationship__c> vhlist=new  list<Vehicle_Relationship__c>();
        Vehicle_Relationship__c vehicle_relationship=new Vehicle_Relationship__c();
          vehicle_relationship.Start_Date__c =date.today();
           vehicle_relationship.End_Date__c = date.today();
           vehicle_relationship.Contact__c = perAcc.Id;
           vehicle_relationship.End_Reason__c = 'DMS';
          vehicle_relationship.Vehicle_ID__c=vehicleObj.id;
           vehicle_relationship.Car_Relation__c='Sales Contact Target';
           vehicle_relationship.Owner_Relation__c='Grand Parent';
           vehicle_relationship.Validity__c='true';
         insert vehicle_relationship;
         
        LeadVehiclePickerTHController.getCarModels('Competitor');
        test.stoptest();
       
        }     
        }
        
}