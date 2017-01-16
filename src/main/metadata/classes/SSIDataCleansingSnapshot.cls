/*
    Type:       Apex Class
    Purpose:    Generate snapshot of SSI data cleansing
    User Story: US-SSI-001
    Used By:    SSIBatchRestRuleCheck.class
    ---------------------------------------------------------------
    History:
    
    29-July-2013 Chris Huang (Breakingpoint)    Created
*/

public class SSIDataCleansingSnapshot{ 
    
    private static final String WEEKLYNEWDEALERS = 'Weekly New Dealers';
    private static final String WEEKLYNEWCARMODELS = 'Weekly New CarModels';
    private static final String WEEKLYINVALIDTOTAL = 'Weekly Invalid Total';
    private static final String WEEKLYCOMPARISION = 'Weekly Comparision';
    private static final String WEEKLYINVALIDDETAIL = 'Weekly Invalid Detail';
    private static final String MONTHLYINVALIDTOTAL = 'Monthly Invalid Total';
    private static final String MONTHLYCOMPARISION = 'Monthly Comparision';
    private static final String MONTHLYINVALIDDETAIL = 'Monthly Invalid Detail';
    
    private static final String Rule_1 = 'Time cannot match'; 
    private static final String Rule_2 = 'Invalid contact';  
    private static final String Rule_3 = 'Same VIN of current period';  
    private static final String Rule_4 = 'Same contact information of current period';  
    private static final String Rule_5 = 'Government vehicles';  
    private static final String Rule_6 = 'Dealer vehicles & Sub-dealer vehicles';  
    private static final String Rule_7 = 'Same VIN and same contact name';  
    private static final String Rule_8 = 'Same VIN and different contact name';  
    private static final String Rule_9 = 'Same contact and same contact name';  
    private static final String Rule_10 = 'Same contact and different contact name';  

    public static void generateSnapshot(List<Id> batchIds){
        
        List<SSI__c> allSSIs = new List<SSI__c>();

        Map<String, SSI_Cleansing_Result__c> resultMap = new Map<String, ssi_cleansing_result__c>();

        prepareData(batchIds, allSSIs, resultMap);

        for (SSI__c ssi : allSSIs) {
            if (ssi.InvoiceDate__c == null){
                continue;
            }
           
            calculateWeeklyNewDealer(ssi, resultMap);
           
            calculateWeeklyNewCarModel(ssi, resultMap);
            calculateWeeklyInvalidTotal(ssi, resultMap);
            calculateWeeklyComparision(ssi, resultMap);
            calculateWeeklyInvalidDetail(ssi, resultMap);
            calculateMonthlyInvalidTotal(ssi, resultMap);
            calculateMonthlyComparision(ssi, resultMap);
            calculateMonthlyInvalidDetail(ssi, resultMap);
        }

        calculateComparision(resultMap);

        if(!resultMap.values().isEmpty()){
            upsert resultMap.values();
        }

    }

    private static void calculateWeeklyNewDealer(SSI__c ssi, Map<String, SSI_Cleansing_Result__c> resultMap) {
        if(ssi.Status__c == 'All Valid' && ssi.DealerCheck_Status__c == 'Accept'){
            String key = getKey(WEEKLYNEWDEALERS, ssi, ssi.InvoiceDate__c.toStartOfWeek());
            SSI_Cleansing_Result__c cr = getResult(resultMap, key);
            cr.SSI_Created_Date__c = ssi.InvoiceDate__c.toStartOfWeek();

            cr.Dealer__c = ssi.Dealer__c;
            cr.DealerName__c = ssi.DealerName__c;
            cr.DealerTotal__c++;
        }
    }

