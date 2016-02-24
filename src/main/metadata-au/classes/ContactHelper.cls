/*
    Type:       Utility for ContactBeforeInsertUpdate, ContactAfterInsertUpdate
    Purpose:    1. Copy contact name, phone, email to Dealer.
                2. There should only be one contact with "Dealer Lead Gate Keeper" selected or "Dealer Complaint Gate Keeper" selected in one Dealer.
                3. There should only be one contact with "Dealer Complaint Manager" selected or "Dealer Presales" selected in one Dealer.
    User Story: US-DP-002
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Sinow Created on 2013-04-28
*/
public class ContactHelper {
    private static final String HasComplaintGetKeeper = 'The Dealer already has a Dealer Complaint Gate Keeper.';
    private static final String HasSalesGetKeeper = 'The Dealer already has a Dealer Lead Gate Keeper.';
    private static final String HasComplaintManager = 'The Dealer already has a Dealer Complaint Manager.';
    private static final String HasPresales = 'The Dealer already has a Dealer Presales.';
    private static final String HasCRMManager = 'The Dealer already has a Dealer CRM Manager.';
    private static final String HasMarketingManager = 'The Dealer already has a Dealer Marketing Manager.';
    private static String dealerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    
    public static void ValidateGateKeeper(List<Contact> contacts) {
        
        List<Contact> newContactsForGateKeeper = new List<Contact>();
        for(Contact con : contacts)
        {
        if(con.Dealer_Complaint_Gate_Keeper__c || con.Dealer_Lead_Gate_Keeper__c) 
            newContactsForGateKeeper.add(con);
        }
        
        if(newContactsForGateKeeper!=null && !newContactsForGateKeeper.Isempty())
        {
            //Set account id of the new Ins/Upd Contact
            Set<Id> AccountIds = new Set<Id>();
            Set<Id> updateContactIds = new Set<Id>();
            
            //Set account Id which has complaint gate keeper
            Set<Id> AccountIdHasComplaintKeeper = new Set<Id>();
            
            //Set account Id which has lead gate keeper
            Set<Id> AccountIdHasSalesKeeper = new Set<Id>();
            
            for(Contact con : contacts)
            {
                AccountIds.add(con.AccountId);
                updateContactIds.add(con.Id);
            }
            
            //Query exist contacts for finding conplaint gate keeper and lead gate keeper
            for(Contact existCon : [select Id, AccountId, Dealer_Complaint_Gate_Keeper__c, Dealer_Lead_Gate_Keeper__c from Contact where Id not in :updateContactIds and AccountId in :AccountIds and (Dealer_Complaint_Gate_Keeper__c = true or Dealer_Lead_Gate_Keeper__c = true)]) {
                if(existCon.Dealer_Complaint_Gate_Keeper__c)
                {
                    AccountIdHasComplaintKeeper.add(existCon.AccountId);
                }
                if(existCon.Dealer_Lead_Gate_Keeper__c)
                {
                    AccountIdHasSalesKeeper.add(existCon.AccountId);
                }
            }
            
            //If find exist gate keeper, show a error message.
            for(Contact con : contacts)
            {
                if(con.Dealer_Complaint_Gate_Keeper__c && AccountIdHasComplaintKeeper.contains(con.AccountId))
                {
                    con.addError(HasComplaintGetKeeper);
                }
                
                if(con.Dealer_Lead_Gate_Keeper__c && AccountIdHasSalesKeeper.contains(con.AccountId))
                {
                    con.addError(HasSalesGetKeeper);
                }
            }   
        }
         
    }
    
