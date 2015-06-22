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

public with sharing class VehicleRelationshipHelper {

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
    public static Map<String,Date> getExsitedInfos(Set<Id> customerIds , String vehicleGroup){
        Map<String,Date>  recordsInfo = new Map <String,Date>();
        for (sObject obj:[select Contact__c, min(Purchase_Date__c) Purchase_Date__c from Vehicle_Relationship__c where Vehicle_ID__r.Vehicle_Group__c = :vehicleGroup and Contact__c in :customerIds group by Contact__c]){
            recordsInfo.put(String.valueOf(obj.get('Contact__c')),Date.valueOf(obj.get('Purchase_Date__c')));
        }
        
        return  recordsInfo;
    }
    private static Map<String, List<String>> colsMap = new Map<String,List<String>>
        {'PC'=> new List<String>{'PC_Status__c','Buy_Cycle__c','PC_Tenure__c'},
         'CV'=> new List<String>{'CV_Status__c','CV_No_Brand_Purchases__c','CV_Tenure__c'},
         'VAN'=> new List<String>{'VAN_Status__c','VAN_No_Brand_Purchases__c','VAN_Tenure__c'}
        };
          //update PC CV VAN tenure
     private static Account updatePCCVField(Account userInfo ,String vehicleGroup, Map<String ,Map<String,Date>> preRecords){
         system.debug('vehicleGroup======================='+vehicleGroup);
         system.debug('preRecords======================='+preRecords);
        if(!String.isblank(vehicleGroup)){
            Map<String,Date> preRecord = preRecords.get(vehicleGroup);
            List<String> cols = colsMap.get(vehicleGroup);
            
            userInfo.put(cols[0], 'customer');
            integer numberofP = 1;
            if(userInfo.get(cols[1])!=null){
                numberofP = integer.valueOf(userInfo.get(cols[1]))+1;
            }
            userInfo.put(cols[1], Decimal.valueOf(numberofP));
            integer tenure = 0;
            if(preRecord.get(userInfo.id) != null){
                tenure = preRecord.get(userInfo.id).monthsBetween(Date.today())/12;
            }
            
            userInfo.put(cols[2] , Decimal.valueOf(tenure));
        }
        return userInfo;        
    }
    
    //When PA gets a Vehicle-Relationship
    public static void updataWhenCreateCVR(Set<Id> vehicleIds, Set<Id> customerIds, List<Vehicle_Relationship__c> cvrs) {
    	system.debug('cvrs>>>'+cvrs);
        Map<id,Account> accounts = new Map<id,Account>();
        Map<String, Map<String,Date>> exsisedRecord = new Map<String, Map<String,Date>>();
        //get pc first date records
        Map<String,Date>  preRecordsPc = getExsitedInfos(customerIds,'PC');
        //get cv first date records 
        Map<String,Date>  preRecordsCv = getExsitedInfos(customerIds,'CV');
        //get cv first date records 
        Map<String,Date>  preRecordsVAN = getExsitedInfos(customerIds,'VAN');
        system.debug(customerIds);
        system.debug(preRecordsPc);    
        exsisedRecord.put('PC', preRecordsPc);
        exsisedRecord.put('CV', preRecordsCv);
        exsisedRecord.put('VAN', preRecordsVAN);
        
        Map<id,Account> accs = AccountHelper.getCustomerInfos(customerIds);
        Map<id,Vehicle__c> vehichles = getVehichles(vehicleIds);
        for(Vehicle_Relationship__c curCvr : cvrs){
            Account acc = new Account();
            if(accounts.containsKey(curCvr.Contact__c)){
                acc = accounts.get(curCvr.Contact__c);
            }else{
                acc = accs.get(curCvr.Contact__c);
            }
            acc = updatePCCVField(acc, vehichles.get(curCvr.Vehicle_ID__c).Vehicle_Group__c, exsisedRecord);
            accounts.put(acc.id,acc);
        }
          UtilDB.updateSobjects(accounts.values());
    }     
    
    public static void auAfter_Insert_Update_Events(list<Vehicle_Relationship__c> listVRNew,boolean isInsert)
    {
    	Set<Id> vehicleIds = new Set<Id>();
	    Set<Id> customerIds = new Set<Id>();
	    List<Vehicle_Relationship__c> insertCvrs = new List<Vehicle_Relationship__c>();
	    
	    for(Vehicle_Relationship__c cvr : listVRNew) {
	        if(isInsert){
                
	            // Make sure the vehicle id not null
	            if (null == cvr.Vehicle_ID__c){
	                cvr.addError('Please select the vehicle Id !');
	                return;
	            }
	            
	            if (!customerIds.contains(cvr.Contact__c)){
	                customerIds.add(cvr.Contact__c);
	            }
	                        
	            if (!vehicleIds.contains(cvr.Vehicle_ID__c)){
	                vehicleIds.add(cvr.Vehicle_ID__c);
	            }
	            
	            insertCvrs.add(cvr);
	        }
	    }
	    system.debug('>>>customerIds'+customerIds);
	    system.debug('>>>vehicleIds'+vehicleIds);
	    //US_AU-CD-001 & 002 & 001.1 & 002.1
	    if(customerIds!=null && !customerIds.isEmpty() && vehicleIds!=null && !vehicleIds.isEmpty()){
	        updataWhenCreateCVR(vehicleIds, customerIds, insertCvrs);
	    }
    }
    //Existing Au functionality ends here    
}