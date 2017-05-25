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
    private String thirdParty; //to store the account recordtype - 3rd party
    Boolean vehicleFind;
    Boolean vehicleRelFind;
    Boolean vehicleRetailFind;
    Boolean accountFilter;
    
    //pagination
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
    
    // For soql
    private String mainSoql;
    private String accountSoql;
    private String leadSoql;
    private String vehicleRelSoql;
    private String vehicleSoql;
    private String AccountLinkSoql;
    private String campaignMemSoql;
    private String CampaignSoql;
    private String RetailTaskSoql;
    private String AddressSoql;
    private String recallSoql;
 
    private Set<String> accountIds;
    private Set<Id> accountIdSet;
    private Set<Id> recallVehIdSet;
    private Integer recallCount;
    
    private Set<String> recallFields;//for recall object 6thamy 2017
    private Set<String> numberFields;
    private Set<String> dateFields;
    private Set<String> dateTimeFields;
    private Set<String> textFields;
    private Set<String> CheckboxFields;
    private Set<String> pickListFields;
    private Set<String> multiplePickListFields;
    private Set<String> vehicleFields;
    private Set<String> vehicleRelFields;    
    private Set<String> AccountLinkFields;
    private Set<String> CampaignFields;
    private Set<String> RetailTaskFields;
    private Set<String> AddressFields;
    
    private final integer listLimit;
    private List<Account> tempAccounts;//To Hold the accounts
    private Map<String, Account> accountMap;
    private Retail_campaign__c curRetCamp = new Retail_campaign__c();//to hold current retail campaign
    
    //To check the parent retail campaign type and set car relation in vehicleRelSoql 
    private String parCampType;
    private String Sales =  'Sales Contact Target';
    private String AfterSalesOrFinance = 'Aftersales Contact Target 1';
    
    //To check in vehicleRel soql if the same account is existing for another vehicle
    List<account> accList;
    List<account> dupAccounts;
    Map<Id,Integer> accIdandCountMap;
    Map<Id,Id> accIdVehIdMap;
        
    public RetailCampaignSegmentationController()
    {
                size = 1000;
                thirdParty = Schema.SObjectType.Account.getRecordTypeInfosByName().get('3rd Party').getRecordTypeId();
                retailCampaignId = ApexPages.currentPage().getParameters().get('id');
                curRetCamp = [SELECT Id,Name,Segmentation_Base__c,Parent_Campaign1__r.Campaign_Type__c FROM Retail_campaign__C WHERE ID =: retailCampaignId];
                if(curRetCamp.Parent_Campaign1__c != NULL){
                    if(curRetCamp.Parent_Campaign1__r.Campaign_Type__c == 'Sales'){
                        parCampType = Sales;
                    } else {
                        parCampType = AfterSalesOrFinance;
                    }
                }
                setFieldType();
    }
    public ApexPages.StandardSetController con {get;set;}
    
    /**
     * Properties -->
     */
    public Transient List<Account> accounts { get; set; }
    public Transient List<Account> limitAccounts;
    public Contact contact { get; set; }
    public String jsonFilter { get; set; }
    
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
        
    /* 
    public List<String> filterOptions {
        get{
           if(contact == null || String.isBlank(contact.SegmentationFilters__c) || contact.SegmentationFilters__c == '[]'){
                return new List<String>();
            }
            else{
                filterOptions = new List<String>();
                List<Object> filterList = (List<Object>)JSON.deserializeUntyped(contact.SegmentationFilters__c);
                for(Object item : filterList){
                    Map<String, Object> filterMap = (Map<String, Object>)item;
                    filterOptions.add((String)filterMap.get('name'));
                }
                return filterOptions;
            }
        }
        set;
    }
    */
    
    public List<SelectOption> SpecialMarkonAccount{
        get{
            SpecialMarkonAccount= new List<SelectOption>();
            SpecialMarkonAccount.add(new SelectOption('', '--None--'));
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account.fields.Special_Mark_on_Account__c;
            for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
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
                status.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
            return status;
        }
        set;
    }
    
     public List<SelectOption> RetailSalesSanction{
        get{
            RetailSalesSanction= new List<SelectOption>();
            RetailSalesSanction.add(new SelectOption('', '--None--'));
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account_Link__c.fields.Retail_Sales_Sanction__c;
            for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                RetailSalesSanction.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
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
    /*
    public List<SelectOption> VehicleClassOptions{
        get{
            VehicleClassOptions = new List<SelectOption>();
            VehicleClassOptions.add(new SelectOption('', '--None--'));
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Vehicle__c.fields.Class__c;
            for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                VehicleClassOptions.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
            return VehicleClassOptions;
        }
        set;
    }
    */
    public PageReference searchAccount(){     
        system.debug('Entered into Search method');
       
        accList = new List<account>();
        dupAccounts =  new List<account>();
        accIdandCountMap = new Map<Id,Integer>();
        accIdVehIdMap = new Map<Id,Id>();
        accountIdSet = new Set<Id>();
        recallVehIdSet = new Set<Id>();
        recallCount = 0;
        vehicleRelFind = false;
        vehicleFind = false;
        VehicleRetailFind = false;
        accountFilter = false;
       
        setSoql();
        accounts = new List<Account>();
        accountIds = new Set<String>();
        //try{
            system.debug('vehiclerelSoql '+vehicleRelSoql);
            if(vehicleRelSoql.endsWith('AND  ')){
                System.debug('Removing end in vehilce soql');
                vehicleRelSoql = vehicleRelSoql.removeEnd('AND  ');
            }
            system.debug('@@@@@@vehiclerelSoql '+vehicleRelSoql);
            if(!vehicleRelSoql.endsWith('where ')) {            
                vehicleRelSoql = vehicleRelSoql.replace('Service_Advisor__c','Service_Advisor__r.Name');
                if(recallSoql.length()>recallLength){
                    System.debug('recallSoqlFinal>>>>'+recallSoql);
                    List<recall__c> recallList = Database.query(recallSoql + ' LIMIT 50000');
                    for(recall__c rc : recallList){
                        recallVehIdSet.add(rc.Vehicle_Id__c);
                    }
                }
                system.debug('recallVehIdSet.size()'+recallVehIdSet.size());
                if(recallVehIdSet.size()>0){
                    vehicleRelSoql+= 'AND Vehicle_Id__c IN: recallvehIdSet ';
                }
                system.debug('finalvehiclerelSoql>>>>'+vehicleRelSoql);
                if(vehicleRelSoql.length()>vehRelLength){
                    List<Vehicle_relationship__C> vehRelList = Database.query(vehicleRelSoql + ' ORDER BY Vehicle_Id__c limit 2000');
                    System.debug('vehRelList '+vehRelList.size());
                    for(Vehicle_relationship__C vr : vehRelList){
                        if(!accountIdSet.contains(vr.contact__c)){
                            accIdandCountMap.put(vr.contact__c,1);//putting the initail value as 1 in map for first time
                            accIdVehIdMap.put(vr.contact__c,vr.vehicle_Id__c);
                            accountIdSet.add(vr.Contact__c);
                        }
                        else if(vr.vehicle_Id__c != accIdVehIdMap.get(vr.contact__c)){
                            accIdVehIdMap.put(vr.contact__c,vr.vehicle_Id__c);
                            Integer i = accIdandCountMap.get(vr.contact__c)+1;//to increase the count of duplicate account found
                            accIdandCountMap.put(vr.contact__c,i);//overwrite the previous value with increased value  
                        }
                    }
                }
            }    

            system.debug('@@@@@@leadSoql '+leadSoql);
            if(!leadSoql.endsWith('where ')){
                leadSoql = leadSoql.replace('Retail_Campaign_Name__c', 'Retail_Campaign_Name__r.Name');
                System.debug('leadSoql '+leadSoql);
                if(leadSoql.length()>leadLength){
                     List<Lead__C> leadList = Database.query(leadSoql+ 'limit 2000');
                     System.debug('leadList '+leadList.size());
                     for(Lead__C vr : leadList){
                         accountIdSet.add(vr.Contact__c);
                     }
                 }
            }
            
            system.debug('@@@@@@AccountLinkSoql '+AccountLinkSoql);
            if(!AccountLinkSoql.endsWith('where ')) {
               // AccountLinkSoql = AccountLinkSoql.replace('toRole__c', 'toRole__r.Name');
               AccountLinkSoql = AccountLinkSoql.replace('Sales_Representative__c', 'Sales_Representative__r.Name');
               if(AccountLinkSoql.length()>accLinkLength){
                     List<Account_Link__C> accLinkList = Database.query(AccountLinkSoql + 'limit 2000');
                      System.debug('accLinkList '+accLinkList.size());
                     for(Account_Link__C vr : accLinkList){
                         accountIdSet.add(vr.toRole__c);
                     }
                 }
            }
                
                system.debug('@@@@@@AccountLinkSoql '+RetailTaskSoql);
                if(!RetailTaskSoql.endsWith('where ')) {
                    //RetailTaskSoql = RetailTaskSoql.replace('Account__c', 'Account__r.Name');
                    if(RetailTaskSoql.length()>retailaskLength){
                         List<Retail_Task__c> retTaskList = Database.query(RetailTaskSoql+ 'limit 2000');
                         System.debug('retTaskList '+retTaskList.size());
                         for(Retail_Task__c vr : retTaskList ){
                             accountIdSet.add(vr.Account__c);
                         }
                     }
                    
                }
                
                system.debug('@@@@@@AddressSoql '+AddressSoql);
                if(!AddressSoql.endsWith('where ')) {
                   if(AddressSoql.length()>addressLength){
                         List<Address__c> addList = Database.query(AddressSoql+ 'limit 2000');
                          System.debug('addList '+addList.size());
                         System.debug('addList '+addList);
                         for(Address__c vr : addList ){
                             accountIdSet.add(vr.Customer__c);
                         }
                     }
                }
                
                 system.debug('@@@@@@campaignMemSoql'+campaignMemSoql);
                if(!campaignMemSoql.endsWith('where ')) {
                  
                    if(campaignMemSoql.length()>campLength){
                         List<Campaign_Member__c> camMemList = Database.query(campaignMemSoql+ 'limit 2000');
                         System.debug('camMemList '+camMemList.size());
                         for(Campaign_Member__c vr : camMemList ){
                             accountIdSet.add(vr.Contact_Id__c);
                         }
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
                system.debug('----------' + accountSoql);
                accList = Database.Query(accountSoql+' LIMIT 2000');
                //con = new ApexPages.StandardSetController(Database.getQueryLocator(accountSoql+'ORDER BY Name ASC'));
                for(account a : accList){
                    if(accIdandCountMap.containsKey(a.Id)){
                        for(integer i=1;i<accIdandCountMap.get(a.Id);i++){
                            dupAccounts.add(a);
                        }
                    }
                }
                accList.addAll(dupAccounts);
                accList.sort();
                con = new ApexPages.StandardSetController(accList);
                system.debug('///////////');
                con.setPageSize(1000); 
                system.debug('///////////');
                noOfRecords = con.getResultSize();
                system.debug('///////////');         
                getloadwrapAccountList();
                System.debug('Tottalrecords'+totalRecords);
            //}
            //catch(Exception ex){
            //'Logic Error!'
              //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getmessage()));
            //}
        return null;
    }
    
   
    public List<wrapperAccount> wrapAccountList{set;get;}
        
    // Create a new Map to verify whether the Account is already added in the Map
    //Map <id,Account> SelectedAccountMap = new Map <id,Account>();      
    Map <string,Account> SelectedAccountMap = new Map <string,Account>();      
     
    // This method process accounts and formats List of wrapper Accounts to be used with checkbox 
    public list<wrapperAccount> getloadwrapAccountList()
    {
        getSelectedAccount();
        wrapAccountList = new  List<wrapperAccount>();
        integer count = 1 ;
            for(Account a : (List<Account>)con.getRecords()){
                wrapperAccount wrapAcc = new wrapperAccount();
                wrapAcc.acc = a;                           // Holding Account
                count+=1;
                string s = a.Id;
                s+=count;
                if(SelectedAccountMap.containsKey(s)){
                    wrapAcc.isSelected = true;    // check if Checkbox is checked in vf page    
                }
                else{
                    wrapAcc.isSelected = false;    // Used as Checkbox in vf page, default is not selected
                }
                
                wrapAccountList.add(wrapAcc);   
            }
            system.debug('Called Wrapper method size---- '+wrapAccountList.size());
        return wrapAccountList;
    }
        
    //This methods holds the accounts which is checked and which is unchecked
    public void getSelectedAccount(){
        //System.debug('initialwrapperaccountsize'+wrapaccountlist.size());
        if(wrapAccountList != NULL){
            Integer j=1;
            for(wrapperAccount wr:wrapAccountList){
                j+=1;
                string dupId = wr.acc.Id;
                dupId = dupId+j;
                if(wr.isSelected == true){
                    //SelectedAccountMap.put(wr.acc.id,wr.acc); // Add the selected contact id in to the SelectedAccountMap.
                    SelectedAccountMap.put(dupId,wr.acc); // Add the selected contact id in to the SelectedAccountMap.
                }
                else{
                    SelectedAccountMap.remove(dupId);                   
                }
            }
        }
        System.debug('selectedAccountmap>>>>'+SelectedAccountMap);
        System.debug('selectedAccountmapsize>>>>'+SelectedAccountMap.size());
    }
  
    // Wrapper class will be to used to have list of accounts with checkbox to Add to Campaign
    public class wrapperAccount{
        public Account acc {set;get;}
        public Boolean isSelected {set;get;}
    }
    
    
    //Add campaign members to Retail campiang
    public PageReference addToCampaign(){
    System.debug('retailCampaignId === '+retailCampaignId);
        if(retailCampaignId == null) return null;
        
        //Calling this method to add the current page selected accounts
        getSelectedAccount();
        
        List<Campaign_Member__c> retailCampaignMembers = new List<Campaign_Member__c>();
        Set<String> accountIds = new Set<String>();
        List<Account> selectedAccount = new List<Account>();
        List<Id> selectedAccoundIds = new List<Id>();
 
        // Filtering seletced accounts
         if(SelectedAccountMap.size()>0){
            for(Account temp : SelectedAccountMap.values()){
                selectedAccount.add(temp);
                system.debug('selectedAccounddddddd==='+temp);
            }
            
            system.debug('selectedAccoundIds==='+selectedAccoundIds);
            for(Account curAcc : selectedAccount){
                Campaign_Member__c member = new Campaign_Member__c(Status__c = 'Ready', Retail_Campaign_Id__c = retailCampaignId);
                member.Contact_Id__c= curAcc.id;
                retailCampaignMembers.add(member);
            }
        }
        System.debug('retailCampaignMembersAfter'+retailCampaignMembers);
        try {
            if(retailCampaignMembers != NULL && !retailCampaignMembers.isEmpty())
            insert retailCampaignMembers;
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'You could not add same contact in one Retail Campaign, Please try again.'));
            return null;
        }
        return new PageReference('/' + retailCampaignId);
    }
 
    
    private void setSoql()
    {
       
       system.debug('Entered into inside  setSoql method');
            string personAccntRecTypId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            string personAccntRetailRecTypId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account Retail').getRecordTypeId();
            string dealerAccntRecTypId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            if(selectedValueSales == 'Company' || selectedValueService == 'Company'){
                selectedValue = 'Company';
                accountSoql = 'select Id, Name, PersonHomePhone, PersonMobilePhone, Phone, PersonEmail, City__c from Account '
                + 'where RecordTypeId =\'' + dealerAccntRecTypId + '\' AND Dealer_Type__c = \'' + selectedValue + '\' and ';
            }
            else if(selectedValueSales == 'Outlet' || selectedValueService == 'Outlet'){
                selectedValue = 'Outlet';
                accountSoql = 'select Id, Name, PersonHomePhone, PersonMobilePhone, Phone, PersonEmail, City__c from Account '
                + 'where RecordTypeId =\'' + dealerAccntRecTypId + '\' AND Dealer_Type__c = \'' + selectedValue + '\' and ';
            }
            else {
                accountSoql = 'select Id, Name, PersonHomePhone, PersonMobilePhone, Phone, PersonEmail, City__c from Account '
                + 'where (RecordTypeId =\'' + personAccntRecTypId + '\' or ' 
                + 'RecordTypeId = \'' + personAccntRetailRecTypId + '\' or '
                + 'RecordTypeId = \'' + thirdParty + '\') and ';
            }
            leadSoql = 'Select Contact__c from Lead__c where ';
            //vehicleSoql = 'Select Contact__c,Vehicle_ID__c From Vehicle_Relationship__c where ';
            vehicleRelSoql = 'Select Contact__c,Vehicle_ID__c,Car_Relation__c From Vehicle_Relationship__c where Car_Relation__c = \''+parCampType+'\' AND ';
            campaignMemSoql = 'Select Contact_Id__c From Campaign_Member__c where ';
            AccountLinkSoql = 'Select toRole__c From Account_Link__c where '; 
            RetailTaskSoql = 'Select Account__c From Retail_Task__c where ';
            AddressSoql = 'Select Customer__c From Address__c where ';
            CampaignSoql ='Select id From Campaign where ';
            recallSoql = 'Select Vehicle_Id__c From Recall__c Where';
            
            vehRelLength = vehicleRelSoql.length();
            leadLength =  leadSoql.length();
            retailaskLength = RetailTaskSoql.length();
            campLength = campaignMemSoql.length();
            addressLength = AddressSoql.length();
            accLinkLength = AccountLinkSoql.length();
            recallLength = recallSoql.length();
            
            system.debug('================='+jsonFilter);
            Map<String, Object> filterMap = (Map<String, Object>)JSON.deserializeUntyped(jsonFilter);
            system.debug('I am filter map'+filterMap);
            Map<String, Object> contentMap = (Map<String, Object>)(filterMap.get('content'));
            system.debug('I am content map'+contentMap);
            
            List<Object> customerFilterItems = (List<Object>)contentMap.get('Customer');
            List<Object> leadFilterItems = (List<Object>)contentMap.get('Interest');
            List<Object> vehicleFilterItems = (List<Object>)contentMap.get('Vehicle');
            List<Object> AccountLinkFilterItems = (List<Object>)contentMap.get('AccountLink');
            List<Object> RetailTaskFilterItems = (List<Object>)contentMap.get('Contract');
            List<Object> AddressFilterItems = (List<Object>)contentMap.get('Address');
            List<Object> campaignFilterItems = (List<Object>)contentMap.get('Campaign');
            List<Object> vehicleretailItems = (List<Object>)contentMap.get('VehicleRetailcopy');
            List<Object> vehiclerelItems = (List<Object>)contentMap.get('VehicleRelation');
            
            system.debug('Entered into customerFilterItems setSoql method'+customerFilterItems);
            system.debug('Entered into leadFilterItems setSoql method'+leadFilterItems);
            system.debug('Entered into vehicleFilterItems  setSoql method'+vehicleFilterItems );
            system.debug('Entered into customerFilterItems setSoql method'+vehiclerelItems);
            system.debug('Entered into AccountLinkFilterItems setSoql method'+AccountLinkFilterItems);
            system.debug('Entered into RetailTaskFilterItems setSoql method'+RetailTaskFilterItems);
            system.debug('Entered into AddressFilterItems setSoql method'+AddressFilterItems);
            system.debug('Entered into campaignFilterItems setSoql method'+campaignFilterItems);
            system.debug('Entered into campaignFilterItems setSoql method'+vehicleretailItems);
            
            if(customerFilterItems != NULL && !customerFilterItems.isEmpty()){
                accountFilter = true;
            }
            
            if(vehicleFilterItems != NULL && vehiclerelItems != NULL && !vehicleFilterItems.isEmpty() && !vehiclerelItems.isEmpty()){
                vehicleFind = true;
                vehicleRelFind = true;
             }
             if(vehicleretailItems!= NULL && vehiclerelItems != NULL && !vehicleretailItems.isEmpty() && !vehiclerelItems.isEmpty()){
                vehicleRetailFind = true;
                vehicleRelFind = true;
             }
             if(vehicleFilterItems != NULL && vehicleretailItems != NULL && !vehicleretailItems.isEmpty() && !vehicleFilterItems.isEmpty()){
                 vehicleFind = true; 
                  vehicleRetailFind = true;   
             }
            setSubSoql(customerFilterItems, 'account');
            setSubSoql(leadFilterItems, 'lead');
            setSubSoql(vehicleFilterItems, 'vehicle');
            setSubSoql(vehiclerelItems,'VehicleRelation'); 
            setSubSoql(AccountLinkFilterItems, 'AccountLink');
            setSubSoql(RetailTaskFilterItems, 'RetailTask');
            setSubSoql(AddressFilterItems, 'Address');
            setSubSoql(campaignFilterItems, 'campaign');
            setSubSoql(vehicleretailItems,'VehicleRelation');
    }
    
    private void setSubSoql(List<Object> filterItems, String cluster)
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
                    if(vehicleRelFind && vehicleRetailFind && logic == '' && cluster == 'VehicleRelation'){
                        logic = ' AND ';
                    }
                    if(vehicleFind && vehicleRetailFind && logic == '' && cluster == 'Vehicle'){
                        logic = ' AND ';
                    }
                    
                    if(vehicleFields.contains(field)){
                        field = 'Vehicle_ID__r.' + field;
                        
                    }
                    if(CampaignFields.contains(field)){
                        field = 'Campaign_ID__r.' + field;
                    }
                    
                    if(field == 'PersonBirthdate' && String.valueOf(filterItemMap.get('criteria')).startswith('3000')) {
                        subSoql += 'CALENDAR_MONTH(PersonBirthdate) = ' + String.valueOf(filterItemMap.get('criteria')).split('-')[1] + ' and DAY_IN_MONTH(PersonBirthdate) = ' + String.valueOf(filterItemMap.get('criteria')).split('-')[2];
                    }
                    else if(field == 'ZipCode__c'){
                        subSoql += 'ZipCode__c LIKE \'%' + (String)filterItemMap.get('criteria') + '%\' '; 
                    }else{
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
                    }
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
                system.debug('campaignMemSoql==='+campaignMemSoql);
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
            else
            criteria = (Date.parse(criteria) + ' ').left(10);
        }
        else if(dateTimeFields.contains(field)){
            Datetime criteriaTime = Datetime.newInstance(Date.parse(criteria), Time.newInstance(0,0,0,0));
            criteriaTime = criteriaTime.addDays(-1);
            criteria = (criteriaTime.date() + ' ').left(10) + 'T16:00:00Z';
        }
       
        else if(CheckboxFields.contains(field)){
           return criteria ;
        } 
        return criteria;
    }
   
  
   
    private void setFieldType(){
        numberFields = new Set<String>{'Buy_Cycle__c', 'Household_Amount__c',
            'Vehicle_Amount__c', 'CurrentMileage__c', 'NextMileage__c'};
        dateFields = new Set<String>{'PersonBirthdate', 'Last_Campaign_Date__c', 'LastServiceDate__c', 'End_Date__c',
            'Latest_Contract_Date__c','NextServiceDate__c','FirstRegistrationDate__c', 'Purchase_Date__c', 'Registration_Date__c', 'Warranty_Start_Date__c','Expected_Close_Date__c','Expected_Registration_Date__c','NextServiceDate__c','NextInspectionDate__c'};
        dateTimeFields = new Set<String>{'Last_Successful_Call__c'};
        textFields = new Set<String>{'Recall_No__c','New_Used__c','PersonEmail', 'Modification_Package__c','Model_Description__c', 'FileName__c', 'ID_Number__c', 'Primary_Address__c', 'ZipCode__c', 'PersonMobilePhone', 'PersonHomePhone', 'Phone',
            'Retail_Campaign_Name__c',  'Registration_City__c', 'Selling_Dealer__c', 'File_Name__pc','Name','Portal_ID__c','Sales_Representative__c','Last_Service_Dealer__c','Service_Advisor__c'};
        pickListFields = new Set<String>{'Customer_Type__c','Special_Mark_on_Account__c','Customer_Lifecycle_Phase__c','Status__c', 'Province__c', 'Age_Range__c', 'Gender__c', 'Hobby__c', 'ID_Type__c', 'Industry', 'Job__c', 'Marital_Status__c', 'Occupation__c',
                                     'Type','Type__c', 'Retail_Interested_Vehicle_Brand__c', 'Retail_Interested_Vehicle_Class__c','Lead_Desired_Service__c', 'Lead_Source__c', 'Lead_Type__c', 'Life_Cycle__c','Price_Range__c', 'Retail_Purchase_Time__c', 'Lead_Additional_Service__c', 
                                     'Purchase_Amount__c', 'Trade_In_Vehicle_Brand__c','Trade_In_Vehicle_Class__c', 'Brand__c', 'Range__c','Car_Relation__c', 'Class__c', 'Info_Source__c', 'Dealer_Lead_Status__c','Retail_Sales_Sanction__c','Product_Name__c','Finance_Product_Name__c','New_Used__c'};
        multiplePickListFields = new Set<String>{'Hobby__c', 'Interest_Model__c','Lead_Desired_Service__c', 'Lead_Additional_Service__c','Retail_OptOutContact_Reason__c'};
        vehicleFields = new Set<String>{'Model_Description__c','Modification_Package__c','Range__c','Brand__c','FirstRegistrationDate__c', 'Class__c', 'CurrentMileage__c', 'Info_Source__c', 'LastServiceDate__c',
            'Latest_Contract_Date__c', 'NextMileage__c', 'NextServiceDate__c', 'Warranty_Start_Date__c','NextInspectionDate__c'};
        vehicleRelFields = new Set<String>{'Car_Relation__c', 'Last_Service_Dealer__c', 'Purchase_Date__c',
            'Registration_City__c', 'Registration_Date__c', 'Selling_Dealer__c','Service_Advisor__c','Customer_Type__c','New_Used__c','End_Date__c'};
            CheckboxFields=new Set<string>{'Retail_Visit_OptOut__c', 'Retail_Email_OptOut__c', 'Retail_Fax_OptOut__c', 'Retail_Phone_OptOut__c', 'Retail_Postal_OptOut__c' };
          AccountLinkFields =new Set<String>{'Sales_Representative__c', 'Retail_Visit_OptOut__c', 'Retail_Sales_Sanction__c', 'Retail_Postal_OptOut__c', 'Retail_Phone_OptOut__c', 'Retail_Fax_OptOut__c', 'Retail_Email_OptOut__c', 'Retail_OptOutContact_Reason__c', 'Portal_ID__c' };  
          recallFields = new Set<String>{'Recall_No__c','Status__c'};
          CampaignFields =new Set<String>{'Name', 'Status'};
          RetailTaskFields =new Set<String>{'Product_Name__c', 'Finance_Product_Name__c', 'Type__c', 'Duration__c',  'Duration__c', 'Status__c'};
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