    public static void ValidateManager(List<Contact> contacts) {
        
        List<Contact> newContactsForManager = new List<Contact>();
        for(Contact con : contacts)
        {
            if(con.Dealer_Complaint_Manager__c || con.Dealer_Presales__c || con.Dealer_CRM_Manager__c || con.Dealer_Marketing_Manager__c)
                newContactsForManager.add(con);
        }
        if(newContactsForManager!=null && !newContactsForManager.Isempty())
        {
            //Set account id of the new Ins/Upd Contact
            Set<Id> AccountIds = new Set<Id>();
            Set<Id> updateContactIds = new Set<Id>();
            
            //Set account Id which has complaint manager
            Set<Id> AccountIdHasComplaintManager = new Set<Id>();
            
            //Set account Id which has presales
            Set<Id> AccountIdHasPresales = new Set<Id>();
            
            //Set account Id which has crm managers
            Set<Id> AccountIdHasCrmMangers = new Set<Id>();
            
            //Set account Id which has marketing managers
            Set<Id> AccountIdHasMarketingManagers = new Set<Id>();
            
            for(Contact con : contacts)
            {
                AccountIds.add(con.AccountId);
                updateContactIds.add(con.Id);
            }
            
            //Query exist contacts for finding conplaint manager and presales
            for(Contact existCon : [select Id, AccountId, Dealer_Complaint_Manager__c, Dealer_Presales__c, Dealer_CRM_Manager__c, Dealer_Marketing_Manager__c from Contact where Id not in :updateContactIds and AccountId in :AccountIds and (Dealer_Complaint_Manager__c = true or Dealer_Presales__c = true or Dealer_CRM_Manager__c = true or Dealer_Marketing_Manager__c = true)]) {
                if(existCon.Dealer_Complaint_Manager__c)
                {
                    AccountIdHasComplaintManager.add(existCon.AccountId);
                }
                if(existCon.Dealer_Presales__c)
                {
                    AccountIdHasPresales.add(existCon.AccountId);
                }
                if(existCon.Dealer_CRM_Manager__c)
                {
                    AccountIdHasCrmMangers.add(existCon.AccountId);
                }
                if(existCon.Dealer_Marketing_Manager__c)
                {
                    AccountIdHasMarketingManagers.add(existCon.AccountId);
                }
            }
            
            //If find exist camplaint manager, a presales, a crm manager, show a error message.
            for(Contact con : contacts)
            {
                if(con.Dealer_Complaint_Manager__c && AccountIdHasComplaintManager.contains(con.AccountId))
                {
                    con.addError(HasComplaintManager);
                }
                
                if(con.Dealer_Presales__c && AccountIdHasPresales.contains(con.AccountId))
                {
                    con.addError(HasPresales);
                }
                if(con.Dealer_CRM_Manager__c && AccountIdHasCrmMangers.contains(con.AccountId))
                {
                    con.addError(HasCRMManager);
                }
                if(con.Dealer_Marketing_Manager__c && AccountIdHasMarketingManagers.contains(con.AccountId))
                {
                    con.addError(HasMarketingManager);
                }
            }
        }
        
    }
    public static void ValidateBusinessUnit(List<Contact> newContacts) {
        Set<Id> AccountIds = new Set<Id>();
        map<id,Account> accountMap = new  map<id,Account>();
         for(Contact con : newContacts)
            {
                AccountIds.add(con.AccountId);
            }
        for(Account acc:[select id,Business_Unit__c,Dealer_Active__c from Account where Id IN:AccountIds]){
            accountMap.put(acc.id, acc);
        }
        for(Contact con:newContacts){
            if(accountMap.containsKey(con.AccountId)){ 
                   boolean match = sortBusinessUnit(con.Business_Unit__c,accountMap.get(con.AccountId).Business_Unit__c);
                if(match ==false)
                {
                con.addError('Business units of the contact does not  align with the dealership');
                }                   
            }
            
        }
        
    }
     public static boolean sortBusinessUnit(String Contacts,string accounts)     
     {
         List<String> contactBusinessUnit=new List<String>();
         List<String> accountBusinessUnit=new List<String>();
         boolean compare = false;
         String ContactsBu=Contacts;
         String accountBu=accounts;
             if(accountBu!=null)
             {
                String[] acc = accountBu.split('\\;');
                 for(string s:acc)
                 {
                 accountBusinessUnit.add(s);
                 }
             }
         accountBusinessUnit.sort();    
         if(ContactsBu !=null)
         { 
         String[] con = ContactsBu.split('\\;');
            for(string s:con)
             {
             contactBusinessUnit.add(s);
             }
          }
            contactBusinessUnit.sort();
         Set<String> contactset = new Set<String>(contactBusinessUnit);
         Set<String> accountset = new Set<String>(accountBusinessUnit);
         system.debug('contactset contactset contactset '+contactset );
         system.debug('contactset contactset contactset '+accountset );
                if(accountset.containsall(contactset))
                compare =true;
                else
                 compare =false;
              
        return compare;
     }
    public static void AfterInsertUpdateEvents(List<Contact> contacts)
    {
    try
    {
    CustomLogUtil.CustomLoggingEntry(' Contact Helper Class AfterInsertUpdateEvents method '+'contacts= ' + contacts.size());
        List<Contact> ComplaintManagerContacts = new List<Contact>();
        List<Contact> PresalesContacts = new List<Contact>();
        List<Contact> CRMManagerContacts = new List<Contact>();
        List<Contact> MarketingManagerContacts = new List<Contact>(); 
        List<Contact> BusinesUnit = new List<Contact>();
        List<String> aftersalesManagerIds = new List<String>();
        Set<ID> dealerIdsForAssignGateKeeper = new Set<ID>();
        
        //Query new Contacts and map account id and contact infomation
        for(Contact con : contacts)
        {
            if(con.Dealer_Complaint_Manager__c)
            {
                ComplaintManagerContacts.add(con);
            }
            if(con.Dealer_Presales__c)
            {
                PresalesContacts.add(con);
            }
            if(con.Dealer_CRM_Manager__c)
            {
                CRMManagerContacts.add(con);
            }
            if(con.Dealer_Marketing_Manager__c)
            {
                MarketingManagerContacts.add(con);
            }
            if(con.Dealer_Aftersales_Manager__c)
            {
                aftersalesManagerIds.add(con.Id);
            }
            if(con.Dealer_Lead_Gate_Keeper__c)
            {
                dealerIdsForAssignGateKeeper.add(con.AccountId);
            }
             
            if((con.Business_Unit__c !=null) || (con.Business_Unit__c ==null))
            {
                BusinesUnit.add(con);
            }
        }
        
        
        //setup Complaint Manager infos to dealer
        if(ComplaintManagerContacts.size() > 0)
        {
            CopyComplaintManagerInfoToDealer(ComplaintManagerContacts);
        }
        
        //setup presales infos to dealer
        if(PresalesContacts.size() > 0)
        {
            CopyPresalesInfoToDealer(PresalesContacts);
        }
        
        //setup CRM manager infos to dealer
        if(CRMManagerContacts.size() > 0)
        {
            CopyCRMManagerInfoToDealer(CRMManagerContacts);
        }
        
        //setup marketing manager infos to dealer
        if(MarketingManagerContacts.size() > 0)
        {
            CopyMarketingManagerInfoToDealer(MarketingManagerContacts);
        }
        
        // Setup aftersales manager info to dealer
        if(aftersalesManagerIds.size() > 0)
        {
            copyAftersalesManagerInfoToDealer(aftersalesManagerIds);
        }
        
        //Update related Lead owner when Contact's Lead gate keeper is checked.
        dealerIdsForAssignGateKeeper.remove(null);
        if(dealerIdsForAssignGateKeeper.size() > 0)
        {
            assignGateKeeperToLeadOwner(dealerIdsForAssignGateKeeper);
        }
        }
     catch(DMLException ex)
      {
        CustomLogUtil.DebugException(ex);
      }
        system.debug('End of method @@@@@@@ ');
    }
    
