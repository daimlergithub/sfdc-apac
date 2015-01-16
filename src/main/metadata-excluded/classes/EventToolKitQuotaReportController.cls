public without sharing class EventToolKitQuotaReportController {

    public Event_Tool_Kit_Quota__c EastQuota { get; set; }
    public Event_Tool_Kit_Quota__c SouthQuota { get; set; }
    public Event_Tool_Kit_Quota__c WestQuota { get; set; }
    public Event_Tool_Kit_Quota__c NorthQuota { get; set; }
    public toolkitAmount EastToolAmount { get; set; }
    public toolkitAmount SouthToolAmount { get; set; }
    public toolkitAmount WestToolAmount { get; set; }
    public toolkitAmount NorthToolAmount { get; set; }
    
    public EventToolKitQuotaReportController() {
        
        for(Event_Tool_Kit_Quota__c quota : [select Id, Name, Q1_Amount__c, Q2_Amount__c, Q3_Amount__c, Q4_Amount__c from Event_Tool_Kit_Quota__c]) {
            if(quota.Name == 'EAST') {
                EastQuota = quota;
            }
            if(quota.Name == 'WEST') {
                WestQuota = quota;
            }
            if(quota.Name == 'SOUTH') {
                SouthQuota = quota;
            }
            if(quota.Name == 'NORTH') {
                NorthQuota = quota;
            }
        }
        
        EastToolAmount = new toolkitAmount();
        SouthToolAmount = new toolkitAmount();
        WestToolAmount = new toolkitAmount();
        NorthToolAmount = new toolkitAmount();
        Date Q1StartDate = Date.newInstance(Date.Today().year(), 1, 1);
        Date Q1EndDate = Date.newInstance(Date.Today().year(), 3, 31);
        Date Q2StartDate = Date.newInstance(Date.Today().year(), 4, 1);
        Date Q2EndDate = Date.newInstance(Date.Today().year(), 6, 30);
        Date Q3StartDate = Date.newInstance(Date.Today().year(), 7, 1);
        Date Q3EndDate = Date.newInstance(Date.Today().year(), 9, 30);
        Date Q4StartDate = Date.newInstance(Date.Today().year(), 10, 1);
        Date Q4EndDate = Date.newInstance(Date.Today().year(), 12, 31);
        
        for(Tool_Kit__c toolkit : [select Id, Region__c, Submit_Date__c from Tool_Kit__c 
                                   where (Apply_Status__c = 'Approved' or Apply_Status__c = 'Tool Kit Finished')
                                   and Submit_Date__c >= :Q1StartDate and Submit_Date__c <= :Q4EndDate and recordType.Name = 'Event']) {
            if(toolkit.Region__c == 'EAST') {
                if(toolkit.Submit_Date__c <= Q1EndDate) {
                    EastToolAmount.Q1Amount += 1;
                }
                else if(toolkit.Submit_Date__c >= Q2StartDate && toolkit.Submit_Date__c <= Q2EndDate) {
                    EastToolAmount.Q2Amount += 1;
                }
                else if(toolkit.Submit_Date__c >= Q3StartDate && toolkit.Submit_Date__c <= Q3EndDate) {
                    system.debug('---------' + toolkit.Id);
                    EastToolAmount.Q3Amount += 1;
                }
                else if(toolkit.Submit_Date__c >= Q4StartDate && toolkit.Submit_Date__c <= Q4EndDate) {
                    EastToolAmount.Q4Amount += 1;
                }
            }
            else if(toolkit.Region__c == 'WEST') {
                if(toolkit.Submit_Date__c <= Q1EndDate) {
                    WestToolAmount.Q1Amount += 1;
                }
                else if(toolkit.Submit_Date__c >= Q2StartDate && toolkit.Submit_Date__c <= Q2EndDate) {
                    WestToolAmount.Q2Amount += 1;
                }
                else if(toolkit.Submit_Date__c >= Q3StartDate && toolkit.Submit_Date__c <= Q3EndDate) {
                    WestToolAmount.Q3Amount += 1;
                }
                else if(toolkit.Submit_Date__c >= Q4StartDate && toolkit.Submit_Date__c <= Q4EndDate) {
                    WestToolAmount.Q4Amount += 1;
                }
            }
            else if(toolkit.Region__c == 'SOUTH') {
                if(toolkit.Submit_Date__c <= Q1EndDate) {
                    SouthToolAmount.Q1Amount += 1;
                }
                else if(toolkit.Submit_Date__c >= Q2StartDate && toolkit.Submit_Date__c <= Q2EndDate) {
                    SouthToolAmount.Q2Amount += 1;
                }
                else if(toolkit.Submit_Date__c >= Q3StartDate && toolkit.Submit_Date__c <= Q3EndDate) {
                    SouthToolAmount.Q3Amount += 1;
                }
                else if(toolkit.Submit_Date__c >= Q4StartDate && toolkit.Submit_Date__c <= Q4EndDate) {
                    SouthToolAmount.Q4Amount += 1;
                }
            }
            else if(toolkit.Region__c == 'NORTH') {
                if(toolkit.Submit_Date__c <= Q1EndDate) {
                    NorthToolAmount.Q1Amount += 1;
                }
                else if(toolkit.Submit_Date__c >= Q2StartDate && toolkit.Submit_Date__c <= Q2EndDate) {
                    NorthToolAmount.Q2Amount += 1;
                }
                else if(toolkit.Submit_Date__c >= Q3StartDate && toolkit.Submit_Date__c <= Q3EndDate) {
                    NorthToolAmount.Q3Amount += 1;
                }
                else if(toolkit.Submit_Date__c >= Q4StartDate && toolkit.Submit_Date__c <= Q4EndDate) {
                    NorthToolAmount.Q4Amount += 1;
                }
            }    
        }
    }
    
    Public class toolkitAmount {
        public toolkitAmount() {
            Q1Amount = 0;
            Q2Amount = 0;
            Q3Amount = 0;
            Q4Amount = 0;
        }
        public Integer Q1Amount { get; set; }
        public Integer Q2Amount { get; set; }
        public Integer Q3Amount { get; set; }
        public Integer Q4Amount { get; set; }
    }
}