public with sharing class YearlyTAAchieTracingController {

    private static String total='Total';
    private static String east='EAST';
    private static String west='WEST';
    private static String north='NORTH';
    private static String south='SOUTH';
    
    
    public List<expense> data { get; set; }
    public transient List<Retail_Campaign__c> campaigns { get; set; }
    public String currentYear = String.valueOf(Date.today().year());
    public transient List<marketTarget> JanTarget { get; set; }
    public transient List<marketTarget> FebTarget { get; set; }
    public transient List<marketTarget> MarTarget { get; set; }
    public transient List<marketTarget> AprTarget { get; set; }
    public transient List<marketTarget> MayTarget { get; set; }
    public transient List<marketTarget> JunTarget { get; set; }
    public transient List<marketTarget> JulTarget { get; set; }
    public transient List<marketTarget> AugTarget { get; set; }
    public transient List<marketTarget> SepTarget { get; set; }
    public transient List<marketTarget> OctTarget { get; set; }
    public transient List<marketTarget> NovTarget { get; set; }
    public transient List<marketTarget> DecTarget { get; set; }
    public transient List<marketTarget> TotalTarget { get; set; }
    
    public List<YearlyMarketTarget> TotalYearlyMarketTarget { get; set; }
    public List<YearlyMarketTarget> TotalYearlyJointMarketTarget { get; set; }
    public List<YearlyMarketTarget> TotalYearlyDrivenMarketTarget { get; set; }
    public Integer ChatHeigth { get; set; }
    
    public YearlyTAAchieTracingController() {
        
        Date startDate = Date.newInstance(Date.Today().year(), 1, 1);
        Date endDate = Date.newInstance(Date.Today().year(), 12, 31);
        Map<Id, String> DealerIdDealerName = new Map<Id, String>();
        Map<Id, Decimal> DealerIdExpense = new Map<Id, Decimal>();
        Map<Id, Decimal> DealerIdYearlyTA = new Map<Id, Decimal>();
        Set<Id> YearlyTAIds = new Set<Id>();
        Map<Id, Decimal> DealerIdMediaJointExpense = new Map<Id, Decimal>();
        Map<Id, Decimal> DealerIdMediaDrivenExpense = new Map<Id, Decimal>();
        Map<Id, Decimal> DealerIdEventJointExpense = new Map<Id, Decimal>();
        Map<Id, Decimal> DealerIdEventDrivenExpense = new Map<Id, Decimal>();
        
        for(Retail_Campaign__c rt : [select Id, RecordType.Name, Dealer_Name__c, Dealer_Name__r.Name, Dealer_Name__r.Branch_name__c, Driven__c, Actual_Expense__c from Retail_Campaign__c 
                                     where (RecordType.Name = 'S&M Event Retail Campaign' or RecordType.Name = 'S&M Media Retail Campaign') and (Driven__c = 'Joint' or Driven__c = 'Dealer Driven') and 
                                      Feedback_Status__c = 'Approved' and Actual_Start_Date__c >= :startDate and Dealer_Name__c != null]) {
            if(rt.Dealer_Name__c != null) {
                DealerIdDealerName.put(rt.Dealer_Name__c, rt.Dealer_Name__r.Name);
                if(!String.isBlank(rt.Dealer_Name__r.Branch_name__c)) {
                    DealerIdDealerName.put(rt.Dealer_Name__c,  rt.Dealer_Name__r.Name + ' - ' + rt.Dealer_Name__r.Branch_name__c);
                }
                
                if(rt.Actual_Expense__c > 0) {
                    if(!DealerIdExpense.containsKey(rt.Dealer_Name__c)) {
                        DealerIdExpense.put(rt.Dealer_Name__c, 0);
                    }
                    DealerIdExpense.put(rt.Dealer_Name__c, DealerIdExpense.get(rt.Dealer_Name__c) + rt.Actual_Expense__c);
                    
                    if(rt.RecordType.Name == 'S&M Media Retail Campaign' && rt.Driven__c == 'Joint') {
                        if(!DealerIdMediaJointExpense.containsKey(rt.Dealer_Name__c)) {
                            DealerIdMediaJointExpense.put(rt.Dealer_Name__c, 0);
                        }
                        DealerIdMediaJointExpense.put(rt.Dealer_Name__c, DealerIdMediaJointExpense.get(rt.Dealer_Name__c) + rt.Actual_Expense__c);
                    }
                    if(rt.RecordType.Name == 'S&M Media Retail Campaign' && rt.Driven__c == 'Dealer Driven') {
                        if(!DealerIdMediaDrivenExpense.containsKey(rt.Dealer_Name__c)) {
                            DealerIdMediaDrivenExpense.put(rt.Dealer_Name__c, 0);
                        }
                        DealerIdMediaDrivenExpense.put(rt.Dealer_Name__c, DealerIdMediaDrivenExpense.get(rt.Dealer_Name__c) + rt.Actual_Expense__c);
                    }
                    if(rt.RecordType.Name == 'S&M Event Retail Campaign' && rt.Driven__c == 'Joint') {
                        if(!DealerIdEventJointExpense.containsKey(rt.Dealer_Name__c)) {
                            DealerIdEventJointExpense.put(rt.Dealer_Name__c, 0);
                        }
                        DealerIdEventJointExpense.put(rt.Dealer_Name__c, DealerIdEventJointExpense.get(rt.Dealer_Name__c) + rt.Actual_Expense__c);
                    }
                    if(rt.RecordType.Name == 'S&M Event Retail Campaign' && rt.Driven__c == 'Dealer Driven') {
                        if(!DealerIdEventDrivenExpense.containsKey(rt.Dealer_Name__c)) {
                            DealerIdEventDrivenExpense.put(rt.Dealer_Name__c, 0);
                        }
                        DealerIdEventDrivenExpense.put(rt.Dealer_Name__c, DealerIdEventDrivenExpense.get(rt.Dealer_Name__c) + rt.Actual_Expense__c);
                    }
                }
            }       
        }
        
        for(Retail_Campaign__c rt : [select Id, RecordType.Name, Driven__c, Dealer_Name__c, Dealer_Name__r.Name, Dealer_Name__r.Branch_name__c, Plan_Expense__c from Retail_Campaign__c 
                                     where (RecordType.Name = 'S&M Event Retail Campaign' or RecordType.Name = 'S&M Media Retail Campaign') and (Driven__c = 'Joint' or Driven__c = 'Dealer Driven') and 
                                     Plan_Start_Date__c >= :startDate and  Apply_Status__c = 'Approved' and Feedback_Status__c != 'Approved']) {
            if(rt.Dealer_Name__c != null) {
                DealerIdDealerName.put(rt.Dealer_Name__c,  rt.Dealer_Name__r.Name);
                if(!String.isBlank(rt.Dealer_Name__r.Branch_name__c)) {
                    DealerIdDealerName.put(rt.Dealer_Name__c,  rt.Dealer_Name__r.Name + ' - ' + rt.Dealer_Name__r.Branch_name__c);
                }
                
                if(rt.Plan_Expense__c > 0) {
                    if(!DealerIdExpense.containsKey(rt.Dealer_Name__c)) {
                    
                        DealerIdExpense.put(rt.Dealer_Name__c, 0);
                    }
                    DealerIdExpense.put(rt.Dealer_Name__c, DealerIdExpense.get(rt.Dealer_Name__c) + rt.Plan_Expense__c);

                    if(rt.RecordType.Name == 'S&M Media Retail Campaign' && rt.Driven__c == 'Joint') {
                        if(!DealerIdMediaJointExpense.containsKey(rt.Dealer_Name__c)) {
                            DealerIdMediaJointExpense.put(rt.Dealer_Name__c, 0);
                        }
                        DealerIdMediaJointExpense.put(rt.Dealer_Name__c, DealerIdMediaJointExpense.get(rt.Dealer_Name__c) + rt.Plan_Expense__c);
                    }
                    if(rt.RecordType.Name == 'S&M Media Retail Campaign' && rt.Driven__c == 'Dealer Driven') {
                        if(!DealerIdMediaDrivenExpense.containsKey(rt.Dealer_Name__c)) {
                            DealerIdMediaDrivenExpense.put(rt.Dealer_Name__c, 0);
                        }
                        DealerIdMediaDrivenExpense.put(rt.Dealer_Name__c, DealerIdMediaDrivenExpense.get(rt.Dealer_Name__c) + rt.Plan_Expense__c);
                    }
                    if(rt.RecordType.Name == 'S&M Event Retail Campaign' && rt.Driven__c == 'Joint') {
                        if(!DealerIdEventJointExpense.containsKey(rt.Dealer_Name__c)) {
                            DealerIdEventJointExpense.put(rt.Dealer_Name__c, 0);
                        }
                        DealerIdEventJointExpense.put(rt.Dealer_Name__c, DealerIdEventJointExpense.get(rt.Dealer_Name__c) + rt.Plan_Expense__c);
                    }
                    if(rt.RecordType.Name == 'S&M Event Retail Campaign' && rt.Driven__c == 'Dealer Driven') {
                        if(!DealerIdEventDrivenExpense.containsKey(rt.Dealer_Name__c)) {
                            DealerIdEventDrivenExpense.put(rt.Dealer_Name__c, 0);
                        }
                        DealerIdEventDrivenExpense.put(rt.Dealer_Name__c, DealerIdEventDrivenExpense.get(rt.Dealer_Name__c) + rt.Plan_Expense__c);
                    }
                }
            }
        }

        TotalYearlyMarketTarget = new List<YearlyMarketTarget>();
        TotalYearlyJointMarketTarget = new List<YearlyMarketTarget>();
        TotalYearlyDrivenMarketTarget = new List<YearlyMarketTarget>();
        YearlyMarketTarget b;
        YearlyMarketTarget c;
        YearlyMarketTarget d;
        for(Retail_Campaign__c rt : [select Id, Y_Region__c, Y_Sub_Region__c, Y_City__c, Y_Dealer_Name__c, Y_Dealer_Name__r.Name, Y_Dealer_Name__r.Branch_name__c, Y_MB_Joint_Marketing_Budget__c, Y_MB_Dealer_Driven_Marketing_Budget__c, Y_MB_Marketing_Budget__c, Y_MB_Joint_Marketing_Expense__c, Y_MB_Dealer_Driven_Marketing_Expense__c from Retail_Campaign__c where Y_MB_Marketing_Budget__c > 0 and Y_Year__c = :currentYear]) {
            DealerIdYearlyTA.put(rt.Y_Dealer_Name__c, rt.Y_MB_Marketing_Budget__c);
            DealerIdDealerName.put(rt.Y_Dealer_Name__c,  rt.Y_Dealer_Name__r.Name);
            if(!String.isBlank(rt.Y_Dealer_Name__r.Branch_name__c)) {
                DealerIdDealerName.put(rt.Y_Dealer_Name__c,  rt.Y_Dealer_Name__r.Name + ' - ' + rt.Y_Dealer_Name__r.Branch_name__c);
            }
            YearlyTAIds.add(rt.Id);
            b = new YearlyMarketTarget();
            b.region = rt.Y_Region__c;
            b.subregion = rt.Y_Sub_Region__c;
            b.city = rt.Y_City__c;
            b.dealerName = rt.Y_Dealer_Name__r.Name;
            if(!String.isBlank(rt.Y_Dealer_Name__r.Branch_name__c)) {
                b.dealerName += '-' + rt.Y_Dealer_Name__r.Branch_name__c;
            }
            b.TotalExpense = rt.Y_MB_Marketing_Budget__c;
            b.onlinePart = 0;
            b.offlinePart = 0;
            if(DealerIdExpense.containsKey(rt.Y_Dealer_Name__c)) {
                b.usedExpense = DealerIdExpense.get(rt.Y_Dealer_Name__c);
                b.blance = rt.Y_MB_Marketing_Budget__c - DealerIdExpense.get(rt.Y_Dealer_Name__c);
            }
            if(b.usedExpense > 0 && b.TotalExpense > 0) {
                b.usedpersent = (b.usedExpense * 100 / b.TotalExpense).setScale(2);
            }
            if(b.blance > 0 && b.TotalExpense > 0) {
                b.blancepersent = (b.blance * 100 / b.TotalExpense).setScale(2);
            }
            TotalYearlyMarketTarget.add(b);
            
            
            c = new YearlyMarketTarget();
            c.region = rt.Y_Region__c;
            c.subregion = rt.Y_Sub_Region__c;
            c.city = rt.Y_City__c;
            c.dealerName = rt.Y_Dealer_Name__r.Name;
            if(!String.isBlank(rt.Y_Dealer_Name__r.Branch_name__c)) {
                c.dealerName += '-' + rt.Y_Dealer_Name__r.Branch_name__c;
            }
            c.TotalExpense = rt.Y_MB_Joint_Marketing_Budget__c;
            if(DealerIdMediaJointExpense.containsKey(rt.Y_Dealer_Name__c)) {
                c.onlinePart = DealerIdMediaJointExpense.get(rt.Y_Dealer_Name__c);
            }
            if(DealerIdEventJointExpense.containsKey(rt.Y_Dealer_Name__c)) {
                c.offlinePart = DealerIdEventJointExpense.get(rt.Y_Dealer_Name__c);
            }
            c.usedExpense = c.onlinePart + c.offlinePart;
            c.blance = c.TotalExpense - c.usedExpense;
            if(c.usedExpense > 0 && c.TotalExpense > 0) {
                c.usedpersent = (c.usedExpense * 100 / c.TotalExpense).setScale(2);
            }
            if(c.blance > 0 && c.TotalExpense > 0) {
                c.blancepersent = (c.blance * 100 / c.TotalExpense).setScale(2);
            }
            TotalYearlyJointMarketTarget.add(c);
            
            d = new YearlyMarketTarget();
            d.region = rt.Y_Region__c;
            d.subregion = rt.Y_Sub_Region__c;
            d.city = rt.Y_City__c;
            d.dealerName = rt.Y_Dealer_Name__r.Name;
            if(!String.isBlank(rt.Y_Dealer_Name__r.Branch_name__c)) {
                d.dealerName += '-' + rt.Y_Dealer_Name__r.Branch_name__c;
            }
            d.TotalExpense = rt.Y_MB_Dealer_Driven_Marketing_Budget__c;
            if(DealerIdMediaDrivenExpense.containsKey(rt.Y_Dealer_Name__c) && DealerIdMediaDrivenExpense.get(rt.Y_Dealer_Name__c) >= 0) {
                d.onlinePart = DealerIdMediaDrivenExpense.get(rt.Y_Dealer_Name__c);
            }
            if(DealerIdMediaDrivenExpense.containsKey(rt.Y_Dealer_Name__c) && DealerIdEventDrivenExpense.get(rt.Y_Dealer_Name__c) >= 0) {
                d.offlinePart = DealerIdEventDrivenExpense.get(rt.Y_Dealer_Name__c);
            }

            d.usedExpense = d.onlinePart + d.offlinePart;
            d.blance = d.TotalExpense - d.usedExpense;
            if(d.TotalExpense > 0 && d.TotalExpense > 0) {
                d.usedpersent = (d.usedExpense * 100 / d.TotalExpense).setScale(2);
            }
            if(d.TotalExpense > 0 && d.TotalExpense > 0) {
                d.blancepersent = (d.blance * 100 / d.TotalExpense).setScale(2);
            }
            TotalYearlyDrivenMarketTarget.add(d);
        }
        
        YearlyMarketTarget AllTotalTarget = new YearlyMarketTarget();
        for(YearlyMarketTarget mt : TotalYearlyMarketTarget) {
            AllTotalTarget.region = total;
            AllTotalTarget.TotalExpense += mt.TotalExpense;
            AllTotalTarget.blance += mt.blance;
            AllTotalTarget.blancepersent = 100;
            AllTotalTarget.usedExpense += mt.usedExpense;
            AllTotalTarget.usedpersent = 100;
        }
        TotalYearlyMarketTarget.add(AllTotalTarget);
        
        YearlyMarketTarget TotalJointTarget = new YearlyMarketTarget();
        for(YearlyMarketTarget mt : TotalYearlyJointMarketTarget) {
            TotalJointTarget.region = total;
            TotalJointTarget.TotalExpense += mt.TotalExpense;
            TotalJointTarget.blance += mt.blance;
            TotalJointTarget.blancepersent += 100;
            TotalJointTarget.onlinePart += mt.onlinePart;
            TotalJointTarget.offlinePart += mt.offlinePart;
            TotalJointTarget.usedExpense += mt.usedExpense;
            TotalJointTarget.usedpersent = 100;
        }
        TotalYearlyJointMarketTarget.add(TotalJointTarget);
        
        YearlyMarketTarget TotalDrivenTarget = new YearlyMarketTarget();
        for(YearlyMarketTarget mt : TotalYearlyDrivenMarketTarget) {
            TotalDrivenTarget.region = total;
            TotalDrivenTarget.TotalExpense += mt.TotalExpense;
            TotalDrivenTarget.blance += mt.blance;
            TotalDrivenTarget.blancepersent += 100;
            TotalDrivenTarget.onlinePart += mt.onlinePart;
            TotalDrivenTarget.offlinePart += mt.offlinePart;
            TotalDrivenTarget.usedExpense += mt.usedExpense;
            TotalDrivenTarget.usedpersent += 100;
        }
        TotalYearlyDrivenMarketTarget.add(TotalDrivenTarget);
            
        data = new List<expense>();
        expense a;
        for(Id dealerId : DealerIdDealerName.KeySet()) {
            
            If(DealerIdExpense.containsKey(dealerId) && DealerIdYearlyTA.containsKey(dealerId)) {
                a = new expense(DealerIdExpense.get(dealerId), DealerIdYearlyTA.get(dealerId), DealerIdDealerName.get(dealerId));
                data.add(a);
            }
            else If(DealerIdExpense.containsKey(dealerId)) {
                a = new expense(DealerIdExpense.get(dealerId), 0, DealerIdDealerName.get(dealerId));
                data.add(a);
            }
            else If(DealerIdYearlyTA.containsKey(dealerId)) {
                a = new expense(0, DealerIdYearlyTA.get(dealerId), DealerIdDealerName.get(dealerId));
                data.add(a);
            }
        }
        
        ChatHeigth = 200 + DealerIdDealerName.KeySet().size() * 20;
        
        JanTarget = new List<marketTarget>();
        FebTarget = new List<marketTarget>();
        MarTarget = new List<marketTarget>();
        AprTarget = new List<marketTarget>();
        MayTarget = new List<marketTarget>();
        JunTarget = new List<marketTarget>();
        JulTarget = new List<marketTarget>();
        AugTarget = new List<marketTarget>();
        SepTarget = new List<marketTarget>();
        OctTarget = new List<marketTarget>();
        NovTarget = new List<marketTarget>();
        DecTarget = new List<marketTarget>();
        TotalTarget = new List<marketTarget>();
        
        Map<Id, List<Retail_Campaign__c>> dealerIdMonthlyTAs = new Map<Id, List<Retail_Campaign__c>>();
        for(Retail_Campaign__c  rt : [select Id, Apply_Status__c, Feedback_Status__c, Actual_Start_Date__c, Plan_Start_Date__c, RecordType.Name, Driven__c, Dealer_Name__c, Dealer_Name__r.Name, Dealer_Name__r.Branch_name__c, Plan_Expense__c, Actual_Expense__c from Retail_Campaign__c where  Dealer_Name__c != null and (Brand__c = 'MB' OR Brand__c = 'StarElite') and (RecordType.Name = 'S&M Event Retail Campaign' or RecordType.Name = 'S&M Media Retail Campaign') and (Driven__c = 'Joint' or Driven__c = 'Dealer Driven') and ((Plan_Start_Date__c >= :startDate and Plan_Start_Date__c <= :endDate and  Apply_Status__c = 'Approved' and  Feedback_Status__c != 'Approved') or (Actual_Start_Date__c >= :startDate and Actual_Start_Date__c <= :endDate and  Feedback_Status__c = 'Approved')) ]) {
            if(!dealerIdMonthlyTAs.containsKey(rt.Dealer_Name__c)) {
                dealerIdMonthlyTAs.put(rt.Dealer_Name__c, new List<Retail_Campaign__c>());
            }
            dealerIdMonthlyTAs.get(rt.Dealer_Name__c).add(rt);
        }
        
        Map<Id, Account> dealerIdInfos = new Map<Id, Account>([select Id, Name, Branch_name__c, Dealer_Region__c, Dealer_MB_Sub_Region__c, Dealer_City_EN__c from Account where Id in :dealerIdMonthlyTAs.keySet()]);
        
        marketTarget temp1;
        marketTarget temp2;
        marketTarget temp3;
        marketTarget temp4;
        marketTarget temp5;
        marketTarget temp6;
        marketTarget temp7;
        marketTarget temp8;
        marketTarget temp9;
        marketTarget temp10;
        marketTarget temp11;
        marketTarget temp12;
        marketTarget tempEast = new marketTarget(east);
        marketTarget tempWest = new marketTarget(west);
        marketTarget tempNorth = new marketTarget(north);
        marketTarget tempSouth = new marketTarget(south);
        decimal marketExpense = 0;
        Date marketStartDate;
        
        for(Id dealerId : dealerIdMonthlyTAs.keySet()) {
            if(dealerIdInfos.containsKey(dealerId)) {
                temp1 = new marketTarget(dealerIdInfos.get(dealerId));
                temp2 = new marketTarget(dealerIdInfos.get(dealerId));
                temp3 = new marketTarget(dealerIdInfos.get(dealerId));
                temp4 = new marketTarget(dealerIdInfos.get(dealerId));
                temp5 = new marketTarget(dealerIdInfos.get(dealerId));
                temp6 = new marketTarget(dealerIdInfos.get(dealerId));
                temp7 = new marketTarget(dealerIdInfos.get(dealerId));
                temp8 = new marketTarget(dealerIdInfos.get(dealerId));
                temp9 = new marketTarget(dealerIdInfos.get(dealerId));
                temp10 = new marketTarget(dealerIdInfos.get(dealerId));
                temp11 = new marketTarget(dealerIdInfos.get(dealerId));
                temp12 = new marketTarget(dealerIdInfos.get(dealerId));

                for(Retail_Campaign__c rt : dealerIdMonthlyTAs.get(dealerId)) {
                    if(rt.Plan_Start_Date__c >= startDate && rt.Plan_Start_Date__c <= endDate &&  rt.Apply_Status__c == 'Approved' &&  rt.Feedback_Status__c != 'Approved') {
                        marketExpense = rt.Plan_Expense__c >= 0 ? rt.Plan_Expense__c : 0;
                        marketStartDate = rt.Plan_Start_Date__c;
                    }else if(rt.Actual_Start_Date__c>= startDate && rt.Actual_Start_Date__c <= endDate && rt.Feedback_Status__c == 'Approved'){
                        marketExpense = rt.Actual_Expense__c >= 0 ? rt.Actual_Expense__c : 0;
                        marketStartDate = rt.Actual_Start_Date__c;
                    }
                        Integer marketMonth = marketStartDate.month();
                        if(marketMonth == 1) {
                            temp1.monthlyMarketExpense += marketExpense;
                        }
                        if(marketMonth == 2) {
                            temp2.monthlyMarketExpense += marketExpense;
                        }
                        if(marketMonth == 3) {
                            temp3.monthlyMarketExpense += marketExpense;
                        }
                        if(marketMonth == 4) {
                            temp4.monthlyMarketExpense += marketExpense;
                        }
                        if(marketMonth == 5) {
                            temp5.monthlyMarketExpense += marketExpense;
                        }
                        if(marketMonth == 6) {
                            temp6.monthlyMarketExpense += marketExpense;
                        }
                        if(marketMonth == 7) {
                            temp7.monthlyMarketExpense += marketExpense;
                        }
                        if(marketMonth == 8) {
                           temp8.monthlyMarketExpense += marketExpense; 
                        }
                        if(marketMonth == 9) {
                            temp9.monthlyMarketExpense += marketExpense;
                        }
                        if(marketMonth == 10) {
                            temp10.monthlyMarketExpense += marketExpense; 
                        }
                        if(marketMonth == 11) {
                            temp11.monthlyMarketExpense += marketExpense;
                        }
                        if(marketMonth == 12) {
                            temp12.monthlyMarketExpense += marketExpense;
                        }
                        
                        if(dealerIdInfos.get(dealerId).Dealer_Region__c == east) {
                            tempEast.monthlyMarketExpense += marketExpense;
                        }
                        else if(dealerIdInfos.get(dealerId).Dealer_Region__c == west) {
                            tempWest.monthlyMarketExpense += marketExpense;
                        }
                        else if(dealerIdInfos.get(dealerId).Dealer_Region__c == north) {
                            tempNorth.monthlyMarketExpense += marketExpense;
                        }
                        else if(dealerIdInfos.get(dealerId).Dealer_Region__c == south) {
                            tempSouth.monthlyMarketExpense += marketExpense;
                        }
                            
                        if(rt.RecordType.Name == 'S&M Media Retail Campaign') {
                            if(marketMonth == 1) {
                                temp1.onlinePart += marketExpense;
                            }
                            if(marketMonth == 2) {
                                temp2.onlinePart += marketExpense;
                            }
                            if(marketMonth == 3) {
                                temp3.onlinePart += marketExpense;
                            }
                            if(marketMonth == 4) {
                                temp4.onlinePart += marketExpense;
                            }
                            if(marketMonth == 5) {
                                temp5.onlinePart += marketExpense;
                            }
                            if(marketMonth == 6) {
                                temp6.onlinePart += marketExpense;
                            }
                            if(marketMonth == 7) {
                                temp7.onlinePart += marketExpense;
                            }
                            if(marketMonth == 8) {
                               temp8.onlinePart += marketExpense; 
                            }
                            if(marketMonth == 9) {
                                temp9.onlinePart += marketExpense;
                            }
                            if(marketMonth == 10) {
                                temp10.onlinePart += marketExpense; 
                            }
                            if(marketMonth == 11) {
                                temp11.onlinePart += marketExpense;
                            }
                            if(marketMonth == 12) {
                                temp12.onlinePart += marketExpense;
                            }
                            
                            if(dealerIdInfos.get(dealerId).Dealer_Region__c == east) {
                                tempEast.onlinePart += marketExpense;
                            }
                            else if(dealerIdInfos.get(dealerId).Dealer_Region__c == west) {
                                tempWest.onlinePart += marketExpense;
                            }
                            else if(dealerIdInfos.get(dealerId).Dealer_Region__c == north) {
                                tempNorth.onlinePart += marketExpense;
                            }
                            else if(dealerIdInfos.get(dealerId).Dealer_Region__c == south) {
                                tempSouth.onlinePart += marketExpense;
                            }
                        }
                        else if(rt.RecordType.Name == 'S&M Event Retail Campaign') {
                            if(marketMonth == 1) {
                                temp1.offlinePart += marketExpense;
                            }
                            if(marketMonth == 2) {
                                temp2.offlinePart += marketExpense;
                            }
                            if(marketMonth == 3) {
                                temp3.offlinePart += marketExpense;
                            }
                            if(marketMonth == 4) {
                                temp4.offlinePart += marketExpense;
                            }
                            if(marketMonth == 5) {
                                temp5.offlinePart += marketExpense;
                            }
                            if(marketMonth == 6) {
                                temp6.offlinePart += marketExpense;
                            }
                            if(marketMonth == 7) {
                                temp7.offlinePart += marketExpense;
                            }
                            if(marketMonth == 8) {
                               temp8.offlinePart += marketExpense; 
                            }
                            if(marketMonth == 9) {
                                temp9.offlinePart += marketExpense;
                            }
                            if(marketMonth == 10) {
                                temp10.offlinePart += marketExpense; 
                            }
                            if(marketMonth == 11) {
                                temp11.offlinePart += marketExpense;
                            }
                            if(marketMonth == 12) {
                                temp12.offlinePart += marketExpense;
                            }
                            
                            if(dealerIdInfos.get(dealerId).Dealer_Region__c == east) {
                                tempEast.offlinePart += marketExpense;
                            }
                            else if(dealerIdInfos.get(dealerId).Dealer_Region__c == west) {
                                tempWest.offlinePart += marketExpense;
                            }
                            else if(dealerIdInfos.get(dealerId).Dealer_Region__c == north) {
                                tempNorth.offlinePart += marketExpense;
                            }
                            else if(dealerIdInfos.get(dealerId).Dealer_Region__c == south) {
                                tempSouth.offlinePart += marketExpense;
                            }
                        }
                        
                        if(rt.Driven__c == 'Dealer Driven') {
                            if(marketMonth == 1) {
                                temp1.monthlyDrivenMarketExpense += marketExpense;
                            }
                            if(marketMonth == 2) {
                                temp2.monthlyDrivenMarketExpense += marketExpense;
                            }
                            if(marketMonth == 3) {
                                temp3.monthlyDrivenMarketExpense += marketExpense;
                            }
                            if(marketMonth == 4) {
                                temp4.monthlyDrivenMarketExpense += marketExpense;
                            }
                            if(marketMonth == 5) {
                                temp5.monthlyDrivenMarketExpense += marketExpense;
                            }
                            if(marketMonth == 6) {
                                temp6.monthlyDrivenMarketExpense += marketExpense;
                            }
                            if(marketMonth == 7) {
                                temp7.monthlyDrivenMarketExpense += marketExpense;
                            }
                            if(marketMonth == 8) {
                               temp8.monthlyDrivenMarketExpense += marketExpense; 
                            }
                            if(marketMonth == 9) {
                                temp9.monthlyDrivenMarketExpense += marketExpense;
                            }
                            if(marketMonth == 10) {
                                temp10.monthlyDrivenMarketExpense += marketExpense; 
                            }
                            if(marketMonth == 11) {
                                temp11.monthlyDrivenMarketExpense += marketExpense;
                            }
                            if(marketMonth == 12) {
                                temp12.monthlyDrivenMarketExpense += marketExpense;
                            }
                            
                            if(dealerIdInfos.get(dealerId).Dealer_Region__c == east) {
                                tempEast.monthlyDrivenMarketExpense += marketExpense;
                            }
                            else if(dealerIdInfos.get(dealerId).Dealer_Region__c == west) {
                                tempWest.monthlyDrivenMarketExpense += marketExpense;
                            }
                            else if(dealerIdInfos.get(dealerId).Dealer_Region__c == north) {
                                tempNorth.monthlyDrivenMarketExpense += marketExpense;
                            }
                            else if(dealerIdInfos.get(dealerId).Dealer_Region__c == south) {
                                tempSouth.monthlyDrivenMarketExpense += marketExpense;
                            }
                        }
                        else if(rt.Driven__c == 'Joint') {
                            if(marketMonth == 1) {
                                temp1.monthlyJointMarketExpense += marketExpense;
                            }
                            if(marketMonth == 2) {
                                temp2.monthlyJointMarketExpense += marketExpense;
                            }
                            if(marketMonth == 3) {
                                temp3.monthlyJointMarketExpense += marketExpense;
                            }
                            if(marketMonth == 4) {
                                temp4.monthlyJointMarketExpense += marketExpense;
                            }
                            if(marketMonth == 5) {
                                temp5.monthlyJointMarketExpense += marketExpense;
                            }
                            if(marketMonth == 6) {
                                temp6.monthlyJointMarketExpense += marketExpense;
                            }
                            if(marketMonth == 7) {
                                temp7.monthlyJointMarketExpense += marketExpense;
                            }
                            if(marketMonth == 8) {
                               temp8.monthlyJointMarketExpense += marketExpense; 
                            }
                            if(marketMonth == 9) {
                                temp9.monthlyJointMarketExpense += marketExpense;
                            }
                            if(marketMonth == 10) {
                                temp10.monthlyJointMarketExpense += marketExpense; 
                            }
                            if(marketMonth == 11) {
                                temp11.monthlyJointMarketExpense += marketExpense;
                            }
                            if(marketMonth == 12) {
                                temp12.monthlyJointMarketExpense += marketExpense;
                            }
                            
                            if(dealerIdInfos.get(dealerId).Dealer_Region__c == east) {
                                tempEast.monthlyJointMarketExpense += marketExpense;
                            }
                            else if(dealerIdInfos.get(dealerId).Dealer_Region__c == west) {
                                tempWest.monthlyJointMarketExpense += marketExpense;
                            }
                            else if(dealerIdInfos.get(dealerId).Dealer_Region__c == north) {
                                tempNorth.monthlyJointMarketExpense += marketExpense;
                            }
                            else if(dealerIdInfos.get(dealerId).Dealer_Region__c == south) {
                                tempSouth.monthlyJointMarketExpense += marketExpense;
                            }
                        }
                    
                }
                JanTarget.add(temp1);
                FebTarget.add(temp2);
                MarTarget.add(temp3);
                AprTarget.add(temp4);
                MayTarget.add(temp5);
                JunTarget.add(temp6);
                JulTarget.add(temp7);
                AugTarget.add(temp8);
                SepTarget.add(temp9);
                OctTarget.add(temp10);
                NovTarget.add(temp11);
                DecTarget.add(temp12);
            }
        }
        
        marketTarget JanTotalTarget = new marketTarget();
        marketTarget FebTotalTarget = new marketTarget();
        marketTarget MarTotalTarget = new marketTarget();
        marketTarget AprTotalTarget = new marketTarget();
        marketTarget MayTotalTarget = new marketTarget();
        marketTarget JunTotalTarget = new marketTarget();
        marketTarget JulTotalTarget = new marketTarget();
        marketTarget AugTotalTarget = new marketTarget();
        marketTarget SepTotalTarget = new marketTarget();
        marketTarget OctTotalTarget = new marketTarget();
        marketTarget NovTotalTarget = new marketTarget();
        marketTarget DecTotalTarget = new marketTarget();

        for(marketTarget mt : JanTarget) {
            JanTotalTarget.region = total;
            JanTotalTarget.monthlyMarketExpense += mt.monthlyMarketExpense;
            JanTotalTarget.onlinePart  += mt.onlinePart;
            JanTotalTarget.offlinePart += mt.offlinePart;
            JanTotalTarget.monthlyJointMarketExpense += mt.monthlyJointMarketExpense;
            JanTotalTarget.monthlyDrivenMarketExpense += mt.monthlyDrivenMarketExpense;
        }
        JanTarget.add(JanTotalTarget);
        for(marketTarget mt : FebTarget) {
            FebTotalTarget.region = total;
            FebTotalTarget.monthlyMarketExpense += mt.monthlyMarketExpense;
            FebTotalTarget.onlinePart  += mt.onlinePart;
            FebTotalTarget.offlinePart += mt.offlinePart;
            FebTotalTarget.monthlyJointMarketExpense += mt.monthlyJointMarketExpense;
            FebTotalTarget.monthlyDrivenMarketExpense += mt.monthlyDrivenMarketExpense;
        }
        FebTarget.add(FebTotalTarget);
        for(marketTarget mt : MarTarget) {
            MarTotalTarget.region = total;
            MarTotalTarget.monthlyMarketExpense += mt.monthlyMarketExpense;
            MarTotalTarget.onlinePart  += mt.onlinePart;
            MarTotalTarget.offlinePart += mt.offlinePart;
            MarTotalTarget.monthlyJointMarketExpense += mt.monthlyJointMarketExpense;
            MarTotalTarget.monthlyDrivenMarketExpense += mt.monthlyDrivenMarketExpense;
        }
        MarTarget.add(MarTotalTarget);
        for(marketTarget mt : AprTarget) {
            AprTotalTarget.region = total;
            AprTotalTarget.monthlyMarketExpense += mt.monthlyMarketExpense;
            AprTotalTarget.onlinePart  += mt.onlinePart;
            AprTotalTarget.offlinePart += mt.offlinePart;
            AprTotalTarget.monthlyJointMarketExpense += mt.monthlyJointMarketExpense;
            AprTotalTarget.monthlyDrivenMarketExpense += mt.monthlyDrivenMarketExpense;
        }
        AprTarget.add(AprTotalTarget);
        for(marketTarget mt : MayTarget) {
            MayTotalTarget.region = total;
            MayTotalTarget.monthlyMarketExpense += mt.monthlyMarketExpense;
            MayTotalTarget.onlinePart  += mt.onlinePart;
            MayTotalTarget.offlinePart += mt.offlinePart;
            MayTotalTarget.monthlyJointMarketExpense += mt.monthlyJointMarketExpense;
            MayTotalTarget.monthlyDrivenMarketExpense += mt.monthlyDrivenMarketExpense;
        }
        MayTarget.add(MayTotalTarget);
        for(marketTarget mt : JunTarget) {
            JunTotalTarget.region = total;
            JunTotalTarget.monthlyMarketExpense += mt.monthlyMarketExpense;
            JunTotalTarget.onlinePart  += mt.onlinePart;
            JunTotalTarget.offlinePart += mt.offlinePart;
            JunTotalTarget.monthlyJointMarketExpense += mt.monthlyJointMarketExpense;
            JunTotalTarget.monthlyDrivenMarketExpense += mt.monthlyDrivenMarketExpense;
        }
        JunTarget.add(JunTotalTarget);
        for(marketTarget mt : JulTarget) {
            JulTotalTarget.region = total;
            JulTotalTarget.monthlyMarketExpense += mt.monthlyMarketExpense;
            JulTotalTarget.onlinePart  += mt.onlinePart;
            JulTotalTarget.offlinePart += mt.offlinePart;
            JulTotalTarget.monthlyJointMarketExpense += mt.monthlyJointMarketExpense;
            JulTotalTarget.monthlyDrivenMarketExpense += mt.monthlyDrivenMarketExpense;
        }
        JulTarget.add(JulTotalTarget);
        for(marketTarget mt : AugTarget) {
            AugTotalTarget.region = total;
            AugTotalTarget.monthlyMarketExpense += mt.monthlyMarketExpense;
            AugTotalTarget.onlinePart  += mt.onlinePart;
            AugTotalTarget.offlinePart += mt.offlinePart;
            AugTotalTarget.monthlyJointMarketExpense += mt.monthlyJointMarketExpense;
            AugTotalTarget.monthlyDrivenMarketExpense += mt.monthlyDrivenMarketExpense;
        }
        AugTarget.add(AugTotalTarget);
        for(marketTarget mt : SepTarget) {
            SepTotalTarget.region = total;
            SepTotalTarget.monthlyMarketExpense += mt.monthlyMarketExpense;
            SepTotalTarget.onlinePart  += mt.onlinePart;
            SepTotalTarget.offlinePart += mt.offlinePart;
            SepTotalTarget.monthlyJointMarketExpense += mt.monthlyJointMarketExpense;
            SepTotalTarget.monthlyDrivenMarketExpense += mt.monthlyDrivenMarketExpense;
        }
        SepTarget.add(SepTotalTarget);
        for(marketTarget mt : OctTarget) {
            OctTotalTarget.region = total;
            OctTotalTarget.monthlyMarketExpense += mt.monthlyMarketExpense;
            OctTotalTarget.onlinePart  += mt.onlinePart;
            OctTotalTarget.offlinePart += mt.offlinePart;
            OctTotalTarget.monthlyJointMarketExpense += mt.monthlyJointMarketExpense;
            OctTotalTarget.monthlyDrivenMarketExpense += mt.monthlyDrivenMarketExpense;
        }
        OctTarget.add(OctTotalTarget);
        for(marketTarget mt : NovTarget) {
            NovTotalTarget.region =total;
            NovTotalTarget.monthlyMarketExpense += mt.monthlyMarketExpense;
            NovTotalTarget.onlinePart  += mt.onlinePart;
            NovTotalTarget.offlinePart += mt.offlinePart;
            NovTotalTarget.monthlyJointMarketExpense += mt.monthlyJointMarketExpense;
            NovTotalTarget.monthlyDrivenMarketExpense += mt.monthlyDrivenMarketExpense;
        }
        NovTarget.add(NovTotalTarget);
        for(marketTarget mt : DecTarget) {
            DecTotalTarget.region = total;
            DecTotalTarget.monthlyMarketExpense += mt.monthlyMarketExpense;
            DecTotalTarget.onlinePart  += mt.onlinePart;
            DecTotalTarget.offlinePart += mt.offlinePart;
            DecTotalTarget.monthlyJointMarketExpense += mt.monthlyJointMarketExpense;
            DecTotalTarget.monthlyDrivenMarketExpense += mt.monthlyDrivenMarketExpense;
        }
        DecTarget.add(DecTotalTarget);
        
        TotalTarget.add(tempEast);
        TotalTarget.add(tempWest);
        TotalTarget.add(tempNorth);
        TotalTarget.add(tempSouth);
       
        marketTarget tempTotal = new marketTarget(total);
        tempTotal.monthlyMarketExpense = tempEast.monthlyMarketExpense + tempWest.monthlyMarketExpense + tempNorth.monthlyMarketExpense + tempSouth.monthlyMarketExpense;
        tempTotal.onlinePart = tempEast.onlinePart + tempWest.onlinePart + tempNorth.onlinePart + tempSouth.onlinePart;
        tempTotal.offlinePart = tempEast.offlinePart + tempWest.offlinePart + tempNorth.offlinePart + tempSouth.offlinePart;
        tempTotal.monthlyJointMarketExpense = tempEast.monthlyJointMarketExpense + tempWest.monthlyJointMarketExpense + tempNorth.monthlyJointMarketExpense + tempSouth.monthlyJointMarketExpense;
        tempTotal.monthlyDrivenMarketExpense = tempEast.monthlyDrivenMarketExpense + tempWest.monthlyDrivenMarketExpense + tempNorth.monthlyDrivenMarketExpense + tempSouth.monthlyDrivenMarketExpense;
        
        TotalTarget.add(tempTotal);
    }
    
    public class expense {
        public expense(decimal a, decimal b, string c) {
            this.data1 = a;
            this.data3 = b;
            this.category = c;
        }
        public decimal data1 { get; set; }
        public decimal data3 { get; set; }
        public String category{ get; set; }
    }
    
    public class marketTarget{
        public marketTarget() {
            this.monthlyMarketExpense = 0;
            this.onlinePart = 0;
            this.offlinePart = 0;
            this.monthlyJointMarketExpense = 0;
            this.monthlyDrivenMarketExpense = 0;
        }
        public marketTarget(String region) {
            this.region = region;
            this.dealerName = '';
            this.monthlyMarketExpense = 0;
            this.onlinePart = 0;
            this.offlinePart = 0;
            this.monthlyJointMarketExpense = 0;
            this.monthlyDrivenMarketExpense = 0;
        }
        public marketTarget(String region, Account a) {
            this.region = region;
            this.dealerName = a.Name;
            if(!String.isBlank(a.Branch_name__c)) {
                this.dealerName += '-' + a.Branch_name__c;
            }
            this.monthlyMarketExpense = 0;
            this.onlinePart = 0;
            this.offlinePart = 0;
            this.monthlyJointMarketExpense = 0;
            this.monthlyDrivenMarketExpense = 0;
        }
        public marketTarget(Account a) {
            this.region = !String.isBlank(a.Dealer_Region__c) ? a.Dealer_Region__c : '';
            this.subregion = !String.isBlank(a.Dealer_MB_Sub_Region__c) ? a.Dealer_MB_Sub_Region__c : '';
            this.city = !String.isBlank(a.Dealer_City_EN__c) ? a.Dealer_City_EN__c : '';
            this.dealerName = a.Name;
            if(!String.isBlank(a.Branch_name__c)) {
                this.dealerName += '-' + a.Branch_name__c;
            }
            this.monthlyMarketExpense = 0;
            this.onlinePart = 0;
            this.offlinePart = 0;
            this.monthlyJointMarketExpense = 0;
            this.monthlyDrivenMarketExpense = 0;
        }
        public String region{ get; set; }
        public String subregion{ get; set; }
        public String city{ get; set; }
        public String dealerName{ get; set; }
        public decimal monthlyMarketExpense { get; set; }
        public decimal onlinePart { get; set; }
        public decimal offlinePart { get; set; }
        public decimal monthlyJointMarketExpense { get; set; }
        public decimal monthlyDrivenMarketExpense { get; set; }
    }
    
    public class YearlyMarketTarget{
        public YearlyMarketTarget() {
            this.TotalExpense = 0;
            this.onlinePart = 0;
            this.offlinePart = 0;
            this.usedExpense = 0;
            this.blance = 0;
            this.usedpersent = 0;
            this.blancepersent = 0;
        }
        public String region{ get; set; }
        public String subregion{ get; set; }
        public String city{ get; set; }
        public String dealerName{ get; set; }
        public decimal TotalExpense { get; set; }
        public decimal onlinePart { get; set; }
        public decimal offlinePart { get; set; }
        public decimal blance { get; set; }
        public decimal usedExpense { get; set; }
        public decimal usedpersent { get; set; }
        public decimal blancepersent { get; set; }
    }
}