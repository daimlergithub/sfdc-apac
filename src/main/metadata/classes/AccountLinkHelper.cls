/**
** This class is a Helper functionality 
** 
** Created By: 
** Date: 
** Modified By : 
** Modified date : 27-oct-2015
**/

public class AccountLinkHelper
{
    
    public static Id AccountLink_ContactSectorRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('ContactSector').getRecordTypeId();
    public static Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static Id AccountLink_RetailCompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
     public static Id AccountLink_contact2conatctRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
    
/** 
* @Description  This method is for parsing crmCode
* @author  
* @Date (mm/dd/yy)
* @param  Maps the crm code of a retail task record to dealers using the crm code.
* @return returns crm codes
* @see   AccountLinkSharingWrapService, UserService, VehicleSharingWrapService
*/   
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
    
    
     /*
        * Added By: Siva Krishna
        * Desc: trigger hanler code for sharing record creation for after insert and after update event
        * Updated: Dec 12, 2016
        */
    
      
    public static void afterInsertEvent(List<Account_Link__c> list_AccountLink){
        Map<Id, List<Id>> map_AccountIdAndListAccountLinkId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> map_FromAccountIdAndListToAccountId = new Map<Id, List<Id>>();
        Set<Id> set_ToAccountId = new Set<Id>();
        
        for(Account_Link__c accountLink : list_AccountLink){
            if(accountLink.RecordTypeId == AccountLink_ContactSectorRecordTypeId && accountLink.Status__c == 'My Shops' && accountLink.toRole__c != null){
              if(!map_AccountIdAndListAccountLinkId.containsKey(accountLink.toRole__c)){
                  map_AccountIdAndListAccountLinkId.put(accountLink.toRole__c, new List<Id>());
              }
              map_AccountIdAndListAccountLinkId.get(accountLink.toRole__c).add(accountLink.Id);
            }
            
            if(accountLink.RecordTypeId == AccountLink_RetailPersonRecordTypeId || accountLink.RecordTypeId == AccountLink_RetailCompanyRecordTypeId){
                set_ToAccountId.add(accountLink.toRole__c);
                if(!map_AccountIdAndListAccountLinkId.containsKey(accountLink.fromRole__c)){
                    map_AccountIdAndListAccountLinkId.put(accountLink.fromRole__c, new List<Id>());
                }
                map_AccountIdAndListAccountLinkId.get(accountLink.fromRole__c).add(accountLink.toRole__c);
            }
        }
        if(map_AccountIdAndListAccountLinkId.size() > 0){
            createSharingRecord(map_AccountIdAndListAccountLinkId);
        }
        
        if(map_AccountIdAndListAccountLinkId.size() > 0){
            createVehicleRelationship(map_AccountIdAndListAccountLinkId, set_ToAccountId);
        }
    }
    
    
    public static void afterUpdateEvent(List<Account_Link__c> list_AccountLink, Map<Id, Account_Link__c> map_AccountLinkIdAndRecord){
        
        Set<Id> set_accountId = new Set<Id>();
        List<Id> list_SharingToDelete = new List<Id>();
        Map<Id, List<Id>> map_AccountIdAndListAccountLinkId = new Map<Id, List<Id>>();
        
        for(Account_Link__c accountLink : list_AccountLink){
            if(accountLink.RecordTypeId == AccountLink_ContactSectorRecordTypeId && accountLink.Status__c == 'My Shops' &&
                accountLink.toRole__c != null && (accountLink.toRole__c != map_AccountLinkIdAndRecord.get(accountLink.Id).toRole__c || 
                accountLink.Status__c != map_AccountLinkIdAndRecord.get(accountLink.Id).Status__c)){
                    
              set_accountId.add(map_AccountLinkIdAndRecord.get(accountLink.Id).toRole__c);
              list_SharingToDelete.add(accountLink.Id);
              
              if(!map_AccountIdAndListAccountLinkId.containsKey(accountLink.toRole__c)){
                  map_AccountIdAndListAccountLinkId.put(accountLink.toRole__c, new List<Id>());
              }
              map_AccountIdAndListAccountLinkId.get(accountLink.toRole__c).add(accountLink.Id);
            }
            
            if(accountLink.RecordTypeId == AccountLink_ContactSectorRecordTypeId && 
                    accountLink.Status__c != 'My Shops' && map_AccountLinkIdAndRecord.get(accountLink.Id).Status__c == 'My Shops'){
                set_accountId.add(map_AccountLinkIdAndRecord.get(accountLink.Id).toRole__c);
                list_SharingToDelete.add(accountLink.Id);
            }
            
            if(accountLink.RecordTypeId != AccountLink_ContactSectorRecordTypeId && 
                    map_AccountLinkIdAndRecord.get(accountLink.Id).RecordTypeId == AccountLink_ContactSectorRecordTypeId){
                set_accountId.add(accountLink.toRole__c);
                list_SharingToDelete.add(accountLink.Id);
            }
        }
        
        if(set_accountId.size() > 0){
            List<User> list_User = new List<User>( [SELECT Id, AccountId FROM User WHERE AccountId IN:set_accountId AND IsPortalEnabled = true]);
            List<Account_Link__Share> list_SharingDele = new List<Account_Link__Share>([SELECT Id FROM Account_Link__Share 
                                                                                            WHERE ParentId IN:list_SharingToDelete AND UserOrGroupId IN :list_User]);
            if(list_SharingDele.size() > 0){
                delete list_SharingDele;
            }
        }
        
        if(map_AccountIdAndListAccountLinkId.size() > 0){
            createSharingRecord(map_AccountIdAndListAccountLinkId);
        }
    }
    
    
    
