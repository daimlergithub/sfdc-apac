/** 
* Utility for Trigger on Contact to handle generic code
* Dealer gate keeper validation functionality 
* Author: Honey
* Created Date : 2018-07-11
*/
public class ContactHelperBase { 
    
    private static final String HasSalesGetKeeper = 'The Dealer already has a Dealer Lead Gate Keeper.';
    private static Set<Id> AccountIds = new Set<Id>();
    private static Set<Id> updateContactIds = new Set<Id>(); 
    
    public static void AfterInsertUpdateEvents(List<Contact> contacts){        
        //Query new Contacts and map account id and contact infomation
        set<ID> dealerIdsForAssignGateKeeper = new Set<ID>(); 
        for(Contact con : contacts){
            if(con.Dealer_Lead_Gate_Keeper__c){
                dealerIdsForAssignGateKeeper.add(con.AccountId);
            }
          }
        //Update related Lead owner when Contact's Lead gate keeper is checked.
        dealerIdsForAssignGateKeeper.remove(null);
        if(dealerIdsForAssignGateKeeper.size() > 0){
            assignGateKeeperToDealer(dealerIdsForAssignGateKeeper);
        }
    } 
    
    public static void assignGateKeeperToDealer(Set<ID> dealerIds) {
        Boolean flag = false;
        Map<String, User> userMap = new Map<String, User>();
        List<Opportunity> leads = new List<Opportunity>();
        List<User> usrList=[select Id, AccountId, Contact.AccountId, contact.account.Dealer_Lead_Gate_Keeper__c from User 
                        where  isActive = true and ContactId != null and Contact.AccountId in :dealerIds and Contact.Dealer_Lead_Gate_Keeper__c = true];
        List<Account> lDealersNotChanged = new List<Account>();  
        List<Account> lDealersChanged = new List<Account>(); 
        for(User usr : usrList){
            userMap.put(usr.Contact.AccountId, usr);
            if(usr.contact.account.Dealer_Lead_Gate_Keeper__c == NULL){
                lDealersNotChanged.add(new Account(id = usr.Contact.AccountId,Dealer_Lead_Gate_Keeper__c = usr.id));
            }
            else{
                lDealersChanged.add(new Account(id = usr.Contact.AccountId,Dealer_Lead_Gate_Keeper__c = usr.id));
            }
        }
        if(!lDealersNotChanged.isEmpty()){
            try{
                update lDealersNotChanged;
            }
            catch(Exception ex){
                Trigger.new[0].addError(ex.getMessage());
            }
        }
        if(!lDealersChanged.isEmpty()){
            String leadStatus = System.Label.Contact_Lead_Status;
            List<String> ldsts = String.isNotBlank(leadStatus) ? leadStatus.split(',') : NULL;
            if(ldsts != NULL && !ldsts.isEmpty()){
                for(Opportunity lead : [select Assigned_Dealer__r.Dealer_Lead_Gate_Keeper__c, Assigned_Dealer__c, OwnerId from Opportunity where Assigned_Dealer__c in :dealerIds and stagename in :ldsts]){ 
                    if((lead.ownerID == NULL || lead.OwnerId == lead.Assigned_Dealer__r.Dealer_Lead_Gate_Keeper__c) && userMap.keySet().contains(lead.Assigned_Dealer__c)){                  
                        lead.OwnerId = userMap.get(lead.Assigned_Dealer__c).Id;
                        leads.add(lead);
                    }
                }
            }
            if(leads.size() > 0){
                try{
                    update leads;
                    flag = true;
                }
                catch(Exception ex){
                    Trigger.new[0].addError(ex.getMessage());
                }
            }
            if(!lDealersChanged.isEmpty() && lDealersChanged.size() > 0 && flag){
                try{
                    update lDealersChanged;
                }
                catch(Exception ex){
                    Trigger.new[0].addError(ex.getMessage());
                }
            }   
        }
    }

    public static void validateGateKeeper(List<Contact> contacts) {
        List<Contact> newContactsForGateKeeper = new List<Contact>(); 
        for(Contact con : contacts){
            if(con.Dealer_Lead_Gate_Keeper__c) 
                newContactsForGateKeeper.add(con);
            }
        validateGateKeeperforContacts(contacts,newContactsForGateKeeper);
    } 

    public static void validateAccountandContactIds(List<Contact> contacts) {
        for(Contact con : contacts){
                AccountIds.add(con.AccountId);
                updateContactIds.add(con.Id);
            }
    }
    
    public static void validateGateKeeperforContacts(List<Contact> contacts,List<Contact> newContactsForGateKeeper){
        if(newContactsForGateKeeper!=null && !newContactsForGateKeeper.Isempty()){
            //Set account Id which has complaint gate keeper
            Set<Id> AccountIdHasComplaintKeeper = new Set<Id>();            
            //Set account Id which has lead gate keeper
            Set<Id> AccountIdHasSalesKeeper = new Set<Id>();
            validateAccountandContactIds(contacts);          
            List<Contact> lstContact=[select Id, AccountId, Dealer_Lead_Gate_Keeper__c from Contact where Id not in :updateContactIds and AccountId in :AccountIds and Dealer_Lead_Gate_Keeper__c = true]; 
            //Query exist contacts for finding conplaint gate keeper and lead gate keeper
            for(Contact existCon : lstContact) {
                if(existCon.Dealer_Lead_Gate_Keeper__c){
                    AccountIdHasSalesKeeper.add(existCon.AccountId);
                }
            }           
        HasDealerGateKeeper(contacts, AccountIdHasSalesKeeper); 
    }
}

    public static void HasDealerGateKeeper(List<Contact> contacts, Set<Id> AccountIdHasSalesKeeper) {
      //If find exist gate keeper, show a error message.
        for(Contact con : contacts){
            if(con.Dealer_Lead_Gate_Keeper__c && AccountIdHasSalesKeeper.contains(con.AccountId)){
                con.addError(HasSalesGetKeeper);
            }
        }
    }   
}