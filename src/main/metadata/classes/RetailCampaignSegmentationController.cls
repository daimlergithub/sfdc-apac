/*
    Page Controller
    ---------------------------------------------------------------
    History:
    
    1. Justin Yu Created on 2014-05-14
*/
public without sharing class RetailCampaignSegmentationController {
    
    private String retailCampaignId;
    private String thirdParty;
    
    // For soql
    private String mainSoql;
    private String accountSoql;
    private String leadSoql;
    private String vehicleRelSoql;
    private String AccountLinkSoql;
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
    
    //added by Lokes m
    public List<SelectOption> status{
        get{
            status= new List<SelectOption>();
            status.add(new SelectOption('', '--None--'));
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account.fields.status__c;
            for(Schema.PicklistEntry entry : fieldResult.getPicklistValues()){
                status.add(new SelectOption(entry.getValue(), entry.getLabel()));
            }
            return status;
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
    
     public List<SelectOption> RetailOptOutContactReason{
        get{
            RetailOptOutContactReason= new List<SelectOption>();
            RetailOptOutContactReason.add(new SelectOption('', '--None--'));
            Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Account.fields.Special_Mark_on_Account__c;
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
    system.debug('Entered into Search method');
        //Added community license switching mechanism
       if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
       {
       system.debug('Entered into Search method');
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
                
                if(!vehicleRelSoql.endsWith('where ')) {
                    vehicleRelSoql = vehicleRelSoql.replace('Last_Service_Dealer__c', 'Last_Service_Dealer__r.Name').replace('Selling_Dealer__c', 'Selling_Dealer__r.Name');
                    if(accountSoql.endsWith('and ')){
                        accountSoql += 'Id in ' + vehicleRelSoql + ')';
                    }
                    else{
                        accountSoql += ' and Id in ' + vehicleRelSoql + ')';
                    }
                }
                
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
                    if(accountSoql.endsWith('and ')){ 
                        accountSoql += 'Id in ' + AccountLinkSoql + ')'; 
                    }
                    else{ 
                        accountSoql += ' and Id in' + AccountLinkSoql + ')'; 
                    }
                }
                
                system.debug('@@@@@@AccountLinkSoql '+RetailTaskSoql);
                if(!RetailTaskSoql.endsWith('where ')) {
                    RetailTaskSoql = RetailTaskSoql.replace('Account__c', 'Account__r.Name');
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
                
                 system.debug('@@@@@@CampaignSoql '+CampaignSoql);
                if(!CampaignSoql.endsWith('where ')) {
                  //  AddressSoql = AddressSoql.replace('Customer__c', 'Customer__r.Name');
                    if(accountSoql.endsWith('and ')){ 
                        accountSoql += 'Id in ' + CampaignSoql + ')'; 
                    }
                    else{ 
                        accountSoql += ' and Id in' + CampaignSoql + ')'; 
                    }
                }
                
               
              /*   // Vehicle filter
                if(!vehicleRelSoql.endsWith('where ')){
                    if(!accountIds.isEmpty()) {
                        vehicleRelSoql += 'and Contact__c in :accountIds '; 
                    }
                    List<Vehicle_Relationship__c> vehicleRels = Database.query(vehicleRelSoql + ' limit 50000');
                    if (Limits.getQueries() +  vehicleRels.size() >= 50000 ) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '50001 Error. Please add more filters.'));
                        return null;
                    }
                    accountIds.clear();
                    for(Vehicle_Relationship__c vr : vehicleRels){
                        accountIds.add(vr.Contact__c);
                    }
                }
   
                // Interest Filter
                system.debug('#########'+accountIds);
                 system.debug('#########accountSoql'+accountSoql);
                if(!leadSoql.endsWith('where ')){
                    if(!accountIds.isEmpty()) {
                        leadSoql += 'and Contact__c in :accountIds '; 
                    }
                    List<Lead__c> leads = Database.query(leadSoql + ' limit 50000');
                    if (Limits.getQueries() +  leads.size() >= 50000 ) {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, '50001 Error. Please add more filters.'));
                        return null;
                    }
                    accountIds.clear();
                    for(Lead__c lead : leads){
                        accountIds.add(lead.Contact__c);
                    }
                }  */
                
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
                
                // Total Amount Spend On Car Service filter
                if(accountMap.isEmpty() || Contact == null){ 
                for(String id : accountMap.keyset()) {
                    addAccountIds.add(id);
                }
                accounts = accountMap.values(); 
                return null; }
                
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
    
    public PageReference addToCampaign(){
        if(retailCampaignId == null || addAccountIds.size()== 0) return null;
        
        Map<String, Retail_Campaign_Member__c> retailCampaignMembers = new Map<String, Retail_Campaign_Member__c>();
        Set<String> accountIds = new Set<String>();
        
        for(Id id: addAccountIds){
            Retail_Campaign_Member__c member = new Retail_Campaign_Member__c(Status__c = 'New', Retail_Campaign__c = retailCampaignId);
            member.Contact__c = id;
            retailCampaignMembers.put(member.Contact__c + ':' + member.Retail_Campaign__c, member);
        }
        
        // Removes the exsitent member
        for(Retail_Campaign_Member__c rcm : [select Contact__c, Retail_Campaign__c from Retail_Campaign_Member__c 
                                            where Contact__c in :accountIds and Retail_Campaign__c = :retailCampaignId]){
            retailCampaignMembers.remove(rcm.Contact__c + ':' + rcm.Retail_Campaign__c);
        }
        
        try {
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
            /*
            accountSoql = 'select Id, Name, PersonHomePhone, PersonMobilePhone, Phone, PersonEmail, City__c from Account '
                + 'where (RecordTypeId = \'01290000000fpFD\' or ' 
                + 'RecordTypeId = \'01290000000rXmS\' or ' 
                + 'RecordTypeId = \'' + thirdParty + '\') and ';
            leadSoql = 'select Id, Contact__c from Lead__c where ';
            vehicleRelSoql = 'select Id, Contact__c from Vehicle_Relationship__c where ';
            
            + '(Select Id, Contact__c From Vehicle_Relationships2__r VEHICLEFILTER ), '
            + '(select Id, Contact__c from Lead_Contact__r LEADFILTER)'
            */
            
            string personAccntRecTypId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            string personAccntRetailRecTypId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account Retail').getRecordTypeId();
            accountSoql = 'select Id, Name, PersonHomePhone, PersonMobilePhone, Phone, PersonEmail, City__c from Account '
                + 'where (RecordTypeId =\'' + personAccntRecTypId + '\' or ' 
                + 'RecordTypeId = \'' + personAccntRetailRecTypId + '\' or '
                + 'RecordTypeId = \'' + thirdParty + '\') and ';
            leadSoql = '(Select Contact__c from Lead__c where ';
            vehicleRelSoql = '(Select Contact__c From Vehicle_Relationship__c where ';
            AccountLinkSoql = '(Select toRole__c From Account_Link__c where '; 
            RetailTaskSoql = '(Select Account__c From Retail_Task__c where ';
            AddressSoql = '(Select Customer__c From Address__c where ';
            
            CampaignSoql ='(Select id From Campaign where ';
            
            Map<String, Object> filterMap = (Map<String, Object>)JSON.deserializeUntyped(jsonFilter);
            Map<String, Object> contentMap = (Map<String, Object>)(filterMap.get('content'));
            List<Object> customerFilterItems = (List<Object>)contentMap.get('Customer');
            List<Object> leadFilterItems = (List<Object>)contentMap.get('Interest');
            List<Object> vehicleFilterItems = (List<Object>)contentMap.get('Vehicle');
            List<Object> AccountLinkFilterItems = (List<Object>)contentMap.get('AccountLink');
            List<Object> RetailTaskFilterItems = (List<Object>)contentMap.get('RetailTask');
            List<Object> AddressFilterItems = (List<Object>)contentMap.get('Address');
            List<Object> campaignFilterItems = (List<Object>)contentMap.get('campaign');
            
            system.debug('Entered into customerFilterItems setSoql method'+customerFilterItems);
            system.debug('Entered into leadFilterItems setSoql method'+leadFilterItems);
            system.debug('Entered into vehicleFilterItems  setSoql method'+vehicleFilterItems );
            system.debug('Entered into AccountLinkFilterItems setSoql method'+AccountLinkFilterItems);
            system.debug('Entered into RetailTaskFilterItems setSoql method'+RetailTaskFilterItems);
            system.debug('Entered into AddressFilterItems setSoql method'+AddressFilterItems);
            system.debug('Entered into campaignFilterItems setSoql method'+campaignFilterItems);
            
            setSubSoql(customerFilterItems, 'account');
            setSubSoql(leadFilterItems, 'lead');
            setSubSoql(vehicleFilterItems, 'vehicle');
            setSubSoql(AccountLinkFilterItems, 'AccountLink');
            setSubSoql(RetailTaskFilterItems, 'RetailTask');
            setSubSoql(AddressFilterItems, 'Address');
            setSubSoql(campaignFilterItems, 'campaign');
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
                    String field = (String)filterItemMap.get('field');
                    String operation = getOperation((String)filterItemMap.get('operation'));
                    String criteria = getCriteria(field, (String)filterItemMap.get('criteria'));
                    String logic = (String)filterItemMap.get('logic');
                    Boolean bracket = (Boolean)filterItemMap.get('bracket');
                    String subSoql = '';
                    
                    if(vehicleFields.contains(field)){
                        field = 'Vehicle_ID__r.' + field;
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
                        subSoql += field + operation + criteria + ' '; 
                    }
                    
                    if(bracket){
                        subSoql = subSoql.removeEnd(' ');
                        subSoql += (++bracketCount > 1 ? ') ' : ' ') + logic + ' (';
                    }
                    else{
                        subSoql += logic + ' ';
                    }
                    
                    if(cluster == 'account'){
                        accountSoql += subSoql;
                    }
                    else if(cluster == 'lead'){
                        leadSoql += subSoql;
                    }
                    else if(cluster == 'vehicle'){
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
                    else if(cluster == 'campaign'){
                        CampaignSoql += subSoql;
                    }
                }
                
                if(cluster == 'account'){
                    accountSoql += (bracketCount > 0 ? ') ' : '');
                }
                else if(cluster == 'lead'){
                    leadSoql += (bracketCount > 0 ? ') ' : '');
                }
                else if(cluster == 'vehicle'){
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
                    CampaignSoql += (bracketCount > 0 ? ') ' : '');
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
        if(textFields.contains(field) || pickListFields.contains(field) || multiplePickListFields.contains(field)){
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
           return  True  + criteria ;
        }
        
       
        return criteria;
    }
    
    private void setFieldType(){
        numberFields = new Set<String>{'Buy_Cycle__c', 'Household_Amount__c',
            'Vehicle_Amount__c', 'CurrentMileage__c', 'NextMileage__c', 'Recall__c'};
        dateFields = new Set<String>{'PersonBirthdate', 'Last_Campaign_Date__c', 'LastServiceDate__c', 
            'Latest_Contract_Date__c','NextServiceDate__c','FirstRegistrationDate__c', 'Purchase_Date__c', 'Registration_Date__c', 'Warranty_Start_Date__c','Expected_Close_Date__c','Expected_Registration_Date__c'};
        dateTimeFields = new Set<String>{'Last_Successful_Call__c'};
        textFields = new Set<String>{'PersonEmail', 'FileName__c', 'ID_Number__c', 'Primary_Address__c', 'ZipCode__c', 'PersonMobilePhone', 'PersonHomePhone', 'Phone',
            'Retail_Campaign_Name__c',  'Registration_City__c', 'Selling_Dealer__c', 'File_Name__pc'};
        pickListFields = new Set<String>{'Status__c', 'Province__c', 'Age_Range__c', 'Gender__c', 'Hobby__c', 'ID_Type__c', 'Industry', 'Job__c', 'Marital_Status__c', 
            'Occupation__c', 'Type', 'Retail_Interested_Vehicle_Brand__c', 'Retail_Interested_Vehicle_Class__c',
            'Lead_Desired_Service__c', 'Lead_Source__c', 'Lead_Type__c', 'Life_Cycle__c',
            'Price_Range__c', 'Retail_Purchase_Time__c', 'Lead_Additional_Service__c', 'Purchase_Amount__c', 'Trade_In_Vehicle_Brand__c',
            'Trade_In_Vehicle_Class__c', 'Brand__c', 'Car_Relation__c', 'Class__c', 'Info_Source__c', 'CAC_Lead_Status__c','Customer_Lifecycle_Phase__c'};
        multiplePickListFields = new Set<String>{'Hobby__c', 'Lead_Desired_Service__c', 'Lead_Additional_Service__c'};
        
        vehicleFields = new Set<String>{'Brand__c','FirstRegistrationDate__c', 'Class__c', 'CurrentMileage__c', 'Info_Source__c', 'LastServiceDate__c',
            'Latest_Contract_Date__c', 'NextMileage__c', 'NextServiceDate__c', 'Warranty_Start_Date__c'};
        vehicleRelFields = new Set<String>{'Car_Relation__c', 'Last_Service_Dealer__c', 'Purchase_Date__c', 'Recall__c',
            'Registration_City__c', 'Registration_Date__c', 'Selling_Dealer__c'};
            CheckboxFields=new Set<string>{'Retail_Visit_OptOut__c', 'Retail_Email_OptOut__c', 'Retail_Fax_OptOut__c', 'Retail_Phone_OptOut__c', 'Retail_Postal_OptOut__c' };
          AccountLinkFields =new Set<String>{'Sales_Representative__c', 'Retail_Visit_OptOut__c', 'Retail_Sales_Sanction__c', 'Retail_Postal_OptOut__c', 'Retail_Phone_OptOut__c', 'Retail_Fax_OptOut__c', 'Retail_Email_OptOut__c', 'Retail_OptOutContact_Reason__c', 'Portal_ID__c' };  
          
          CampaignFields =new Set<String>{'Name' , 'Status'};
          RetailTaskFields =new Set<String>{'Product_Name__c', 'Finance_Product_Name__c', 'Re_lease_Prohibit_flag__c', 'Duration__c',  'Duration__c', 'Status__c'};
          AddressFields = new Set<String>{'ZipCode__c' , 'Province__c'};
    }
}