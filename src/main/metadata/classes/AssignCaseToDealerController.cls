/*
    Type:       Extension for AssignCaseToDealer Page
    Purpose:    Assign case to dealer
    User Story: AS-Complaint_002(2014Release1.1)
    Used By:    AssignCaseToDealer.page
    ---------------------------------------------------------------
    History:
    
    1. Chaos Created on 2014-02-19

*/
public class AssignCaseToDealerController {
    
    public String userName {get; set;}
    public String dealerName {get; set;}
    public String selectedUserId {get; set;}
    public Case assignCase { get; set; }
    public List<UserWithAccountInfo> users { get; set; }
    public Boolean hasQueryResult { get; set; }
    public static final String ERROR_MSG_1 = Label.Assign_Case_To_Dealer_ErrorMsg1;
    
    // Query return limit and Dealer's Record Type Name
    private final Integer QUERY_LIMIT = 200;
    private final String ACCOUNT_RT_DEALER = 'Dealer';
    private final String DEALER_USER = 'Dealer Community User';
    private final String DEALER_DELEGATED_ADMIN = 'Dealer Delegate Admin';
    
    // Account Address Fields Mapping with Dealer City
    private final Map<String, String> ADDRESS_FIELD_MAPPING = new Map<String, String> {
        'Dealer_Region__c' => 'Dealer_Region__c',
        'Province__c' => 'Province__c',
        'City__c' => 'City__c'
    };
    
    // Two Muti-Select Fields on Account
    private final List<String> MUTI_SELECT_FIELDS = new List<String> {
        'Dealer_Sales_Type__c',
        'Dealer_Service_Codes__c'
    };
    
    public AssignCaseToDealerController() {
        Id caseId = ApexPages.currentPage().getParameters().get('caseId');
        
        try {
            assignCase = [SELECT Id, OwnerId,Case_Dealer__c FROM Case WHERE Id = :caseId];
            system.debug('######################=assignCase0'+assignCase);
        }
        catch (QueryException e) {
            // If user open this from home page, it means, 
            // we don't need to pass province and city
            System.debug('User may open this page in the Home Page Custom Link.');
        }

        query();
    }
    
    public void query() {
        
        users = new List<UserWithAccountInfo>();
        Set<Id> accountIds = new Set<Id>();
        Map<id, String> accountIdAccountBranchName = new Map<id, String>();
            
        String queryDealerSOQL = 'select Id, Branch_name__c from Account where RecordType.Name = :ACCOUNT_RT_DEALER ';
        if(!String.isBlank(dealerName)) {
            queryDealerSOQL += 'AND (Name LIKE \'%' + dealerName + '%\'';
            queryDealerSOQL += ' or Branch_name__c LIKE \'%' + dealerName + '%\')';
        }
            System.debug(queryDealerSOQL);
        for(Account acc : Database.query(queryDealerSOQL)) {
            
            accountIds.add(acc.Id);
            accountIdAccountBranchName.put(acc.Id, acc.Branch_name__c);
        }
        String Dealer='Dealer Delegate Admin';
        String querySOQL = 'Select Id, Name, FirstName, LastName, UserRole.Name, Profile.Name, AccountId ' +
                            'FROM User ' +
                           'WHERE IsActive = true ';// AND ' +
                         //  '(Profile.Name like \%'+Dealer+'%\)';
        String DEALER_DELEGATE_ADMIN=UtilConstant.DEALER_DELEGATE_ADMIN;
        if(!String.isBlank(DEALER_DELEGATE_ADMIN)) {
            querySOQL += ' AND Profile.Name LIKE \'%' + DEALER_DELEGATE_ADMIN + '%\'';
        }                  
        // If userName filter is not null, add it into SOQL
        if(!String.isBlank(userName)) {
            querySOQL += ' AND Name LIKE \'%' + userName + '%\'';
        }
        //if (accountIds.size() > 0) {
            querySOQL += ' AND AccountId in :accountIds ';
        //}

        querySOQL = querySOQL + 
            ' ORDER BY UserRole.Name DESC LIMIT ' + this.QUERY_LIMIT;
        System.debug(querySOQL);
        List<User> oblist=new List<User>();
        if(querySOQL!=Null){
            oblist = Database.query(querySOQL);
        }
        // If no query result, system alert no search result.
        hasQueryResult = (oblist.size() > 0);
        if (!hasQueryResult) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, ERROR_MSG_1));
        }else{
            UserWithAccountInfo uai = null;
            if(oblist!=Null && !oblist.isEmpty()){
            for (User ob : oblist) {
                uai = new UserWithAccountInfo();
                uai.userId = ob.Id;
                //uai.userName = ob.FirstName + ' ' + ob.LastName;
                uai.userName = ob.Name;
                uai.userRoleName = ob.UserRole.Name;
                if(accountIdAccountBranchName.containsKey(ob.AccountId)) {
                    uai.branchName = accountIdAccountBranchName.get(ob.AccountId);
                }
                uai.profileName = ob.Profile.Name;
                users.add(uai);
            }
          }
        }
    }
    // Inner Class
    public class UserWithAccountInfo{
        public String userId                {get; set;}
        public String userName              {get; set;}
        public String userRoleName          {get; set;}
        public String branchName            {get; set;}
        public String profileName           {get; set;}
        
        public UserWithAccountInfo() {}
    }
    
    public void clear() {
        users = new List<UserWithAccountInfo>();
        hasQueryResult = false;
        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO, ERROR_MSG_1));
    }
    
    public void assign() {
        // Set Case owner filed to the selected dealer user
        if (assignCase.OwnerId != selectedUserId) {
            assignCase.OwnerId = selectedUserId;
            assignCase.Case_Dealer__c = [select AccountId from User where id = :selectedUserId].AccountId;
            assignCase.SendEmailToGateKeeper__c = true;
            update assignCase;
        }
    }
}