           public static void CopyFirstNameLastNameToDRM(List<Contact> contacts,Map<id,Contact> oldContacts) {
    try
    {
    CustomLogUtil.CustomLoggingEntry(' Contact Helper Class CopyFirstNameLastNameToDRM method '+'contacts= ' + contacts.size()); 
    
        Set<Id> accountIds = new Set<Id>(); 
        map<id,Account> relatedAccounts =new map<id,Account>();
        map<id,Account> dealersToUpdate = new map<id,Account>();
        
      
        for(Contact con : contacts) {   
            accountIds.add(con.AccountId);
        }
       
        for(Account ac:[select Id,DRM__c from Account where  Id in: accountIds])
        {
            relatedAccounts.put(ac.id, ac);
            
        }
       
        for(Contact con : contacts) { 
            if(con.Inactive__c==false && con.Salutation=='DRM MBFS' ){
              if(relatedAccounts.containsKey(con.AccountId)){
                       relatedAccounts.get(con.AccountId).DRM__c=con.FirstName + ' ' + con.LastName;                       
                       dealersToUpdate.put(relatedAccounts.get(con.AccountId).id,relatedAccounts.get(con.AccountId));
                       }
                
            }
            else if(con.Inactive__c==false && oldContacts!=null && !oldContacts.isEmpty() && oldContacts.get(con.id).Salutation=='DRM MBFS' && oldContacts.get(con.id).Salutation!=con.Salutation){
                 if(relatedAccounts.containsKey(con.AccountId)){
                       relatedAccounts.get(con.AccountId).DRM__c='';                    
                       dealersToUpdate.put(relatedAccounts.get(con.AccountId).id,relatedAccounts.get(con.AccountId));
                       }
                
            }
        }        
        
        if(dealersToUpdate!=null && !dealersToUpdate.IsEmpty() && dealersToUpdate.values().size() > 0) { 
            
               UtilSobject.updateSobjects(dealersToUpdate.values());
        }
        
       }
      catch(DMLException ex)
      {
        CustomLogUtil.DebugException(ex);
      }
      CustomLogUtil.DebugLogInsert();
    }
    
