/**
 * DataSharing 
 *   1.Run batch class to extend apex sharing in release 1.0 to share person account 
 *   to active lead/complaint gate keeper of the active dealers with the same CRM Code 
 *   as the assigned dealer at lead/complaint assignment. 
 *   (dealer lead/complaint gate keeper is based on the flag on dealer contact)
 *   2. Run batch class to extend apex sharing in release 1.0 to share person account 
 *   to active users of active dealers with the same CRM Code as the owner dealer of 
 *   retail vehicle relationship.
 */

public class AccountSharingDataHandler {

    protected CMap parentIds = new CMap();
    protected CMap userOrGroupIds = new CMap();
        
    public AccountSharingDataHandler(String processFlg) {        
        this.processFlg = processFlg;
     }

    //person account record type
    private Id personAccountRecordType = UtilRecordType.getRecordTypeIdByName(UtilRecordType.Account_Object,UtilRecordType.person_Account);
    private String processFlg = '';

    
    public void shareAccount(CMap parentIds, CMap userOrGroupIds){    
        List<sObject> shareRecs = makeInserRecords(parentIds, userOrGroupIds);
        try {
            List<Database.SaveResult> result = Database.insert(shareRecs,false);  
            system.debug('Success Amount: [' + result.size() +'] |  Is :' + result);            
        } catch (DmlException e) {
            system.debug('DML Exception: ' + e.getDmlMessage(0));
        }       
    }

    /**
     * make a dms & account map
     */
    public CMap filterDealer(List<sObject> scope){
        CMap dmsAndAccount = new CMap();
        for(sObject sa : scope){
            Account a = (Account)sa;
            dmsAndAccount.add(a.Dealer_DMS_CRM_Code__c, a.Id);
        }
        return dmsAndAccount;       
    }
    
    /**
     *  Create a share record of object
     */
    public sObject createShareObject(id parentId, id UserOrGroupId){

        AccountShare shareObj = new AccountShare();
        shareObj.put('AccountId', parentId);
        shareObj.put('UserOrGroupId', UserOrGroupId);
        shareObj.put('AccountAccessLevel', 'Read');
        shareObj.put('OpportunityAccessLevel', 'Read');
        //shareObj.put('RowCause', processFlg);        
        return shareObj;
    }

    //using sharing object and to be shared people make sharing record
    public List<sObject> makeInserRecords(CMap pIds, CMap uogIds){
        List<sObject> shareRecs = new List<sObject>();
        if (pIds != null)
        for(String crmCode: pIds.keySet()){
            if (pIds.get(crmCode) != null && uogIds.get(crmCode) != null) {
                for(Id pId : pIds.get(crmCode)){
                    for(Id uogId : uogIds.get(crmCode)){
                        shareRecs.add(createShareObject(pId,uogId));
                    }           
                }
            }
        }
        system.debug('shareRecs:'+shareRecs);
        return shareRecs;
    }

