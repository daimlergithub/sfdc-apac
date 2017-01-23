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
    public static Id AccountLink_VehicleExternalRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId();
    public static Id AccountLink_IndividualCustomerRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId();
    public static Id AccountLink_Contact2ContactRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
    public static Id AccountLink_CompanyCustomerRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Company Customer External Link').getRecordTypeId();
    public static Id AccountLink_contact2conatctRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
    public Account_Link__c oldals {set;get;}
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
        * Added By: Abhishekh Dasepalle
        * Desc: trigger handler code for after update operation which insert record in ep export notification object
        * Updated: Dec 20, 2016
        */
    public static void ExportNotification (List<Account_Link__c> sample,Map<id,Account_Link__c> oldals)  {
    
   
    List<EP_Export_Notification__c> epList = New list<EP_Export_Notification__c>();
   
        for(Account_Link__c als : sample){
        Id recId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
        Id recrId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
        if ( als.Retail_DMS_Customer_ID__c != null && als.RecordTypeId == recId || als.Retail_DMS_Customer_ID__c != null && als.RecordTypeId == recrId  ){
         
         
         if(als.Retail_Gender__c!= oldals.get(als.Id).Retail_Gender__c || als.Retail_UCID__c!= oldals.get(als.Id).Retail_UCID__c || 

            als.Retail_LastName__c != oldals.get(als.Id).Retail_LastName__c||
            als.Retail_Full_Name__c != oldals.get(als.Id).Retail_Full_Name__c||
            als.Retail_Full_Name_Title__c != oldals.get(als.Id).Retail_Full_Name_Title__c||
            als.Retail_Full_Name_Native__c != oldals.get(als.Id).Retail_Full_Name_Native__c||
            als.Retail_FirstName__c != oldals.get(als.Id).Retail_FirstName__c||
            als.Retail_LastName_Native__c != oldals.get(als.Id).Retail_LastName_Native__c||
            als.Retail_FirstName_Native__c != oldals.get(als.Id).Retail_FirstName_Native__c||
            als.Retail_Company_Name__c != oldals.get(als.Id).Retail_Company_Name__c||
            als.Retail_Company_Name_Native1__c != oldals.get(als.Id).Retail_Company_Name_Native1__c||
            als.Retail_Preferred_Language__c != oldals.get(als.Id).Retail_Preferred_Language__c||
            als.Retail_Special_Care__c != oldals.get(als.Id).Retail_Special_Care__c||
            als.Retail_Special_Needs_Class__c !=    oldals.get(als.Id).Retail_Special_Needs_Class__c||
            als.Retail_PersonBirthdate__c !=    oldals.get(als.Id).Retail_PersonBirthdate__c||
            als.Retail_Occupation__c != oldals.get(als.Id).Retail_Occupation__c||
            als.Retail_Vat_No__c != oldals.get(als.Id).Retail_Vat_No__c||
            als.Retail_Commercial_Reg_No__c != oldals.get(als.Id).Retail_Commercial_Reg_No__c||
            als.Retail_Foundation_Month__c  !=  oldals.get(als.Id).Retail_Foundation_Month__c||
            als.Retail_Website__c   !=  oldals.get(als.Id).Retail_Website__c||
            als.Retail_Industry__c  !=  oldals.get(als.Id).Retail_Industry__c||
            als.Retail_Primary_Phone__c !=  oldals.get(als.Id).Retail_Primary_Phone__c||
            als.Retail_Allow_Data_Sharing__c    !=  oldals.get(als.Id).Retail_Allow_Data_Sharing__c||
            als.Retail_Delete_Flag__c   !=  oldals.get(als.Id).Retail_Delete_Flag__c||
            als.Retail_Duplicate_Flag__c    !=  oldals.get(als.Id).Retail_Duplicate_Flag__c||
            als.Retail_Email__c !=  oldals.get(als.Id).Retail_Email__c||
            als.Retail_Fax__c   !=  oldals.get(als.Id).Retail_Fax__c||
            als.Retail_Individual_Home_Phone__c !=  oldals.get(als.Id).Retail_Individual_Home_Phone__c||
            als.Retail_Work_Phone__c    !=  oldals.get(als.Id).Retail_Work_Phone__c||
            als.Retail_Mobile__c    !=  oldals.get(als.Id).Retail_Mobile__c||
            als.Retail_Company_Phone__c !=  oldals.get(als.Id).Retail_Company_Phone__c||
            als.Retail_Company_Other_Phone__c   !=  oldals.get(als.Id).Retail_Company_Other_Phone__c||
            als.Retail_Fax__c   !=  oldals.get(als.Id).Retail_Fax__c|| 
            als.Retail_Province__c  !=  oldals.get(als.Id).Retail_Province__c|| 
            als.Retail_City__c  != oldals.get(als.Id).Retail_City__c||
            als.Retail_Distinct__c  !=  oldals.get(als.Id).Retail_Distinct__c||
            als.Retail_Address_Line_1__c    !=  oldals.get(als.Id).Retail_Address_Line_1__c||
            als.Retail_Address_Line_2__c    !=  oldals.get(als.Id).Retail_Address_Line_2__c||
            als.Retail_ZipCode__c   !=  oldals.get(als.Id).Retail_ZipCode__c||
            als.Retail_Related_Company__c   !=  oldals.get(als.Id).Retail_Related_Company__c||
            als.Retail_Position__c  !=  oldals.get(als.Id).Retail_Position__c){
         
            EP_Export_Notification__c epe = New EP_Export_Notification__c();
            epe.Status__c = 'New';
            epe.Usecase__c = 'AL.CustomerUpdate';
            epe.MD__c = als.MD__c;
            epe.Type__c = 'Account_Link__c';
            epe.SFDC_object_id__c = als.id;
            
            
            
         
           epList.add(epe);
         
         }
         }
         insert epList;
        
    
    
    
    }
    }
      /*
        * Added By: Siva Krishna
        * Desc: trigger hanler code for sharing record creation for after insert and after update event
        * Updated: Dec 30, 2016
        */
      
      
    public static void afterInsertEvent(List<Account_Link__c> list_AccountLink){
        Map<Id, List<Id>> map_AccountIdAndListAccountLinkId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> map_FromAccountIdAndListToAccountId = new Map<Id, List<Id>>();
        Set<Id> set_ToAccountId = new Set<Id>();
        Map<Id, List<Id>> map_DealerAccountIdAndListAccountLinkId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> map_PersonCompanyAccountIdAndListAccountLinkId = new Map<Id, List<Id>>();
        
        for(Account_Link__c accountLink : list_AccountLink){
            if(accountLink.RecordTypeId == AccountLink_ContactSectorRecordTypeId && accountLink.Status__c == 'My Shops' && accountLink.fromRole__c != null){
              if(!map_AccountIdAndListAccountLinkId.containsKey(accountLink.fromRole__c)){
                  map_AccountIdAndListAccountLinkId.put(accountLink.fromRole__c, new List<Id>());
              }
              map_AccountIdAndListAccountLinkId.get(accountLink.fromRole__c).add(accountLink.Id);
            }
            
            if(accountLink.RecordTypeId == AccountLink_RetailPersonRecordTypeId || accountLink.RecordTypeId == AccountLink_RetailCompanyRecordTypeId){
                if(accountLink.fromRole__c != null && accountLink.toRole__c != null){
                    set_ToAccountId.add(accountLink.fromRole__c);
                    if(!map_AccountIdAndListAccountLinkId.containsKey(accountLink.toRole__c)){
                        map_AccountIdAndListAccountLinkId.put(accountLink.toRole__c, new List<Id>());
                    }
                    map_AccountIdAndListAccountLinkId.get(accountLink.toRole__c).add(accountLink.Id);
                }
            }
            
            if(accountLink.RecordTypeId == AccountLink_RetailPersonRecordTypeId || accountLink.RecordTypeId == AccountLink_RetailCompanyRecordTypeId
                || accountLink.RecordTypeId == AccountLink_VehicleExternalRecordTypeId){ 
                                   
                if(accountLink.fromRole__c != null){
                    if(!map_DealerAccountIdAndListAccountLinkId.containsKey(accountLink.fromRole__c)){
                      map_DealerAccountIdAndListAccountLinkId.put(accountLink.fromRole__c, new List<Id>());
                    }
                    map_DealerAccountIdAndListAccountLinkId.get(accountLink.fromRole__c).add(accountLink.Id);
                }
            }
            
            if(accountLink.RecordTypeId == AccountLink_CompanyCustomerRecordTypeId || accountLink.RecordTypeId == AccountLink_Contact2ContactRecordTypeId
                || accountLink.RecordTypeId == AccountLink_IndividualCustomerRecordTypeId){
                    
                if(!map_PersonCompanyAccountIdAndListAccountLinkId.containsKey(accountLink.fromRole__c)){
                  map_PersonCompanyAccountIdAndListAccountLinkId.put(accountLink.fromRole__c, new List<Id>());
              }
              map_PersonCompanyAccountIdAndListAccountLinkId.get(accountLink.fromRole__c).add(accountLink.Id);
            }
            
            if(accountLink.RecordTypeId == AccountLink_Contact2ContactRecordTypeId){
                if(!map_AccountIdAndListAccountLinkId.containsKey(accountLink.toRole__c)){
                  map_AccountIdAndListAccountLinkId.put(accountLink.toRole__c, new List<Id>());
              }
              map_AccountIdAndListAccountLinkId.get(accountLink.toRole__c).add(accountLink.Id);
            }
        }
        
        if(map_AccountIdAndListAccountLinkId.size() > 0){
            // createSharingRecord(map_AccountIdAndListAccountLinkId);
        }
        
        if(map_AccountIdAndListAccountLinkId.size() > 0){
            createVehicleRelationship(map_AccountIdAndListAccountLinkId, set_ToAccountId);
        }
        
        if(map_DealerAccountIdAndListAccountLinkId.size() > 0){
            createDealerSharingRecord(map_DealerAccountIdAndListAccountLinkId);
        }
        
        if(map_PersonCompanyAccountIdAndListAccountLinkId.size() > 0){
            createPCSharingRecord(map_PersonCompanyAccountIdAndListAccountLinkId);
        }
    }
    
    
    public static void afterUpdateEvent(List<Account_Link__c> list_AccountLink, Map<Id, Account_Link__c> map_AccountLinkIdAndRecord){
        
        Set<Id> set_accountId = new Set<Id>();
        List<Id> list_SharingToDelete = new List<Id>();
        Map<Id, List<Id>> map_AccountIdAndListAccountLinkId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> map_PersonCompanyAccountIdAndListAccountLinkId = new Map<Id, List<Id>>();
        
        for(Account_Link__c accountLink : list_AccountLink){
            if(accountLink.RecordTypeId == AccountLink_ContactSectorRecordTypeId && accountLink.Status__c == 'My Shops' &&
                accountLink.fromRole__c != null && (accountLink.fromRole__c != map_AccountLinkIdAndRecord.get(accountLink.Id).fromRole__c || 
                accountLink.Status__c != map_AccountLinkIdAndRecord.get(accountLink.Id).Status__c)){
                    
              set_accountId.add(map_AccountLinkIdAndRecord.get(accountLink.Id).fromRole__c);
              list_SharingToDelete.add(accountLink.Id);
              
              if(!map_AccountIdAndListAccountLinkId.containsKey(accountLink.fromRole__c)){
                  map_AccountIdAndListAccountLinkId.put(accountLink.fromRole__c, new List<Id>());
              }
              map_AccountIdAndListAccountLinkId.get(accountLink.fromRole__c).add(accountLink.Id);
            }
            
            if(accountLink.RecordTypeId == AccountLink_ContactSectorRecordTypeId && 
                    accountLink.Status__c != 'My Shops' && map_AccountLinkIdAndRecord.get(accountLink.Id).Status__c == 'My Shops'){
                set_accountId.add(map_AccountLinkIdAndRecord.get(accountLink.Id).fromRole__c);
                list_SharingToDelete.add(accountLink.Id);
            }
            
            if(accountLink.RecordTypeId != AccountLink_ContactSectorRecordTypeId && 
                    map_AccountLinkIdAndRecord.get(accountLink.Id).RecordTypeId == AccountLink_ContactSectorRecordTypeId){
                set_accountId.add(accountLink.fromRole__c);
                list_SharingToDelete.add(accountLink.Id);
            }
            
            if((accountLink.RecordTypeId != AccountLink_CompanyCustomerRecordTypeId && map_AccountLinkIdAndRecord.get(accountLink.Id).RecordTypeId == AccountLink_CompanyCustomerRecordTypeId)
                    || (accountLink.RecordTypeId != AccountLink_Contact2ContactRecordTypeId && map_AccountLinkIdAndRecord.get(accountLink.Id).RecordTypeId == AccountLink_Contact2ContactRecordTypeId)
                    || (map_AccountLinkIdAndRecord.get(accountLink.Id).RecordTypeId == AccountLink_IndividualCustomerRecordTypeId && accountLink.RecordTypeId != AccountLink_IndividualCustomerRecordTypeId)){
                    
                set_accountId.add(accountLink.fromRole__c);
                list_SharingToDelete.add(accountLink.Id);
            }
            
            if(accountLink.fromRole__c != null && (accountLink.RecordTypeId == AccountLink_CompanyCustomerRecordTypeId || accountLink.RecordTypeId == AccountLink_Contact2ContactRecordTypeId
                || accountLink.RecordTypeId == AccountLink_IndividualCustomerRecordTypeId) && accountLink.fromRole__c != map_AccountLinkIdAndRecord.get(accountLink.Id).fromRole__c){
                    
                set_accountId.add(map_AccountLinkIdAndRecord.get(accountLink.Id).fromRole__c);
                list_SharingToDelete.add(accountLink.Id);
                if(!map_PersonCompanyAccountIdAndListAccountLinkId.containsKey(accountLink.fromRole__c)){
                  map_PersonCompanyAccountIdAndListAccountLinkId.put(accountLink.fromRole__c, new List<Id>());
                }
                map_PersonCompanyAccountIdAndListAccountLinkId.get(accountLink.fromRole__c).add(accountLink.Id);
            }
            
            if(accountLink.toRole__c != null && accountLink.RecordTypeId == AccountLink_Contact2ContactRecordTypeId
                && accountLink.toRole__c != map_AccountLinkIdAndRecord.get(accountLink.Id).toRole__c){
                    
                set_accountId.add(map_AccountLinkIdAndRecord.get(accountLink.Id).toRole__c);
                list_SharingToDelete.add(accountLink.Id);
                if(!map_AccountIdAndListAccountLinkId.containsKey(accountLink.toRole__c)){
                    map_AccountIdAndListAccountLinkId.put(accountLink.toRole__c, new List<Id>());
                }
                map_AccountIdAndListAccountLinkId.get(accountLink.toRole__c).add(accountLink.Id);
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
        
        if(map_PersonCompanyAccountIdAndListAccountLinkId.size() > 0){
            createPCSharingRecord(map_PersonCompanyAccountIdAndListAccountLinkId);
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
    
    
    private static void createPCSharingRecord(Map<Id, List<Id>> map_AccountIdAndListAccountLinkId){
        List<Account_Link__Share> list_SharingRecord = new List<Account_Link__Share>();
        for(User usr : [SELECT Id, Contact.AccountId FROM User WHERE Contact.AccountId IN:map_AccountIdAndListAccountLinkId.keySet() AND IsPortalEnabled = true AND Contact.Account.RecordType.Name = 'Dealer']){
            if(map_AccountIdAndListAccountLinkId.containsKey(usr.Contact.AccountId)){
                for(Id accountLinkId : map_AccountIdAndListAccountLinkId.get(usr.Contact.AccountId)){
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
    
    
    
    private static void createDealerSharingRecord(Map<Id, List<Id>> map_AccountIdAndListAccountLinkId){
        List<Account_Link__Share> list_SharingRecord = new List<Account_Link__Share>();
        for(User usr : [SELECT Id, Contact.AccountId FROM User WHERE Contact.AccountId IN:map_AccountIdAndListAccountLinkId.keySet() AND IsPortalEnabled = true AND Contact.Account.RecordType.Name = 'Dealer']){
            if(map_AccountIdAndListAccountLinkId.containsKey(usr.Contact.AccountId)){
                for(Id accountLinkId : map_AccountIdAndListAccountLinkId.get(usr.Contact.AccountId)){
                    Account_Link__Share accountLinkShare = new Account_Link__Share();
                    accountLinkShare.AccessLevel = 'Edit';
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
            for(User usr :  [SELECT Id, Contact.AccountId FROM User WHERE Contact.AccountId IN :set_ToAccountId AND IsPortalEnabled = true AND Contact.Account.RecordType.Name = 'Dealer']){
                if(!map_AccountIdListUser.containsKey(usr.Contact.AccountId)){
                    map_AccountIdListUser.put(usr.Contact.AccountId, new List<Id>());
                }
                map_AccountIdListUser.get(usr.Contact.AccountId).add(usr.Id);
            }
            
            if(map_AccountIdListUser.size() > 0){
                for(Vehicle_Relationship__c vehicleR : list_VehicleRelationRecord){
                    if(map_FromAccountIdAndListToAccountId.containsKey(vehicleR.Contact__c)){
                        for(Id toAccId : map_FromAccountIdAndListToAccountId.get(vehicleR.Contact__c)){
                            if(map_AccountIdListUser.containsKey(toAccId)){
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
 public static void updateRetailCopy(boolean isUpdate, boolean isinsert,boolean isBefore ,List<Account_Link__c> accLst){
        
        system.debug('------>Method is called');
        Set<String> AccountIds = new set<String>();//Set initialization to add account Id's
        List<Account_Link__c> AccountlnkUpdate = new List<Account_Link__c>();//Account Link Initialization
        for(Account_Link__c acc : accLst){
            if((isInsert || isUpdate) && acc.MD__c == label.MarketJp){ //Checking Market for updated account
                AccountIds.add(acc.toRole__c); //Adding accountId's to set
                System.debug('AccountID--->'+acc.id);        
            }
            
        }
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();//Retriveing record type ID for Retail Person
        Id RetailCompany = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();//Retriveing record type ID for Retail Company
        Map<id,Account> accountMap = new Map<id,Account>([select id,Name,RecordType.Name, LastName, FirstName, Salutation__c, LastName_Native_1__c,
                                                FirstName_Native_1__c, Gender__c, PersonBirthdate, Occupation__c, Industry, 
                                                Preferred_Language__c, Primary_Phone__c, Special_Care__c, Special_Needs_Class__c,
                                                Allow_Data_Sharing2__c, Individual_Home_Phone__c, Work_Phone__c, Mobile__c, Fax,
                                                Email__c,Primary_Address_Reference__r.Address_Type__c, Primary_Address_Reference__r.Province__c,
                                                Primary_Address_Reference__r.City__c, Primary_Address_Reference__r.District__c, Primary_Address_Reference__r.Block__c,
                                                Primary_Address_Reference__r.Address_Line_1__c, Primary_Address_Reference__r.Address_Line_2__c, Primary_Address_Reference__r.ZipCode__c,
                                                Company_Name_Native_1__c, Commercial_Reg_No__c, Vat_No__c, 
                                                Foundation_Date__c, Website, Primary_Address_Reference__r.CreatedDate,
                                                Primary_Address_Reference__r.LastModifiedDate
                                                from Account WHERE Id IN :AccountIds]);
        System.debug('Accountlinklist------>'+accountMap);
        //Account link iteration
        for(Account_Link__c acclink : accLst ){
            if(acclink.toRole__c != null){
            if(accountMap.get(acclink.toRole__c).RecordType.Name == 'Person Account') {
                acclink.Retail_LastName__c = accountMap.get(acclink.toRole__c).LastName;
                acclink.Retail_FirstName__c = accountMap.get(acclink.toRole__c).FirstName;
                //acclink.Retail_Salutation__c = accountMap.get(acclink.toRole__c).Salutation__c;
                acclink.Retail_Full_Name__c = ((accountMap.get(acclink.toRole__c).LastName != null ? accountMap.get(acclink.toRole__c).LastName:'') + (accountMap.get(acclink.toRole__c).FirstName != null ? accountMap.get(acclink.toRole__c).FirstName:'')).left(25); 
                acclink.Retail_Full_Name_Title__c = ((accountMap.get(acclink.toRole__c).Salutation__c!= null ? accountMap.get(acclink.toRole__c).Salutation__c: '')+(accountMap.get(acclink.toRole__c).LastName != null ? accountMap.get(acclink.toRole__c).LastName:'') + (accountMap.get(acclink.toRole__c).FirstName != null ? accountMap.get(acclink.toRole__c).FirstName:'')).left(140);
                acclink.Retail_LastName_Native__c = accountMap.get(acclink.toRole__c).LastName_Native_1__c;
                acclink.Retail_FirstName_Native__c = accountMap.get(acclink.toRole__c).FirstName_Native_1__c; 
                acclink.Retail_Gender__c = accountMap.get(acclink.toRole__c).Gender__c;
                acclink.Retail_PersonBirthdate__c = accountMap.get(acclink.toRole__c).PersonBirthdate;
                acclink.Retail_Occupation__c = accountMap.get(acclink.toRole__c).Occupation__c;                
                acclink.Retail_Preferred_Language__c = accountMap.get(acclink.toRole__c).Preferred_Language__c;
                acclink.Retail_Primary_Phone__c = accountMap.get(acclink.toRole__c).Primary_Phone__c;
                acclink.Retail_Special_Care__c = accountMap.get(acclink.toRole__c).Special_Care__c;
                acclink.Retail_Special_Needs_Class__c = accountMap.get(acclink.toRole__c).Special_Needs_Class__c;
                acclink.Retail_Allow_Data_Sharing__c = accountMap.get(acclink.toRole__c).Allow_Data_Sharing2__c;                
                acclink.Retail_Work_Phone__c = accountMap.get(acclink.toRole__c).Work_Phone__c;
                acclink.Retail_Mobile__c = accountMap.get(acclink.toRole__c).Mobile__c;                
                acclink.Retail_Email__c = accountMap.get(acclink.toRole__c).Email__c;
				acclink.Retail_Individual_Home_Phone__c = accountMap.get(acclink.toRole__c).Individual_Home_Phone__c;
            }
            //Checking the Company RecordType
            if(accountMap.get(acclink.toRole__c).RecordType.Name=='Company'){ 
                acclink.Retail_Company_Name__c = accountMap.get(acclink.toRole__c).Name;
                acclink.Retail_Company_Name_Native1__c = accountMap.get(acclink.toRole__c).Company_Name_Native_1__c;
                acclink.Retail_Commercial_Reg_No__c = accountMap.get(acclink.toRole__c).Commercial_Reg_No__c;
                acclink.Retail_Vat_No__c = accountMap.get(acclink.toRole__c).Vat_No__c;
                if(accountMap.get(acclink.toRole__c).Foundation_Date__c != null)
                {
                    Integer FoundationDate = accountMap.get(acclink.toRole__c).Foundation_Date__c.month();
                    if(FoundationDate <= 9){
                        acclink.Retail_Foundation_Month__c = '0'+String.valueOf(accountMap.get(acclink.toRole__c).Foundation_Date__c.month())+ String.valueOf(accountMap.get(acclink.toRole__c).Foundation_Date__c.Year());      
                    }else {                    
                        acclink.Retail_Foundation_Month__c = String.valueOf(accountMap.get(acclink.toRole__c).Foundation_Date__c.month())+ String.valueOf(accountMap.get(acclink.toRole__c).Foundation_Date__c.Year());
                    }
                 }
				 acclink.Retail_Company_Phone__c = accountMap.get(acclink.toRole__c).Individual_Home_Phone__c;
                 acclink.Retail_Company_Other_Phone__c =  accountMap.get(acclink.toRole__c).Work_Phone__c;
            }//End if for Company record type
            acclink.Retail_Industry__c = accountMap.get(acclink.toRole__c).Industry; 
            acclink.Retail_Website__c = accountMap.get(acclink.toRole__c).website;
            //acclink.Retail_Individual_Home_Phone__c = accountMap.get(acclink.toRole__c).Individual_Home_Phone__c;
            acclink.Retail_Fax__c = accountMap.get(acclink.toRole__c).Fax;
            
            //Checking Null for sales Address 
            if(accountMap.get(acclink.toRole__c).Primary_Address_Reference__c != null){ 
                    acclink.Retail_Address_Type__c = accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Address_Type__c; 
                    acclink.Retail_Province__c = (accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Province__c !=null ?accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Province__c: '' ); 
                    acclink.Retail_City__c = (accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.City__c != null ? accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.City__c:'').left(17);
                    acclink.Retail_Distinct__c = ((accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.District__c!=null ? accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.District__c : '')+(accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Block__c!= null ?accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Block__c : '')).left(17);
                    acclink.Retail_Address_Line_1__c = ((accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Address_Line_1__c)!=null?accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Address_Line_1__c:'').left(17);
                    acclink.Retail_Address_Line_2__c = ((accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Address_Line_2__c)!=null?accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Address_Line_2__c:'').left(17);
                    acclink.Retail_ZipCode__c = (accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.ZipCode__c!=null ? accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.ZipCode__c : '' );
                    acclink.Retail_Address_CreatedDate__c = Date.ValueOf(accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.CreatedDate);
                    acclink.Retail_Address_LastModifiedDate__c = Date.ValueOf(accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.LastModifiedDate);

                }//End if for Sales Address
            }
           //AccountlnkUpdate.add(acclink); //Adding Account link to Lsit  
        }//End of for loop
        
       // if(!AccountlnkUpdate.isEmpty())
         //   update AccountlnkUpdate;
    }//End of Method
//created by:surya varma
//sfdcjp-578
  /*created by :Surya Varma
     Desc:Trigger handler code for sharing account record when after insert and delete event
     Update date:28/12/2016
      
   */  
 
//created by:surya varma
//sfdcjp-578
  /*created by :Surya Varma
     Desc:Trigger handler code for sharing account record when after insert and delete event
     Update date:28/12/2016
      */
     
 
 public static void afterInsertDeleteEvent(List<Account_Link__c>aclnklist)
 {
    list<Account_Link__c>allist=[select id,name,recordtypeId,fromRole__c,toRole__c,fromRole__r.name,fromRole__r.RecordTypeid,toRole__r.RecordTypeid,toRole__r.id from Account_Link__c where id IN :aclnklist];
    set<id>toroleidlist=new set<id>();
    for(Account_Link__c atl:allist)
    {
        toroleidlist.add(atl.toRole__r.id);
    }
    list<SurveyTaker__c>stlist=[select id,account__c,account__r.id from SurveyTaker__c where  account__r.id IN :toroleidlist];
     Map<Id,list<surveytaker__c>> newstmap=new Map<Id,list<surveytaker__c>>();
   for(SurveyTaker__c st: stlist){
        if(!newstmap.containsKey(st.account__c))
                {
                    
                    newstmap.put(st.account__c, new List<SurveyTaker__c>());
                } 
                newstmap.get(st.account__c).add(st);
   
   }
    
    list<Account_Link__c>allist1 = new list<Account_Link__c>();
    list<Account> aclist;
    list<string> aclistnames = new list<string>();
    list<Accountshare> acclist=new list<Accountshare>(); 
    list<SurveyTaker__share> sutlist=new list<SurveyTaker__share>();
  
    Set<id> StAccountIdsSet = new Set<id>();
    Set<id> AccountIdsSet = new Set<id>();
    Set<id> ToAccountIdsSet = new Set<id>();  
    map<string,id> assgroupMap = new map<string,id>();  
    Map<Id,Account_Link__c>  newAccountMap = new Map<Id,Account_Link__c>([select id,name,recordtypeId,fromRole__c ,toRole__c,fromRole__r.name,fromRole__r.RecordTypeid,toRole__r.RecordTypeid,toRole__r.id from Account_Link__c where id IN :aclnklist]);
    Map<Id,SurveyTaker__c> newSMap = new Map<Id,SurveyTaker__c>([select id,account__c from SurveyTaker__c where  account__r.id IN :toroleidlist ]);
    Id rc=Schema.SObjectType.Account_Link__c.getRecordtypeInfosByName().get('Retail Company').getRecordTypeId();
    Id rp=Schema.SObjectType.Account_Link__c.getRecordtypeInfosByName().get('Retail Person').getRecordTypeId();
    Id rpa=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Person Account').getRecordTypeId();
    Id rca=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Company').getRecordTypeId(); 
    Id da=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Dealer').getRecordTypeId(); 
  
    for(Account_Link__c al:allist)
    {
        if((al.recordtypeId==rc)||(al.recordtypeId==rp))
        {
            
            if(al.fromRole__c!=null)
            {
                if(al.fromRole__r.RecordTypeid==da && (al.ToRole__r.RecordTypeid==rpa)||(al.ToRole__r.RecordTypeid==rca))
                {
                    allist1.add(al);
                    aclistnames.add(al.fromRole__r.name);
                    AccountIdsSet.add(al.fromRole__c);
                    ToAccountIdsSet.add(al.toRole__c);
                }
            }
        } 
        
    }
    list<group>glist=[select id ,Name ,Type from Group where Name IN:aclistnames];
    if( aclistnames!=null&& allist1!=null)
    {
        for(Group assg:glist)
        {
               
            assgroupMap.put(assg.Name, assg.id);

        }
    
        for(Account_Link__c alnk: allist1) 
        {
            if(AccountIdsSet.contains(alnk.fromRole__c))
            {
                 
                if(assgroupMap.containskey(alnk.fromRole__r.name))
                {
                 system.debug('Inserting1');
                     Accountshare a=new Accountshare();
                     a.Accountid=alnk.toRole__c;
                     a.UserOrGroupId = assgroupMap.get(alnk.fromRole__r.name);
                     a.AccountAccessLevel='edit';
                     a.RowCause = Schema.Accountshare.RowCause.Manual;
                     a.OpportunityAccessLevel ='edit';
                     acclist.add(a);
                    if(newstmap.containskey(alnk.toRole__c))
                  {
                      for(SurveyTaker__c sa:newstmap.get(alnk.toRole__c))
                      {
                          //checking match with current accountid with accountid in survey taker record
                          system.debug('Inserting2');
                                 SurveyTaker__share surt=new SurveyTaker__share();
                                 surt.ParentId=sa.id;
                                 surt.UserOrGroupId=assgroupMap.get(alnk.fromRole__r.name);
                                 surt.AccessLevel='edit';
                                 surt.RowCause = Schema.SurveyTaker__share.RowCause.Manual;
                                 sutlist.add(surt);
                           
                      }    
                  }
        }
    }
    if(acclist.size()>0)
    {
        insert acclist;
       if(sutlist!=null)
        {
          insert sutlist;
        }
    }
 }
 }
 }
  public static void afterDeleteEvent(List<Account_Link__c>oldlist)
 {
  // list<Account_Link__c>allist=[select id,name,recordtypeId,fromRole__c,toRole__c,fromRole__r.name,fromRole__r.RecordTypeid,toRole__r.RecordTypeid,toRole__r.id from Account_Link__c where id IN :oldlist];
     set<id>toroleidlist=new set<id>();
     set<Id> fromRoleIdList = new set<id>();

     for(Account_Link__c atl:oldlist)
     {
           toroleidlist.add(atl.toRole__c);
           fromRoleIdList.add(atl.fromRole__c);

     }
     list<SurveyTaker__c> stlist=[select id,account__c,account__r.id from SurveyTaker__c where  account__r.id IN :toroleidlist];
     
     Map<Id,list<surveytaker__c>> newstmap=new Map<Id,list<surveytaker__c>>();
   for(SurveyTaker__c st: stlist){
        if(!newstmap.containsKey(st.account__c))
                {
                    
                    newstmap.put(st.account__c, new List<SurveyTaker__c>());
                } 
                newstmap.get(st.account__c).add(st);
   
   }
         
    Map<Id,Account> fromAccountRecordTypeMap = new Map<Id,Account>();
   for(Account acc:[Select id, Name,RecordtypeId From Account Where Id IN:fromRoleIdList]){      
      fromAccountRecordTypeMap.put(acc.id,acc);
   
   }
   
   Map<Id,Account> ToAccountRecordTypeMap = new Map<Id,Account>();
   for(Account acc:[Select id, Name,RecordtypeId From Account Where Id IN:toroleidlist]){      
      ToAccountRecordTypeMap.put(acc.id,acc);
   
   }
   
   list<Account_Link__c>allist1 = new list<Account_Link__c>();
  list<Account> aclist;
  list<string> aclistnames = new list<string>();
  list<Accountshare> acclist=new list<Accountshare>(); 
  list<SurveyTaker__share> sutlist=new list<SurveyTaker__share>();
  
    Set<id> StAccountIdsSet = new Set<id>();
    Set<id> AccountIdsSet = new Set<id>();
  Set<id> ToAccountIdsSet = new Set<id>();  
  map<string,id> assgroupMap = new map<string,id>();  
  Id rc=Schema.SObjectType.Account_Link__c.getRecordtypeInfosByName().get('Retail Company').getRecordTypeId();
  Id rp=Schema.SObjectType.Account_Link__c.getRecordtypeInfosByName().get('Retail Person').getRecordTypeId();
  Id rpa=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Person Account').getRecordTypeId();
  Id rca=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Company').getRecordTypeId(); 
  Id da=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Dealer').getRecordTypeId(); 
  
    for(Account_Link__c al:oldlist)
     {
         if((al.recordtypeId==rc)||(al.recordtypeId==rp))
         {
            
             if(al.fromRole__c!=null)
             {
                 if(fromAccountRecordTypeMap.containskey(al.fromRole__c) && fromAccountRecordTypeMap.get(al.fromRole__c).RecordTypeid== da && ((ToAccountRecordTypeMap.containskey(al.ToRole__c) && ToAccountRecordTypeMap.get(al.ToRole__c).RecordTypeid==rpa)||(ToAccountRecordTypeMap.containskey(al.ToRole__c) && ToAccountRecordTypeMap.get(al.ToRole__c).RecordTypeid==rca)))
                 {
                      allist1.add(al);
                     aclistnames.add(fromAccountRecordTypeMap.get(al.fromRole__c).name);
                     AccountIdsSet.add(al.fromRole__c);
                     ToAccountIdsSet.add(al.toRole__c);
                 }
             }
         } 
        
     }
     list<group>glist=[select id ,Name ,Type from Group where Name IN:aclistnames];
     
     
    if( aclistnames!=null&& allist1!=null)
    {
       for(Group assg:glist)
        {
               
           assgroupMap.put(assg.Name, assg.id);

        }
    
     for(Account_Link__c alnk: allist1) 
     {
          if(AccountIdsSet.contains(alnk.fromRole__c))
          {
                 
              if(fromAccountRecordTypeMap.containskey(alnk.fromRole__c) && assgroupMap.containskey(fromAccountRecordTypeMap.get(alnk.fromRole__c).name))
              {
               system.debug('assgroupMap'+ assgroupMap);
                Accountshare a=new Accountshare();
                a.Accountid=alnk.toRole__c;
                a.UserOrGroupId = assgroupMap.get(fromAccountRecordTypeMap.get(alnk.fromRole__c).name);
                a.AccountAccessLevel='edit';
                a.RowCause = Schema.Accountshare.RowCause.Manual;
                a.OpportunityAccessLevel ='edit';
                acclist.add(a);
                if(newstmap.containskey(alnk.toRole__c))
                  {
                      for(SurveyTaker__c sa:newstmap.get(alnk.toRole__c))
                      {
                          //checking match with current accountid with accountid in survey taker record
                          system.debug('Inserting1');
                                SurveyTaker__share surt=new SurveyTaker__share();
                                 surt.ParentId=sa.id;
                                 surt.UserOrGroupId=assgroupMap.get(FromAccountRecordTypeMap.get(alnk.fromRole__c).name);
                                 surt.AccessLevel='edit';
                                 surt.RowCause = Schema.SurveyTaker__share.RowCause.Manual;
                                sutlist.add(surt);
                             
                      }   
                  }
               } 
    
          }
       }
     }
    if(acclist.size()>0)
    {
        insert acclist;
       if(sutlist!=null)
            {
            insert sutlist;
            }
    }
 }
  public static void updateAccountlinksonPrimaryAddress(List<Account_Link__c> list_AccountLink,Map<id,Account_Link__c> oldMap,boolean isUpdate, boolean isinsert){
     Set<Id> accountId = new Set<Id>();
     List<Account_Link__c> accountList = new List<Account_Link__c>();
     List<Account_Link__c> accountList1 = new List<Account_Link__c>();
     for(Account_Link__c acc :list_AccountLink)
     {
         if(acc.Retail_Address_Reference__c != null && acc.MD__c == label.MarketJP){
                if(isInsert || (isUpdate && acc.Retail_Address_Reference__c != oldMap.get(acc.id).Retail_Address_Reference__c)){
                    accountId.add(acc.Retail_Address_Reference__c);
                }
        } 
    }   
      string regexForNullValue ='null';
            string nullValue ='';                            
            String province;
            Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
            UtilAddressTranslation.gettranslatedvalues('JP');
            accountList = [select id,Retail_Address_Reference__c , Retail_Address_Type__c ,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,
                           Retail_Address_Reference__r.District__c,Retail_Address_Reference__r.Block__c,Retail_Address_Reference__r.Address_Line_1__c,
                            Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Address_Reference__r.Address_Type__c,Retail_Address_Reference__r.City__c,Retail_Address_Reference__r.Address_Line_2__c,
                            Retail_Address_Reference__r.ZipCode__c,Retail_Address_Reference__r.Province__c,Retail_Address_Reference__r.CreatedDate,Retail_Address_Reference__r.LastModifiedDate,
                            Retail_Address_CreatedDate__c,Retail_Address_LastModifiedDate__c from Account_Link__c where Retail_Address_Reference__c IN:accountId];
        if(accountList.size() > 0){
            for(Account_Link__c acc: accountList){            
                acc.Retail_Address_Type__c = acc.Retail_Address_Reference__r.Address_Type__c;                       
                acc.Retail_City__c = acc.Retail_Address_Reference__r.City__c;
                acc.Retail_Distinct__c = acc.Retail_Address_Reference__r.District__c + ' ' + acc.Retail_Address_Reference__r.Block__c ;
                acc.Retail_Address_Line_1__c  = acc.Retail_Address_Reference__r.Address_Line_1__c;
                acc.Retail_Address_Line_2__c =  acc.Retail_Address_Reference__r.Address_Line_2__c;
                acc.Retail_ZipCode__c = acc.Retail_Address_Reference__r.ZipCode__c;
                if(addtrmap1.containsKey(acc.Retail_Address_Reference__r.Province__c) )
                {
                    province = addtrmap1.get(acc.Retail_Address_Reference__r.Province__c);
                }                
                acc.Retail_Province__c = province+ acc.Retail_Address_Reference__r.City__c + acc.Retail_Address_Reference__r.District__c + acc.Retail_Address_Reference__r.Block__c+ acc.Retail_Address_Reference__r.Address_Line_1__c + ' ' + acc.Retail_Address_Reference__r.Address_Line_2__c ;
                acc.Retail_Province__c  =acc.Retail_Province__c.replaceAll(regexForNullValue,nullValue);
                acc.Retail_Address_CreatedDate__c = (acc.Retail_Address_Reference__r.CreatedDate).date();
                acc.Retail_Address_LastModifiedDate__c = (acc.Retail_Address_Reference__r.LastModifiedDate).date();
                    accountList1.add(acc);
            }
        }
        if(!accountList1.isEmpty()||accountList1!=null)
            {
                update accountList1; 
            }
  }
}