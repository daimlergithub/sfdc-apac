/*
Type:       Utility for Vehicle Relationship trigger
Purpose:    1.  Create a apex trigger to share the VR record to "Portal Role and Subordinates" with read only. 
Partner Name should be Account Name + " " + "Partner Executive", e.g. Beijing Mercedes 4S shop Partner Executive 


User Story: ISSUE-0757
Used By:    
---------------------------------------------------------------
History:

1. Sichao Lai Created on 2013-06-18
*/

public with sharing class VehicleRelationshipHelper 
{
  private static final String contact2ContactRT = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();  
    
    public static void shareVR(List<Vehicle_Relationship__c> vRelationshipNew)
    {
        Map<ID, ID> shareid = new Map<ID, ID>();
        Map<ID, ID> vrIdcontactId = new Map<ID, ID>();
        Map<ID, ID> vrIdvehicleId = new Map<ID, ID>();
        
        for(Vehicle_Relationship__c vr : vRelationshipNew)
        {
            if(vr.Owner_Dealer__c != null && vr.RecordTypeId == Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId())
            {
                shareid.put(vr.id, vr.Owner_Dealer__c);
                vrIdcontactId.put(vr.id, vr.Contact__c);
                vrIdvehicleId.put(vr.id, vr.Vehicle_ID__c);
            }
        }
        if(shareid != null && !shareid.IsEmpty() && vrIdcontactId != null && !vrIdcontactId.IsEmpty() && vrIdvehicleId != null && !vrIdvehicleId.IsEmpty())
        {
            List<SObject> vehicleRelationshipShareToInsert = new List<SObject>();
            List<SObject> accountShareToInsert = new List<SObject>();
            List<SObject> vehicleShareToInsert = new List<SObject>();
            Map<ID, String> account = new Map<ID, String>();
            Map<String, ID> userrole = new Map<String, ID>();
            Map<ID, ID> user = new Map<ID, ID>();
            Map<ID, Set<ID>> users = new Map<ID, Set<ID>>();
            
            
            for(ACCOUNT a : [SELECT name, id FROM ACCOUNT WHERE id in : shareid.values()]){
                String s = a.name + ' ' + 'Partner Executive';
                account.put(a.id, s);
            }
            
            for(UserRole ur : [SELECT id, name FROM UserRole WHERE name in : account.values()]){
                userrole.put(ur.name, ur.id);
            }
            
            for(User u : [SELECT id, userroleid FROM User WHERE userroleid in : userrole.values() AND isActive = true]){
                user.put(u.userroleid, u.id);
            }
            
            for(ID a : user.keyset()){
                Set<ID> s = getRoleSubordinateUsers(user.get(a));
                users.put(a, s);
            }    
            
            for(ID share : shareid.keyset()){
                if(shareid.containskey(share)){
                    if(account.containskey(shareid.get(share))){
                        if(userrole.containskey(account.get(shareid.get(share)))){
                            if(users.containskey(userrole.get(account.get(shareid.get(share))))){
                                for(ID fid : users.get(userrole.get(account.get(shareid.get(share))))){
                                    vehicleRelationshipShareToInsert.add(new Vehicle_Relationship__Share(AccessLevel = 'Read', ParentId = share , UserOrGroupId = fid));
                                    if(vrIdcontactId.containsKey(share))
                                    {
                                        accountShareToInsert.add(new AccountShare(AccountAccessLevel = 'Read', AccountId = vrIdcontactId.get(share), OpportunityAccessLevel = 'Read', CaseAccessLevel = 'Read', UserOrGroupId = fid));
                                    }
                                    if(vrIdvehicleId.containsKey(share))
                                    {
                                        vehicleShareToInsert.add(new Vehicle__Share(AccessLevel = 'Read', ParentId = vrIdvehicleId.get(share) , UserOrGroupId = fid));
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            if(vehicleRelationshipShareToInsert != null && !vehicleRelationshipShareToInsert.IsEmpty())
            {
                UtilSobject.insertSobjects(vehicleRelationshipShareToInsert);
            }
            
            if(accountShareToInsert != null && !accountShareToInsert.IsEmpty())
            {
                UtilSobject.insertSobjects(accountShareToInsert);
            }
            
            if(vehicleShareToInsert != null && !vehicleShareToInsert.IsEmpty())
            {
                UtilSobject.insertSobjects(vehicleShareToInsert);
            }
        }
    }
    
    
      
    public static Set<ID> getRoleSubordinateUsers(Id userId) {
        
        // get requested user's role
        Id roleId= [select UserRoleId from User where Id = :userId].UserRoleId;
        Map<Id,Id> roles= new Map<Id,Id>();
        for(UserRole ur : [select Id, parentroleid from UserRole where Name like '%Partner User' or Name like '%Partner Executive' or Name like '%Partner Manager']){
            roles.put(ur.id, ur.parentroleid);
        }
        
        // get all of the roles underneath the user
        Set<Id> allSubRoleIds = getAllSubRoleIds(new Set<ID>{roleId}, roles);
        allSubRoleIds.add(roleId);
        // get all of the ids for the users in those roles
        Map<Id,User> users = new Map<Id, User>([Select Id, Name From User where UserRoleId IN :allSubRoleIds and isActive = true]);
        // return the ids as a set so you can do what you want with them
        return users.keySet();
        
    }
    
    private static Set<ID> getAllSubRoleIds(Set<ID> roleIds, Map<Id,Id> roles) {
        
        Set<ID> currentRoleIds = new Set<ID>();
        
        // get all of the roles underneath the passed roles
        
        for(ID crole: roles.keyset()){
            if(roleIds.contains(roles.get(crole))){
                currentRoleIds.add(crole);
            }
        }
        
        // go fetch some more rolls!
        if(currentRoleIds.size() > 0)
        {
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds,roles));
        }     
        return currentRoleIds;
    }
    //Existing Au Functionality satrts from here
    //Get vehiches Vehicle_Group__c by vehicle id
    public static Map<id,Vehicle__c> getVehichles(set<Id> ids){
        return new Map<id,Vehicle__c>(
            [select id,
             Vehicle_Group__c
             from Vehicle__c 
             where Id in :ids]);
        
    }
    //get the lastest record
    public static Map<String, Map<String,Date>> getExsitedInfos(Set<Id> customerIds , list<String> vehicleGroup){
         Map<String, Map<String,Date>> recordsInfo = new Map<String, Map<String,Date>>();
         Map<String,Date> Info = new  Map<String,Date>();
        for (sObject obj:[select Contact__c, min(Purchase_Date__c) Purchase_Date__c,Vehicle_ID__r.Vehicle_Group__c Vehicle_Group__c from Vehicle_Relationship__c where Vehicle_ID__r.Vehicle_Group__c IN:vehicleGroup and Contact__c in :customerIds group by Contact__c, Vehicle_ID__r.Vehicle_Group__c]){
            if(string.valueOf(obj.get('Vehicle_Group__c'))=='PC'){
            Info.put(String.valueOf(obj.get('Contact__c')),Date.valueOf(obj.get('Purchase_Date__c')));
            recordsInfo.put('PC',Info);
            }
           if(string.valueOf(obj.get('Vehicle_Group__c'))=='CV'){
            Info.put(String.valueOf(obj.get('Contact__c')),Date.valueOf(obj.get('Purchase_Date__c')));
            recordsInfo.put('CV',Info);
            }
           if(string.valueOf(obj.get('Vehicle_Group__c'))=='Van'){
            Info.put(String.valueOf(obj.get('Contact__c')),Date.valueOf(obj.get('Purchase_Date__c')));
            recordsInfo.put('Van',Info);
            }
        }
        
        return  recordsInfo;
    }
    private static Map<String, List<String>> colsMap = new Map<String,List<String>>
    {'PC'=> new List<String>{'PC_Status__c','Buy_Cycle__c','PC_Tenure__c'},
        'CV'=> new List<String>{'CV_Status__c','CV_No_Brand_Purchases__c','CV_Tenure__c'},
            'Van'=> new List<String>{'VAN_Status__c','VAN_No_Brand_Purchases__c','VAN_Tenure__c'}
    };
        //update PC CV VAN tenure
        @TestVisible
        private static Account updatePCCVField(Account userInfo ,String vehicleGroup, Map<String ,Map<String,Date>> preRecords,boolean isCustomer,boolean isinsert,boolean isupdate,boolean isdelete,boolean brandValue,boolean tenureValue){
            
            if(!String.isblank(vehicleGroup) && colsMap != null && colsMap.get(vehicleGroup) != null && preRecords!= null && preRecords.get(vehicleGroup) != null && userInfo.id!=null ){
                Map<String,Date> preRecord = preRecords.get(vehicleGroup);
                List<String> cols = colsMap.get(vehicleGroup);
                 if(isCustomer && !cols.isEmpty())
                    {
                     if(userInfo.get(cols[0]) != 'Complainant')
                      userInfo.put(cols[0], 'customer');
                    }   
                        
                integer numberofP =1; 
                      
                integer MaxnumberofP =99;     
                if(userInfo.get(cols[1])!=null)
                {          
               numberofP =integer.valueOf(userInfo.get(cols[1]));  
                    if(isinsert)
                    {
                        numberofP = integer.valueOf(userInfo.get(cols[1]))+1;  
                    } 
                    if(isupdate && brandValue)
                    {                        
                        numberofP =integer.valueOf(userInfo.get(cols[1]))+1;   
                             
                    }        
                    
                    if(isdelete)
                    { 
                        numberofP = integer.valueOf(userInfo.get(cols[1]))-1;         
                    }
                }
                if(numberofP !=null && (numberofP < -99 || numberofP > 99) && vehicleGroup !='PC')
                {
                userInfo.put(cols[1], MaxnumberofP);
                }
                else
                {
                userInfo.put(cols[1], Decimal.valueOf(numberofP));
                }
              
                integer tenure = 0;
                integer Maxtenure= 99; 
                if(preRecord.get(userInfo.id) != null){ 
                if(isupdate && tenureValue)
                {
                tenure = preRecord.get(userInfo.id).monthsBetween(Date.today())/12;
                }
                else
                {
                tenure = preRecord.get(userInfo.id).monthsBetween(Date.today())/12;
                }
                    
                }
                 
                
                if((tenure > 99 || tenure < -99) && tenure !=null)
                {
                userInfo.put(cols[2] , Decimal.valueOf(Maxtenure));
                }
                else
                {
                userInfo.put(cols[2] , Decimal.valueOf(tenure));
                }
                 return userInfo;    
            }
            
            else if( isdelete && preRecords == null || preRecords.get(vehicleGroup) == null)
            {
            integer Zerono=0; 
            List<String> cols = colsMap.get(vehicleGroup);
            userInfo.put(cols[1], Zerono);
            userInfo.put(cols[2] , Zerono);
            }
            
            return userInfo;
               
        }
    
    //When PA gets a Vehicle-Relationship
    public static void updataWhenCreateCVR(Set<Id> vehicleIds, Set<Id> customerIds, List<Vehicle_Relationship__c> cvrs,boolean isInsert,boolean isupdate,boolean isdelete,boolean brandValue,boolean tenureValue) {
        Map<id,Account> accounts = new Map<id,Account>();
         Map<id,Vehicle__c> vehichles = new  Map<id,Vehicle__c>();        
        Map<String, Map<String,Date>> exsisedRecord = new Map<String, Map<String,Date>>();
        list<string> vehicleGroupString = new list<string>{'PC','CV','Van'};
        //get pc first date records
       // Map<String,Date>  preRecordsPc = getExsitedInfos(customerIds,vehicleGroupString);
        //get cv first date records 
       // Map<String,Date>  preRecordsCv = getExsitedInfos(customerIds,'CV');
        //get cv first date records 
       // Map<String,Date>  preRecordsVAN = getExsitedInfos(customerIds,'Van');
      exsisedRecord = getExsitedInfos(customerIds,vehicleGroupString);
        //exsisedRecord.put('PC', preRecordsPc);
        //exsisedRecord.put('CV', preRecordsCv);
        //exsisedRecord.put('Van', preRecordsVAN);
        
        Map<id,Account> accs = AccountHelper.getCustomerInfos(customerIds);
        list<Address__c> lstAddress=[select Customer__c from Address__c where Customer__c In:customerIds];
        set<id> setAccId= new set<Id>();
        Account acc = new Account();
        if(lstAddress!=null && !lstAddress.isEmpty())
        {
            for(Address__c objAdd:lstAddress)
                setAccId.add(objAdd.Customer__c);
        }
        //if(getVehichles(vehicleIds) != null)
        vehichles = getVehichles(vehicleIds);
        
        if(cvrs != null && !cvrs.isEmpty())
        {
            for(Vehicle_Relationship__c curCvr : cvrs)
            { 
                if(curCvr != null && curCvr.Contact__c != null)
                {           
                    if(accounts != null && !accounts.isEmpty() && accounts.containsKey(curCvr.Contact__c))
                    {
                        acc = accounts.get(curCvr.Contact__c);
                    }
                    else
                    {
                        acc = accs.get(curCvr.Contact__c);
                    }
                }
                if(curCvr != null && curCvr.Vehicle_ID__c != null && vehichles != null && acc!=null && acc.Id!=null) 
                {
                    if(vehichles.get(curCvr.Vehicle_ID__c) != null && vehichles.get(curCvr.Vehicle_ID__c).Vehicle_Group__c != null)
                    acc = updatePCCVField(acc, vehichles.get(curCvr.Vehicle_ID__c).Vehicle_Group__c, exsisedRecord,(setAccId!= null && !setAccId.isEmpty() && setAccId.contains(acc.id)),isinsert,isupdate,isdelete,brandValue,tenureValue);
                    ////////    SFDCAU-735; update status to 'Complainant' based on Vehichle group if Car relation is 'Complainant' /////////
                    if(curCvr.Car_Relation__c == 'Complainant' && acc.System_Data_Source__c == 'ICC')
                    {
                        if((acc.Buy_Cycle__c == 1) && (acc.CV_No_Brand_Purchases__c == 0 || acc.CV_No_Brand_Purchases__c == null) && (acc.VAN_No_Brand_Purchases__c == 0 || acc.VAN_No_Brand_Purchases__c == null) && vehichles.get(curCvr.Vehicle_ID__c).Vehicle_Group__c == 'PC')
                        {
                            acc.PC_Status__c = 'Complainant';
                        }
                        if((acc.Buy_Cycle__c == 0 || acc.Buy_Cycle__c == null) && (acc.CV_No_Brand_Purchases__c == 1) && (acc.VAN_No_Brand_Purchases__c == 0 || acc.VAN_No_Brand_Purchases__c == null) && vehichles.get(curCvr.Vehicle_ID__c).Vehicle_Group__c == 'CV')
                        {
                            acc.CV_Status__c = 'Complainant';
                        }
                        if((acc.Buy_Cycle__c == 0 || acc.Buy_Cycle__c == null) && (acc.CV_No_Brand_Purchases__c == 0 || acc.CV_No_Brand_Purchases__c == null) && (acc.VAN_No_Brand_Purchases__c == 1) && vehichles.get(curCvr.Vehicle_ID__c).Vehicle_Group__c == 'VAN')
                        {
                            acc.VAN_Status__c = 'Complainant';
                        }
                    }
                    
                    if(acc != null && acc.id != null){
                    accounts.put(acc.id,acc);
                    }
                }
            }
        }
        if(accounts != null && !accounts.containsKey(null) && accounts.values() != null)
        {
            //UtilDB.updateSobjects(accounts.values());
            String JSONString = JSON.serialize(accounts.values());
            updateaccounts(JSONString);
        }
    }    
    @future
    public static void updateaccounts(String str)
    {
        List<Account> webList=(List<Account>)JSON.deserialize(str,List<Account>.class);
        UtilDB.updateSobjects(webList); 
    }
    
    public static void auAfter_Insert_Update_Events(list<Vehicle_Relationship__c> listVRNew,map<id,Vehicle_Relationship__c> oldMap,boolean isInsert,boolean isupdate,boolean isdelete)
    {
        system.debug('Enter after trigger');
        Set<Id> vehicleIds = new Set<Id>();
        Set<Id> customerIds = new Set<Id>();
        List<Vehicle_Relationship__c> insertCvrs = new List<Vehicle_Relationship__c>();
        boolean isdeleteValue=false;
        boolean tenureValue=false;
        boolean brandValue=false;
        for(Vehicle_Relationship__c cvr : listVRNew) {
            if(isInsert || isdelete || isupdate){
                if(isdelete)
                    isdeleteValue=true;
                
                // Make sure the vehicle id not null
                if (null == cvr.Vehicle_ID__c && (isInsert || isupdate)){
                    cvr.addError('Please select the vehicle Id !');
                    return;
                }
                
                 if (cvr.Contact__c != null && !customerIds.contains(cvr.Contact__c)){
                    customerIds.add(cvr.Contact__c);
                }
                
               if (cvr.Vehicle_ID__c != null && !vehicleIds.contains(cvr.Vehicle_ID__c)){
                    vehicleIds.add(cvr.Vehicle_ID__c);
                }
                if(((isInsert || isdelete) && cvr.Car_Relation__c =='Owner'))
                {                
                    insertCvrs.add(cvr); 
                }
                if(((isupdate && oldMap.get(cvr.Id).Car_Relation__c=='Owner' && cvr.Car_Relation__c !='Owner')))
                {
                    insertCvrs.add(cvr);
                    if(isupdate)
                        isdeleteValue=true;
                } 
                if(((isupdate && oldMap.get(cvr.Id).Car_Relation__c!='Owner' && cvr.Car_Relation__c =='Owner')))
                {
                    insertCvrs.add(cvr);
                    if(isupdate)
                        isdeleteValue=false;
                        brandValue=true;
                }
                if(((isupdate && oldMap.get(cvr.Id).Purchase_Date__c != cvr.Purchase_Date__c)))
                {
                       insertCvrs.add(cvr);
                        if(isupdate)
                        isdeleteValue=false;
                        tenureValue=true; 
                }
                
                
                if(((isupdate && oldMap.get(cvr.Id).Contact__c != cvr.Contact__c)))
                { 
                    insertCvrs.add(cvr);
                    if(isupdate)
                    isdeleteValue=false; 
                }
            
            }
        } 
        
        //US_AU-CD-001 & 002 & 001.1 & 002.1
        if(customerIds!=null && !customerIds.isEmpty() && vehicleIds!=null && !vehicleIds.isEmpty() && insertCvrs!=null && !insertCvrs.isEmpty() ){
            updataWhenCreateCVR(vehicleIds, customerIds, insertCvrs,isInsert,isupdate,isdeleteValue,brandValue,tenureValue);
        }
        // Commented by Rakesh for Too Many SOQl error issue.   
        /* if (isInsert || isdelete ) {
                   //share owner and finance dealer
                 shareOwnerandFinanceDealers(listVRNew);
                }*/
        
    }
    public static void auBefore_Insert_Update_Events(list<Vehicle_Relationship__c> listVRNew)
    {
        for(Vehicle_Relationship__c objVR:listVRNew)
        {
            objVR.VIN_Search__c=objVR.UsVIN__c;
        }
    }     
 
    
    /* To share Account and related object to Owner Dealer and Finance Dealer
    */

    public static void shareOwnerandFinanceDealers(List<Vehicle_Relationship__c> vrList)
    {
        List<AccountShare> accshareList = new List<AccountShare>();
        set<id> vrId = new set<id>();
        set<id> conid = new set<id>();
        set<id> userGroupId = new set<id>();
        set<id> vrUserGroupId = new set<id>();
        map<id,id> finacLinkMap = new map<id,id>();
        map<id,id> accountmap = new map<id,id>();          
        map<id,id> vehMap = new map<id,id>();
        map<id,set<id>> chkduplicateShareMap = new map<id,set<id>>();
        List<Group> ownergroupList = new List<Group>();
        List<Group> financegroupList = new List<Group>();
        map<string,id> ownerGroupMap = new map<string,id>();
        map<string,id> financeGroupMap = new map<string,id>();
        map<id,map<id,id>> accvechmMap = new map<id,map<id,id>>();
        set<string> ownerGroup = new set<string>();
        set<string> financeGroup = new set<string>();
        List<Vehicle_Relationship__c> shareVrList = new List<Vehicle_Relationship__c>();        
        List<Account_Link__c> acclinkList = new List<Account_Link__c>();
        List<Accountshare> accountshareList = new List<Accountshare>();
        List<Account_Link__share> accountlinkshareList = new List<Account_Link__share>();
        List<Accountshare> duplisharedList = new List<AccountShare>();
        List<Vehicle__Share> vechshareList = new List<Vehicle__Share>();
        List<Vehicle_Relationship__Share> vRshareList = new List<Vehicle_Relationship__Share>();
        List<Vehicle_Relationship__Share> duplivRshareList = new List<Vehicle_Relationship__Share>();
        for (Vehicle_Relationship__c vr:vrList )
        {
            if(vr.Owner_Dealer__c != null && vr.Contact__c != null)
            {
                vrId.add(vr.Id);
                conid.add(vr.Contact__c);
            }
            if(vr.Finance_Dealer__c != null && vr.Contact__c != null)
            {
                vrId.add(vr.Id);
                conid.add(vr.Contact__c);
            }           
        }
        system.debug('conid>>>' + conid);
        if(!conid.isEmpty() && conid !=null)
        {
            duplisharedList =[select AccountId, UserOrGroupId, AccountAccessLevel from AccountShare where AccountId =:conid];
            acclinkList =[select id,recordtypeId,torole__c,fromrole__c from Account_Link__c where torole__c=:conid and recordtypeId =:contact2ContactRT];
        }
        if(!duplisharedList.isEmpty() && duplisharedList != null)
        {
            for(AccountShare accsh : duplisharedList)
            {
                userGroupId.add(accsh.UserOrGroupId);
                chkduplicateShareMap.put(accsh.AccountId , userGroupId);                    
            }
        }
        if(!vrId.isEmpty() && vrId != null)
        {
            shareVrList = [select id , contact__c ,Owner_Dealer__c, Owner_Dealer__r.Name ,Finance_Dealer__c, 
                           Finance_Dealer__r.Name,vehicle_ID__c from Vehicle_Relationship__c where ID =:vrId];
            duplivRshareList = [select ParentId, UserOrGroupId, AccessLevel from Vehicle_Relationship__Share where ParentId =:vrId];
        }
        if(!duplivRshareList.isEmpty() && duplivRshareList != null)
        {
            for(Vehicle_Relationship__Share duplishre : duplivRshareList)
            {
                vrUserGroupId.add(duplishre.UserOrGroupId);
                chkduplicateShareMap.put(duplishre.ParentId, vrUserGroupId);
            }
        }
        if(!shareVrList.isEmpty() && shareVrList != null)
        {
            for(Vehicle_Relationship__c shrVr : shareVrList)
            {
                ownerGroup.add(shrVr.Owner_Dealer__r.name);
                financeGroup.add(shrVr.Finance_Dealer__r.name);
                accountmap.put(shrVr.id , shrVr.Contact__c);
                vehMap.put(shrVr.id , shrVr.Vehicle_ID__c);
                accvechmMap.put(shrVr.Contact__c, vehMap);
            }
        }
        if(!ownerGroup.isEmpty() && ownerGroup!= null)
        {
            ownergroupList = [select id ,DeveloperName ,Name ,Type from Group where Name =:ownerGroup];
        }
        if(!financeGroup.isEmpty() && financeGroup != null)
        {
            financegroupList = [select id ,DeveloperName ,Name ,Type from Group where Name =:financeGroup];
        }
        for(Group gr : ownergroupList)
        {
            ownerGroupMap.put(gr.Name, gr.id);
        }
        for(Group grp : financegroupList)
        {
            financeGroupMap.put(grp.Name , grp.id);
        }
        system.debug('chkduplicateShareMap>>' + chkduplicateShareMap);
        system.debug('ownerGroupMap>>>' + ownerGroupMap);
        if(!shareVrList.isEmpty() && shareVrList != null)
        {
            for(Vehicle_Relationship__c sVr : shareVrList)
            {
                if(sVr.Owner_Dealer__c != null && ownerGroupMap.get(sVr.Owner_Dealer__r.Name) != null)
                {
                    system.debug('chkduplicateShareMap>><<><><' + chkduplicateShareMap.get(sVr.Contact__c));
                    system.debug('ownerGroupMap>>' + ownerGroupMap.get(sVr.Owner_Dealer__r.Name));
                    if(!chkduplicateShareMap.get(sVr.Contact__c).Contains(ownerGroupMap.get(sVr.Owner_Dealer__r.Name)))
                    {
                        AccountShare accsha = new AccountShare();
                        accsha.AccountId = sVr.Contact__c;
                        accSha.UserOrGroupId = ownerGroupMap.get(sVr.Owner_Dealer__r.Name);
                        accSha.AccountAccessLevel = 'Edit';
                        accSha.OpportunityAccessLevel = 'None';
                        accSha.CaseAccessLevel = 'None';
                        accountshareList.add(accsha);
                        
                    }
                    if(!acclinkList.isEmpty() && acclinkList != null)
                    {
                        for(Account_Link__c sharelink : acclinkList)
                        {
                            if(sharelink.toRole__c != null && sharelink.RecordTypeId == contact2ContactRT 
                               && sVr.Contact__c == sharelink.toRole__c)
                            {
                                Account_Link__Share con2conlink = new Account_Link__Share();
                                con2conlink.ParentId = sharelink.Id;
                                con2conlink.AccessLevel = 'Edit';
                                con2conlink.UserOrGroupId = ownerGroupMap.get(sVr.Owner_Dealer__r.Name);
                                accountlinkshareList.add(con2conlink);
                            }
                        }
                    }
                        if(!shareVrList.isEmpty() && shareVrList !=null 
                           && (!chkduplicateShareMap.get(sVr.Id).contains(ownerGroupMap.get(sVr.Owner_Dealer__r.Name))))
                        {
                            Vehicle_Relationship__Share vrShare = new Vehicle_Relationship__Share();
                            vrShare.ParentId = sVr.Id;
                            vrShare.UserOrGroupId = ownerGroupMap.get(sVr.Owner_Dealer__r.Name);
                            vrShare.AccessLevel = 'Edit';
                            vRshareList.add(vrShare);
                            if(!accvechmMap.isEmpty() && accvechmMap != null && accvechmMap.get(sVr.Contact__c).get(sVr.Id) != null)
                            {
                                Vehicle__Share shrVehicle = new Vehicle__Share();
                                shrVehicle.ParentId = accvechmMap.get(sVr.Contact__c).get(sVr.Id);
                                shrVehicle.UserOrGroupId = ownerGroupMap.get(sVr.Owner_Dealer__r.Name);
                                shrVehicle.AccessLevel = 'Edit';
                                vechshareList.add(shrVehicle);
                            }
                        }
                    }                
                if(sVr.Finance_Dealer__c != null && (sVr.Owner_Dealer__c != sVr.Finance_Dealer__c) && financeGroupMap.get(sVr.Finance_Dealer__r.Name) != null)
                {
                    if(!chkduplicateShareMap.get(sVr.Contact__c).Contains(financeGroupMap.get(sVr.Finance_Dealer__r.Name)))
                    {
                        AccountShare accfinsha = new AccountShare();
                        accfinsha.AccountId = accountmap.get(sVr.id);
                        accfinsha.UserOrGroupId = financeGroupMap.get(sVr.Finance_Dealer__r.Name);
                        accfinsha.AccountAccessLevel = 'Edit';
                        accfinsha.OpportunityAccessLevel = 'None';
                        accfinsha.CaseAccessLevel = 'Read';
                        accountshareList.add(accfinsha);
                    }
                    if(!acclinkList.isEmpty() && acclinkList != null)
                    {
                        for(Account_Link__c sharefinlink : acclinkList)
                        {
                            if(sharefinlink.toRole__c != null && sharefinlink.RecordTypeId == contact2ContactRT 
                               && sVr.Contact__c == sharefinlink.toRole__c)
                            {
                                Account_Link__Share con2confinlink = new Account_Link__Share();
                                con2confinlink.ParentId = sharefinlink.Id;
                                con2confinlink.AccessLevel = 'Edit';
                                con2confinlink.UserOrGroupId = financeGroupMap.get(sVr.Finance_Dealer__r.Name);
                                accountlinkshareList.add(con2confinlink);
                            }
                        }
                    }
                        
                    if(!shareVrList.isEmpty() && shareVrList != null
                      && (!chkduplicateShareMap.get(sVr.Id).contains(financeGroupMap.get(sVr.Finance_Dealer__r.Name))))
                    {
                        Vehicle_Relationship__Share vrfinShare = new Vehicle_Relationship__Share();
                        vrfinShare.ParentId = sVr.Id;
                        vrfinShare.UserOrGroupId = financeGroupMap.get(sVr.Finance_Dealer__r.Name);
                        vrfinShare.AccessLevel = 'Edit';
                        vRshareList.add(vrfinShare);
                        if(!accvechmMap.isEmpty() && accvechmMap != null && accvechmMap.get(sVr.Contact__c).get(sVr.Id) != null)
                        {
                            Vehicle__Share shrfinVehicle = new Vehicle__Share();
                            shrfinVehicle.ParentId = accvechmMap.get(sVr.Contact__c).get(sVr.Id);
                            shrfinVehicle.UserOrGroupId = financeGroupMap.get(sVr.Finance_Dealer__r.Name);
                            shrfinVehicle.AccessLevel = 'Edit';
                            vechshareList.add(shrfinVehicle);
                        }
                    }                    
                }
            }
        }
        system.debug('ownershareList>>>>>' + vechshareList);
        system.debug('finshareList>>>>>' + vRshareList);
        system.debug('accountshareList>>>>>' + accountshareList);
        if(!accountshareList.isEmpty() && accountshareList != null)
        {
            insert accountshareList;
        }
        if(!accountlinkshareList.isEmpty() && accountlinkshareList != null)
        {
            insert accountlinkshareList;
        }
        if(!vechshareList.isEmpty() && vechshareList != null)
        {
            insert vechshareList;
        }
        if(!vRshareList.isEmpty() && vRshareList !=null)
        {
            insert vRshareList;
        }
    }
          
    //Existing Au functionality ends here    
}