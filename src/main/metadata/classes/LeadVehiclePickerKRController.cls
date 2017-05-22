/**
** Controller class for the Vehicle Picker Page.
** 1. Provides the Brand, Class and Model values for the Vehicle Picker from Car Models.
** 2. Handles execution all the Vehicle Picker Operation like New, Edit and Clear.
** 3. Handles the Lookup search functionality.
** 
** Created By: Shrinivas Desai.
** Date:  3/12/2015
**/

global without sharing class LeadVehiclePickerKRController {
    
    public String currentRecordId {get;set;}
    public Lead__c lead_Vehicles {get; set;}
    public List<Vehicle_Relationship__c> leadOwnerVehiclesRelationships;
    public List<Vehicle__c> leadOwnerVehicles; 
    public String serialized_vehicleTypeMap {set;get;}
    public String lookup_Vehicles {set;get;}
    public String leadType {get;set;}
    
    Map<String, Set<String>> brandClassMap {get;set;}
    Map<String, Set<String>> classModelMap {get;set;}
    
    public List<Vehicle_Relationship__c> leadVehicleRelationships;
    
    public static user usr{
        get
        {
            if (usr == null)
            {
                usr = [select id,Market__c from User where id=:userinfo.getuserId()];
            }
            return usr;
        }
        private set;
    }

    /**
    *@Description : This method fetches all the vehicles that are associated with the Lead to pre-populate the values.
    *@Author : Shrinivas Desai.
    *@Date : 3/12/2015
    *@param: Apex standard controller.
    *@return: This is a constructor method.
    *@see: LeadVehiclePickerKRController
    */
    Public string profileName;
    Public boolean disableButtons{get;set;}
    public LeadVehiclePickerKRController(ApexPages.StandardController controller) {
        
        //profileName = userinfo.getprofilename();
        profile p = [select Name from profile where id =:userinfo.getprofileId()];
        disableButtons = true;
        if(p.Name.contains('Dealer Community User')){
            disableButtons = false;
        }
        currentRecordId  = controller.getId();
        System.debug('Lead Vehicles Types...' +lead_Vehicles);
        Set<Id> lead_VehicleIds;
        serialized_vehicleTypeMap = JSON.serialize(''); 
        lookup_Vehicles = JSON.serialize('');        
        brandClassMap = new Map<String, Set<String>>();
        classModelMap = new Map<String, Set<String>>();
        List<String> tempList = new List<String>();
        Map<String, Map<String,String>> mapVehicleTtype_Fields = new Map<String, Map<String, String>>();        
        Map<Id, List<String>> map_vehicleIds = new Map<Id, List<String>>();
        List<Id> vehicleIds = new List<Id>();
        List<Vehicle__c> vehiclesForLead;
        
        try{
        
            /***************** QUERY THE VEHICLES ASSOCIATED WITH THE LEAD : START *******************/
            if(!Test.isRunningTest()){
                lead_Vehicles = [Select Lead_Type__c, Interested_Vehicle__c, Interested_Competitor_Vehicle__c, Current_Vehicle_1__c, CAC_Lead_Status__c ,Dealer_Lead_Status__c ,Lead_Desired_Service__c,Current_Vehicle_2__c,Trade_In_Vehicle__c, Purchased_Vehicle__c From Lead__c Where Id =: currentRecordId  AND MD__c = :usr.Market__c];
            }
            else{
                lead_Vehicles = [Select Lead_Type__c, Interested_Vehicle__c, Interested_Competitor_Vehicle__c, Current_Vehicle_1__c, CAC_Lead_Status__c ,Dealer_Lead_Status__c ,Lead_Desired_Service__c,Current_Vehicle_2__c,Trade_In_Vehicle__c, Purchased_Vehicle__c From Lead__c Where Id =: currentRecordId];
            }
            leadType = lead_Vehicles.Lead_Type__c;
            system.debug('lead_Vehicles1:' +lead_Vehicles.Lead_Desired_Service__c);  
             if((lead_Vehicles.CAC_Lead_Status__c == 'Purchased(Only Non BDC)' || lead_Vehicles.Dealer_Lead_Status__c == 'Purchased(Only Non BDC)') && lead_Vehicles.Purchased_Vehicle__c == null){
                 ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Info, '<font color="red">' +System.Label.purchased_vehicle_related_information+ '</font>'));               
               
             }     
             if(lead_Vehicles.Lead_Desired_Service__c!= Null && lead_Vehicles.Lead_Desired_Service__c.contains('Trade-In') && lead_Vehicles.Trade_In_Vehicle__c == null){
              system.debug('lead_Vehicles2:' +lead_Vehicles.Lead_Desired_Service__c);
                ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.Info, '<font color="red">' +System.Label.Trade_In_related_information+ '</font>'));          
            
             } 
            
            system.debug('@ Intial Lead vehicle record values :' +lead_Vehicles);                                              
            lead_VehicleIds = new Set<Id>{  lead_Vehicles.Interested_Vehicle__c, lead_Vehicles.Interested_Competitor_Vehicle__c,
                                            lead_Vehicles.Current_Vehicle_1__c, lead_Vehicles.Current_Vehicle_2__c,lead_Vehicles.Trade_In_Vehicle__c,
                                            lead_Vehicles.Purchased_Vehicle__c
                                         };
            if(!Test.isRunningTest()){                           
                leadOwnerVehiclesRelationships = [select Vehicle_Id__r.Id from Vehicle_Relationship__c where Contact__c  IN (Select Contact__c from Lead__c where Id =:currentRecordId AND MD__c = :usr.Market__c)];  
            }else{
                leadOwnerVehiclesRelationships = [select Vehicle_Id__r.Id from Vehicle_Relationship__c where Contact__c  IN (Select Contact__c from Lead__c where Id =:currentRecordId)];
            }           
            System.debug('Lead Vehicle Relationships...' +leadOwnerVehiclesRelationships.size());
            for (Integer i=0; i < leadOwnerVehiclesRelationships.size(); i++){
                System.debug('In the For :' +leadOwnerVehiclesRelationships[i]);
                vehicleIds.add(leadOwnerVehiclesRelationships[i].Vehicle_Id__c);
            }
            if(!vehicleIds.isEmpty()){
                System.debug('Vehicle Ids' +vehicleIds);
                if(!Test.isRunningTest()){
                leadOwnerVehicles = [Select Brand__c, Class__c, Model_Description__c, UsVIN__c From Vehicle__c Where Id IN :vehicleIds AND MD__c = :usr.Market__c];
                }
                else{
                     leadOwnerVehicles = [Select Brand__c, Class__c, Model_Description__c, UsVIN__c From Vehicle__c Where Id IN :vehicleIds];
                }
                System.debug('Lead Owner vehicles...:' +leadOwnerVehicles);
                System.debug('Each Lead Vehicle type...' +lead_Vehicles.Interested_Vehicle__c); 
            }
            
            if (lead_Vehicles != null) {
                tempList = map_vehicleIds.get(lead_Vehicles.Interested_Vehicle__c);
                if (tempList == null){
                    map_vehicleIds.put(lead_Vehicles.Interested_Vehicle__c, new List<String>{'InterestedVehicle'});
                }else{
                    tempList.add('InterestedVehicle');
                }
                tempList = map_vehicleIds.get(lead_Vehicles.Interested_Competitor_Vehicle__c);
                if (tempList == null){
                     map_vehicleIds.put(lead_Vehicles.Interested_Competitor_Vehicle__c, new List<String>{'CompetitorVehicle'});
                }else{
                    tempList.add('CompetitorVehicle');
                }
                tempList = map_vehicleIds.get(lead_Vehicles.Current_Vehicle_1__c);
                if (tempList == null){
                    map_vehicleIds.put(lead_Vehicles.Current_Vehicle_1__c, new List<String>{'CurrentVehicle1'});
                }else{
                    tempList.add('CurrentVehicle1');
                }
                tempList = map_vehicleIds.get(lead_Vehicles.Current_Vehicle_2__c);
                if (tempList == null){
                    map_vehicleIds.put(lead_Vehicles.Current_Vehicle_2__c, new List<String>{'CurrentVehicle2'});
                }else{
                    tempList.add('CurrentVehicle2');
                }
                tempList = map_vehicleIds.get(lead_Vehicles.Trade_In_Vehicle__c);
                if (tempList == null){
                    map_vehicleIds.put(lead_Vehicles.Trade_In_Vehicle__c, new List<String>{'TradeIn'});
                }else{
                    tempList.add('TradeIn');
                }
                tempList = map_vehicleIds.get(lead_Vehicles.Purchased_Vehicle__c);
                if (tempList == null){
                    map_vehicleIds.put(lead_Vehicles.Purchased_Vehicle__c, new List<String>{'PurchasedVehicle'});
                }else{
                    tempList.add('PurchasedVehicle');
                }  
                System.debug('Map of Vehicles and Ids :' +map_vehicleIds);
            }                                

            system.debug('Lead Vehicle Ids :' +lead_VehicleIds);
            //Query all the Vehicle Fields
            if(!lead_VehicleIds.isEmpty()){
                if(!Test.isRunningTest()){
                    vehiclesForLead = [Select RecordTypeId, Brand__c, Class__c, Colour__c, Model_Description__c, NextMileage__c, Trim__c From Vehicle__c Where Id IN :lead_VehicleIds AND MD__c = :usr.Market__c];
                }else{
                    vehiclesForLead = [Select RecordTypeId, Brand__c, Class__c, Colour__c, Model_Description__c, NextMileage__c, Trim__c From Vehicle__c Where Id IN :lead_VehicleIds];
                }
                System.debug('All Vehicle Ids for Leads...' +vehiclesForLead);
                for (Vehicle__c vehicles : vehiclesForLead){
                    System.debug('Entered Loop...');
                    List<String> leadVehicleType = map_vehicleIds.get(vehicles.Id);
                    System.debug('vehicle type...' +leadVehicleType);
                    for(String lvt : leadVehicleType){
                        Map<String, String> tmpMap = new Map<String, String>();
                        String recType_name = UtilRecordType.getRecordTypeNameById('Vehicle__c', vehicles.RecordTypeId);
                        tmpMap.put('Brand', vehicles.Brand__c);
                        tmpMap.put('Class', vehicles.Class__c);
                        tmpMap.put('Colour',vehicles.Colour__c);
                        tmpMap.put('Model',vehicles.Model_Description__c);
                        tmpMap.put('Mileage', String.valueOf(vehicles.NextMileage__c));
                        tmpMap.put('Trim',vehicles.Trim__c);
                        tmpMap.put('RecordType', recType_name);
                        system.debug('Temporary Map...' +tmpMap);
                        mapVehicleTtype_Fields.put(lvt,tmpMap);
                        System.debug('mapVehicleTtype_Fields :' +mapVehicleTtype_Fields);
                    }
                }
                System.debug('Final Map for Vehicles Initialization :' +mapVehicleTtype_Fields);
                serialized_vehicleTypeMap = JSON.serialize(mapVehicleTtype_Fields);
                System.debug(serialized_vehicleTypeMap);
            } 
        }catch(Exception e){
            System.debug('Exception encountered...' +e.getMessage());
        }  
        
        /***************** QUERY THE VEHICLES ASSOCIATED WITH THE LEAD : END *******************/
    }
    
    
    /**
    *@Description : This method fetches the car model records filtered by the statu values recieved, created a mapping
                    for the associated Brand, Class and Model values.
    *@Author : Shrinivas Desai
    *@Date : 3/12/2015
    *@param: Car Model Status values.
    *@return: List<Map<String, Set<String>>>
    *@see: getCarModels.
    */
    @RemoteAction
    global static List<Map<String, Set<String>>> getCarModels(String status_type){
    
     /***************** CAR MODEL WRAPPER CLASS LOGIC : START ****************************/
            List<Car_Model__c> carModels;
            Map<String, Set<String>> brandClassMap = new Map<String, Set<String>>();
            Map<String, Set<String>> classModelMap =  new Map<String, Set<String>>();
             map<string, set<string>> classColorfinMap = new map<string, set<String>>();
             map<string, List<string>> modelColourMap = new map<string,List<string>>();
             map<string, set<string>> modelColourFinMap = new map<string, set<string>>();
            List<VehicleBrandsAndClasses> vBrandsAndClasses;
            String brandClassMapping; 
            String classModelMapping;
            String VehicleBrandClassMapping;
            VehicleBrandsAndClasses vBC;
            List<String> brand_class_model_MapWrapping;            
            List<Map<String, Set<String>>> brand_class_model = new List<Map<String, Set<String>>>();
            Set<String> tempSet = new Set<String>();
            UtilConstant utilConst = new UtilConstant();
            system.debug('usr.Market__c '+ usr.Market__c);
            /*Query Car Model Records filter by status*/
            if(status_type.equalsIgnoreCase('None')){
                if(!Test.isRunningTest()){
                    carModels = [SELECT Brand__c,Name,Series__c,Colour__c,Model__c  FROM Car_Model__c Where MD__c = :usr.Market__c];
                }else{
                    carModels = [SELECT Brand__c,Name,Series__c,Colour__c,Model__c  FROM Car_Model__c];
                }
            }else{
                if(!Test.isRunningTest()){
                    carModels = [SELECT Brand__c,Name,Series__c,Colour__c,Model__c  FROM Car_Model__c Where Status__c =:status_type AND MD__c = :usr.Market__c];
                }else{
                    carModels = [SELECT Brand__c,Name,Series__c,Colour__c,Model__c  FROM Car_Model__c Where Status__c =:status_type];
                }
            }
            
            System.debug('New @Shrinivas Car Models:' +carModels);
            for(Car_Model__c cm : carModels){
                //Create brand class map.
                tempSet = brandClassMap.get(cm.Brand__c);
                if(tempSet == null){
                    brandClassMap.put(cm.Brand__c, new Set<String>{cm.Series__c});
                }else{
                    tempSet.add(cm.Series__c);
                } 
                //Create Class model map.
                tempSet = classModelMap.get(cm.Series__c+cm.Brand__c);
                if(tempSet == null){
                    classModelMap.put(cm.Series__c+cm.Brand__c, new Set<String>{cm.Name});
                }else{
                    tempSet.add(cm.Name);
                }
                 if(cm.Colour__c !=null && cm.Colour__c != ''){
                     List<string> tempLst = cm.Colour__c.split('\\|');
                     set<string> tempSetColors = new set<string>();
                      tempSetColors.addAll(tempLst);
                      if(!classColorfinMap.containsKey(cm.Series__c+cm.Brand__c)){
                          classColorfinMap.put(cm.Series__c+cm.Brand__c,tempSetColors);
                      }
                      if(!modelColourMap.containsKey(cm.Name)){
                          List<string> tempColour = new List<string>();
                          tempColour.add(cm.Colour__c);
                          modelColourMap.put(cm.Name, tempColour);
                      }else{
                          modelColourMap.get(cm.Name).add(cm.Colour__c);
                      }
                  }    
            } 
            if(modelColourMap.size()>0){ 
                for(string str: modelColourMap.keySet()){
                      List<string> modelColourLst = modelColourMap.get(str);
                      set<string> SetColors = new set<string>();
                      for(string str1: modelColourLst){
                          List<string> colours =  str1.split('\\|');
                          SetColors.addAll(colours);
                      }
                      if(!modelColourFinMap.containsKey(str)){
                        modelColourFinMap.put(str, SetColors);
                      }
                        modelColourFinMap.get(str).addAll(SetColors);
                 }
            }     
            system.debug('classColorfinMap '+ classColorfinMap);
            system.debug('modelColourMap '+ modelColourMap);
            system.debug('modelColourFinMap '+ modelColourFinMap);
            System.debug('@Shrinivas : The Brand Class Map3' +brandClassMap);
            brand_class_model.add(brandClassMap);
            brandClassMapping = JSON.serialize(brandClassMap);
            System.debug('@Shrinivas : The Class Model Map3' +classModelMap);
            brand_class_model.add(classModelMap);
            brand_class_model.add(classColorfinMap);
            brand_class_model.add(modelColourFinMap);
            /*Work on the Picklist values here*/
            if (vBrandsAndClasses == null){
                vBrandsAndClasses = new List<vehicleBrandsAndClasses>();
            }
            
            Integer dynamicID = 0;
            Set<String> brandKeySets = brandClassMap.keySet();  
            for (String brands : brandKeySets){
                System.debug('@Entered for loop...' +brandClassMap.keySet());
                vBC = new VehicleBrandsAndClasses();
                vBC.name = new Map<String, String>();
                vBC.name.put('Id',String.valueof(++dynamicID));
                vBC.name.put('name', brands);
                System.debug('vBC Maps :' +vBC);
                if (brandClassMap.get(brands) != null){
                    Set<String> b_Classes = brandClassMap.get(brands);
                    System.debug('@Shrinivas b_Classes :' +b_Classes);
                    vBC.brandClass = new List<Map<String,String>>();
                    for (String cls : b_Classes){
                        BrandClasses b_Cls = new BrandClasses();                    
                        b_Cls.name = new Map<String, String>();
                        b_Cls.name.put('Id', String.valueof(++dynamicID));
                        b_Cls.name.put('name', cls);
                        vBC.brandClass.add(b_Cls.name);
                        System.debug('@Brand Classes :' +vBC);
                    }
                }
                vBrandsAndClasses.add(vBC);             
            }

            System.debug('@Shrinivas: Final brand class :' +vBrandsAndClasses);
            System.debug('@Shrinivas: Final brand class string :' +VehicleBrandClassMapping);
            classModelMapping = JSON.serialize(classModelMap);
            system.debug('@Shrinivas Final Class Model mapping:' +classModelMapping);
            brand_class_model_MapWrapping = new List<String>{VehicleBrandClassMapping, classModelMapping};
            System.debug('Map Wrappings :' +brand_class_model_MapWrapping);
            
            return brand_class_model;
         /***************** CAR MODEL WRAPPER CLASS LOGIC : END ****************************/ 
    }
    
    /**
    *@Description : This method handles the clear functionality for the Vehicle Picker module.
                    The operation for Clear (i.e delete/removing reference) is decided based on vehicle details.
    *@Author : Shrinivas Desai.
    *@Date : 3/12/2015
    *@param: The associated vehicle details. (i.e Vehicle Type, Lead Record Id)
    *@return: This method does not return any values.
    *@see: clearVehicleFromLead.
    */
    @RemoteAction
    global static void clearVehicleFromLead(String vehicleDetails){    
        UtilConstant utilConst = new UtilConstant();
        Map<String, String> vehicleAttributes = (Map<String, String>)JSON.deserialize(vehicleDetails, Map<String, String>.class);
        System.debug('Vehicle Type...' +vehicleAttributes.get('VehicleType'));

		Lead__c lead = [Select Interested_Vehicle__c,Interested_Competitor_Vehicle__c,Current_Vehicle_1__c,Current_Vehicle_2__c,Trade_In_Vehicle__c,Purchased_Vehicle__c from Lead__c where Id =:vehicleAttributes.get('CurrentRecordId')];
        Vehicle__c vehicleId;
        Id vehicleRec_Id;
        String lead_Vehicle_Type = vehicleAttributes.get('VehicleType');
        if (lead_Vehicle_Type.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
            //lead = [Select Id, Interested_Vehicle__c from Lead__c Where Id =:vehicleAttributes.get('CurrentRecordId')];
            vehicleId = [Select Id,RecordTypeId from Vehicle__c Where Id=:lead.Interested_Vehicle__c];
            //vehicleRec_Id = [SELECT RecordTypeId FROM Vehicle__c WHERE Id =:lead.Interested_Vehicle__c].RecordTypeId;
        }else if (lead_Vehicle_Type.equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
            //lead = [Select Id, Interested_Competitor_Vehicle__c from Lead__c Where Id =:vehicleAttributes.get('CurrentRecordId')];
            vehicleId = [Select Id,RecordTypeId from Vehicle__c Where Id=:lead.Interested_Competitor_Vehicle__c];
            //vehicleRec_Id = [SELECT RecordTypeId FROM Vehicle__c WHERE Id =:lead.Interested_Competitor_Vehicle__c].RecordTypeId;
        }else if (lead_Vehicle_Type.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
            //lead = [Select Id, Current_Vehicle_1__c from Lead__c Where Id =:vehicleAttributes.get('CurrentRecordId')];
            vehicleId = [Select Id,RecordTypeId from Vehicle__c Where Id=:lead.Current_Vehicle_1__c];
            //vehicleRec_Id = [SELECT RecordTypeId FROM Vehicle__c WHERE Id =:lead.Current_Vehicle_1__c].RecordTypeId;
        }else if (lead_Vehicle_Type.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
            //lead = [Select Id, Current_Vehicle_2__c from Lead__c Where Id =:vehicleAttributes.get('CurrentRecordId')];
            vehicleId = [Select Id,RecordTypeId from Vehicle__c Where Id=:lead.Current_Vehicle_2__c];
            //vehicleRec_Id = [SELECT RecordTypeId FROM Vehicle__c WHERE Id =:lead.Current_Vehicle_2__c].RecordTypeId;
        }else if (lead_Vehicle_Type.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
            //lead = [Select Id, Trade_In_Vehicle__c from Lead__c Where Id =:vehicleAttributes.get('CurrentRecordId')];
            vehicleId = [Select Id,RecordTypeId from Vehicle__c Where Id=:lead.Trade_In_Vehicle__c];
            //vehicleRec_Id = [SELECT RecordTypeId FROM Vehicle__c WHERE Id =:lead.Trade_In_Vehicle__c].RecordTypeId;
        }else if (lead_Vehicle_Type.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
            //lead = [Select Id, Purchased_Vehicle__c from Lead__c Where Id =:vehicleAttributes.get('CurrentRecordId')];
            vehicleId = [Select Id,RecordTypeId from Vehicle__c Where Id=:lead.Purchased_Vehicle__c];
            //vehicleRec_Id = [SELECT RecordTypeId FROM Vehicle__c WHERE Id =:lead.Purchased_Vehicle__c].RecordTypeId;
        }
        
        String recType_name = UtilRecordType.getRecordTypeNameById('Vehicle__c', vehicleId.RecordTypeId);
        System.debug('@Clear : Vehicle Rec Name :' +recType_name);
        
        if (recType_name.equalsIgnoreCase(utilConst.VEHICLE_PRODUCT)){
            Delete vehicleId;
        }else {
            if (lead_Vehicle_Type.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                lead.Interested_Vehicle__c = null;
            }
            else if (lead_Vehicle_Type.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                lead.Current_Vehicle_1__c = null;
            }
            else if (lead_Vehicle_Type.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                lead.Current_Vehicle_2__c = null;
            }
            else if (lead_Vehicle_Type.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                lead.Trade_In_Vehicle__c = null;
            }
            else if (lead_Vehicle_Type.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                lead.Purchased_Vehicle__c = null;
            }
          //  update lead;
        }
    }
    
    /**
    *@Description : This method controls the search functionality for lookup in the vehicle picker.
    *@Author : Shrinivas Desai.
    *@Date : 3/12/2015
    *@param: Search criteria (i.e VIN number, vehicle type, Lead record Id)
    *@return: List of Vehicle records.
    *@see: searchVehicles
    */
    @RemoteAction
    global static List<Vehicle__c> searchVehicles(String lookupSearchDetails){
        UtilConstant utilConst = new UtilConstant();
        Map<String, String> searchAttributes = (Map<String, String>)JSON.deserialize(lookupSearchDetails, Map<String, String>.class);
        String vin_number = searchAttributes.get(utilConst.VIN);
        String vehicle_type = searchAttributes.get(utilConst.VEHICLE_TYPE);
        system.debug('@Vehicle VIN Number :' +searchAttributes.get('VIN'));
        system.debug('@Vehicle Type :' +searchAttributes.get('VehicleType'));
        system.debug('@Lead Record Id :' +searchAttributes.get('RecordId'));
        List<Vehicle__c> vehicle;
        List<Vehicle_Relationship__c> leadVehicleRelationships;
        List<Vehicle__c> selfRegisteredVehicles;
        Set<Id> defaultVehicleIds = new Set<Id>();
        Set<Id> allVehicleIds = new Set<Id>();
        Lead__c leadAcc;
        
        if ((vehicle_type.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE) ||vehicle_type.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE))){
            if(!Test.isRunningTest()){
                vehicle = [Select Brand__c, Class__c, Model__c from Vehicle__c Where UsVIN__c =:vin_number AND MD__c = :usr.Market__c];
                system.debug('Vehicle for If' +vehicle);
            }else{
                vehicle = [Select Brand__c, Class__c, Model__c from Vehicle__c Where UsVIN__c =:vin_number];
            }
        }
        else{
            if(!Test.isRunningTest()){
                leadAcc = [Select Contact__c from Lead__c where Id =: searchAttributes.get('RecordId') AND MD__c = :usr.Market__c];
                system.debug('Lead Contact...' +leadAcc);
            }else{
                leadAcc = [Select Contact__c from Lead__c where Id =: searchAttributes.get('RecordId')];
            }
            leadVehicleRelationships = [SELECT Vehicle_ID__c FROM Vehicle_Relationship__c WHERE Contact__c =:leadAcc.Contact__c ORDER BY CreatedDate ASC];
            system.debug('Lead Vehicle Relationships...' +leadVehicleRelationships);
            
            if (!leadVehicleRelationships.isEmpty()){
                defaultVehicleIds.add(leadVehicleRelationships[0].Vehicle_ID__c);
                system.debug('Default Vehicle Ids...' +defaultVehicleIds);           
                for (Vehicle_Relationship__c vr : leadVehicleRelationships){
                    allVehicleIds.add(vr.Vehicle_ID__c);
                }
            }
            //Search for Self Registered:
            Id selfRegisteredRec_TypeId = UtilRecordType.getRecordTypeIdByName('Vehicle__c',utilConst.SELF_REGISTERED);
            system.debug('Self Registered Rec Id :' +selfRegisteredRec_TypeId);
            if(!Test.isRunningTest()){
                selfRegisteredVehicles = [Select Id from Vehicle__c where Related_contact__c =:leadAcc.Contact__c AND RecordTypeId =:selfRegisteredRec_TypeId AND MD__c = :usr.Market__c ORDER BY CreatedDate ASC];
                system.debug('Self Registered Vehicles :' +selfRegisteredVehicles);
            }else{
                selfRegisteredVehicles = [Select Id from Vehicle__c where Related_contact__c =:leadAcc.Contact__c AND RecordTypeId =:selfRegisteredRec_TypeId];
            }
            
            if (!selfRegisteredVehicles.isEmpty()){
                defaultVehicleIds.add(selfRegisteredVehicles[0].Id);
                for (Vehicle__c v : selfRegisteredVehicles){    
                    allVehicleIds.add(v.Id);
                }
                system.debug('Default Vehicle Ids...' +defaultVehicleIds);
            }
            if (vin_number.equalsIgnoreCase('')){
                if(!Test.isRunningTest()){
                    vehicle = [Select Brand__c, Class__c, Model__c from Vehicle__c Where Id IN :defaultVehicleIds AND MD__c = :usr.Market__c];
                    system.debug('Default Vehicle Records...' +vehicle);
                }else{
                    vehicle = [Select Brand__c, Class__c, Model__c from Vehicle__c Where Id IN :defaultVehicleIds];
                }
            }
            else{
                if(!Test.isRunningTest()){
                    vehicle = [Select Brand__c, Class__c, Model__c from Vehicle__c Where Id IN :allVehicleIds AND UsVIN__c =:vin_number AND MD__c = :usr.Market__c];
                }
                else{
                    vehicle = [Select Brand__c, Class__c, Model__c from Vehicle__c Where Id IN :allVehicleIds AND UsVIN__c =:vin_number];
                }
            }                 
            system.debug('Vehicle for else' +vehicle); 
        }
            
        System.debug('@Vehicle :' +vehicle);
        return vehicle;
    }
    
    /**
    *@Description : This method controls the New and Edit functionality of the Vehicle Picker component.
    *@Author : Shrinivas Desai.
    *@Date : 3/12/2015
    *@param: The Vehicle Details
    *@return: This method does not return any value.
    *@see: updateVehicleDetails.
    */
    @RemoteAction
    global static void updateVehicleDetails(String vehicleDetails) {
        UtilConstant utilConst = new UtilConstant(); 
        Vehicle__c leadVehicle = new Vehicle__c();
        List<Car_Model__c> carModel;    
		     
        System.debug('I am in my remote method...' +vehicleDetails);
        Map<String, String> vehicleAttributes = (Map<String, String>)JSON.deserialize(vehicleDetails, Map<String, String>.class);
		carModel = [Select Id from Car_Model__c Where Brand__c =:vehicleAttributes.get('Brand') AND Series__c =:vehicleAttributes.get('Class') AND Name =:vehicleAttributes.get('Model') ORDER BY CreatedDate ASC NULLS LAST];
		Lead__c lead = [Select Id, Interested_Vehicle__c,Interested_Competitor_Vehicle__c, Current_Vehicle_1__c,Current_Vehicle_2__c,Trade_In_Vehicle__c,Purchased_Vehicle__c  from Lead__c Where Id =:vehicleAttributes.get('CurrentRecordId')];
        if(vehicleAttributes.get('Lookup') == 'false'){ 
            System.debug('The Vehicle Attributes...' +vehicleAttributes);
            System.debug('Operation Value' +vehicleAttributes.get('Operation'));
            leadVehicle.Brand__c = vehicleAttributes.get('Brand');
            leadVehicle.Class__c = vehicleAttributes.get('Class');
            leadVehicle.Colour__c = vehicleAttributes.get('Colour');
            leadVehicle.Trim__c = vehicleAttributes.get('Trim');
            leadVehicle.Model_Description__c = vehicleAttributes.get('Model');
            String mileageVal = vehicleAttributes.get('Mileage');
       

            if (!mileageVal.equals('')){
                leadVehicle.NextMileage__c = Integer.valueof(vehicleAttributes.get('Mileage'));
            }
            if(vehicleAttributes.get('Operation').equalsIgnoreCase('New')){
                System.debug('New...');
                Id rec_Id = UtilRecordType.getRecordTypeIdByName('Vehicle__c',utilConst.VEHICLE_PRODUCT);
                leadVehicle.RecordTypeId = rec_Id;
                System.debug('Rec_Id :' +rec_Id);
                leadVehicle.Car_Model__c = carModel[0].Id;
                insert leadVehicle;
                
                //Lead__c lead = [Select Id from Lead__c Where Id =:vehicleAttributes.get('CurrentRecordId')];
                if (vehicleAttributes.get('LeadVehicleType').equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                     lead.Interested_Vehicle__c = leadVehicle.Id;
                }else if (vehicleAttributes.get('LeadVehicleType').equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
                     lead.Interested_Competitor_Vehicle__c = leadVehicle.Id;
                }else if (vehicleAttributes.get('LeadVehicleType').equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                     lead.Current_Vehicle_1__c = leadVehicle.Id;
                }else if (vehicleAttributes.get('LeadVehicleType').equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                     lead.Current_Vehicle_2__c = leadVehicle.Id;
                }else if (vehicleAttributes.get('LeadVehicleType').equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                     lead.Trade_In_Vehicle__c = leadVehicle.Id;
                }else if (vehicleAttributes.get('LeadVehicleType').equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                     lead.Purchased_Vehicle__c = leadVehicle.Id;
                }
                update lead;
            }else if (vehicleAttributes.get('Operation').equalsIgnoreCase('Edit')){
                System.debug('Edit...');
                
                if (vehicleAttributes.get('LeadVehicleType').equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                    leadVehicle.Id =  lead.Interested_Vehicle__c;
                    leadVehicle.Car_Model__c = carModel[0].Id;
                    //update leadVehicle;
                    lead.Interested_Vehicle__c = leadVehicle.Id;
                    //update lead;
                }else if (vehicleAttributes.get('LeadVehicleType').equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
                    System.debug('@shrinivas : vehicle id :' +leadVehicle);
                    System.debug('@shrinivas : lead vehicle id :' +lead.Interested_Competitor_Vehicle__c);
                    leadVehicle.Id =  lead.Interested_Competitor_Vehicle__c;
                    leadVehicle.Car_Model__c = carModel[0].Id;
                    //update leadVehicle;       
                    lead.Interested_Competitor_Vehicle__c = leadVehicle.Id;
                    //update lead;
                }else if (vehicleAttributes.get('LeadVehicleType').equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                    leadVehicle.Id =  lead.Current_Vehicle_1__c;
                    leadVehicle.Car_Model__c = carModel[0].Id;                           
                    //update leadVehicle;
                    lead.Current_Vehicle_1__c = leadVehicle.Id;
                    //update lead;
                }else if (vehicleAttributes.get('LeadVehicleType').equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                    leadVehicle.Id =  lead.Current_Vehicle_2__c;
                    leadVehicle.Car_Model__c = carModel[0].Id;      
                    //update leadVehicle;
                    lead.Current_Vehicle_2__c = leadVehicle.Id;                     
                    //update lead;
                }else if (vehicleAttributes.get('LeadVehicleType').equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                    leadVehicle.Id =  lead.Trade_In_Vehicle__c;
                    leadVehicle.Car_Model__c = carModel[0].Id;       
                    //update leadVehicle;
                    lead.Trade_In_Vehicle__c = leadVehicle.Id;
                    //update lead;
                }else if (vehicleAttributes.get('LeadVehicleType').equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                    leadVehicle.Id =  lead.Purchased_Vehicle__c;
                    leadVehicle.Car_Model__c = carModel[0].Id;       
                    //update leadVehicle;
                    lead.Purchased_Vehicle__c = leadVehicle.Id;
                    //update lead;
                }
                update lead;
				update leadVehicle;
            }            
        }
        if(vehicleAttributes.get('Lookup') == 'true'){
           System.debug('Vehicle Type is Interested Vehicle...' +vehicleAttributes);
           //Lead__c lead = [Select Id from Lead__c Where Id =:vehicleAttributes.get('CurrentRecordId')];
           if (vehicleAttributes.get('VehicleType').equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
               system.debug('Vehicle Type :' +vehicleAttributes.get('VehicleType'));
               system.debug('Vehicle Id:' +vehicleAttributes.get('Id'));
               lead.Interested_Vehicle__c = vehicleAttributes.get('Id');
           }else if (vehicleAttributes.get('VehicleType').equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
               lead.Current_Vehicle_1__c = vehicleAttributes.get('Id');
           }else if (vehicleAttributes.get('VehicleType').equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
               lead.Current_Vehicle_2__c = vehicleAttributes.get('Id');
           }else if (vehicleAttributes.get('VehicleType').equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
               lead.Trade_In_Vehicle__c = vehicleAttributes.get('Id');
           }else if (vehicleAttributes.get('VehicleType').equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
               lead.Purchased_Vehicle__c = vehicleAttributes.get('Id');
           }
           update lead;
        }  
    }
    
    global class VehicleBrandsAndClasses{
        public Map<String, String> name {get; set;}
        public List<Map<String,String>> brandClass {get; set;}
    }
    
    public class BrandClasses{
        public Map<String, String> name {get;set;}
    }
    
    
}