/****************************************************************
Created by  : Manjunath C Sarashetti

*******************************************************************/

@isTest
public without sharing class LeadVehiclePickerTHControllerTest{
    
    public static testMethod void TestCase(){
        Profile profile = [Select Id from Profile where Name = 'System Administrator'];
        User us = TestClassHelper.createUser('User1PH',profile,'TH');
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
            LeadVehiclePickerTHController.clearVehicleFromLead(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('VehicleType','CurrentVehicle2');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            LeadVehiclePickerTHController.clearVehicleFromLead(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('VehicleType','TradeIn');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            LeadVehiclePickerTHController.clearVehicleFromLead(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('VehicleType','Purchased');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            LeadVehiclePickerTHController.clearVehicleFromLead(JSON.serialize(clearVehicleDetails));
        }
    } 
    
    
    // updateVehicleDetails
    public static testMethod void TestCase1(){
        Profile profile = [Select Id from Profile where Name = 'System Administrator'];
        User us = TestClassHelper.createUser('User2PH',profile,'TH');
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
            Map<String,String> clearVehicleDetails = new Map<String,String>();
            clearVehicleDetails.put('VehicleType','Interested Vehicle');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','true');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('VehicleType','CurrentVehicle1');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','true');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('VehicleType','CurrentVehicle2');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','true');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('VehicleType','TradeIn');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','true');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
            
            clearVehicleDetails.clear();
            clearVehicleDetails.put('VehicleType','Purchased');
            clearVehicleDetails.put('CurrentRecordId',ld.Id);
            clearVehicleDetails.put('Lookup','true');
            clearVehicleDetails.put('Id', vhCompetitor.id);
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
        }
    } 
    
    // updateVehicleDetails new
    public static testMethod void TestCase3(){
        Profile profile = [Select Id from Profile where Name = 'System Administrator'];
        User us = TestClassHelper.createUser('User3PH',profile,'TH');
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
            clearVehicleDetails.put('Operation','New');
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
            clearVehicleDetails.put('Operation','New');
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
            LeadVehiclePickerTHController.updateVehicleDetails(JSON.serialize(clearVehicleDetails));
        }
    } 
    // updateVehicleDetails edit
    public static testMethod void TestCase4(){
        Profile profile = [Select Id from Profile where Name = 'System Administrator'];
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
        }
    } 
    // updateVehicleDetails edit
    public static testMethod void TestCase5(){
        Profile profile = [Select Id from Profile where Name = 'System Administrator'];
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
            LeadVehiclePickerTHController.searchVehicles(JSON.serialize(lookupSearchDetails));
            
            lookupSearchDetails.clear();
            lookupSearchDetails.put('LeadVehicleType','Interested Vehicle');
            lookupSearchDetails.put('CurrentRecordId',ld.Id);
            lookupSearchDetails.put('RecordId',ld.Id);
            lookupSearchDetails.put('Lookup','false');
            lookupSearchDetails.put('VehicleType','Competitor Vehicle');
            lookupSearchDetails.put('VIN','');
            LeadVehiclePickerTHController.searchVehicles(JSON.serialize(lookupSearchDetails));
        }
     }
}