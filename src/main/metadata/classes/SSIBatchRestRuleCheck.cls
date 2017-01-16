/*
    Type:       SSI rest rule cleansing (Data Quality Cleansing)
    Purpose:    Clean rest rule
    User Story: US-SSI-004, CR-000098, SSI-003
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Chris Created on 2013-06-21
    2. Chris Update on 2013-08-30 Change all Current Period check logic.
    3. Patrick Zhang add new phone number filter on 2013-12-02
    4. Patrick Zhang add new isPhoneNumberValid() on 2013-12-03
    5. Patrick Zhang remove codes about Vin Match and task creation 
    6. Barney lai modified on 2014-3-5

*/
global class SSIBatchRestRuleCheck implements Database.Batchable<SObject> { //, Database.Stateful  {
    
    private String query;
    
    private Integer successCount = 0;

    private List<SSI__c> currentScope = new List<SSI__c>();
    
    private final String Rule_1 = 'Time cannot match'; 
    private final String Rule_2 = 'Invalid contact';  
    private final String Rule_3 = 'Same VIN of current period';  
    private final String Rule_4 = 'Same contact information of current period';  
    private final String Rule_5 = 'Government vehicles';  
    private final String Rule_6 = 'Dealer vehicles & Sub-dealer vehicles';  
    private final String Rule_7 = 'Same VIN and same contact name';  
    private final String Rule_8 = 'Same VIN and different contact name';  
    private final String Rule_9 = 'Same contact and same contact name';  
    private final String Rule_10 = 'Same contact and different contact name';  

    private static String totalItemsString = 'totalItems';
    
    //Barney lai 2014-3-5 start
    private enum setType {
        VIN,
        MOBILE,
        PHONE,
        ORIGINALMOBILE,
        ORIGINALPHONE
    }
    //Barney lai 2014-3-5 end
    
    private String[] GovVehicles = new String[]{
        'Office', 'Government', 'Appoint', 'Standing', 'Political consultation', 'Deputies', 'NPC', 'General Political', 'Assembly', 
        'Headquarters', 'Ganxiu', 'Retired cadres', 'Department of Transportation', 'CPPCC', 'Procuratorate', 'Check the hospital', 'Court', 
        'Army', 'Military Representative Office', 'Military Representative', 'Military region', 'Subdistricts', 'War office', 'War Office', 'Readiness', 'Reserve', 
        'Local police station', 'Armed', 'Police', 'Guard', 'Police', 'Police detachment', 'Police', 'Prison', 'Public security', 'Smuggling', 
        'Customs', 'Fire Brigade', 'Troops', 'Armed Forces Department', 'General Staff', 'Border Detachment', 'Criminal Investigation Unit', 'Detention', 'On behalf of', 
        'Border defense', 'Customs', 'Organization Department', 'Republic', 'Stockpiles', 'National Security'
    };
        
    private String[] DealerVehicles = new String[]{ 
        'PDI','Hokusei','Run quickly','Products Car','Vehicle Industry','Rent','German star','Dongchi','East Star','Two','Navistar','Huaxing','Vehicle','Car','Dealer','Truck',
        'Stock car','Lee Star','Lone Star','Pengxing','Car','Zung Fu','Rising','Goods vehicles','Test drive','Pre car','Teng Star','Pass and','Sales','Star Han','SACA','The more stars',
        'Star','Star','The transfer','Lease','Boss','Huge','North Pennines','Extreme','Penglong','The letter','Bao lied','Min Star','Starfish','Hong Yue Star','Kam Shing','Guizhou your star','Hainan joint Crown','Hengyang Chifeng','Hunan, China and the United States','Jining lucky','Jiaxing a letter','Jiangmen co ceremony','Million to help clear all','Jiujiang Inchcape','Kunming Star flag','Nanjing- Star','Nanning Guanxing',
        'Wenfeng Heng-wei','Hing Ning Xinyu','Qingdao Sanhe','South Link Xinghui','Quzhou Auron','Quanzhou Long Star','Ryan Hongsheng','Shantou Jinhao','Shantou Wing Chun','Proudly Daxing','Shenzhen Furi','Taizhou DelStar',
        'Taizhou Op','Wenzhou Huaneng','Wuxi letter country','Wuhan Star Long','Wuhan Starwise','Yiwu GuoBang','Wuou','Yongkang guobang','Yuanan Queensland star','South Link Xinghui','Zhejiang huace','Zhejiang XING-hang',
        'Chongqing company Yee Hing','Chongqing stars Shun','Zibo star Kat'
    };
    
    //Barney lai 2014-3-5 start
    private String[] DealervehiclesSubdealervehicles = new String[]{
        'Automotive','Star','Commercial vehicle','Sales','Rentals','Dealer','test drive','transfer','Product cart','Sold vehicle','Vehicle industry',
        'Motor vehicle','Truck','Stock cars','Secondary','Cars','Rental','East star','North Star','Star logo','Renfu','Stars','Lone Star','Li Xing',
        'Mercedes-Benz','Pass and','Star John','Free Star','ROC star','Hangxing','More stars','Rising','Huaxing'
    };
    //Barney lai 2014-3-5 end

    // Patrick Start
    private String[] SerialPhoneNumbers = new String[]{
        '0000000','1111111','2222222','3333333','4444444','5555555','6666666',
        '7777777','8888888','9999999'
    };
    // Patrick Stop
    
    // Map<'2013-6', Map<UsVIN, ssi>>
    private Map<String, Map<String, SSI__c>> VINSMAP = new Map<String, Map<String, SSI__c>>();
    // Map<UsVin, batchSSI>
    //private Map<String, SSI__c> VOMAP = new Map<String,SSI__c>();
    
    // Map<'2013-6', Map<mobile, ssi>>
    private Map<String, Map<String, SSI__c>> MOBILEMAP = new Map<String, Map<String, SSI__c>>();
    // Map<mobile, batchSSI>
    //private Map<String,SSI__c> MOBILEOMAP = new Map<String,SSI__c>();
    
    //Barney lai 2014-3-5 start
    private Map<String, Map<String, SSI__c>> PHONEMAP = new Map<String, Map<String, SSI__c>>();
    private Map<String, Map<String, SSI__c>> ORIGINALMOBILEMAP = new Map<String, Map<String, SSI__c>>();
    private Map<String, Map<String, SSI__c>> ORIGINALPHONEMAP = new Map<String, Map<String, SSI__c>>();
    //Barney lai 2014-3-5 end

    
    private void setPeriodSet (List<SSI__c> scope) {

        Set<String> vinSet = new Set<String>();
        Set<String> mobileSet = new Set<String>();
        Set<String> phoneSet = new Set<String>();
        //Barney lai 2014-3-5 start
        Set<String> originalmobileSet = new Set<String>();
        Set<String> originalphoneSet = new Set<String>();
        //Barney lai 2014-3-5 end
        for (SSi__c ssi : scope) {
            if (ssi.VehicleUSvin__c != null) {
                vinSet.add(ssi.VehicleUSvin__c);
            }           
            if (ssi.HomeMobilePhone__c != null) {
                String hphone = formatPhone(ssi.HomeMobilePhone__c);
                if (hphone != null) {
                    mobileSet.add(hphone);
                }                
            }
            //Barney lai 2014-3-5 start
            if (ssi.OfficePhone__c != null) {
                String ophone = formatPhone(ssi.OfficePhone__c);
                if (ophone != null) {
                    phoneSet.add(ophone);
                }   
            }
            if (ssi.Original_HomeMobilePhone__c != null) {
                String rhphone = formatPhone(ssi.Original_HomeMobilePhone__c);
                if (rhphone != null) {
                    originalmobileSet.add(rhphone);
                }   
            }
            if (ssi.OriginalOfficePhone__c != null) {
                String rophone = formatPhone(ssi.OriginalOfficePhone__c);
                if (rophone != null) {
                    originalphoneSet.add(rophone);
                }   
            }
            //Barney lai 2014-3-5 end
        }    

        // get start date
        AggregateResult[] sds = [
            SELECT MIN(InvoiceDate__c)startDate 
            FROM SSI__c
            Where Id in :scope
        ];
        Date startDate = sds.size() > 0 ? (Date)sds[0].get('startDate') : null;

        // get end date
        AggregateResult[] eds = [
            SELECT MAX(InvoiceDate__c)endDate 
            FROM SSI__c
            Where Id in :scope
        ];
        Date endDate = eds.size() > 0 ? (Date)eds[0].get('endDate') : null;

        if(startDate != null && endDate != null) {
            Date sd = startDate.toStartOfMonth().addMonths(-3);
            Date ed = endDate.toStartOfMonth().addMonths(1);
            //Barney lai 2014-3-5 start
            for(List<SSI__c> sList : [
                Select VehicleUSvin__c, CustomerName__c, HomeMobilePhone__c, OfficePhone__c, InvoiceDate__c,
                Original_HomeMobilePhone__c, OriginalOfficePhone__c, OriginalCustomerName__c
                From SSI__c 
                Where Status__c In ('All Valid', 'Unmatched', 'Matched') 
                    And InvoiceDate__c >= :sd And InvoiceDate__c < :ed And VehicleUSvin__c != null 
                    And VehicleUSvin__c In :vinSet]){
                setSinglePeriodSet(sList);
            } // SOQL for USVin loop
            
           for(List<SSI__c> sList : [
                Select VehicleUSvin__c, CustomerName__c, HomeMobilePhone__c, OfficePhone__c, InvoiceDate__c,
                Original_HomeMobilePhone__c, OriginalOfficePhone__c, OriginalCustomerName__c
                From SSI__c 
                Where Status__c In ('All Valid', 'Unmatched', 'Matched') 
                    And InvoiceDate__c >= :sd And InvoiceDate__c < :ed And HomeMobilePhone__c != null 
                    And (HomeMobilePhone__c In :mobileSet OR HomeMobilePhone__c In :phoneSet 
                         OR HomeMobilePhone__c In :originalmobileSet OR HomeMobilePhone__c In :originalphoneSet)]){
                setSinglePeriodSet(sList);
            } // SOQL for HomeMobilePhone loop
            
           for(List<SSI__c> sList : [
                Select VehicleUSvin__c, CustomerName__c, HomeMobilePhone__c, OfficePhone__c, InvoiceDate__c,
                Original_HomeMobilePhone__c, OriginalOfficePhone__c, OriginalCustomerName__c
                From SSI__c 
                Where Status__c In ('All Valid', 'Unmatched', 'Matched') 
                    And InvoiceDate__c >= :sd And InvoiceDate__c < :ed And OfficePhone__c != null 
                    //Barney lai 2014-3-5 start
                    And (OfficePhone__c In :mobileSet OR OfficePhone__c In :phoneSet 
                         OR OfficePhone__c In :originalmobileSet OR OfficePhone__c In :originalphoneSet)]){
                    //Barney lai 2014-3-5 end
                setSinglePeriodSet(sList);
            } // SOQL for OfficePhone loop
            
            for(List<SSI__c> sList : [
                Select VehicleUSvin__c, CustomerName__c, HomeMobilePhone__c, OfficePhone__c, InvoiceDate__c,
                Original_HomeMobilePhone__c, OriginalOfficePhone__c, OriginalCustomerName__c
                From SSI__c 
                Where Status__c In ('All Valid', 'Unmatched', 'Matched') 
                    And InvoiceDate__c >= :sd And InvoiceDate__c < :ed And Original_HomeMobilePhone__c != null 
                    //Barney lai 2014-3-5 start
                    And (Original_HomeMobilePhone__c In :mobileSet OR Original_HomeMobilePhone__c In :phoneSet 
                         OR Original_HomeMobilePhone__c In :originalmobileSet OR Original_HomeMobilePhone__c In :originalphoneSet)]){
                    //Barney lai 2014-3-5 end
                setSinglePeriodSet(sList);
            } // SOQL for Original HomeMobilePhone loop
            
            for(List<SSI__c> sList : [
                Select VehicleUSvin__c, CustomerName__c, HomeMobilePhone__c, OfficePhone__c, InvoiceDate__c,
                Original_HomeMobilePhone__c, OriginalOfficePhone__c, OriginalCustomerName__c
                From SSI__c 
                Where Status__c In ('All Valid', 'Unmatched', 'Matched') 
                    And InvoiceDate__c >= :sd And InvoiceDate__c < :ed And OriginalOfficePhone__c != null 
                    //Barney lai 2014-3-5 start
                    And (OriginalOfficePhone__c In :mobileSet OR OriginalOfficePhone__c In :phoneSet 
                         OR OriginalOfficePhone__c In :originalmobileSet OR OriginalOfficePhone__c In :originalphoneSet)]){
                    //Barney lai 2014-3-5 end
                setSinglePeriodSet(sList);
            } // SOQL for Original OriginalOfficePhone loop
            //Barney lai 2014-3-5 end
        } // date condition
    }

    private void setSinglePeriodSet (List<SSI__c> ssis) {
        for (SSI__c ssi : ssis) {
            String key = ssi.invoiceDate__c.year() + '-' + ssi.invoiceDate__c.month();

            if(!VINSMAP.containsKey(key)){
                VINSMAP.put(key, new Map<String, SSI__c>());
            }
            if(ssi.VehicleUSvin__c != null && ssi.VehicleUSvin__c.length() > 0){
                VINSMAP.get(key).put(ssi.VehicleUSvin__c, ssi);
            }

            if(!MOBILEMAP.containsKey(key)){
                MOBILEMAP.put(key, new Map<String, SSI__c>());
            }
            if(ssi.HomeMobilePhone__c != null && ssi.HomeMobilePhone__c.length() > 0){
                if(isPhoneNumberValid(ssi.HomeMobilePhone__c)){
                     MOBILEMAP.get(key).put(ssi.HomeMobilePhone__c, ssi);
                }           
            }
            //Barney lai 2014-3-5 start
            if(!PHONEMAP.containsKey(key)){
                PHONEMAP.put(key, new Map<String, SSI__c>());
            }
            if(ssi.OfficePhone__c != null && ssi.OfficePhone__c.length() > 0){
                if(isPhoneNumberValid(ssi.OfficePhone__c)){
                     PHONEMAP.get(key).put(ssi.OfficePhone__c, ssi);
                }           
            }
            
            if(!ORIGINALMOBILEMAP.containsKey(key)){
                ORIGINALMOBILEMAP.put(key, new Map<String, SSI__c>());
            }
            if(ssi.Original_HomeMobilePhone__c != null && ssi.Original_HomeMobilePhone__c.length() > 0){
                if(isPhoneNumberValid(ssi.Original_HomeMobilePhone__c)){
                     ORIGINALMOBILEMAP.get(key).put(ssi.Original_HomeMobilePhone__c, ssi);
                }           
            }
            
            if(!ORIGINALPHONEMAP.containsKey(key)){
                ORIGINALPHONEMAP.put(key, new Map<String, SSI__c>());
            }
            if(ssi.OriginalOfficePhone__c != null && ssi.OriginalOfficePhone__c.length() > 0){
                if(isPhoneNumberValid(ssi.OriginalOfficePhone__c)){
                     ORIGINALPHONEMAP.get(key).put(ssi.OriginalOfficePhone__c, ssi);
                }           
            }
            //Barney lai 2014-3-5 end
        }
    }

    private void setSinglePeriodSet (SSI__c ssi) {
        List<SSI__c> ssis = new List<SSI__c>();
        ssis.add(ssi);
        setSinglePeriodSet(ssis);
    }

    private Map<String, SSI__c> getPeriodSet(Date invoiceDate, setType sType){
        Map<String, SSI__c> checkMap = new Map<String, SSI__c>();

        if(invoiceDate != null){

            String key = invoiceDate.year() + '-' + invoiceDate.month();  

            if(sType == setType.VIN && VINSMAP.containsKey(key)){
                checkMap = VINSMAP.get(key); 
            //Barney lai 2014-3-5 start
            } else if(sType == setType.MOBILE && MOBILEMAP.containsKey(key)){
                checkMap = MOBILEMAP.get(key); 
            } else if(sType == setType.PHONE && PHONEMAP.containsKey(key)){
                checkMap = PHONEMAP.get(key); 
            } else if(sType == setType.ORIGINALMOBILE && ORIGINALMOBILEMAP.containsKey(key)){
                checkMap = ORIGINALMOBILEMAP.get(key); 
            } else if(sType == setType.ORIGINALPHONE && ORIGINALPHONEMAP.containsKey(key)){
                checkMap = ORIGINALPHONEMAP.get(key); 
            }
            //Barney lai 2014-3-5 end
                    
        }
        return checkMap;
    }
    
    global SSIBatchRestRuleCheck(String q) {
        this.query = q;       
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {


        setPeriodSet(scope);

        List<SSI__c> externalUpdateList = new List<SSI__c>();

        for(SSI__c ssi : (List<SSI__c>)scope){
            
            //rule 1: Inconsistent time
            
            if(ssi.InvoiceDate__c == null){
                invalid(ssi, Rule_1);
                continue;
            } else {
                Date invoiceDate = ssi.InvoiceDate__c.toStartOfMonth();
                Date handoverDate = ssi.HandoverDate__c.toStartOfMonth();
                if (invoiceDate > handoverDate) {
                    invalid(ssi, Rule_1);
                    continue;
                }
            }

            //rule 2: Invalid Contact
            Boolean noPhone = true;
            if(ssi.HomeMobilePhone__c != null){
                ssi.HomeMobilePhone__c = formatPhone(ssi.HomeMobilePhone__c);
                if (isPhoneNumberValid(ssi.HomeMobilePhone__c)) {
                    noPhone = false;
                }
            }

            if(ssi.OfficePhone__c != null){
                ssi.OfficePhone__c = formatPhone(ssi.OfficePhone__c);
                if (isPhoneNumberValid(ssi.OfficePhone__c)) {
                    noPhone = false;
                }
            }
            if(noPhone){
                invalid(ssi, Rule_2);
                continue;
            }
            
            //rule 3: Chassis No. same period
            //1. All Valid records exist within the same chassis number, then all records of the same chassis number Invalid
            //2. This issue does not exist within the same chassis, All Valid records, then:
            //a. This instalment within the same chassis number invoice date are also the same, take a validated, and the remaining Invalid
            //b. This instalment within the same chassis number invoice date, take the validation of invoices at an earlier date, the remaining Invalid
            if(ssi.VehicleUSvin__c == null){
                invalid(ssi, Rule_3);
                continue;
            }else{
                if(getPeriodSet(ssi.InvoiceDate__c, setType.VIN).keySet().contains(ssi.VehicleUSvin__c)){
                    //1
                    invalid(ssi, Rule_3);
                    continue;
                }
            }
            
            //rule 4: Associated with the period in the same way
            // Who this period or the memory on the same mobile phone number or phone number is Invalid
            //Barney lai 2014-3-5 start
            if(ssi.HomeMobilePhone__c!= null && ssi.HomeMobilePhone__c.length() > 0 
                && (getPeriodSet(ssi.InvoiceDate__c, setType.MOBILE).keySet().contains(ssi.HomeMobilePhone__c)
                || getPeriodSet(ssi.InvoiceDate__c, setType.ORIGINALMOBILE).keySet().contains(ssi.HomeMobilePhone__c)
                || getPeriodSet(ssi.InvoiceDate__c, setType.PHONE).keySet().contains(ssi.HomeMobilePhone__c)
                || getPeriodSet(ssi.InvoiceDate__c, setType.ORIGINALPHONE).keySet().contains(ssi.HomeMobilePhone__c))){
                //Determines whether this issue has the same contact information
                invalid(ssi, Rule_4);
                continue;
            }
            
            if(ssi.OfficePhone__c != null && ssi.OfficePhone__c.length() > 0 
                && (getPeriodSet(ssi.InvoiceDate__c, setType.MOBILE).keySet().contains(ssi.OfficePhone__c)
                || getPeriodSet(ssi.InvoiceDate__c, setType.ORIGINALMOBILE).keySet().contains(ssi.OfficePhone__c)
                || getPeriodSet(ssi.InvoiceDate__c, setType.PHONE).keySet().contains(ssi.OfficePhone__c)
                || getPeriodSet(ssi.InvoiceDate__c, setType.ORIGINALPHONE).keySet().contains(ssi.OfficePhone__c))){
                //Determines whether this issue has the same contact information
                invalid(ssi, Rule_4);
                continue;
            } 
            
            if(ssi.Original_HomeMobilePhone__c != null && ssi.Original_HomeMobilePhone__c.length() > 0 
                && (getPeriodSet(ssi.InvoiceDate__c, setType.MOBILE).keySet().contains(ssi.Original_HomeMobilePhone__c)
                || getPeriodSet(ssi.InvoiceDate__c, setType.PHONE).keySet().contains(ssi.Original_HomeMobilePhone__c))){
                //Determines whether this issue has the same contact information
                invalid(ssi, Rule_4);
                continue;
            }  
            
            if(ssi.OriginalOfficePhone__c != null && ssi.OriginalOfficePhone__c.length() > 0 
                && (getPeriodSet(ssi.InvoiceDate__c, setType.MOBILE).keySet().contains(ssi.OriginalOfficePhone__c)
                || getPeriodSet(ssi.InvoiceDate__c, setType.PHONE).keySet().contains(ssi.OriginalOfficePhone__c))){
                //Determines whether this issue has the same contact information
                invalid(ssi, Rule_4);
                continue;
            }     
            
            //rule 5: Government buyers
            if((ssi.CustomerName__c == null || ssi.CustomerName__c.length() == 0) 
              && (ssi.CompanyName__c == null || ssi.CompanyName__c.length() == 0)){
                invalid(ssi, 'Customer Name and Company Name does not exist');
                continue;
            } else if((ssi.CustomerName__c != null && ssi.CustomerName__c.length() > 4)) {
                Boolean isGov = false;
                for(String gv : GovVehicles){
                    if((ssi.CustomerName__c != null && ssi.CustomerName__c.indexOf(gv) >= 0)){
                        invalid(ssi, Rule_5);
                        isGov = true;
                        break;
                    }
                }
                if(isGov) {                       
                    continue;
                }
            }
            
            //rule 6: Dealer cars and two distributors purchase
            Boolean isDealer = false;
            if((ssi.CustomerName__c != null && ssi.CustomerName__c.length() > 4)) {
                for(String dv : DealervehiclesSubdealervehicles){
                    if(ssi.CustomerName__c != null && ssi.CustomerName__c.indexOf(dv) >= 0){
                        invalid(ssi, Rule_6);
                        isDealer = true;
                        break;
                    }
                }
            }
            for(String dv : DealervehiclesSubdealervehicles){
                if(ssi.CompanyName__c != null && ssi.CompanyName__c.indexOf(dv) >= 0) {
                    invalid(ssi, Rule_6);
                    isDealer = true;
                    break;
                }
            }
            if(isDealer){
                continue;
            }
            //Barney lai 2014-3-5 end
            
            //rule 7: Chassis number to repeat and have the same name
            //rule 8: Chassis number past repetitive and different names
            Date time1 = ssi.InvoiceDate__c.addMonths(-1);
            Date time2 = ssi.InvoiceDate__c.addMonths(-2);
            Date time3 = ssi.InvoiceDate__c.addMonths(-3);
            Map<String, SSI__c> vMap1 = getPeriodSet(time1, setType.VIN);
            Map<String, SSI__c> vMap2 = getPeriodSet(time2, setType.VIN);
            Map<String, SSI__c> vMap3 = getPeriodSet(time3, setType.VIN);

            if(vMap1.keySet().contains(ssi.VehicleUSvin__c)){
                SSI__c pssi = vMap1.get(ssi.VehicleUSvin__c);   
                if(ssi.CustomerName__c == pssi.CustomerName__c){
                    invalid(ssi, Rule_7);
                }else{
                    invalid(ssi, Rule_8);
                }               
                continue;
            }
            if(vMap2.keySet().contains(ssi.VehicleUSvin__c)){
                SSI__c pssi = vMap2.get(ssi.VehicleUSvin__c);   
                if(ssi.CustomerName__c == pssi.CustomerName__c){
                    invalid(ssi, Rule_7);
                }else{
                    invalid(ssi, Rule_8);
                }               
                continue;
            }
            if(vMap3.keySet().contains(ssi.VehicleUSvin__c)){
                SSI__c pssi = vMap3.get(ssi.VehicleUSvin__c);   
                if(ssi.CustomerName__c == pssi.CustomerName__c){
                    invalid(ssi, Rule_7);
                }else{
                    invalid(ssi, Rule_8);
                }               
                continue;
            }
            
            //rule 9: Contact to repeat and have the same name
            //rule 10: Contact past repetitive and different names
            Map<String, SSI__c> cmMap1 = getPeriodSet(time1, setType.MOBILE);
            Map<String, SSI__c> cmMap2 = getPeriodSet(time2, setType.MOBILE);
            Map<String, SSI__c> cmMap3 = getPeriodSet(time3, setType.MOBILE);
            if(cmMap1.keySet().contains(ssi.HomeMobilePhone__c)){
                SSI__c pssi = cmMap1.get(ssi.HomeMobilePhone__c);
                //Barney lai 2014-3-5 start   
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end    
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            if(cmMap2.keySet().contains(ssi.HomeMobilePhone__c)){
                SSI__c pssi = cmMap2.get(ssi.HomeMobilePhone__c); 
                //Barney lai 2014-3-5 start  
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end   
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            if(cmMap3.keySet().contains(ssi.HomeMobilePhone__c)){
                SSI__c pssi = cmMap3.get(ssi.HomeMobilePhone__c); 
                //Barney lai 2014-3-5 start  
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end   
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            
            //Barney lai 2014-3-5 start
            if(cmMap1.keySet().contains(ssi.OfficePhone__c)){
                SSI__c pssi = cmMap1.get(ssi.OfficePhone__c);
                //Barney lai 2014-3-5 start   
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end    
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            if(cmMap2.keySet().contains(ssi.OfficePhone__c)){
                SSI__c pssi = cmMap2.get(ssi.OfficePhone__c); 
                //Barney lai 2014-3-5 start  
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end   
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            if(cmMap3.keySet().contains(ssi.OfficePhone__c)){
                SSI__c pssi = cmMap3.get(ssi.OfficePhone__c); 
                //Barney lai 2014-3-5 start  
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end   
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            
            Map<String, SSI__c> cpMap1 = getPeriodSet(time1, setType.PHONE);
            Map<String, SSI__c> cpMap2 = getPeriodSet(time2, setType.PHONE);
            Map<String, SSI__c> cpMap3 = getPeriodSet(time3, setType.PHONE);
            
            if(cpMap1.keySet().contains(ssi.OfficePhone__c)){
                SSI__c pssi = cpMap1.get(ssi.OfficePhone__c);   
                //Barney lai 2014-3-5 start
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            if(cpMap2.keySet().contains(ssi.OfficePhone__c)){
                SSI__c pssi = cpMap2.get(ssi.OfficePhone__c);  
                //Barney lai 2014-3-5 start 
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end   
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            if(cpMap3.keySet().contains(ssi.OfficePhone__c)){
                SSI__c pssi = cpMap3.get(ssi.OfficePhone__c); 
                //Barney lai 2014-3-5 start  
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end   
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            
            if(cpMap1.keySet().contains(ssi.HomeMobilePhone__c)){
                SSI__c pssi = cpMap1.get(ssi.HomeMobilePhone__c);   
                //Barney lai 2014-3-5 start
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            if(cpMap2.keySet().contains(ssi.HomeMobilePhone__c)){
                SSI__c pssi = cpMap2.get(ssi.HomeMobilePhone__c);  
                //Barney lai 2014-3-5 start 
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end   
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            if(cpMap3.keySet().contains(ssi.HomeMobilePhone__c)){
                SSI__c pssi = cpMap3.get(ssi.HomeMobilePhone__c); 
                //Barney lai 2014-3-5 start  
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end   
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            
            Map<String, SSI__c> comMap1 = getPeriodSet(time1, setType.ORIGINALMOBILE);
            Map<String, SSI__c> comMap2 = getPeriodSet(time2, setType.ORIGINALMOBILE);
            Map<String, SSI__c> comMap3 = getPeriodSet(time3, setType.ORIGINALMOBILE);
            
            if(comMap1.keySet().contains(ssi.OfficePhone__c)){
                SSI__c pssi = comMap1.get(ssi.OfficePhone__c);   
                //Barney lai 2014-3-5 start
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            if(comMap2.keySet().contains(ssi.OfficePhone__c)){
                SSI__c pssi = comMap2.get(ssi.OfficePhone__c);  
                //Barney lai 2014-3-5 start 
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end   
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            if(comMap3.keySet().contains(ssi.OfficePhone__c)){
                SSI__c pssi = comMap3.get(ssi.OfficePhone__c); 
                //Barney lai 2014-3-5 start  
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end   
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            
            if(comMap1.keySet().contains(ssi.HomeMobilePhone__c)){
                SSI__c pssi = comMap1.get(ssi.HomeMobilePhone__c);   
                //Barney lai 2014-3-5 start
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            if(comMap2.keySet().contains(ssi.HomeMobilePhone__c)){
                SSI__c pssi = comMap2.get(ssi.HomeMobilePhone__c);  
                //Barney lai 2014-3-5 start 
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end   
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            if(comMap3.keySet().contains(ssi.HomeMobilePhone__c)){
                SSI__c pssi = comMap3.get(ssi.HomeMobilePhone__c); 
                //Barney lai 2014-3-5 start  
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end   
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            
            Map<String, SSI__c> copMap1 = getPeriodSet(time1, setType.ORIGINALPHONE);
            Map<String, SSI__c> copMap2 = getPeriodSet(time2, setType.ORIGINALPHONE);
            Map<String, SSI__c> copMap3 = getPeriodSet(time3, setType.ORIGINALPHONE);
            
            if(copMap1.keySet().contains(ssi.OfficePhone__c)){
                SSI__c pssi = copMap1.get(ssi.OfficePhone__c);   
                //Barney lai 2014-3-5 start
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            if(copMap2.keySet().contains(ssi.OfficePhone__c)){
                SSI__c pssi = copMap2.get(ssi.OfficePhone__c);  
                //Barney lai 2014-3-5 start 
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end   
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            if(copMap3.keySet().contains(ssi.OfficePhone__c)){
                SSI__c pssi = copMap3.get(ssi.OfficePhone__c); 
                //Barney lai 2014-3-5 start  
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end   
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            
            if(copMap1.keySet().contains(ssi.HomeMobilePhone__c)){
                SSI__c pssi = copMap1.get(ssi.HomeMobilePhone__c);   
                //Barney lai 2014-3-5 start
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            if(copMap2.keySet().contains(ssi.HomeMobilePhone__c)){
                SSI__c pssi = copMap2.get(ssi.HomeMobilePhone__c);  
                //Barney lai 2014-3-5 start 
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end   
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            if(copMap3.keySet().contains(ssi.HomeMobilePhone__c)){
                SSI__c pssi = copMap3.get(ssi.HomeMobilePhone__c); 
                //Barney lai 2014-3-5 start  
                if(ssi.CustomerName__c == pssi.CustomerName__c || ssi.OriginalCustomerName__c == pssi.OriginalCustomerName__c){
                //Barney lai 2014-3-5 end   
                    invalid(ssi, Rule_9);
                }else{
                    invalid(ssi, Rule_10);
                }               
                continue;
            }
            
            //Barney lai 2014-3-5 end
            // All rules pass
            ssi.Status__c = 'All Valid';

            // Save Map
            setSinglePeriodSet(ssi);
        }   
        
        if(scope.size()>0){
            update scope;
            currentScope = scope;
            successCount += scope.size();
        }

    }

    private void invalid(SSI__c ssi, String reason){
        ssi.Status__c = 'Invalid';
        ssi.Suspect_Reason__c = reason;
    }
    

    // To judge whether phone number is valid
    private Boolean isPhoneNumberValid(String phone){

        Boolean isValid = false;
        if (phone.length() == 11 && (
            phone.startsWith('13') ||
            phone.startsWith('14') ||
            phone.startsWith('15') ||
            phone.startsWith('18'))) {
            for (String  num: SerialPhoneNumbers) {
                if (phone.subString(2).contains(num)) {
                    isValid = false;
                    break;          
                }else{
                    isValid = true;
                }
            }
        }
        return isValid;
    }
 
    private String formatPhone (String phoneNumber) {
        if (phoneNumber != null) {
            phoneNumber = phoneNumber.removeStart('+86');
            phoneNumber = phoneNumber.removeStart('0086');
            if (phoneNumber.startsWith('86') && phoneNumber.length() >= 9) {
                phoneNumber = phoneNumber.removeStart('86');
            }
            phoneNumber = phoneNumber.replaceAll('[^0-9]', '');
            phoneNumber = phoneNumber.removeStart('0');
        }
        return phoneNumber;
    }
    
    global void finish(Database.BatchableContext bc) {

        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                           JobItemsProcessed, TotalJobItems, ApexClassId 
                    FROM AsyncApexJob
                    WHERE Id = :bc.getJobId()]; 
        
        if (job.TotalJobItems == 0 || job.Status == 'Aborted' || job.NumberOfErrors > 0) {

            AggregateResult[] totalCompletedJob = [
                SELECT SUM(TotalJobItems) totalItems  
                FROM AsyncApexJob
                Where ApexClassId =: job.ApexClassId And Createddate = TODAY And Status = 'Completed' And TotalJobItems > 0 And JobType='BatchApex' 
            ];

            Integer totalCompleted = 0;
            if (totalCompletedJob.size() > 0 && totalCompletedJob[0].get(totalItemsString) != null) {
                totalCompleted = totalCompletedJob.size() > 0 ? ((Decimal)totalCompletedJob[0].get(totalItemsString)).intValue() : 0;
            }            

            AggregateResult[] totalFailedJob = [
                SELECT SUM(NumberOfErrors) totalItems  
                FROM AsyncApexJob
                Where ApexClassId =: job.ApexClassId And Createddate = TODAY And Status = 'Completed'  And TotalJobItems > 0 And JobType='BatchApex' 
            ];

            Integer totalFailed = 0;
            if (totalFailedJob.size() > 0 && totalFailedJob[0].get(totalItemsString) != null) {
                totalFailed = totalFailedJob.size() > 0 ? ((Decimal)totalFailedJob[0].get(totalItemsString)).intValue() : 0;
            }         

            User currentUser = [Select Email From User Where Id = :UserInfo.getUserId()];
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {currentUser.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject('SSI Data Quality Cleansing Batch Status: Completed. ');
            mail.setPlainTextBody('The batch Apex job processed ' + (totalCompleted + totalFailed) +
                ' batches with '+ totalFailed + ' failures.');// \nTotal Records Updated: ' + totalCompleted*200);
            try {
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
            catch(Exception ex) {
                system.debug('Send SSI Data Quality Cleansing Batch Status Email Exception ::' + ex.getMessage());
            }
        } else {
            String dtString = Datetime.now().format('yyyy-MM-dd') + 'T' + Datetime.now().format('HH:mm:ss')+'.000Z';
            String calcStr = 
                'Select Id From SSI__c Where LastModifieddate >= YESTERDAY And LastModifieddate < ' + dtString + ' And LastModifiedById = \'' + UserInfo.getUserId() + '\' Order By LastModifieddate DESC LIMIT 100 ';
            //System.debug('----------calcStr---------->' + calcStr);
            SSIBatchCalculateResult  calcBatcher = new SSIBatchCalculateResult (calcStr);
            Database.executeBatch(calcBatcher, 100);

            String queryStr = 
                'Select VehicleUSvin__c, OfficePhone__c, InvoiceDate__c, HomeMobilePhone__c, HandoverDate__c, CustomerName__c, CompanyName__c, Invoice_Month__c, OriginalCustomerName__c, Original_HomeMobilePhone__c, OriginalOfficePhone__c '
                + 'From SSI__c Where Status__c = \'In Process\'' 
                + ' And (DealerCheck_Status__c = \'Valid\' Or DealerCheck_Status__c = \'Accept\') '
                + ' And (CarModelCheck_Status__c = \'Valid\' Or CarModelCheck_Status__c = \'Accept\') '
                + ' Order By  Invoice_Month__c ASC, InvoiceDate__c DESC LIMIT 100 ';
                    
            SSIBatchRestRuleCheck restRuleChecker = new SSIBatchRestRuleCheck(queryStr);

            Id batchId = Database.executeBatch(restRuleChecker, 100);        
        }


    }
}