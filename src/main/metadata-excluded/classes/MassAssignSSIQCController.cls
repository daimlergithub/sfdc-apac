/*
    Type:       Page Controller
    ---------------------------------------------------------------
    History:
    
    1. 2014-03-12 Created By Justin Yu
*/
public class MassAssignSSIQCController {
    
    private List<QC__c> qcs;
    
    public MassAssignSSIQCController(){
        qcs = new List<QC__c>();
        taskHandler = new OB_Task_Handing__c( QC_Found__c = 0);
        assignType = 'Assignment';
    }
    
    public OB_Task_Handing__c taskHandler { get; set; }
    public String subject { get; set; }
    public String assignType { get; set; }
    public String userIdString { get; set; }
    
    public List<SelectOption> getSubjects(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
        for(Schema.RecordTypeInfo recordTypeInfo : Survey_Result__c.SObjectType.getDescribe().getRecordTypeInfos()){
            options.add(new SelectOption(recordTypeInfo.getName(), recordTypeInfo.getName()));
        }
        options.remove(options.size() - 1);
        return options;
    }
    
    public List<SelectOption> getAssignTypeOptions(){
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = OB_Task_Handing__c.Assign_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();       
        for(Schema.PicklistEntry f : ple){
            options.add(new SelectOption(f.getValue(),f.getLabel()));
        }
        return options;
    }
    
    public PageReference applyFilter(){
        try{
            qcs = Database.query(getQueryString());
            taskHandler.QC_Found__c = qcs.size();
        }
        catch(DMLException ex){
            ApexPages.addMessages(ex);
        }
        return null;
    }
    
    public PageReference assignQC(){
        
        if(taskHandler.QC_Found__c == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Not_Found_QC));
            return null;
        }
        if(userIdString == null || userIdString.length() == 0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Label.Select_User));
            return null;
        }
        
        List<String> userIds = userIdString.split(';');
        Integer userSize = userIds.size();
        
        for(Integer i = 0, length = qcs.size(); i < length; i++){
            Integer j = Math.mod(i, userSize);
            qcs[i].OwnerId = userIds[j];
        }
        
        try{
            update qcs;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, Label.QC_Assigned_Successfully));
        }
        catch(DMLException ex){
            ApexPages.addMessages(ex);
        }
        
        return null;
    }
    
    private String getQueryString(){
        String soql = 'select OwnerId from QC__c where RecordTypeId = \'01290000000rXmWAAU\' and Status__c = \'New\'';
        if(!String.isBlank(subject)){
            soql += ' and Survey_Type__c = \'' + subject + '\'';
        }
        if(taskHandler.From__c != null){
            String month = taskHandler.From__c.month() > 9 ? String.valueOf(taskHandler.From__c.month()) : '0' + taskHandler.From__c.month();
            String day = taskHandler.From__c.day() > 9 ? String.valueOf(taskHandler.From__c.day()) : '0' + taskHandler.From__c.day();
            String fromDate = taskHandler.From__c.year() + '-' + month + '-' + day + 'T' + '00:00:00Z';
            soql += ' and CreatedDate >= ' + fromDate;
        }
        if(taskHandler.To__c != null){
            String month = taskHandler.To__c.month() > 9 ? String.valueOf(taskHandler.To__c.month()) : '0' + taskHandler.To__c.month();
            String day = taskHandler.To__c.day() > 9 ? String.valueOf(taskHandler.To__c.day()) : '0' + taskHandler.To__c.day();
            String toDate = taskHandler.To__c.year() + '-' + month + '-' + day + 'T' + '00:00:00Z';
            soql += ' and CreatedDate <= ' + toDate;
        }
        if(assignType == 'Assignment' && !Test.isRunningTest()){
            soql += ' and OwnerId = \'00G90000001WPXL\'';
        }
        if(assignType == 'Recall' && !Test.isRunningTest()){
            soql += ' and Owner.ProfileId = \'00e90000001K3nq\'';
        }
        return soql;
    }
}