    public static void CopyComplaintManagerInfoToDealer(List<Contact> contacts) {
        Map<Id, String> AccountIdComplaintManagerInfos = new Map<Id, String>();
        Map<Id, String> AccountIdComplaintManagerEmails = new Map<Id, String>();
        List<Account> DealersToUpdate = new List<Account>();
        String contactInfo;
        
        //Query new Contacts and map account id and contact infomation
        for(Contact con : contacts) {
            contactInfo = con.FirstName + ' ' + con.LastName + '<br/>' + con.Name_English__c + '<br/>' + con.Phone;
            AccountIdComplaintManagerInfos.put(con.AccountId, contactInfo.replace('null', ''));
            AccountIdComplaintManagerEmails.put(con.AccountId, con.Email);
        }
        
        //Query related accounts and setup values from the last map
        for(Account acc : [select Id, Dealer_Complaint_Manager__c, Dealer_Complaint_Manager_Email__c from Account where Id in :AccountIdComplaintManagerInfos.keySet() and RecordTypeId = :dealerRecordTypeId]) {
            acc.Dealer_Complaint_Manager__c = AccountIdComplaintManagerInfos.get(acc.Id);
            acc.Dealer_Complaint_Manager_Email__c = AccountIdComplaintManagerEmails.get(acc.Id);
            DealersToUpdate.add(acc);
        }
        
        if(DealersToUpdate!=null && !DealersToUpdate.IsEmpty()) {
            UtilSobject.updateSobjects(DealersToUpdate);
        }
    }
    
