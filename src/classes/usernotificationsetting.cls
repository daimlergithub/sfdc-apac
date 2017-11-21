/*********************************************************************************************
LastModifiedBy    : SivaRamaKrishna Aduri
LastModifiedDate  : Apr 12,2017
Description       : usernotificationsetting
*********************************************************************************************/

public class usernotificationsetting{

    public id uid{get;set;}
    public List<Account> acclst{set;get;}
    public string strname{set;get;}
    public user usertoupdate{set;get;}
    public Id dealeracctrt;
    
    public List<String> selectedUserIds { get; set; }
    public List<String> selectedUserIds2 { get; set; }
    public List<String> selectedUserIds3 { get; set; }
    
    public List<String> removedUserIds { get; set; }
    public List<String> removedUserIds2 { get; set; }
    public List<String> removedUserIds3 { get; set; }
        
    private Map<Id, String> availableUsersMap;
    private Map<Id, String> availableUsersMap2;
    private Map<Id, String> availableUsersMap3;
    
    //To populate already selected user in selected list
    private Map<Id, String> alreadySelectedUsersMap;
    
    private Map<Id, String> selectedUsersMap;
    private Map<Id, String> selectedUsersMap2;
    private Map<Id, String> selectedUsersMap3;

    private List<SelectOption> selectedUsers{set;get;}

    //Strings to store already seleted values
    private Set<String> NotificationLeadDealerAssignmentSet ;
    private Set<String> NotificationLeadNotAssignedSet ;
    private Set<String> NotificationLeadNoUpdateSet ;
    
    public usernotificationsetting(ApexPages.StandardController controller) {
        initializeCollections();
        uid = apexpages.currentpage().getparameters().get('id');
        dealeracctrt= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        usertoUpdate=[select id,name,Dealer_GC_Code__c ,contactid,Notification_Lead_Dealer_Assignment__c,Notification_Lead_Not_Assigned__c,Notification_Lead_No_Update__c from user where id=:uid]; 
        strname=usertoupdate.Dealer_GC_Code__c;
        if(usertoUpdate.Notification_Lead_Dealer_Assignment__c != NULL && !String.isBlank(usertoUpdate.Notification_Lead_Dealer_Assignment__c))
        for(String s : usertoUpdate.Notification_Lead_Dealer_Assignment__c.split(';')){
            NotificationLeadDealerAssignmentSet.add(s);
        }
        if(usertoUpdate.Notification_Lead_Not_Assigned__c != NULL && !String.isBlank(usertoUpdate.Notification_Lead_Not_Assigned__c))
        for(String s : usertoUpdate.Notification_Lead_Not_Assigned__c.split(';')){
            NotificationLeadNotAssignedSet.add(s);
        }
        if(usertoUpdate.Notification_Lead_No_Update__c!= NULL && !String.isBlank(usertoUpdate.Notification_Lead_No_Update__c))
        for(String s : usertoUpdate.Notification_Lead_No_Update__c.split(';')){
            NotificationLeadNoUpdateSet.add(s);
        }
        getUsers();
    }
    
    private void initializeCollections() {
        selectedUserIds = new List<String>();
        selectedUserIds2 = new List<String>();
        selectedUserIds3 = new List<String>();
        removedUserIds = new List<String>();
        removedUserIds2 = new List<String>();
        removedUserIds3 = new List<String>();
        availableUsersMap = new Map<Id, String>();
        availableUsersMap2 = new Map<Id, String>();
        availableUsersMap3 = new Map<Id, String>();
        selectedUsersMap = new Map<Id, String>();
        selectedUsersMap2 = new Map<Id, String>();        
        selectedUsersMap3 = new Map<Id, String>(); 
        selectedUsers = new List<SelectOption>();   
        alreadySelectedUsersMap = new Map<Id,String>();
        NotificationLeadDealerAssignmentSet = new Set<string>();
        NotificationLeadNotAssignedSet = new Set<string>();
        NotificationLeadNoUpdateSet = new Set<string>();
    
    }

    private void getUsers() {
        for (Account u : [select Id,Name,Dealer_GC_Code__c,Dealer_ND_Code__c from Account where  Dealer_GC_Code__c =:strname AND recordtypeId=:dealeracctrt]) {
            availableUsersMap.put(u.Id, u.Name);
            availableUsersMap2.put(u.Id, u.Name);
            availableUsersMap3.put(u.Id, u.Name);
        }
       
        //For Notification Lead Dealer Assignment   
        for(Id curId : availableUsersMap.keySet()){
            if(NotificationLeadDealerAssignmentSet.contains(availableUsersMap.get(curId))){
                 selectedUsersMap.put(curId, availableUsersMap.get(curId));
                 availableUsersMap.remove(curId);
            }
        }
        
        //For Notification Lead NOT Assignment   
        for(Id curId : availableUsersMap2.keySet()){
            if(NotificationLeadNotAssignedSet.contains(availableUsersMap2.get(curId))){
                 selectedUsersMap2.put(curId, availableUsersMap2.get(curId));
                 availableUsersMap2.remove(curId);
            }
        }
        
        //For Notification Lead No Update      
        for(Id curId : availableUsersMap3.keySet()){
            if(NotificationLeadNoUpdateSet.contains(availableUsersMap3.get(curId))){
                 selectedUsersMap3.put(curId, availableUsersMap3.get(curId));
                 availableUsersMap3.remove(curId);
            }
        }
    }
     
