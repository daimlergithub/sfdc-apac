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

public class AccountSharingDataBatchHandler {
    
    protected CMap parentIds = new CMap();
    protected CMap userOrGroupIds = new CMap();
        
    public AccountSharingDataBatchHandler (String processFlg) {
        
        this.processFlg = processFlg;
    }

    //person account record type
    private Id personAccountRecordType =
        UtilRecordType.getRecordTypeIdByName('Account', 'Person Account');

    private String processFlg = '';
    /**
     * share Person Account of Lead to active dealer have same CRM code
     * @scope Account list consist Crm code and Account id
     * @which person Account which is specified , 
     *          If it's null , It's will consist Lead and Complaint
     */
    public void executeProcessByCRMCode(List<sObject> scope) {
        
        CMap dmsAndDealer = filterDealer(scope);

        //Filter the dealer not to be share
        dmsAndDealer.cleanLessThanTwoList();

        if(dmsAndDealer.KeySet().size() < 1){return;}
        
        Set<String> dealerIds = dmsAndDealer.values2();
        SYSTEM.debug('dmsAndDealer====:'+dmsAndDealer);

        Map<String, CMap> dataMap = new Map<String, CMap>();

        //Choose process
        //Query share data for this proccess
        if( this.processFlg == 'Lead__c'){

            dataMap = LeadShareProcess(dealerIds , null);

        }else if (this.processFlg == 'Dealer'){
            
            dataMap = DealerShareProcess(dealerIds);

        }else if (this.processFlg == 'Complaint') {

            dataMap = ComplaintShareProcess(dealerIds);

        }else if (this.processFlg == 'Retail_Vehicle_RelationShip') {
            dataMap = RetailAccountShareProcess(dealerIds);
        }

        //Query Dealer GateKeeper
        CMap parent = dataMap.get('parent');
        CMap users = dataMap.get('user');
        
        system.debug('parent========================' + parent);
        system.debug('user========================' + users);

        //make them use crm code
        for(String crmCode : dmsAndDealer.KeySet()){
            for(String accountid : dmsAndDealer.get(crmCode)){
                if(parent.get(accountid) != null && users.get(accountid) != null){
                    parentIds.addAll(crmCode, parent.get(accountid));
                    userOrGroupIds.addAll(crmCode, users.get(accountid));
                }
            }
        }

        shareAccount(parentIds, userOrGroupIds);

    }
    
    
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
     *  share lead process
     */
    private Map<String, CMap> LeadShareProcess(Set<String> dealerIds, CMap shareObjects){
    
        Map<String, CMap> rtnMap = new Map<String, CMap>();
        //Query Dealer GateKeeper
        CMap leadGaterKeeperAndDealer = getGateKeeper(dealerIds, 'Lead');
        system.debug(leadGaterKeeperAndDealer);
        CMap leadPersonAccountAndDealer = new CMap();
        if(shareObjects == null){
            //Query Sharing object
            for(Account a : [Select (Select Contact__c From Lead_Assigned_Dealer__r) From Account a WHERE id in :dealerIds]){
                for(Lead__c l : a.getSObjects('Lead_Assigned_Dealer__r')){
                    leadPersonAccountAndDealer.add(a.Id, (String)l.get('Contact__c'));
                }
            }
        }else{
            leadPersonAccountAndDealer = shareObjects;
        }

        rtnMap.put('parent', leadPersonAccountAndDealer);
        rtnMap.put('user', leadGaterKeeperAndDealer);

        return rtnMap;

    }

    /**
     *  share each active dealer record to the users of the active dealers with the same CRM Code.
     */
    private Map<String, CMap> ComplaintShareProcess(Set<String> dealerIds){
    
        Map<String, CMap> rtnMap = new Map<String, CMap>();

        CMap users = getGateKeeper(dealerIds, 'Lead');
        CMap parent = new CMap();

        //Query Sharing object
        for(Case c : [select AccountId, Case_Dealer__c from Case WHERE Case_Dealer__c in :dealerIds AND recordtype.Name like '%Complaint']){
            parent.add(c.Case_Dealer__c, c.Accountid);
        }

        rtnMap.put('parent', parent);
        rtnMap.put('user', users);

        return rtnMap;

    }

    /**
     *  share each active dealer record to the users of the active dealers with the same CRM Code.
     */
    private Map<String, CMap> DealerShareProcess(Set<String> dealerIds){
    
        Map<String, CMap> rtnMap = new Map<String, CMap>();

        CMap users = new CMap();
        CMap parent = new CMap();

        //Query Sharing object
        for(User a : [Select Id, Accountid From User where isactive = true and AccountId in :dealerIds]){
            users.add( a.Accountid,a.Id);
        }

        for(String id : dealerIds){
            parent.add(id, id);
        }

        rtnMap.put('parent', parent);
        rtnMap.put('user', users);

        return rtnMap;

    }