    private static void createSharingRecord(Map<Id, List<Id>> map_AccountIdAndListAccountLinkId){
        List<Account_Link__Share> list_SharingRecord = new List<Account_Link__Share>();
        for(User usr : [SELECT Id, AccountId FROM User WHERE AccountId IN:map_AccountIdAndListAccountLinkId.keySet() AND IsPortalEnabled = true]){
            if(map_AccountIdAndListAccountLinkId.containsKey(usr.AccountId)){
                for(Id accountLinkId : map_AccountIdAndListAccountLinkId.get(usr.AccountId)){
                    Account_Link__Share accountLinkShare = new Account_Link__Share();
                    accountLinkShare.AccessLevel = 'Read';
                    accountLinkShare.UserOrGroupId = usr.Id;
                    accountLinkShare.ParentId = accountLinkId;
                    accountLinkShare.RowCause = Schema.Account_Link__Share.RowCause.Manual;
                    list_SharingRecord.add(accountLinkShare);
                }
            }
        }
        if(list_SharingRecord.size() > 0){
            Database.insert(list_SharingRecord, false);
        }
    }
    
    
    private static void createVehicleRelationship(Map<Id, List<Id>> map_FromAccountIdAndListToAccountId, Set<Id> set_ToAccountId){
        Map<Id, List<Id>> map_AccountIdListUser = new Map<Id, List<Id>>();
        List<Vehicle_Relationship__Share> list_SharingRecord = new List<Vehicle_Relationship__Share>();
        
        List<Vehicle_Relationship__c> list_VehicleRelationRecord = new List<Vehicle_Relationship__c>([SELECT Id, Contact__c 
                                                                                                        FROM Vehicle_Relationship__c 
                                                                                                        WHERE Contact__c IN: map_FromAccountIdAndListToAccountId.keySet()]);
        if(list_VehicleRelationRecord.size() > 0){
            for(User usr :  [SELECT Id, AccountId FROM User WHERE AccountId IN :set_ToAccountId AND IsPortalEnabled = true AND Account.RecordType.Name = 'Dealer']){
                if(!map_AccountIdListUser.containsKey(usr.AccountId)){
                    map_AccountIdListUser.put(usr.AccountId, new List<Id>());
                }
                map_AccountIdListUser.get(usr.AccountId).add(usr.Id);
            }
            
            if(map_AccountIdListUser.size() > 0){
                for(Vehicle_Relationship__c vehicleR : list_VehicleRelationRecord){
                    for(Id toAccId : map_FromAccountIdAndListToAccountId.get(vehicleR.Contact__c)){
                        for(Id usrId : map_AccountIdListUser.get(toAccId)){
                            Vehicle_Relationship__Share vehicleRelationShare = new Vehicle_Relationship__Share();
                            vehicleRelationShare.AccessLevel = 'Edit';
                            vehicleRelationShare.UserOrGroupId = usrId;
                            vehicleRelationShare.ParentId = vehicleR.Id;
                            vehicleRelationShare.RowCause = Schema.Vehicle_Relationship__Share.RowCause.Manual;
                            list_SharingRecord.add(vehicleRelationShare);
                        }
                    }
                }
            } 
            
            if(list_SharingRecord.size() > 0){
                Database.insert(list_SharingRecord, false);
            }
        }
    }
 public static void beforeInsertUpdateEvent(List<Account_Link__c> list_AccountLink,Map<id,Account_Link__c> oldMap)
 {
     Set<Id> accIds = new Set<Id>();
     List<Account_Link__c> accountlinkList = new List<Account_Link__c>();
     for(Account_Link__c acclink :list_AccountLink)
     {
     accIds.add(acclink.toRole__c);
     }
     Map<id,Account> accountMap = new Map<id,Account>([select id,(select id,position__c from Account_Links__r where recordtypeid=:AccountLink_contact2conatctRecordTypeId order by lastmodifieddate limit 1) from Account where id in :accIds]);
     
     for(Account_Link__c acclink :list_AccountLink)
     {
        If(oldMap!=null && acclink.Retail_Related_Company__c!=oldMap.get(acclink.id).Retail_Related_Company__c)
        {
        if(accountMap!=null && accountMap.get(acclink.toRole__c)!=null && !accountMap.get(acclink.toRole__c).Account_Links__r.isempty())
        {
            acclink.position__c=accountMap.get(acclink.toRole__c).Account_Links__r[0].position__c;
            accountlinkList.add(acclink);
        }
        }
         if(acclink.role__c ==acclink.role2__c && acclink.recordtypeid==AccountLink_contact2conatctRecordTypeId )
         {
         acclink.adderror('Account Link record with the same Role1, Role2 and Relation exists.');
         
         }
     }
    
     
 }

}