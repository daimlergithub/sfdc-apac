public class AccountLinkHelper
{
    private static final String CUSTOMER_TYPE = 'Customer', SERVICE_TYPE = 'Service', PROSPECT_TYPE = 'Prospect';
    private static final String NO_TYPE = 'The imported relationship has no type';
    
    public static string nameParsing(string name)
    {
        String crmCode;
        if(name!=null && name.indexOf('DMS-') > -1)
        {
            name = name.substring(name.indexOf('DMS-'));
            crmCode = name.substring(name.lastIndexOf('-') - 2, name.lastIndexOf('-'));
        }
        return crmCode;    
    }
    //Existing AU Functionality starts here.
    public static void auBefore_Insert_Events(list<Account_Link__c> listALNew)
    {
        List<Account_Link__c> cdrs = new List<Account_Link__c>();
        for(Account_Link__c cdr : listALNew){
            if(cdr.toRole__c == null || cdr.fromRole__c == null){
                cdr.addError('Customer or Dealer must be provided!');
            }
            else{
                cdrs.add(cdr);
            }
        }
        if(cdrs!=null && !cdrs.isEmpty()){
            preventRelationshipSaving(cdrs);
        }
    }
    
     public static void preventRelationshipSaving(List<Account_Link__c> relationships){
        
        Map<String, Account_Link__c> existentRelationships = getAllExistentRelationships(relationships);
        List<Account_Link__c> removedRelationships = new List<Account_Link__c>();
        
        //TODO commented : Type__c doesn't exist.
        /*for(Account_Link__c rel : relationships){
            if(String.isBlank(rel.Type__c)){
                rel.addError(NO_TYPE);
                continue;
            }
            
            String index = getIndex(rel);
            if(existentRelationships.containsKey(index)){
                Account_Link__c existentRel = existentRelationships.get(index);
                if(isHigherPriority(existentRel.Type__c, rel.Type__c)){
                    rel.Type__c = existentRel.Type__c;
                }
            }
        }*/
        
        if(existentRelationships!=null && !existentRelationships.isEmpty()){
            delete existentRelationships.values();
        }
    }
    
    /**
     *  Finds all existent customer dealer relationships according to the new relationships, Maps with customer ID and Dealer ID.
     */
  @testvisible  private static Map<String, Account_Link__c> getAllExistentRelationships(List<Account_Link__c> relationships){
        Set<String> customerIds = new Set<String>();
        Set<String> dealerIds = new Set<String>();
        
        for(Account_Link__c item : relationships){
            customerIds.add(item.toRole__c);
            dealerIds.add(item.fromRole__c);
        }
        
        Map<String, Account_Link__c> resultMap = new Map<String, Account_Link__c>();
        for(Account_Link__c item : [select Id, toRole__c, fromRole__c
                                                    from Account_Link__c
                                                    where toRole__c in :customerIds and fromRole__c in :dealerIds]){
            String index = getIndex(item);
            if(!resultMap.containskey(index)){           
                resultMap.put(index, item);
            }
        }
        return resultMap;
    }
    
 @testvisible    private static String getIndex(Account_Link__c relationship){
        String cid = relationship.toRole__c, did = relationship.fromRole__c;
        return cid.substring(0, 15) + ';' + did.substring(0, 15);
    }
    
  @testvisible   private static Boolean isHigherPriority(String one, String two){
        if(two == CUSTOMER_TYPE){
            return false;
        }
        if(one == CUSTOMER_TYPE){
            return true;
        }
        if(one > two){
            return true;
        }
        return false;
    }
    
    Public static void shareAccountToDealer(List<Account_Link__c> aclinkList)
    {
        set<id> aclnkId = new set<id>();
        set<id> accid = new set<id>();
        List<Account> shaccList = new List<Account>();
        List<Vehicle_Relationship__c> shvRList = new List<Vehicle_Relationship__c>();
        set<id> vRId = new set<id>();
        map<id,id> vRMap = new map<id,id>();
        map<id,id> vechMap = new map<id,id>();
        set<string> grpId = new set<string>();
        map<string,id> groupMap = new map<string,id>();
        List<Group> grpList = new List<Group>();
        map<id,id> accountMap = new map<id,id>();
        List<Sobject> shareacclinkList = new List<Sobject>();
        List<Account_Link__c> shareaclkList = new List<Account_Link__c>();
        for(Account_Link__c aclnk : aclinkList)
        {
            if(aclnk.toRole__c != null && aclnk.fromRole__c != null && 
               (aclnk.Status__c == 'Preferred' || aclnk.Status__c == 'Preferred' || aclnk.Status__c == 'Last Selling' ||
               aclnk.Status__c == 'Last Servicing' || aclnk.Status__c == 'Territory Dealer'|| aclnk.Status__c == 'Last Financing'))
            {
                aclnkId.add(aclnk.id);   
            }            
        }
        
        shareaclkList = [select id, torole__c, fromrole__c, fromrole__r.Name from Account_Link__c where id =:aclnkId];        
        if(shareaclkList.isEmpty() && shareaclkList != null)
        {
            for(Account_Link__c acln : shareaclkList)
            {
                grpId.add(acln.fromrole__r.Name);
                accid.add(acln.toRole__c);
                accountMap.put(acln.Id, acln.toRole__c);
            }
        }
        if(!accid.isEmpty() && accid != null)
        {
            shvRList = [select id , contact__c , vehicle_ID__c from Vehicle_Relationship__c where contact__c =:accid];
        }
        if(!shvRList.isEmpty() && shvRList != null)
        {
            for(Vehicle_Relationship__c srVr : shvRList)
            {
                vRMap.put(srVr.contact__c, srVr.id);
                vechMap.put(srVr.Contact__c, srVr.Vehicle_ID__c);
            }            
        }
        grpList = [select id ,DeveloperName ,Name ,Type from Group where Name =:grpId];
        for(Group gr :grpList)
        {
            groupMap.put(gr.Name, gr.id);
        }
        if(!shareaclkList.isEmpty() && shareaclkList != null)
        {
            for(Account_Link__c shaclnk : shareaclkList)
            {
                AccountShare acshar = new AccountShare();
                acshar.AccountId = accountMap.get(shaclnk.id);
                acshar.UserOrGroupId = groupMap.get(shaclnk.fromrole__r.Name);
                acshar.AccountAccessLevel = 'Edit';
                acshar.CaseAccessLevel = 'Read';
                shareacclinkList.add(acshar);
                
                Account_Link__Share alinkShare = new Account_Link__Share();
                alinkShare.ParentId = shaclnk.Id;
                alinkShare.UserOrGroupId = groupMap.get(shaclnk.fromrole__r.Name);
                alinkShare.AccessLevel = 'Edit';
                shareacclinkList.add(alinkShare);
                if(!vRMap.isEmpty() && vRMap.get(shaclnk.toRole__c) != null)
                {
                    Vehicle_Relationship__Share vrShare = new Vehicle_Relationship__Share();
                    vrShare.ParentId = vRMap.get(shaclnk.toRole__c);
                    vrShare.UserOrGroupId = groupMap.get(shaclnk.fromrole__r.Name);
                    vrShare.AccessLevel = 'Edit';
                    shareacclinkList.add(vrShare);
                }
                if(!vechMap.isEmpty() && vechMap != null)
                {
                    Vehicle__Share shrVehicle = new Vehicle__Share();
                    shrVehicle.ParentId = vechMap.get(shaclnk.toRole__c);
                    shrVehicle.UserOrGroupId = groupMap.get(shaclnk.fromrole__r.Name);
                    shrVehicle.AccessLevel = 'Edit';
                    shareacclinkList.add(shrVehicle);
                }
            }
        }
        
        if(!shareacclinkList.isEmpty() && shareacclinkList != null)
        {
            insert shareacclinkList;
        }
    }
    //Existing AU Functionality ends here.
}