    private static void calculateWeeklyNewCarModel(SSI__c ssi, Map<String, SSI_Cleansing_Result__c> resultMap) {
        if(ssi.Status__c == 'All Valid' && ssi.CarModelCheck_Status__c == 'Accept'){
            String key = getKey(WEEKLYNEWCARMODELS, ssi, ssi.InvoiceDate__c.toStartOfWeek());
            SSI_Cleansing_Result__c cr = getResult(resultMap, key);
            cr.SSI_Created_Date__c = ssi.InvoiceDate__c.toStartOfWeek();

            cr.VehicleCBUCKD__c = ssi.VehicleCBUCKD__c;
            cr.VehicleModel__c = ssi.VehicleModel__c;
            cr.VehicleDesc__c = ssi.VehicleDesc__c;
            cr.VehicleTotal__c++;
        }
    }

    private static void calculateWeeklyInvalidTotal(SSI__c ssi, Map<String, SSI_Cleansing_Result__c> resultMap) {
        
        if(ssi.Status__c == 'Invalid'){
            String key = getKey(WEEKLYINVALIDTOTAL, ssi, ssi.InvoiceDate__c.toStartOfWeek());
            SSI_Cleansing_Result__c cr = getResult(resultMap, key);
            cr.SSI_Created_Date__c = ssi.InvoiceDate__c.toStartOfWeek();

            cr.CurrentWeekInvalid__c++;
            addSuspectReason(ssi, cr);
        }
    }

    private static void calculateWeeklyComparision(SSI__c ssi, Map<String, SSI_Cleansing_Result__c> resultMap) {
        String key = getKey(WEEKLYCOMPARISION, ssi, ssi.InvoiceDate__c.toStartOfWeek());
        SSI_Cleansing_Result__c cr = getResult(resultMap, key);
        cr.SSI_Created_Date__c = ssi.InvoiceDate__c.toStartOfWeek();

        if(cr.Dealer__c == null || cr.Dealer__c.length() == 0){
            cr.Dealer__c = ssi.Dealer__c;
            cr.DealerName__c = ssi.DealerName__c;
        }     

        cr.CurrentWeekTotal__c++;
        if(ssi.Status__c == 'All Valid'){
            cr.CurrentWeekValid__c++;
        }else if(ssi.Status__c == 'Invalid'){
            cr.CurrentWeekInvalid__c++;         
        } 
    }

    private static void calculateWeeklyInvalidDetail(SSI__c ssi, Map<String, SSI_Cleansing_Result__c> resultMap) {
        String key = getKey(WEEKLYINVALIDDETAIL, ssi, ssi.InvoiceDate__c.toStartOfWeek());
        SSI_Cleansing_Result__c cr = getResult(resultMap, key);
        cr.SSI_Created_Date__c = ssi.InvoiceDate__c.toStartOfWeek();

        if(cr.Dealer__c == null || cr.Dealer__c.length() == 0){
            cr.Dealer__c = ssi.Dealer__c;
            cr.DealerName__c = ssi.DealerName__c;
        }    

        cr.CurrentWeekTotal__c++;
        if(ssi.Status__c == 'All Valid'){
            cr.CurrentWeekValid__c++;
        }else if(ssi.Status__c == 'Invalid'){
            cr.CurrentWeekInvalid__c++;    
            addSuspectReason(ssi, cr);        
        }       
    }

    private static void calculateMonthlyInvalidTotal(SSI__c ssi, Map<String, SSI_Cleansing_Result__c> resultMap) {
        if(ssi.Status__c == 'Invalid'){
            String key = getKey(MONTHLYINVALIDTOTAL, ssi, ssi.InvoiceDate__c.toStartOfMonth());
            SSI_Cleansing_Result__c cr = getResult(resultMap, key);
            cr.SSI_Created_Date__c = ssi.InvoiceDate__c.toStartOfMonth();

            cr.CurrentMonthInvalid__c++;
            addSuspectReason(ssi, cr);
        }
    }

