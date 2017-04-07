@isTest
public without sharing class LeadVehiclePickerKRControllerTests{
    
    private static Lead__c testLead;
    private static Vehicle__c testVehicleMB;
    private static Vehicle__c testVehicle_VehicleProduct;
    private static List<Car_Model__c> carModels;
    private static List<Map<String, Set<String>>> carModelMap;
    public static user usr;
    public static List<Vehicle_Relationship__c> vrlist;
    public static List<Vehicle__c> vechlist;
    private static List<String> vehicleTypes = new List<String> {'Interested Vehicle', 'Competitor Vehicle', 'CurrentVehicle1', 'CurrentVehicle2', 'TradeIn', 'Purchased'};
    public static Id personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id salesleadsRecordtypeid = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
    public static Id vehicleMBRecordtypeid = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
    public static Id VehicleProductRecordtypeid = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('Vehicle Product').getRecordTypeId();
    public static Id SelfRegisteredRecordtypeid = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('Self Registered').getRecordTypeId();
    public static Id VehicleRelationshipRetailRecordtypeid = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();
    public static void createTestData(){
    
    /********************* CREATING TEST DATA : START **************************/
        
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        //insert updatecustomsettings;
Trigger__c TriggerAddress=new Trigger__c(Name='TriggerAccountLink',Trigger_Name__c='TriggerAccountLink',Trigger_Handler__c='TriggerAccountLinkTriggerHandlerJP',update__c=False,insert__c=False,delete__c=False,after__c=False,before__c=False,enabled__c=False,Market__c='JP');
        insert TriggerAddress;
        Trigger__c TriggerAddress1=new Trigger__c(Name='TriggerLead',Trigger_Name__c='TriggerLead',Trigger_Handler__c='TriggerLeadTriggerHandlerJP',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='JP');
        //insert TriggerAddress1;
        UtilConstant utilConst = new UtilConstant();     
        //testLead = (Lead__c)UtilTestData.createSobject(new Lead__c(), UtilConstant.SALES_LEADS);
        Account ta = new Account(RecordTypeId=personRecordtypeid,LastName='test123',MBK_Data_Source__c='Email');
        insert ta;
        system.debug('Accounts... :' +ta );
        testLead = new Lead__c(RecordTypeId=salesleadsRecordtypeid,Contact__c = ta.Id,CAC_Lead_Status__c = 'Qualified',Lead_Type__c = 'New Car');
        insert testLead;
        system.debug('Leads... :' +testLead);
        for(ApexPages.Message msg :  ApexPages.getMessages()) {
            System.assertEquals('Have a nice day', msg.getSummary());
            System.assertEquals(ApexPages.Severity.ERROR, msg.getSeverity());
        }
        
        /*
        lead.Relation_With_The_Leads__c = 'testR';
        lead.Lead_Desired_Service__c = 'Trade-In';
        lead.Purchase_Time__c = '0 - 3 months';
        lead.Interested_Vehicle_Brand__c = 'testI';
        lead.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead.Trade_In_Vehicle_Brand__c = 'c230';
        lead.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead.Trade_In_Other_Vehicle_Model__c = 'testT';
        lead.Interested_Vehicle_Brand__c = 'Smart';
        lead.Assigned_Dealer__c = dealer.Id;
        */
        
        //testVehicleMB = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345'), UtilConstant.MB);
        testVehicleMB = new Vehicle__c(RecordTypeId=vehicleMBRecordtypeid,Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', 
                                       Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
        system.debug('Test Vehicle1' +testVehicleMB);                                              
        
        //testVehicle_VehicleProduct = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345'), utilConst.VEHICLE_PRODUCT);
        testVehicle_VehicleProduct = new Vehicle__c(RecordTypeId=VehicleProductRecordtypeid,Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', 
                                                    Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
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
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerKRController vpc = new LeadVehiclePickerKRController(sc);
        
        carModelMap = LeadVehiclePickerKRController.getCarModels('None');
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
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerKRController vpc = new LeadVehiclePickerKRController(sc);
        carModelMap = LeadVehiclePickerKRController.getCarModels('Competitor');
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
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerKRController vpc = new LeadVehiclePickerKRController(sc);
        carModelMap = LeadVehiclePickerKRController.getCarModels('Own Sellable');
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
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerKRController vpc = new LeadVehiclePickerKRController(sc);
        carModelMap = LeadVehiclePickerKRController.getCarModels('Own Non Sellable');
        system.debug('Own Non Sellable Car Models :' +carModelMap);
        Map<String, Set<String>> tempMap = carModelmap[0];
        System.debug('Size of the Car Model Map :' +tempMap.size());
        test.StopTest();
        //System.assertEquals(tempMap.size(),1);
    }
       
    /*public static testMethod void testCreateNewVehicle(){
    
        //@@@@@@@@@@@ NEW VEHICLE @@@@@@@@@@@
        
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerKRController vpc = new LeadVehiclePickerKRController(sc);
        String vehicleDetials;
        LeadVehiclePickerKRController.updateVehicleDetails(vehicleDetials);
        test.startTest();
        
        //String vehicleDetials;
        //Map<String,String> tempMap_New = new Map<String,String>();
        //vehicleDetials = JSON.serialize(tempMap_New);
        //LeadVehiclePickerKRController.updateVehicleDetails(vehicleDetials);
         Lead__c leadDetails = [Select Interested_Vehicle__c,Interested_Competitor_Vehicle__c,Current_Vehicle_1__c,Current_Vehicle_2__c,Trade_In_Vehicle__c,Purchased_Vehicle__c from Lead__c where Id =:testLead.Id];
		 lead_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:leadDetails];
        for (String vehicle : vehicleTypes){
        
            String leadId = testLead.Id;
                  
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
            system.debug('$$$$$$$$$$$$'+vehicleDetials);
            
            
            Lead__c leadDetails;
            Vehicle__c lead_VehicleDetails;
            if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                //leadDetails = [Select Interested_Vehicle__c from Lead__c where Id =:testLead.Id];
                //lead_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:leadDetails.Interested_Vehicle__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
                //leadDetails = [Select Interested_Competitor_Vehicle__c from Lead__c where Id =:testLead.Id];
                //lead_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:leadDetails.Interested_Competitor_Vehicle__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                leadDetails = [Select Current_Vehicle_1__c from Lead__c where Id =:testLead.Id];
                //lead_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c from Vehicle__c Where Id =:leadDetails.Current_Vehicle_1__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                //leadDetails = [Select Current_Vehicle_2__c from Lead__c where Id =:testLead.Id];
                //lead_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:leadDetails.Current_Vehicle_2__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                //leadDetails = [Select Trade_In_Vehicle__c from Lead__c where Id =:testLead.Id];
                //lead_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:leadDetails.Trade_In_Vehicle__c];
            }
            else if (vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                //leadDetails = [Select Purchased_Vehicle__c from Lead__c where Id =:testLead.Id];
                //lead_VehicleDetails = [Select Brand__c, Class__c, Model__c, Model_Description__c,Colour__c, Trim__c, NextMileage__c From Vehicle__c Where Id =:leadDetails.Purchased_Vehicle__c];
            }
                
            
            System.assertEquals(lead_VehicleDetails.Brand__c,'AMG');
            System.assertEquals(lead_VehicleDetails.Class__c,'A-Class');
            System.assertEquals(lead_VehicleDetails.Model_Description__c,'A160');
            System.assertEquals(lead_VehicleDetails.Colour__c,'Green');
            System.assertEquals(lead_VehicleDetails.Trim__c,'Yellow');
            System.assertEquals(lead_VehicleDetails.NextMileage__c,45);
            
            //@@@@@@@@@@@ EDIT VEHICLE @@@@@@@@@@@
            
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
            LeadVehiclePickerKRController.updateVehicleDetails(vehicleDetials);
            
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
        
    }*/
    
    public static testMethod void testLookupVehicle(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerKRController vpc = new LeadVehiclePickerKRController(sc);
        Map<String,String> tempMap = new Map<String,String>();
		Lead__c leadDetails = [Select Interested_Vehicle__c,Interested_Competitor_Vehicle__c,Current_Vehicle_1__c,Current_Vehicle_2__c,Trade_In_Vehicle__c,Purchased_Vehicle__c from Lead__c where Id =:testLead.Id];
        for(String vehicle : vehicleTypes){
            tempMap.put('Id',testVehicleMB.Id);
            tempMap.put('VehicleType',vehicle);
            tempMap.put('Lookup','true');
            tempMap.put('CurrentRecordId',testLead.Id);
            String vehicleDetails = JSON.serialize(tempMap);
            system.debug('Vehicle Detials for Lookup...' +vehicleDetails);
            LeadVehiclePickerKRController.updateVehicleDetails(vehicleDetails);
            
            if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                //leadDetails = [Select Interested_Vehicle__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Interested_Vehicle__c,testVehicleMB.Id);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                //leadDetails = [Select Current_Vehicle_1__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Current_Vehicle_1__c,testVehicleMB.Id);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                //leadDetails = [Select Current_Vehicle_2__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Current_Vehicle_2__c,testVehicleMB.Id);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                //leadDetails = [Select Trade_In_Vehicle__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Trade_In_Vehicle__c,testVehicleMB.Id);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                //leadDetails = [Select Purchased_Vehicle__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Purchased_Vehicle__c,testVehicleMB.Id);
            }
            
        }
        test.stopTest();
    }
    

    public static testMethod void testClearNewVehicle(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerKRController vpc = new LeadVehiclePickerKRController(sc);
        test.startTest();
		Lead__c leadDetails = [Select Interested_Vehicle__c,Interested_Competitor_Vehicle__c,Current_Vehicle_1__c,Current_Vehicle_2__c,Trade_In_Vehicle__c,Purchased_Vehicle__c from Lead__c where Id =:testLead.Id];
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
            LeadVehiclePickerKRController.updateVehicleDetails(vehicleDetials);
            

            
            //Lead__c leadDetails;
            //Clear the Vehicle:
            Map<String,String> clearVehicleDetails = new Map<String,String>();
            clearVehicleDetails.put('VehicleType',vehicle);
            clearVehicleDetails.put('CurrentRecordId',testLead.Id);
        
            LeadVehiclePickerKRController.clearVehicleFromLead(JSON.serialize(clearVehicleDetails));
           
            if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                //leadDetails = [Select Interested_Vehicle__c from Lead__c where Id =:testLead.Id];
                system.debug('Cleared Vehicle Id:' +leadDetails.Interested_Vehicle__c);
                System.assertEquals(leadDetails.Interested_Vehicle__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
                //leadDetails = [Select Interested_Competitor_Vehicle__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Interested_Competitor_Vehicle__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                //leadDetails = [Select Current_Vehicle_1__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Current_Vehicle_1__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                //leadDetails = [Select Current_Vehicle_2__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Current_Vehicle_2__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                //leadDetails = [Select Trade_In_Vehicle__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Trade_In_Vehicle__c,null);
            }
            else if (vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                //leadDetails = [Select Purchased_Vehicle__c from Lead__c where Id =:testLead.Id];
                System.assertEquals(leadDetails.Purchased_Vehicle__c,null);
            }
            
            
            
        }
        test.StopTest();
    }
    
    
    
    public static testMethod void testLookupClear(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerKRController vpc = new LeadVehiclePickerKRController(sc);
        Map<String,String> tempMap = new Map<String,String>();
		Lead__c leadDetails = [Select Interested_Vehicle__c,Interested_Competitor_Vehicle__c,Current_Vehicle_1__c,Current_Vehicle_2__c,Trade_In_Vehicle__c,Purchased_Vehicle__c from Lead__c where Id =:testLead.Id];
        for(String vehicle : vehicleTypes){
        
            if (!vehicle.equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
                tempMap.put('Id',testVehicleMB.Id);
                tempMap.put('VehicleType',vehicle);
                tempMap.put('Lookup','true');
                tempMap.put('CurrentRecordId',testLead.Id);
                String vehicleDetails = JSON.serialize(tempMap);
                system.debug('Vehicle Detials for Lookup...' +vehicleDetails);
                LeadVehiclePickerKRController.updateVehicleDetails(vehicleDetails);
                
                //Clear the Vehicle:
                Map<String,String> clearVehicleDetails = new Map<String,String>();
                clearVehicleDetails.put('VehicleType',vehicle);
                clearVehicleDetails.put('CurrentRecordId',testLead.Id);
                //LeadVehiclePickerKRController.clearVehicleFromLead(JSON.serialize(clearVehicleDetails));
                
               if (vehicle.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                    //leadDetails = [Select Interested_Vehicle__c from Lead__c where Id =:testLead.Id];
                    system.debug('Cleared Vehicle Id:' +leadDetails.Interested_Vehicle__c);
                    System.assertEquals(leadDetails.Interested_Vehicle__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                    //leadDetails = [Select Current_Vehicle_1__c from Lead__c where Id =:testLead.Id];
                    System.assertEquals(leadDetails.Current_Vehicle_1__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                    //leadDetails = [Select Current_Vehicle_2__c from Lead__c where Id =:testLead.Id];
                    System.assertEquals(leadDetails.Current_Vehicle_2__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                    //leadDetails = [Select Trade_In_Vehicle__c from Lead__c where Id =:testLead.Id];
                    System.assertEquals(leadDetails.Trade_In_Vehicle__c,null);
                }
                else if (vehicle.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                    //leadDetails = [Select Purchased_Vehicle__c from Lead__c where Id =:testLead.Id];
                    System.assertEquals(leadDetails.Purchased_Vehicle__c,null);
                }
                
                
            }
            
        }
        test.stopTest();
    }
    
    
    public static testMethod void testLookupSearch(){
        UtilConstant utilConst = new UtilConstant();
        createTestData();
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerKRController vpc = new LeadVehiclePickerKRController(sc);
        
        //Creating associated data for search test.
        //Account testAccount = (Account)UtilTestData.createSobject(new Account(MBK_Data_Source__c='Email',Mobile__c ='000-123-4567'), UtilConstant.person_Account);
        Account testAccount = new Account(RecordTypeId=personRecordtypeid,LastName='test23',MBK_Data_Source__c='Email');
        insert testAccount;
        system.debug('$$$$$$$$$$$$'+testAccount);
        system.debug('$$$$$$$$$$$$'+testAccount.Id);
        testLead.Contact__c = testAccount.Id;
        system.debug('$$$$$$$$$$$$'+testLead.Contact__c);
        update testLead;
        
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
                searchDetails.put('RecordId',testLead.Id);
                List<Vehicle__c> resultVehicles = LeadVehiclePickerKRController.searchVehicles(JSON.serialize(searchDetails));
                system.debug('PSM PSM PSM resultVehicles '+resultVehicles);
                system.debug('PSM PSM PSM resultVehicles[0].Id '+resultVehicles[0].Id);
                Vehicle__c tmpVehicle = [Select UsVIN__c from Vehicle__c Where Id =:resultVehicles[0].Id];
                system.debug('Vehicle VIn number :' +tmpVehicle.UsVIN__c);
                System.assertEquals(tmpVehicle.UsVIN__c,'87465345982346578');
                
            }else{
                Map<String,String> searchDetails = new Map<String,String>();
                searchDetails.put('VIN','');
                searchDetails.put('VehicleType',vehicle);
                searchDetails.put('RecordId',testLead.Id);
                List<Vehicle__c> resultVehicles = LeadVehiclePickerKRController.searchVehicles(JSON.serialize(searchDetails));
                system.debug('Searched Other Vehicles:' +resultVehicles);
                system.debug('Searched Other Vehicles count:' +resultVehicles.size());
                System.assertEquals(resultVehicles.size(),1);
            }
        }
        test.StopTest();
    }       
}