    public void shareAccountByCRMCode(Map<id,Lead__c> newData, Map<id,Lead__c> oldData, boolean isNew){        
        CMap cmsAndDealer = new CMap();
        CMap parent = new CMap();
        CMap users = new CMap();
        CMap userOrGroupIds = new CMap();
        Set<String> cmsCodes = new Set<String>();
        Set<String> dealers = new Set<String>();
        Set<String> personAccounts = new Set<String>();
        
        for(id key: newData.keySet()){
            if(!isNew){
                Lead__c newLead = (Lead__c)newData.get(key);
                if( newData.get(key).Assigned_Dealer__c != oldData.get(key).Assigned_Dealer__c) {
                    dealers.add(newLead.Assigned_Dealer__c);
                    personAccounts.add(newLead.Contact__c);                 
                }
            }else{
                dealers.add(newData.get(key).Assigned_Dealer__c);
                personAccounts.add(newData.get(key).Contact__c);                
            }
        }
        
    
        for(lead__c l:[SELECT id, Contact__c,Contact__r.recordType.Name, Assigned_Dealer__r.Id, Assigned_Dealer__r.Dealer_DMS_CRM_Code__c from Lead__c where Assigned_Dealer__c in :dealers and Contact__c in :personAccounts]) {
            //Query person account need to share
            if(l.Contact__r.recordtype.Name == 'Person Account' || l.Contact__r.recordtype.Name == 'Company'){
                parent.add(l.Assigned_Dealer__r.Dealer_DMS_CRM_Code__c, l.Contact__c);
            }

        }
        
        system.debug('parm0====================' + parent);
        system.debug('parm1====================cmsCodes' + cmsCodes);
        String dealerRecordtype = UtilRecordType.getRecordTypeIdByName(UtilRecordType.Account_Object,UtilRecordType.Dealer);
        //Query DMS CODE and dealer
        for(Account a: [select id , Dealer_DMS_CRM_Code__c from account where Dealer_DMS_CRM_Code__c in :parent.keyset() and Dealer_Active__c = true and RecordTypeId = :dealerRecordtype]){
            cmsAndDealer.add(a.Dealer_DMS_CRM_Code__c, a.id);
        }
        system.debug('parm1====================cmsAndDealer' + cmsAndDealer);        
        //Query Dealer GateKeeper
        for (User u : [select id,  contact.Dealer_Lead_Gate_Keeper__c, AccountId from user 
                      where contact.Dealer_Lead_Gate_Keeper__c = true and accountid in :cmsAndDealer.values2() and isactive = true]) {
            users.add(u.AccountId, u.id);
          }            
        system.debug('parm1====================users' + users);        
        for (String key : cmsAndDealer.KeySet()) {
            for(String id: cmsAndDealer.get(key)) {
                if(users.get(id)!=null && users.get(id).size()>=1 ){
                    userOrGroupIds.addAll(key, users.get(id));
                }
            }   
        }
        system.debug('setp1==================:'+ parent);
        system.debug('setp2==================:'+ userOrGroupIds);
        if(userOrGroupIds.values2().size()<1) return;
          shareAccount(parent, userOrGroupIds);        
     }
    
    /**
     * At complaint assignment, share person account to active comlaint gate keeper of dealer
     * and the active dealers with same crm code
     */
    public void shareAccountByComplaint(Map<id,Case> newData, Map<id,Case> oldData, boolean isNew){
        CMap cmsAndDealer = new CMap();
        CMap parent = new CMap();
        CMap users = new CMap();
        CMap userOrGroupIds = new CMap();
        Set<String> cmsCodes = new Set<String>();
        Set<String> dealers = new Set<String>();
        Set<String> personAccounts = new Set<String>();
        
        for(id key: newData.keySet()){
            if(!isNew){
                Case newLead = (Case)newData.get(key);
                if( newData.get(key).Case_Dealer__c != oldData.get(key).Case_Dealer__c) {
                    dealers.add(newLead.Case_Dealer__c);
                    personAccounts.add(newLead.AccountId);                  
                }
            }else{
                dealers.add(newData.get(key).Case_Dealer__c);
                personAccounts.add(newData.get(key).AccountId);             
            }
        }
        
        if(dealers.size() > 0 || personAccounts.size() > 0) {
            for(Case l:[SELECT id, AccountId, Case_Dealer__r.Id, Case_Dealer__r.Dealer_DMS_CRM_Code__c 
                           from Case 
                           where Case_Dealer__c in :dealers 
                           and AccountId in (select id from Account where id in :personAccounts and recordtype.Name in ('Person Account','Company'))]) {
                //Query person account need to share
                parent.add(l.Case_Dealer__r.Dealer_DMS_CRM_Code__c, l.AccountId);
            }
        }
        system.debug('parm0====================' + parent);
        system.debug('parm1====================cmsCodes' + cmsCodes);
        String dealerRecordtype = UtilRecordType.getRecordTypeIdByName(UtilRecordType.Account_Object,UtilRecordType.Dealer);
        //Query DMS CODE and dealer
        if(parent.keyset().size() > 0) {
            for(Account a: [select id , Dealer_DMS_CRM_Code__c from account where Dealer_DMS_CRM_Code__c in :parent.keyset() and Dealer_Active__c = true and RecordTypeId = :dealerRecordtype]){
                cmsAndDealer.add(a.Dealer_DMS_CRM_Code__c, a.id);
            }
        }
        system.debug('parm1====================cmsAndDealer' + cmsAndDealer);
        
        //Query Dealer GateKeeper
        if(cmsAndDealer.values2().size() > 0) {
            for (User u : [select id,  contact.Dealer_Complaint_Gate_Keeper__c, AccountId from user 
    where contact.Dealer_Complaint_Gate_Keeper__c = true and accountid in :cmsAndDealer.values2() and isactive = true]) {
                users.add(u.AccountId, u.id);
            }
        }
        system.debug('parm1====================users' + users);
        
        for (String key : cmsAndDealer.KeySet()) {
            for(String id: cmsAndDealer.get(key)) {
                if(users.get(id)!=null && users.get(id).size()>=1 ){
                    userOrGroupIds.addAll(key, users.get(id));
                }
            }   
        }
        system.debug('setp1==================:'+ parent);
        system.debug('setp2==================:'+ userOrGroupIds);

        if(userOrGroupIds.values2().size()<1) return;
        shareAccount(parent, userOrGroupIds);
    }

