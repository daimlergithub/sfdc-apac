/*
    Type:       Campaign Calendar Controller
    Purpose:    Query User and Campaign Information shown on Calendar
    User Story: US-Cpn-012 - CAS Marketing Campaign sharing

    Used By:    Campaign_Timeline （VF)
    ---------------------------------------------------------------
    History:

    23-May-2013 Stephano.shi (Breakingpoint)    Created
    Patrick Zhang updated on 2013-09-30

*/
public class CPCalController {
    private static String whereString='Where ';
    private static String andString='AND';
    private static String blank='';
    private static String minusOne='-1';
    private static String minusTwelve='-12';
    private static String minusThirtyOne='-31';
    private static String all='All';
    private static String parentId='ParentId=:partId AND ';
    private static String recordTypeString='RecordTypeId = :cmcpId';
    
    
 
    
    /* Public Properties */
    String userLan;        // Current User Language
    List<Campaign> theCamps;      // Campaign
    public Id partId;   //ParentId
    
    /* Construction */
    void cpCalController(){
        PageReference pageRef = ApexPages.currentPage();
        // Get Campaign Partner Id From URL.
        partId = pageRef.getParameters().get('ParentId');   
        // Current Login User Language.
        userLan = getUserLan();
    }

    /* Get Current Login User Information */
    public String getUserLan() {
        // Current Login User Language.
        return UserInfo.getLanguage();
    }
    
    /* Get all campaign information */
    @RemoteAction
    public static List<Campaign> queAllCamps(String currYear, String endYear, String partId, String cat, String tp, String cct) {
        List<Campaign> theCamps = new List<Campaign>();
        // CAC Campaign
        theCamps = queCACCamps(currYear,endYear,partId,cat);
        // Central Marketing Campaign
        theCamps.addAll(queCentralCamps(currYear,endYear,partId, cat, tp));
        // CAS Marketing Campaign
        theCamps.addAll(queCASCamps(currYear,endYear,partId, tp));
        // CAC CRM Campaign
        theCamps.addAll(queCACCrmCamps(currYear,endYear,partId, cct));
        // Execution Campaign & Parent Campaign
        theCamps.addAll(queCACExeCamps(partId));

        return theCamps;
    }
    
    /* Get Central Campaign Information */
    @RemoteAction
    public static List<Campaign> queCentralCamps(String currYear, String endYear, String partId, String cat, String tp) {
        // Campaign Record Type Collection
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Campaign.getRecordTypeInfosByName();
        // Get Central Maketing Campaign Record Type ID
        Id cmcpId = cpRecordTypeMap.get('Central Marketing Campaign').getRecordTypeId();
        // Default filter date
        Date cuDate = system.today();
        Date enDate = system.today();
        // query str variable
        String selSTR = 'Select id, Name, Type, Status, StartDate, EndDate, IsActive, CAC_Frequency_Category__c, Repeat_Frequency__c From Campaign ';
        String whrSTR = whereString;
        String whrAND = andString;
        String whrCurD = blank;
        String whrEndD = blank;
        String whrParId = blank;
        String whrCat = blank;
        String whrTp = blank;
        String whrStatus = 'Cancelled';
        String whrRecTpId = 'RecordTypeId = :cmcpId AND Status <> :whrStatus';
               
        // Campaign Collection
        List<Campaign> theCamps = new List<Campaign>();
        
        // where condition combination
        if (currYear != null && String.isNotBlank(currYear)){
            cuDate = date.valueOf(currYear+minusOne+minusOne);
            whrCurD = 'StartDate != Null AND StartDate >= :cuDate AND ';
        }
        if (endYear != null && String.isNotBlank(endYear)){
            enDate = date.valueOf(endYear+minusTwelve+minusThirtyOne);
            whrEndD = 'EndDate != Null AND EndDate <= :enDate AND ';
        }
        if (partId != null && String.isNotBlank(partId)){
            whrParId = parentId;
        }
        
        if(String.isNotBlank(cat) && cat != all){

            whrCat = 'CAC_Frequency_Category__c=:cat AND ';
        }
        if(String.isNotBlank(tp) && tp != all){
            whrTp = 'Type=:tp AND ';
        }        
        
        whrSTR = whrSTR + whrCurD + whrEndD + whrParId +  whrTp + whrRecTpId;
        system.debug('whrSTR>>>'+whrSTR);
        system.debug('tp>>>'+tp);
        theCamps = Database.query(selSTR + whrSTR);

        return theCamps;
    }
    
