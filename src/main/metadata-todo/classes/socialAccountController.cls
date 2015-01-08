/*
    Type:       Social Account Extension
    Purpose:    Result the account list and binding account
    User Story: US-SM-001 - Social Media

    Used By:    (Page)SocialAccountPage
    ---------------------------------------------------------------
    History:

    7-June-2013 Stephano.shi (Breakingpoint)    Created
*/
public class socialAccountController{
    
    public String srchAccName{get; set;}                                    // account name for searching
    public String smName{get; set;}                                         // social media account name
    public String fName{get; set;}                                          // social media first name
    public String lName{get; set;}                                          // social media last name
    public String phoneNumber{get; set;}                                    // contact number from webchat or weibo
    public String socialMeidaId{get; set;}                                  // social media id from webchat or weibo
    public String soicalType{get; set;}                                     // social type: webchat / weibo
    public List<Account> seletedAccounts = new List<Account>();             // selected account list in social media account page.
    public List<accountwrapper> accountList = new List<accountwrapper>();   // reuslt account list.
    public String saveUrl{get; set;}                                        // URL
    public String message{get; set;}
    public String nolink{get; set;}
    public String newid{get; set;}
    
    /********************************************************************/
    /* The extension constructor initializes the private member         */
    /* variable acct by using the getRecord method from the standard    */
    /* controller.                                                      */
    /********************************************************************/    
    public socialAccountController() {
        phoneNumber = ApexPages.currentPage().getParameters().get('phone');     // parament contact number
        socialMeidaId = ApexPages.currentPage().getParameters().get('smID');    // parament soical media id
        fName = ApexPages.currentPage().getParameters().get('fname');     // parament first name
        lName = ApexPages.currentPage().getParameters().get('lname');      // parament last name
        smName = ApexPages.currentPage().getParameters().get('sm_Nick_Name');       // parament soical media user name
        soicalType = ApexPages.currentPage().getParameters().get('smType');     // parament soical media type
        srchAccName = (phoneNumber!='') ? phoneNumber : '电话号码...';
        nolink = 'inline';
        //saveUrl = '/a1P/e?Name='+socialMeidaId+'&00NO0000000sGZP='+smName+'&00NO0000000s9EF='+soicalType;
        saveUrl = '/apex/SocialAccountPage?smID=' + socialMeidaId + '&sm_Nick_Name=' + smName + '&smType=' + soicalType;
        newid = ApexPages.currentPage().getParameters().get('newid');
        
    }
    
    /* Searching person account, when page initialized. */
    public PageReference getAccounts(){
        Boolean isLink = false; // if the account is linked up.
        // clear account list result preivous
        accountList.clear();    
        
        // Account with Social media account result
        for(Account a : [Select OwnerId,Id, Name, Type, customer_number__c, Primary_Address__c, Phone, PersonAssistantPhone, PersonMobilePhone, Province__c, City_CN__c, PersonEmail, Hobby__c, (SELECT Id,Name FROM Social_Media_Accounts__r) From Account Where PersonMobilePhone = :phoneNumber AND isPersonAccount=true]){
            for(Social_Media_Account__c sm : a.Social_Media_Accounts__r){
                // If the account has been linked up.
                if(socialMeidaId != '' && socialMeidaId != null && socialMeidaId.equals(sm.Name)){
                    isLink = true;
                    break;
                }
            }
            // displayed account list
            accountList.add(new accountwrapper(a,false,isLink));
            // default link variable
            isLink = false;
        }
        return null;
    }
    
    /* Display the detail of account which is selected */
    public PageReference getSelected(){
        // clear account list result preivous        
        seletedAccounts.clear();

        for(accountwrapper accwrapper : accountList){
            if(accwrapper.selected == true){
                seletedAccounts.add(accwrapper.acc);
            }
        }
        return null;
    }
    
    /* seletedAccounts get method */
    public List<Account> getSeletedAccounts(){
        if(seletedAccounts.size()>0)
             return seletedAccounts;
        else
            return null;
    }  
    
    /* accountList get method */
    public List<accountwrapper> getAccountList(){
        if(accountList.size()>0)
             return accountList;
        else
            return null;
    }  
    
    /* Inner Class : accountwrapper         */
    /* @Variable    : Account acc           */
    /* @Variable    : Boolean selected      */
    /* @Variable    : Boolean linked        */    
    public class accountwrapper{
        public Account acc{get; set;}
        public Boolean selected {get; set;}
        public Boolean linked {get; set;}
        public accountwrapper(Account a, boolean sel, boolean link){
            acc = a;
            selected = sel;
            linked = link;
        }
    }
    
    /* Link the social user to selected account */
    public PageReference linksUp(){
        if(seletedAccounts.size() > 0){
            Account acc = (Account)seletedAccounts[0];
            List<Contact> cons = [Select Id From Contact Where AccountId = :acc.Id Limit 1];
            Id conId = cons.size() > 0 ? cons[0].Id : null;
            // Create Social Media Account
            Social_Media_Account__c smAcc = new Social_Media_Account__c(Account__c=acc.Id, Contact_Id__c = conId, Nick_Name__c=smName, Name=socialMeidaId, Type__c=soicalType);
            insert smAcc; 
            message = 'It is successfully linked up with Account:[' + acc.Name + ']!';
            nolink = 'none';
        }
        
        // Linked flag
        for(accountwrapper accwrapper : accountList){
            if(accwrapper.selected == true){
                accwrapper.linked = true;
            }
        }
        
        // Clear accounts
        //seletedAccounts.clear();
        return null;
    }
    
    /* Searching person account, when page initialized. */
    public PageReference srchAccounts(){
        Boolean isLink = false; // if the account is linked up.
        // clear account list result preivous
        accountList.clear();    
 
        String likeQry = 'Select OwnerId,Id, Name, Type, Primary_Address__c, customer_number__c, Phone, PersonAssistantPhone, PersonMobilePhone, Province__c, City_CN__c, PersonEmail, Hobby__c, (SELECT Id,Name FROM Social_Media_Accounts__r) From Account Where (PersonMobilePhone like \'%' + srchAccName + '%\') AND isPersonAccount=true';
        if(newid != null && newid.length() > 10){
            likeQry = 'Select OwnerId,Id, Name, Type, Primary_Address__c, customer_number__c, Phone, PersonAssistantPhone, PersonMobilePhone, Province__c, City_CN__c, PersonEmail, Hobby__c, (SELECT Id,Name FROM Social_Media_Accounts__r) From Account Where (Id=:newid) AND isPersonAccount=true';
        }
    
        List<Account> accList = Database.query(likeQry);
        System.debug('AccountList1>>'+accList);
        
        // Account with Social media account result
        for(Account a : accList){
            for(Social_Media_Account__c sm : a.Social_Media_Accounts__r){
                // If the account has been linked up.
                if(socialMeidaId != '' && socialMeidaId != null && socialMeidaId.equals(sm.Name)){
                    isLink = true;
                    break;
                }
            }
            // displayed account list
            accountList.add(new accountwrapper(a,false,isLink));
            // default link variable
            isLink = false;
        }
        System.debug('AccountList2>>'+accountList);
        return null;
    }
}