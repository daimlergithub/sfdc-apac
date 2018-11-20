/**
** Class        : SalesLeadEditController 
** Description  : Sales edit page controller
** Created By   : Prem Kumar
** Date         : 30/03/2018
** Updated BY   : Shashi Goswami - 06/04/2018
**/

public without sharing class SalesLeadEditController {
    
    //This map is used for all vehicles
    public map<String, List<Lead_Details__c>> allVehiclesMap {get;set;}
    //This list is used for all vehicles
    public List<Lead_Details__c> allVehiclesList {get;set;}
    //This is used for interested vehicle
    public list<Lead_Details__c> intVehicleList {get;set;} 
    //This is used for competitor vehicle
    public list<Lead_Details__c> compVehicleList {get;set;} 
    // Current Vehicle List
    public List<Vehicle_Relationship__c> currentVehicleList {get;set;}
    //To fetch opportunity details
    public Opportunity opp {get;set;}
    public Integer intPreferredCount{get;set;}
    public Integer compPreferredCount{get;set;}
    list<Lead_Details__c> tradeVehc = new list<Lead_Details__c>();
    
    //Added for Inline VF Page
    public Boolean EditIntVeh{get;set;}
    public list<Lead_Details__c> allIntVehicles{get;set;}
    public list<Lead_Details__c> allCompVehicles{get;set;}
    public list<Lead_Details__c> allTradeVehicles{get;set;}    
    
   	public List<SelectOption> lstAvailableOptions {get;set;}
    public List<SelectOption> lstSelectedOptions {get;set;}
	public List<SelectOption> lstPrepopulateOptions {get;set;}
	private List<String> carSearchFormat;
   	private map<Id,Car_Model__c> mapCarModel;
    
    public String userMarket {get;set;}
    
    // Constructor
    public SalesLeadEditController(ApexPages.StandardController controller) {
        allVehiclesMap = new Map<String,List<Lead_Details__c>>();
        allVehiclesList = new List<Lead_Details__c>();        
        intVehicleList = new List<Lead_Details__c>();
        compVehicleList = new List<Lead_Details__c>();
        intPreferredCount = 0;
        compPreferredCount = 0;
		//Sada added New Fields as per usMBANZ-157,158
		//Madhu added New Fields as per usMBANZ-384
        Id oppId = ApexPages.currentPage().getParameters().get('id');
        String salesQuery = 'SELECT id,Name ,RecordType.Name,StageName,Case__c,CreatedDate,Campaign.Name,Visited_Showroom_Date_Time__c,Market__c, Type_of_Sale__c, Purchased_Vehicle__c, Lead_Additional_Service__c,Pickup_Date_Time__c,Order_Placed_Date__c,Quotation_Date__c,Quotation_Amount__c,Order_No__c, Average_Driving__c, Order_Print_Date__c,Order_Confirmation_Date__c,Registration_No__c,Network_Registration_Date__c,Bought_Vehicle_Brand__c,Next_Contact_Customer_Date__c,Bought_Vehicle_Class__c,Bought_Vehicle_Model__c,Invoice_Number__c,Invoice_Date__c,Purchase_Time__c,Received_Date_Time__c, Lost_to_Co_Dealer_Name__c, Invoice_Amount__c,Qualified_Date_Time__c,UCID__c,UCID_account__c,Desired_Contact_Date__c,Price_Range__c,Test_Drive_Date__c,Preferred_Contact_Time__c,Assigned_Service_Advisor__c, Accepted_Date_Time__c,Purchase_Date__c,Quotation_Print_Date__c,Quotation_No__c,Assigned_Date_Time__c,Preferred_Contact_Method__c, Lost_to_OEM_Name__c,Lead_Latest_Phase__c,Contact__c,Sales_Consultant__c,Dealer_Comment__c,Customer_Preferred_Representative__c, Referal_Referee_Note__c, Description,Customer_Specified_Dealer__c,Lead_Type__c,Assigned_Dealer__c,CloseDate,Lead_Sub_Type__c,Lead_DataSource__c,Handover_Date__c, Referal_Referee_Name__c,CAC_Lost_Reason__c,Lead_DataSubSource__c,Lost_Reason_text__c,Lead_Desired_Service__c,Last_Successful_Call__c, Lost_To_Competitor_Name__c,Current_Vehicle_1_Text__c,Current_Vehicle_2_Text__c,Lead_Source__c,Lead_Priority__c,Lost_To__c,Lost_Situation__c,Lead_No__c,Allow_Data_Sharing__c,OwnerId,Is_Active__c,LeadSource,AccountId,Payment_Mode__c,Lost_Date__c,CreatedById,LastModifiedById,Service_Requested_date__c,Quotation_No_History__c,WIP_Number__c,WIP_Created_Date__c,Job_Card_Number__c,Job_Card_Date__c,Check_In_Date__c,Check_Out_Date__c,Needs_Check_Date__c,Product_Proposal_Date__c,Finance_Proposal_Date__c,Insurance_Proposal_Date__c,Service_Program_Proposal_Date__c,Simple_Estimation_Date__c,Pick_up_Time__c,company_account__c,Preferred_Negotiation_Place__c,Preferred_Negotiation_DateTime__c,Lost_Dealer_Date__c ,Lost_Dealer_Date_Time__c ,Policy_Inception_Date__c ,First_Contact_Customer_Date_Time__c ,VIN__c ,Drop_off_Time__c ,Existing_Contract__c ,Deposit_Payment_Date__c ,Deposit__c ,Dealer_Aftersales_Manager_Email__c ,Dealer_Owner_Email__c ,Assigned_to_Dealer_Directly__c ,Finance_Product_Name__c,Wholesale_Comment__c,CommissionNumber__c ,Lost_CAC_Date__c,Test_drive_details__c ,Price_Range_From__c ,Lost_CAC_Date_Time__c ,Contact_Failed_For_3_Days_Date_Time__c ,Price_Range_To__c ,Portal_Request_ID__c ,Contact_Timing__c ,Trade_in_Date__c,Finance_Quotation_No_History__c,Finance_Quotation_Date__c,Selected_Car_Model__c,Finance_Quotation_No__c,CA_Updated_Date__c,Quotation_Model__c,Service_date__c,Preferred_Delivery_Date__c,Form_Title__c,Entity__c,Lost_Sub_Type__c,ZipCode__c,Lead_eMail__c,Lead_Mobile__c,Related_leads__c FROM opportunity WHERE Id = :oppId';
        opp= Database.query(salesQuery);
        if (opp != null){
            userMarket = opp.Market__c;
        }
        //Rajesh - Get list of VRs for account and check for uniqueness of vehicle. Only 1 VR per vehicle needs to show in this page
        List<Vehicle_Relationship__c> contactVRs = [Select Vehicle_ID__c,Vehicle_Model__c,Vehicle_Brand__c,Vehicle_Class__c,Mileage_start__c,Mileage_End__c from Vehicle_Relationship__c where Contact__c= :opp.AccountID];
        String vehicleSet = '';
        currentVehicleList = new List<Vehicle_Relationship__c>();
        for (Vehicle_Relationship__c vr : contactVRs){
            String vehicleId = String.valueOf(vr.Vehicle_ID__c);
            if (vehicleId != null && vehicleId != ''){
                if (!vehicleSet.contains(vehicleId)){
                    vehicleSet = vehicleSet + ',' + vehicleId;
                    currentVehicleList.add(vr);
                }
            }
        }

        //Added for Inline VF-----
        allIntVehicles =[Select Id,Brand__c,Car_Model__c,Car_Model_Competitor__c,Class__c,Color__c,Market__c,Mileage__c,Preferred__c,Related_Lead__c,Trade_In_Vehicle__c,Trim__c,Type__c,Vehicle_Model_Type__c,Year_of_Manufacture__c,brand_picklist__c,class_picklist__c from Lead_Details__c where Related_Lead__c=:opp.Id and Type__c='Interested'];
        allCompVehicles =[Select Id,Brand__c,Car_Model__c,Car_Model_Competitor__c,Class__c,Color__c,Market__c,Mileage__c,Preferred__c,Related_Lead__c,Trade_In_Vehicle__c,Trim__c,Type__c,Vehicle_Model_Type__c,Year_of_Manufacture__c,brand_picklist__c,class_picklist__c from Lead_Details__c where Related_Lead__c=:opp.Id and Type__c='Competitor'];
        allTradeVehicles =[Select Id,Brand__c,Car_Model__c,Car_Model_Competitor__c,Class__c,Color__c,Market__c,Mileage__c,Preferred__c,Related_Lead__c,Trade_In_Vehicle__c,Trim__c,Type__c,Vehicle_Model_Type__c,Year_of_Manufacture__c,brand_picklist__c,class_picklist__c from Lead_Details__c where Related_Lead__c=:opp.Id and Type__c='Trade In'];
        //----
        
        for(Lead_Details__c ld : [Select Id, recordTypeId, Car_Model_Competitor__c, Brand__c, Car_Model__c, Class__c, Color__c, Market__c, Mileage__c, Preferred__c, Related_Lead__c, Trade_In_Vehicle__c, Trim__c, Type__c, Vehicle_Model_Type__c, Year_of_Manufacture__c,brand_picklist__c,class_picklist__c From Lead_Details__c Where Related_Lead__c =: ApexPages.currentPage().getParameters().get('id')]){
            // Add vehicles separately
            String leadDetailRecordTypeName = UtilRecordType.getRecordTypeNameById('Lead_Details__c', ld.RecordTypeId);
            if(!allVehiclesMap.isEmpty() && allVehiclesMap.containsKey(leadDetailRecordTypeName)){
                List<Lead_Details__c> tempLdList = allVehiclesMap.get(leadDetailRecordTypeName);
                tempLdList.add(ld);
                allVehiclesList.add(ld);
                allVehiclesMap.put(leadDetailRecordTypeName, tempLdList);
            }
            else{
                allVehiclesList.add(ld);
                allVehiclesMap.put(leadDetailRecordTypeName, new List<Lead_Details__c>{ld});
            }
        }
        // Populate vehicles on edit page
        if(!allVehiclesMap.isEmpty()){
            intVehicleList.addAll(new list<Lead_Details__c>(allVehiclesMap.get(System.Label.Lead_Detail_Interested_Record_Type)));
            compVehicleList.addAll(new list<Lead_Details__c>(allVehiclesMap.get(System.Label.Lead_Detail_Competitor_Record_Type)));
        }
         	//Added for Interested CarModel Selection Utility for AU and NZ market	
        if(Opp.Market__c == 'AU' || Opp.Market__c == 'NZ')
        {
            lstSelectedOptions = new List<SelectOption>();
            carSearchFormat = ((String)System.label.CarSearchFormatCriteria).split(',');
            mapCarModel = SalesLeadUtility.populateCarModel(Opp);
            lstAvailableOptions = SalesLeadUtility.populateOptions(mapCarModel,null,true);
            lstPrepopulateOptions = SalesLeadUtility.populateOptions(mapCarModel,intVehicleList,false);
        }
    }
    // Populate Trade in vehicles on edit page
    public List<Lead_Details__c> getTradeInVehicles(){
        if(allVehiclesMap.isEmpty() || (!allVehiclesMap.isEmpty() && allVehiclesMap.get(System.Label.Lead_Detail_TradeIn_Record_Type) == NULL)){
            tradeVehc = new list<Lead_Details__c>();
            Lead_Details__c tld = new Lead_Details__c();
            tld.type__c = 'Trade In';
            ID leadrecTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_TradeIn_Record_Type);
            tld.RecordTypeId = leadrecTypeId;
            tld.Related_Lead__c = opp.Id;
            tradeVehc.add(tld);
            allVehiclesMap.put(System.Label.Lead_Detail_TradeIn_Record_Type,tradeVehc);
            return allVehiclesMap.get(System.Label.Lead_Detail_TradeIn_Record_Type);
        }
        else if(!allVehiclesMap.isEmpty() && allVehiclesMap.get(System.Label.Lead_Detail_TradeIn_Record_Type) != NULL){
            return allVehiclesMap.get(System.Label.Lead_Detail_TradeIn_Record_Type);
        }
        return null;
    }
    
    // Add interested vehicle records
    public PageReference addIntRecord() {
        Lead_Details__c led = new Lead_Details__c();
        led.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Interested_Record_Type);
        led.Related_Lead__c = opp.Id;
        led.Market__c = opp.market__c;
        intVehicleList.add(led);
        return null;
    }
    
    // Add Competitor vehicle records
    public PageReference addCompRecord() {        
        Lead_Details__c led = new Lead_Details__c();
        led.RecordTypeId = UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type);
        led.Related_Lead__c = opp.Id;
        led.Market__c = opp.Market__c;
        compVehicleList.add(led);
        return null;
    }
    
    // To auto populate various field values of the lead details record
    public void UpdateModInfoCtrl(){
        for(Lead_Details__c ledInt : intVehicleList){
            if((ledInt.Car_Model__c != null || ledInt.Brand_Picklist__c != null || ledInt.Class_Picklist__c != null) && !allVehiclesList.contains(ledInt))
                allVehiclesList.add(ledInt);
        }
        for(Lead_Details__c ledComp : compVehicleList){
            if((ledComp.Car_Model_Competitor__c != null || ledComp.Brand_Picklist__c != null || ledComp.Class_Picklist__c != null) && !allVehiclesList.contains(ledComp))
                allVehiclesList.add(ledComp);
        }
        for(Lead_Details__c ledDet : tradeVehc){
            if(!(ledDet.Trade_In_Vehicle__c == null && ledDet.Mileage__c == null && ledDet.Trim__c == null && ledDet.Year_of_Manufacture__c == null && ledDet.RecordTypeId == UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_TradeIn_Record_Type)))
                allVehiclesList.addAll(tradeVehc);
        }
        set<id> carModelIdSet = new set<id>();
        for(Lead_Details__c leDetail : allVehiclesList){
            carModelIdSet.add(leDetail.Car_Model__c);
            carModelIdSet.add(leDetail.Car_Model_Competitor__c);
        }
        Map<Id,Car_Model__c> cmMap = new Map<Id,Car_Model__c>([select id, brand__C,series__c,Colour__c,Trim__c from car_model__C where id in: carModelIdSet]);
        System.debug('cmMap==>' + cmMap);
        for(Lead_Details__c ld : allVehiclesList){
            if(ld.RecordTypeId == UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Interested_Record_Type)
               && cmMap.containsKey(ld.Car_Model__c)){
                   ld.Car_Model__c = cmMap.get(ld.Car_Model__c).Id;
                   ld.brand__C = cmMap.get(ld.Car_Model__c).brand__C;
                   ld.Class__c = cmMap.get(ld.Car_Model__c).Series__c;
                   ld.color__c = cmMap.get(ld.Car_Model__c).colour__c;
                   ld.trim__C = cmMap.get(ld.Car_Model__c).trim__c;
                   ld.Brand_Picklist__c = cmMap.get(ld.Car_Model__c).brand__C;
                   ld.Class_Picklist__c = cmMap.get(ld.Car_Model__c).Series__c;
               }
            else if(ld.RecordTypeId == UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type) 
                    && cmMap.containsKey(ld.Car_Model_Competitor__c)){
                        ld.Car_Model_Competitor__c = cmMap.get(ld.Car_Model_Competitor__c).Id;
                        ld.brand__C = cmMap.get(ld.Car_Model_Competitor__c).brand__C;
                        ld.Class__c = cmMap.get(ld.Car_Model_Competitor__c).Series__c;
                        ld.color__c = cmMap.get(ld.Car_Model_Competitor__c).colour__c;
                        ld.trim__C = cmMap.get(ld.Car_Model_Competitor__c).trim__c;
                        ld.Brand_Picklist__c = cmMap.get(ld.Car_Model_Competitor__c).brand__c;
                        ld.Class_Picklist__c = cmMap.get(ld.Car_Model_Competitor__c).Series__c;
                    }
        }
    }
    
    // Preferred Check logic
    public void checkIntVehiclePreferred(){
        intPreferredCount = 0;
        for(Lead_Details__c ld : allVehiclesList){
            if(ld.Preferred__c && ld.RecordTypeId == UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Interested_Record_Type))
                intPreferredCount++;
        }
        if(intPreferredCount > 1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.label.IN_Interested_Preferred_vehicle));
        }   
    }
    public void checkCompVehiclePreferred(){
        compPreferredCount = 0;
        for(Lead_Details__c ld : allVehiclesList){
            if(ld.Preferred__c && ld.RecordTypeId == UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type))
                compPreferredCount++;
        }
        if(compPreferredCount > 1){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, System.label.IN_Interested_Preferred_vehicle));
        }   
    }  
    // To save the lead record and upsert all the associated lead details record.
    public PageReference saveOpp(){
        UpdateModInfoCtrl();
        checkIntVehiclePreferred();
        checkCompVehiclePreferred();
        if(tradeVehc.size() > 0){
            if(tradeVehc[0].Trade_In_Vehicle__c != null && !allVehiclesList.contains(tradeVehc[0])) 
                allVehiclesList.add(tradeVehc[0]);
        }
        List<Lead_Details__c> finalAllVehicleList = new List<Lead_Details__c>();
        for(Lead_Details__c ledDet : allVehiclesList){
            if(!(ledDet.Car_Model__c == null && ledDet.Car_Model_Competitor__c == null && ledDet.Brand_Picklist__c == null && ledDet.Class_Picklist__c == null && ledDet.RecordTypeId != UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_TradeIn_Record_Type)))
                finalAllVehicleList.add(ledDet);
        }
        if(intPreferredCount < 2 && compPreferredCount < 2){
            try{
                if(finalAllVehicleList != null && finalAllVehicleList.size() != 0){
                    //rajesh 6/22/2018 - added set logic below to prevent duplicate error while upsert
                    Set<Lead_Details__c> setFinalLeadDetails = new Set<Lead_Details__c>();
                    setFinalLeadDetails.addAll(finalAllVehicleList);
                    List<Lead_Details__c> lstToUpsertLeadDetails = new List<Lead_Details__c>();
                    lstToUpsertLeadDetails.addAll(setFinalLeadDetails);
                    upsert lstToUpsertLeadDetails;
                    //Update opp;
                }
                // upsert finalAllVehicleList;
                 Update opp;
            }
            catch(DmlException de){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,de.getDMLMessage(0)));      
                return null;
            }         
               	//Added for Interested CarModel Selection Utility for AU and NZ market	
            if(Opp.Market__c == 'AU' || Opp.Market__c == 'NZ')
            {
                SalesLeadUtility.deleteSelectedLeadDetails(Opp);
            	SalesLeadUtility.createLeadDetails(Opp, lstSelectedOptions, mapCarModel);
            }
            PageReference oppPage = new ApexPages.StandardController(opp).view();
            oppPage.setRedirect(true);
            return oppPage;
        }
        return null;
    }
}