    private static void calculateMonthlyComparision(SSI__c ssi, Map<String, SSI_Cleansing_Result__c> resultMap) {
        String key = getKey(MONTHLYCOMPARISION, ssi, ssi.InvoiceDate__c.toStartOfMonth());
        SSI_Cleansing_Result__c cr = getResult(resultMap, key);
        cr.SSI_Created_Date__c = ssi.InvoiceDate__c.toStartOfMonth();

        if(cr.Dealer__c == null || cr.Dealer__c.length() == 0){
            cr.Dealer__c = ssi.Dealer__c;
            cr.DealerName__c = ssi.DealerName__c;
        }            

        cr.CurrentMonthTotal__c++;
        if(ssi.Status__c == 'All Valid'){
            cr.CurrentMonthValid__c++;
        }else if(ssi.Status__c == 'Invalid'){
            cr.CurrentMonthInvalid__c++;         
        }
    }

    private static void calculateMonthlyInvalidDetail(SSI__c ssi, Map<String, SSI_Cleansing_Result__c> resultMap) {
        String key = getKey(MONTHLYINVALIDDETAIL, ssi, ssi.InvoiceDate__c.toStartOfMonth());
        SSI_Cleansing_Result__c cr = getResult(resultMap, key);
        cr.SSI_Created_Date__c = ssi.InvoiceDate__c.toStartOfMonth();

        if(cr.Dealer__c == null || cr.Dealer__c.length() == 0){
            cr.Dealer__c = ssi.Dealer__c;
            cr.DealerName__c = ssi.DealerName__c;
        }    

        cr.CurrentMonthTotal__c++;
        if(ssi.Status__c == 'All Valid'){
            cr.CurrentMonthValid__c++;
        }else if(ssi.Status__c == 'Invalid'){
            cr.CurrentMonthInvalid__c++;  
            addSuspectReason(ssi, cr);          
        }               
    }

    private static void calculateComparision(Map<String, SSI_Cleansing_Result__c> resultMap){
        for(SSI_Cleansing_Result__c cr : resultMap.values()){
            if(cr.Type__c == WEEKLYCOMPARISION){
                String pkey = getKey(cr.Type__c, cr.SSI_Created_Date__c.addDays(-7), cr.Dealer__c, cr.VehicleDesc__c);
                if (resultMap.containsKey(pkey)) {
                    SSI_Cleansing_Result__c pcr = resultMap.get(pkey);
                    cr.LastWeekTotal__c = pcr.CurrentWeekTotal__c;
                    cr.LastWeekValid__c = pcr.CurrentWeekValid__c;
                    cr.LastWeekInvalid__c = pcr.CurrentWeekInvalid__c;
                }

            }else if(cr.Type__c == MONTHLYCOMPARISION){
                String pkey = getKey(cr.Type__c, cr.SSI_Created_Date__c.addMonths(-1), cr.Dealer__c, cr.VehicleDesc__c);
                if (resultMap.containsKey(pkey)) {
                    SSI_Cleansing_Result__c pcr = resultMap.get(pkey);
                    cr.LastMonthTotal__c = pcr.CurrentMonthTotal__c;
                    cr.LastMonthValid__c = pcr.CurrentMonthValid__c;
                    cr.LastMonthInvalid__c = pcr.CurrentMonthInvalid__c;
                }    
            }
        }
    }
    

