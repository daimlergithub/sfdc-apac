/*
  Name                 : UtilCaseShare
  Object               : Case
  Requirement          : moved excessive methods from CaseHelper class  to UtilCaseShare
  Refer classes        : CaseHelper.cls
  Author               : Mohana raja reddy Alla
  Create Date          :10/8/2015
  Modify History       : 
 
 */
public with sharing class UtilCaseShare 
{
    
     public static CaseTeamRole DealerRole = [select Id from CaseTeamRole where Name = 'Dealer' limit 1];
    
// share Case For US-CC-023    
    public static void shareCase(Map<Id, Id> casesToShare, Map<String, String> vehicleToOwner) {
       // List<CaseShare> shareCases = new List<CaseShare>();
        Map<Id, List<Id>> accountIdUserIds = new Map<Id, List<Id>>();
        Map<Id, Set<Id>> caseIdExistUserIds = new Map<Id, Set<Id>>();
        List<CaseTeamMember> caseTeamMembers = new List<CaseTeamMember>();
        list<user> userInfo=[select id, AccountId from User 
                        where isActive=true 
                        and AccountId in :casesToShare.values() 
                        and (Profile.Name =: UtilConstant.DEALER_DELEGATE_ADMIN
                        or Contact.Permission_Set_Settings__c includes ('Complaint_Management'))];
        
        list<caseTeamMember> csTeamMember=[select ParentId, MemberId from caseTeamMember where ParentId in :casesToShare.keySet()];
        
        
        for(User cus:userInfo ) {
            if(!accountIdUserIds.containsKey(cus.AccountId)) {
                accountIdUserIds.put(cus.AccountId, new List<Id>());
            }
            accountIdUserIds.get(cus.AccountId).add(cus.Id);
        }
        
        for(caseTeamMember cs : csTeamMember) {
            if(!caseIdExistUserIds.containsKey(cs.ParentId)) {
                caseIdExistUserIds.put(cs.ParentId, new Set<Id>());
            }
            caseIdExistUserIds.get(cs.ParentId).add(cs.MemberId);
        }
        
        for(Id caseId : casesToShare.keySet()) {
            if(accountIdUserIds.containsKey(casesToShare.get(caseId))) {
                for(Id userId : accountIdUserIds.get(casesToShare.get(caseId))) {
                    if((caseIdExistUserIds.containsKey(caseId) && !caseIdExistUserIds.get(caseId).contains(userId)) || !caseIdExistUserIds.containsKey(caseId)) {
                        caseTeamMembers.add(new caseTeamMember(ParentId = caseId, MemberId = userId, TeamRoleId = DealerRole.Id));
                    }
                }
            }
        }
        
        if(caseTeamMembers!=null && !caseTeamMembers.IsEmpty()) {
            UtilSobject.insertSobjects(caseTeamMembers);
        }
        
        shareCaseVehicleToDealer(vehicleToOwner);
    }
	
	 /**
     * Shares the vehicle in case to a dealer
     *  user after the case owner is changed to the dealer user.
     * By Justin Yu
     */
    private static void shareCaseVehicleToDealer(Map<String, String> vehicleToOwner){
        
        
        
        if(!vehicleToOwner.isEmpty()){
            Set<String> existentSharings = getExistentSharings(vehicleToOwner);
            List<Vehicle__Share> vehicleSharings = new List<Vehicle__Share>();
            
            for(String vehicleId : vehicleToOwner.keySet()){
                String dealerId = vehicleToOwner.get(vehicleId);
                if(!existentSharings.contains(getSharingIndex(vehicleId, dealerId))){
                    vehicleSharings.add(new Vehicle__Share(ParentId = vehicleId, UserOrGroupId = dealerId, AccessLevel = 'Read'));
                }
            }
            if(vehicleSharings!=null && !vehicleSharings.IsEmpty())
            UtilSobject.insertSobjects(vehicleSharings);
        }
    }
	
	/**
     * Maps a sharing to a record.
     * By Justin Yu
     */
    public static String getSharingIndex(String parentId, String userOrGroupId){
        return parentId + ';' + userOrGroupId;
    }
	
	
    /**
     * Gets the existent vehicle sharings.
     * By Justin Yu
     */
    private static Set<String> getExistentSharings(Map<String, String> vehicleToOwner){
        Set<String> result = new Set<String>();
        list<Vehicle__Share> vehShare=new list<Vehicle__Share>([select ParentId, UserOrGroupId from Vehicle__Share 
                                    where ParentId in :vehicleToOwner.keySet() 
                                    and UserOrGroupId in : vehicleToOwner.values()]);
        
        for(Vehicle__Share vShare :vehShare ){
         result.add(UtilCaseShare.getSharingIndex(vShare.ParentId, vShare.UserOrGroupId));
        }
        return result;
    }
    
    // ADD START AS-Complaint_002 CHAOS 2014/2/21
    public static void shareCaseWithoutshareVehicle(Map<id,Set<Id>> casesToShare) {
      //  List<CaseShare> shareCases = new List<CaseShare>();
        List<Id> allAccountIds = new List<Id>();
        Map<Id, List<Id>> accountIdUserIds = new Map<Id, List<Id>>();
        Map<Id, Set<Id>> caseIdExistUserIds = new Map<Id, Set<Id>>();
        List<CaseTeamMember> caseTeamMembers = new List<CaseTeamMember>();
        list<User> userInfo;
        list<caseTeamMember> csTeamMember=[select ParentId, MemberId from caseTeamMember where ParentId in :casesToShare.keySet()];
        
        for(Id caseid : casesToShare.keySet()){
            allAccountIds.addAll(casesToShare.get(caseid));
        }
        
        userInfo= new list<User>([select id, AccountId from User 
                        where isActive=true 
                        and AccountId in :allAccountIds 
                        and (Profile.Name =: UtilConstant.DEALER_DELEGATE_ADMIN 
                        or Contact.Permission_Set_Settings__c includes ('Complaint_Management'))]);
        
        for(User cus: userInfo) {
            if(!accountIdUserIds.containsKey(cus.AccountId)) {
                accountIdUserIds.put(cus.AccountId, new List<Id>());
            }
            accountIdUserIds.get(cus.AccountId).add(cus.Id);
        }
        
        for(caseTeamMember cs :csTeamMember) {
            if(!caseIdExistUserIds.containsKey(cs.ParentId)) {
                caseIdExistUserIds.put(cs.ParentId, new Set<Id>());
            }
            caseIdExistUserIds.get(cs.ParentId).add(cs.MemberId);
        }
        
        for(Id caseId : casesToShare.keySet()) {
            for (Id accountId : allAccountIds) {
                if(accountIdUserIds.containsKey(accountId)) {
                    for(Id userId : accountIdUserIds.get(accountId)) {
                        if((caseIdExistUserIds.containsKey(caseId) && !caseIdExistUserIds.get(caseId).contains(userId)) || !caseIdExistUserIds.containsKey(caseId)) {
                            caseTeamMembers.add(new caseTeamMember(ParentId = caseId, MemberId = userId, TeamRoleId = DealerRole.Id));
                        }
                    }
                }
            }
        }
        
        if(caseTeamMembers!=null && !caseTeamMembers.IsEmpty()) {
            UtilSobject.insertSobjects(caseTeamMembers);
        }
    }
	// ADD END AS-Complaint_002 CHAOS 2014/2/21
    
    // The complaint Case Owner will be 
    // auto changed to the Dealer's Complaint Gate keeper
    public static Map<id,User> getGateKeepers(List<Case> ids){
        Map<id,User> caseIdUser = new Map<id,User>(); 
        Set<id> dealerAccounts = new Set<id>();
        Map<id,List<User>> accountAndUser = new Map<id,List<User>>();
        Map<Id, Id> customerGateKeepers = new Map<Id, Id>();
        list<User> userInfo;
        
        for(Case c : ids){
            if(c.Case_Dealer__c != null){
                dealerAccounts.add(c.Case_Dealer__c);
            }
        }
        
        userInfo= new list<User>([select Id,AccountId, Email, ContactId from User 
                    where  isActive = true and ContactId in (select Id from Contact where AccountId in :dealerAccounts and Dealer_Complaint_Gate_Keeper__c = true)]);
        
        for(User u : userInfo ){
            if(!accountAndUser.containsKey(u.AccountId)) {
                accountAndUser.put(u.AccountId, new List<User>());
            }
            accountAndUser.get(u.AccountId).add(u);
        }

        for(Case c : ids){
            if(null != accountAndUser.get(c.Case_Dealer__c)){
                User u = accountAndUser.get(c.Case_Dealer__c)[0];
                if(c.OwnerId != u.id){
                    caseIdUser.put(c.id, u);
                    if(null != c.AccountId){
                        customerGateKeepers.put(c.AccountId, u.Id);
                    }
                }
            }
        }

        if(customerGateKeepers.size() > 0) {
           UtilCaseShare.shareCustomerToGateKeeper(customerGateKeepers);
        }
      CaseHelper.shareCaseToRO(ids);
        
        return caseIdUser;
    }
	 public static void shareCustomerToGateKeeper(Map<Id, Id> customerGateKeepers) {
        List<AccountShare> accShares = new List<AccountShare>();
        Map<Id, Set<Id>> accountIdExistUserIds = new Map<Id, Set<Id>>();
        list<AccountShare> acShare= new list<AccountShare>([select AccountId, UserOrGroupId from AccountShare where id in :customerGateKeepers.keyset()]);

        for(AccountShare accShare :acShare ) {
            if(!accountIdExistUserIds.containsKey(accShare.AccountId)) {
                accountIdExistUserIds.put(accShare.AccountId, new Set<Id>());
            }
            accountIdExistUserIds.get(accShare.AccountId).add(accShare.UserOrGroupId);
        }
        
        for(Id accId : customerGateKeepers.keyset()) {
            If(!accountIdExistUserIds.containsKey(accId) || (accountIdExistUserIds.containsKey(accId) && !accountIdExistUserIds.get(accId).contains(customerGateKeepers.get(accId)))) {
                accShares.add(new AccountShare(AccountId = accId, OpportunityAccessLevel = 'None', CaseAccessLevel = 'None', AccountAccessLevel = 'Read', UserOrGroupId = customerGateKeepers.get(accId)));
            }
        }
        
        if(accShares.size() > 0) {
            try {
                insert accShares;
            }
            catch(Exception ex) {
                System.debug('Exception message is :' + ex.getMessage());
            }
        }
    }
}