    public static void CopyPresalesInfoToDealer(List<Contact> contacts) {
        Map<Id, String> AccountIdPresalesInfos = new Map<Id, String>();
        Map<Id, String> AccountIdPresalesEmails = new Map<Id, String>();
        List<Account> DealersToUpdate = new List<Account>();
        String contactInfo;
        
        //Query new Contacts and map account id and contact infomation
        for(Contact con : contacts) {
            contactInfo = con.FirstName + ' ' + con.LastName + '<br/>' + con.Name_English__c + '<br/>' + con.Phone;
            AccountIdPresalesInfos.put(con.AccountId, contactInfo.replace('null', ''));
            AccountIdPresalesEmails.put(con.AccountId, con.Email);
        }
        
        //Query related accounts and setup values from the last map
        for(Account acc : [select Id, Dealer_Presales__c, Dealer_Presales_Email__c from Account where Id in :AccountIdPresalesInfos.keySet() and RecordTypeId = :dealerRecordTypeId]) {
            acc.Dealer_Presales__c = AccountIdPresalesInfos.get(acc.Id);
            acc.Dealer_Presales_Email__c = AccountIdPresalesEmails.get(acc.Id);
            DealersToUpdate.add(acc);
        }
        
        if(DealersToUpdate!=null && !DealersToUpdate.IsEmpty()) {
            UtilSobject.updateSobjects(DealersToUpdate);
        }
    }
    
    public static void CopyCRMManagerInfoToDealer(List<Contact> contacts) {
        Map<Id, String> AccountIdCRMManagerInfos = new Map<Id, String>();
        Map<Id, String> AccountIdCRMManagerEmails = new Map<Id, String>();
        List<Account> DealersToUpdate = new List<Account>();
        String contactInfo;
        
        //Query new Contacts and map account id and contact infomation
        for(Contact con : contacts) {
            contactInfo = con.FirstName + ' ' + con.LastName + '<br/>' + con.Name_English__c + '<br/>' + con.Phone;
            AccountIdCRMManagerInfos.put(con.AccountId, contactInfo.replace('null', ''));
            AccountIdCRMManagerEmails.put(con.AccountId, con.Email);
        }
        
        //Query related accounts and setup values from the last map
        for(Account acc : [select Id, Dealer_CRM_Manager__c, Dealer_CRM_Manager_Email__c from Account where Id in :AccountIdCRMManagerInfos.keySet() and RecordTypeId = :dealerRecordTypeId]) {
            acc.Dealer_CRM_Manager__c = AccountIdCRMManagerInfos.get(acc.Id);
            acc.Dealer_CRM_Manager_Email__c = AccountIdCRMManagerEmails.get(acc.Id);
            DealersToUpdate.add(acc);
        }
        
        if(DealersToUpdate!=null && !DealersToUpdate.IsEmpty()) {
            UtilSobject.updateSobjects(DealersToUpdate);
        }
    }
    
    public static void copyMarketingManagerInfoToDealer(List<Contact> contacts) {
        Map<Id, String> AccountIdMarketingManagerInfos = new Map<Id, String>();
        Map<Id, String> AccountIdMarketingManagerEmails = new Map<Id, String>();
        List<Account> DealersToUpdate = new List<Account>();
        String contactInfo;
        
        //Query new Contacts and map account id and contact infomation
        for(Contact con : contacts) {
            contactInfo = con.FirstName + ' ' + con.LastName + '<br/>' + con.Name_English__c + '<br/>' + con.Phone;
            AccountIdMarketingManagerInfos.put(con.AccountId, contactInfo.replace('null', ''));
            AccountIdMarketingManagerEmails.put(con.AccountId, con.Email);
        }
        
        //Query related accounts and setup values from the last map
        for(Account acc : [select Id, Dealer_Marketing_Manager__c, Dealer_Marketing_Manager_Email__c from Account where Id in :AccountIdMarketingManagerInfos.keySet() and RecordTypeId = :dealerRecordTypeId]) {
            acc.Dealer_Marketing_Manager__c = AccountIdMarketingManagerInfos.get(acc.Id);
            acc.Dealer_Marketing_Manager_Email__c = AccountIdMarketingManagerEmails.get(acc.Id);
            DealersToUpdate.add(acc);
        }
        
        if(DealersToUpdate!=null && !DealersToUpdate.IsEmpty()) {
            UtilSobject.updateSobjects(DealersToUpdate);
        }
    }
    
