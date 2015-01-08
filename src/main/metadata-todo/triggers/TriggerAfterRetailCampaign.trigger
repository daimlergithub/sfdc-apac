/*
    Type:       Trigger
    Purpose:    Create Task when campaign status is changed  
    User Story: Retail Campaign
    Used By:    
    ---------------------------------------------------------------
    History:
    
    12-May-2014 Shuang Li    Created
*/
trigger TriggerAfterRetailCampaign on Retail_Campaign__c (after insert, after update) {
    if (!UtilCustomSettings.isEnabled('TriggerRetailCampaign')) {
        return;
    }
    
    Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName();
    List<Retail_Campaign__Share> csList = new List<Retail_Campaign__Share>();
    List<Retail_Campaign__Share> deleteCsList = new List<Retail_Campaign__Share>();
    if(Trigger.isInsert) {
        List<Retail_Campaign__c> MonthlyTA = new List<Retail_Campaign__c >();
        List<MonthlyRule__c> MonthlyRule = [select Name, ATL_BTL__c, Brand__c, Driven__c, KPI_Type__c from MonthlyRule__c];
        Set<Id> dealerNameIds = new Set<Id>();
        for(Retail_Campaign__c cp : trigger.new) {
            if(cpRecordTypeMap.get('Sales & Marketing Yearly TA').getRecordTypeId()== cp.RecordTypeId ){
                
                for (MonthlyRule__c eachMonthly : MonthlyRule){
                    MonthlyTA.add(new Retail_Campaign__c (
                                  RecordTypeId = cpRecordTypeMap.get('Monthly TA').getRecordTypeId(), 
                                  Name = cp.name + '-' + eachMonthly.name,
                                  M_YearlyTA__c = cp.id,
                                  M_ATL_BTL__c = eachMonthly.ATL_BTL__c,
                                  M_Brand__c = eachMonthly.Brand__c,
                                  Driven__c = eachMonthly.Driven__c,
                                  M_KPI_Type__c = eachMonthly.KPI_Type__c,
                                  Y_Dealer_Name__c = cp.Y_Dealer_Name__c
                                  ));
                }
                dealerNameIds.add(cp.Y_Dealer_Name__c);
            }
        }
        
        
        if(MonthlyTA.size() > 0){
            insert MonthlyTA;
            Set<Id> MonthlyTAIds = new Set<Id>();
            for (Retail_Campaign__c eachMonthly : MonthlyTA){
                MonthlyTAIds.add(eachMonthly.Id);
            }
            MonthlyTA = [select Id, Y_Dealer_Name__c from Retail_Campaign__c where Id in :MonthlyTAIds];
            List<User> users = [select Id, AccountId from User where isActive = true and AccountId in :dealerNameIds and Contact.Permission_Set_Settings__c includes ('S_M_Yearly_TA')];
            for (Retail_Campaign__c eachMonthly : MonthlyTA){
                for(User user : users) {
                    if(eachMonthly.Y_Dealer_Name__c == user.AccountId) {
                        csList.add(new Retail_Campaign__Share(ParentId = eachMonthly.id, UserOrGroupId = user.id, AccessLevel = 'Edit'));
                    }
                }
            }
        }
    }
    Map<id, id> monthlyTAYearlyTAMap = new Map<id, id>();
    Map<id, id> aSRetailYearlyTAMap = new Map<id, id>();
    if(Trigger.isUpdate || Trigger.isInsert) {
        for(Retail_Campaign__c cp : trigger.new) {    
            if(cpRecordTypeMap.get('Monthly TA').getRecordTypeId()== cp.RecordTypeId ){
                monthlyTAYearlyTAMap.put(cp.id, cp.M_YearlyTA__c);
            }
            if(cpRecordTypeMap.get('AS Retail Campaign').getRecordTypeId()== cp.RecordTypeId ){
                aSRetailYearlyTAMap.put(cp.id, cp.Yearly_TA__c);
            }
        }
    }
    if(monthlyTAYearlyTAMap.size() > 0){
        Double S_MarketingBudget;
        Double A_MarketingBudget;
        Double M_MarketingBudget;
        Double M_J_MarketingBudget;
        Double M_D_MarketingBudget;
        List<Retail_Campaign__c> MonthlyList = [select M_Brand__c, Driven__c, Y_Total_Amount__c, M_YearlyTA__c from Retail_Campaign__c where M_YearlyTA__c in :monthlyTAYearlyTAMap.values()  and M_KPI_Type__c = 'Marketing Budget'];
        List<Retail_Campaign__c> YearlyList = [select id, Y_SMART_Marketing_Budget__c, Y_AMG_Marketing_Budget__c, Y_MB_Marketing_Budget__c, Y_MB_Joint_Marketing_Budget__c, Y_MB_Dealer_Driven_Marketing_Budget__c from Retail_Campaign__c where id in :monthlyTAYearlyTAMap.values() ];
        for(Retail_Campaign__c Year : YearlyList) {
            S_MarketingBudget = 0;
            A_MarketingBudget = 0;
            M_MarketingBudget = 0;
            M_J_MarketingBudget = 0;
            M_D_MarketingBudget = 0;
            for(Retail_Campaign__c Mon : MonthlyList) {
                if(Mon.M_YearlyTA__c == Year.id){
                    if(Mon.M_Brand__c == 'MB + StarElite'){
                       M_MarketingBudget = M_MarketingBudget + Mon.Y_Total_Amount__c;
                       if(Mon.Driven__c == 'Joint'){
                           M_J_MarketingBudget = M_J_MarketingBudget + Mon.Y_Total_Amount__c;
                       }else if (Mon.Driven__c == 'Dealer Driven'){
                           M_D_MarketingBudget = M_D_MarketingBudget + Mon.Y_Total_Amount__c;
                       }
                    }else if(Mon.M_Brand__c == 'smart'){
                       S_MarketingBudget = S_MarketingBudget + Mon.Y_Total_Amount__c;
                    }else if(Mon.M_Brand__c == 'AMG'){
                       A_MarketingBudget = A_MarketingBudget + Mon.Y_Total_Amount__c;
                    }
                }
            }
            Year.Y_SMART_Marketing_Budget__c = S_MarketingBudget;
            Year.Y_AMG_Marketing_Budget__c = A_MarketingBudget;
            Year.Y_MB_Marketing_Budget__c = M_MarketingBudget;
            Year.Y_MB_Joint_Marketing_Budget__c = M_J_MarketingBudget;
            Year.Y_MB_Dealer_Driven_Marketing_Budget__c = M_D_MarketingBudget;
        }
        update YearlyList;
    }
    
    if(aSRetailYearlyTAMap.size() > 0){
        Double AS_MarketingCurrentPlannedBudget;
        Double Q1MarketingBudget = 0;
        Double Q2MarketingBudget = 0;
        Double Q3MarketingBudget = 0;
        Double Q4MarketingBudget = 0;
        Double Q1ActualExpense = 0;
        Double Q2ActualExpense = 0;
        Double Q3ActualExpense = 0;
        Double Q4ActualExpense = 0;
        Date Q1EndDate = Date.newInstance(Date.Today().year(), 3, 31);
        Date Q2EndDate = Date.newInstance(Date.Today().year(), 6, 30); 
        Date Q3EndDate = Date.newInstance(Date.Today().year(), 9, 30);
        List<Retail_Campaign__c> CampaignList = [select Plan_Start_Date__c, Actual_Start_Date__c, Actual_Expense__c, Yearly_TA__c, Plan_Expense__c, Apply_Status__c, Feedback_Status__c from Retail_Campaign__c where Yearly_TA__c in :aSRetailYearlyTAMap.values() ];
        List<Retail_Campaign__c> YearlyList = [select id, AS_Marketing_Current_Planned_Budget__c, Y_Year__c from Retail_Campaign__c where id in :aSRetailYearlyTAMap.values() ];
        for(Retail_Campaign__c Year : YearlyList) {
            AS_MarketingCurrentPlannedBudget = 0;
            if(Year.Y_Year__c != null && Integer.valueOf(Year.Y_Year__c) != Date.Today().year()) {
                Q1EndDate = Date.newInstance(Integer.valueOf(Year.Y_Year__c), 3, 31);
                Q2EndDate = Date.newInstance(Integer.valueOf(Year.Y_Year__c), 6, 30); 
                Q3EndDate = Date.newInstance(Integer.valueOf(Year.Y_Year__c), 9, 30);
            }
            for(Retail_Campaign__c Campaign : CampaignList) {
                if(Campaign.Yearly_TA__c == Year.id){
                    if(Campaign.Plan_Expense__c != null && Campaign.Apply_Status__c == 'Approved'){
                        AS_MarketingCurrentPlannedBudget = AS_MarketingCurrentPlannedBudget + Campaign.Plan_Expense__c;
                        
                        if(Campaign.Plan_Start_Date__c <= Q1EndDate) { 
                            Q1MarketingBudget += Campaign.Plan_Expense__c; 
                        } 
                        else if(Campaign.Plan_Start_Date__c <= Q2EndDate) { 
                            Q2MarketingBudget += Campaign.Plan_Expense__c; 
                        }
                        else if(Campaign.Plan_Start_Date__c <= Q3EndDate) { 
                            Q3MarketingBudget += Campaign.Plan_Expense__c; 
                        }
                        else { 
                            Q4MarketingBudget += Campaign.Plan_Expense__c; 
                        }
                    }
                    
                    if(Campaign.Actual_Expense__c != null && Campaign.Feedback_Status__c == 'Approved'){
                        if(Campaign.Actual_Start_Date__c <= Q1EndDate) { 
                            Q1ActualExpense += Campaign.Actual_Expense__c; 
                        } 
                        else if(Campaign.Actual_Start_Date__c <= Q2EndDate) { 
                            Q2ActualExpense += Campaign.Actual_Expense__c; 
                        }
                        else if(Campaign.Actual_Start_Date__c <= Q3EndDate) { 
                            Q3ActualExpense += Campaign.Actual_Expense__c; 
                        }
                        else { 
                            Q4ActualExpense += Campaign.Actual_Expense__c; 
                        }
                    }
                }
            }
            Year.Q1_Actual_Expense__c = Q1ActualExpense; 
            Year.Q2_Actual_Expense__c = Q2ActualExpense; 
            Year.Q3_Actual_Expense__c = Q3ActualExpense; 
            Year.Q4_Actual_Expense__c = Q4ActualExpense; 
            Year.Q1_Marketing_Budget__c = Q1MarketingBudget; 
            Year.Q2_Marketing_Budget__c = Q2MarketingBudget; 
            Year.Q3_Marketing_Budget__c = Q3MarketingBudget; 
            Year.Q4_Marketing_Budget__c = Q4MarketingBudget; 
            Year.AS_Marketing_Current_Planned_Budget__c = AS_MarketingCurrentPlannedBudget;
        }
        update YearlyList;
    }

    List<Task> taskList = new List<Task>();
    Map<id, id> SMyearlyTAMap = new Map<id, id>();
    Map<id, id> ASyearlyTAMap = new Map<id, id>();
    Map<id, id> ASdeleteMap = new Map<id, id>();
    Map<id, id> SMdeleteMap = new Map<id, id>();
    Map<id, Retail_Campaign__c> RCMap = new Map<id, Retail_Campaign__c>();
    for(Retail_Campaign__c cp : trigger.new) {
        if(Trigger.isInsert || (Trigger.isUpdate && cp.Y_Dealer_Name__c != trigger.oldMap.get(cp.id).Y_Dealer_Name__c)) {
            if( cpRecordTypeMap.get('Aftersales Yearly TA').getRecordTypeId()== cp.RecordTypeId){
                ASyearlyTAMap.put(cp.Y_Dealer_Name__c, cp.id);
                RCMap.put(cp.Y_Dealer_Name__c, cp);
            }else if(cpRecordTypeMap.get('Sales & Marketing Yearly TA').getRecordTypeId()== cp.RecordTypeId){
                SMyearlyTAMap.put(cp.Y_Dealer_Name__c, cp.id);
                RCMap.put(cp.Y_Dealer_Name__c, cp);
            }
            if(Trigger.isUpdate && cpRecordTypeMap.get('Aftersales Yearly TA').getRecordTypeId()== cp.RecordTypeId){
                ASdeleteMap.put(trigger.oldMap.get(cp.id).Y_Dealer_Name__c, cp.id);
            }else if(Trigger.isUpdate && cpRecordTypeMap.get('Sales & Marketing Yearly TA').getRecordTypeId()== cp.RecordTypeId){
                SMdeleteMap.put(trigger.oldMap.get(cp.id).Y_Dealer_Name__c, cp.id);
            }
             
        }
    }

    List<User> SMyearlyTAusers = [select AccountId, Id, ContactId from User 
        where  isActive = true and AccountId in  :SMyearlyTAMap.keySet() and Contact.Permission_Set_Settings__c includes ('S_M_Yearly_TA')];

    List<User> ASyearlyTAusers = [select AccountId, Id, ContactId from User 
        where  isActive = true and AccountId in  :ASyearlyTAMap.keySet() and Contact.Permission_Set_Settings__c includes ('AS_Yearly_TA')];

    for(User user : SMyearlyTAusers) {
        csList.add(new Retail_Campaign__Share(ParentId = SMyearlyTAMap.get(user.AccountId),
                                            UserOrGroupId = user.id, 
                                            AccessLevel = 'Edit'));
         if(RCMap.get(user.AccountId).Y_Apply_Deadline__c != NULL){                                   
             taskList.add(RetailCampaignHelper.generateHighPrioTask(user, RCMap.get(user.AccountId), '请于到期截止日前提交年度计划'));
         }                
    }
    for(User user : ASyearlyTAusers) {
        csList.add(new Retail_Campaign__Share(ParentId = ASyearlyTAMap.get(user.AccountId),
                                            UserOrGroupId = user.id,
                                            AccessLevel = 'Edit'));
         if(RCMap.get(user.AccountId).Y_Apply_Deadline__c != NULL){                                   
             taskList.add(RetailCampaignHelper.generateHighPrioTask(user, RCMap.get(user.AccountId), '请于到期截止日前提交年度计划'));
         }                
    }
    List<User> ASdUsers = [select AccountId, Id, ContactId from User 
                            where  isActive = true and AccountId in  :ASdeleteMap.keySet() and Contact.Permission_Set_Settings__c includes ('AS_Retail_Campaign')];
    List<User> SMdUsers = [select AccountId, Id, ContactId from User 
                            where  isActive = true and AccountId in  :SMdeleteMap.keySet() and Contact.Permission_Set_Settings__c includes ('S_M_Retail_Campaign')];

    deleteCsList = [select Id, UserOrGroupId, ParentId, AccessLevel, RowCause from Retail_Campaign__Share
                            where (ParentId = :ASdeleteMap.values() and UserOrGroupId in :ASdUsers) OR (ParentId = :SMdeleteMap.values() and UserOrGroupId in :SMdUsers)];
    if(csList.size() > 0){
        try {
            insert csList;
        }
        catch(Exception ex) {
            System.debug('Exception message is :' + ex.getMessage());
        }
    }
    
    if(taskList.size() > 0){
        try {
            insert taskList;
        }
        catch(Exception ex) {
            System.debug('Exception message is :' + ex.getMessage());
        }
    }
    
    if(deleteCsList.size() > 0) {
        try {
            delete deleteCsList;
        }
        catch(Exception ex) {
            System.debug('Exception message is :' + ex.getMessage());
        }
    }
    
    //Sinow update 2014-Jun-05 - Release1.2 Qulification Process
    if(Trigger.isUpdate) {
        
        Set<Id> parentCampaignIds = new Set<Id>();
        Set<Id> parentCampaignIdsForUpdateQuarter = new Set<Id>();
        for(Retail_Campaign__c cp : trigger.new) {
            if((cp.RecordTypeId == cpRecordTypeMap.get('Retail MB Best Practice').getRecordTypeId() || cp.RecordTypeId == cpRecordTypeMap.get('Retail smart Best Practice').getRecordTypeId())
               && cp.Parent_Campaign__c != null && ((cp.Final_Best_Practice__c && !trigger.oldMap.get(cp.id).Final_Best_Practice__c) || (cp.Final_Best_Practice_Forsmart__c&& !trigger.oldMap.get(cp.id).Final_Best_Practice_Forsmart__c))) {
                parentCampaignIds.add(cp.Parent_Campaign__c);
            }
            if(cp.RecordTypeId == cpRecordTypeMap.get('Retail smart Best Practice').getRecordTypeId()
               && cp.Parent_Campaign__c != null && cp.BP_Status__c == 'Retail Submit' && cp.BP_Status__c != trigger.oldMap.get(cp.id).BP_Status__c) {
                parentCampaignIdsForUpdateQuarter.add(cp.Parent_Campaign__c);
            }
        }
        
        if(parentCampaignIds.size() > 0) {
            RetailCampaignHelper.updateParentCampaignStatus(parentCampaignIds);
        }
        
        if(parentCampaignIdsForUpdateQuarter.size() > 0) {
            RetailCampaignHelper.updateParentCampaignQuarter(parentCampaignIdsForUpdateQuarter);
        }
    }
}