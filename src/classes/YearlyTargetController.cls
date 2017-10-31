/*
    Type:       controller
    Purpose:    Yearly Target Controller
    User Story: Retail Campaign - View and edit yearly target.

    Used By:    VF Page - YearlyTarget.page
    ---------------------------------------------------------------
    History:

    9-May-2014 Sinow zhang (Nttdata)    Created
*/
public with sharing class YearlyTargetController {
    
    private final string DEFAULT_SORT_ORDER = 'Desc';
    private final string DEFAULT_SORT_FIELD = 'LastModifiedDate';
    private final Integer DEFAULT_RESULTS_PER_PAGE = 100;
    
    public Integer totalResult{get;set;}
    public String sortField{get;set;}
    private String sortOrder;
    private String previousSortField;
    private String query;
    public boolean NameAsc{get;set;}
    public boolean yearAsc{get;set;}
    public boolean applyDateAsc{get;set;}
    public boolean dealerNameAsc{get;set;}
    public boolean regionAsc{get;set;}
    public boolean subRegionAsc{get;set;}
    public boolean statusAsc{get;set;}
    public boolean cityAsc{get;set;}
    public String requestedPage{get;set;}
    public List<SelectOption> lType {get;set;}
    public String selectedLType {get;set;}
    public String selectedURLType {get;set;}
    public List<Retail_Campaign__c> RetailCampaigns {get; set;}
    public List<Retail_Campaign__c> RetailCampaignsToDisplay {get; set;}
    public String ASRecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Aftersales Yearly TA').getRecordTypeId();
    public String SMRecordTypeId = Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Sales & Marketing Yearly TA').getRecordTypeId();
        
    public Paginator paginator {get;set;}
     
    public YearlyTargetController() {
        
        NameAsc = false;
        yearAsc = false;
        applyDateAsc = false;
        dealerNameAsc = false;
        regionAsc = false;
        subRegionAsc = false;
        statusAsc = false;
        cityAsc = false;
        selectedLType = SMRecordTypeId;
        
        lType= new List<SelectOption>();
        if([select Name from Profile where Id = :UserInfo.getProfileId()].Name != 'Dealer Community User') {
            lType.add(new SelectOption(SMRecordTypeId ,System.Label.Sales_Marketing));
            lType.add(new SelectOption(ASRecordTypeId ,System.Label.Aftersales));
        } else {
            if([select Id from PermissionSetAssignment where AssigneeId = :UserInfo.getUserId() and permissionSet.Name = 'S_M_Yearly_TA'].size() == 1) {
                lType.add(new SelectOption(SMRecordTypeId ,System.Label.Sales_Marketing));
            }
            if([select Id from PermissionSetAssignment where AssigneeId = :UserInfo.getUserId() and permissionSet.Name = 'AS_Yearly_TA'].size() == 1) {
                lType.add(new SelectOption(ASRecordTypeId ,System.Label.Aftersales));
                selectedLType = ASRecordTypeId;
            }
        }

        init();
    }

    public void init() {
        RetailCampaigns = [select Id, Name, Y_Year__c, Y_Apply_Deadline__c, Y_Dealer_Name__c, Y_Dealer_Name__r.Name, Y_Region__c, Y_Sub_Region__c, Y_Status__c, Y_City__c from Retail_Campaign__c where RecordTypeId = :selectedLType];
        setPagination(RetailCampaigns);
        RetailCampaignsToDisplay = paginator.getFirstPage();  
        requestedPage = String.valueOf(paginator.currentPage);
        totalResult = RetailCampaigns.size();
    }
        
    /************************************************
    A method that is used to return the total no of pages 
    **************************************************/
    public PageReference goRequestedPage() {
        boolean check = pattern.matches('[0-9]+',requestedPage); 
        Integer pageNo = check? Integer.valueOf(requestedPage) : 0;
        if(pageNo == 0 || pageNo > paginator.totalPage){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Invalid page number.')); 
            return null;       
        }  
        RetailCampaignsToDisplay = paginator.getPage(Integer.valueOf(requestedPage));
        return null;  
    }
    
    private void setPagination(List<Retail_Campaign__c> resContents){
      paginator = new Paginator(DEFAULT_RESULTS_PER_PAGE, resContents);
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
     
    public void initForAS() {
        init();
    }
     
    /************************************************
     Returns the previous page of records 
    **************************************************/
    public void previous() {
        requestedPage = String.valueOf(paginator.currentPage);      
        RetailCampaignsToDisplay = paginator.getPreviousPage();  
    }  
        
    
    /************************************************
     Returns the next page of records   
    **************************************************/  
    public void next() {
       requestedPage = String.valueOf(paginator.currentPage);       
       RetailCampaignsToDisplay = paginator.getNextPage(); 
    }
      
    /************************************************
     Return the first page of records   
    **************************************************/     
    public void first() {
       requestedPage = String.valueOf(paginator.currentPage);         
       RetailCampaignsToDisplay = paginator.getFirstPage();
    }
      
    /************************************************
     Return the last page of the records   
    **************************************************/  
    public void last() {      
       requestedPage = String.valueOf(paginator.currentPage);
       RetailCampaignsToDisplay = paginator.getLastPage();
    }
    
    public String recordNumbering {
        get {
          if(RetailCampaignsToDisplay != null ) {
            return paginator.getShowingFrom() + '-' + paginator.getShowingTo() + ' ' + System.Label.Yearly_TA_Of + ' ' + paginator.totalResults;
          }
          return '';
        }set;
    }
}