    /**
     * share person account of Account link 
     */
    public void shareAccountByAccountLink(Map<id,Account_Link__c> newData, Map<id,Account_Link__c> oldData, boolean isNew){
        CMap cmsAndDealer = new CMap();
        CMap parent = new CMap();
        CMap users = new CMap();
        CMap userOrGroupIds = new CMap();
        Set<String> cmsCodes = new Set<String>();
        Set<String> personAccounts = new Set<String>();
        Set<String> dealers = new Set<String>();
                
        for(id key: newData.keySet()){
                
            String cmsCode = getCRMcodeFromName(newData.get(key).Name);
            if(String.isBlank(cmsCode)) continue;
            system.debug('shareAccountByAccountLink============'+cmsCode);
            if(!isNew){
                Account_Link__c alc = (Account_Link__c)newData.get(key);
                
                if( newData.get(key).fromRole__c != oldData.get(key).fromRole__c &&  newData.get(key).fromRole__c != null) {
                    parent.add(cmsCode, alc.fromRole__c);
                }
                if( newData.get(key).toRole__c != oldData.get(key).toRole__c &&  newData.get(key).toRole__c != null) {
                    parent.add(cmsCode, alc.toRole__c);                     
                }
            }else{
                if(newData.get(key).fromRole__c != null) {
                    parent.add(cmsCode, newData.get(key).fromRole__c);
                }
                if(newData.get(key).toRole__c != null) {
                    parent.add(cmsCode, newData.get(key).toRole__c);                    
                }
            }
        }
        system.debug(newData);
        
        if(parent.keySet().size()<1) return;

        userOrGroupIds = getSameCodeUser(parent.keySet());
        system.debug('setp1==================:'+ parent);
        system.debug('setp2==================:'+ userOrGroupIds);
        
        if(userOrGroupIds.values2().size()<1) return;
        shareAccount(parent, userOrGroupIds);
    }
    
    /**
     *  get Crm code from Account_link__c 
     */
    private String getCRMcodeFromName(String name){
        if (name == null)
            return null;
       // List<String> parts = name.split('-');
       
       if (name.contains('-')){
            List<String> parts = name.split('-');
 
            if (parts.size() > 2){
                return parts[2].substring(parts[2].length()-2, parts[2].length());
            }
        } 
        
        return null;
        
        //return parts[2].substring(parts[2].length()-2, parts[2].length()); 
    }

