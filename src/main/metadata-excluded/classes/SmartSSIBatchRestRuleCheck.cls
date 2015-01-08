/*
    Type:       Smart SSI rest rule cleansing (Data Quality Cleansing)
    Purpose:    Clean rest rule
    User Story: smart SSI
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Chris Created on 2014-03-14

*/
global class SmartSSIBatchRestRuleCheck implements Database.Batchable<SObject> { //, Database.Stateful  {
    
    private String query;
    
    private Integer successCount = 0;

    private List<smart_SSI__c> currentScope = new List<smart_SSI__c>();
    
    private final String Rule_1 = 'Time cannot match'; 
    private final String Rule_2 = 'Invalid contact';  
    private final String Rule_3 = 'Same VIN of current period';  
    private final String Rule_4 = 'Same contact information of current period';  
    private final String Rule_5 = 'Government vehicles';  
    private final String Rule_6 = 'Dealer vehicles & Sub-dealer vehicles';  
    private final String Rule_7 = 'Same VIN';  
    private final String Rule_8 = 'Same contact';   
    
    private enum setType {
        VIN,
        MOBILE,
        PHONE,
        ORIGINALMOBILE,
        ORIGINALPHONE
    }
    
    private String[] GovVehicles = new String[]{
        '厅', '政府', '委', '常委', '政治协商', '人大代表', '人大', '总政', '总装', 
        '司令部', '干休', '干休所', '交通局', '政协', '检察院', '检查院', '法院', 
        '军队', '军代处', '军代', '军区', '军分区', '交战办', '战办', '战备', '预备队', 
        '派出所', '武警', '警察', '警备', '警队', '警支队', '警', '监狱', '公安', '缉私', 
        '海关', '消防大队', '部队', '武装部', '总参', '边防支队', '刑侦支队', '劳教', '代表', 
        '边防', '海关', '组织部', '共和国', '物资储备', '国家安全'
    };
    
    private String[] DealervehiclesSubdealervehicles = new String[]{
        '汽车','之星','商品车','销售','租赁','经销商','试驾车','中转车','产品车','售前车','车业',
        '机动车','卡车','库存车','二级','轿车','出租','东星','北星','星徽','仁孚','中星','龙星','利星',
        '奔驰','通和','星翰','腾星','鹏星','航星','越星','瑞星','华星','斯玛特'
    };

    private String[] SerialPhoneNumbers = new String[]{
        '0000000','1111111','2222222','3333333','4444444','5555555','6666666',
        '7777777','8888888','9999999'
    };
    
    private Map<String, Map<String, smart_SSI__c>> VINSMAP = new Map<String, Map<String, smart_SSI__c>>();

    private Map<String, Map<String, smart_SSI__c>> MOBILEMAP = new Map<String, Map<String, smart_SSI__c>>();
    
    private Map<String, Map<String, smart_SSI__c>> PHONEMAP = new Map<String, Map<String, smart_SSI__c>>();
    private Map<String, Map<String, smart_SSI__c>> ORIGINALMOBILEMAP = new Map<String, Map<String, smart_SSI__c>>();
    private Map<String, Map<String, smart_SSI__c>> ORIGINALPHONEMAP = new Map<String, Map<String, smart_SSI__c>>();

    
    private void setPeriodSet (List<smart_SSI__c> scope) {

        Set<String> vinSet = new Set<String>();
        Set<String> mobileSet = new Set<String>();
        Set<String> phoneSet = new Set<String>();
        Set<String> originalmobileSet = new Set<String>();
        Set<String> originalphoneSet = new Set<String>();
 
        for (smart_SSI__c ssi : scope) {
            if (ssi.VehicleUSvin__c != null) {
                vinSet.add(ssi.VehicleUSvin__c);
            }           
            if (ssi.HomeMobilePhone__c != null) {
                String hphone = formatPhone(ssi.HomeMobilePhone__c);
                if (hphone != null) {
                    mobileSet.add(hphone);
                }                
            }
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
        }    

        // get start date
        AggregateResult[] sds = [
            SELECT MIN(InvoiceDate__c)startDate 
            FROM smart_SSI__c
            Where Id in :scope
        ];
        Date startDate = sds.size() > 0 ? (Date)sds[0].get('startDate') : null;

        // get end date
        AggregateResult[] eds = [
            SELECT MAX(InvoiceDate__c)endDate 
            FROM smart_SSI__c
            Where Id in :scope
        ];
        Date endDate = eds.size() > 0 ? (Date)eds[0].get('endDate') : null;

        if(startDate != null && endDate != null) {
            Date sd = startDate.toStartOfMonth().addMonths(-3);
            Date ed = endDate.toStartOfMonth().addMonths(1);

            for(List<smart_SSI__c> sList : [
                Select VehicleUSvin__c, CustomerName__c, HomeMobilePhone__c, OfficePhone__c, InvoiceDate__c,
                Original_HomeMobilePhone__c, OriginalOfficePhone__c, OriginalCustomerName__c
                From smart_SSI__c 
                Where Status__c In ('All Valid', 'Unmatched', 'Matched') 
                    And InvoiceDate__c >= :sd And InvoiceDate__c < :ed And VehicleUSvin__c != null 
                    And VehicleUSvin__c In :vinSet]){
                setSinglePeriodSet(sList);
            } // SOQL for USVin loop
            
           for(List<smart_SSI__c> sList : [
                Select VehicleUSvin__c, CustomerName__c, HomeMobilePhone__c, OfficePhone__c, InvoiceDate__c,
                Original_HomeMobilePhone__c, OriginalOfficePhone__c, OriginalCustomerName__c
                From smart_SSI__c 
                Where Status__c In ('All Valid', 'Unmatched', 'Matched') 
                    And InvoiceDate__c >= :sd And InvoiceDate__c < :ed And HomeMobilePhone__c != null 
                    And (HomeMobilePhone__c In :mobileSet OR HomeMobilePhone__c In :phoneSet 
                         OR HomeMobilePhone__c In :originalmobileSet OR HomeMobilePhone__c In :originalphoneSet)]){
                setSinglePeriodSet(sList);
            } // SOQL for HomeMobilePhone loop
            
           for(List<smart_SSI__c> sList : [
                Select VehicleUSvin__c, CustomerName__c, HomeMobilePhone__c, OfficePhone__c, InvoiceDate__c,
                Original_HomeMobilePhone__c, OriginalOfficePhone__c, OriginalCustomerName__c
                From smart_SSI__c 
                Where Status__c In ('All Valid', 'Unmatched', 'Matched') 
                    And InvoiceDate__c >= :sd And InvoiceDate__c < :ed And OfficePhone__c != null 
                    //Barney lai 2014-3-5 start
                    And (OfficePhone__c In :mobileSet OR OfficePhone__c In :phoneSet 
                         OR OfficePhone__c In :originalmobileSet OR OfficePhone__c In :originalphoneSet)]){
                    //Barney lai 2014-3-5 end
                setSinglePeriodSet(sList);
            } // SOQL for OfficePhone loop
            
            for(List<smart_SSI__c> sList : [
                Select VehicleUSvin__c, CustomerName__c, HomeMobilePhone__c, OfficePhone__c, InvoiceDate__c,
                Original_HomeMobilePhone__c, OriginalOfficePhone__c, OriginalCustomerName__c
                From smart_SSI__c 
                Where Status__c In ('All Valid', 'Unmatched', 'Matched') 
                    And InvoiceDate__c >= :sd And InvoiceDate__c < :ed And Original_HomeMobilePhone__c != null 
                    And (Original_HomeMobilePhone__c In :mobileSet OR Original_HomeMobilePhone__c In :phoneSet 
                         OR Original_HomeMobilePhone__c In :originalmobileSet OR Original_HomeMobilePhone__c In :originalphoneSet)]){
                setSinglePeriodSet(sList);
            } // SOQL for Original HomeMobilePhone loop
            
            for(List<smart_SSI__c> sList : [
                Select VehicleUSvin__c, CustomerName__c, HomeMobilePhone__c, OfficePhone__c, InvoiceDate__c,
                Original_HomeMobilePhone__c, OriginalOfficePhone__c, OriginalCustomerName__c
                From smart_SSI__c 
                Where Status__c In ('All Valid', 'Unmatched', 'Matched') 
                    And InvoiceDate__c >= :sd And InvoiceDate__c < :ed And OriginalOfficePhone__c != null 
                    And (OriginalOfficePhone__c In :mobileSet OR OriginalOfficePhone__c In :phoneSet 
                         OR OriginalOfficePhone__c In :originalmobileSet OR OriginalOfficePhone__c In :originalphoneSet)]){
                setSinglePeriodSet(sList);
            } // SOQL for Original OriginalOfficePhone loop
        } // date condition
    }

    private void setSinglePeriodSet (List<smart_SSI__c> ssis) {
        for (smart_SSI__c ssi : ssis) {
            String key = ssi.invoiceDate__c.year() + '-' + ssi.invoiceDate__c.month();

            if(!VINSMAP.containsKey(key)){
                VINSMAP.put(key, new Map<String, smart_SSI__c>());
            }
            if(ssi.VehicleUSvin__c != null && ssi.VehicleUSvin__c.length() > 0){
                VINSMAP.get(key).put(ssi.VehicleUSvin__c, ssi);
            }

            if(!MOBILEMAP.containsKey(key)){
                MOBILEMAP.put(key, new Map<String, smart_SSI__c>());
            }
            if(ssi.HomeMobilePhone__c != null && ssi.HomeMobilePhone__c.length() > 0){
                if(isPhoneNumberValid(ssi.HomeMobilePhone__c)){
                     MOBILEMAP.get(key).put(ssi.HomeMobilePhone__c, ssi);
                }           
            }
            if(!PHONEMAP.containsKey(key)){
                PHONEMAP.put(key, new Map<String, smart_SSI__c>());
            }
            if(ssi.OfficePhone__c != null && ssi.OfficePhone__c.length() > 0){
                if(isPhoneNumberValid(ssi.OfficePhone__c)){
                     PHONEMAP.get(key).put(ssi.OfficePhone__c, ssi);
                }           
            }
            
            if(!ORIGINALMOBILEMAP.containsKey(key)){
                ORIGINALMOBILEMAP.put(key, new Map<String, smart_SSI__c>());
            }
            if(ssi.Original_HomeMobilePhone__c != null && ssi.Original_HomeMobilePhone__c.length() > 0){
                if(isPhoneNumberValid(ssi.Original_HomeMobilePhone__c)){
                     ORIGINALMOBILEMAP.get(key).put(ssi.Original_HomeMobilePhone__c, ssi);
                }           
            }
            
            if(!ORIGINALPHONEMAP.containsKey(key)){
                ORIGINALPHONEMAP.put(key, new Map<String, smart_SSI__c>());
            }
            if(ssi.OriginalOfficePhone__c != null && ssi.OriginalOfficePhone__c.length() > 0){
                if(isPhoneNumberValid(ssi.OriginalOfficePhone__c)){
                     ORIGINALPHONEMAP.get(key).put(ssi.OriginalOfficePhone__c, ssi);
                }           
            }
        }
    }

    private void setSinglePeriodSet (smart_SSI__c ssi) {
        List<smart_SSI__c> ssis = new List<smart_SSI__c>();
        ssis.add(ssi);
        setSinglePeriodSet(ssis);
    }

    private Map<String, smart_SSI__c> getPeriodSet(Date invoiceDate, setType sType){
        Map<String, smart_SSI__c> checkMap = new Map<String, smart_SSI__c>();

        if(invoiceDate != null){

            String key = invoiceDate.year() + '-' + invoiceDate.month();  

            if(sType == setType.VIN && VINSMAP.containsKey(key)){
                checkMap = VINSMAP.get(key); 
            } else if(sType == setType.MOBILE && MOBILEMAP.containsKey(key)){
                checkMap = MOBILEMAP.get(key); 
            } else if(sType == setType.PHONE && PHONEMAP.containsKey(key)){
                checkMap = PHONEMAP.get(key); 
            } else if(sType == setType.ORIGINALMOBILE && ORIGINALMOBILEMAP.containsKey(key)){
                checkMap = ORIGINALMOBILEMAP.get(key); 
            } else if(sType == setType.ORIGINALPHONE && ORIGINALPHONEMAP.containsKey(key)){
                checkMap = ORIGINALPHONEMAP.get(key); 
            }
                    
        }
        return checkMap;
    }
    
    global SmartSSIBatchRestRuleCheck(String q) {
        this.query = q;       
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {

        system.debug('-----'+scope);
        setPeriodSet(scope);

        List<smart_SSI__c> externalUpdateList = new List<smart_SSI__c>();

        for(smart_SSI__c ssi : (List<smart_SSI__c>)scope){
            
            //rule 1: 时间不符
            
            if (ssi.HandoverDate__c == null && ssi.InvoiceDate__c != null) {

            } else if(ssi.InvoiceDate__c == null){
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

            //rule 2: 无效联系方式
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
            
            //rule 3: 底盘号本期相同
            //1. 本期内存在相同底盘号的All Valid记录，则本批所有同一底盘号的记录Invalid
            //2. 本期内不存在相同底盘号的All Valid记录，则：
            //a. 本批内底盘号相同发票日期也相同，取一条通过验证，其余Invalid
            //b. 本批内底盘号相同发票日期不同，取发票日期较早的通过验证，其余Invalid
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
            
            //rule 4: 与本期内联系方式相同
            // 如本期内或本批内存在相同的手机号或电话号，则Invalid
            //Barney lai 2014-3-5 start
            if(ssi.HomeMobilePhone__c!= null && ssi.HomeMobilePhone__c.length() > 0 
                && (getPeriodSet(ssi.InvoiceDate__c, setType.MOBILE).keySet().contains(ssi.HomeMobilePhone__c)
                || getPeriodSet(ssi.InvoiceDate__c, setType.ORIGINALMOBILE).keySet().contains(ssi.HomeMobilePhone__c)
                || getPeriodSet(ssi.InvoiceDate__c, setType.PHONE).keySet().contains(ssi.HomeMobilePhone__c)
                || getPeriodSet(ssi.InvoiceDate__c, setType.ORIGINALPHONE).keySet().contains(ssi.HomeMobilePhone__c))){
                //先判断本期是否有相同的联系方式
                invalid(ssi, Rule_4);
                continue;
            }
            
            if(ssi.OfficePhone__c != null && ssi.OfficePhone__c.length() > 0 
                && (getPeriodSet(ssi.InvoiceDate__c, setType.MOBILE).keySet().contains(ssi.OfficePhone__c)
                || getPeriodSet(ssi.InvoiceDate__c, setType.ORIGINALMOBILE).keySet().contains(ssi.OfficePhone__c)
                || getPeriodSet(ssi.InvoiceDate__c, setType.PHONE).keySet().contains(ssi.OfficePhone__c)
                || getPeriodSet(ssi.InvoiceDate__c, setType.ORIGINALPHONE).keySet().contains(ssi.OfficePhone__c))){
                //先判断本期是否有相同的联系方式
                invalid(ssi, Rule_4);
                continue;
            } 
            
            if(ssi.Original_HomeMobilePhone__c != null && ssi.Original_HomeMobilePhone__c.length() > 0 
                && (getPeriodSet(ssi.InvoiceDate__c, setType.MOBILE).keySet().contains(ssi.Original_HomeMobilePhone__c)
                || getPeriodSet(ssi.InvoiceDate__c, setType.PHONE).keySet().contains(ssi.Original_HomeMobilePhone__c))){
                //先判断本期是否有相同的联系方式
                invalid(ssi, Rule_4);
                continue;
            }  
            
            if(ssi.OriginalOfficePhone__c != null && ssi.OriginalOfficePhone__c.length() > 0 
                && (getPeriodSet(ssi.InvoiceDate__c, setType.MOBILE).keySet().contains(ssi.OriginalOfficePhone__c)
                || getPeriodSet(ssi.InvoiceDate__c, setType.PHONE).keySet().contains(ssi.OriginalOfficePhone__c))){
                //先判断本期是否有相同的联系方式
                invalid(ssi, Rule_4);
                continue;
            }     
            
            //rule 5: 政府购车
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
            
            //rule 6: 经销商购车&二级经销商购车
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
            
            //rule 7: 底盘号往期重复
            Date time1 = ssi.InvoiceDate__c.addMonths(-1);
            Date time2 = ssi.InvoiceDate__c.addMonths(-2);
            Date time3 = ssi.InvoiceDate__c.addMonths(-3);
            Map<String, smart_SSI__c> vMap1 = getPeriodSet(time1, setType.VIN);
            Map<String, smart_SSI__c> vMap2 = getPeriodSet(time2, setType.VIN);
            Map<String, smart_SSI__c> vMap3 = getPeriodSet(time3, setType.VIN);

            if(vMap1.keySet().contains(ssi.VehicleUSvin__c)){ 
                invalid(ssi, Rule_7);            
                continue;
            }
            if(vMap2.keySet().contains(ssi.VehicleUSvin__c)){
                invalid(ssi, Rule_7);          
                continue;
            }
            if(vMap3.keySet().contains(ssi.VehicleUSvin__c)){
                invalid(ssi, Rule_7);       
                continue;
            }
            
            //rule 8: 联系方式往期重复
            Map<String, smart_SSI__c> cmMap1 = getPeriodSet(time1, setType.MOBILE);
            Map<String, smart_SSI__c> cmMap2 = getPeriodSet(time2, setType.MOBILE);
            Map<String, smart_SSI__c> cmMap3 = getPeriodSet(time3, setType.MOBILE);
            
            if(cmMap1.keySet().contains(ssi.HomeMobilePhone__c)){   
                invalid(ssi, Rule_8);              
                continue;
            }
            if(cmMap2.keySet().contains(ssi.HomeMobilePhone__c)){
                invalid(ssi, Rule_8);             
                continue;
            }
            if(cmMap3.keySet().contains(ssi.HomeMobilePhone__c)){
                invalid(ssi, Rule_8);              
                continue;
            }
            
            if(cmMap1.keySet().contains(ssi.OfficePhone__c)){ 
                invalid(ssi, Rule_8);             
                continue;
            }
            if(cmMap2.keySet().contains(ssi.OfficePhone__c)){ 
                invalid(ssi, Rule_8);              
                continue;
            }
            if(cmMap3.keySet().contains(ssi.OfficePhone__c)){
                invalid(ssi, Rule_8);              
                continue;
            }
            
            Map<String, smart_SSI__c> cpMap1 = getPeriodSet(time1, setType.PHONE);
            Map<String, smart_SSI__c> cpMap2 = getPeriodSet(time2, setType.PHONE);
            Map<String, smart_SSI__c> cpMap3 = getPeriodSet(time3, setType.PHONE);
            
            if(cpMap1.keySet().contains(ssi.OfficePhone__c)){
                invalid(ssi, Rule_8);           
                continue;
            }
            if(cpMap2.keySet().contains(ssi.OfficePhone__c)){  
                invalid(ssi, Rule_8);          
                continue;
            }
            if(cpMap3.keySet().contains(ssi.OfficePhone__c)){
                invalid(ssi, Rule_8);            
                continue;
            }
            
            if(cpMap1.keySet().contains(ssi.HomeMobilePhone__c)){
                invalid(ssi, Rule_8);            
                continue;
            }
            if(cpMap2.keySet().contains(ssi.HomeMobilePhone__c)){ 
                invalid(ssi, Rule_8);              
                continue;
            }
            if(cpMap3.keySet().contains(ssi.HomeMobilePhone__c)){
                invalid(ssi, Rule_8);             
                continue;
            }
            
            Map<String, smart_SSI__c> comMap1 = getPeriodSet(time1, setType.ORIGINALMOBILE);
            Map<String, smart_SSI__c> comMap2 = getPeriodSet(time2, setType.ORIGINALMOBILE);
            Map<String, smart_SSI__c> comMap3 = getPeriodSet(time3, setType.ORIGINALMOBILE);
            
            if(comMap1.keySet().contains(ssi.OfficePhone__c)){
                invalid(ssi, Rule_8);             
                continue;
            }
            if(comMap2.keySet().contains(ssi.OfficePhone__c)){  
                invalid(ssi, Rule_8);            
                continue;
            }
            if(comMap3.keySet().contains(ssi.OfficePhone__c)){
                invalid(ssi, Rule_8);               
                continue;
            }
            
            if(comMap1.keySet().contains(ssi.HomeMobilePhone__c)){
                invalid(ssi, Rule_8);               
                continue;
            }
            if(comMap2.keySet().contains(ssi.HomeMobilePhone__c)){
                invalid(ssi, Rule_8);               
                continue;
            }
            if(comMap3.keySet().contains(ssi.HomeMobilePhone__c)){
                invalid(ssi, Rule_8);                
                continue;
            }
            
            Map<String, smart_SSI__c> copMap1 = getPeriodSet(time1, setType.ORIGINALPHONE);
            Map<String, smart_SSI__c> copMap2 = getPeriodSet(time2, setType.ORIGINALPHONE);
            Map<String, smart_SSI__c> copMap3 = getPeriodSet(time3, setType.ORIGINALPHONE);
            
            if(copMap1.keySet().contains(ssi.OfficePhone__c)){
                invalid(ssi, Rule_8);               
                continue;
            }
            if(copMap2.keySet().contains(ssi.OfficePhone__c)){
                invalid(ssi, Rule_8);                
                continue;
            }
            if(copMap3.keySet().contains(ssi.OfficePhone__c)){
                invalid(ssi, Rule_8);               
                continue;
            }
            
            if(copMap1.keySet().contains(ssi.HomeMobilePhone__c)){
                invalid(ssi, Rule_8);                
                continue;
            }
            if(copMap2.keySet().contains(ssi.HomeMobilePhone__c)){
                invalid(ssi, Rule_8);                
                continue;
            }
            if(copMap3.keySet().contains(ssi.HomeMobilePhone__c)){
                invalid(ssi, Rule_8);               
                continue;
            }
            
            
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

    private void invalid(smart_SSI__c ssi, String reason){
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
            if (totalCompletedJob.size() > 0 && totalCompletedJob[0].get('totalItems') != null) {
                totalCompleted = totalCompletedJob.size() > 0 ? ((Decimal)totalCompletedJob[0].get('totalItems')).intValue() : 0;
            }            

            AggregateResult[] totalFailedJob = [
                SELECT SUM(NumberOfErrors) totalItems  
                FROM AsyncApexJob
                Where ApexClassId =: job.ApexClassId And Createddate = TODAY And Status = 'Completed'  And TotalJobItems > 0 And JobType='BatchApex' 
            ];

            Integer totalFailed = 0;
            if (totalFailedJob.size() > 0 && totalFailedJob[0].get('totalItems') != null) {
                totalFailed = totalFailedJob.size() > 0 ? ((Decimal)totalFailedJob[0].get('totalItems')).intValue() : 0;
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
                'Select Id From smart_SSI__c Where LastModifieddate >= YESTERDAY And LastModifieddate < ' + dtString + ' And LastModifiedById = \'' + UserInfo.getUserId() + '\' Order By LastModifieddate DESC LIMIT 100 ';
            //System.debug('----------calcStr---------->' + calcStr);
            smartSSIBatchCalculateResult  calcBatcher = new smartSSIBatchCalculateResult (calcStr);
            Database.executeBatch(calcBatcher, 100);

            String queryStr = 
                'Select VehicleUSvin__c, OfficePhone__c, InvoiceDate__c, HomeMobilePhone__c, HandoverDate__c, CustomerName__c, CompanyName__c, Invoice_Month__c, OriginalCustomerName__c, Original_HomeMobilePhone__c, OriginalOfficePhone__c '
                + 'From smart_SSI__c Where Status__c = \'In Process\'' 
                + ' And (DealerCheck_Status__c = \'Valid\' Or DealerCheck_Status__c = \'Accept\') '
                + ' And (CarModelCheck_Status__c = \'Valid\' Or CarModelCheck_Status__c = \'Accept\') '
                + ' Order By  Invoice_Month__c ASC, InvoiceDate__c DESC LIMIT 100 ';
                    
            smartSSIBatchRestRuleCheck restRuleChecker = new smartSSIBatchRestRuleCheck(queryStr);

            Id batchId = Database.executeBatch(restRuleChecker, 100);        
        }


    }
}