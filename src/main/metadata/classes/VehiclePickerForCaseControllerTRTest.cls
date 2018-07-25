@isTest
public without sharing class VehiclePickerForCaseControllerTRTest{
    
    private static Case testCase;
    private static Vehicle__c testVehicleMB;
    private static Vehicle__c testVehicle_VehicleProduct;
    private static List<Car_Model__c> carModels;
    private static List<Map<String, Set<String>>> carModelMap;
    public static user usr;
    private static List<String> vehicleTypes = new List<String> {'Interested Vehicle', 'Competitor Vehicle', 'CurrentVehicle1', 'CurrentVehicle2', 'TradeIn', 'Purchased'};
    //private static List<String> vehicleTypes = new List<String> {'Interested Vehicle', 'Competitor Vehicle', 'CurrentVehicle1'};
   
    public static id VehicleMBRecordtypeid = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
    public static Id VehicleProductRecordtypeid = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('Vehicle Product').getRecordTypeId();
    public static Id SelfRegisteredRecordtypeid = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('Self Registered').getRecordTypeId();
    public static id personRecordtypeid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id MBRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
    public static Id VehicleRelationshipRetailRecordtypeid = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();
    public static void createTestData(){
    
    /********************* CREATING TEST DATA : START **************************/
        
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        //insert updatecustomsettings;
Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAccountLink',Trigger_Name__c='TriggerAccountLink',Trigger_Handler__c='TriggerAccountLinkTriggerHandlerJP',update__c=False,insert__c=False,delete__c=False,after__c=False,before__c=False,enabled__c=False,Market__c='TR');
        insert TriggerAddress;
        Trigger__c TriggerAddress1=new Trigger__c(Name='TriggerLead',Trigger_Name__c='TriggerLead',Trigger_Handler__c='TriggerLeadTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='TR');
        //insert TriggerAddress1;
        UtilConstant utilConst = new UtilConstant();     
        //testCase = (Lead__c)UtilTestData.createSobject(new Lead__c(), UtilConstant.SALES_LEADS);
        Account ta = new Account(RecordTypeId=personRecordtypeid,FirstName='test123',LastName='test123',Data_Source__c='Employee Referral');
        insert ta;
        system.debug('Accounts... :' +ta );
        testCase = new Case(RecordTypeId = MBRecordTypeId,Case_Department__c = 'testcase',Description = 'testdes',Case_Type__c = 'testcasetype',Case_Class__c = 'Complaint',Case_SubType__c = 'test case subtype',               //testCase = (Case )UtilTestData.createSobject(new Case (), UtilConstant.SALES_LEADS);
                            Case_Source__c = 'test case source',Overdue_Reason__c ='Others', AccountId = ta.Id); 
        insert testCase;
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
            System.assertEquals('Have a nice day', msg.getSummary());
            System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        }
        
       
        testVehicleMB = new Vehicle__c(RecordTypeId=vehicleMBRecordtypeid,Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', 
                                       Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
                                                      
        
        
        testVehicle_VehicleProduct = new Vehicle__c(RecordTypeId=VehicleProductRecordtypeid,Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', 
                                                    Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
        system.debug('Test Vehicle2' +testVehicle_VehicleProduct);
        
        //Create Car Models
        List<String> carStatus = new List<String>{'Own Sellable', 'Own Non Sellable','Competitor'};
        List<String> brands = new List<String>{'AMG','Others','TRUCKS','Maybach'};
        List<String> classes = new List<String>{'A-CLASS','B-CLASS','C-CLASS','C-CLASS'};
        List<String> models = new List<String>{'A160','A180','B200','C200K Elegance'};
        List<String> colours = new List<String>{'Red|Blue','blue|Bage','white|Black','Yellow|Green'};
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
        
        Profile prof = [select Id from Profile where Name = 'IntegrationAPI'];
        usr = new User (ProfileId = prof.Id, isActive = true, Username='lai1@nttdata.com',LastName='sichaof',Email='sichao.lai@nttdata.com',Alias='laisc',CommunityNickname='barney1',
                    TimeZoneSidKey='America/Los_Angeles',LocaleSidKey='en_US',EmailEncodingKey='ISO-8859-1',LanguageLocaleKey='en_US');
    }
    
    
    public static testMethod void testCarModels(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseControllerTR vpc = new VehiclePickerForCaseControllerTR(sc);
        
        carModelMap = VehiclePickerForCaseControllerTR.getCarModels('None');
        system.debug('All Car Models :' +carModelMap);
        Map<String, Set<String>> tempMap = carModelmap[0];
        System.debug('Size of the Car Model Map :' +tempMap.size());
        test.StopTest();
        //System.assertEquals(tempMap.size(),4);
          
    }
    public static testMethod void testCarModels1(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseControllerTR vpc = new VehiclePickerForCaseControllerTR(sc);
        carModelMap = VehiclePickerForCaseControllerTR.getCarModels('Competitor');
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
        VehiclePickerForCaseControllerTR vpc = new VehiclePickerForCaseControllerTR(sc);
        carModelMap = VehiclePickerForCaseControllerTR.getCarModels('Own Sellable');
        system.debug('Own Sellable Car Models :' +carModelMap);
        Map<String, Set<String>> tempMap = carModelmap[0];
        System.debug('Size of the Car Model Map :' +tempMap.size());
        test.StopTest();
        //System.assertEquals(tempMap.size(),1);
    }
    public static testMethod void testCarModels3(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseControllerTR vpc = new VehiclePickerForCaseControllerTR(sc);
        carModelMap = VehiclePickerForCaseControllerTR.getCarModels('Own Non Sellable');
        system.debug('Own Non Sellable Car Models :' +carModelMap);
        Map<String, Set<String>> tempMap = carModelmap[0];
        System.debug('Size of the Car Model Map :' +tempMap.size());
        test.StopTest();
        //System.assertEquals(tempMap.size(),1);
    }
       
    
    public static testMethod void testLookupVehicle(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseControllerTR vpc = new VehiclePickerForCaseControllerTR(sc);
        Map<String,String> tempMap = new Map<String,String>();
    case caseDeatils = [Select Interested_Vehicle__c,Interested_Competitor_Vehicle__c,Current_Vehicle_1__c,Current_Vehicle_2__c,Trade_In_Vehicle__c,Purchased_Vehicle__c from case where Id =:testCase.Id];
        for(String vehicle : vehicleTypes){
            tempMap.put('Id',testVehicleMB.Id);
            tempMap.put('VehicleType',vehicle);
            tempMap.put('Lookup','true');
            tempMap.put('CurrentRecordId',testCase.Id);
            String vehicleDetails = JSON.serialize(tempMap);
            system.debug('Vehicle Detials for Lookup...' +vehicleDetails);
            VehiclePickerForCaseControllerTR.updateVehicleDetails(vehicleDetails);
            
            if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                //caseDeatils = [Select Interested_Vehicle__c from Lead__c where Id =:testCase.Id];
                System.assertEquals(caseDeatils.Interested_Vehicle__c,testVehicleMB.Id);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                //caseDeatils = [Select Current_Vehicle_1__c from Lead__c where Id =:testCase.Id];
                System.assertEquals(caseDeatils.Current_Vehicle_1__c,testVehicleMB.Id);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                //caseDeatils = [Select Current_Vehicle_2__c from Lead__c where Id =:testCase.Id];
                System.assertEquals(caseDeatils.Current_Vehicle_2__c,testVehicleMB.Id);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                //caseDeatils = [Select Trade_In_Vehicle__c from Lead__c where Id =:testCase.Id];
                System.assertEquals(caseDeatils.Trade_In_Vehicle__c,testVehicleMB.Id);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                //caseDeatils = [Select Purchased_Vehicle__c from Lead__c where Id =:testCase.Id];
                System.assertEquals(caseDeatils.Purchased_Vehicle__c,testVehicleMB.Id);
            }
            
        }
        test.stopTest();
    }
    

    public static testMethod void testClearNewVehicle(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseControllerTR vpc = new VehiclePickerForCaseControllerTR(sc);
        test.startTest();
    case caseDeatils = [Select Interested_Vehicle__c,Interested_Competitor_Vehicle__c,Current_Vehicle_1__c,Current_Vehicle_2__c,Trade_In_Vehicle__c,Purchased_Vehicle__c from case where Id =:testCase.Id];
        for (String vehicle : vehicleTypes){
            String leadId = testCase.Id;
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
            tempMap_New.put('caseVehicleType',vehicle);
            vehicleDetials = JSON.serialize(tempMap_New);
            VehiclePickerForCaseControllerTR.updateVehicleDetails(vehicleDetials);
            

            
            //Lead__c caseDeatils;
            //Clear the Vehicle:
            Map<String,String> clearVehicleDetails = new Map<String,String>();
            clearVehicleDetails.put('VehicleType',vehicle);
            clearVehicleDetails.put('CurrentRecordId',testCase.Id);
        
            VehiclePickerForCaseControllerTR.clearVehicleFromCase(JSON.serialize(clearVehicleDetails));
           
            if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                //caseDeatils = [Select Interested_Vehicle__c from Lead__c where Id =:testCase.Id];
                system.debug('Cleared Vehicle Id:' +caseDeatils.Interested_Vehicle__c);
                System.assertEquals(caseDeatils.Interested_Vehicle__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
                //caseDeatils = [Select Interested_Competitor_Vehicle__c from Lead__c where Id =:testCase.Id];
                System.assertEquals(caseDeatils.Interested_Competitor_Vehicle__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                //caseDeatils = [Select Current_Vehicle_1__c from Lead__c where Id =:testCase.Id];
                System.assertEquals(caseDeatils.Current_Vehicle_1__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                //caseDeatils = [Select Current_Vehicle_2__c from Lead__c where Id =:testCase.Id];
                System.assertEquals(caseDeatils.Current_Vehicle_2__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                //caseDeatils = [Select Trade_In_Vehicle__c from Lead__c where Id =:testCase.Id];
                System.assertEquals(caseDeatils.Trade_In_Vehicle__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                //caseDeatils = [Select Purchased_Vehicle__c from Lead__c where Id =:testCase.Id];
                System.assertEquals(caseDeatils.Purchased_Vehicle__c,null);
            }
            
            
            
        }
        test.StopTest();
    }
    
    
    
    public static testMethod void testLookupClear(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseControllerTR vpc = new VehiclePickerForCaseControllerTR(sc);
        Map<String,String> tempMap = new Map<String,String>();
    case caseDeatils = [Select Interested_Vehicle__c,Interested_Competitor_Vehicle__c,Current_Vehicle_1__c,Current_Vehicle_2__c,Trade_In_Vehicle__c,Purchased_Vehicle__c from case where Id =:testCase.Id];
        for(String vehicle : vehicleTypes){
        
            if (!vehicle.equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
                tempMap.put('Id',testVehicleMB.Id);
                tempMap.put('VehicleType',vehicle);
                tempMap.put('Lookup','true');
                tempMap.put('CurrentRecordId',testCase.Id);
                String vehicleDetails = JSON.serialize(tempMap);
                system.debug('Vehicle Detials for Lookup...' +vehicleDetails);
                VehiclePickerForCaseControllerTR.updateVehicleDetails(vehicleDetails);
                
                //Clear the Vehicle:
                Map<String,String> clearVehicleDetails = new Map<String,String>();
                clearVehicleDetails.put('VehicleType',vehicle);
                clearVehicleDetails.put('CurrentRecordId',testCase.Id);
                //VehiclePickerForCaseControllerTR.clearVehicleFromLead(JSON.serialize(clearVehicleDetails));
                
               if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                    //caseDeatils = [Select Interested_Vehicle__c from Lead__c where Id =:testCase.Id];
                    system.debug('Cleared Vehicle Id:' +caseDeatils.Interested_Vehicle__c);
                    System.assertEquals(caseDeatils.Interested_Vehicle__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                    //caseDeatils = [Select Current_Vehicle_1__c from Lead__c where Id =:testCase.Id];
                    System.assertEquals(caseDeatils.Current_Vehicle_1__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                    //caseDeatils = [Select Current_Vehicle_2__c from Lead__c where Id =:testCase.Id];
                    System.assertEquals(caseDeatils.Current_Vehicle_2__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                    //caseDeatils = [Select Trade_In_Vehicle__c from Lead__c where Id =:testCase.Id];
                    System.assertEquals(caseDeatils.Trade_In_Vehicle__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                    //caseDeatils = [Select Purchased_Vehicle__c from Lead__c where Id =:testCase.Id];
                    System.assertEquals(caseDeatils.Purchased_Vehicle__c,null);
                }
                
                
            }
            
        }
        test.stopTest();
    }
    
    
    public static testMethod void testLookupSearch(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseControllerTR vpc = new VehiclePickerForCaseControllerTR(sc);
        
        //Creating associated data for search test.
        //Account testAccount = (Account)UtilTestData.createSobject(new Account(Data_Source__c='Past Data',Mobile__c ='000-123-4567'), UtilConstant.person_Account);
        Account testAccount = new Account(RecordTypeId=personRecordtypeid,FirstName='test',LastName='test23',Data_Source__c='Past Data');
        insert testAccount;
        system.debug('$$$$$$$$$$$$'+testAccount);
        system.debug('$$$$$$$$$$$$'+testAccount.Id);
        testCase.AccountId = testAccount.Id;
        update testCase;
        
        String Vin = '87465345982346578';
        //Vehicle__c testVIN_Vehicle = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345'), UtilConstant.MB);
        Vehicle__c testVIN_Vehicle = new Vehicle__c(RecordTypeId=vehicleMBRecordtypeid,Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', 
                                                    Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
        insert testVIN_Vehicle;                                     
        testVIN_Vehicle.UsVIN__c = Vin;
        update testVIN_Vehicle;
        
        //Vehicle__c testVR_vehicle = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345'), UtilConstant.MB);
        Vehicle__c testVR_vehicle = new Vehicle__c(RecordTypeId=vehicleMBRecordtypeid,Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', 
                                                    Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
        insert testVR_vehicle;
        //Vehicle_Relationship__c testVR  = (Vehicle_Relationship__c)UtilTestData.createSobject(new Vehicle_Relationship__c(), UtilConstant.Vehicle_Relationship_Retail);
        Vehicle_Relationship__c testVR  = new Vehicle_Relationship__c(RecordTypeId=VehicleRelationshipRetailRecordtypeid );        
        testVR.Contact__c = testAccount.Id;
        testVR.Vehicle_ID__c = testVehicleMB.Id;
        insert testVR;
        testVR.Contact__c = testAccount.Id;
        testVR.Vehicle_ID__c = testVehicleMB.Id;
        update testVR;
        
        //testVR_vehicle.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Vehicle__c', 'Self Registered');
        testVR_vehicle.RecordTypeId = SelfRegisteredRecordtypeid;
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
                //List<VehiclePickerForCaseControllerTR.vehicleWrapper> resultVehicles = VehiclePickerForCaseControllerTR.searchVehicles(JSON.serialize(searchDetails));
                
                //Vehicle__c tmpVehicle = [Select UsVIN__c from Vehicle__c Where Id =:resultVehicles[0].vehIdW];
                
                
            }else{
                Map<String,String> searchDetails = new Map<String,String>();
                searchDetails.put('VIN','');
                searchDetails.put('VehicleType',vehicle);
                searchDetails.put('RecordId',testCase.Id);
                List<VehiclePickerForCaseControllerTR.vehicleWrapper> resultVehicles = VehiclePickerForCaseControllerTR.searchVehicles(JSON.serialize(searchDetails));
                system.debug('Searched Other Vehicles:' +resultVehicles);
                system.debug('Searched Other Vehicles count:' +resultVehicles.size());
                
            }
        }
        test.StopTest();
    }

 public static testMethod void testLookupSearchcurrentVehicle(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        ApexPages.StandardController sc = new ApexPages.StandardController(testCase);
        VehiclePickerForCaseControllerTR vpc = new VehiclePickerForCaseControllerTR(sc);
        
        //Creating associated data for search test.
        //Account testAccount = (Account)UtilTestData.createSobject(new Account(Data_Source__c='Past Data',Mobile__c ='000-123-4567'), UtilConstant.person_Account);
        Account testAccount = new Account(RecordTypeId=personRecordtypeid,FirstName='test',LastName='test23',Data_Source__c='Past Data');
        insert testAccount;
        system.debug('$$$$$$$$$$$$'+testAccount);
        system.debug('$$$$$$$$$$$$'+testAccount.Id);
        testCase.AccountId = testAccount.Id;
        update testCase;
        
        String Vin = '87465345982346578';
        //Vehicle__c testVIN_Vehicle = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345'), UtilConstant.MB);
        Vehicle__c testVIN_Vehicle = new Vehicle__c(RecordTypeId=vehicleMBRecordtypeid,Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', 
                                                    Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
        insert testVIN_Vehicle;                                     
        testVIN_Vehicle.UsVIN__c = Vin;
        update testVIN_Vehicle;
        
        //Vehicle__c testVR_vehicle = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345'), UtilConstant.MB);
        Vehicle__c testVR_vehicle = new Vehicle__c(RecordTypeId=vehicleMBRecordtypeid,Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', 
                                                    Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
        insert testVR_vehicle;
        //Vehicle_Relationship__c testVR  = (Vehicle_Relationship__c)UtilTestData.createSobject(new Vehicle_Relationship__c(), UtilConstant.Vehicle_Relationship_Retail);
        Vehicle_Relationship__c testVR  = new Vehicle_Relationship__c(RecordTypeId=VehicleRelationshipRetailRecordtypeid );        
        testVR.Contact__c = testAccount.Id;
        testVR.Vehicle_ID__c = testVehicleMB.Id;
        insert testVR;
        testVR.Contact__c = testAccount.Id;
        testVR.Vehicle_ID__c = testVehicleMB.Id;
        update testVR;
        
        //testVR_vehicle.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Vehicle__c', 'Self Registered');
        testVR_vehicle.RecordTypeId = SelfRegisteredRecordtypeid;
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
                //List<VehiclePickerForCaseControllerTR.vehicleWrapper> resultVehicles = VehiclePickerForCaseControllerTR.searchVehicles(JSON.serialize(searchDetails));
                
                //Vehicle__c tmpVehicle = [Select UsVIN__c from Vehicle__c Where Id =:resultVehicles[0].vehIdW];
                
                
            }else{
                Map<String,String> searchDetails = new Map<String,String>();
                searchDetails.put('VIN','');
                searchDetails.put('VehicleType',vehicle);
                searchDetails.put('RecordId',testCase.Id);
                List<VehiclePickerForCaseControllerTR.vehicleWrapper> resultVehicles = VehiclePickerForCaseControllerTR.searchforCurrentVehicles(JSON.serialize(searchDetails));
                system.debug('Searched Other Vehicles:' +resultVehicles);
                system.debug('Searched Other Vehicles count:' +resultVehicles.size());
             
            }
        }
        test.StopTest();
    }   
}