    /**
     * share person account of retail vehicle raletionship
     */
    public void shareAccountByRetailVR(Map<id,Vehicle_Relationship__c> newData, Map<id,Vehicle_Relationship__c> oldData, boolean isNew){
        CMap parent = new CMap();
        CMap userOrGroupIds = new CMap();
        Set<String> cmsCodes = new Set<String>();
        Set<String> personAccounts = new Set<String>();
        Set<String> dealers = new Set<String>();
        String retailRvId = UtilRecordType.getRecordTypeIdByName(UtilRecordType.Vehicle_Relationship,UtilRecordType.Vehicle_Relationship_Retail);    
    
        if (!isNew) return;
        
        for(Vehicle_Relationship__c vrc : newData.values()){
            system.debug('vrc.RecordTypeId===============' + vrc.RecordTypeId);
            system.debug('retailRvId===============' + retailRvId);
            
            if(vrc.RecordTypeId == retailRvId){
                system.debug('i am in');
                dealers.add(vrc.Owner_Dealer__c);
                personAccounts.add(vrc.Contact__c);             
            }
        }
        
        system.debug('dealers====================' + dealers);
        system.debug('personAccounts====================personAccounts' + personAccounts);
        for(Vehicle_Relationship__c l:[SELECT id, Contact__c,contact__r.recordtype.Name, Owner_Dealer__r.Id, Owner_Dealer__r.Dealer_DMS_CRM_Code__c from Vehicle_Relationship__c where Owner_Dealer__c in :dealers and Contact__c in :personAccounts]) {
            //Query person account need to share
            if(l.Contact__r.recordtype.Name == 'Person Account' || l.Contact__r.recordtype.Name == 'Company'){
                parent.add(l.Owner_Dealer__r.Dealer_DMS_CRM_Code__c, l.Contact__c);
                
                // Query Dealer_DMS_CRM_Code__c of Dealer
                if(!cmsCodes.contains(l.Owner_Dealer__r.Dealer_DMS_CRM_Code__c)){
                    cmsCodes.add(l.Owner_Dealer__r.Dealer_DMS_CRM_Code__c);
                }
            }
        }
        
        if(parent.values2().size()<1) return;
        
        userOrGroupIds = getSameCodeUser(parent.keySet());
        if(userOrGroupIds.values2().size()<1) return;
        shareAccount(parent, userOrGroupIds);
    }
    
    /**
     * share dealer to same code dealer
     */
    public void shareDealerByCrmCode(Map<id,Account> newData, Map<id,Account> oldData, boolean isNew){       
        CMap parent = new CMap();   
      //  String dealerRecordtype = UtilRecordType.getRecordTypeIdByName('Account', 'Dealer');        
         String dealerRecordtype =UtilRecordType.getRecordTypeIdByName(UtilRecordType.Account_Object,UtilRecordType.Dealer);
        //Delete Old share records
                
        for(Account a : newData.values()){
            if(a.Dealer_DMS_CRM_Code__c != null && a.RecordTypeId == dealerRecordtype){
                if(!isNew ){
                    if( a.Dealer_DMS_CRM_Code__c != oldData.get(a.id).Dealer_DMS_CRM_Code__c ) {
                        parent.add(a.Dealer_DMS_CRM_Code__c, a.id);
                    }
                }else{
                        parent.add(a.Dealer_DMS_CRM_Code__c, a.id);
                }
            }
        }

        if(!isNew){
          //  deleteOldShare(oldData, 'Dealer');
        }
        if(parent.values2().size()<1) return;       
        userOrGroupIds = getSameCodeUser(parent.keySet());
        system.debug('setp1==================:'+ parent);
        system.debug('setp2==================:'+ userOrGroupIds);

        if(userOrGroupIds.values2().size()<1) return;
        shareAccount(parent, userOrGroupIds);
        system.debug('Limit after shareDealerByCrmCode query========'+limits.getQueries() );

    }

