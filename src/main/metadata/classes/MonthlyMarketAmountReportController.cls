public  with sharing class MonthlyMarketAmountReportController {
    public MonthlyMarketAmount MonthlyMarketAmount { get; set; }
    public MonthlyMarketAmountReportController () {
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName();
        MonthlyMarketAmount = new MonthlyMarketAmount();
        Set<Id> dealerMediaDealerIds = new Set<Id>();
        Set<Id> dealerEventDealerIds = new Set<Id>();
        Set<Id> jointMediaDealerIds = new Set<Id>();
        Set<Id> jointEventDealerIds = new Set<Id>();

        for(Retail_Campaign__c retailCam : [select Id, Driven__c, RecordTypeId, Plan_Expense__c, Dealer_Name__c
                                        from Retail_Campaign__c where Plan_End_Date__c >= :System.today().toStartOfMonth() and Plan_End_Date__c <= :System.today().addMonths(1).toStartOfMonth().addDays(-1) and Apply_Status__c ='Approved' and (RecordTypeId = :cpRecordTypeMap.get('S&M Event Retail Campaign').getRecordTypeId() OR RecordTypeId = :cpRecordTypeMap.get('S&M Media Retail Campaign').getRecordTypeId()) ]) {
                 if(retailCam.Plan_Expense__c == null){
                     retailCam.Plan_Expense__c = 0;
                 }                       
            if(retailCam.Driven__c == 'Dealer Driven'){
                if(retailCam.RecordTypeId == cpRecordTypeMap.get('S&M Media Retail Campaign').getRecordTypeId()){
                    MonthlyMarketAmount.dealerMediaExpense = MonthlyMarketAmount.dealerMediaExpense + retailCam.Plan_Expense__c;
                    dealerMediaDealerIds .add(retailCam.Dealer_Name__c);
                    MonthlyMarketAmount.dealerMediaCampaignNumber = MonthlyMarketAmount.dealerMediaCampaignNumber + 1;
                }else if(retailCam.RecordTypeId == cpRecordTypeMap.get('S&M Event Retail Campaign').getRecordTypeId()){
                    MonthlyMarketAmount.dealerEventExpense = MonthlyMarketAmount.dealerEventExpense + retailCam.Plan_Expense__c;
                    dealerEventDealerIds .add(retailCam.Dealer_Name__c);
                    MonthlyMarketAmount.dealerEventCampaignNumber = MonthlyMarketAmount.dealerEventCampaignNumber + 1;
                }
                MonthlyMarketAmount.dealerTotalExpense = MonthlyMarketAmount.dealerTotalExpense + retailCam.Plan_Expense__c;
                MonthlyMarketAmount.dealerTotalCampaignNumber = MonthlyMarketAmount.dealerTotalCampaignNumber + 1;
            }else if(retailCam.Driven__c == 'Joint'){ 
                if(retailCam.RecordTypeId == cpRecordTypeMap.get('S&M Media Retail Campaign').getRecordTypeId()){
                    MonthlyMarketAmount.JointMediaExpense = MonthlyMarketAmount.JointMediaExpense + retailCam.Plan_Expense__c;
                    jointMediaDealerIds .add(retailCam.Dealer_Name__c);
                    MonthlyMarketAmount.JointMediaCampaignNumber = MonthlyMarketAmount.JointMediaCampaignNumber + 1;
                }else if(retailCam.RecordTypeId == cpRecordTypeMap.get('S&M Event Retail Campaign').getRecordTypeId()){
                    MonthlyMarketAmount.JointEventExpense = MonthlyMarketAmount.JointEventExpense + retailCam.Plan_Expense__c;
                    jointEventDealerIds .add(retailCam.Dealer_Name__c);
                    MonthlyMarketAmount.JointEventCampaignNumber = MonthlyMarketAmount.JointEventCampaignNumber + 1;
                }
                MonthlyMarketAmount.JointTotalExpense = MonthlyMarketAmount.JointTotalExpense + retailCam.Plan_Expense__c;
                MonthlyMarketAmount.JointTotalCampaignNumber = MonthlyMarketAmount.JointTotalCampaignNumber + 1;
            }
        }
        MonthlyMarketAmount.dealerMediaDealerNumber = dealerMediaDealerIds.size();
        MonthlyMarketAmount.dealerEventDealerNumber = dealerEventDealerIds.size();
        MonthlyMarketAmount.dealerTotalDealerNumber = MonthlyMarketAmount.dealerMediaDealerNumber + MonthlyMarketAmount.dealerEventDealerNumber;
        MonthlyMarketAmount.JointMediaDealerNumber = jointMediaDealerIds.size();
        MonthlyMarketAmount.JointEventDealerNumber = jointEventDealerIds.size();
        MonthlyMarketAmount.JointTotalDealerNumber = MonthlyMarketAmount.JointMediaDealerNumber + MonthlyMarketAmount.JointEventDealerNumber;
        if(MonthlyMarketAmount.dealerTotalExpense== 0){
            MonthlyMarketAmount.dealerMediaPersent = 0.00;
            MonthlyMarketAmount.dealerEventPersent = 0.00;
        }else{
            MonthlyMarketAmount.dealerMediaPersent =(MonthlyMarketAmount.dealerMediaExpense * 100 / MonthlyMarketAmount.dealerTotalExpense ).setScale(2);
            MonthlyMarketAmount.dealerEventPersent =(MonthlyMarketAmount.dealerEventExpense * 100 / MonthlyMarketAmount.dealerTotalExpense ).setScale(2);
        }
        if(MonthlyMarketAmount.JointTotalExpense == 0){
            MonthlyMarketAmount.JointMediaPersent = 0.00;
            MonthlyMarketAmount.JointEventPersent = 0.00;
        }else{
            MonthlyMarketAmount.JointMediaPersent =(MonthlyMarketAmount.JointMediaExpense * 100 / MonthlyMarketAmount.JointTotalExpense ).setScale(2);
            MonthlyMarketAmount.JointEventPersent =(MonthlyMarketAmount.JointEventExpense * 100 / MonthlyMarketAmount.JointTotalExpense ).setScale(2);
        }
        MonthlyMarketAmount.TotalExpense = MonthlyMarketAmount.dealerTotalExpense+ MonthlyMarketAmount.JointTotalExpense;
        MonthlyMarketAmount.TotalPersent = 100.00;
        MonthlyMarketAmount.dealerTotalPersent = MonthlyMarketAmount.dealerMediaPersent + MonthlyMarketAmount.dealerEventPersent ;
        MonthlyMarketAmount.JointTotalPersent = MonthlyMarketAmount.JointMediaPersent + MonthlyMarketAmount.JointEventPersent ;
        MonthlyMarketAmount.TotalDealerNumber = MonthlyMarketAmount.dealerTotalDealerNumber + MonthlyMarketAmount.jointTotalDealerNumber ;
        MonthlyMarketAmount.TotalCampaignNumber = MonthlyMarketAmount.dealerTotalCampaignNumber + MonthlyMarketAmount.JointTotalCampaignNumber ;

    }
    public class  MonthlyMarketAmount{
        public MonthlyMarketAmount() {
            this.dealerMediaExpense = 0;
            this.dealerEventExpense = 0;
            this.dealerTotalExpense = 0;
            this.JointMediaExpense = 0;
            this.JointEventExpense = 0;
            this.JointTotalExpense = 0;
            this.dealerMediaPersent = 0;
            this.dealerEventPersent = 0;
            this.dealerTotalPersent = 0;
            this.JointMediaPersent = 0;
            this.JointEventPersent = 0;
            this.JointTotalPersent = 0;
            this.dealerMediaDealerNumber = 0;
            this.dealerEventDealerNumber = 0;
            this.dealerTotalDealerNumber = 0;
            this.JointMediaDealerNumber = 0;
            this.JointEventDealerNumber = 0;
            this.JointTotalDealerNumber = 0;
            this.dealerMediaCampaignNumber = 0;
            this.dealerEventCampaignNumber = 0;
            this.dealerTotalCampaignNumber = 0;
            this.JointMediaCampaignNumber = 0;
            this.JointEventCampaignNumber = 0;
            this.JointTotalCampaignNumber = 0;
            this.TotalCampaignNumber = 0;
            this.TotalDealerNumber = 0;
            this.TotalPersent = 0;
            this.TotalExpense= 0;
        }
        public decimal dealerMediaExpense { get; set; }
        public decimal dealerEventExpense { get; set; }
        public decimal dealerTotalExpense { get; set; }
        public decimal JointMediaExpense { get; set; }
        public decimal JointEventExpense { get; set; }
        public decimal JointTotalExpense { get; set; }
        public decimal dealerMediaPersent { get; set; }
        public decimal dealerEventPersent { get; set; }
        public decimal dealerTotalPersent { get; set; }
        public decimal JointMediaPersent { get; set; }
        public decimal JointEventPersent { get; set; }
        public decimal JointTotalPersent { get; set; }
        public decimal dealerMediaDealerNumber { get; set; }
        public decimal dealerEventDealerNumber { get; set; }
        public decimal dealerTotalDealerNumber { get; set; }
        public decimal JointMediaDealerNumber { get; set; }
        public decimal JointEventDealerNumber { get; set; }
        public decimal JointTotalDealerNumber { get; set; }
        public decimal dealerMediaCampaignNumber { get; set; }
        public decimal dealerEventCampaignNumber { get; set; }
        public decimal dealerTotalCampaignNumber { get; set; }
        public decimal JointMediaCampaignNumber { get; set; }
        public decimal JointEventCampaignNumber { get; set; }
        public decimal JointTotalCampaignNumber { get; set; }
        public decimal TotalCampaignNumber { get; set; }
        public decimal TotalDealerNumber { get; set; }
        public decimal TotalPersent { get; set; }
        public decimal TotalExpense{ get; set; }
    }
}