    /* Get CAS Marketing Campaign Information */
    @RemoteAction
    public static List<Campaign> queCASCamps(String currYear, String endYear, String partId, String tp) {
        // Campaign Record Type Collection
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Campaign.getRecordTypeInfosByName();
        // Get Central Maketing Campaign Record Type ID
        Id cmcpId = cpRecordTypeMap.get('CAS Marketing Campaign').getRecordTypeId();
        // Default filter date
        Date cuDate = system.today();
        Date enDate = system.today();
        // query str variable
        String selSTR = 'Select id, Name, Type, Status, StartDate, EndDate, IsActive  From Campaign ';
        String whrSTR = whereString;
        String whrAND = andString;
        String whrCurD = blank;
        String whrEndD = blank;
        String whrParId = blank;
        String whrTp = blank;
        String whrStatus = 'Cancelled';
        String whrRecTpId = 'RecordTypeId = :cmcpId AND Status <> :whrStatus';
        
        // Campaign Collection
        List<Campaign> theCamps = new List<Campaign>();
        
        // where condition combination
        if (currYear != null && String.isNotBlank(currYear)){
            cuDate = date.valueOf(currYear+minusOne+minusOne);
            whrCurD = 'StartDate != Null AND StartDate >= :cuDate AND ';
        }
        if (endYear != null && String.isNotBlank(endYear)){
            enDate = date.valueOf(endYear+minusTwelve+minusThirtyOne);
            whrEndD = 'EndDate != Null AND EndDate <= :enDate AND ';
        }
        if (partId != null && String.isNotBlank(partId)){
            whrParId = parentId;
        }
        if(String.isNotBlank(tp) && tp != all){
            whrTp = 'Type=:tp AND ';
        } 

        whrSTR = whrSTR + whrCurD + whrEndD + whrParId + whrTp + whrRecTpId;
        system.debug(whrSTR);
        theCamps = Database.query(selSTR + whrSTR);

        return theCamps;
    }
    
    /* Get CAC CRM Campaign Information */
    @RemoteAction
    public static List<Campaign> queCACCrmCamps(String currYear, String endYear, String partId, String cct) {
        // Campaign Record Type Collection
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Campaign.getRecordTypeInfosByName();
        // Get Central Maketing Campaign Record Type ID
        Id cmcpId = cpRecordTypeMap.get('CAC CRM Campaign').getRecordTypeId();
        // Default filter date
        Date cuDate = system.today();
        Date enDate = system.today();
        // query str variable
        String selSTR = 'Select id, Name, Type, Status, CAC_Campaign_Type__c, StartDate, EndDate, IsActive  From Campaign ';
        String whrSTR = whereString;
        String whrAND = andString;
        String whrCurD = blank;
        String whrEndD = blank;
        String whrParId = blank;
        String whrCCT = blank;
        String whrRecTpId = recordTypeString;
        
        // Campaign Collection
        List<Campaign> theCamps = new List<Campaign>();
        
        // where condition combination
        if (currYear != null && String.isNotBlank(currYear)){
            cuDate = date.valueOf(currYear+minusOne+minusOne);
            whrCurD = 'StartDate != Null AND StartDate >= :cuDate AND ';
        }
        if (endYear != null && String.isNotBlank(endYear)){
            enDate = date.valueOf(endYear+minusTwelve+minusThirtyOne);
            whrEndD = 'EndDate != Null AND EndDate <= :enDate AND ';
        }
        if (partId != null && String.isNotBlank(partId)){
            whrParId = parentId;
        }
        // Patrick begins here
        if (cct != null && String.isNotBlank(cct) && cct != all){
            whrCCT = 'CAC_Campaign_Type__c= :cct AND ';
        }
        // To here

        whrRecTpId = recordTypeString;
        whrSTR = whrSTR + whrCurD + whrEndD + whrParId + whrCCT + whrRecTpId;
        system.debug(whrSTR);
        theCamps = Database.query(selSTR + whrSTR);

        return theCamps;
    }
    