    private static void addSuspectReason (SSI__c ssi, SSI_Cleansing_Result__c cr) {
        if(ssi.DealerCheck_Status__c == 'Reject'){
            cr.Illegal_Dealer__c++;
        }else if(ssi.CarModelCheck_Status__c == 'Reject'){
            cr.Car_Model_Unmatched__c++;
        }else if(ssi.Suspect_Reason__c == Rule_1){
            cr.Time_cannot_match__c++;
        }else if(ssi.Suspect_Reason__c == Rule_2){
            cr.Invalid_contact__c++;
        }else if(ssi.Suspect_Reason__c == Rule_3){
            cr.Same_VIN_of_current_period__c++;
        }else if(ssi.Suspect_Reason__c == Rule_4){
            cr.Same_contact_info_of_current_period__c++;
        }else if(ssi.Suspect_Reason__c == Rule_5){
            cr.Government_vehicles__c++;
        }else if(ssi.Suspect_Reason__c == Rule_6){
            cr.Dealer_vehicles_Sub_dealer_vehicles__c++;
        }else if(ssi.Suspect_Reason__c == Rule_7){
            cr.Same_VIN_and_same_contact_name__c++;
        }else if(ssi.Suspect_Reason__c == Rule_8){
            cr.Same_VIN_and_different_contact_name__c++;
        }else if(ssi.Suspect_Reason__c == Rule_9){
            cr.Same_contact_and_same_contact_name__c++;
        }else if(ssi.Suspect_Reason__c == Rule_10){
            cr.Same_contact_and_different_contact_name__c++;
        }  
    }

    private static SSI_Cleansing_Result__c getResult(Map<String, SSI_Cleansing_Result__c> resultMap, String key) {
        if(!resultMap.containsKey(key)){
            resultMap.put(key, new SSI_Cleansing_Result__c());
        
            SSI_Cleansing_Result__c cr = resultMap.get(key);
            cr.Type__c = key.split('-')[0];

            cr.CurrentWeekTotal__c = 0;
            cr.CurrentWeekValid__c = 0;
            cr.CurrentWeekInvalid__c = 0;
            cr.LastWeekTotal__c = 0; 
            cr.LastWeekValid__c = 0;
            cr.LastWeekInvalid__c = 0; 

            cr.CurrentMonthTotal__c = 0; 
            cr.CurrentMonthValid__c = 0; 
            cr.CurrentMonthInvalid__c = 0; 
            cr.LastMonthTotal__c = 0; 
            cr.LastMonthValid__c = 0; 
            cr.LastMonthInvalid__c = 0; 

            cr.Valid__c = 0; 
            cr.Invalid__c = 0; 

            cr.Illegal_Dealer__c = 0; 
            cr.Car_Model_Unmatched__c = 0; 
            cr.Time_cannot_match__c = 0; 
            cr.Invalid_contact__c = 0; 
            cr.Same_VIN_of_current_period__c = 0; 
            cr.Same_contact_info_of_current_period__c = 0; 
            cr.Government_vehicles__c = 0; 
            cr.Dealer_vehicles_Sub_dealer_vehicles__c = 0; 
            cr.Same_VIN_and_same_contact_name__c = 0; 
            cr.Same_VIN_and_different_contact_name__c = 0; 
            cr.Same_contact_and_same_contact_name__c = 0; 
            cr.Same_contact_and_different_contact_name__c = 0; 

            cr.VehicleTotal__c = 0; 

            cr.DealerTotal__c = 0; 

        }    

        return resultMap.get(key);
    }

    private static void prepareData (List<Id> batchIds, List<SSI__c> allSSIs, Map<String, SSI_Cleansing_Result__c> resultMap) {

        for(List<SSI__c> ssis : 
                [Select 
                    Id, 
                    InvoiceDate__c,
                    Status__c, 
                    Dealer__c,
                    DealerName__c,
                    VehicleCBUCKD__c,
                    VehicleModel__c,
                    VehicleDesc__c,
                    DealerCheck_Status__c, 
                    CarModelCheck_Status__c,
                    Suspect_Reason__c
                From SSI__c
                Where Id In: batchIds And InvoiceDate__c != null 
                ]){
            allSSIs.addAll(ssis);
        }

        Set<Date> dataRegion = new Set<Date>();

        for(SSI__c ssi : allSSIs){
            Date cwkey = ssi.InvoiceDate__c.toStartOfWeek();
            Date cmkey = ssi.InvoiceDate__c.toStartOfMonth();
            Date pwKey = cwkey.addDays(-7);
            Date pmKey = cmkey.addMonths(-1);
            dataRegion.add(cwkey);
            dataRegion.add(cmkey);
            dataRegion.add(pwKey);
            dataRegion.add(pmKey);
        }

        getResultMap(dataRegion, resultMap);

    }

