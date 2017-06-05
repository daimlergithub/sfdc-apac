/******************************************************************
    Page Controller
    ---------------------------------------------------------------
    History:
    
    1. Justin Yu Created on 2014-05-14
    2. Last modified date : 2017-May-08
           modified by : Lokesh M
       Desc : retail campign segmentation
       JIRA : SFDCJP-1023,JP-1052,JP-1050,JP-1076,JP-1054
******************************************************************/
public with sharing class RetailCampaignSegmentationController {
    
    
    private String retailCampaignId;
    Boolean vehicleFind;
    Boolean vehicleRelFind;
    Boolean vehicleRetailFind;
    //Boolean recallFind;
    Boolean accountFilter;
    
    //pagination
    public ApexPages.StandardSetController con {get;set;}
    public Integer totalrecords{get;set;}
    Public Integer size{get;set;} 
    Public Integer noOfRecords{get; set;} 
    
    //Find the initail soql lentght of all queries
    private Integer vehRelLength;
    private Integer leadLength;
    private Integer retailaskLength;
    private Integer addressLength;
    private Integer campLength;
    private Integer accLinkLength;
    private Integer recallLength;
    private Integer VehRetCopyLength;
    
    // For soql
    private String accountSoql;
    private String leadSoql;
    private String vehicleRelSoql;
    private String vehicleSoql;
    private String AccountLinkSoql;
    private String campaignMemSoql;
    private String RetailTaskSoql;
    private String AddressSoql;
    private String recallSoql;
    private String VehRetCopySoql;
    
    private Set<String> accountIds;
    private Set<Id> accountIdSet;
    private Set<Id> vehIdSet;//to store the recall object vehicles and vehicle retail copy object vehicles 
    private Integer recallCount;
    
    private Set<String> recallFields;
    private Set<String> numberFields;
    private Set<String> dateFields;
    private Set<String> textFields;
    private Set<String> pickListFields;
    private Set<String> multiplePickListFields;
    private Set<String> vehicleFields;
    private Set<String> vehicleRelFields;    
    private Set<String> AccountLinkFields;
    private Set<String> retialCampaignFields;
    private Set<String> RetailTaskFields;
    private Set<String> AddressFields;
    
    private Retail_campaign__c curRetCamp = new Retail_campaign__c();//to hold current retail campaign
    
    //To check the parent retail campaign type and set car relation in vehicleRelSoql 
    public String parCampType{set;get;}
    public String Sales =  'Sales Contact Target';
    public String AfterSalesOrFinance = 'Aftersales Contact Target 1';
    
    //To change the available picklist values
    Public Set<String> retTaskStatus = new Set<String>{'Draft', 'Waiting for Approval', 'Approved', 'Rejected','In service','Expired','pullback','Save','Waiting for cancellation approval','Cancellation Approved','Cancelled','Active', 'Matured','Cancelled','Early Termination','Subrogation','Consent Termination','Forced Termination','Change of Owner'};
    public Set<String> specialMarkAcc = new Set<String>{'Automotive related','Dealer','Fire department','Lawyer','Insurance Company','MBJ','Ministry of Transport','Police'};
    public Set<String> accStatus = new Set<String>{'Customer', 'Prospect'};
    public Set<String> LeadDealerStatus = new Set<String>{'Not Started','On-going','Order Placed','Purchased(Only Non BDC)','Lost'};
    
    public String jsonFilter { get; set; }
    public Map<String, Object> filterMap;
    public Map<String, Object> contentMap;
    
    // For data model
    public Account account { get; set; }
    public Lead__c lead { get; set; }
    public Vehicle__c vehicle { get; set; }
    public Vehicle_Relationship__c vehicleRel { get; set; }
    public Campaign CampaignRec { get; set; }
    public Account_Link__c AlkRec{ get; set; }
    public Retail_Task__c RatilTask{ get; set; }
    public Address__c  address{ get; set; }
    public campaign_member__C camMem {get; set;}
    public recall__C recall {get; set;}
    public List<account> accList; 
    public user u;
    public Map<Id,recall__C> vehIdRecallRecMap;
    public Map<Id,Account_Link__c> vehIdAccLinkRecMap;
    string personAccntRecTypId;
    String retailTaskLeaseRecType;
    String retailTaskLoanRecType;
    String retailTaskInsRecType;
    
    //Segmentation_Base__c
    public String segmentationBase{set;get;}
    
    public RetailCampaignSegmentationController()
    {
        size = 100;
        retailCampaignId = ApexPages.currentPage().getParameters().get('id');
        personAccntRecTypId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        retailTaskLeaseRecType = Schema.SobjectType.Retail_Task__c.getRecordTypeInfosByName().get('Lease Contract').getRecordTypeId();
        retailTaskLoanRecType = Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Loan Contract').getRecordTypeId();
        retailTaskInsRecType = Schema.SObjectType.Retail_Task__c.getRecordTypeInfosByName().get('Insurance Contract').getRecordTypeId();
        curRetCamp = [SELECT Id,Name,Segmentation_Base__c,Parent_Campaign1__r.Campaign_Type__c FROM Retail_campaign__C WHERE ID =: retailCampaignId];
        segmentationBase = curRetCamp.Segmentation_Base__c;
        if(curRetCamp.Parent_Campaign1__c != NULL){
            if(curRetCamp.Parent_Campaign1__r.Campaign_Type__c == 'Sales'){
                parCampType = Sales;
            } else {
                parCampType = AfterSalesOrFinance;
            }
        }
        setFieldType();
    }
    
    public String selectedValueSales {set;get;}
    public String selectedValueService {set;get;}
    public String selectedValue {set;get;}// holding the value which they selected either 'company' or 'outlet'
  
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--None--'));
        options.add(new SelectOption('Company','Company'));
        options.add(new SelectOption('Outlet','Outlet'));
        return options;
    }
        
    public List<SelectOption> RetailTaskStatus{
        get{
            RetailTaskStatus= new List<SelectOption>();
            RetailTaskStatus.add(new SelectOption('', '--None--'));
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Retail_Task__c.fields.Status__c;
            for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                if(retTaskStatus.contains(entry.getLabel()))
                RetailTaskStatus.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
            return RetailTaskStatus;
        }
        set;
    }
    
   
    public List<SelectOption> SpecialMarkonAccount{
        get{
            SpecialMarkonAccount= new List<SelectOption>();
            SpecialMarkonAccount.add(new SelectOption('', '--None--'));
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account.fields.Special_Mark_on_Account__c;
            for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                if(specialMarkAcc.contains(entry.getLabel()))
                SpecialMarkonAccount.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
            return SpecialMarkonAccount;
        }
        set;
    }
    
    public List<SelectOption> Customerphase{
        get{
            Customerphase= new List<SelectOption>();
            Customerphase.add(new SelectOption('', '--None--'));
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account.fields.Customer_Lifecycle_Phase__c;
            for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                Customerphase.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
            return Customerphase;
        }
        set;
    }
    
     public List<SelectOption> status{
        get{
            status= new List<SelectOption>();
            status.add(new SelectOption('', '--None--'));
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account.fields.Status__c;
            for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                if(accStatus.contains(entry.getLabel()))
                status.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
            return status;
        }
        set;
    }
    
    public List<SelectOption> DealerLeadStatus{
        get{
            DealerLeadStatus= new List<SelectOption>();
            DealerLeadStatus.add(new SelectOption('', '--None--'));
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Lead__c.fields.Dealer_Lead_Status__c;
            for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                if(LeadDealerStatus.contains(entry.getLabel()))
                DealerLeadStatus.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
            return DealerLeadStatus;
        }
        set;
    }
    
     public List<SelectOption> RetailSalesSanction{
        get{
            RetailSalesSanction= new List<SelectOption>();
            RetailSalesSanction.add(new SelectOption('', '--None--'));
            RetailSalesSanction.add(new SelectOption('A', 'A'));
            RetailSalesSanction.add(new SelectOption('B', 'B'));
            RetailSalesSanction.add(new SelectOption('C', 'C'));
            RetailSalesSanction.add(new SelectOption('D', 'D'));
            RetailSalesSanction.add(new SelectOption('E', 'E'));
            RetailSalesSanction.add(new SelectOption('F', 'F'));
            return RetailSalesSanction;
        }
        set;
    }
     
     public List<SelectOption> RetailOptOutContactReason{
        get{
            RetailOptOutContactReason= new List<SelectOption>();
            //RetailOptOutContactReason.add(new SelectOption('', '--None--'));
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account_Link__c.fields.Retail_OptOutContact_Reason__c;
            for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                RetailOptOutContactReason.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
            return RetailOptOutContactReason;
        }
        set;
    }
  
    public PageReference searchAccount(){    
       
        accList = new List<account>();
        accountIdSet = new Set<Id>();
        accountFilter = false;
        accountIds = new Set<String>(); 
        vehIdSet = new Set<Id>();
        recallCount = 0;
        vehicleRelFind = false;
        vehicleFind = false;
        u = [SELECT Id,Contact.Account.name FROM User WHERE Id =:userInfo.getUserId() ];
        vehIdRecallRecMap = new Map<Id,recall__C>();
        vehIdAccLinkRecMap = new Map<Id,Account_Link__c>();
        
        system.debug('================='+jsonFilter);
        filterMap = (Map<String, Object>)JSON.deserializeUntyped(jsonFilter);
        system.debug('I am filter map'+filterMap);
        contentMap = (Map<String, Object>)(filterMap.get('content'));
        system.debug('I am content map'+contentMap);
/************************************segmentationBase == Vehicle Starts************************************/
        if(segmentationBase == 'Vehicle'){
            setSoqlVehicle();
            if(vehicleRelSoql.endsWith('AND  ') || vehicleRelSoql.endsWith('AND ')){
                System.debug('Removing end in vehilce soql');
                vehicleRelSoql = vehicleRelSoql.removeEnd('AND  ').removeEnd('AND ');
            }
            system.debug('@@@@@@vehiclerelSoql '+vehicleRelSoql);
            /*if(recallSoql.length()>recallLength){
                vehicleRelSoql += 'AND Vehicle_Id__c IN ('+recallSoql+') ';
            }
            if(VehRetCopySoql.length()>VehRetCopyLength){
                VehRetCopySoql = VehRetCopySoql.replace('Sales_Representative__c', 'Sales_Representative__r.Name').replace('Service_Advisor__c','Service_Advisor__r.Name');
                vehicleRelSoql += 'AND Vehicle_Id__c IN ('+VehRetCopySoql+') ';
            }
            */ //for recall object records
                if(recallSoql.length()>recallLength){
                    System.debug('recallSoqlFinal>>>>'+recallSoql);
                    List<recall__c> recallList = Database.query(recallSoql + ' LIMIT 10000');
                    for(recall__c rc : recallList){
                        vehIdSet.add(rc.Vehicle_Id__c);
                        vehIdRecallRecMap.put(rc.Vehicle_Id__C,rc);
                    }
                    vehicleRelSoql+= 'AND Vehicle_Id__c IN: vehIdSet ';
                }
                
                //for vehicleRetailCopy records
                if(VehRetCopySoql.length()>VehRetCopyLength){
                    VehRetCopySoql = VehRetCopySoql.replace('Sales_Representative__c', 'Sales_Representative__r.Name').replace('Service_Advisor__c', 'Service_Advisor__r.Name');
                    system.debug('vehicleRetialCopySoql'+VehRetCopySoql);
                    List<Account_Link__c> vehRetialList = Database.query(VehRetCopySoql+' LIMIT 10000');
                    for(Account_Link__c ac : vehRetialList){
                        vehIdSet.add(ac.Vehicle__c);
                        vehIdAccLinkRecMap.put(ac.vehicle__c,ac);
                    }
                    vehicleRelSoql+= 'AND Vehicle_Id__c IN: vehIdSet ';
                }
                
                if(vehicleRelSoql.length()>vehRelLength){
                    vehicleRelSoql = vehicleRelSoql.replace('Last_Service_Dealer__c','Last_Service_Dealer__r.Name');
                    system.debug('finalvehiclerelSoql>>>>'+vehicleRelSoql);
                    List<Vehicle_relationship__C> vehRelList = Database.query(vehicleRelSoql + ' ORDER BY Contact__c ASC limit 10000');
                    con = new ApexPages.StandardSetController(vehRelList);
                    con.setPageSize(100); 
                    noOfRecords = con.getResultSize();
                    getloadwrapAccountList();
                }
           /************************************segmentationBase == Vehicle Ends***************************************/
        }
        else if(segmentationBase == 'Customer'){
            /************************************segmentationBase == customer Starts**********************************/
            //string personAccntRetailRecTypId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account Retail').getRecordTypeId();
            string dealerAccntRecTypId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            if(selectedValueSales == 'Company'){
                accountSoql = 'select Id, Name, PersonHomePhone, PersonMobilePhone, Phone, PersonEmail, City__c from Account '
                + 'where RecordTypeId =\'' + dealerAccntRecTypId + '\' AND Dealer_Type__c = Company and ';
            }
            else if(selectedValueSales == 'Outlet'){
                accountSoql = 'select Id, Name, PersonHomePhone, PersonMobilePhone, Phone, PersonEmail, City__c from Account '
                + 'where RecordTypeId =\'' + dealerAccntRecTypId + '\' AND Dealer_Type__c = Outlet and ';
            }
            else {
                accountSoql = 'select Id, Name, PersonHomePhone, PersonMobilePhone, Phone, PersonEmail, City__c from Account '
                + 'where RecordTypeId =\'' + personAccntRecTypId + '\' and ';
            } 
            leadSoql = 'Select Contact__c from Lead__c where ';
            campaignMemSoql = 'Select Contact_Id__c From Campaign_Member__c where ';
            AccountLinkSoql = 'Select toRole__c From Account_Link__c where '; 
            AddressSoql = 'Select Customer__c From Address__c where ';
            leadLength =  leadSoql.length();
            campLength = campaignMemSoql.length();
            addressLength = AddressSoql.length();
            accLinkLength = AccountLinkSoql.length();
            List<Object> customerFilterItems = (List<Object>)contentMap.get('Customer');
            List<Object> leadFilterItems = (List<Object>)contentMap.get('Interest');
            List<Object> AccountLinkFilterItems = (List<Object>)contentMap.get('AccountLink');
            List<Object> AddressFilterItems = (List<Object>)contentMap.get('Address');
            List<Object> campaignFilterItems = (List<Object>)contentMap.get('Campaign');
            
            system.debug('Entered into customerFilterItems setSoql method'+customerFilterItems);
            system.debug('Entered into leadFilterItems setSoql method'+leadFilterItems);
            system.debug('Entered into AccountLinkFilterItems setSoql method'+AccountLinkFilterItems);
            system.debug('Entered into AddressFilterItems setSoql method'+AddressFilterItems);
            system.debug('Entered into campaignFilterItems setSoql method'+campaignFilterItems);
            if(customerFilterItems != NULL && !customerFilterItems.isEmpty()){
                accountFilter = true;
            }
            setSubSoql(customerFilterItems, 'account');
            setSubSoql(leadFilterItems, 'lead');
            setSubSoql(AccountLinkFilterItems, 'AccountLink');
            setSubSoql(AddressFilterItems, 'Address');
            setSubSoql(campaignFilterItems, 'campaign');
            
            system.debug('@@@@@@leadSoql '+leadSoql);
            if(leadSoql.length()>leadLength){
                //accountSoql += 'AND Id IN('+leadSoql+')';
                 List<Lead__C> leadList = Database.query(leadSoql+ 'limit 10000');
                 for(Lead__C vr : leadList){
                     accountIdSet.add(vr.Contact__c);
                 }
             }
            
            system.debug('@@@@@@AccountLinkSoql '+AccountLinkSoql);
            if(AccountLinkSoql.length()>accLinkLength){
                AccountLinkSoql = AccountLinkSoql.replace('Selling_Dealer__c', 'Selling_Dealer__c.Name');
                //accountSoql += 'AND Id IN('+AccountLinkSoql+')';
                 AccountLinkSoql = AccountLinkSoql.replace('Sales_Representative__c', 'Sales_Representative__r.Name');
                 List<Account_Link__C> accLinkList = Database.query(AccountLinkSoql + 'limit 10000');
                 for(Account_Link__C vr : accLinkList){
                     accountIdSet.add(vr.toRole__c);
                 }
            }
                
            system.debug('@@@@@@AddressSoql '+AddressSoql);
           if(AddressSoql.length()>addressLength){
               //accountSoql += 'AND Id IN('+AddressSoql+')';
                 List<Address__c> addList = Database.query(AddressSoql+ 'limit 10000');
                 for(Address__c vr : addList ){
                     accountIdSet.add(vr.Customer__c);
                 }
             }
        
            
             system.debug('@@@@@@campaignMemSoql'+campaignMemSoql);
            if(campaignMemSoql.length()>campLength){
                //accountSoql += 'AND Id IN('+campaignMemSoql+')';
                 List<Campaign_Member__c> camMemList = Database.query(campaignMemSoql+ 'limit 10000');
                   for(Campaign_Member__c vr : camMemList ){
                     accountIdSet.add(vr.Contact_Id__c);
                 }
             }

            //Searhs the accounts according to all other filters
            if(accountIdSet.size()==0 && accountFilter){
                accountSoql += '';
            }
            else if(accountSoql.endsWith('and ')){
                accountSoql += 'Id in :accountIdSet ';
            }
            else{
                accountSoql += ' and Id in :accountIdSet ';
            }
            
            // Searchs the accounts according to the Customer Filter 
            if(!accountIds.isEmpty()){
                if(accountSoql.endsWith('and ')){
                    accountSoql += 'Id in :accountIds ';
                }
                else{
                    accountSoql += ' and Id in :accountIds ';
                }
            }
            
            system.debug('@@@@@@@@' + accountSoql);
            accList = Database.Query(accountSoql+' LIMIT 10000');
            con = new ApexPages.StandardSetController(accList);
            con.setPageSize(100); 
            noOfRecords = con.getResultSize();
            getloadwrapAccountList(); 
/************************************segmentationBase == Vehicle Ends************************************/
        }
        else if(segmentationBase == 'Contract'){
/************************************segmentationBase == Contract Starts************************************/
            RetailTaskSoql = 'Select Account__c,Product_Name__c,Type__c,Duration__c,Status__c From Retail_Task__c WHERE (RecordTypeId =\'' + retailTaskLeaseRecType + '\' or  RecordTypeId = \'' + retailTaskLoanRecType + '\' or RecordTypeId = \''+retailTaskInsRecType + '\') AND Account__r.RecordTypeId = \'' + personAccntRecTypId + '\' AND '; 
            retailaskLength = RetailTaskSoql.length();
            List<Object> RetailTaskFilterItems = (List<Object>)contentMap.get('Contract');
            system.debug('Entered into RetailTaskFilterItems setSoql method'+RetailTaskFilterItems);
            setSubSoql(RetailTaskFilterItems, 'RetailTask');
            system.debug('@@@@@@AccountLinkSoql '+RetailTaskSoql);
            if(RetailTaskSoql.length()>retailaskLength){
                 List<Retail_Task__c> retTaskList = Database.query(RetailTaskSoql+ 'limit 10000'); 
                 con = new ApexPages.StandardSetController(retTaskList);
                 con.setPageSize(100); 
                 noOfRecords = con.getResultSize();
                 getloadwrapAccountList();
             }
/************************************segmentationBase == Contract Ends************************************/
        }
        return null;
    }
    
    public void setSoqlVehicle(){
        string vehRetCopyRecType=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId();
        vehicleRelSoql = 'Select Contact__c,Vehicle_ID__c,Car_Relation__c,End_Date__c,Vehicle_ID__r.FirstRegistrationDate__c,Vehicle_ID__r.Class__c,Vehicle_ID__r.Model_Description__c,New_Used__c From Vehicle_Relationship__c where Contact__r.RecordTypeId =\'' + personAccntRecTypId + '\' AND Car_Relation__c = \''+parCampType+'\' AND ';
        if(selectedValueService=='Outlet'){
            vehicleRelSoql += 'Last_Service_Dealer__c =\''+ u.Contact.Account.Name+'\' AND ';
        }
        recallSoql = 'Select Vehicle_Id__c,Recall_No__c,Status__c From Recall__c Where';
        VehRetCopySoql = 'Select Vehicle__c,NextInspectionDate__c,NextServiceDate__c,Service_Advisor__c FROM Account_Link__c WHERE RecordTypeId = \'' + vehRetCopyRecType + '\' AND ';
        
        vehRelLength = vehicleRelSoql.length();
        recallLength = recallSoql.length();
        VehRetCopyLength = VehRetCopySoql.length();
        
        List<Object> vehicleFilterItems = (List<Object>)contentMap.get('Vehicle');
        List<Object> vehicleretailItems = (List<Object>)contentMap.get('VehicleRetailcopy');
        List<Object> vehiclerelItems = (List<Object>)contentMap.get('VehicleRelation');
        system.debug('Entered into vehicleFilterItems  setSoql method'+vehicleFilterItems );
        system.debug('Entered into vehicleRelFilterItems setSoql method'+vehiclerelItems);
        system.debug('Entered into vehicleRetailCopyFilterItems setSoql method'+vehicleretailItems);
        if(vehicleFilterItems != NULL && vehiclerelItems != NULL && !vehicleFilterItems.isEmpty() && !vehiclerelItems.isEmpty()){
            vehicleFind = true;
            vehicleRelFind = true;
         }
         
         setSubSoql(vehicleFilterItems, 'vehicle');
         setSubSoql(vehiclerelItems,'VehicleRelation');
         setSubSoql(vehicleretailItems,'VehicleRetailcopy');    
    }
  
    public void setSubSoql(List<Object> filterItems, String cluster)
    {
       
       system.debug('Entered into filterItems'+filterItems);
       system.debug('Entered into cluster'+cluster);
       
            Integer bracketCount = 0;
            
            if(filterItems != null){
                for(Object filterItem : filterItems){
                    Map<String, Object> filterItemMap = (Map<String, Object>)filterItem;
                    System.debug('Filter Item Map'+filterItemMap);
                    
                    String field = (String)filterItemMap.get('field');
                    String operation = getOperation((String)filterItemMap.get('operation'));
                    String criteria = getCriteria(field, (String)filterItemMap.get('criteria'));
                    String logic = (String)filterItemMap.get('logic');
                    Boolean bracket = (Boolean)filterItemMap.get('bracket');
                    String subSoql = '';
                    //To Find Vehicle fileter is added or not
                    if(vehicleRelFind && vehicleFind && logic == '' && cluster == 'vehicle'){
                        logic = ' AND ';
                    }
                    
                    if(vehicleFields.contains(field)){
                        field = 'Vehicle_ID__r.' + field;
                        
                    }
                    if(retialCampaignFields.contains(field)){
                        field = 'Retail_Campaign_Id__r.' + field;
                    }
                    
                    if(recallFields.contains(field) && cluster == 'vehicle'){
                        if(recallCount == 0){
                            recallSoql += ' '+field+' '+operation+' '+criteria+' ';
                            recallCount++;
                        }
                        else{
                            recallSoql += 'AND '+field+' '+operation+' '+criteria+' ';
                        }
                    }
                    else
                    subSoql += field + operation + criteria + ' '; 
                        
                    if(bracket){
                        subSoql = subSoql.removeEnd(' ');
                        subSoql += (++bracketCount > 1 ? ') ' : ' ') + logic + ' (';
                    }
                    else{
                        subSoql += logic + ' ';
                    }
                    System.debug('finalsubsoql'+subSoql);
                    if(cluster == 'account'){
                        accountSoql += subSoql;
                    }
                    else if(cluster == 'lead'){
                        leadSoql += subSoql;
                    }
                    else if(cluster == 'vehicle' || cluster == 'VehicleRelation'){
                        if(!recallFields.contains(field))
                        vehicleRelSoql += subSoql;
                    }
                    else if(cluster == 'VehicleRetailcopy'){
                        VehRetCopySoql += subSoql;
                    }
                    else if(cluster == 'AccountLink'){
                        AccountLinkSoql += subSoql;
                    }
                    else if(cluster == 'RetailTask'){
                       RetailTaskSoql += subSoql;
                    }
                    else if(cluster == 'Address'){
                        AddressSoql += subSoql;
                    }
                    else if(cluster == 'Campaign'){
                        campaignMemSoql+= subSoql;
                    }
                }
          
                if(cluster == 'account'){
                    accountSoql += (bracketCount > 0 ? ') ' : '');
                }
                else if(cluster == 'lead'){
                    leadSoql += (bracketCount > 0 ? ') ' : '');
                }
                 else if(cluster == 'vehicle' || cluster == 'VehicleRelation'){
                    vehicleRelSoql += (bracketCount > 0 ? ') ' : '');
                }
                else if(cluster == 'AccountLink'){
                    RetailTaskSoql += (bracketCount > 0 ? ') ' : '');
                }
                else if(cluster == 'RetailTask'){
                    RetailTaskSoql += (bracketCount > 0 ? ') ' : '');
                }
                else if(cluster == 'Address'){
                    AddressSoql += (bracketCount > 0 ? ') ' : '');
                }
                else if(cluster == 'campaign'){
                    campaignMemSoql+= (bracketCount > 0 ? ') ' : '');
                }
            }
    }  
   
    public List<wrapperAccount> wrapperList{set;get;}
        
    // Create a new Map to verify whether the Account is already added in the Map
    Map <id,Account> SelectedAccountMap = new Map <id,Account>();      
    Map <id,Vehicle_Relationship__c> SelectedVrMap = new Map <id,Vehicle_Relationship__c>();      
    Map <id,Retail_Task__c> SelectedRetailTaskMap = new Map <id,Retail_Task__c>();      
     
    // This method process accounts and formats List of wrapper Accounts to be used with checkbox 
    public list<wrapperAccount> getloadwrapAccountList()
    {
        getSelectedRecords();
        wrapperList = new  List<wrapperAccount>();
        if(segmentationBase == 'Customer'){
            for(Account a : (List<Account>)con.getRecords()){
                wrapperAccount wrapAcc = new wrapperAccount();
                wrapAcc.acc = a;                           
                if(SelectedAccountMap.containsKey(a.id)){
                    wrapAcc.isSelected = true;    
                }
                else{
                    wrapAcc.isSelected = false;   
                }
                wrapperList.add(wrapAcc);   
            }
        }
        else if(segmentationBase == 'Vehicle'){
            for(Vehicle_Relationship__c a : (List<Vehicle_Relationship__c>)con.getRecords()){
                wrapperAccount wrapAcc = new wrapperAccount();
                wrapAcc.veh = a;
                if(vehIdRecallRecMap.get(a.Vehicle_ID__c) != NULL)
                wrapAcc.recall = vehIdRecallRecMap.get(a.Vehicle_ID__c);
                if(vehIdAccLinkRecMap.get(a.Vehicle_ID__c) != NULL)
                wrapAcc.accLink = vehIdAccLinkRecMap.get(a.Vehicle_ID__c);
                if(SelectedVrMap.containsKey(a.id)){
                    wrapAcc.isSelected = true;   
                }
                else{
                    wrapAcc.isSelected = false;  
                }
                
                wrapperList.add(wrapAcc);  
                
            }
        }
        else if(segmentationBase == 'Contract'){
            for(Retail_Task__c a : (List<Retail_Task__c>)con.getRecords()){
                wrapperAccount wrapAcc = new wrapperAccount();
                wrapAcc.retail = a;                          
                if(SelectedRetailTaskMap.containsKey(a.id)){
                    wrapAcc.isSelected = true;   
                }
                else{
                    wrapAcc.isSelected = false;   
                }
                
                wrapperList.add(wrapAcc);   
            }
        }
            system.debug('Called Wrapper method size---- '+wrapperList.size());
            
        return wrapperList;
    }
        
    //This methods holds the records which is checked and which is unchecked
    public void getSelectedRecords(){
        if(wrapperList != NULL){
            for(wrapperAccount wr:wrapperList){
                if(wr.isSelected == true){
                    if(segmentationBase == 'Customer')
                    SelectedAccountMap.put(wr.acc.id,wr.acc);
                    else if(segmentationBase == 'Vehicle')
                    SelectedVrMap.put(wr.veh.id,wr.veh);
                    else if(segmentationBase == 'Contract')
                    SelectedRetailTaskMap.put(wr.retail.id,wr.retail);
                }
                else{
                    if(segmentationBase == 'Customer')
                    SelectedAccountMap.remove(wr.acc.id);   
                    else if(segmentationBase == 'Vehicle')
                    SelectedVrMap.remove(wr.veh.id);  
                    else if(segmentationBase == 'Contract')
                    SelectedRetailTaskMap.remove(wr.retail.id);  
                }
            }
        }
    }
  
    // Wrapper class will be to used to have list of accounts with checkbox to Add to Campaign
    public class wrapperAccount{
        public Account acc {set;get;}
        public Vehicle_Relationship__c veh {set;get;}
        public Retail_Task__c retail {set;get;}
        public Boolean isSelected {set;get;}
        public Recall__c recall{set;get;}
        public Account_Link__c accLink{set;get;}
    }
    
    
    //Add campaign members to Retail campiang
    public PageReference addToCampaign(){
    System.debug('retailCampaignId === '+retailCampaignId);
        if(retailCampaignId == null) return null;
        
        //Calling this method to add the current page selected records
        getSelectedRecords();
        
        List<Campaign_Member__c> retailCampaignMembers = new List<Campaign_Member__c>();
        if(segmentationBase == 'Customer'){
            if(SelectedAccountMap.size()>0){
                for(Account curAcc : SelectedAccountMap.values()){
                    Campaign_Member__c member = new Campaign_Member__c(Status__c = 'Ready', Retail_Campaign_Id__c = retailCampaignId);
                    member.Contact_Id__c= curAcc.id;   
                    retailCampaignMembers.add(member);
                }
            }
        }
        else if(segmentationBase == 'Vehicle'){
            if(SelectedVrMap.size()>0){
                for(Vehicle_Relationship__c curVr : SelectedVrMap.values()){
                    Campaign_Member__c member = new Campaign_Member__c(Status__c = 'Ready', Retail_Campaign_Id__c = retailCampaignId);
                    member.Contact_Id__c= curVr.Contact__c;
                    member.Vehicle__c = curVr.Vehicle_ID__c;
                    member.Vehicle_Relationship__c = curVr.Id;
                    retailCampaignMembers.add(member);
                }
            }
        }
        else if(segmentationBase == 'Contract'){
            if(SelectedRetailTaskMap.size() > 0){
                for(Retail_Task__c curRec : SelectedRetailTaskMap.values()){
                    Campaign_Member__c member = new Campaign_Member__c(Status__c = 'Ready', Retail_Campaign_Id__c = retailCampaignId);
                    member.Contact_Id__c= curRec.Account__c;
                    member.Retail_Task__c = curRec.Id;
                    retailCampaignMembers.add(member);
                }    
            }
        }
       
        System.debug('retailCampaignMembersAfter'+retailCampaignMembers);
        try {
            if(retailCampaignMembers != NULL && !retailCampaignMembers.isEmpty())
            insert retailCampaignMembers;
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getMessage()));
            return null;
        }
        return new PageReference('/' + retailCampaignId);
    }
    
    private String getOperation(String operation){
        operation = operation.replace('Exclude', '!=');
        operation = operation.replace('Equals', '=');
        operation = operation.replace('Greater Than', '>');
        operation = operation.replace('Less Than', '<');
        return operation;
    }
    
    private String getCriteria(String field, String criteria){
        if(textFields.contains(field) || pickListFields.contains(field) || multiplePickListFields.contains(field)){
            return '\'' + criteria + '\'';
        }
        else if(dateFields.contains(field)){
            if(criteria == 'null'){
            criteria = null;
        }
        else if(criteria.contains(';')){
           String[] arrCriteia = criteria.split(';');
           System.debug('Before changing the criteria'+criteria );
           if(vehicleFields.contains(field)){
               criteria = (Date.parse(arrCriteia[0]) + ' ').left(10)+' AND Vehicle_Id__r.'+field+'<'+(Date.parse(arrCriteia[1]) + ' ').left(10);
           }
           else{
               criteria = (Date.parse(arrCriteia[0]) + ' ').left(10)+' AND '+field+'<'+(Date.parse(arrCriteia[1]) + ' ').left(10);
           }
           System.debug('After changing the criteria'+criteria);
        }
        else
            criteria = (Date.parse(criteria) + ' ').left(10);
        }
        return criteria;
    }
   
    private void setFieldType(){
        numberFields = new Set<String>{'Vehicle_Amount__c', 'CurrentMileage__c'};
        dateFields = new Set<String>{'PersonBirthdate', 'LastServiceDate__c', 'End_Date__c','LastServiceDate__c', 'NextServiceDate__c','FirstRegistrationDate__c', 'Registration_Date__c', 'Expected_Close_Date__c','Expected_Registration_Date__c','NextInspectionDate__c'};
        textFields = new Set<String>{'Recall_No__c','New_Used__c','PersonEmail', 'Modification_Package__c','Model_Description__c', 'ZipCode__c', 'Selling_Dealer__c','Name','Sales_Representative__c','Last_Service_Dealer__c','Service_Advisor__c'};
        pickListFields = new Set<String>{'Customer_Type__c','Special_Mark_on_Account__c','Customer_Lifecycle_Phase__c','Status__c', 'Province__c', 'Occupation__c', 'Type','Type__c', 'Range__c','Car_Relation__c', 'Class__c', 'Dealer_Lead_Status__c','Retail_Sales_Sanction__c','Product_Name__c','New_Used__c'};
        multiplePickListFields = new Set<String>{'Interest_Model__c', 'Retail_OptOutContact_Reason__c'};
        vehicleFields = new Set<String>{'Model_Description__c','Modification_Package__c','Range__c','FirstRegistrationDate__c', 'Class__c'};
        vehicleRelFields = new Set<String>{'Car_Relation__c', 'Last_Service_Dealer__c', 'Registration_Date__c', 'Selling_Dealer__c','Service_Advisor__c','Customer_Type__c','New_Used__c','End_Date__c'};
        AccountLinkFields =new Set<String>{'Sales_Representative__c', 'Retail_Visit_OptOut__c', 'Retail_Sales_Sanction__c', 'Retail_Postal_OptOut__c', 'Retail_Phone_OptOut__c', 'Retail_Fax_OptOut__c', 'Retail_Email_OptOut__c', 'Retail_OptOutContact_Reason__c','NextServiceDate__c','NextInspectionDate__c','LastServiceDate__c', 'CurrentMileage__c' };  
        recallFields = new Set<String>{'Recall_No__c','Status__c'};
        retialCampaignFields =new Set<String>{'Name'};
        RetailTaskFields =new Set<String>{ 'Product_Name__c', 'Type__c', 'Duration__c', 'Status__c'};
        AddressFields = new Set<String>{'ZipCode__c' , 'Province__c'};
    }
    
    
    // returns the first page of records
    public void first() {
         con.first();
     }
     
     // returns the last page of records
     public void last() {
         con.last();
     }
    
    // returns the previous page of records
     public void previous() {
         con.previous();
     } 
    
    //disable first and prev button
    public Boolean hasPrevious {
        get {
            return con.getHasPrevious();
        }
        set;
    }
    
    //display the next page of records
    public void next() {
        con.next();
    }
    
    //disable the next and last buttons
    public Boolean hasnext {
        get {
            return con.getHasNext();
        }
        set;
    }
   
}