    /**
     *  share each active dealer record to the users of the active dealers Vehicle_Relationship__c with the same CRM Code.
     */
    private Map<String, CMap> RetailAccountShareProcess(Set<String> dealerIds){
    
        Map<String, CMap> rtnMap = new Map<String, CMap>();

        CMap users = new CMap();
        CMap parent = new CMap();

        //Query Sharing object
        for(User a : [Select Id, Accountid From User where isactive = true and AccountId in :dealerIds]){
            users.add( a.Accountid,a.Id);
        }

        for(Vehicle_Relationship__c v : [Select Contact__c, Owner_Dealer__c 
                                         From Vehicle_Relationship__c 
                                         where Owner_Dealer__c in :dealerIds and recordtype.Name='Vehicle Relationship Retail']){
            parent.add(v.Owner_Dealer__c, v.Contact__c);
        }

        rtnMap.put('parent', parent);
        rtnMap.put('user', users);

        return rtnMap;

    }

    /**
     * share person account of Account link 
     */
    public void accountLinkShareProcess(List<Account_Link__c> accountLinks){
        CMap cmsAndDealer = new CMap();
        CMap parent = new CMap();
        CMap users = new CMap();
        CMap userOrGroupIds = new CMap();
        Set<String> cmsCodes = new Set<String>();
        Set<String> personAccounts = new Set<String>();
        Set<String> dealers = new Set<String>();
        
        for(Account_Link__c alink : accountLinks){
            String cmsCode = getCRMcodeFromName(alink.Name);

            if(!cmsCodes.contains(cmsCode) && !String.isBlank(cmsCode)){
                    
                if(alink.toRole__c != null || alink.fromRole__c != null){
                    cmsCodes.add(cmsCode);
                }
                if(alink.toRole__c != null ){
                    parent.add(cmsCode, alink.toRole__c);
                }
                if(alink.fromRole__c != null ){
                    parent.add(cmsCode, alink.fromRole__c);
                }
            }

        }
        if(parent.keySet().size()<1 || cmsCodes.size()<1) return;
/**
        Map<id, Account> dealersMap = new Map<id,Account>([select Id, Dealer_DMS_CRM_Code__c from Account 
                    where RecordType.Name = 'Dealer' 
                    and Dealer_DMS_CRM_Code__c in :cmsCodes 
                    and Dealer_Active__c = true ]);
        
        
        //Query Sharing object
        for(User u : [Select Id, AccountId From User where isactive = true and AccountId in :dealersMap.keySet()]){
            users.add(u.AccountId,u.Id);
        }

        for(Account a : dealersMap.values()){
            cmsAndDealer.add(a.Dealer_DMS_CRM_Code__c,a.Id);
        }

        for(String crmCode : cmsAndDealer.KeySet()){
            for(String accountid : cmsAndDealer.get(crmCode)){
                if( users.get(accountid) != null){
                    userOrGroupIds.addAll(crmCode, users.get(accountid));
                }
            }
        }       
*/
        //Query Sharing object
        for(User u : [select Id, Contact.Account.Dealer_DMS_CRM_Code__c, AccountId from User where IsActive = true and Contact.Account.Dealer_DMS_CRM_Code__c in :cmsCodes and Contact.Account.Dealer_Active__c = true and Contact.Account.Recordtype.Name = 'dealer']){

            userOrGroupIds.add(u.Contact.Account.Dealer_DMS_CRM_Code__c,u.id);
        }
        system.debug('parent=======' + parent);
        system.debug('userOrGroupIds=========' + userOrGroupIds);
        
        if(parent.keySet().size()<1 || userOrGroupIds.keySet().size()<1) return;
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
     * Query dealers gatekeeper
     * @param dealers dealer ids
     * @return Map key is dealer id , value is user id
     */
    public CMap getGateKeeper(Set<String> dealers , String which ){

        String addStr = '';
        if(which == 'Lead'){
            addStr = ' And   c.Dealer_Lead_Gate_Keeper__c = true';
        }
        if(which == 'Complaint'){
            addStr = ' And   c.Dealer_complaint_Gate_Keeper__c = true';         
        }


        String querySOQL = 'SELECT ' +
                           '      Id , ' +
                           '      AccountId '+ 
                           'FROM User ' +
                           'WHERE isActive = true ' +
                           'AND contactId in ' +
                           '               (SELECT c.Id ' +
                           '                FROM Contact c ' + 
                           '                WHERE c.AccountId in :dealers ' +
                           addStr + ')'; 
        system.debug(querySOQL);
        CMap gateKeepers = new CMap();

        for(User u : Database.query(querySOQL)){
            gateKeepers.add(u.AccountId, u.Id);
        }
        return gateKeepers;
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
            for(Id pId : pIds.get(crmCode)){
                if(uogIds.get(crmCode) != null){
                    for(Id uogId : uogIds.get(crmCode)){
                        shareRecs.add(createShareObject(pId,uogId));
                    }
                }           
            }
        }
        system.debug('shareRecs:'+shareRecs);
        return shareRecs;
    }
}