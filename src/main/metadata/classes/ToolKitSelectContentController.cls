/*
    Type:       Controller for ToolKitSelectContent Visualforce page 
    Purpose:    Select content
    User Story: Retail Campaign
    Used By:    ToolKitSelectContent.page
    ---------------------------------------------------------------
    History:
    
    1. Barney Lai Created on 2014-05-14
    2. zhongyang.si update to add more select condition 2014-11-10
*/

public class ToolKitSelectContentController {
    private final Integer DEFAULT_RESULTS_PER_PAGE = 10;
    public List<ContentVersion> contentList { get; set; }
    public List<ContentVersion> contentListToShow { get; set; }
    public Id toolkitID {get; set;}
    public ContentVersion contentVersion { get; set; }
    public Tool_Kit__c toolKitInfo {get;set;}
    public Boolean hasQueryResult {get;set;}
    public String today {get; set;}
    public Id choosenContentName {get; set;}
    public String ContentName {get; set;}
    public Paginator paginator {get;set;}
    public Integer totalResult{get;set;}

    public ToolKitSelectContentController (ApexPages.StandardController stdController){
        init();
    }
    
    public ToolKitSelectContentController (){
        init();
    }
    
    private void init(){
        toolkitID = ApexPages.currentPage().getParameters().get('toolkitId');
        today = ApexPages.currentPage().getParameters().get('today');
        ToolkitInfo = [SELECT id, RecordType.Name, Event_Kit_Name__c, Media_Kit_Name__c, Event_Type__c, view__c FROM Tool_Kit__c WHERE id = :toolkitID];
        contentVersion = new ContentVersion();
        //when user load the page, there is not any results showing on the page
        hasQueryResult = false;
    }        
    
    public PageReference choose() {
        if(ToolkitInfo.RecordType.Name == 'Media'){
            ToolkitInfo.Media_Kit_URL__c = '/sfc/#version?selectedVersionId=' + choosenContentName;
            ToolkitInfo.Media_Kit_Name__c = ContentName;
        }else{
            ToolkitInfo.Event_Kit_URL__c = '/sfc/#version?selectedVersionId=' + choosenContentName;
            ToolkitInfo.Event_Kit_Name__c = ContentName;
        }
        ToolkitInfo.view__c = '/sfc/servlet.shepherd/version/download/' + choosenContentName;

        try{
            update ToolkitInfo;
        }catch(exception e){
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.ERROR,'Error:'+ e));
        }
        return null;
    }
    
    public void query() {
        String querySOQL = 'SELECT id,PathOnClient,Title,Brand__c,Class__c,CBU_PbP__c,Media_Type__c, Ad_Type__c,Ad_Num__c,Event_Type__c,Event_Num__c,Event_Tool_Kit__c,lastmodifieddate,Document_Type__c FROM ContentVersion '+ 
                           ' WHERE (Due_Date__c = NULL or Due_Date__c >= ' + today + ')' ;
        
        // add the query condition
        if(ToolkitInfo.RecordType.Name == 'Media') {
            querySOQL += ' AND Media_Type__c != null AND Media_Type__c != \'\'';
        } else {
            querySOQL += ' AND Event_Type__c != null AND Event_Type__c != \'\'';
        }
        if (contentVersion.PathOnClient != null && contentVersion.PathOnClient != '') {
            querySOQL += ' AND PathOnClient Like \'%' + contentVersion.PathOnClient + '%\'';
        }
        if (contentVersion.Title != null && contentVersion.Title != ''){
            querySOQL += ' AND title like \'%' + contentVersion.Title + '%\'' ;
        }
        if (contentVersion.Brand__c != null && contentVersion.Brand__c != ''){
            querySOQL += ' AND brand__c = \'' + contentVersion.Brand__c + '\'';
        }
        if (contentVersion.CBU_PbP__c != null && contentVersion.CBU_PbP__c != ''){
            querySOQL += ' AND cbu_pbp__c = \'' + contentVersion.CBU_PbP__c + '\'';
        }
        if (contentVersion.Class__c != null && contentVersion.Class__c != ''){
            querySOQL += ' AND class__c = \'' + contentVersion.Class__c + '\'';
        }
        if (contentVersion.Event_Tool_Kit__c != null && contentVersion.Event_Tool_Kit__c != ''){
            querySOQL += ' AND event_tool_kit__c like \'%' + contentVersion.Event_Tool_Kit__c + '%\'' ;
        }
        if (contentVersion.Due_Date__c != null){
            querySOQL += ' AND day_only(lastmodifieddate) = ' + String.valueOf(contentVersion.Due_Date__c);
        }
        if (contentVersion.Media_Type__c != null && contentVersion.Media_Type__c != ''){
            querySOQL += ' AND Media_Type__c = \'' + contentVersion.Media_Type__c + '\'';
        }
        if (contentVersion.Event_Type__c != null && contentVersion.Event_Type__c != ''){
            querySOQL += ' AND Event_Type__c = \'' + contentVersion.Event_Type__c + '\'';
        }
        if (contentVersion.AD_Type__c != null && contentVersion.AD_Type__c != ''){
            querySOQL += ' AND AD_Type__c like  \'%' + contentVersion.AD_Type__c + '%\'';
        }
    
        contentList = Database.query(querySOQL);
        paginator = new Paginator(DEFAULT_RESULTS_PER_PAGE, contentList);
        contentListToShow = paginator.getFirstPage();  
        totalResult = contentList.size();
        
        hasQueryResult = (contentList.size() > 0);
        if (!hasQueryResult) {
            ApexPages.addMessage(new ApexPages.Message( ApexPages.severity.INFO,Label.CP_No_Search_Result));
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
    
    /************************************************
     Returns the previous page of records 
    **************************************************/
    public void previous() {
        contentListToShow = paginator.getPreviousPage();  
    }  
 
    /************************************************
     Returns the next page of records   
    **************************************************/  
    public void next() {
       contentListToShow = paginator.getNextPage(); 
    }
      
    /************************************************
     Return the first page of records   
    **************************************************/     
    public void first() {
       contentListToShow = paginator.getFirstPage();
    }
      
    /************************************************
     Return the last page of the records   
    **************************************************/  
    public void last() {      
       contentListToShow = paginator.getLastPage();
    }
    
    public String recordNumbering {
        get {
          if(contentListToShow != null ) {
            return paginator.getShowingFrom() + '-' + paginator.getShowingTo() + ' ' + Label.Page_Element_Of+ ' ' + paginator.totalResults;
          }
          return '';
        }set;
    }
}