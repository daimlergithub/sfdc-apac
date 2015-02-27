/*
    Type:       Controller Class for MassApproveToolKit Page
    Purpose:    Search and mass approve Tool Kits
    HLD:        BRD-Release 1.3 CRs
    Used By:    MassApproveToolKit.page
    ---------------------------------------------------------------
    History:
    
    1. Cyril Created on 2014-10-17

*/

public with sharing class MassApproveToolKitController {
    public List<Tool_Kit__c> toolKitList { get; set; }
    public List<sObject> toolKitShowList { get; set; }
    public List<ToolKitInfo> toolKitsInfo { get; set; }
    public Boolean hasQueryResult { get; set; }
    public String city { get; set;}
    public String region { get; set;}
    public String subRegion { get; set;}
    public String rtType { get; set; }
    public String comment { get; set; }
    public String applyStatus { get; set; }
    public String feedbackStatus { get; set; }
    public Boolean headChecked { get; set; }
    public Tool_Kit__c toolKit { get; set; }
    public Paginator paginator {get;set;}
    
    private final String RT_EVENT_TK = 'Event';
    private final String RT_MEDIA_TK = 'Media';
    private final String TK_EVENT = Label.Tool_Kit_Type_Event;
    private final String TK_MEDIA = Label.Tool_Kit_Type_Media;
    
    public MassApproveToolKitController() {
        hasQueryResult = false;
        toolKitsInfo = new List<ToolKitInfo>();
        toolKit = new Tool_Kit__c(RecordTypeId = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get(RT_EVENT_TK).getRecordTypeId(), Approver__c = UserInfo.getUserId());
    }
    
    public void query() {
        Set<String> rts = new Set<String>();
        String cityStr = String.isEmpty(city) ? '' : city.trim();
        cityStr = String.isEmpty(cityStr) ? '' : ('%' + cityStr + '%');
        Id dealer = toolKit.Dealer_Name__c;
        Id approver = toolKit.Approver__c;
        String brand = toolKit.Brand__c;
        String mediaType = toolKit.Media_Type__c;
        Date planStartDate = toolKit.Plan_Start_Date__c;
        Date planEndDate = toolKit.Plan_End_Date__c;
        Date actualStartDate = toolKit.Actual_Start_Date__c;
        Date actualEndDate = toolKit.Actual_End_Date__c;
        Date deliverDate = toolKit.Deliver_Date__c;
        Set<String> approveApplyStatus = new Set<String> {'Confirmed', 'Cancel Application'};
        String approveFeedbackStatus = 'Confirmed';
        String queryStr = 'SELECT Id, ' + this.getColumns() + 'Name FROM Tool_Kit__c WHERE';
        
        if (rtType == RT_EVENT_TK) {
            rts.add(RT_EVENT_TK);
        } else if (rtType == RT_MEDIA_TK) {
            rts.add(RT_MEDIA_TK);
        } else {
            rts.add(RT_EVENT_TK);
            rts.add(RT_MEDIA_TK);
        }
        
        queryStr = queryStr + (String.isEmpty(region) ? '' : ' Dealer_Region__c = :region AND');
        queryStr = queryStr + (String.isEmpty(subRegion) ? '' : ' Dealer_Sub_Region__c = :subRegion AND');
        queryStr = queryStr + (String.isEmpty(cityStr) ? '' : ' City__c LIKE :cityStr AND');
        queryStr = queryStr + (dealer == null ? '' : ' Dealer_Name__c = :dealer AND');
        queryStr = queryStr + (approver == null ? '' : ' Approver__c = :approver AND');
        if (String.isEmpty(applyStatus) && String.isEmpty(feedbackStatus)) {
            queryStr = queryStr + ' (Apply_Status__c IN :approveApplyStatus OR Feedback_Status__c = :approveFeedbackStatus) AND';
        } else if(String.isEmpty(applyStatus)) {
            queryStr = queryStr + ' Feedback_Status__c = :feedbackStatus AND';
        } else if (String.isEmpty(feedbackStatus)) {
            queryStr = queryStr + ' Apply_Status__c = :applyStatus AND';
        } else {
            queryStr = queryStr + ' Feedback_Status__c = :feedbackStatus AND Apply_Status__c = :applyStatus AND';
        }
        queryStr = queryStr + (brand == null ? '' : ' Brand__c = :brand AND');
        queryStr = queryStr + (planStartDate == null ? '' : ' Plan_Start_Date__c = :planStartDate AND');
        queryStr = queryStr + (planEndDate == null ? '' : ' Plan_End_Date__c = :planEndDate AND');
        queryStr = queryStr + (actualStartDate == null ? '' : ' Actual_Start_Date__c = :actualStartDate AND');
        queryStr = queryStr + (actualEndDate == null ? '' : ' Actual_End_Date__c = :actualEndDate AND');
        queryStr = queryStr + (mediaType == null ? '' : ' Media_Type__c = :mediaType AND');
        queryStr = queryStr + (actualEndDate == null ? '' : ' Actual_End_Date__c = :actualEndDate AND');
        queryStr = queryStr + (deliverDate == null ? '' : ' Deliver_Date__c = :deliverDate AND');
        queryStr = queryStr + ' RecordType.Name IN :rts LIMIT 1000';
        List<Tool_Kit__c> toolKits = Database.query(queryStr);
        
        if (toolKits.size() == 0) ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, Label.CP_No_Search_Result));
        if (toolKits.size() == 1000) ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, Label.Message_Max_Size_1000));
        
        paginator = new Paginator(50, toolKits);
        toolKitsInfo.clear();
        toolKitShowList = paginator.getFirstPage();
        for (sObject tk : toolKitShowList) {
            if (tk != null && tk.Id != null) toolKitsInfo.add(new ToolKitInfo(false, (Tool_Kit__c)tk));
        }
        hasQueryResult = !(toolKitsInfo.isEmpty());
        headChecked = false;
    }
    
    public void approve() {
        Integer validNum = 0;
        List<Approval.ProcessWorkitemRequest> requests = new List<Approval.ProcessWorkitemRequest>();
        for (ToolKitInfo info : toolKitsInfo) {
            if(info.isToApprove == false) continue;
            MyProcess process = new MyProcess(info.toolKit.id);
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
        Set<String> recordTypes = new Set<String>();
        options.add(new SelectOption('', Label.Select_Option_None));
        options.add(new SelectOption('Confirmed', Label.Status_Confirmed));
        options.add(new SelectOption('Cancel Application', Label.Status_Cancel_Application));
        return options;
    }
    
    public List<SelectOption> getFeedbackStatusOptions(){
        List<SelectOption> options = new List<SelectOption>();
        Set<String> recordTypes = new Set<String>();
        options.add(new SelectOption('', Label.Select_Option_None));
        options.add(new SelectOption('Confirmed', Label.Status_Confirmed));
        return options;
    }
    
    public List<SelectOption> getRecordTypes(){
        List<SelectOption> options = new List<SelectOption>();
        Set<String> recordTypes = new Set<String>();
        options.add(new SelectOption('', Label.Select_Option_None));
        options.add(new SelectOption(RT_EVENT_TK, TK_EVENT));
        options.add(new SelectOption(RT_MEDIA_TK, TK_MEDIA));
        return options;
    }
    
    public List<SelectOption> getRegions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', Label.Select_Option_None));
        Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account.fields.Dealer_Region__c;
        for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
            options.add(new SelectOption(entry.getValue(), (UserInfo.getLanguage() == 'en_US' ? entry.getLabel() : (((entry.getLabel().replace('North', 'North')).replace('South','South')).replace('West', 'Western')).replace('East', 'East'))));
        }
        return options;
    }
    
    public List<SelectOption> getSubRegions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', Label.Select_Option_None));
        Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account.fields.Dealer_MB_Sub_Region__c;
        for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
            options.add(new SelectOption(entry.getValue(), (UserInfo.getLanguage() == 'en_US' ? entry.getLabel() : ((((entry.getLabel().replace('North', 'NorthSide')).replace('South','SouthSide')).replace('West', 'WesternSide')).replace('East', 'EastSide').replace('EAST', 'EastSide')))));
        }
        return options;
    }
    
    private String getColumns() {
        String columns = '';
        for (Schema.FieldSetMember member : this.getFieldSetMembers()) {
            columns += member.getFieldPath() + ', ';
        }
        return columns;
    }
    
    private List<Schema.FieldSetMember> getFieldSetMembers() {
        return SObjectType.Tool_Kit__c.FieldSets.ToolKitInfo.getFields();
    }
    
    public class ToolKitInfo{
        public Boolean isToApprove { get; set; }
        public Tool_Kit__c toolKit { get; set; }
        
        public ToolKitInfo(Boolean isToApprove, Tool_Kit__c toolKit){
            this.isToApprove = isToApprove;
            this.toolKit = toolKit;
        }
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
        toolKitsInfo.clear();
        toolKitShowList = paginator.getPreviousPage();
        for (sObject tk : toolKitShowList) {
            if (tk != null && tk.Id != null) toolKitsInfo.add(new ToolKitInfo(false, (Tool_Kit__c)tk));
        }
        hasQueryResult = !(toolKitsInfo.isEmpty());
        headChecked = false;
    }
    
    public void next() {
        toolKitsInfo.clear();
        toolKitShowList = paginator.getNextPage();
        for (sObject tk : toolKitShowList) {
            if (tk != null && tk.Id != null) toolKitsInfo.add(new ToolKitInfo(false, (Tool_Kit__c)tk));
        }
        hasQueryResult = !(toolKitsInfo.isEmpty());
        headChecked = false;
    }
    
    public void first() {
        toolKitsInfo.clear();
        toolKitShowList = paginator.getFirstPage();
        for (sObject tk : toolKitShowList) {
            if (tk != null && tk.Id != null) toolKitsInfo.add(new ToolKitInfo(false, (Tool_Kit__c)tk));
        }
        hasQueryResult = !(toolKitsInfo.isEmpty());
        headChecked = false;
    }
    
    public void last() {
        toolKitsInfo.clear();
        toolKitShowList = paginator.getLastPage();
        for (sObject tk : toolKitShowList) {
            if (tk != null && tk.Id != null) toolKitsInfo.add(new ToolKitInfo(false, (Tool_Kit__c)tk));
        }
        hasQueryResult = !(toolKitsInfo.isEmpty());
        headChecked = false;
    }
    
    public String recordNumbering {
        get {
            if(toolKitShowList != null) {
                return paginator.getShowingFrom() + '-' + paginator.getShowingTo() + ' ' + Label.Page_Element_Of + ' ' + paginator.totalResults;
            }
            return '';
        }set;
    }
}