/*
    Type:       Controller for SelectAssignedDealer
    Purpose:    Select assigned dealer for lead__c
    User Story: US-Lead-003
    Used By:    SelectAssignedDealer.page
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-04-12
*/
public with sharing class SelectAssignedDealerController {
    
    private Map<Id, Campaign> campaignMap = new Map<Id, Campaign>(); // Related Campaigns under the Campaign Lead of this lead
    private final Integer QUERY_LIMIT = 200; // Query return limit and Dealer's Record Type Name
    private final String ACCOUNT_RT_DEALER = 'Dealer';
    
    public Lead__c lead                          {get; set;}
    public String name                           {get; set;}
    public Account dealer                        {get; set;}
    public Boolean hasQueryResult                {get; set;}
    public List<Account> dealers                 {get; set;}
    public Id choosenDealerId                    {get; set;}
    public Id choosenCampaignId                  {get; set;}
    public Boolean hasMessage                    {get; set;}
    public Id dealerRecordTypeId                 {get; set;}
    // this was added to check the market discriminator based on the logged in user
    public user usr;
    
    public SelectAssignedDealerController(ApexPages.StandardController controller) {
        usr = [select id,Market__c from user where id =:userInfo.getUserid()];
        lead = [SELECT RecordType.Name, Name, Contact__r.Province__c, Contact__r.City__c, 
                Interested_Vehicle_Brand__c, Combine_Interested_Vehicle_Brand__c, Aftersales_Vehicle_Brand__c
                FROM Lead__c WHERE Id = :controller.getId()];
        
        // Initiate dealer
        dealerRecordTypeId = UtilRecordType.getRecordTypeIdByName('Account', 'Dealer');
        dealer = new Account(RecordTypeId = dealerRecordTypeId, Province__c = lead.Contact__r.Province__c, City__c = lead.Contact__r.City__c);
        
        // Get all related Campaign Leads
        List<Campaign_Lead__c> camLeads = [ SELECT Id, Campaign__r.Name, 
                                                Campaign__c,
                                                Campaign__r.Parent.ParentId
                                            FROM Campaign_Lead__c
                                            WHERE Lead__c = :lead.Id
                                            ORDER BY LastModifiedDate DESC];
        
        // Populate campaignMap
        for (Campaign_Lead__c camLead : camLeads) {
            campaignMap.put(camLead.Campaign__c, camLead.Campaign__r);
        }
        
        // Intiate choosenCampaignId with lastest one
        choosenCampaignId = camLeads.size() > 0 ? 
            camLeads[0].Campaign__c : null;

        query();
    }
    
    /**
     * 2014-3-5 added by Justin Yu -- List the cities which contains at least one dealer
     */
    public List<SelectOption> getCityOptions(){
        List<SelectOption> options = new List<SelectOption>();
        Set<String> cities = new Set<String>();
        for(Account dealer : [select City__c from Account 
            where Dealer_Active__c = true 
            and RecordTypeId =: dealerRecordTypeId and Province__c = :dealer.Province__c]){
            cities.add(dealer.City__c);
        }
        cities.remove(null);
        options.add(new SelectOption('', '--None--'));
        for(String city : cities){
            options.add(new SelectOption(city, city));
        }
        return options;
    }
    
    /**
     * 2014-3-5 added by Justin Yu
     */
    public PageReference refreshPage(){
        return null;
    }
    
    public List<SelectOption> campaignOptions {
        get {
            List<SelectOption> campaignOptions = new List<SelectOption>();
            campaignOptions.add(new SelectOption('', '--None--'));
            for (Campaign cam : campaignMap.values()) {
                campaignOptions.add(new SelectOption(cam.Id, cam.Name));
            }

            return campaignOptions;
        }
    }
    
    public void query() {
        // We must inculde the IsPsersonAccount in the SOQL, otherwise, 
        // we will get exception in debug log but not display on the page
        String querySOQL = 'SELECT ' + this.getColumns() + 
            'IsPersonAccount, Id FROM Account WHERE Dealer_Active__c = true and ' + 
            'RecordType.Name = :ACCOUNT_RT_DEALER AND ';
        // If Lead Record Type is Sales Leads, this filter is must,
        // if not, no need.
      
        if (lead.RecordType.Name == 'Sales Leads') {
            querySOQL += 'Dealer_Service_Codes__c includes (\'Sales\') AND ';
            /********************************
            if (lead.Interested_Vehicle_Brand__c == 'MB' || lead.Interested_Vehicle_Brand__c == 'AMG') {
                querySOQL += 'Dealer_Sales_Type__c includes (\'MB\') AND ';   
            }
            else if (lead.Interested_Vehicle_Brand__c == 'smart') {
                querySOQL += 'Dealer_Sales_Type__c includes (\'smart\') AND ';   
            }
            ********************************/
        }
        else if (lead.RecordType.Name == 'Aftersales Leads') {
            querySOQL += 'Dealer_Service_Codes__c includes (\'Service\') AND ';
            /********************************
            if (lead.Aftersales_Vehicle_Brand__c != 'smart') {
                querySOQL += 'Dealer_Sales_Type__c excludes (\'smart\') AND ';   
            }
            else if (lead.Aftersales_Vehicle_Brand__c == 'smart') {
                querySOQL += 'Dealer_Sales_Type__c includes (\'smart\') AND ';   
            }
            *******************************/
        }
      
        // Filter Part
        if (choosenCampaignId != null) {
            // Get the Central MKT Campaign Id by choosenCampaignId
            Id centralMKTCampaignId = 
                campaignMap.get(choosenCampaignId).Parent.ParentId;

            if (centralMKTCampaignId != null) {
                // This Variable is used for populating all dealers 
                // in related Participating Dealer of Central MKT Campaign
                Set<Id> participatingDealerIds = new Set<Id>();

                // Get all Participate Dealers in Central MKT Campaign
                List<Participating_Dealer__c> parDealers = 
                    [SELECT Id, Dealer__c FROM Participating_Dealer__c
                     WHERE Campaign__c = :centralMKTCampaignId]; 

                // Populate participatingDealerIds
                for (Participating_Dealer__c parDealer : parDealers) {
                    if (parDealer.Dealer__c != null) {
                        participatingDealerIds.add(parDealer.Dealer__c);
                    }
                }
                if (participatingDealerIds.size() > 0) {
                    querySOQL += 'Id IN : participatingDealerIds AND ';
                }
            }
        }
        if (dealer.Dealer_Sales_Type__c != null && dealer.Dealer_Sales_Type__c != '') {
            String Dealer_Sales_Type = dealer.Dealer_Sales_Type__c;
            querySOQL += 'Dealer_Sales_Type__c = :Dealer_Sales_Type AND ';
        }
        if (dealer.Dealer_Service_Codes__c != null && dealer.Dealer_Service_Codes__c != '') {
            String Dealer_Service_Codes = dealer.Dealer_Service_Codes__c;
            querySOQL += 'Dealer_Service_Codes__c = :Dealer_Service_Codes AND ';
        }
        
        if (name != null && name != '') {
            querySOQL += 'Name Like \'%' + name + '%\' AND ';
        }
        system.debug('dealers >>>1 :'+dealer.Dealer_Service_Codes__c);
        system.debug('dealers >>>2 :'+dealer.Dealer_Sales_Type__c);
        if (dealer.Province__c != null && dealer.Province__c != '') {
            String province = dealer.Province__c;
            querySOQL += 'Province__c = :province AND ';
        }
        //for CR-000259 start
        
        if (!String.isblank(dealer.City__c)) {
            String city = dealer.City__c;
            querySOQL += 'City__c = :city AND ';
        }
        // Below condition was added to imprint the logged in user Market discriminator to find dealer(accounts) in his specific market
        if(usr.Market__c != null && usr.Market__c != ''){
            system.debug('usr.Market__c '+ usr.Market__c);
            
            querySOQL += 'MD__c='+'\''+usr.Market__c+'\'';
        }
        system.debug('querySOQL1 '+ querySOQL);
        //for CR-000259 end
        // Query Dealers               
        querySOQL = querySOQL.subString(0, querySOQL.length()) + 
            ' ORDER BY Dealer_Region__c DESC NULLS LAST LIMIT ' + this.QUERY_LIMIT;
        system.debug('querySOQL '+ querySOQL);
        dealers = Database.query(querySOQL);
        system.debug('dealers >>>3 :'+dealers);
        // If no query result, system alert no search result.
        hasQueryResult = (dealers.size() > 0);
        if (!hasQueryResult) {
            this.addInfoMessage(Label.CP_No_Search_Result);
        }
    }
    
    public PageReference choose() {
        // Populate assigned dealer
        hasMessage = false;
        lead.Assigned_Dealer__c = choosenDealerId;
        try {
            update lead;
        }
        catch (DMLException e) {
            this.addErrorMessage(e.getDMLMessage(0));
            hasMessage = true;
            System.debug('Debug Output ======> {' + hasMessage + '}');
        }

        return null;
    }


    // Get the SOQL Expr of DealerSearchColumns FieldSet fields
    private String getColumns() {
        String columns = '';
        for (Schema.FieldSetMember member : this.getFieldSetMembers()) {
            columns += member.getFieldPath() + ', ';
        }
        
        return columns;
    }
    
    // Get the FieldSet Members of Account FieldSet(AssignedDealerColumns)
    private List<Schema.FieldSetMember> getFieldSetMembers() {
        return SObjectType.Account.FieldSets.AssignedDealerColumns.getFields();
    }
    
    //TODO: not used any where
    /*private void addNoParticipatingDealersMessage() {
        dealers = new List<Account>();
        // If no query result, system alert no search result.
        hasQueryResult = (dealers.size() > 0);
        if (!hasQueryResult) {
            this.addInfoMessage('No Participating Dealers');
        }
    }*/

    private void addInfoMessage(String msg) {
        ApexPages.addMessage(new ApexPages.Message(
            ApexPages.severity.INFO, msg));
    }

    private void addErrorMessage(String msg) {
        ApexPages.addMessage(new ApexPages.Message(
            ApexPages.severity.ERROR, msg));
    }
}