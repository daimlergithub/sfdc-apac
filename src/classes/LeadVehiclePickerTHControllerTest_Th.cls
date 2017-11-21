/****************************************************************
Created by  : Manjunath C Sarashetti

*******************************************************************/

@isTest
public without sharing class LeadVehiclePickerTHControllerTest_Th{
    /***************************************************
    This method is used to test clearVehicleFromLead
    ****************************************************/
     private static Lead__c testLead;
    private static Vehicle__c testVehicleMB;
    private static Vehicle__c testVehicle_VehicleProduct;
    private static List<Car_Model__c> carModels;
    private static List<Map<String, Set<String>>> carModelMap;
  private static Contact con;
   private static Vehicle__c vehicle;
      private static Vehicle_Relationship__c vehicle_relationship;
    private static List<String> vehicleTypes = new List<String> {'Interested Vehicle', 'Competitor Vehicle', 'CurrentVehicle1', 'CurrentVehicle2', 'TradeIn', 'Purchased'};
  
    
    public static testMethod void TestCase(){
        Profile profile = [Select Id from Profile where Name = 'System Administrator'];
        User us = TestClassHelper.createUser('User1PH',profile,'TH');
        insert US;
        system.runAs(US){
        test.starttest();
            Lead__c Ld = TestClassHelper.CreateLeadRec();
            ld.MD__c='TH';
            insert ld;
            ApexPages.StandardController sc = new ApexPages.StandardController(ld);
            LeadVehiclePickerTHController vpc = new LeadVehiclePickerTHController(sc);
            Map<string, id> rTypes = new Map<string, id>();
            rTypes = TestClassHelper.getRecordType('Vehicle__c');
            Vehicle__c  vhCompetitor  = TestClassHelper.CreateVehicleRec(rTypes.get('Competitor'));
            vhCompetitor.MD__c='TH';

            insert vhCompetitor  ;
            
            ld.Interested_Vehicle__c = vhCompetitor.id;
            ld.Interested_Competitor_Vehicle__c= vhCompetitor.id;
            ld.Current_Vehicle_1__c= vhCompetitor.id;
            ld.Current_Vehicle_2__c= vhCompetitor.id;
            ld.Trade_In_Vehicle__c= vhCompetitor.id;
            ld.Purchased_Vehicle__c= vhCompetitor.id;
            update ld;
            Map<String,String> clearVehicleDetails = new Map<String,String>();
            clearVehicleDetails.put('VehicleType','Interested Vehicle');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            LeadVehiclePickerTHController.clearVehicleFromLead(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('VehicleType','Competitor Vehicle');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            LeadVehiclePickerTHController.clearVehicleFromLead(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('VehicleType','CurrentVehicle1');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            system.assertEquals(clearVehicleDetails.get('VehicleType'),'CurrentVehicle1');
            LeadVehiclePickerTHController.clearVehicleFromLead(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('VehicleType','CurrentVehicle2');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            system.assertEquals(clearVehicleDetails.get('VehicleType'),'CurrentVehicle2');
            LeadVehiclePickerTHController.clearVehicleFromLead(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('VehicleType','TradeIn');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            system.assertEquals(clearVehicleDetails.get('VehicleType'),'TradeIn');
            LeadVehiclePickerTHController.clearVehicleFromLead(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('VehicleType','Purchased');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            system.assertEquals(clearVehicleDetails.get('VehicleType'),'Purchased');
            test.stoptest();
            LeadVehiclePickerTHController.clearVehicleFromLead(JSON.serialize(clearVehicleDetails));
            
        }
    } 
    
    /***************************************************
    This method is used to test updateVehicleDetails
    ****************************************************/
    public static testMethod void TestCase1(){
        Profile profile = [Select Id from Profile where Name = 'System Administrator'];
        User us = TestClassHelper.createUser('User2PH',profile,'TH');
        insert US;
        system.runAs(US){
        test.starttest();
            Lead__c Ld = TestClassHelper.CreateLeadRec();
            ld.MD__c='TH';
            insert ld;
            ApexPages.StandardController sc = new ApexPages.StandardController(ld);
            LeadVehiclePickerTHController vpc = new LeadVehiclePickerTHController(sc);
            Map<string, id> rTypes = new Map<string, id>();
            rTypes = TestClassHelper.getRecordType('Vehicle__c');
            Vehicle__c  vhCompetitor  = TestClassHelper.CreateVehicleRec(rTypes.get('Competitor'));
            vhCompetitor.MD__c='TH';
            
            insert vhCompetitor  ;
            
            ld.Interested_Vehicle__c = vhCompetitor.id;
            ld.Interested_Competitor_Vehicle__c= vhCompetitor.id;
            ld.Current_Vehicle_1__c= vhCompetitor.id;
            ld.Current_Vehicle_2__c= vhCompetitor.id;
            ld.Trade_In_Vehicle__c= vhCompetitor.id;
            ld.Purchased_Vehicle__c= vhCompetitor.id;
            update ld;
            Map<String,String> clearVehicleDetails = new Map<String,String>();
            clearVehicleDetails.put('VehicleType','Interested Vehicle');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','true');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            system.assertEquals(clearVehicleDetails.get('VehicleType'),'Interested Vehicle');
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('VehicleType','CurrentVehicle1');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','true');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            system.assertEquals(clearVehicleDetails.get('VehicleType'),'CurrentVehicle1');
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('VehicleType','CurrentVehicle2');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','true');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            system.assertEquals(clearVehicleDetails.get('VehicleType'),'CurrentVehicle2');
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('VehicleType','TradeIn');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','true');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            system.assertEquals(clearVehicleDetails.get('VehicleType'),'TradeIn');
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('VehicleType','Purchased');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','true');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            test.stoptest();
            system.assertEquals(clearVehicleDetails.get('VehicleType'),'Purchased');
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
            
        }
    } 
    /***************************************************
    This method is used to test updateVehicleDetails - New version
    ****************************************************/
    public static testMethod void TestCase3(){
        Profile profile = [Select Id from Profile where Name = 'System Administrator'];
        User us = TestClassHelper.createUser('User3PH',profile,'TH');
        insert US;
        system.runAs(US){
        test.starttest();
            Lead__c Ld = TestClassHelper.CreateLeadRec();
            ld.MD__c='TH';
            insert ld;
            ApexPages.StandardController sc = new ApexPages.StandardController(ld);
            LeadVehiclePickerTHController vpc = new LeadVehiclePickerTHController(sc);
            Map<string, id> rTypes = new Map<string, id>();
            rTypes = TestClassHelper.getRecordType('Vehicle__c');
            Vehicle__c  vhCompetitor  = TestClassHelper.CreateVehicleRec(rTypes.get('Competitor'));
            vhCompetitor.MD__c='TH';
            insert vhCompetitor  ;
            
            ld.Interested_Vehicle__c = vhCompetitor.id;
            ld.Interested_Competitor_Vehicle__c= vhCompetitor.id;
            ld.Current_Vehicle_1__c= vhCompetitor.id;
            ld.Current_Vehicle_2__c= vhCompetitor.id;
            ld.Trade_In_Vehicle__c= vhCompetitor.id;
            ld.Purchased_Vehicle__c= vhCompetitor.id;
            update ld;
            
            Car_Model__c carModel = TestClassHelper.CreateCarModelRec('Benz','Class A','A00');
            insert carModel ;
            Map<String,String> clearVehicleDetails = new Map<String,String>();
            clearVehicleDetails.put('LeadVehicleType','Interested Vehicle');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','false');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            clearVehicleDetails.put('Brand','Benz');
            clearVehicleDetails.put('Class','Class A');
            clearVehicleDetails.put('Colour','Black');
            clearVehicleDetails.put('Trim','1');
            clearVehicleDetails.put('Model','A00');
            clearVehicleDetails.put('Mileage','100');
            clearVehicleDetails.put('Operation','New');
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
            system.assertEquals(clearVehicleDetails.get('Operation'),'New');
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('LeadVehicleType','CurrentVehicle1');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','false');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            clearVehicleDetails.put('Brand','Benz');
            clearVehicleDetails.put('Class','Class A');
            clearVehicleDetails.put('Colour','Black');
            clearVehicleDetails.put('Trim','1');
            clearVehicleDetails.put('Model','A00');
            clearVehicleDetails.put('Mileage','100');
            clearVehicleDetails.put('Operation','New');
            system.assertEquals(clearVehicleDetails.get('Operation'),'New');
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('LeadVehicleType','CurrentVehicle2');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','false');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            clearVehicleDetails.put('Brand','Benz');
            clearVehicleDetails.put('Class','Class A');
            clearVehicleDetails.put('Colour','Black');
            clearVehicleDetails.put('Trim','1');
            clearVehicleDetails.put('Model','A00');
            clearVehicleDetails.put('Mileage','100');
            clearVehicleDetails.put('Operation','New');
            system.assertEquals(clearVehicleDetails.get('Operation'),'New');
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('LeadVehicleType','TradeIn');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','false');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            clearVehicleDetails.put('Brand','Benz');
            clearVehicleDetails.put('Class','Class A');
            clearVehicleDetails.put('Colour','Black');
            clearVehicleDetails.put('Trim','1');
            clearVehicleDetails.put('Model','A00');
            clearVehicleDetails.put('Mileage','100');
            clearVehicleDetails.put('Operation','New');
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('LeadVehicleType','Purchased');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','false');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            clearVehicleDetails.put('Brand','Benz');
            clearVehicleDetails.put('Class','Class A');
            clearVehicleDetails.put('Colour','Black');
            clearVehicleDetails.put('Trim','1');
            clearVehicleDetails.put('Model','A00');
            clearVehicleDetails.put('Mileage','100');
            clearVehicleDetails.put('Operation','New');
            test.stoptest();
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
        }
    } 
    /***************************************************
    This method is used to test updateVehicleDetails - Edit 
    ****************************************************/
    // updateVehicleDetails edit
    public static testMethod void TestCase4(){
        Profile profile = [Select Id from Profile where Name = 'System Administrator'];
         test.starttest();
        User us = TestClassHelper.createUser('User4PH',profile,'TH');
        insert US;
        system.runAs(US){
            Lead__c Ld = TestClassHelper.CreateLeadRec();
           
            ld.MD__c='TH';
            insert ld;
            ApexPages.StandardController sc = new ApexPages.StandardController(ld);
            LeadVehiclePickerTHController vpc = new LeadVehiclePickerTHController(sc);
            Map<string, id> rTypes = new Map<string, id>();
            rTypes = TestClassHelper.getRecordType('Vehicle__c');
            Vehicle__c  vhCompetitor  = TestClassHelper.CreateVehicleRec(rTypes.get('Competitor'));
            vhCompetitor.MD__c='TH';

            insert vhCompetitor  ;
            
            ld.Interested_Vehicle__c = vhCompetitor.id;
            ld.Interested_Competitor_Vehicle__c= vhCompetitor.id;
            ld.Current_Vehicle_1__c= vhCompetitor.id;
            ld.Current_Vehicle_2__c= vhCompetitor.id;
            ld.Trade_In_Vehicle__c= vhCompetitor.id;
            ld.Purchased_Vehicle__c= vhCompetitor.id;
            update ld;
            
            Car_Model__c carModel = TestClassHelper.CreateCarModelRec('Benz','Class A','A00');
            insert carModel ;
            Map<String,String> clearVehicleDetails = new Map<String,String>();
            clearVehicleDetails.put('LeadVehicleType','Interested Vehicle');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','false');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            clearVehicleDetails.put('Brand','Benz');
            clearVehicleDetails.put('Class','Class A');
            clearVehicleDetails.put('Colour','Black');
            clearVehicleDetails.put('Trim','1');
            clearVehicleDetails.put('Model','A00');
            clearVehicleDetails.put('Mileage','100');
            clearVehicleDetails.put('Operation','Edit');
            system.assertEquals(clearVehicleDetails.get('Operation'),'Edit');
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('LeadVehicleType','CurrentVehicle1');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','false');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            clearVehicleDetails.put('Brand','Benz');
            clearVehicleDetails.put('Class','Class A');
            clearVehicleDetails.put('Colour','Black');
            clearVehicleDetails.put('Trim','1');
            clearVehicleDetails.put('Model','A00');
            clearVehicleDetails.put('Mileage','100');
            clearVehicleDetails.put('Operation','Edit');
            system.assertEquals(clearVehicleDetails.get('Operation'),'Edit');
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('LeadVehicleType','CurrentVehicle2');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','false');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            clearVehicleDetails.put('Brand','Benz');
            clearVehicleDetails.put('Class','Class A');
            clearVehicleDetails.put('Colour','Black');
            clearVehicleDetails.put('Trim','1');
            clearVehicleDetails.put('Model','A00');
            clearVehicleDetails.put('Mileage','100');
            clearVehicleDetails.put('Operation','Edit');
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('LeadVehicleType','TradeIn');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','false');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            clearVehicleDetails.put('Brand','Benz');
            clearVehicleDetails.put('Class','Class A');
            clearVehicleDetails.put('Colour','Black');
            clearVehicleDetails.put('Trim','1');
            clearVehicleDetails.put('Model','A00');
            clearVehicleDetails.put('Mileage','100');
            clearVehicleDetails.put('Operation','Edit');
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('LeadVehicleType','Purchased');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','false');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            clearVehicleDetails.put('Brand','Benz');
            clearVehicleDetails.put('Class','Class A');
            clearVehicleDetails.put('Colour','Black');
            clearVehicleDetails.put('Trim','1');
            clearVehicleDetails.put('Model','A00');
            clearVehicleDetails.put('Mileage','100');
            clearVehicleDetails.put('Operation','Edit');
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
            test.stoptest();
        }
    } 
    /***************************************************
    This method is used to test searchVehicles
    ****************************************************/
   
    public static testMethod void TestCase5(){
        Profile profile = [Select Id from Profile where Name = 'System Administrator'];
        test.starttest();
        User us = TestClassHelper.createUser('User5PH',profile,'TH');
        insert US;
        system.runAs(US){
            Lead__c Ld = TestClassHelper.CreateLeadRec();
            //ld.LastName ='TestRecord';
            ld.MD__c='TH';
            insert ld;
            ApexPages.StandardController sc = new ApexPages.StandardController(ld);
            LeadVehiclePickerTHController vpc = new LeadVehiclePickerTHController(sc);
            Map<string, id> rTypes = new Map<string, id>();
            rTypes = TestClassHelper.getRecordType('Vehicle__c');
            Vehicle__c  vhCompetitor  = TestClassHelper.CreateVehicleRec(rTypes.get('Competitor'));
            vhCompetitor.MD__c='TH';
            insert vhCompetitor  ;
            
            
            Map<string, id> rTypesAcc = new Map<string, id>();
            rTypesAcc = TestClassHelper.getRecordType('Account');
            Account acc  = TestClassHelper.CreateAccRec('LastName');
            acc.Email__c='test@test.com';
            acc.recordTypeid=rTypesAcc.get('Person Account');
            insert acc;
            
            ld.Interested_Vehicle__c = vhCompetitor.id;
            ld.Interested_Competitor_Vehicle__c= vhCompetitor.id;
            ld.Current_Vehicle_1__c= vhCompetitor.id;
            ld.Current_Vehicle_2__c= vhCompetitor.id;
            ld.Trade_In_Vehicle__c= vhCompetitor.id;
            ld.Purchased_Vehicle__c= vhCompetitor.id;
            ld.Contact__c=acc.id;
            update ld;
            
            Car_Model__c carModel = TestClassHelper.CreateCarModelRec('Benz','Class A','A00');
            insert carModel ;
            Map<String,String> lookupSearchDetails = new Map<String,String>();
            lookupSearchDetails.put('LeadVehicleType','Interested Vehicle');
            lookupSearchDetails.put('CurrentRecordId',ld.Id);
            lookupSearchDetails.put('RecordId',ld.Id);
            lookupSearchDetails.put('Lookup','false');
            lookupSearchDetails.put('VehicleType','Interested Vehicle');
            lookupSearchDetails.put('VIN','');
            system.assertEquals(lookupSearchDetails.get('Lookup'),'false');
            LeadVehiclePickerTHController.searchVehicles(JSON.serialize(lookupSearchDetails));
            
            lookupSearchDetails.clear();
            lookupSearchDetails.put('LeadVehicleType','Interested Vehicle');
            lookupSearchDetails.put('CurrentRecordId',ld.Id);
            lookupSearchDetails.put('RecordId',ld.Id);
            lookupSearchDetails.put('Lookup','false');
            lookupSearchDetails.put('VehicleType','Competitor Vehicle');
            lookupSearchDetails.put('VIN','');
            LeadVehiclePickerTHController.searchVehicles(JSON.serialize(lookupSearchDetails));
            test.stoptest();
        }
     }
     //dhanam
     
     public static void createTestData(){
    
    /********************* CREATING TEST DATA : START **************************/
        
       Id devRecordTypeId  = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();

       Account dealer=new Account();
         
        dealer.RecordTypeId = devRecordTypeId;
        dealer.Dealer_Alternate_Name__c = 'Test Alternate';
        dealer.Phone = '+66-03-777-9999';
        dealer.LastName='test';
        dealer.email__c='Dhanamjaya@gmail.com';
        dealer.Individual_Home_Phone__c='+6612123789';
        insert dealer;
        testLead=new Lead__c();
        insert testLead;
        con = new Contact (LastName = 'portalTestUser',Dealer_Complaint_Gate_Keeper__c=true, Permission_Set_Settings__c = 'S_M_Retail_Campaign');
        insert con;  
        vehicle=new vehicle__c();
        vehicle.UsVIN__c = 'usvin111111111111'; 
        vehicle.EuroVIN__c = 'eurovin1234567890';
        vehicle.Brand__c = 'MB';
        vehicle.Class__c = 'A-Class';
        vehicle.Model__c = 'A160';
        vehicle.Colour__c = 'white';
        vehicle.CommissionNumber__c = '123456';
        insert vehicle;    
        UtilConstant utilConst = new UtilConstant();     
        testVehicleMB = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(), UtilConstant.MB);
        testVehicle_VehicleProduct = (Vehicle__c)UtilTestData.createSobject(new Vehicle__c(), utilConst.VEHICLE_PRODUCT);
        List<String> carStatus = new List<String>{'Own Sellable', 'Own Non Sellable','Competitor'};
        List<String> brands = new List<String>{'AMG','Others','TRUCKS','Maybach'};
        List<String> classes = new List<String>{'A-CLASS','B-CLASS','C-CLASS','C-CLASS'};
        List<String> models = new List<String>{'A160','A180','B200','C200K Elegance'};
        carModels = new List<Car_Model__c>();
        for (Integer i=0; i<4; i++){
            carModels.add(new Car_Model__c());
        }
        carModels = (List<Car_Model__c>)UtilTestData.createSobjects(carModels, '');      
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
    }

    public static testMethod void testCarModels(){
        UtilConstant utilConst = new UtilConstant();
        test.starttest();
        Profile profile = [Select Id from Profile where Name = 'System Administrator'];
        User us = TestClassHelper.createUser('User1PH',profile,'TH');
        insert US;
        
        system.runAs(US){
        createTestData();
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerTHController vpc = new LeadVehiclePickerTHController(sc);
        carModelMap = LeadVehiclePickerTHController.getCarModels('None');
        Map<String, Set<String>> tempMap = carModelmap[0];
        test.StopTest();
        System.assertEquals(tempMap.size(),4);
        
        }
     
    }
    
    public static testMethod void error(){
    createTestData();
    test.StartTest();
    testLead.CAC_lead_status__c='Purchased';
        testLead.Bought_Vehicle_Brand__c='MB';
        testLead.Bought_Vehicle_Class__c='A-Class';
        testLead.Bought_Vehicle_Model__c='A160';
        testLead.Purchased_CAC_Date_Time__c=system.now();
        testLead.Purchased_CAC_Date__c=system.today();
        update testLead;
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerTHController vpc = new LeadVehiclePickerTHController(sc);
        testLead.Lead_Desired_Service__c='Trade-In';
        update testlead;
        test.StopTest();
        ApexPages.StandardController sc1 = new ApexPages.StandardController(testLead);
        LeadVehiclePickerTHController vpc1 = new LeadVehiclePickerTHController(sc);
    
    }
    public static testMethod void VehicleInsert(){
    createTestData();
    test.starttest();
    
        testLead.Interested_Vehicle__c=vehicle.id;
        
        update testLead;
        ApexPages.StandardController sc = new ApexPages.StandardController(testLead);
        LeadVehiclePickerTHController vpc = new LeadVehiclePickerTHController(sc);
        test.stoptest();
        system.assertEquals(vehicle.id,[select id from vehicle__c where id=:vehicle.id].id);
        }
}