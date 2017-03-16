global without sharing class VehiclePickerForCaseController {
    public String currentRecordId {get;set;}
    public Case case_Vehicles {get; set;}
    public List<Vehicle_Relationship__c> caseOwnerVehiclesRelationships;
    public List<Vehicle__c> caseOwnerVehicles;  
    public String serialized_vehicleTypeMap {set;get;}
    public String lookup_Vehicles {set;get;}
    public String leadType {get;set;}
    
    Map<String, Set<String>> brandClassMap {get;set;}
    Map<String, Set<String>> classModelMap {get;set;}
    Public boolean disableButtons{get;set;}
    public List<Vehicle_Relationship__c> caseVehicleRelationships;
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
    *@Description : This method fetches all the vehicles that are associated with the cse to pre-populate the values.
    *@Author : Shrinivas Desai.
    *@Date : 3/12/2015
    *@param: Apex standard controller.
    *@return: This is a constructor method.
    *@see: VehiclePickerController
    */
    public VehiclePickerForCaseController(ApexPages.StandardController controller) {
        profile p = [select Name from profile where id =:userinfo.getprofileId()];
        disableButtons = true;
        if(p.Name.contains('Dealer')){
            disableButtons = false;
        }        
        currentRecordId  = controller.getId();
        System.debug('cse Vehicles Types...' +case_Vehicles);
        Set<Id> case_VehicleIds;
        serialized_vehicleTypeMap = JSON.serialize(''); 
        lookup_Vehicles = JSON.serialize('');        
        brandClassMap = new Map<String, Set<String>>();
        classModelMap = new Map<String, Set<String>>();
        List<String> tempList = new List<String>();
        Map<String, Map<String,String>> mapVehicleTtype_Fields = new Map<String, Map<String, String>>();        
        Map<Id, List<String>> map_vehicleIds = new Map<Id, List<String>>();
        List<Id> vehicleIds = new List<Id>();
        List<Vehicle__c> vehiclesForCase;
        
        try{
        
            /***************** QUERY THE VEHICLES ASSOCIATED WITH THE Case : START *******************/
            if(!Test.isRunningTest()){
				case_Vehicles = [Select Interested_Vehicle__c, Interested_Competitor_Vehicle__c, Current_Vehicle_1__c,Current_Vehicle_2__c,Trade_In_Vehicle__c, Purchased_Vehicle__c From Case Where Id =: currentRecordId AND MD__c = :usr.Market__c];
			}else{
				case_Vehicles = [Select Interested_Vehicle__c, Interested_Competitor_Vehicle__c, Current_Vehicle_1__c,Current_Vehicle_2__c,Trade_In_Vehicle__c, Purchased_Vehicle__c From Case Where Id =: currentRecordId];
			}           
            system.debug('@ Intial Case vehicle record values :' +case_Vehicles);                                                   
            case_VehicleIds = new Set<Id>{  case_Vehicles.Interested_Vehicle__c, case_Vehicles.Interested_Competitor_Vehicle__c,
                                            case_Vehicles.Current_Vehicle_1__c, case_Vehicles.Current_Vehicle_2__c,case_Vehicles.Trade_In_Vehicle__c,
                                            case_Vehicles.Purchased_Vehicle__c
                                         };
			if(!Test.isRunningTest()){							 
				caseOwnerVehiclesRelationships = [select Vehicle_Id__r.Id from Vehicle_Relationship__c where Contact__c  IN (Select Car_Owner__c from Case where Id =:currentRecordId AND MD__c = :usr.Market__c)];  
			}else{
				caseOwnerVehiclesRelationships = [select Vehicle_Id__r.Id from Vehicle_Relationship__c where Contact__c  IN (Select Car_Owner__c from Case where Id =:currentRecordId)];
			}			
            System.debug('Case Vehicle Relationships...' +caseOwnerVehiclesRelationships.size());
            for (Integer i=0; i < caseOwnerVehiclesRelationships.size(); i++){
                System.debug('In the For :' +caseOwnerVehiclesRelationships[i]);
                vehicleIds.add(caseOwnerVehiclesRelationships[i].Vehicle_Id__c);
            }
            if(!vehicleIds.isEmpty()){
                System.debug('Vehicle Ids' +vehicleIds);
                caseOwnerVehicles = [Select Brand__c, Class__c, Model_Description__c, UsVIN__c From Vehicle__c Where Id IN :vehicleIds AND MD__c = :usr.Market__c];
                System.debug('Case Owner vehicles...:' +caseOwnerVehicles);
                System.debug('Each Case Vehicle type...' +case_Vehicles.Interested_Vehicle__c); 
            }
            
            if (case_Vehicles != null) {
                tempList = map_vehicleIds.get(case_Vehicles.Interested_Vehicle__c);
                if (tempList == null){
                    map_vehicleIds.put(case_Vehicles.Interested_Vehicle__c, new List<String>{'InterestedVehicle'});
                }else{
                    tempList.add('InterestedVehicle');
                }
                tempList = map_vehicleIds.get(case_Vehicles.Interested_Competitor_Vehicle__c);
                if (tempList == null){
                     map_vehicleIds.put(case_Vehicles.Interested_Competitor_Vehicle__c, new List<String>{'CompetitorVehicle'});
                }else{
                    tempList.add('CompetitorVehicle');
                }
                tempList = map_vehicleIds.get(case_Vehicles.Current_Vehicle_1__c);
                if (tempList == null){
                    map_vehicleIds.put(case_Vehicles.Current_Vehicle_1__c, new List<String>{'CurrentVehicle1'});
                }else{
                    tempList.add('CurrentVehicle1');
                }
                tempList = map_vehicleIds.get(case_Vehicles.Current_Vehicle_2__c);
                if (tempList == null){
                    map_vehicleIds.put(case_Vehicles.Current_Vehicle_2__c, new List<String>{'CurrentVehicle2'});
                }else{
                    tempList.add('CurrentVehicle2');
                }
                tempList = map_vehicleIds.get(case_Vehicles.Trade_In_Vehicle__c);
                if (tempList == null){
                    map_vehicleIds.put(case_Vehicles.Trade_In_Vehicle__c, new List<String>{'TradeIn'});
                }else{
                    tempList.add('TradeIn');
                }
                tempList = map_vehicleIds.get(case_Vehicles.Purchased_Vehicle__c);
                if (tempList == null){
                    map_vehicleIds.put(case_Vehicles.Purchased_Vehicle__c, new List<String>{'PurchasedVehicle'});
                }else{
                    tempList.add('PurchasedVehicle');
                }  
                System.debug('Map of Vehicles and Ids :' +map_vehicleIds);
            }                                

            system.debug('Case Vehicle Ids :' +case_VehicleIds);
            //Query all the Vehicle Fields
            if(!case_VehicleIds.isEmpty()){
				if(!Test.isRunningTest()){
					vehiclesForCase = [Select RecordTypeId, Brand__c, Class__c, Colour__c, Model_Description__c, NextMileage__c, Trim__c From Vehicle__c Where Id IN :case_VehicleIds AND MD__c = :usr.Market__c];
                System.debug('All Vehicle Ids for Leads...' +vehiclesForCase);
				}else{
					vehiclesForCase = [Select RecordTypeId, Brand__c, Class__c, Colour__c, Model_Description__c, NextMileage__c, Trim__c From Vehicle__c Where Id IN :case_VehicleIds];
				}
                for (Vehicle__c vehicles : vehiclesForCase){
                    System.debug('Entered Loop...');
                    List<String> caseVehicleType = map_vehicleIds.get(vehicles.Id);
                    System.debug('vehicle type...' +caseVehicleType);
                    for(String lvt : caseVehicleType){
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
        
        /***************** QUERY THE VEHICLES ASSOCIATED WITH THE Case : END *******************/
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
            List<VehicleBrandsAndClasses> vBrandsAndClasses;
            String brandClassMapping; 
            String classModelMapping;
            String VehicleBrandClassMapping;
            VehicleBrandsAndClasses vBC;
            List<String> brand_class_model_MapWrapping;            
            List<Map<String, Set<String>>> brand_class_model = new List<Map<String, Set<String>>>();
            Set<String> tempSet = new Set<String>();
            UtilConstant utilConst = new UtilConstant();
            
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
            }           

            System.debug('@Shrinivas : The Brand Class Map3' +brandClassMap);
            brand_class_model.add(brandClassMap);
            brandClassMapping = JSON.serialize(brandClassMap);
            System.debug('@Shrinivas : The Class Model Map3' +classModelMap);
            brand_class_model.add(classModelMap);
            
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
    *@param: The associated vehicle details. (i.e Vehicle Type, Case Record Id)
    *@return: This method does not return any values.
    *@see: clearVehicleFromCase.
    */
    @RemoteAction
    global static void clearVehicleFromCase(String vehicleDetails){    
        UtilConstant utilConst = new UtilConstant();
        Map<String, String> vehicleAttributes = (Map<String, String>)JSON.deserialize(vehicleDetails, Map<String, String>.class);
        System.debug('Vehicle Type...' +vehicleAttributes.get('VehicleType'));
		Case cse = [Select Id, Interested_Vehicle__c, Current_Vehicle_1__c,Current_Vehicle_2__c,Trade_In_Vehicle__c,Purchased_Vehicle__c,Interested_Competitor_Vehicle__c  from Case Where Id =:vehicleAttributes.get('CurrentRecordId')];

        Vehicle__c vehicleId;
        Id vehicleRec_Id;
        String case_Vehicle_Type = vehicleAttributes.get('VehicleType');
        if (case_Vehicle_Type.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
            //cse = [Select Id, Interested_Vehicle__c from Case Where Id =:vehicleAttributes.get('CurrentRecordId')];
            vehicleId = [Select Id,RecordTypeId from Vehicle__c Where Id=:cse.Interested_Vehicle__c];
            //vehicleRec_Id = [SELECT RecordTypeId FROM Vehicle__c WHERE Id =:cse.Interested_Vehicle__c].RecordTypeId;
        }else if (case_Vehicle_Type.equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
            //cse = [Select Id, Interested_Competitor_Vehicle__c from Case Where Id =:vehicleAttributes.get('CurrentRecordId')];
            vehicleId = [Select Id,RecordTypeId from Vehicle__c Where Id=:cse.Interested_Competitor_Vehicle__c];
            //vehicleRec_Id = [SELECT RecordTypeId FROM Vehicle__c WHERE Id =:cse.Interested_Competitor_Vehicle__c].RecordTypeId;
        }else if (case_Vehicle_Type.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
            //cse = [Select Id, Current_Vehicle_1__c from Case Where Id =:vehicleAttributes.get('CurrentRecordId')];
            vehicleId = [Select Id,RecordTypeId from Vehicle__c Where Id=:cse.Current_Vehicle_1__c];
            //vehicleRec_Id = [SELECT RecordTypeId FROM Vehicle__c WHERE Id =:cse.Current_Vehicle_1__c].RecordTypeId;
        }else if (case_Vehicle_Type.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
            //cse = [Select Id, Current_Vehicle_2__c from Case Where Id =:vehicleAttributes.get('CurrentRecordId')];
            vehicleId = [Select Id,RecordTypeId from Vehicle__c Where Id=:cse.Current_Vehicle_2__c];
            //vehicleRec_Id = [SELECT RecordTypeId FROM Vehicle__c WHERE Id =:cse.Current_Vehicle_2__c].RecordTypeId;
        }else if (case_Vehicle_Type.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
            //cse = [Select Id, Trade_In_Vehicle__c from Case Where Id =:vehicleAttributes.get('CurrentRecordId')];
            vehicleId = [Select Id,RecordTypeId from Vehicle__c Where Id=:cse.Trade_In_Vehicle__c];
            //vehicleRec_Id = [SELECT RecordTypeId FROM Vehicle__c WHERE Id =:cse.Trade_In_Vehicle__c].RecordTypeId;
        }else if (case_Vehicle_Type.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
            //cse = [Select Id, Purchased_Vehicle__c from Case Where Id =:vehicleAttributes.get('CurrentRecordId')];
            vehicleId = [Select Id,RecordTypeId from Vehicle__c Where Id=:cse.Purchased_Vehicle__c];
            //vehicleRec_Id = [SELECT RecordTypeId FROM Vehicle__c WHERE Id =:cse.Purchased_Vehicle__c].RecordTypeId;
        }
        
        String recType_name = UtilRecordType.getRecordTypeNameById('Vehicle__c', vehicleId.RecordTypeId);
        System.debug('@Clear : Vehicle Rec Name :' +recType_name);
        
        if (recType_name.equalsIgnoreCase(utilConst.VEHICLE_PRODUCT)){
            Delete vehicleId;
        }else {
            if (case_Vehicle_Type.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                cse.Interested_Vehicle__c = null;
            }
            else if (case_Vehicle_Type.equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                cse.Current_Vehicle_1__c = null;
            }
            else if (case_Vehicle_Type.equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                cse.Current_Vehicle_2__c = null;
            }
            else if (case_Vehicle_Type.equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                cse.Trade_In_Vehicle__c = null;
            }
            else if (case_Vehicle_Type.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                cse.Purchased_Vehicle__c = null;
            }
            update cse;
        }
    }
    
    /**
    *@Description : This method controls the search functionality for lookup in the vehicle picker.
    *@Author : Shrinivas Desai.
    *@Date : 3/12/2015
    *@param: Search criteria (i.e VIN number, vehicle type, Case record Id)
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
        system.debug('@Case Record Id :' +searchAttributes.get('RecordId'));
        List<Vehicle__c> vehicle;
        List<Vehicle_Relationship__c> caseVehicleRelationships;
        List<Vehicle__c> selfRegisteredVehicles;
        Set<Id> defaultVehicleIds = new Set<Id>();
        Set<Id> allVehicleIds = new Set<Id>();
        Case caseAcc;
        if ((vehicle_type.equalsIgnoreCase(utilConst.INTERESTED_VEHICLE) ||vehicle_type.equalsIgnoreCase(utilConst.PURCHASED_VEHICLE))){
            if(!Test.isRunningTest()){
                vehicle = [Select Brand__c, Class__c, Model__c from Vehicle__c Where UsVIN__c =:vin_number AND MD__c = :usr.Market__c];
                system.debug('Vehicle for If' +vehicle);
            }else{
                vehicle = [Select Brand__c, Class__c, Model__c from Vehicle__c Where UsVIN__c =:vin_number];
            }
            system.debug('Vehicle for If' +vehicle);
        }
        else{
			if(!Test.isRunningTest()){
				caseAcc = [Select AccountId from Case where Id =: searchAttributes.get('RecordId') AND MD__c = :usr.Market__c];
			}else{
				caseAcc = [Select AccountId from Case where Id =: searchAttributes.get('RecordId')];
			}
            system.debug('Case Contact...' +caseAcc);
            caseVehicleRelationships = [SELECT Vehicle_ID__c FROM Vehicle_Relationship__c WHERE Contact__c =:caseAcc.AccountId ORDER BY CreatedDate ASC];
            system.debug('Case Vehicle Relationships...' +caseVehicleRelationships);
            
            if (!caseVehicleRelationships.isEmpty()){
                defaultVehicleIds.add(caseVehicleRelationships[0].Vehicle_ID__c);
                system.debug('Default Vehicle Ids...' +defaultVehicleIds);           
                for (Vehicle_Relationship__c vr : caseVehicleRelationships){
                    allVehicleIds.add(vr.Vehicle_ID__c);
                }
            }
            //Search for Self Registered:
            Id selfRegisteredRec_TypeId = UtilRecordType.getRecordTypeIdByName('Vehicle__c',utilConst.SELF_REGISTERED);
            system.debug('Self Registered Rec Id :' +selfRegisteredRec_TypeId);
			 if(!Test.isRunningTest()){
				selfRegisteredVehicles = [Select Id from Vehicle__c where Related_contact__c =:caseAcc.AccountId AND RecordTypeId =:selfRegisteredRec_TypeId AND MD__c = :usr.Market__c ORDER BY CreatedDate ASC];
				system.debug('Self Registered Vehicles :' +selfRegisteredVehicles);
			 }else{
				 selfRegisteredVehicles = [Select Id from Vehicle__c where Related_contact__c =:caseAcc.AccountId AND RecordTypeId =:selfRegisteredRec_TypeId ORDER BY CreatedDate ASC];
				system.debug('Self Registered Vehicles :' +selfRegisteredVehicles);
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
					system.debug('Default Vehicle Records...' +vehicle);
				}
            }
            else{
				if(!Test.isRunningTest()){
					vehicle = [Select Brand__c, Class__c, Model__c from Vehicle__c Where Id IN :allVehicleIds AND UsVIN__c =:vin_number AND MD__c = :usr.Market__c];
				}else{
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
        Vehicle__c caseVehicle = new Vehicle__c();
        List<Car_Model__c> carModel;    
        System.debug('I am in my remote method...' +vehicleDetails);
        Map<String, String> vehicleAttributes = (Map<String, String>)JSON.deserialize(vehicleDetails, Map<String, String>.class);
		carModel = [Select Id from Car_Model__c Where Brand__c =:vehicleAttributes.get('Brand') AND Series__c =:vehicleAttributes.get('Class') AND Name =:vehicleAttributes.get('Model') ORDER BY CreatedDate ASC NULLS LAST];
		Case cse = [Select Id, Interested_Vehicle__c,Interested_Competitor_Vehicle__c, Current_Vehicle_1__c,Current_Vehicle_2__c,Trade_In_Vehicle__c,Purchased_Vehicle__c  from Case Where Id =:vehicleAttributes.get('CurrentRecordId')];
        if(vehicleAttributes.get('Lookup') == 'false'){ 
            System.debug('The Vehicle Attributes...' +vehicleAttributes);
            System.debug('Operation Value' +vehicleAttributes.get('Operation'));
            caseVehicle.Brand__c = vehicleAttributes.get('Brand');
            caseVehicle.Class__c = vehicleAttributes.get('Class');
            caseVehicle.Colour__c = vehicleAttributes.get('Colour');
            caseVehicle.Trim__c = vehicleAttributes.get('Trim');
            caseVehicle.Model_Description__c = vehicleAttributes.get('Model');
            String mileageVal = vehicleAttributes.get('Mileage');
        
            if (!mileageVal.equals('')){
                caseVehicle.NextMileage__c = Integer.valueof(vehicleAttributes.get('Mileage'));
            }
            if(vehicleAttributes.get('Operation').equalsIgnoreCase('New')){
                System.debug('New...');
                Id rec_Id = UtilRecordType.getRecordTypeIdByName('Vehicle__c',utilConst.VEHICLE_PRODUCT);
                caseVehicle.RecordTypeId = rec_Id;
                System.debug('Rec_Id :' +rec_Id);
                caseVehicle.Car_Model__c = carModel[0].Id;
                insert caseVehicle;
                
                
                
                if (vehicleAttributes.get('caseVehicleType').equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                     cse.Interested_Vehicle__c = caseVehicle.Id;
                }else if (vehicleAttributes.get('caseVehicleType').equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
                     cse.Interested_Competitor_Vehicle__c = caseVehicle.Id;
                }else if (vehicleAttributes.get('caseVehicleType').equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                     cse.Current_Vehicle_1__c = caseVehicle.Id;
                }else if (vehicleAttributes.get('caseVehicleType').equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                     cse.Current_Vehicle_2__c = caseVehicle.Id;
                }else if (vehicleAttributes.get('caseVehicleType').equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                     cse.Trade_In_Vehicle__c = caseVehicle.Id;
                }else if (vehicleAttributes.get('caseVehicleType').equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                     cse.Purchased_Vehicle__c = caseVehicle.Id;
                }
                update cse;
            }else if (vehicleAttributes.get('Operation').equalsIgnoreCase('Edit')){
                System.debug('Edit...');
                if (vehicleAttributes.get('caseVehicleType').equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
                    caseVehicle.Id =  cse.Interested_Vehicle__c;
                    caseVehicle.Car_Model__c = carModel[0].Id;
                    //update caseVehicle;
                    cse.Interested_Vehicle__c = caseVehicle.Id;
                    //update cse;
                }else if (vehicleAttributes.get('caseVehicleType').equalsIgnoreCase(utilConst.COMPETITOR_VEHICLE)){
                    System.debug('@shrinivas : vehicle id :' +caseVehicle);
                    System.debug('@shrinivas : cse vehicle id :' +cse.Interested_Competitor_Vehicle__c);
                    caseVehicle.Id =  cse.Interested_Competitor_Vehicle__c;
                    caseVehicle.Car_Model__c = carModel[0].Id;
                    //update caseVehicle;       
                    cse.Interested_Competitor_Vehicle__c = caseVehicle.Id;
                    //update cse;
                }else if (vehicleAttributes.get('caseVehicleType').equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
                    caseVehicle.Id =  cse.Current_Vehicle_1__c;
                    caseVehicle.Car_Model__c = carModel[0].Id;                           
                    //update caseVehicle;
                    cse.Current_Vehicle_1__c = caseVehicle.Id;
                    //update cse;
                }else if (vehicleAttributes.get('caseVehicleType').equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
                    caseVehicle.Id =  cse.Current_Vehicle_2__c;
                    caseVehicle.Car_Model__c = carModel[0].Id;      
                    //update caseVehicle;
                    cse.Current_Vehicle_2__c = caseVehicle.Id;                     
                    //update cse;
                }else if (vehicleAttributes.get('caseVehicleType').equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
                    caseVehicle.Id =  cse.Trade_In_Vehicle__c;
                    caseVehicle.Car_Model__c = carModel[0].Id;       
                    //update caseVehicle;
                    cse.Trade_In_Vehicle__c = caseVehicle.Id;
                    //update cse;
                }else if (vehicleAttributes.get('caseVehicleType').equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
                    caseVehicle.Id =  cse.Purchased_Vehicle__c;
                    caseVehicle.Car_Model__c = carModel[0].Id;       
                    //update caseVehicle;
                    cse.Purchased_Vehicle__c = caseVehicle.Id;
                    //update cse;
                }
				update caseVehicle;
                update cse;
            }            
        }
        if(vehicleAttributes.get('Lookup') == 'true'){
           System.debug('Vehicle Type is Interested Vehicle...' +vehicleAttributes);
           //Case cse = [Select Id from Case Where Id =:vehicleAttributes.get('CurrentRecordId')];
           if (vehicleAttributes.get('VehicleType').equalsIgnoreCase(utilConst.INTERESTED_VEHICLE)){
               system.debug('Vehicle Type :' +vehicleAttributes.get('VehicleType'));
               system.debug('Vehicle Id:' +vehicleAttributes.get('Id'));
               cse.Interested_Vehicle__c = vehicleAttributes.get('Id');
           }else if (vehicleAttributes.get('VehicleType').equalsIgnoreCase(utilConst.CURRENT1_VEHICLE)){
               cse.Current_Vehicle_1__c = vehicleAttributes.get('Id');
           }else if (vehicleAttributes.get('VehicleType').equalsIgnoreCase(utilConst.CURRENT2_VEHICLE)){
               cse.Current_Vehicle_2__c = vehicleAttributes.get('Id');
           }else if (vehicleAttributes.get('VehicleType').equalsIgnoreCase(utilConst.TRADE_IN_VEHICLE)){
               cse.Trade_In_Vehicle__c = vehicleAttributes.get('Id');
           }else if (vehicleAttributes.get('VehicleType').equalsIgnoreCase(utilConst.PURCHASED_VEHICLE)){
               cse.Purchased_Vehicle__c = vehicleAttributes.get('Id');
           }
           update cse;
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