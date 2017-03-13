/*
    Page Controller
    ---------------------------------------------------------------
    History:
    
    1. Justin Yu Created on 2014-05-14
    2. Lokesh M Last modified date : 2017-0Mar-02
       JIRA - SFDCJP-1023
*/
public without sharing class RetailCampaignSegmentationController {
    
    private String retailCampaignId;
    private String thirdParty;
    Boolean vehicleFind;
    Boolean vehicleRelFind;
    Boolean vehicleRetailFind;
    
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
    private Set<String> accountIds;
    private Set<Id> addAccountIds;
    
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
    
        
    public RetailCampaignSegmentationController()
    {
        //Added community license switching mechanism
       if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
       {
            listLimit = 100;
            thirdParty = Schema.SObjectType.Account.getRecordTypeInfosByName().get('3rd Party').getRecordTypeId();
            retailCampaignId = ApexPages.currentPage().getParameters().get('id');
            attendedCampaign = '';
            hasReferralRecord = noComplaint = false;
            setFieldType();
            
            User user = [select ContactId from User where Id = :UserInfo.getUserId()];
            if(user.ContactId != null){
                contact = [select Id, AccountId, SegmentationFilters__c from Contact where Id = :user.ContactId];
            } 
       }
    }
    
    /**
     * Properties -->
     */
    public Transient List<Account> accounts { get; set; }
    public Transient List<Account> limitAccounts;
    public Contact contact { get; set; }
    public String jsonFilter { get; set; }
    
    // Special Filters
    public String attendedCampaign { get; set; }
    public Boolean hasReferralRecord { get; set; }
    public Boolean noComplaint { get; set; }
    public Decimal carServiceAmount { get; set; }
    
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
    
    String[] Values= new String[]{};//define array string to store value in Sales Dealer field in Vf page
  public String selectedValue {set;get;}
  
   public String[] countries = new String[]{};
       
            
        public List<SelectOption> getItems() {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('None','--None--'));
            options.add(new SelectOption('Company','Company'));
            options.add(new SelectOption('Outlet','Outlet'));
            return options;
        }
            
        public String[] getCountries() {
            return countries;
        }
            
        public void setCountries(String[] countries) {
            this.countries = countries;
        }
    
        
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
    
    public List<SelectOption> hobbyOptions{
        get{
            hobbyOptions = new List<SelectOption>();
            hobbyOptions.add(new SelectOption('', '--None--'));
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account.fields.Hobby__c;
            for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                hobbyOptions.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
            return hobbyOptions;
        }
        set;
    }
    public List<SelectOption> leadDesiredServiceOptions{
        get{
            leadDesiredServiceOptions = new List<SelectOption>();
            leadDesiredServiceOptions.add(new SelectOption('', '--None--'));
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Lead__c.fields.Lead_Desired_Service__c;
            for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                leadDesiredServiceOptions.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
            return leadDesiredServiceOptions;
        }
        set;
    }
    
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
    
    //addred by lokesh M
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
     //added by lokesh m
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
    
    
     //added by lokesh m
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
    
    public List<SelectOption> leadAdditionalServiceOptions{
        get{
            leadAdditionalServiceOptions = new List<SelectOption>();
            leadAdditionalServiceOptions.add(new SelectOption('', '--None--'));
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Lead__c.fields.Lead_Additional_Service__c;
            for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                leadAdditionalServiceOptions.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
            return leadAdditionalServiceOptions;
        }
        set;
    }
    public List<SelectOption> leadClassOptions{
        get{
            leadClassOptions = new List<SelectOption>();
            leadClassOptions.add(new SelectOption('', '--None--'));
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Lead__c.fields.Interested_Vehicle_Class__c;
            for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                leadClassOptions.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
            return leadClassOptions;
        }
        set;
    }
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
    
    /**
     * Methods -->
     */
    @RemoteAction
    public static void saveFilter(String newfilter){
        User user = [select ContactId from User where Id = :UserInfo.getUserId()];
        if(user.ContactId != null){
            Contact contact = [select SegmentationFilters__c from Contact where Id = :user.ContactId];
            if(String.isBlank(contact.SegmentationFilters__c) || contact.SegmentationFilters__c == '[]'){
                contact.SegmentationFilters__c = '[' + newfilter + ']';
            }
            else{
                String originalFilter = contact.SegmentationFilters__c.substring(1, contact.SegmentationFilters__c.length() - 1);
                contact.SegmentationFilters__c = '[' + originalFilter + ',' + newfilter + ']';
            }
            update contact;
        }
    }
    
    @RemoteAction
    public static void deleteFilter(String deletefilterName){
        User user = [select ContactId from User where Id = :UserInfo.getUserId()];
        if(user.ContactId != null){
            Contact contact = [select SegmentationFilters__c from Contact where Id = :user.ContactId];
              
               List<Object> filterList = (List<Object>)JSON.deserializeUntyped(contact.SegmentationFilters__c);
                 List<Object> filterListNew = new List<Object>();
                for(Object item : filterList){
                    Map<String, Object> filterMap = (Map<String, Object>)item;
                    if (deletefilterName != (String)filterMap.get('name')){
                    filterListNew.add(item);
                    }
                }
            contact.SegmentationFilters__c = JSON.serialize(filterListNew);
            update contact;
        }
    }
    
    public PageReference searchAccount()
    {
     
    System.debug('------------'+selectedValue);
    system.debug('Entered into Search method');
        //Added community license switching mechanism
       if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
       {
           wrapAccountList = null;
           vehicleRelFind = false;
           vehicleFind = false;
           VehicleRetailFind = false;
            setSoql();
            accounts = new List<Account>();
            addAccountIds = new Set<Id>();
            accountIds = new Set<String>();
             
            
            try{
                // Has Attended Campaign filter
                if(attendedCampaign != ''){
                    for(CampaignMember member : [select Contact.AccountId from CampaignMember where Campaign.Name = :attendedCampaign.trim()]){
                        accountIds.add(member.Contact.AccountId);
                    }
                }
                
                                     system.debug('@@@@@@vehiclerelSoql '+vehicleRelSoql);

                if(!vehicleRelSoql.endsWith('where ')) {
                
                    vehicleRelSoql = vehicleRelSoql.replace('Last_Service_Dealer__c', 'Last_Service_Dealer__r.Name').replace('Service_Advisor__c','Service_Advisor__r.Name');
                     system.debug('@@@@@@accountSoql'+accountSoql);
                    if(accountSoql.endsWith('and ')){
                        accountSoql += 'Id in ' + vehicleRelSoql + ')';
                    }
                    else{
                        accountSoql += ' and Id in ' + vehicleRelSoql + ')';
                    }
                   system.debug('@@@@@@accountSoql '+accountSoql); 
                }
                 system.debug('@@@@@@leadSoql '+leadSoql);
                if(!leadSoql.endsWith('where ')) {
                    leadSoql = leadSoql.replace('Retail_Campaign_Name__c', 'Retail_Campaign_Name__r.Name');
                    if(accountSoql.endsWith('and ')){ 
                        accountSoql += 'Id in ' + leadSoql + ')'; 
                    }
                    else{ 
                        accountSoql += ' and Id in' + leadSoql + ')'; 
                    }
                }
                
                
                
                
                system.debug('@@@@@@AccountLinkSoql '+AccountLinkSoql);
                if(!AccountLinkSoql.endsWith('where ')) {
                   // AccountLinkSoql = AccountLinkSoql.replace('toRole__c', 'toRole__r.Name');
                   AccountLinkSoql = AccountLinkSoql.replace('Sales_Representative__c', 'Sales_Representative__r.Name');
                    system.debug('@@@@@@AccountLinkSoql '+AccountLinkSoql);
                             if(accountSoql.endsWith('and ')){ 
                        accountSoql += 'Id in ' + AccountLinkSoql + ')'; 
                    }
                    else{ 
                        accountSoql += ' and Id in' + AccountLinkSoql + ')'; 
                    }
                }
                
                system.debug('@@@@@@AccountLinkSoql '+RetailTaskSoql);
                if(!RetailTaskSoql.endsWith('where ')) {
                    //RetailTaskSoql = RetailTaskSoql.replace('Account__c', 'Account__r.Name');
                    if(accountSoql.endsWith('and ')){ 
                        accountSoql += 'Id in ' + RetailTaskSoql + ')'; 
                    }
                    else{ 
                        accountSoql += ' and Id in' + RetailTaskSoql + ')'; 
                    }
                }
                
                system.debug('@@@@@@AddressSoql '+AddressSoql);
                if(!AddressSoql.endsWith('where ')) {
                  //  AddressSoql = AddressSoql.replace('Customer__c', 'Customer__r.Name');
                    if(accountSoql.endsWith('and ')){ 
                        accountSoql += 'Id in ' + AddressSoql + ')'; 
                    }
                    else{ 
                        accountSoql += ' and Id in' + AddressSoql + ')'; 
                    }
                }
                
                 system.debug('@@@@@@campaignMemSoql'+campaignMemSoql);
                if(!campaignMemSoql.endsWith('where ')) {
                  //  AddressSoql = AddressSoql.replace('Customer__c', 'Customer__r.Name');
                    if(accountSoql.endsWith('and ')){ 
                        accountSoql += 'Id in ' + campaignMemSoql+ ')'; 
                    }
                    else{ 
                        accountSoql += ' and Id in' + campaignMemSoql+ ')'; 
                    }
                }
                
               
                
                // Searchs the accounts according to the Customer Filter 
                if(!accountIds.isEmpty() || attendedCampaign != ''){
                    if(accountSoql.endsWith('and ')){
                        accountSoql += 'Id in :accountIds ';
                    }
                    else{
                        accountSoql += ' and Id in :accountIds ';
                    }
                }
                system.debug('----------' + accountSoql);
                Map<String, Account> accountMap = new Map<String, Account>();
                Set<String> indexs = new Set<String>();   // Removes the multiple accounts.
                List<Account> tempAccounts = Database.query(accountSoql + 'limit 50000');
                if (Limits.getQueries() +  tempAccounts.size() >= 50000 ) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, Label.LimitQueries));
                    return null;
                }
                for(Account acc : tempAccounts) {
                    String phone = acc.PersonHomePhone == null ? '' : acc.PersonHomePhone
                                 + acc.PersonMobilePhone == null ? '' : acc.PersonMobilePhone
                                 + acc.Phone == null ? '' : acc.Phone;
                    if(!indexs.contains(acc.name + phone)){
                        accountMap.put(acc.Id, acc);
                        indexs.add(acc.name + phone);
                    }
                }
                system.debug('test 1'+accountMap);
                // Has Referral Record filter
                if(accountMap.isEmpty()){ return null; }
                
                if(hasReferralRecord){
                    Map<String, Account> clonedAccountMap = accountMap.clone();
                    accountMap.clear();
                    for(Lead__c lead : [select Referal_Referee_Name__r.AccountId from Lead__c 
                                        where Referal_Referee_Name__r.AccountId in :clonedAccountMap.keySet()]){
                        accountMap.put(lead.Referal_Referee_Name__r.AccountId, clonedAccountMap.get(lead.Referal_Referee_Name__r.AccountId));
                    }
                }
                system.debug('test 1'+accountMap);
                // No Complaint filter
                if(accountMap.isEmpty()){ return null; }
                
                if(noComplaint){
                    for(Case c : [select AccountId from Case where AccountId in :accountMap.keySet()]){
                        accountMap.remove(c.AccountId);
                    }
                }
                
                if(accountMap.values().size() > 10000){
                    accounts = new list<Account>();
                    limitAccounts = new list<Account>();
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'sorry the target customers are more than 10,000 please modify your segmentation filters and check again.'));
                    return null;
                }
                
                system.debug('11111'+accountMap);
                system.debug('2222'+Contact);
                // Total Amount Spend On Car Service filter
                if(!accountMap.isEmpty() || Contact == null){ 
                for(String id : accountMap.keyset()) {
                    addAccountIds.add(id);
                }
                accounts = accountMap.values();
                system.debug('calling load wrapper'); 
                loadWrapAccounts();
                return null; }
                system.debug('near loadwrapper');
                if(carServiceAmount != null){
                
                    Map<String, Decimal> totalAmountMap = new Map<String, Decimal>();
                    for(Retail_Task__c rt : [select Service_Amount__c, Related_Contact__c from Retail_Task__c 
                                            where Related_Contact__c in :accountMap.keySet() and Service_Dealer__c = :contact.AccountId]){
                        Decimal amount = totalAmountMap.get(rt.Related_Contact__c);
                        amount = amount == null ? 0 : amount;
                        totalAmountMap.put(rt.Related_Contact__c, rt.Service_Amount__c + amount);
                    }
                    for(String accId : totalAmountMap.keySet()){
                        if(totalAmountMap.get(accId) < carServiceAmount){
                            accountMap.remove(accId);
                        }
                    }
                }
                accounts = accountMap.values();
                for(String id : accountMap.keyset()) {
                    addAccountIds.add(id);
                }
            }
            catch(Exception ex){
            //'Logic Error!'
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getmessage()));
            }
       }
        return null;
    }
    
    public Account[] getlimitAccounts()
    {
       
        integer counter = 0;
        integer loopCount = 0;
        limitAccounts = new list<Account>();
        system.debug('================limit account'+limitAccounts );
        system.debug('================ accounts'+accounts );
        if(accounts != null){     
            for(Account a : accounts){
                if(counter < listLimit){
       
                        limitAccounts.add(a);
                    counter++;
                }else{
                    break;
                }
            }
        }
        return limitAccounts;
    }
    
    public List<wrapperAccount> wrapAccountList {set;get;}
    // This method process accounts and formats List of wrapper Accounts to be used with checkbox 
    public void loadWrapAccounts()
    {
        wrapAccountList = new  List<wrapperAccount>();
        integer counter = 0;
        integer loopCount = 0;
        if(accounts != null){     
            for(Account a : accounts){
                if(counter < listLimit){
                        wrapperAccount wrapAcc = new wrapperAccount();
                        wrapAcc.acc = a;               // Holding Account
                        wrapAcc.isSelected = false;    // Used as Checkbox in vf page, default is not selected
                        wrapAccountList.add(wrapAcc);
                    counter++;
                }else{
                    break;
                }
            }
        }
        system.debug('Called Wrapper method ---- '+wrapAccountList);
    }
    
    // Wrapper class will be to used to have list of accounts with checkbox to Add to Campaign
    public class wrapperAccount{
        public Account acc {set;get;}
        public Boolean isSelected {set;get;}
    }
    
    public PageReference addToCampaign(){
    System.debug('retailCampaignId === '+retailCampaignId+'addAccountIds'+addAccountIds.size());
        if(retailCampaignId == null || addAccountIds.size()== 0) return null;
        
        Map<String, Campaign_Member__c> retailCampaignMembers = new Map<String, Campaign_Member__c>();
        Set<String> accountIds = new Set<String>();
        List<Id> selectedAccoundIds = new List<Id>();
        Map<Id,String> accName = new Map<Id,String>();
         System.debug('wrapAccountList==='+wrapAccountList);
        // Filtering seletced accounts
        for(wrapperAccount temp : wrapAccountList){
            if(temp.isSelected)
                selectedAccoundIds.add(temp.acc.Id);
                accName.put(temp.acc.Id,temp.acc.name);
        }
        system.debug('selectedAccoundIds==='+selectedAccoundIds);
        for(Id id: selectedAccoundIds){
            Campaign_Member__c member = new Campaign_Member__c(Status__c = 'Ready', Retail_Campaign_Id__c = retailCampaignId);
            member.Name = accName.get(id);
            member.Contact_Id__c= id;
            retailCampaignMembers.put(member.Contact_Id__c+ ':' + member.Retail_Campaign_Id__c, member);
           
        }
        System.debug('retailCampaignMembersBefore'+retailCampaignMembers);
        // Removes the exsitent member
        for(Campaign_Member__c rcm : [select Contact_Id__c, Retail_Campaign_Id__c from Campaign_Member__c
                                            where Contact_Id__c in :selectedAccoundIds and Retail_Campaign_Id__c = :retailCampaignId]){
            retailCampaignMembers.remove(rcm.Contact_Id__c + ':' + rcm.Retail_Campaign_Id__c );
           // retailCampaignMembers.remove(rcm.Contact__c,rcm.Retail_Campaign__c);
        }
        System.debug('retailCampaignMembersAfter'+retailCampaignMembers);
        System.debug('retailCampaignMembersAftervalues'+retailCampaignMembers.values());

        try {
            if(retailCampaignMembers != NULL && !retailCampaignMembers.isEmpty())
            insert retailCampaignMembers.values();
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, 'You could not add same contact in one Retail Campaign, Please try again.'));
            return null;
        }
        return new PageReference('/' + retailCampaignId);
    }
    
    private void setSoql()
    {
        
        //Added community license switching mechanism
       if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
       {
       
       system.debug('Entered into inside  setSoql method');
            string personAccntRecTypId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            string personAccntRetailRecTypId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account Retail').getRecordTypeId();
            string dealerAccntRecTypId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            if(selectedValue == 'Company' || selectedValue == 'Outlet'){
                accountSoql = 'select Id, Name, PersonHomePhone, PersonMobilePhone, Phone, PersonEmail, City__c from Account '
                + 'where RecordTypeId =\'' + dealerAccntRecTypId + '\' AND Dealer_Type__c = \'' + selectedValue + '\' AND ';
            }
            /*else if(selectedValue == 'Outlet'){
                accountSoql = 'select Id, Name, PersonHomePhone, PersonMobilePhone, Phone, PersonEmail, City__c from Account '
                + 'where (RecordTypeId =\'' + dealerAccntRecTypId + '\' AND Dealer_Type__c = Company AND'
            }*/
            else {
                accountSoql = 'select Id, Name, PersonHomePhone, PersonMobilePhone, Phone, PersonEmail, City__c from Account '
                + 'where (RecordTypeId =\'' + personAccntRecTypId + '\' or ' 
                + 'RecordTypeId = \'' + personAccntRetailRecTypId + '\' or '
                + 'RecordTypeId = \'' + thirdParty + '\') and ';
            }
            leadSoql = '(Select Contact__c from Lead__c where ';
            vehicleSoql = '(Select Contact__c From Vehicle_Relationship__c where ';
            vehicleRelSoql = '(Select Contact__c From Vehicle_Relationship__c where ';
            campaignMemSoql = '(Select Contact_Id__c From Campaign_Member__c where ';
            AccountLinkSoql = '(Select toRole__c From Account_Link__c where '; 
            RetailTaskSoql = '(Select Account__c From Retail_Task__c where ';
            AddressSoql = '(Select Customer__c From Address__c where ';
            
            CampaignSoql ='(Select id From Campaign where ';
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
            
            if(vehicleFilterItems != NULL && vehiclerelItems != NULL && !vehicleFilterItems.isEmpty() && !vehiclerelItems.isEmpty()){
                vehicleFind = true;
                vehicleRelFind = true;
             }
             if(vehicleretailItems!= NULL && vehiclerelItems != NULL && !vehicleretailItems.isEmpty() && !vehiclerelItems.isEmpty()){
                vehicleRetailFind = true;
                vehicleRelFind = true;
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
    }
    
    private void setSubSoql(List<Object> filterItems, String cluster)
    {
        //Added community license switching mechanism
       if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
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
                    if(vehicleRelFind && vehicleFind && logic == '' && cluster == 'vehicle'){
                        System.debug('beforeField--'+field+'--operation--'+operation+'--Criteraia--'+criteria+'--logic--'+logic+'---');
                        logic = ' AND ';
                        System.debug('AfterField--'+field+'--operation--'+operation+'--Criteraia--'+criteria+'--logic--'+logic+'---');
                    }
                    if(vehicleRelFind && vehicleRetailFind && logic == '' && cluster == 'VehicleRelation'){
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
                    else if(field == 'Primary_Address__c'){
                        subSoql += 'Primary_Address__c LIKE \'%' + (String)filterItemMap.get('criteria') + '%\' '; 
                    }else if(field == 'Registration_City__c'){
                        subSoql += 'Registration_City__c LIKE \'%' + (String)filterItemMap.get('criteria') + '%\' '; 
                    }else if(field == 'ZipCode__c'){
                        subSoql += 'ZipCode__c LIKE \'%' + (String)filterItemMap.get('criteria') + '%\' '; 
                    }else{
                        System.debug('BeforeAddLogicSubSoql'+subSoql);
                        subSoql += field + operation + criteria + ' '; 
                        System.debug('AfterAddLogicSubSoql'+subSoql);
                    }
                     system.debug('sub soql'+subSoql);
                     System.debug('bracket'+bracket);
                    if(bracket){
                        system.debug('BeforesubSoqlremoveEnd'+subSoql);
                        subSoql = subSoql.removeEnd(' ');
                        system.debug('AftersubSoqlremoveEnd'+subSoql);
                        subSoql += (++bracketCount > 1 ? ') ' : ' ') + logic + ' (';
                        system.debug('bracketCount'+subSoql);
                    }
                    else{
                    System.debug('beforeaaaaaaaa'+subSoql);
                       
                        subSoql += logic + ' ';
                        System.debug('aaaaaaaa'+subSoql);
                    }
                    System.debug('finalsubsoql'+subSoql);
                    if(cluster == 'account'){
                        accountSoql += subSoql;
                    }
                    else if(cluster == 'lead'){
                        leadSoql += subSoql;
                    }
                    
                    else if(cluster == 'vehicle' || cluster == 'VehicleRelation'){
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
    }
    
    private String getOperation(String operation){
        operation = operation.replace('Not Equals', '!=');
        operation = operation.replace('Equals', '=');
        operation = operation.replace('Greater Than', '>');
        operation = operation.replace('Less Than', '<');
        return operation;
    }
    
    private String getCriteria(String field, String criteria){
        System.debug('----'+field+'--criteria '+criteria);
        System.debug('pickListFields.contains(field) '+pickListFields.contains((field.trim())));
        if(textFields.contains(field) || pickListFields.contains(field) || multiplePickListFields.contains(field)){
            System.debug('criteria : '+criteria);
            return '\'' + criteria + '\'';
        }
        else if(dateFields.contains(field)){
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
            'Vehicle_Amount__c', 'CurrentMileage__c', 'NextMileage__c', 'Recall__c'};
        dateFields = new Set<String>{'PersonBirthdate', 'Last_Campaign_Date__c', 'LastServiceDate__c', 'End_Date__c',
            'Latest_Contract_Date__c','NextServiceDate__c','FirstRegistrationDate__c', 'Purchase_Date__c', 'Registration_Date__c', 'Warranty_Start_Date__c','Expected_Close_Date__c','Expected_Registration_Date__c','MOT_Expired_Date__c','NextInspectionDate__c'};
        dateTimeFields = new Set<String>{'Last_Successful_Call__c'};
        textFields = new Set<String>{'New_Used__c','PersonEmail', 'FileName__c', 'ID_Number__c', 'Primary_Address__c', 'ZipCode__c', 'PersonMobilePhone', 'PersonHomePhone', 'Phone',
            'Retail_Campaign_Name__c',  'Registration_City__c', 'Selling_Dealer__c', 'File_Name__pc','Name','Portal_ID__c','Sales_Representative__c','Last_Service_Dealer__c','Service_Advisor__c'};
        pickListFields = new Set<String>{'Customer_Type__c','Special_Mark_on_Account__c','Customer_Lifecycle_Phase__c','Status__c', 'Province__c', 'Age_Range__c', 'Gender__c', 'Hobby__c', 'ID_Type__c', 'Industry', 'Job__c', 'Marital_Status__c', 'Occupation__c',
                                     'Type', 'Retail_Interested_Vehicle_Brand__c', 'Retail_Interested_Vehicle_Class__c','Lead_Desired_Service__c', 'Lead_Source__c', 'Lead_Type__c', 'Life_Cycle__c','Price_Range__c', 'Retail_Purchase_Time__c', 'Lead_Additional_Service__c', 
                                     'Purchase_Amount__c', 'Trade_In_Vehicle_Brand__c','Trade_In_Vehicle_Class__c', 'Brand__c', 'Car_Relation__c', 'Class__c', 'Info_Source__c', 'CAC_Lead_Status__c','Retail_Sales_Sanction__c','Product_Name__c','Finance_Product_Name__c','New_Used__c'};
        multiplePickListFields = new Set<String>{'Hobby__c', 'Interest_Model__c','Lead_Desired_Service__c', 'Lead_Additional_Service__c','Retail_OptOutContact_Reason__c'};
        vehicleFields = new Set<String>{'Brand__c','FirstRegistrationDate__c', 'Class__c', 'CurrentMileage__c', 'Info_Source__c', 'LastServiceDate__c',
            'Latest_Contract_Date__c', 'NextMileage__c', 'NextServiceDate__c', 'Warranty_Start_Date__c','Recall__c','NextInspectionDate__c'};
        vehicleRelFields = new Set<String>{'Car_Relation__c', 'Last_Service_Dealer__c', 'Purchase_Date__c',
            'Registration_City__c', 'Registration_Date__c', 'Selling_Dealer__c','Service_Advisor__c','Customer_Type__c','New_Used__c','End_Date__c'};
            CheckboxFields=new Set<string>{'Retail_Visit_OptOut__c', 'Retail_Email_OptOut__c', 'Retail_Fax_OptOut__c', 'Retail_Phone_OptOut__c', 'Retail_Postal_OptOut__c' };
          AccountLinkFields =new Set<String>{'Sales_Representative__c', 'Retail_Visit_OptOut__c', 'Retail_Sales_Sanction__c', 'Retail_Postal_OptOut__c', 'Retail_Phone_OptOut__c', 'Retail_Fax_OptOut__c', 'Retail_Email_OptOut__c', 'Retail_OptOutContact_Reason__c', 'Portal_ID__c' };  
          
          CampaignFields =new Set<String>{'Name', 'Status'};
          RetailTaskFields =new Set<String>{'Product_Name__c', 'Finance_Product_Name__c', 'Re_lease_Prohibit_flag__c', 'Duration__c',  'Duration__c', 'Status__c'};
          AddressFields = new Set<String>{'ZipCode__c' , 'Province__c'};
    }
}