    /**
     * share dealer to same code dealer
     */
    /*
    public void share3rdAccount(Map<id,Account> newData){
        Map<id, id> shareobjects = new Map<id,id>();        
        String dealerRecordtype = UtilRecordType.getRecordTypeIdByName(UtilRecordType.Account_Object,UtilRecordType.3rd_Party);     
        
        for(Account a : newData.values()){
            if(a.RecordTypeId == dealerRecordtype){
                shareobjects.put(a.OwnerId, a.id);
            }
        }
        system.debug('3RD ============' + shareobjects);
        if(shareobjects.size()<1) return;
        
        List<String> profileName = new List<String>{'Dealer Community S&M Manager',
                                                    'Dealer Community AS Marketing Manager'};
        CMap parent = new CMap();
       // CMap accountids = new CMap();
        CMap userOrGroupIds = new CMap();
        
        for(user u: [select accountId, id from user where id in :shareObjects.keyset()]){
            //accountids.add( u.accountId, u.id );
            parent.add(u.accountId, shareObjects.get(u.id));
        }
        
        for(User u : [select accountId, id from user where profile.name in :profileName and Accountid in :parent.keySet()]){
            userOrGroupIds.add(u.accountId, u.id);
        }
        
        system.debug('setp1==================:'+ parent);
        system.debug('setp2==================:'+ userOrGroupIds);

        if(userOrGroupIds.values2().size()<1) return;
        shareAccount(parent, userOrGroupIds);
     }
    */ 
    /**
     * get user of some dms code
     */
    private CMap getSameCodeUser(Set<String> cmsCodes){
        
        CMap cmsAndDealer = new CMap();
        CMap users = new CMap();
        CMap userOrGroupIds = new CMap();
        /**
        system.debug('cmsCodes====================cmsAndDealer' + cmsCodes);
        system.debug('cmsCodes====================cmsAndDealer' + [select id , Dealer_DMS_CRM_Code__c from account where Dealer_DMS_CRM_Code__c in :cmsCodes and Dealer_Active__c = true]);
        
        String soql = 'select id , Dealer_DMS_CRM_Code__c from account where Dealer_DMS_CRM_Code__c in :cmsCodes and Dealer_Active__c = true';
        system.debug('cmsCodes====================cmsAndDealer' + database.query(soql));
        */
        if(cmsCodes.size()<1) return userOrGroupIds;
        //Query DMS CODE and dealer
        String dealerRecordtype = UtilRecordType.getRecordTypeIdByName(UtilRecordType.Account_Object,UtilRecordType.Dealer);
        for(Account a: [select id , Dealer_DMS_CRM_Code__c from account where Dealer_DMS_CRM_Code__c in :cmsCodes and Dealer_Active__c = true and RecordTypeId = :dealerRecordtype]){
            cmsAndDealer.add(a.Dealer_DMS_CRM_Code__c, a.id);
        }

        system.debug('parm1====================cmsAndDealer' + cmsAndDealer);
        
        //Query Dealer 
        for (User u : [select id,  AccountId from user where accountid in :cmsAndDealer.values2() and isActive = true]) {
            users.add(u.AccountId, u.id);
        }
        
        for (String key : cmsAndDealer.KeySet()) {
            for(String id: cmsAndDealer.get(key)) {
                if(users.get(id)!=null && users.get(id).size()>=1 ){
                    userOrGroupIds.addAll(key, users.get(id));
                }
            }   
        }       
        return userOrGroupIds;
    }
    
    /**
     *  delete old share account, when update
     */
    private void deleteOldShare(Map<id,Account> oldData, String recordType) {
        
        String recordtypeId = UtilRecordType.getRecordTypeIdByName(UtilRecordType.Account_Object,recordType); 
        
        Set<String> cmsCode = new Set<String>();
        Set<String> AccountIds = new Set<String>();
        for(Account a : oldData.values()){
            if(a.recordTypeid == recordtypeId){
                cmsCode.add(a.Dealer_DMS_CRM_Code__c);
                AccountIds.add(a.id);
            }
        }
        

        CMap users = getSameCodeUser(cmsCode);
        system.debug('delete part========================' + users);
        if(AccountIds.size()>0 && users.values2().size()>0){
            try{
                database.delete([select id from AccountShare where AccountId in :AccountIds and userOrGroupId in :users.values2()],false);
            }catch(DMLexception e){
                system.debug('DML Exception: ' + e.getDmlMessage(0));
            }
        }
    }
    
}