    /* Get CAC Campaign Information */
    @RemoteAction
    public static List<Campaign> queCACCamps(String currYear, String endYear, String partId, String cat) {
        // Campaign Record Type Collection
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Campaign.getRecordTypeInfosByName();
        // Get Central Maketing Campaign Record Type ID
        Id cmcpId = cpRecordTypeMap.get('CAC Campaign').getRecordTypeId();  //CAC Campaign Record Type Id
        Integer daysBetween = 0;    // Day Diff 
        Integer monthsBetween = 0;  // Month Diff
        Integer yearsBetween = 0;   // Year Diff
        long weeksBetween = 0;  // Week Diff

        List<Campaign> addCamps = new List<Campaign>(); // sub campaigns for recurring campaign
        Date startDate; // sub campaign start date
        Date endDate;   // sub campaign end date
        
        Integer cnt = 0;    // CAC Campaign list index
        List<Integer> cntList = new List<Integer>();    // recurring campaign index of list
        
        // Default filter date
        Date cuDate = system.today();
        Date enDate = system.today();
        // query str variable
        String selSTR = 'Select id, Name, Repeated_Campaign__c,Repeat_Frequency__c, Repeat_From__c, Repeat_End__c, IsActive, CAC_Frequency_Category__c From Campaign ';
        String whrSTR = whereString;
        String whrAND = andString;
        String whrCurD = blank;
        String whrEndD = blank;
        String whrParId = blank;
        String whrCat = blank;
        String whrRecTpId = recordTypeString;
        
        // Campaign Collection
        List<Campaign> theCamps = new List<Campaign>();
        
        // where condition combination
        if (currYear != null && String.isNotBlank(currYear)){
            cuDate = date.valueOf(currYear+minusOne+minusOne);
            whrCurD = 'Repeat_From__c != Null AND Repeat_From__c >= :cuDate AND ';
        }
        if (endYear != null && String.isNotBlank(endYear)){
            enDate = date.valueOf(endYear+minusTwelve+minusThirtyOne);
            whrEndD = 'Repeat_End__c != Null AND Repeat_End__c <= :enDate AND ';
        }
        if (partId != null && String.isNotBlank(partId)){
            whrParId = parentId;
        }
        
        if (String.isNotBlank(cat) && cat != all){
            whrCat = 'CAC_Frequency_Category__c=:cat AND ';
        }
        
        whrRecTpId = recordTypeString;
        whrSTR = whrSTR + whrCurD + whrEndD + whrParId + whrCat + whrRecTpId;
        system.debug(selSTR + whrSTR);
        theCamps = Database.query(selSTR + whrSTR);
        
        /* START CAC Campaigns Hand Block */
        for(Campaign cmp:theCamps) {
            
            // Repeat_From__c Null Value
            if(cmp.Repeat_From__c != null){
                cmp.StartDate = cmp.Repeat_From__c.date();
                if(cmp.Repeat_End__c == null) {
                    System.debug('Camp1>>>'+cmp.Name);
                    cmp.EndDate = cmp.Repeat_From__c.date();
                } else {
                    cmp.EndDate = cmp.Repeat_End__c.date();
                }
            } else {
                cntList.add(cnt);
                cnt ++;
                break;
            }
            /*
            if(cmp.Repeated_Campaign__c){
            // recurring Campaign   
                // repeat type is daily
                if(cmp.Repeat_Frequency__c == 'Daily'){
                    // calculate days diff from start to end.
                    daysBetween = cmp.Repeat_From__c.date().daysBetween(cmp.Repeat_End__c.date());
                    // inital the sub campaign start day .
                    startDate = cmp.Repeat_From__c.date();
                    
                    // generate sub campaign for each day diff.
                    for(integer i=0; i<daysBetween+1; i++){
                        addCamps.add(new Campaign(Name = cmp.Name, 
                                                  StartDate = startDate,
                                                  EndDate = startDate,                                                    
                                                  Repeat_From__c = startDate,
                                                  Repeat_End__c = startDate,
                                                  Id = cmp.Id,
                                                  CAC_Frequency_Category__c = cmp.CAC_Frequency_Category__c
                                                 ));
                        // the next sub campaign start day.
                        startDate = startDate.addDays(1);
                    }
                    // add recurring campaign index of cac campaign list   
                    cntList.add(cnt);
                    System.debug('addCampsDaily>>>' + addCamps);
                // repeat type is weekly        
                } else if(cmp.Repeat_Frequency__c == 'Weekly'){
                    // calculate weeks diff from start to end.
                    //weeksBetween = (cmp.Repeat_From__c.getTime() - cmp.Repeat_End__c.getTime())/1000/3600/24/7;
                    weeksBetween = cmp.Repeat_From__c.date().toStartOfWeek().daysBetween(cmp.Repeat_End__c.date().toStartOfWeek().addDays(7))/7;
                    System.debug('weeksBetween>>>' + weeksBetween);
                    // inital sub campaign start date
                    startDate = cmp.Repeat_From__c.date();
                    endDate = (startDate.toStartOfWeek().addDays(6) <= cmp.Repeat_End__c.date())? startDate.toStartOfWeek().addDays(6) : cmp.Repeat_End__c.date();
                    System.debug('endDate >>> '+ endDate);
                    // generate sub campaign for each week diff.
                    for(integer i=0; i<weeksBetween; i++){
                        addCamps.add(new Campaign(Name = cmp.Name, 
                                                  StartDate = startDate,
                                                  EndDate = endDate,                                                  
                                                  Repeat_From__c = startDate,
                                                  Repeat_End__c = endDate,
                                                  Id = cmp.Id,
                                                  CAC_Frequency_Category__c = cmp.CAC_Frequency_Category__c
                                                 ));
                        // the next sub campaign start day.
                        startDate = startDate.toStartOfWeek().addDays(7);
                        endDate = (startDate.addDays(6) <= cmp.Repeat_End__c.date())? startDate.addDays(6) : cmp.Repeat_End__c.date();
                    }
                    
                    // add recurring campaign index of cac campaign list
                    cntList.add(cnt);
                    System.debug('addCampsWeekly>>>' + addCamps);
                } else if(cmp.Repeat_Frequency__c == 'Bi-Weekly'){
                
                } else if(cmp.Repeat_Frequency__c == 'Monthly'){
                    monthsBetween = cmp.Repeat_From__c.date().monthsBetween(cmp.Repeat_End__c.date()) + 1;
                    // inital the sub campaign start day .
                    startDate = cmp.Repeat_From__c.date();
                    endDate = ((startDate.toStartOfMonth().addMonths(1) -1) >= cmp.Repeat_End__c.date())?cmp.Repeat_End__c.date():(startDate.toStartOfMonth().addMonths(1) -1);
                    // generate sub campaign for each day diff.
                    for(integer i=0; i<monthsBetween; i++){
                        addCamps.add(new Campaign(Name = cmp.Name, 
                                                  StartDate = startDate,
                                                  EndDate = endDate,                                                    
                                                  Repeat_From__c = startDate,
                                                  Repeat_End__c = endDate,
                                                  Id = cmp.Id,
                                                  CAC_Frequency_Category__c = cmp.CAC_Frequency_Category__c
                                                 ));
                        // the next sub campaign start day.
                        startDate = startDate.addMonths(1).toStartOfMonth();
                        endDate = ((startDate.toStartOfMonth().addMonths(1) -1) >= cmp.Repeat_End__c.date())?cmp.Repeat_End__c.date():(startDate.toStartOfMonth().addMonths(1) -1);
                    }
                    // add recurring campaign index of cac campaign list   
                    cntList.add(cnt);
                    System.debug('addCampsMonthly>>>' + addCamps); 
                } else if(cmp.Repeat_Frequency__c == 'Quarterly'){
                    
                    
                } else if(cmp.Repeat_Frequency__c == 'Yearly'){
                    yearsBetween = cmp.Repeat_End__c.year() - cmp.Repeat_From__c.year() + 1;
                    System.debug('yearsBetween>>>' + yearsBetween);
                    startDate = cmp.Repeat_From__c.date();
                    endDate = (date.newinstance(startDate.year(),12,31) >= cmp.Repeat_End__c.Date()) ? cmp.Repeat_End__c.Date() : date.newinstance(startDate.year(),12,31);
                     for(integer i=0; i<yearsBetween; i++){
                        addCamps.add(new Campaign(Name = cmp.Name, 
                                                  StartDate = startDate,
                                                  EndDate = endDate,                                                    
                                                  Repeat_From__c = startDate,
                                                  Repeat_End__c = endDate,
                                                  Id = cmp.Id,
                                                  CAC_Frequency_Category__c = cmp.CAC_Frequency_Category__c
                                                 ));
                        // the next sub campaign start day.
                        startDate = date.newinstance(startDate.year() + 1,1,1);
                        endDate = (date.newinstance(startDate.year(),12,31) >= cmp.Repeat_End__c.Date()) ? cmp.Repeat_End__c.Date() : date.newinstance(startDate.year(),12,31);             
                     }
                    // add recurring campaign index of cac campaign list   
                    cntList.add(cnt);
                    System.debug('addCampsYearly>>>' + addCamps); 
                }
            }*/
            cnt++;
        }
        //theCamps.addAll(addCamps);
        System.debug('theCamps>>>' + theCamps);
        for(Integer x : cntList){
            //theCamps.remove(x);
            System.debug('Camps>>>' + theCamps.get(x));
            theCamps.set(x,null);           
        }
        return theCamps;
    }
    