    public static void copyAftersalesManagerInfoToDealer(List<String> contactIds) {
        List<Account> dealers = new List<Account>();
        for(Contact con : [select Name, Email, Title, Phone, Account.Dealer_Aftersales_Manager__c, Account.Dealer_Aftersales_Manager_Email__c from Contact where Id in :contactIds]){
            String title = con.Title == null ? '' : con.Title;
            String phone = con.Phone == null ? '' : con.Phone;
            con.Account.Dealer_Aftersales_Manager__c = con.Name + '\n' + title + '\n' + phone;
            con.Account.Dealer_Aftersales_Manager_Email__c = con.Email;
            dealers.add(con.Account);
        }
        if(dealers.size() > 0){
            update dealers;
        }
    }
    
    public static void assignGateKeeperToLeadOwner(Set<ID> dealerIds) {
        Map<String, User> userMap = new Map<String, User>();
        for(User usr : [select Id, AccountId, Contact.AccountId from User 
                        where  isActive = true and ContactId != null and Contact.AccountId in :dealerIds and Contact.Dealer_Lead_Gate_Keeper__c = true]){
            userMap.put(usr.Contact.AccountId, usr);
        }
        
        List<Lead__c> leads = new List<Lead__c>();
        for(Lead__c lead : [select Assigned_Dealer__c, OwnerId 
                            from Lead__c 
                            where Assigned_Dealer__c in :dealerIds
                            and (Dealer_LMS__c = 'Salesforce' or (Dealer_LMS__c = 'LMS' and RecordType.Name = 'Aftersales Leads'))]){
            if(String.valueOf(lead.OwnerId).startsWith('00G')){
                if(userMap.keySet().contains(lead.Assigned_Dealer__c)){
                    lead.OwnerId = userMap.get(lead.Assigned_Dealer__c).Id;
                    leads.add(lead);
                }
            }
        }
        if(leads.size() > 0){
            try{
                update leads;
            }
            catch(Exception ex){
                Trigger.new[0].addError(ex.getMessage());
            }
        }
    }
    
    public static void updateBusinessUnit(List<Account> accounts){
    try
       { 
    CustomLogUtil.CustomLoggingEntry('contact Helper class updateBusinessUnit Method'+  'accounts'+ accounts.size()); 
        map<Id,Account> accountid=new map<Id,Account>();
        List<Account> listAcc=new List<Account>();
        List<Contact> listCon=new List<Contact>();
        List<Contact> UpdateCon=new List<Contact>();
    
            if(accounts!=null && !accounts.isEmpty())
            {
                for(Account acc:accounts)
                {
                accountid.put(acc.id,acc);
                }
            }
            
            listCon=[Select id,AccountId,Business_Unit__c from Contact Where AccountId=:accountid.keySet()];
                if(listCon!=null && !listCon.isEmpty())
                {
                   
                        for(Contact con:listCon)
                        {   
                            if(accountid.containsKey(con.AccountId)){
                                if(accountid.get(con.AccountId).id==con.AccountId)
                        
                                    con.Business_Unit__c=accountid.get(con.AccountId).Business_Unit__c;
                                    UpdateCon.add(con);
                            }
                        }
                     
                    
               }    
        if(UpdateCon!=null && !UpdateCon.IsEmpty()) {  
        System.debug('@@@@@@@@@@@@@ UpdateCon'+UpdateCon);       
         UtilSobject.updateSobjects(UpdateCon);          
        }
    }
     catch(DMLException ex)
      {
        CustomLogUtil.DebugException(ex);
      }
      CustomLogUtil.DebugLogInsert();
    }
}