    private static void getResultMap (Set<Date> dataRegion, Map<String, SSI_Cleansing_Result__c> resultMap) {

        for(List<SSI_Cleansing_Result__c> crs : [
            SELECT 
                Id, 
                Sinotrust_Number__c, 
                Dealer__c, 
                DealerName__c, 
                CurrentWeekTotal__c, 
                CurrentWeekValid__c, 
                CurrentWeekInvalid__c, 
                LastWeekTotal__c, 
                LastWeekValid__c, 
                LastWeekInvalid__c, 
                CurrentMonthTotal__c, 
                CurrentMonthValid__c, 
                CurrentMonthInvalid__c, 
                LastMonthTotal__c, 
                LastMonthValid__c, 
                LastMonthInvalid__c, 
                Type__c, 
                //MonthlyInvalidComparision__c, 
                //MonthlyTotalComparision__c, 
                //MonthlyValidComparision__c, 
                //WeeklyInvalidComparision__c, 
                //WeeklyTotalComparision__c, 
                //WeeklyValidComparision__c, 
                SSI_Created_Date__c, 
                Valid__c, 
                Invalid__c, 
                Car_Model_Unmatched__c, 
                Time_cannot_match__c, 
                Invalid_contact__c, 
                Same_VIN_of_current_period__c, 
                Same_contact_info_of_current_period__c, 
                Government_vehicles__c, 
                Dealer_vehicles_Sub_dealer_vehicles__c, 
                Same_VIN_and_same_contact_name__c, 
                Same_VIN_and_different_contact_name__c, 
                Same_contact_and_same_contact_name__c, 
                Same_contact_and_different_contact_name__c, 
                VehicleCBUCKD__c, 
                VehicleModel__c, 
                VehicleDesc__c, 
                VehicleTotal__c, 
                DealerTotal__c, 
                Illegal_Dealer__c
            From ssi_cleansing_result__c
            Where Createddate >= LAST_N_Days:60 And SSI_Created_Date__c in: dataRegion]){

            for(SSI_Cleansing_Result__c cr : crs){        
                String key = getKey(cr);       
                resultMap.put(key, cr);        
            }

        }
    }

    private static String getKey (String type, SSI__c ssi, Date InvoiceDate) {
        return getKey(type, InvoiceDate, ssi.Dealer__c, ssi.VehicleDesc__c);
    }

    private static String getKey (SSI_Cleansing_Result__c cr) {
        return getKey(cr.Type__c, cr.SSI_Created_Date__c, cr.Dealer__c, cr.VehicleDesc__c);  
    }

    private static String getKey (String type, Date InvoiceDate, String dealer, String carModel) {
        String key = '';
        if(type == WEEKLYNEWDEALERS){
            key = type + '-' + InvoiceDate.format() + '-' + dealer;      
        }else if(type == WEEKLYNEWCARMODELS){
            key = type + '-' + InvoiceDate.format() + '-' + carModel;          
        }else if(type == WEEKLYINVALIDTOTAL){
            key = type + '-' + InvoiceDate.format();          
        }else if(type == WEEKLYCOMPARISION){
            key = type + '-' + InvoiceDate.format() + '-' + dealer;      
        }else if(type == WEEKLYINVALIDDETAIL){
            key = type + '-' + InvoiceDate.format() + '-' + dealer;          
        }else if(type == MONTHLYINVALIDTOTAL){
            key = type + '-' + InvoiceDate.format();          
        }else if(type == MONTHLYCOMPARISION){
            key = type + '-' + InvoiceDate.format() + '-' + dealer;      
        }else if(type == MONTHLYINVALIDDETAIL){
            key = type + '-' + InvoiceDate.format() + '-' + dealer;          
        }
        return key;
    }
    
}