/**
** This class is a Helper functionality
**
** Created By:
** Date:
** Modified By :
** Modified date : 27-oct-2015
**/
 
public class AccountLinkHelperKR
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
    
     }
     if(epList.size()>0){
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
        Map<Id, List<Id>> SharingVrsFromAlk = new Map<Id, List<Id>>();
        Map<Id, List<Id>> map_FromAccountIdAndListToAccountId = new Map<Id, List<Id>>();
        Set<Id> set_ToAccountId = new Set<Id>();
        Map<Id, List<Id>> map_DealerAccountIdAndListAccountLinkId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> map_PersonCompanyAccountIdAndListAccountLinkId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> CompanyPersonVehicleLinkALK = new Map<Id, List<Id>>();
        Map<Id, List<Id>> map_FromAccountToListIndividualAccountLinkId = getRelatedIndividualCustomerRecordTypeAccountLink(list_AccountLink);
        Set<Id> VehiclealkId = new Set<Id>();
        Set<Id> VehicleExtaccountId = new Set<Id>();
        Set<Id> contactSetorDealerIdSet = new Set<Id>();
        Set<Id> dealerAccIdSetFromRetailPerson = new Set<Id>();
       
        for(Account_Link__c accountLink : list_AccountLink){
        if(accountLink.Retail_Delete_Flag__c == false){
            if(accountLink.RecordTypeId == AccountLink_ContactSectorRecordTypeId && accountLink.Status__c == 'My Shops' && accountLink.fromRole__c != null){
              if(!map_AccountIdAndListAccountLinkId.containsKey(accountLink.fromRole__c)){
                  map_AccountIdAndListAccountLinkId.put(accountLink.fromRole__c, new List<Id>());
              }
              map_AccountIdAndListAccountLinkId.get(accountLink.fromRole__c).add(accountLink.Id);
              contactSetorDealerIdSet.add(accountLink.fromRole__c);
            }
           
            if(accountLink.RecordTypeId == AccountLink_RetailPersonRecordTypeId || accountLink.RecordTypeId == AccountLink_RetailCompanyRecordTypeId){
                if(accountLink.fromRole__c != null && accountLink.toRole__c != null){
                    set_ToAccountId.add(accountLink.fromRole__c);
                    if(!map_AccountIdAndListAccountLinkId.containsKey(accountLink.toRole__c)){
                        map_AccountIdAndListAccountLinkId.put(accountLink.toRole__c, new List<Id>());
                    }
                    map_AccountIdAndListAccountLinkId.get(accountLink.toRole__c).add(accountLink.Id);
                    
                    map_AccountIdAndListAccountLinkId.putAll(map_FromAccountToListIndividualAccountLinkId);
                   
                    if(!map_AccountIdAndListAccountLinkId.containsKey(accountLink.fromRole__c)){
                        map_AccountIdAndListAccountLinkId.put(accountLink.fromRole__c, new List<Id>());
                    }
                    map_AccountIdAndListAccountLinkId.get(accountLink.fromRole__c).add(accountLink.Id);
                }
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
           
            //Share Account Link with VR's
            if(accountLink.RecordTypeId == AccountLink_RetailPersonRecordTypeId || accountLink.RecordTypeId == AccountLink_RetailCompanyRecordTypeId ){
                                   
                if(accountLink.fromRole__c != null && accountLink.toRole__c!=null){
                    set_ToAccountId.add(accountLink.fromRole__c);
                    dealerAccIdSetFromRetailPerson.add(accountLink.fromRole__c);
                    if(!SharingVrsFromAlk.containsKey(accountLink.toRole__c)){
                        SharingVrsFromAlk.put(accountLink.toRole__c, new List<Id>());
                    }
                    SharingVrsFromAlk.get(accountLink.toRole__c).add(accountLink.Id);
                }
            }
           
            if(accountLink.RecordTypeId == AccountLink_IndividualCustomerRecordTypeId) {
                if(!map_PersonCompanyAccountIdAndListAccountLinkId.containsKey(accountLink.fromRole__c)){
                    map_PersonCompanyAccountIdAndListAccountLinkId.put(accountLink.fromRole__c, new List<Id>());
                }
                map_PersonCompanyAccountIdAndListAccountLinkId.get(accountLink.fromRole__c).add(accountLink.Id);
                map_PersonCompanyAccountIdAndListAccountLinkId.putAll(map_FromAccountToListIndividualAccountLinkId);
            }
           
            if(accountLink.RecordTypeId == AccountLink_CompanyCustomerRecordTypeId || accountLink.RecordTypeId == AccountLink_Contact2ContactRecordTypeId) {
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
           
            //If AccountLink record type person or company or Vehicle external link share records to Dealer User.
            if(accountLink.RecordTypeId == AccountLink_RetailCompanyRecordTypeId || accountLink.RecordTypeId == AccountLink_RetailPersonRecordTypeId ){
                if(accountLink.fromRole__c !=null && accountLink.toRole__c!=null)
                {
                   
                if(!CompanyPersonVehicleLinkALK.containsKey(accountLink.toRole__c)){
                  CompanyPersonVehicleLinkALK.put(accountLink.toRole__c, new List<Id>());
              }
              CompanyPersonVehicleLinkALK.get(accountLink.toRole__c).add(accountLink.Id);
              set_ToAccountId.add(accountLink.fromRole__c);
            }
           
            }
           
            if(accountLink.RecordTypeId == AccountLink_VehicleExternalRecordTypeId) {
                if(accountLink.fromRole__c !=null && accountLink.Vehicle__c != null) {
                    VehicleExtaccountId.add(accountLink.fromRole__c);
                    VehiclealkId.add(accountLink.Vehicle__c);
                   
                    // Added for Vehicle external link sharing
                    if(!map_AccountIdAndListAccountLinkId.containsKey(accountLink.fromRole__c)){
                        map_AccountIdAndListAccountLinkId.put(accountLink.fromRole__c, new List<Id>());
                    }
                    map_AccountIdAndListAccountLinkId.get(accountLink.fromRole__c).add(accountLink.Id);
                    map_AccountIdAndListAccountLinkId.putAll(map_FromAccountToListIndividualAccountLinkId);
                }
            }
        }
        }
       
        // START: Adding Similar GC Code related Account To Map which is sharing already.
        Set<Id> dealerAccIdSet = new Set<Id>();
       for(Id dealerAccId : map_PersonCompanyAccountIdAndListAccountLinkId.keySet()) {
            dealerAccIdSet.add(dealerAccId);
        }
        for(Id dealerAccId : map_AccountIdAndListAccountLinkId.keySet()) {
            dealerAccIdSet.add(dealerAccId);
        }
       
        //system.assert(false, dealerAccIdSet);
        Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = getAllDealerAccountWithSameGCCode(dealerAccIdSet);
        //system.assert(false, map_AccountIdAndListAccountLinkId);
       
        for(Id dealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.keySet()) {
            if(map_PersonCompanyAccountIdAndListAccountLinkId.containsKey(dealerId)) {
                List<Id> accountLinkIdList = map_PersonCompanyAccountIdAndListAccountLinkId.get(dealerId);
                for(Id similarGCCodeDealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.get(dealerId)) {
                    map_PersonCompanyAccountIdAndListAccountLinkId.put(similarGCCodeDealerId, accountLinkIdList);
                }
            }
           
            if(map_AccountIdAndListAccountLinkId.containsKey(dealerId)) {
                List<Id> accountLinkIdList = map_AccountIdAndListAccountLinkId.get(dealerId);
                for(Id similarGCCodeDealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.get(dealerId)) {
                    if(contactSetorDealerIdSet.contains(dealerId)) {
                        map_AccountIdAndListAccountLinkId.put(similarGCCodeDealerId, accountLinkIdList);
                    } else {
                        map_DealerAccountIdAndListAccountLinkId.put(similarGCCodeDealerId, accountLinkIdList);
                    }
                }
                if(!contactSetorDealerIdSet.contains(dealerId)) {
                    map_DealerAccountIdAndListAccountLinkId.put(dealerId, accountLinkIdList);
                    //map_AccountIdAndListAccountLinkId.remove(dealerId);
                }
            }
        }
        //system.assert(false, map_DealerAccountIdAndListAccountLinkId);
       
        // END: Adding Similar GC Code related Account To Map which is sharing already.
        //system.assert(false, map_DealerAccountIdAndListAccountLinkId);
       
        if(VehicleExtaccountId!=null && VehiclealkId!=null)
        {
            ShareehicleALK(VehicleExtaccountId,VehiclealkId);
        }
        if(map_AccountIdAndListAccountLinkId.size() > 0){
             createSharingRecord(map_AccountIdAndListAccountLinkId);
        }
       
        //system.assert(false, SharingVrsFromAlk);
        if(SharingVrsFromAlk.size() > 0){
            dealerIdToSimilarGCCodeDealerAccountIdsMap = getAllDealerAccountWithSameGCCode(dealerAccIdSetFromRetailPerson);
            for(Id dealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.keySet()) {
                if(dealerIdToSimilarGCCodeDealerAccountIdsMap.get(dealerId).size() > 0) {
                    dealerAccIdSetFromRetailPerson.addAll(dealerIdToSimilarGCCodeDealerAccountIdsMap.get(dealerId));
                }
            }
            //system.assert(false, dealerAccIdSetFromRetailPerson + '\n\n' + set_ToAccountId);
            createVehicleRelationship(SharingVrsFromAlk, dealerAccIdSetFromRetailPerson);
            //createVehicleRelationship(SharingVrsFromAlk, set_ToAccountId);
        }
       
        if(map_DealerAccountIdAndListAccountLinkId.size() > 0){
            createDealerSharingRecord(map_DealerAccountIdAndListAccountLinkId);
        }
       
        if(map_PersonCompanyAccountIdAndListAccountLinkId.size() > 0){
            createPCSharingRecord(map_PersonCompanyAccountIdAndListAccountLinkId);
        }
       
        //If Alk record type is person or company or vehicle external share alk records to Dealer user
        if(CompanyPersonVehicleLinkALK.size() > 0){
            SharePersonCompanyVehicleALK(CompanyPersonVehicleLinkALK,set_ToAccountId);
        }
    }
   
    public static Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
   
    // Get all the Dealer Account with Same GC Code -
    private static Map<Id, Set<Id>> getAllDealerAccountWithSameGCCode(Set<Id> dealerAccountIdSet) {
       
        List<Account> dealerAccList = [select Id, Dealer_GC_Code__c from Account where Id =: dealerAccountIdSet AND RecordType.DeveloperName = 'Dealer'];
        Map<String, Id> gcCodeToDealerAccIdMap = new Map<String, Id>();
        Set<Id> accIdSet = new Set<Id>();
        for(Account accRec : dealerAccList) {
            if(String.isNotBlank(accRec.Dealer_GC_Code__c)) {
                gcCodeToDealerAccIdMap.put(accRec.Dealer_GC_Code__c, accRec.Id);
                accIdSet.add(accRec.Id);
            }
        }
        system.debug('gcCodeToDealerAccIdMap \n\n' + gcCodeToDealerAccIdMap + '\n\n' + gcCodeToDealerAccIdMap.keySet());
        Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = new Map<Id, Set<Id>>();
        if(dealerAccList.size() > 0) {
            List<Account> similarGCCodeDealerAccountList = [select Id, Dealer_GC_Code__c from Account where Dealer_GC_Code__c IN: gcCodeToDealerAccIdMap.keySet()
                                                                    AND RecordtypeId =: Dealer_RecordTypeId];
            for(Account accRec : similarGCCodeDealerAccountList) {
                if(!accIdSet.contains(accRec.Id) && accRec.Dealer_GC_Code__c != null) {
                    if(!dealerIdToSimilarGCCodeDealerAccountIdsMap.containsKey(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c))) {
                        dealerIdToSimilarGCCodeDealerAccountIdsMap.put(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c), new Set<Id>());
                    }
                    dealerIdToSimilarGCCodeDealerAccountIdsMap.get(gcCodeToDealerAccIdMap.get(accRec.Dealer_GC_Code__c)).add(accRec.Id);
                }
            }                                                       
        }
        return dealerIdToSimilarGCCodeDealerAccountIdsMap;
    }
   
    // Get all the Account Link records of "Individual Customer External Link" record Type.
    private static Map<Id, List<Id>> getRelatedIndividualCustomerRecordTypeAccountLink(List<Account_Link__c> list_AccountLink) {
        Map<Id, List<Id>> map_FromAccountToListIndividualAccountLinkId = new Map<Id, List<Id>>();
        Set<Id> accIdSet = new Set<Id>();
        for(Account_Link__c accLinkRec : list_AccountLink) {
            accIdSet.add(accLinkRec.toRole__c);
        }
       
        List<Account> accList = [select Id, (select Id, fromRole__c, RecordTypeId, RecordType.DeveloperName from Account_Links__r) from Account where Id IN: accIdSet];
        for(Account accRec : accList) {
            String dealerAccId;        
            for(Account_Link__c accLinkRec : accRec.Account_Links__r) {
                if(accLinkRec.RecordType.DeveloperName == 'Retail_Person' || accLinkRec.RecordType.DeveloperName == 'Retail_Company' ||
                        accLinkRec.RecordType.DeveloperName == 'Vehicle_External_Link') {
                    dealerAccId = accLinkRec.fromRole__c;
                }
            }
           
            for(Account_Link__c accLinkRec : accRec.Account_Links__r) {
                if((accLinkRec.RecordType.DeveloperName == 'IndividualExternalLink' || accLinkRec.RecordType.DeveloperName == 'Contact2Contact'
                    || accLinkRec.RecordType.DeveloperName == 'CompanyExternalLink') && String.isNotBlank(dealerAccId)) {
                    if(!map_FromAccountToListIndividualAccountLinkId.containsKey(dealerAccId)) {
                        map_FromAccountToListIndividualAccountLinkId.put(dealerAccId, new List<Id>());
                    }
                    map_FromAccountToListIndividualAccountLinkId.get(dealerAccId).add(accLinkRec.Id);
                }
            }
        }
       
        return map_FromAccountToListIndividualAccountLinkId;
    }
   
    
    public static void afterUpdateEvent(List<Account_Link__c> list_AccountLink, Map<Id, Account_Link__c> map_AccountLinkIdAndRecord){
       
        Set<Id> set_accountId = new Set<Id>();
        
        List<Id> list_SharingToDelete = new List<Id>();
        Map<Id, List<Id>> map_AccountIdAndListAccountLinkId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> map_PersonCompanyAccountIdAndListAccountLinkId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> map_FromAccountToListIndividualAccountLinkId = getRelatedIndividualCustomerRecordTypeAccountLink(list_AccountLink);
       
        for(Account_Link__c accountLink : list_AccountLink){
        if(accountLink.Retail_Delete_Flag__c == false){
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
           
             // Added for Retail Person - Account Link issue
               if(accountLink.RecordTypeId == AccountLink_RetailCompanyRecordTypeId || accountLink.RecordTypeId == AccountLink_RetailPersonRecordTypeId) {
                if(accountLink.fromRole__c !=null && accountLink.toRole__c != null) {
                    set_accountId.add(map_AccountLinkIdAndRecord.get(accountLink.Id).fromRole__c);
                    list_SharingToDelete.add(accountLink.Id);
                    if(!map_PersonCompanyAccountIdAndListAccountLinkId.containsKey(accountLink.fromRole__c)) {
                        map_PersonCompanyAccountIdAndListAccountLinkId.put(accountLink.fromRole__c, new List<Id>());
                    }
                    map_PersonCompanyAccountIdAndListAccountLinkId.get(accountLink.fromRole__c).add(accountLink.Id);
                   
                    // For Individual
                    for(Id fromAccId : map_FromAccountToListIndividualAccountLinkId.keySet()) {
                        if(!map_PersonCompanyAccountIdAndListAccountLinkId.containsKey(fromAccId)) {
                            map_PersonCompanyAccountIdAndListAccountLinkId.putAll(map_FromAccountToListIndividualAccountLinkId);
                        } else {
                            map_PersonCompanyAccountIdAndListAccountLinkId.get(fromAccId).addAll(map_FromAccountToListIndividualAccountLinkId.get(fromAccId));
                        }
                    }
                    for(Id fromAccId : map_FromAccountToListIndividualAccountLinkId.keySet()) {
                        for(Id accLinkId : map_FromAccountToListIndividualAccountLinkId.get(fromAccId)) {
                            list_SharingToDelete.add(accLinkId);
                        }
                    }
                   
                }
            }
        }
        }
        if(set_accountId.size() > 0){
            List<User> list_User = new List<User>( [SELECT Id, AccountId FROM User WHERE AccountId IN:set_accountId AND IsPortalEnabled = true]);
            List<Account> dealerAccList = [select Name from Account where Id IN: set_accountId];
            Set<String> dealerAccNameSet = new Set<String>();
            for(Account dealerRec : dealerAccList) {
                dealerAccNameSet.add(dealerRec.Name);
            }
            List<Group> groupList = [select Id, Name, Type from Group where Name IN: dealerAccNameSet];
           
            List<Account_Link__Share> list_SharingDele = new List<Account_Link__Share>([SELECT Id FROM Account_Link__Share
                                                                                            WHERE ParentId IN:list_SharingToDelete
                                                                                            AND (UserOrGroupId IN :list_User OR UserOrGroupId IN :groupList)]);
            //system.assert(false, list_SharingDele);
            if(list_SharingDele.size() > 0){
                Database.delete(list_SharingDele, false);
            }
        }
       
        if(map_AccountIdAndListAccountLinkId.size() > 0){
            createSharingRecord(map_AccountIdAndListAccountLinkId);
        }
       
        if(map_PersonCompanyAccountIdAndListAccountLinkId.size() > 0){
            createPCSharingRecord(map_PersonCompanyAccountIdAndListAccountLinkId);
        }
       
        
        
        // Delete Vehicle Related sharing if Retail Person or Retail Company is deleted from button - "Delete Retail Copy"
        Set<Id> toRoleIdSet = new Set<Id>();
        Set<Id> fromRoleIdSet = new Set<Id>();
        for(Account_Link__c accountLink : list_AccountLink){
            if((accountLink.RecordTypeId == AccountLink_RetailCompanyRecordTypeId || accountLink.RecordTypeId == AccountLink_RetailPersonRecordTypeId)
                && accountLink.Retail_Delete_Flag__c && !map_AccountLinkIdAndRecord.get(accountLink.Id).Retail_Delete_Flag__c) {
                toRoleIdSet.add(accountLink.toRole__c);
                fromRoleIdSet.add(accountLink.fromRole__c);
            }
        }
       
        if(fromRoleIdSet.size() > 0 && toRoleIdSet.size() > 0) { 
            Map<Id, Account> fromAccountRecordTypeMap = new Map<Id,Account>();
            Map<Id, Account> toAccountRecordTypeMap = new Map<Id,Account>();
            for(Account acc : [Select Name, RecordTypeId From Account Where Id IN: fromRoleIdSet OR Id IN: toRoleIdSet]) {  
                if(toRoleIdSet.contains(acc.Id)) {
                    toAccountRecordTypeMap.put(acc.Id, acc);
                } else if(fromRoleIdSet.contains(acc.Id)) {
                    fromAccountRecordTypeMap.put(acc.Id, acc);
                }     
            }
            deleteVehicleSharing(toAccountRecordTypeMap, fromAccountRecordTypeMap);
            deleteIndividualSharing(toAccountRecordTypeMap, fromAccountRecordTypeMap);
        }
    }
   
    private static void ShareehicleALK(Set<Id> set_ToAccountId,Set<Id> VehiclealkId)
    {
    List<Account_Link__C> Vehiclelist_AccountLink = new List<Account_Link__C>();
    List<Account_Link__Share> list_SharingRecord = new List<Account_Link__Share>();
    List<User> portaluser=new List<User>();
    if(VehiclealkId !=null && set_ToAccountId!=null)
    {
     Vehiclelist_AccountLink =[SELECT Id,Retail_Delete_Flag__c,recordtypeID,Vehicle__c, toRole__c, fromRole__c  FROM Account_Link__C   WHERE fromRole__c=:set_ToAccountId and recordtypeID=:AccountLink_VehicleExternalRecordTypeId and Vehicle__c=:VehiclealkId] ;
     }
     if(set_ToAccountId!=null)
     {
         portaluser=[SELECT Id, Contact.AccountId FROM User WHERE Contact.AccountId=:set_ToAccountId  AND IsPortalEnabled = true];
           }
     
      if(portaluser!=null)
       {
        for(User usr :portaluser){
           
            if(Vehiclelist_AccountLink!=null)
            {
                 for(Account_Link__c alk:Vehiclelist_AccountLink)
                 {
                 if(alk.recordtypeID ==AccountLink_VehicleExternalRecordTypeId && alk.Retail_Delete_Flag__c == false)
                 {
                    Account_Link__Share accountLinkShare = new Account_Link__Share();
                    accountLinkShare.AccessLevel = 'Edit';
                    accountLinkShare.UserOrGroupId = usr.Id;
                    accountLinkShare.ParentId = alk.id;
                    accountLinkShare.RowCause = Schema.Account_Link__Share.RowCause.Manual;
                    list_SharingRecord.add(accountLinkShare);
                 }
               
             }
             }
        }
        }
        
        
        system.debug('list_SharingRecord@@@@'+list_SharingRecord);
        if(list_SharingRecord.size() > 0){
            Database.insert(list_SharingRecord, false);
        }
    }
    //If Alk record type is person or company or vehicle external share alk records to Dealer user
    private static void SharePersonCompanyVehicleALK(Map<Id, List<Id>> map_AccountIdAndListAccountLinkId,Set<Id> set_ToAccountId){
        List<Account_Link__Share> list_SharingRecord = new List<Account_Link__Share>();
         List<Account_Link__C> list_AccountLink = new List<Account_Link__C>([SELECT Id,Retail_Delete_Flag__c, toRole__c, fromRole__c  FROM Account_Link__C   WHERE toRole__c IN: map_AccountIdAndListAccountLinkId.keySet() and fromRole__c=:set_ToAccountId] );
         //for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]){
           
         List<Group> portaluser = new List<Group>([select Id, Name, Type from Group where Name IN: set_ToAccountId]);
         //List<User> portaluser=new List<User>([SELECT Id, Contact.AccountId FROM User WHERE Contact.AccountId=:set_ToAccountId  AND IsPortalEnabled = true]);
        if(portaluser!=null) {
            for(Group usr :portaluser){
                if(list_AccountLink!=null) {
                    for(Account_Link__c alk:list_AccountLink) {
                        if(alk.Retail_Delete_Flag__c == false){
                            Account_Link__Share accountLinkShare = new Account_Link__Share();
                            accountLinkShare.AccessLevel = 'Edit';
                            accountLinkShare.UserOrGroupId = usr.Id;
                            accountLinkShare.ParentId = alk.id;
                            accountLinkShare.RowCause = Schema.Account_Link__Share.RowCause.Manual;
                            list_SharingRecord.add(accountLinkShare);
                        }
                    }
                }
            }
        }
       
        system.debug('list_SharingRecord@@@@'+list_SharingRecord);
        if(list_SharingRecord.size() > 0){
            Database.insert(list_SharingRecord, false);
        }
    }
   
     
    
    private static void createSharingRecord ( Map<Id, List<Id>> map_AccountIdAndListAccountLinkId) {
       
        // Changing Sharing from User to Public Group
        system.debug('map_AccountIdAndListAccountLinkId :'+map_AccountIdAndListAccountLinkId);
        List<Account> dealerAccList = [select Name,Dealer_ND_Code__c from Account where Id IN: map_AccountIdAndListAccountLinkId.keySet()];
        system.debug('dealerAccList >> 1:'+dealerAccList);
        system.debug('dealerAccList >> 2:'+dealerAccList.size());
        Set<String> dealerAccNameSet = new Set<String>();
       
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        for(Account dealerRec : dealerAccList) {
            dealerAccNameSet.add(dealerRec.Dealer_ND_Code__c);
            accNameToAccIdMap.put(dealerRec.Dealer_ND_Code__c, dealerRec.Id);
        }
        
        List<Account_Link__Share> list_SharingRecord = new List<Account_Link__Share>();
        system.debug('dealerAccNameSet :'+dealerAccNameSet);
        list<Group> gps = [select Id, Name, Type from Group where Name IN: dealerAccNameSet];
        system.debug('gps :'+gps);
        for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]){
            if(accNameToAccIdMap.containsKey(groupRec.Name) && map_AccountIdAndListAccountLinkId.containsKey(accNameToAccIdMap.get(groupRec.Name))){
                for(Id accountLinkId : map_AccountIdAndListAccountLinkId.get(accNameToAccIdMap.get(groupRec.Name))){
                    Account_Link__Share accountLinkShare = new Account_Link__Share();
                    accountLinkShare.AccessLevel = 'Edit'; //Modified access permission from Read to Edit  #SFDCKR-978
                    accountLinkShare.UserOrGroupId = groupRec.Id;
                    accountLinkShare.ParentId = accountLinkId;
                    accountLinkShare.RowCause = Schema.Account_Link__Share.RowCause.Manual;
                    list_SharingRecord.add(accountLinkShare);
                }
            }
        }
        if(list_SharingRecord.size() > 0){
            Database.insert(list_SharingRecord, false);
        }
        
        List<Account> dealerAccList1 = [select Id, Dealer_GC_Code__c from Account where Id in: map_AccountIdAndListAccountLinkId.keySet() AND RecordType.DeveloperName = 'Dealer'];
        system.debug('dealerAccList1  >> :'+dealerAccList1);
        Map<String, Id> gcCodeToDealerAccIdMap = new Map<String, Id>();
        Set<Id> accIdSet = new Set<Id>();
        for(Account accRec : dealerAccList1) {
            if(String.isNotBlank(accRec.Dealer_GC_Code__c)) {
                gcCodeToDealerAccIdMap.put(accRec.Dealer_GC_Code__c, accRec.Id);
                accIdSet.add(accRec.Id);
            }
        }
        system.debug('gcCodeToDealerAccIdMap \n\n' + gcCodeToDealerAccIdMap + '\n\n' + gcCodeToDealerAccIdMap.keySet());
        Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = new Map<Id, Set<Id>>();
        system.debug('dealerAccList1 << :'+dealerAccList1);
        if(dealerAccList1.size() > 0) {
            //List<Account> similarGCCodeDealerAccountList = [select Id,Name, Dealer_GC_Code__c,Dealer_ND_Code__c from Account where Dealer_GC_Code__c IN: gcCodeToDealerAccIdMap.keySet() AND RecordtypeId =: Dealer_RecordTypeId and Dealer_type__c = 'Company'];
            List<Account> similarGCCodeDealerAccountList = [select Id,Name, Dealer_GC_Code__c,Dealer_ND_Code__c from Account where Dealer_GC_Code__c IN: gcCodeToDealerAccIdMap.keySet() AND RecordtypeId =: Dealer_RecordTypeId];// and Dealer_type__c = 'Company'];
           
            system.debug('similarGCCodeDealerAccountList :'+similarGCCodeDealerAccountList);
            Set<String> dealerAccNameSet1 = new Set<String>();
            for(Account dealerRec : similarGCCodeDealerAccountList ) {
                dealerAccNameSet.add(dealerRec.Dealer_ND_Code__c);
            }
            system.debug('dealerAccNameSet :'+dealerAccNameSet);
            List<AccountShare> AccountShareList = new  List<AccountShare>();
            for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]){
                system.debug('groupRec :'+groupRec.Name);
                for(Account dealerRec : dealerAccList) {
                    system.debug('dealerRec :'+dealerRec.Name);
                    AccountShare AccountShareRecord = new AccountShare();
                    AccountShareRecord.AccountId= dealerRec.id;
                    AccountShareRecord.UserOrGroupId= groupRec.Id;
                    AccountShareRecord.AccountAccessLevel= 'Read';
                    AccountShareRecord.OpportunityAccessLevel= 'Edit';   
                    AccountShareRecord.RowCause='Manual';
                    AccountShareList.add(AccountShareRecord);
                }            
            }
            system.debug('AccountShareList :'+AccountShareList);
            if(AccountShareList.size() > 0){
                Database.insert(AccountShareList, false);
            }
        }
    }
   
    
    private static void createPCSharingRecord(Map<Id, List<Id>> map_AccountIdAndListAccountLinkId){
        // Changing Sharing from User to Public Group
        List<Account> dealerAccList = [select Name from Account where Id IN: map_AccountIdAndListAccountLinkId.keySet()];
        Set<String> dealerAccNameSet = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        for(Account dealerRec : dealerAccList) {
            dealerAccNameSet.add(dealerRec.Name);
            accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
        }
       
        List<Account_Link__Share> list_SharingRecord = new List<Account_Link__Share>();
        for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]){
            if(accNameToAccIdMap.containsKey(groupRec.Name) && map_AccountIdAndListAccountLinkId.containsKey(accNameToAccIdMap.get(groupRec.Name))){
                for(Id accountLinkId : map_AccountIdAndListAccountLinkId.get(accNameToAccIdMap.get(groupRec.Name))){
                    Account_Link__Share accountLinkShare = new Account_Link__Share();
                    accountLinkShare.AccessLevel = 'Read';
                    accountLinkShare.UserOrGroupId = groupRec.Id;
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
       
        // Changing Sharing from User to Public Group
        List<Account> dealerAccList = [select Name from Account where Id IN: map_AccountIdAndListAccountLinkId.keySet()];
        Set<String> dealerAccNameSet = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        for(Account dealerRec : dealerAccList) {
            dealerAccNameSet.add(dealerRec.Name);
            accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
        }
       
        List<Account_Link__Share> list_SharingRecord = new List<Account_Link__Share>();
        for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]) {
            if(accNameToAccIdMap.containsKey(groupRec.Name) && map_AccountIdAndListAccountLinkId.containsKey(accNameToAccIdMap.get(groupRec.Name))){
                for(Id accountLinkId : map_AccountIdAndListAccountLinkId.get(accNameToAccIdMap.get(groupRec.Name))){
                    Account_Link__Share accountLinkShare = new Account_Link__Share();
                    accountLinkShare.AccessLevel = 'Edit';
                    accountLinkShare.UserOrGroupId = groupRec.Id;
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
        // Changing Sharing from User to Public Group
        List<Account> dealerAccList = [select Name from Account where Id IN: set_ToAccountId];
        Set<String> dealerAccNameSet = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        for(Account dealerRec : dealerAccList) {
            dealerAccNameSet.add(dealerRec.Name);
            accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
        }
       
        Map<Id, List<Id>> map_AccountIdListUser = new Map<Id, List<Id>>();
        List<Vehicle_Relationship__Share> list_SharingRecord = new List<Vehicle_Relationship__Share>();
		List<Vehicle__Share> list_VehicleSharingRecord = new List<Vehicle__Share>();
       
        List<Vehicle_Relationship__c> list_VehicleRelationRecord = new List<Vehicle_Relationship__c>([SELECT Id, Contact__c, Vehicle_ID__c
                                                                                                        FROM Vehicle_Relationship__c
                                                                                                        WHERE Contact__c IN: map_FromAccountIdAndListToAccountId.keySet()]);
        if(list_VehicleRelationRecord.size() > 0)
		{
            for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet])
			{
                for(Vehicle_Relationship__c vehicleR : list_VehicleRelationRecord)
				{
                    if(map_FromAccountIdAndListToAccountId.containsKey(vehicleR.Contact__c))
					{
                        for(Id toAccId : map_FromAccountIdAndListToAccountId.get(vehicleR.Contact__c))
						{    
							Vehicle_Relationship__Share vehicleRelationShare = new Vehicle_Relationship__Share();
							vehicleRelationShare.AccessLevel = 'Edit';
							vehicleRelationShare.UserOrGroupId = groupRec.id;
							vehicleRelationShare.ParentId = vehicleR.Id;
							vehicleRelationShare.RowCause = Schema.Vehicle_Relationship__Share.RowCause.Manual;
							list_SharingRecord.add(vehicleRelationShare);   

							Vehicle__Share vehicleShare = new Vehicle__Share();
							vehicleShare.AccessLevel = 'Edit';
							vehicleShare.UserOrGroupId = groupRec.id;
							vehicleShare.ParentId = vehicleR.Vehicle_ID__c;
							list_VehicleSharingRecord.add(vehicleShare); 
                             
                        }
                    }
                }
             }
           
            if(list_SharingRecord.size() > 0)
			{
                Database.insert(list_SharingRecord, false);
            }
			if(list_VehicleSharingRecord.size() > 0)
			{
                Database.insert(list_VehicleSharingRecord, false);
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
        Set<String> FromAccountIds = new set<String>();
        string market;
        for(Account_Link__c acc : accLst){
            //if((isInsert || isUpdate) && acc.MD__c == label.MarketJp) //Checking Market for updated account
            if((isInsert || isUpdate) && acc.MD__c == label.MarketKR)
            {
                AccountIds.add(acc.toRole__c); //Adding accountId's to set
                FromAccountIds.add(acc.fromRole__c); 
                System.debug('AccountID--->'+acc.id); 
                market =  acc.MD__c;     
            }
        }
        List<Account_Link__c> Existlist = [Select id,recordtypeid from Account_Link__c where fromRole__c IN:FromAccountIds AND toRole__c IN: AccountIds AND recordtypeid =: AccountLink_contact2conatctRecordTypeId];
        for(Account_Link__c acclink : accLst ){
            if(Existlist.size()>0 && acclink.recordtypeid==AccountLink_contact2conatctRecordTypeId){
            acclink.addError('Account Link record with the same Role1, Role2 and Relation exists.');
            }    
        }
            
        string regexForNullValue ='null';
        string nullValue ='';                           
        String province;
        Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
        UtilAddressTranslation.gettranslatedvalues(market);
        Id RetailPerson = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();//Retriveing record type ID for Retail Person
        Id RetailCompany = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();//Retriveing record type ID for Retail Company
        Map<id,Account> accountMap = new Map<id,Account>([select id,Name,RecordType.Name, LastName, FirstName, Salutation__c, LastName_Native_1__c,PersonMobilePhone,PersonEmail,
                                                    FirstName_Native_1__c, Gender__c, PersonBirthdate, Occupation__c, Industry,MBK_Occupation__c,Allow_Data_Sharing__c,
                                                    Preferred_Language__c, Primary_Phone__c, Special_Care__c, Special_Needs_Class__c,Primary_Phone_Display__c,DMS_Customer_ID__c,Complaint_Amount__c,
                                                    Allow_Data_Sharing2__c, Individual_Home_Phone__c, Work_Phone__c, Mobile__c, Fax,Sales_Sanction__c,Preferred_Contact_Method__c,PersonHasOptedOutOfEmail,
                                                    Email__c,Primary_Address_Reference__r.Address_Type__c, Primary_Address_Reference__r.Province__c,PersonHasOptedOutOfFax,
                                                    Primary_Address_Reference__r.City__c, Primary_Address_Reference__r.District__c, Primary_Address_Reference__r.Block__c,
                                                    Primary_Address_Reference__r.Address_Line_1__c, Primary_Address_Reference__r.Address_Line_2__c, Primary_Address_Reference__r.ZipCode__c,Agreement_to_commit_info_processing__c,
                                                    Company_Name_Native_1__c, Commercial_Reg_No__c, Vat_No__c,PersonDoNotCall,Visit_Opt_Out__c,Job__c,Company_Name__c,Personal_Abroad_Agreement__c,
                                                    Foundation_Date__c, Website, Primary_Address_Reference__r.CreatedDate,UCID__c,Personal_Agreement__c,Personal_Information_Third_Party_Release__c,
                                                    Primary_Address_Reference__r.LastModifiedDate,Postal_Opt_Out__c
                                                    from Account WHERE Id IN :AccountIds]);
        System.debug('Accountlinklist------>'+accountMap);
        //Account link iteration
        for(Account_Link__c acclnk : accLst ){
            if(acclnk.toRole__c != null){
                if(accountMap.get(acclnk.toRole__c).RecordType.Name == 'Person Account') {                 
                    acclnk.Retail_LastName__c = accountMap.get(acclnk.toRole__c).LastName;
                    acclnk.Retail_FirstName__c = accountMap.get(acclnk.toRole__c).FirstName;
                    acclnk.Retail_Full_Name__c = (accountMap.get(acclnk.toRole__c).LastName != null ? accountMap.get(acclnk.toRole__c).LastName :'') + '  ' + (accountMap.get(acclnk.toRole__c).FirstName != null ? accountMap.get(acclnk.toRole__c).FirstName:'').left(25); 
                    acclnk.Retail_Full_Name_Title__c = ((accountMap.get(acclnk.toRole__c).Salutation__c!= null ? accountMap.get(acclnk.toRole__c).Salutation__c: '')+ '  '+(accountMap.get(acclnk.toRole__c).LastName != null ? accountMap.get(acclnk.toRole__c).LastName:'')+ '  ' + (accountMap.get(acclnk.toRole__c).FirstName != null ? accountMap.get(acclnk.toRole__c).FirstName:'')).left(140);
                    acclnk.Retail_LastName_Native__c = accountMap.get(acclnk.toRole__c).LastName_Native_1__c;
                    acclnk.Retail_FirstName_Native__c = accountMap.get(acclnk.toRole__c).FirstName_Native_1__c; 
                    acclnk.Retail_Full_Name_Native__c = ((accountMap.get(acclnk.toRole__c).LastName_Native_1__c!=null ? accountMap.get(acclnk.toRole__c).LastName_Native_1__c : '')+ ' ' +(accountMap.get(acclnk.toRole__c).FirstName_Native_1__c!=null ? accountMap.get(acclnk.toRole__c).FirstName_Native_1__c:'')).left(50);
                    acclnk.Retail_Gender__c = accountMap.get(acclnk.toRole__c).Gender__c;
                    acclnk.Retail_PersonBirthdate__c = accountMap.get(acclnk.toRole__c).PersonBirthdate;
                    acclnk.Retail_Occupation__c = accountMap.get(acclnk.toRole__c).MBK_Occupation__c;                
                    acclnk.Retail_Preferred_Language__c = 'Korean';
                    acclnk.Retail_Industry__c = accountMap.get(acclnk.toRole__c).Industry;                  
                    acclnk.Retail_Special_Care__c = accountMap.get(acclnk.toRole__c).Special_Care__c;
                    acclnk.Retail_Special_Needs_Class__c = accountMap.get(acclnk.toRole__c).Special_Needs_Class__c;
                    acclnk.Retail_Allow_Data_Sharing__c = accountMap.get(acclnk.toRole__c).Allow_Data_Sharing__c;  
                    acclnk.Retail_Individual_Home_Phone__c = accountMap.get(acclnk.toRole__c).Individual_Home_Phone__c;
                    acclnk.Retail_Work_Phone__c = accountMap.get(acclnk.toRole__c).Work_Phone__c;
                    acclnk.Retail_Mobile__c = accountMap.get(acclnk.toRole__c).PersonMobilePhone;   
                    acclnk.Retail_Email__c = accountMap.get(acclnk.toRole__c).PersonEmail;
                    acclnk.Retail_Primary_Phone__c = accountMap.get(acclnk.toRole__c).Primary_Phone_Display__c;
                    acclnk.Retail_DMS_Customer_ID__c    = accountMap.get(acclnk.toRole__c).DMS_Customer_ID__c;
                    acclnk.Retail_Complaint_Amount__c = accountMap.get(acclnk.toRole__c).Complaint_Amount__c;
                    acclnk.Retail_Sales_Sanction__c = accountMap.get(acclnk.toRole__c).Sales_Sanction__c;                
                    acclnk.Retail_Preferred_Contact_Method__c = accountMap.get(acclnk.toRole__c).Preferred_Contact_Method__c;
                    acclnk.Retail_Email_OptOut__c = accountMap.get(acclnk.toRole__c).PersonHasOptedOutOfEmail;
                    acclnk.Retail_Fax_OptOut__c = accountMap.get(acclnk.toRole__c).PersonHasOptedOutOfFax;
                    acclnk.Retail_Phone_OptOut__c = accountMap.get(acclnk.toRole__c).PersonDoNotCall;
                    acclnk.Retail_Visit_OptOut__c = accountMap.get(acclnk.toRole__c).Visit_Opt_Out__c;
                    acclnk.Retail_Position__c = accountMap.get(acclnk.toRole__c).Job__c;
                    acclnk.Retail_WebSite__c = accountMap.get(acclnk.toRole__c).Website;
                   // acclnk.Retail_Company_Name__c = accountMap.get(acclink.toRole__c).Company_Name__c;
                    acclnk.Retail_Postal_OptOut__c= accountMap.get(acclnk.toRole__c).Postal_Opt_Out__c ;
                    acclnk.Retail_UCID__c = accountMap.get(acclnk.toRole__c).UCID__c;
                    acclnk.Retail_Company_Name_Native1__c = accountMap.get(acclnk.toRole__c).Company_Name_Native_1__c; 
                    acclnk.Retail_Commercial_Reg_No__c = accountMap.get(acclnk.toRole__c).Commercial_Reg_No__c; 
                    acclnk.Retail_Company_Phone__c = accountMap.get(acclnk.toRole__c).Individual_Home_Phone__c;
                    acclnk.Retail_Company_Other_Phone__c = accountMap.get(acclnk.toRole__c).Work_Phone__c;
                    acclnk.Retail_Agreement__c = accountMap.get(acclnk.toRole__c).Personal_Agreement__c;
                    acclnk.Retail_Information_Third_Party_Release__c = accountMap.get(acclnk.toRole__c).Personal_Information_Third_Party_Release__c;
                    acclnk.Retail_Abroad_Agreement__c = accountMap.get(acclnk.toRole__c).Personal_Abroad_Agreement__c;
                    acclnk.Retail_Agreement_Info_Processing__c = accountMap.get(acclnk.toRole__c).Agreement_to_commit_info_processing__c;
                    acclnk.Retail_Vat_No__c = accountMap.get(acclnk.toRole__c).Vat_No__c ;
                    acclnk.Retail_Address_CreatedDate__c = Date.ValueOf(accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.CreatedDate);
                    acclnk.Retail_Address_LastModifiedDate__c = Date.valueOf(accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.LastModifiedDate);
                    acclnk.Retail_Fax__c = accountMap.get(acclnk.toRole__c).Fax;
                    //if(retailCompanyupdate != Null && acclnk.RecordTypeId != RetailCompany){                       
                        //acclnk.Retail_Related_Company__c = retailCompanyupdate .id;
                    //}           
                }
                
                //Checking the Company RecordType
                if(accountMap.get(acclnk.toRole__c).RecordType.Name=='Company'){
                    acclnk.Retail_Company_Name__c = accountMap.get(acclnk.toRole__c).Company_Name__c;
                    acclnk.Retail_Company_Name_Native1__c = accountMap.get(acclnk.toRole__c).Company_Name_Native_1__c;
                    acclnk.Retail_Commercial_Reg_No__c = accountMap.get(acclnk.toRole__c).Commercial_Reg_No__c;
                    acclnk.Retail_Vat_No__c = accountMap.get(acclnk.toRole__c).Vat_No__c;
                    acclnk.Retail_Industry__c = accountMap.get(acclnk.toRole__c).Industry; 
                    acclnk.Retail_Website__c = accountMap.get(acclnk.toRole__c).website;
                    acclnk.Retail_Company_Phone__c = accountMap.get(acclnk.toRole__c).Individual_Home_Phone__c;
                    acclnk.Retail_Company_Other_Phone__c = accountMap.get(acclnk.toRole__c).Work_Phone__c;
                    acclnk.Retail_DMS_Customer_ID__c = accountMap.get(acclnk.toRole__c).DMS_Customer_ID__c;      
                    acclnk.Retail_Email_OptOut__c = accountMap.get(acclnk.toRole__c).PersonHasOptedOutOfEmail;
                    acclnk.Retail_Fax_OptOut__c = accountMap.get(acclnk.toRole__c).PersonHasOptedOutOfFax;
                    acclnk.Retail_Primary_Phone__c = accountMap.get(acclnk.toRole__c).Primary_Phone_Display__c;
                    acclnk.Retail_Sales_Sanction__c = accountMap.get(acclnk.toRole__c).Sales_Sanction__c;
                    acclnk.Retail_Phone_OptOut__c = accountMap.get(acclnk.toRole__c).PersonDoNotCall;
                    acclnk.Retail_Visit_OptOut__c = accountMap.get(acclnk.toRole__c).Visit_Opt_Out__c;
                    acclnk.Retail_UCID__c = accountMap.get(acclnk.toRole__c).UCID__c;
                    acclnk.Retail_Agreement__c = accountMap.get(acclnk.toRole__c).Personal_Agreement__c;
                    acclnk.Retail_Information_Third_Party_Release__c = accountMap.get(acclnk.toRole__c).Personal_Information_Third_Party_Release__c;
                    acclnk.Retail_Abroad_Agreement__c = accountMap.get(acclnk.toRole__c).Personal_Abroad_Agreement__c;
                    acclnk.Retail_Agreement_Info_Processing__c = accountMap.get(acclnk.toRole__c).Agreement_to_commit_info_processing__c;
                    acclnk.Retail_Address_CreatedDate__c = Date.ValueOf(accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.CreatedDate);
                    acclnk.Retail_Address_LastModifiedDate__c = Date.valueOf(accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.LastModifiedDate); 
                    acclnk.Retail_Fax__c = accountMap.get(acclnk.toRole__c).Fax;
                    acclnk.Retail_Postal_OptOut__c= accountMap.get(acclnk.toRole__c).Postal_Opt_Out__c ;
                    if(accountMap.get(acclnk.toRole__c).Foundation_Date__c != null)
                    {
                        Integer FoundationDate = accountMap.get(acclnk.toRole__c).Foundation_Date__c.month();
                        if(FoundationDate <= 9){
                            acclnk.Retail_Foundation_Month__c = '0'+String.valueOf(accountMap.get(acclnk.toRole__c).Foundation_Date__c.month())+ String.valueOf(accountMap.get(acclnk.toRole__c).Foundation_Date__c.Year());     
                        }else {                   
                            acclnk.Retail_Foundation_Month__c = String.valueOf(accountMap.get(acclnk.toRole__c).Foundation_Date__c.month())+ String.valueOf(accountMap.get(acclnk.toRole__c).Foundation_Date__c.Year());
                        }
                    }
                }
                //End if for Company record type
               
                //Checking Null for sales Address
                if(accountMap.get(acclnk.toRole__c).Primary_Address_Reference__c != null){
                    System.debug('******AccountlnkUpdate');
                    acclnk.Retail_Address_Type__c = accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.Address_Type__c;
                    if(addtrmap1.containsKey(accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.Province__c) )
                    {
                         province = addtrmap1.get(accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.Province__c);
                    }
                    acclnk.Retail_Province__c = province ; 
                    acclnk.Retail_Province__c  =acclnk.Retail_Province__c.replaceAll(regexForNullValue,nullValue);
                    //acclink.Retail_Province__c = (accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Province__c !=null ?accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Province__c: '' );
                    acclnk.Retail_City__c = (accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.City__c != null ? accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.City__c:'').left(17);
                    acclnk.Retail_Distinct__c = ((accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.District__c!=null ? accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.District__c : '')+(accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.Block__c!= null ?accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.Block__c : '')).left(17);
                    acclnk.Retail_Address_Line_1__c = ((accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.Address_Line_1__c)!=null?accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.Address_Line_1__c:'').left(17);
                    acclnk.Retail_Address_Line_2__c = ((accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.Address_Line_2__c)!=null?accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.Address_Line_2__c:'').left(17);
                    acclnk.Retail_ZipCode__c = (accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.ZipCode__c!=null ? accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.ZipCode__c : '' );
                    acclnk.Retail_Address_CreatedDate__c = Date.ValueOf(accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.CreatedDate);
                    acclnk.Retail_Address_LastModifiedDate__c = Date.ValueOf(accountMap.get(acclnk.toRole__c).Primary_Address_Reference__r.LastModifiedDate);
                }
                AccountlnkUpdate.add(acclnk);
            }             
        }
           
           // if(!AccountlnkUpdate.isEmpty())
           // update AccountlnkUpdate;
    }//End of Method

/****
public static void updateRetailCopy(boolean isUpdate, boolean isinsert,boolean isBefore ,List<Account_Link__c> accLst){
       
        system.debug('------>Method is called');
        Set<String> AccountIds = new set<String>();//Set initialization to add account Id's
        List<Account_Link__c> AccountlnkUpdate = new List<Account_Link__c>();//Account Link Initialization
        Set<String> FromAccountIds = new set<String>();
        string market;
        for(Account_Link__c acc : accLst){
            //if((isInsert || isUpdate) && acc.MD__c == label.MarketJp){ //Checking Market for updated account
            if((isInsert || isUpdate) && (acc.MD__c == label.MarketJp || acc.MD__c == label.MarketKR)){
                AccountIds.add(acc.toRole__c); //Adding accountId's to set
                FromAccountIds.add(acc.fromRole__c); 
                System.debug('AccountID--->'+acc.id); 
                market =  acc.MD__c;     
            }
           
        }
         List<Account_Link__c> Existlist = [Select id,recordtypeid from Account_Link__c where fromRole__c IN:FromAccountIds AND toRole__c IN: AccountIds AND recordtypeid =: AccountLink_contact2conatctRecordTypeId];
        for(Account_Link__c acclink : accLst ){
            if(Existlist.size()>0 && acclink.recordtypeid==AccountLink_contact2conatctRecordTypeId){
            acclink.addError('Account Link record with the same Role1, Role2 and Relation exists.');
           }    
        }
        
          string regexForNullValue ='null';
            string nullValue ='';                           
            String province;
            Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
            UtilAddressTranslation.gettranslatedvalues(market);
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
                                                Foundation_Date__c, Website, Primary_Address_Reference__r.CreatedDate,UCID__c,
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
                acclink.Retail_Full_Name__c = ((accountMap.get(acclink.toRole__c).LastName != null ? accountMap.get(acclink.toRole__c).LastName:'')+ '  ' + (accountMap.get(acclink.toRole__c).FirstName != null ? accountMap.get(acclink.toRole__c).FirstName:'')).left(25);
                acclink.Retail_Full_Name_Title__c = ((accountMap.get(acclink.toRole__c).Salutation__c!= null ? accountMap.get(acclink.toRole__c).Salutation__c: '')+ '  '+(accountMap.get(acclink.toRole__c).LastName != null ? accountMap.get(acclink.toRole__c).LastName:'') + '  '+(accountMap.get(acclink.toRole__c).FirstName != null ? accountMap.get(acclink.toRole__c).FirstName:'')).left(140);
                acclink.Retail_LastName_Native__c = accountMap.get(acclink.toRole__c).LastName_Native_1__c;
                acclink.Retail_FirstName_Native__c = accountMap.get(acclink.toRole__c).FirstName_Native_1__c;
                acclink.Retail_Full_Name_Native__c = ((accountMap.get(acclink.toRole__c).LastName_Native_1__c != null ? accountMap.get(acclink.toRole__c).LastName_Native_1__c:'')+ ' ' +(accountMap.get(acclink.toRole__c).FirstName_Native_1__c != null ? accountMap.get(acclink.toRole__c).FirstName_Native_1__c:'')).left(50);
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
            acclink.Retail_UCID__c = accountMap.get(acclink.toRole__c).UCID__c;
           
            //Checking Null for sales Address
            if(accountMap.get(acclink.toRole__c).Primary_Address_Reference__c != null){
                    acclink.Retail_Address_Type__c = accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Address_Type__c;
                    if(addtrmap1.containsKey(accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Province__c) )
                    {
                         province = addtrmap1.get(accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Province__c);
                    }
                    acclink.Retail_Province__c = province ; 
                    acclink.Retail_Province__c  =acclink.Retail_Province__c.replaceAll(regexForNullValue,nullValue);
                    //acclink.Retail_Province__c = (accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Province__c !=null ?accountMap.get(acclink.toRole__c).Primary_Address_Reference__r.Province__c: '' );
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
    ****************************************/
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
 
 
    list<Account_Link__c>allist=[select id,name,recordtypeId,fromRole__c,toRole__c,fromRole__r.name,fromRole__r.Dealer_GC_Code__c,fromRole__r.RecordTypeid,toRole__r.RecordTypeid,toRole__r.id from Account_Link__c where id IN :aclnklist];
    set<id>toroleidlist=new set<id>();
    set<id>fromroleidlist=new set<id>();
    set<String> GCCode = new set<String>();
    list<String> AccountNAme = new List<String>();
    for(Account_Link__c atl:allist)
    {
        toroleidlist.add(atl.toRole__r.id);
        fromroleidlist.add(atl.fromRole__c);
        GCCode.add(atl.fromRole__r.Dealer_GC_Code__c);
    }
    list<SurveyTaker__c>stlist=[select id,account__c,account__r.id from SurveyTaker__c where  account__r.id IN :toroleidlist];
    list<account> acolist = [select id, Name, RecordTypeId,Dealer_GC_Code__c from Account WHERE Dealer_GC_Code__c IN: GCCode AND RecordTypeid=:Dealer_RecordTypeId];
   
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
     for(Account acc :acolist){
           system.debug('acc.Name'+acc.Name);
           AccountNAme.add(acc.Name);  
       }
    list<group>glist=[select id ,Name ,Type from Group where Name IN:aclistnames OR Name IN:AccountNAme];
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
                  if(AccountNAme.size()>0)
                    {
                    for(id m:assgroupMap.values())
                    {
                 system.debug('Inserting1');
                     Accountshare a=new Accountshare();
                     a.Accountid=alnk.toRole__c;
                     a.UserOrGroupId = m;
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
                                 surt.UserOrGroupId=m;
                                 surt.AccessLevel='edit';
                                 surt.RowCause = Schema.SurveyTaker__share.RowCause.Manual;
                                 sutlist.add(surt);
                          
                      }   
                  }
                  }
                  }
                  else {
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
   
    // Remove Sharing For Vehicle Relationship when Record is deleted
    deleteVehicleSharing(ToAccountRecordTypeMap, fromAccountRecordTypeMap);
    deleteIndividualSharing(toAccountRecordTypeMap, fromAccountRecordTypeMap);
   
 }
    
    // Remove Sharing For Vehicle Relationship when Record is deleted
    private static void deleteVehicleSharing(Map<Id, Account> ToAccountRecordTypeMap, Map<Id, Account> fromAccountRecordTypeMap) {
        Id vehicleRelationRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship').getRecordTypeId();
        Map<Id, Vehicle_Relationship__c> vehicleRelationshipMap = new Map<Id, Vehicle_Relationship__c>([select Id from Vehicle_Relationship__c where Contact__c IN: ToAccountRecordTypeMap.keyset()
                                                                        AND RecordTypeId =: vehicleRelationRecordTypeId]);
       
        
        Set<String> dealerAccNameSet = new Set<String>();
        for(Account dealerRec : fromAccountRecordTypeMap.values()) {
            dealerAccNameSet.add(dealerRec.Name);
        }
        List<Group> groupList = [select Id, Name, Type from Group where Name IN: dealerAccNameSet];
       
        List<Vehicle_Relationship__Share> list_SharingDele = [SELECT Id, ParentId FROM Vehicle_Relationship__Share
                                                                                                WHERE ParentId IN: vehicleRelationshipMap.keySet()
                                                                                                AND UserOrGroupId IN :groupList];
       
        if(list_SharingDele.size() > 0){
            Database.delete(list_SharingDele, false);
        }
    }
   
    
    // Remove Sharing For Individual External Link when dealer Record is deleted
    private static void deleteIndividualSharing(Map<Id, Account> ToAccountRecordTypeMap, Map<Id, Account> fromAccountRecordTypeMap) {
        Id indiLinkRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId();
        Id comapnyExternalLinkRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Company Customer External Link').getRecordTypeId();
        Id c2cRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
        List<Id> validRecordTypeId = new List<Id>{indiLinkRecordTypeId, comapnyExternalLinkRecordTypeId, c2cRecordTypeId};
       
        Map<Id, Account_Link__c> indiAccoutLinkMap = new Map<Id, Account_Link__c>([select Id from Account_Link__c where toRole__c IN: ToAccountRecordTypeMap.keyset()
                                                                        AND RecordTypeId IN: validRecordTypeId]);
       
        
        Set<String> dealerAccNameSet = new Set<String>();
        for(Account dealerRec : fromAccountRecordTypeMap.values()) {
            dealerAccNameSet.add(dealerRec.Name);
        }
        List<Group> groupList = [select Id, Name, Type from Group where Name IN: dealerAccNameSet];
       
        List<Account_Link__Share> list_SharingDele = [SELECT Id, ParentId FROM Account_Link__Share
                                                                            WHERE ParentId IN: indiAccoutLinkMap.keySet()
                                                                            AND UserOrGroupId IN :groupList];
       
        if(list_SharingDele.size() > 0){
            Database.delete(list_SharingDele, false);
        }
    }
   public static void updateAccountlinksonPrimaryAddress(List<Account_Link__c> list_AccountLink,Map<id,Account_Link__c> oldMap,boolean isUpdate, boolean isinsert){
     system.debug('updateAccountlinksonPrimaryAddress :');
     Set<Id> accountId = new Set<Id>();
     List<Account_Link__c> accountList = new List<Account_Link__c>();
     List<Account_Link__c> accountList1 = new List<Account_Link__c>();
     for(Account_Link__c acc :list_AccountLink)
     {
         if(acc.Retail_Address_Reference__c != null && (acc.MD__c == label.MarketJP || acc.MD__c == label.MarketKR)){
                if(isInsert || (isUpdate && acc.Retail_Address_Reference__c != oldMap.get(acc.id).Retail_Address_Reference__c)){
                    accountId.add(acc.Retail_Address_Reference__c);
                }
        }
    } 
     system.debug('accountId >>:'+accountId); 
      string regexForNullValue ='null';
            string nullValue ='';                           
            String province;
            Map<String, String> addtrmap1 = UtilAddressTranslation.addtrmap;
            UtilAddressTranslation.gettranslatedvalues('KR');
            accountList = [select id,Retail_Address_Reference__c , Retail_Address_Type__c ,Retail_Province__c,Retail_City__c,Retail_Distinct__c,Retail_Address_Line_1__c,
                           Retail_Address_Reference__r.District__c,Retail_Address_Reference__r.Block__c,Retail_Address_Reference__r.Address_Line_1__c,
                            Retail_Address_Line_2__c,Retail_ZipCode__c,Retail_Address_Reference__r.Address_Type__c,Retail_Address_Reference__r.City__c,Retail_Address_Reference__r.Address_Line_2__c,
                            Retail_Address_Reference__r.ZipCode__c,Retail_Address_Reference__r.Province__c,Retail_Address_Reference__r.CreatedDate,Retail_Address_Reference__r.LastModifiedDate,
                            Retail_Address_CreatedDate__c,Retail_Address_LastModifiedDate__c from Account_Link__c where Retail_Address_Reference__c IN:accountId];
         system.debug('accountList >>:'+accountList ); 
        if(accountList.size() > 0){
            for(Account_Link__c acc: accountList){           
                acc.Retail_Address_Type__c = acc.Retail_Address_Reference__r.Address_Type__c;                      
                acc.Retail_City__c = (acc.Retail_Address_Reference__r.City__c != null ? acc.Retail_Address_Reference__r.City__c : '').left(17);
                acc.Retail_Distinct__c = ((acc.Retail_Address_Reference__r.District__c !=null ? acc.Retail_Address_Reference__r.District__c : '')+ (acc.Retail_Address_Reference__r.Block__c!=null ? acc.Retail_Address_Reference__r.Block__c : '')).left(17);              
                acc.Retail_Address_Line_1__c  = (acc.Retail_Address_Reference__r.Address_Line_1__c !=null? acc.Retail_Address_Reference__r.Address_Line_1__c :'').left(17);
                acc.Retail_Address_Line_2__c =  (acc.Retail_Address_Reference__r.Address_Line_2__c !=null? acc.Retail_Address_Reference__r.Address_Line_2__c :'').left(17);
                acc.Retail_ZipCode__c = acc.Retail_Address_Reference__r.ZipCode__c;
                if(addtrmap1.containsKey(acc.Retail_Address_Reference__r.Province__c) )
                {
                    province = addtrmap1.get(acc.Retail_Address_Reference__r.Province__c);
                }               
                acc.Retail_Province__c = province ;//+ acc.Retail_Address_Reference__r.City__c + acc.Retail_Address_Reference__r.District__c + acc.Retail_Address_Reference__r.Block__c+ acc.Retail_Address_Reference__r.Address_Line_1__c + ' ' + acc.Retail_Address_Reference__r.Address_Line_2__c ;
                //acc.Retail_Province__c  =acc.Retail_Province__c.replaceAll(regexForNullValue,nullValue);
               // acc.Retail_Address_CreatedDate__c = DAY_ONLY(convertTimezone((acc.Retail_Address_Reference__r.CreatedDate)));
                system.debug('>>>>>>>> :'+Date.newInstance(acc.Retail_Address_Reference__r.CreatedDate.year(),acc.Retail_Address_Reference__r.CreatedDate.month(),acc.Retail_Address_Reference__r.CreatedDate.day()));
                acc.Retail_Address_CreatedDate__c = Date.newInstance(acc.Retail_Address_Reference__r.CreatedDate.year(),acc.Retail_Address_Reference__r.CreatedDate.month(),acc.Retail_Address_Reference__r.CreatedDate.day());
                acc.Retail_Address_LastModifiedDate__c = Date.ValueOf((acc.Retail_Address_Reference__r.LastModifiedDate));
                accountList1.add(acc);
            }
        }
        system.debug('accountList1>>:'+accountList1); 
        if(!accountList1.isEmpty()||accountList1!=null)
            {
                update accountList1;
            }
  }
 
  /*
    LastModifiedDate : 3rd Mar, 2017
    LastModifedBY    : Lokesh M
    JIRA No          : SFDCJP-1893
    Method           : updateRetailCopyfromC2C
    Event            : Before Update
  */
  public static void updateRetailCopyfromC2C(boolean isUpdate,boolean isBefore , boolean isInsert ,List<Account_Link__c> accLst){
        Map<Id,Account_Link__c> updateMap = new Map<Id,Account_Link__C>();
        Set<Id> comId = new Set<Id>();
        Set<Id> perAccIdSet = new Set<Id>();
        Set<Id> comAccIdSet = new Set<Id>();
        Map<Id,Id> retComAccLinkMap = new Map<Id,Id>();
        if((isInsert || isUpdate) && isBefore){
            for(Account_Link__c accLink : accLst){
                if(accLink.RecordtypeId == AccountLink_RetailPersonRecordTypeId && accLink.Retail_Related_Company__c != NULL && accLink.MD__c == label.MarketKR){
                    comId.add(accLInk.Retail_Related_Company__c);
                    perAccIdSet.add(accLink.toRole__c);
                    updateMap.put(accLink.Retail_Related_Company__c,accLink);
                }
            }
            List<Account_Link__c> accLinkList = [SELECT Id,Position__c,fromRole__c,toRole__c FROM Account_Link__c WHERE ID IN: comId AND RecordTypeId =: AccountLink_RetailCompanyRecordTypeId];
            if(accLinkList != NULL && !accLinkList.isEmpty()){
                for(Account_Link__c accl : accLinkList){
                    comAccIdSet.add(accl.toRole__c);
                    retComAccLinkMap.put(accl.toRole__c,accl.Id);     
                }
            }
            List<Account_Link__c> accLinkConToCon = [SELECT Id,Position__c,fromRole__c,toRole__C  FROM Account_Link__c WHERE (fromRole__c IN: perAccIdSet AND toRole__c IN: comAccIdSet) OR (fromRole__c IN: comAccIdSet AND toRole__c IN: perAccIdSet)];
            if(accLinkConToCon != NULL && !accLinkConToCon.isEmpty()){
                for(Account_Link__c acLink : accLinkConToCon){
                    if(!String.isBlank(acLink.Position__c)){
                        if(retComAccLinkMap.get(acLInk.toRole__c) != NULL)
                        updateMap.get(retComAccLinkMap.get(acLInk.toRole__c)).Retail_Position__c = acLink.Position__c;
                        else if(retComAccLinkMap.get(acLInk.fromRole__c) != NULL)
                        updateMap.get(retComAccLinkMap.get(acLInk.fromRole__c)).Retail_Position__c = acLink.Position__c;
                    }
                }   
            }
        }       
    }
	
	/******************************************
    createdDate : 27 Apr, 2017
    createdBy   : Lokesh M
    JIRA No     : SFDCKR-992
    Method      : updateRetailPositionfromC2C
    Event       : Before Update, before insert
    *******************************************/  
    public static void updateRetailPositionfromC2C(boolean isUpdate,boolean isAfter , boolean isInsert ,List<Account_Link__c> accLst){
         system.debug('>>>>>>>>>>>>>>>>>>>'+accLst.size());
         system.debug('>>>>>>>>>>>>>>>>>>>label.MarketKR'+label.MarketKR);
         
        Map<Id,String> accLinkPosMap = new Map<Id,String>();
        list<account_link__c> updateList = new List<Account_link__c>();
        if((isInsert || isUpdate) && isAfter ){
        system.debug('>>>>>>>>>>>>>>>>>>>');
            for(Account_Link__c accLink : accLst){
                 system.debug('>>>>>>>>>>>>>>>>accLink.position '+String.isBlank(accLink.Position__c) );
                 system.debug('>>>>>>>>>>>>>>>>accLink.MD__c '+accLink.MD__c );
                if(accLink.RecordtypeId == AccountLink_Contact2ContactRecordTypeId && !String.isBlank(accLink.Position__c) && accLink.MD__c == label.MarketKR){
                    system.debug('acclinkposition'+accLink.toRole__r.name+'  '+accLink.position__c);
                    system.debug('acclinkposition'+accLink.fromRole__r.name+'  '+accLink.position__c);
                    accLinkPosMap.put(accLink.toRole__c,accLink.position__c);
                    accLinkPosMap.put(accLink.fromRole__c,accLink.Position__c);
                }
            }
            if(accLinkPosMap.size()>0){
                List<Account_Link__c> retailCopyAccLinks = [SELECT Id,Position__C,fromRole__c,toRole__c FROM Account_Link__c WHERE toRole__c IN: accLinkPosMap.keySet() AND (recordTypeId =: AccountLink_RetailPersonRecordTypeId OR recordTypeId =: AccountLink_RetailCompanyRecordTypeId)];
                System.debug('retailCopyAccLinks'+retailCopyAccLinks);
                if(retailCopyAccLinks != NULL && !retailCopyAccLinks.isEmpty()){
                    for(Account_Link__c eachAccLink : retailCopyAccLinks){
                    System.debug('>>>>>>>'+eachAccLink.Id);
                    System.debug('>>>>>>>'+accLinkPosMap.get(eachAccLink.toRole__c));
                        eachAccLink.Retail_Position__c = accLinkPosMap.get(eachAccLink.toRole__c);
                        updateList.add(eachAccLink);
                        System.debug('>>>>>>>'+eachAccLink.Retail_Position__c);
                    }
                }
            }  
            if(updateList.size()>0){
                Database.SaveResult[] srList = Database.update(updateList, false);
                for (Database.SaveResult sr : srList) {
                    if (sr.isSuccess()) {
                        System.debug('Successfully inserted account. AccountLink ID: ' + sr.getId());
                    }
                    else {
                        for(Database.Error err : sr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Account fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            }              
        } 
    }
}