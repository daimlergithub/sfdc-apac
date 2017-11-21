/*
    Type:       Controller Class for MassApproveRetailCampaign Page
    Purpose:    Search and mass approve Retail Campaigns
    HLD:        BRD-Release 1.3 CRs
    Used By:    MassApproveRetailCampaign.page
    ---------------------------------------------------------------
    History:
    
    1. Cyril Created on 2014-10-17

*/

public with sharing class MassApproveRetailCampaignController {
    public List<Retail_Campaign__c> cpnList { get; set; }
    public List<sObject> cpnShowList { get; set; }
    public List<RetailCampaignInfo> cpnsInfo { get; set; }
    public Boolean hasCpn { get; set; }
    public String rtType { get; set; }
    public Retail_Campaign__c cpn { get; set; }
    public String minExpense { get; set; }
    public String maxExpense { get; set; }
    public String city { get; set;}
    public String comment { get; set; }
    public String applyStatus { get; set; }
    public String feedbackStatus { get; set; }
    public Boolean headChecked { get; set; }
    public Paginator paginator {get;set;}
    
    private static String confirmed = 'Confirmed';
    private final String RT_SM_EVENT_RC = 'S&M Event Retail Campaign';
    private final String RT_SM_MEDIA_RC = 'S&M Media Retail Campaign';
    private final String CPN_EVENT = Label.Campaign_Type_Event;
    private final String CPN_MEIDA = Label.Campaign_Type_Media;
    
    public MassApproveRetailCampaignController() {
        hasCpn = false;
        cpnsInfo = new List<RetailCampaignInfo>();
        cpn = new Retail_Campaign__c(RecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get(RT_SM_EVENT_RC).getRecordTypeId(), Driven__c = UtilConstant.Empty, Approver__c = UserInfo.getUserId());
    }
    
    public void query() {
        Set<String> rts = new Set<String>();
        String driven = cpn.Driven__c;
        String cityStr = String.isEmpty(city) ? UtilConstant.Empty : city.trim();
        cityStr = String.isEmpty(cityStr) ? UtilConstant.Empty : ('%' + cityStr + '%');
        Id dealer = cpn.Dealer_Name__c;
        Id approver = cpn.Approver__c;
        String brand = cpn.Brand__c;
        String carModel = cpn.Car_Model__c;
        Date planStartDate = cpn.Plan_Start_Date__c;
        Date planEndDate = cpn.Plan_End_Date__c;
        Date actualStartDate = cpn.Actual_Start_Date__c;
        Date actualEndDate = cpn.Actual_End_Date__c;
        Double minExp = cpn.Min_Expense__c;
        Double maxExp = cpn.Max_Expense__c;
        Set<String> approveApplyStatus = new Set<String> {'Confirmed', 'Cancel Application'};
        String approveFeedbackStatus = confirmed;
        String queryStr = 'SELECT Id, ' + this.getColumns() + 'Name FROM Retail_Campaign__c WHERE';
        String[] carModles = carModel == null ? null : carModel.split(';', 0);
        
        if (rtType == RT_SM_EVENT_RC) {
            rts.add(RT_SM_EVENT_RC);
        } else if (rtType == RT_SM_MEDIA_RC) {
            rts.add(RT_SM_MEDIA_RC);
        } else {
            rts.add(RT_SM_MEDIA_RC);
            rts.add(RT_SM_EVENT_RC);
        }
        
        queryStr = queryStr + (String.isEmpty(driven) ? UtilConstant.Empty : ' Driven__c = :driven AND');
        queryStr = queryStr + (String.isEmpty(cityStr) ? UtilConstant.Empty : ' City__c LIKE :cityStr AND');
        queryStr = queryStr + (dealer == null ? UtilConstant.Empty : ' Dealer_Name__c = :dealer AND');
        queryStr = queryStr + (approver == null ? UtilConstant.Empty : ' Approver__c = :approver AND');
        if (String.isEmpty(applyStatus) && String.isEmpty(feedbackStatus)) {
            queryStr = queryStr + ' (Apply_Status__c IN :approveApplyStatus OR Feedback_Status__c = :approveFeedbackStatus) AND';
        } else if(String.isEmpty(applyStatus)) {
            queryStr = queryStr + ' Feedback_Status__c = :feedbackStatus AND';
        } else if (String.isEmpty(feedbackStatus)) {
            queryStr = queryStr + ' Apply_Status__c = :applyStatus AND';
        } else {
            queryStr = queryStr + ' Feedback_Status__c = :feedbackStatus AND Apply_Status__c = :applyStatus AND';
        }
        queryStr = queryStr + (brand == null ? UtilConstant.Empty : ' Brand__c = :brand AND');
        if (carModles != null) {
            queryStr = queryStr + ' Car_Model__c INCLUDES(';
            for (String cm : carModles) {
                queryStr = queryStr + '\'' + cm + '\', ';
            }
            queryStr = queryStr.removeEnd(', ') + ') AND';
        }
        queryStr = queryStr + (minExp == -1 ? UtilConstant.Empty : ' Plan_Expense__c >= :minExp AND');
        queryStr = queryStr + (maxExp == -1 ? UtilConstant.Empty : ' Plan_Expense__c <= :maxExp AND');
        queryStr = queryStr + (planStartDate == null ? UtilConstant.Empty : ' Plan_Start_Date__c = :planStartDate AND');
        queryStr = queryStr + (planEndDate == null ? UtilConstant.Empty : ' Plan_End_Date__c = :planEndDate AND');
        queryStr = queryStr + (actualStartDate == null ? UtilConstant.Empty : ' Actual_Start_Date__c = :actualStartDate AND');
        queryStr = queryStr + (actualEndDate == null ? UtilConstant.Empty : ' Actual_End_Date__c = :actualEndDate AND');
        queryStr = queryStr + ' RecordType.Name IN :rts ORDER BY Dealer_Name__c, Campaign_Code__c ASC LIMIT 1000';
        cpnList = Database.query(queryStr);
        
        if (cpnList.size() == 0) ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, Label.CP_No_Search_Result));
        if (cpnList.size() == 1000) ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, Label.Message_Max_Size_1000));
        
        paginator = new Paginator(50, cpnList);
        cpnsInfo.clear();
        cpnShowList = paginator.getFirstPage();
        for (sObject cpn : cpnShowList) {
            if (cpn != null && cpn.Id != null) cpnsInfo.add(new RetailCampaignInfo(false, (Retail_Campaign__c)cpn));
        }
        hasCpn = !(cpnsInfo.isEmpty());
        headChecked = false;
    }
    
    public void approve() {
        Integer validNum = 0;
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        for (RetailCampaignInfo info : cpnsInfo) {
            if(info.checked == false) continue;
            MyProcess process = new MyProcess(info.cpn.id);
            if(!(process.hasMyStep)) continue;
            validNum = validNum + 1;
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setNextApproverIds(null);
            req.setWorkitemId(process.workItemId);
            req.setComments(comment);
            req.setAction('Approve');
            requests.add(req);
        }
        
        if (validNum == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.Message_No_Valid_Records));
        } else {
            Approval.ProcessResult[] results = Approval.process(requests, false);
            Boolean isSuccess = true;
            for (Approval.ProcessResult rs : results) {
                if (!rs.isSuccess()) {
                    isSuccess = false;
                    break;
                }
            }
            
            if (!isSuccess) ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.Message_Approve_Failed));
            if (isSuccess) ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, Label.Message_Approve_Success));
        }
        
        query();
    }
    
    public List<SelectOption> getApplyStatusOptions(){
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption(UtilConstant.Empty, Label.Select_Option_None));
        options.add(new SelectOption(confirmed, Label.Status_Confirmed));
        options.add(new SelectOption('Cancel Application', Label.Status_Cancel_Application));
        options.add(new SelectOption('Approved', Label.Status_Approved));
        return options;
    }
    
    public List<SelectOption> getFeedbackStatusOptions(){
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption(UtilConstant.Empty, Label.Select_Option_None));
        options.add(new SelectOption(confirmed, Label.Status_Confirmed));
        options.add(new SelectOption('Approved', Label.Status_Approved));
        return options;
    }
    
    public List<SelectOption> getRecordTypes(){
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption(UtilConstant.Empty, Label.Select_Option_None));
        options.add(new SelectOption(RT_SM_MEDIA_RC, CPN_MEIDA));
        options.add(new SelectOption(RT_SM_EVENT_RC, CPN_EVENT));
        return options;
    }
    
    private String getColumns() {
        String columns = UtilConstant.Empty;
        for (Schema.FieldSetMember member : this.getFieldSetMembers()) {
            columns += member.getFieldPath() + ', ';
        }
        
        return columns;
    }
    
    private List<Schema.FieldSetMember> getFieldSetMembers() {
        return SObjectType.Retail_Campaign__c.FieldSets.RetailCampaignInfo.getFields();
    }
    
    public class RetailCampaignInfo{
        public RetailCampaignInfo(Boolean checked, Retail_Campaign__c cpn){
            this.checked = checked;
            this.cpn = cpn;
        }
        
        public Boolean checked { get; set; }
        public Retail_Campaign__c cpn { get; set; }
    }
    
    public boolean hasPrev{
        get{
            return paginator.isPreviousPageAvailable;
        }set;
    }
    
    public boolean hasNext{
        get{
           return paginator.isNextPageAvailable;
        }set;
    }
    
    public void previous() {
        cpnsInfo.clear();
        cpnShowList = paginator.getPreviousPage();
        for (sObject cpn : cpnShowList) {
            if (cpn != null && cpn.Id != null) cpnsInfo.add(new RetailCampaignInfo(false, (Retail_Campaign__c)cpn));
        }
        hasCpn = !(cpnsInfo.isEmpty());
        headChecked = false;
    }
    
    public void next() {
        cpnsInfo.clear();
        cpnShowList = paginator.getNextPage();
        for (sObject cpn : cpnShowList) {
            if (cpn != null && cpn.Id != null) cpnsInfo.add(new RetailCampaignInfo(false, (Retail_Campaign__c)cpn));
        }
        hasCpn = !(cpnsInfo.isEmpty());
        headChecked = false;
    }
    
    public void first() {
        cpnsInfo.clear();
        cpnShowList = paginator.getFirstPage();
        for (sObject cpn : cpnShowList) {
            if (cpn != null && cpn.Id != null) cpnsInfo.add(new RetailCampaignInfo(false, (Retail_Campaign__c)cpn));
        }
        hasCpn = !(cpnsInfo.isEmpty());
        headChecked = false;
    }
    
    public void last() {
        cpnsInfo.clear();
        cpnShowList = paginator.getLastPage();
        for (sObject cpn : cpnShowList) {
            if (cpn != null && cpn.Id != null) cpnsInfo.add(new RetailCampaignInfo(false, (Retail_Campaign__c)cpn));
        }
        hasCpn = !(cpnsInfo.isEmpty());
        headChecked = false;
    }
    
    public String recordNumbering {
        get {
            if(cpnShowList != null) {
                return paginator.getShowingFrom() + '-' + paginator.getShowingTo() + ' ' + Label.Page_Element_Of + ' ' + paginator.totalResults;
            }
            return '';
        }set;
    }
}