    /* Get CAC Execution Campaign Information */
    @RemoteAction
    public static List<Campaign> queCACExeCamps(String partId) {
        // Campaign Record Type Collection
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Campaign.getRecordTypeInfosByName();
        
        // CAC Campaign Record Type Id
        Id cmcpId = cpRecordTypeMap.get('CAC Campaign').getRecordTypeId();
        
        // Get CAC Execution Campaign Record Type Id
        List<Id> cmcpExeIds = new List<Id>();
        cmcpExeIds.add(cpRecordTypeMap.get('Campaign Execution - Complex').getRecordTypeId());
        cmcpExeIds.add(cpRecordTypeMap.get('Campaign Execution - Simple').getRecordTypeId());
        
        // Default filter date
        Date cuDate = system.today();
        Date enDate = system.today();
                
        // query str variable
        String selSTR = 'Select id, Name, Repeated_Campaign__c,Repeat_Frequency__c, Repeat_From__c, Repeat_End__c, IsActive, CAC_Frequency_Category__c, Index__c From Campaign ';
        String whrSTR = whereString;
        String whrSTR_CAC = whereString;   // Parnter CAC Campaign WHERE condition
        String whrAND = andString;
        String whrCurD = blank;
        String whrEndD = blank;
        String whrParId = blank;
        String whrId = blank;
        String whrRecTpId = 'RecordTypeId in :cmcpExeIds ';
        String whrRecTpId_CAC = recordTypeString;
        String whrSort = 'Order By Index__c DESC';
        
        // Campaign Collection
        List<Campaign> theCamps = new List<Campaign>(); // whole campaign displayed
        List<Campaign> cacCampaigns = new List<Campaign>(); // partner campaign for cac
        
        // campaign id for partner of exection & id of cac
        if (partId != null && String.isNotBlank(partId)){
            whrParId = parentId;
            whrId = 'Id=:partId AND ';
        }
        
        // where condition
        whrSTR_CAC = whrSTR_CAC + whrId + whrRecTpId_CAC;
        whrSTR = whrSTR + whrParId + whrRecTpId;
        
        system.debug('CAC >>>: ' + selSTR + whrSTR_CAC);
        system.debug('EXE >>>: ' + selSTR + whrSTR);
        
        // campaign query execution.
        cacCampaigns = Database.query(selSTR + whrSTR_CAC);
        theCamps = Database.query(selSTR + whrSTR + whrSort);
        
        // duration setup.
        if(cacCampaigns.size() > 0 && theCamps.size() > 0) {
            Date fromDate = cacCampaigns[0].Repeat_From__c == null ? null : cacCampaigns[0].Repeat_From__c.Date();
            Date endDate = cacCampaigns[0].Repeat_End__c == null ? null : cacCampaigns[0].Repeat_End__c.Date();
            cacCampaigns[0].StartDate = fromDate;
            cacCampaigns[0].EndDate = endDate;
            
            for(Campaign cmp:theCamps) {
                cmp.Name = '└ [' + cmp.Index__c + '] ' + cmp.Name;
                cmp.StartDate = fromDate;
                cmp.EndDate = endDate;
            }
            
            theCamps.add(cacCampaigns[0]);
        }

        return theCamps;
        
    }
}