    //For Notification Lead Dealer Assignment
   public void add() {
        if (!selectedUserIds.isEmpty()) {
            for (String userId : selectedUserIds) {
                selectedUsersMap.put(userId, availableUsersMap.get(userId));
                availableUsersMap.remove(userId);
            }
        }
    }

    public void remove() {
        if (!removedUserIds.isEmpty()) {
            for (String userId : removedUserIds) {
                availableUsersMap.put(userId, selectedUsersMap.get(userId));
                selectedUsersMap.remove(userId);
            }
        }
    }
    
    public List<SelectOption> getAvailableUsers() {
        List<SelectOption> availableUsers = new List<SelectOption>();
        System.debug('availableUsersMap>>>>'+availableUsersMap.keySet());
        for (Id userId : availableUsersMap.keySet()) {
                availableUsers.add(new SelectOption(userId, availableUsersMap.get(userId)));
        }
        return availableUsers;
    }
    
    public List<SelectOption> getSelectedUsers() {
        List<SelectOption> selectedUsers = new List<SelectOption>();
        for (String userId : selectedUsersMap.keySet()) {
            selectedUsers.add(new SelectOption(userId, selectedUsersMap.get(userId)));
        }
        return selectedUsers;
    }
    
    
    //For Notification Lead Not Assigned
    public void add2() {
        if (!selectedUserIds2.isEmpty()) {
            for (String userId : selectedUserIds2) {
                selectedUsersMap2.put(userId, availableUsersMap2.get(userId));
                availableUsersMap2.remove(userId);
            }
        }
    }

    public void remove2() {
        if (!removedUserIds2.isEmpty()) {
            for (String userId : removedUserIds2) {
                availableUsersMap2.put(userId, selectedUsersMap2.get(userId));
                selectedUsersMap2.remove(userId);
            }
        }
    }
    
    public List<SelectOption> getAvailableUsers2() {
        List<SelectOption> availableUsers2 = new List<SelectOption>();
        for (Id userId : availableUsersMap2.keySet()) {
            availableUsers2.add(new SelectOption(userId, availableUsersMap2.get(userId)));
        }
        return availableUsers2;
    }
    
    public List<SelectOption> getSelectedUsers2() {
        List<SelectOption> selectedUsers2 = new List<SelectOption>();
        for (String userId : selectedUsersMap2.keySet()) {
            selectedUsers2.add(new SelectOption(userId, selectedUsersMap2.get(userId)));
        }
        return selectedUsers2;
    }
    
    //For Notification Lead No Update
    public void add3() {    
        if (!selectedUserIds3.isEmpty()) {
            for (String userId : selectedUserIds3) {
                selectedUsersMap3.put(userId, availableUsersMap3.get(userId));
                availableUsersMap3.remove(userId);
            }
        }
    }
    
    public void remove3() {
        if (!removedUserIds3.isEmpty()) {
            for (String userId : removedUserIds3) {
                availableUsersMap3.put(userId, selectedUsersMap3.get(userId));
                selectedUsersMap3.remove(userId);
            }
        }
    }
    
    public List<SelectOption> getAvailableUsers3() {
        List<SelectOption> availableUsers3 = new List<SelectOption>();
        for (Id userId : availableUsersMap3.keySet()) {
            availableUsers3.add(new SelectOption(userId, availableUsersMap3.get(userId)));
        }
        return availableUsers3;
    }
    
    public List<SelectOption> getSelectedUsers3() {
        List<SelectOption> selectedUsers3 = new List<SelectOption>();
        for (String userId : selectedUsersMap3.keySet()) {
            selectedUsers3.add(new SelectOption(userId, selectedUsersMap3.get(userId)));
        }
        return selectedUsers3;
    }
    
    //updating fields in user object
    public void updateit()
    {
        String NotificationLeadDealerAssignment = String.join(selectedUsersMap.values(), ';');
        String NotificationLeadNotAssigned= String.join(selectedUsersMap2.values(), ';');
        String NotificationLeadNoUpdate = String.join(selectedUsersMap3.values(), ';');
        usertoupdate.Notification_Lead_Dealer_Assignment__c = NotificationLeadDealerAssignment;          
        usertoupdate.Notification_Lead_Not_Assigned__c = NotificationLeadNotAssigned;          
        usertoupdate.Notification_Lead_No_Update__c  = NotificationLeadNoUpdate ;          
        update usertoupdate;        
    }
}