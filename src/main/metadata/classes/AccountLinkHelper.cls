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
    public static Id DealerAccid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public Account_Link__c oldals {set;get;}
/** 
* @Description  This method is for parsing crmCode
* @author  
* @Date (mm/dd/yy)
* @param  Maps the crm code of a retail task record to dealers using the crm code.
* @return returns crm codes
* @see   AccountLinkSharingWrapService, UserService, VehicleSharingWrapService
*/   
    static User Integrationusr = [Select Id,ProfileId,Profile.Name from User WHERE ID = : UserInfo.getUserId()];
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
    public static void ExportNotification (List<Account_Link__c> accountLinkList,Map<id,Account_Link__c> oldals) 
    {
        List<Account_Link__c> acclinkList = new List<Account_Link__c>();
        set<id> acclknkIds = new set<id>();
        List<EP_Export_Notification__c> epList = New list<EP_Export_Notification__c>();
        List<EP_Export_Notification__c> existingEpList = new List<EP_Export_Notification__c>();
		//SN2018- define DealerAccList to check for non Yansee dealer
        Map<ID,Account> DealerAccList = new Map<Id,Account>();
        for(Account_Link__c als : accountLinkList){
            if(als.RecordTypeId == AccountLink_RetailPersonRecordTypeId || als.RecordTypeId == AccountLink_RetailCompanyRecordTypeId && string.isnotblank(als.fromRole__c))
            DealerAccList.put(als.fromRole__c,new account());
        } 
         if(DealerAccList.size()>0){
            DealerAccList.putall([select id,MD__c,Dealer_GC_Code__c from Account where id in: DealerAccList.keyset()]);
         }    
        for(Account_Link__c als : accountLinkList)
        {
            if ( (als.Retail_DMS_Customer_ID__c != null && als.RecordTypeId == AccountLink_RetailPersonRecordTypeId) || (als.Retail_DMS_Customer_ID__c != null && als.RecordTypeId == AccountLink_RetailCompanyRecordTypeId) 
                && (als.Retail_Gender__c!= oldals.get(als.Id).Retail_Gender__c || als.Retail_UCID__c!= oldals.get(als.Id).Retail_UCID__c || 
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
                    als.Retail_Position__c  !=  oldals.get(als.Id).Retail_Position__c))
            {
				//SN20180531- updated to check for non Yansee dealer   
                System.debug('@@@'+Label.NonALEPNotification+'@@@'+als.Retail_Dealer_CompanyCode__c);                 
                //if(DealerAccList.size()>0 &&  !Label.NonALEPNotification.contains(DealerAccList.get(als.fromRole__c).Dealer_GC_code__c))  
                if(DealerAccList.size()>0 && string.isnotblank(DealerAccList.get(als.fromRole__c).Dealer_GC_code__c) &&!Label.NonALEPNotification.contains(DealerAccList.get(als.fromRole__c).Dealer_GC_code__c))                                                                                                                                              
                acclknkIds.add(als.Id);
            }
        }
        system.debug('acclknkIds>>><>' + acclknkIds);
        if(!acclknkIds.isEmpty() && acclknkIds != null)
        {	//SN20180602-- updated to check for non Yansee dealer			
            acclinkList = [select id,MD__c,Retail_Dealer_CompanyCode__c from Account_Link__c where id =:acclknkIds AND fromrole__r.Dealer_Rollout_Status__c = 'Done'];
            existingEpList = [select id,Status__c,SFDC_object_id__c from EP_Export_Notification__c where SFDC_object_id__c =:acclknkIds AND Status__c = 'New'];
        }
        system.debug('acclinkList>>><>' + acclknkIds);
        system.debug('existingEpList>>><>' + existingEpList);
        if(!acclinkList.isEmpty() && acclinkList != null)
        {
            for(Account_Link__c acnkl : acclinkList)
            {
                if(existingEpList.isEmpty() && existingEpList != null)
                {
                    EP_Export_Notification__c epe = New EP_Export_Notification__c();
                    epe.Status__c = 'New';
                    epe.Usecase__c = 'AL.CustomerUpdate';
                    epe.MD__c = acnkl.MD__c;
                    epe.Type__c = 'Account_Link__c';
                    epe.SFDC_object_id__c = acnkl.id;
					//SN20180602- updated to check for non Yansee dealer			
					if(!label.NonALEPNotification.contains(acnkl.Retail_Dealer_CompanyCode__c))																		   
                    epList.add(epe);
                }
            }
        }
        system.debug('epList><><><>' + epList);
        if(epList.size()>0)
        {
            insert epList;
        }
    }
      /*
        * Added By: Siva Krishna
        * Desc: trigger hanler code for sharing record creation for after insert and after update event
        * Updated: Dec 30, 2016
        */
      
      
    public static void afterInsertEvent(List<Account_Link__c> list_AccountLink){
        // if(leadUtil.SharingReuleissue == true){ // commented as part of SFDCJP-2542
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
                    map_AccountIdAndListAccountLinkId.remove(dealerId);
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
        //}
        //LeadUtil.SharingReuleissue = false;
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
   @TestVisible private static Map<Id, List<Id>> getRelatedIndividualCustomerRecordTypeAccountLink(List<Account_Link__c> list_AccountLink) {
        Map<Id, List<Id>> map_FromAccountToListIndividualAccountLinkId = new Map<Id, List<Id>>();
        Set<Id> accIdSet = new Set<Id>();
        for(Account_Link__c accLinkRec : list_AccountLink) {
            accIdSet.add(accLinkRec.toRole__c);
            
        }
       
        
        List<Account> accList = [select Id, (select Id, fromRole__c, RecordTypeId, RecordType.DeveloperName from Account_Links__r) from Account where Id IN: accIdSet ];
        
        if(accIdSet.size() >0 && !accIdSet.isEmpty()){ 
        //List<Account> accList = [select Id from Account where Id IN: accIdSet  LIMIT 5000];
        //List<Account_Link__c> accLink = [select Id, fromRole__c, RecordTypeId, RecordType.DeveloperName from Account_Link__c Where fromRole__c IN: accIdSet   LIMIT 5000];
        
        
        for(Account accRec : accList) {
            String dealerAccId;         
            for(Account_Link__c accLinkRec : accRec.Account_Links__r  ) {
                if(accLinkRec.RecordType.DeveloperName == 'Retail_Person' || accLinkRec.RecordType.DeveloperName == 'Retail_Company' ||
                        accLinkRec.RecordType.DeveloperName == 'Vehicle_External_Link') {
                    dealerAccId = accLinkRec.fromRole__c;
                } 
            }
            
            for(Account_Link__c accLinkRec : accRec.Account_Links__r  ) {
                if((accLinkRec.RecordType.DeveloperName == 'IndividualExternalLink' || accLinkRec.RecordType.DeveloperName == 'Contact2Contact' 
                    || accLinkRec.RecordType.DeveloperName == 'CompanyExternalLink') && String.isNotBlank(dealerAccId)) {
                    if(!map_FromAccountToListIndividualAccountLinkId.containsKey(dealerAccId)) {
                        map_FromAccountToListIndividualAccountLinkId.put(dealerAccId, new List<Id>());
                    }
                    map_FromAccountToListIndividualAccountLinkId.get(dealerAccId).add(accLinkRec.Id);
                } 
            }
        }
        }
        
        return map_FromAccountToListIndividualAccountLinkId;
    }
    public static void afterUpdateEvent(List<Account_Link__c> list_AccountLink, Map<Id, Account_Link__c> map_AccountLinkIdAndRecord)
    {
        
        Set<Id> set_accountId = new Set<Id>();
        Set<Id> oldAccId = new set<id>();
        Set<Id> dealerAccIdSetFromRetailPerson = new Set<Id>();
        List<Id> list_SharingToDelete = new List<Id>();
        Map<Id, List<Id>> map_AccountIdAndListAccountLinkId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> map_PersonCompanyAccountIdAndListAccountLinkId = new Map<Id, List<Id>>();
        Map<Id, List<Id>> map_FromAccountToListIndividualAccountLinkId = getRelatedIndividualCustomerRecordTypeAccountLink(list_AccountLink);
         Map<Id, List<Id>> SharingVrsFromAlk = new Map<Id, List<Id>>();
        for(Account_Link__c accountLink : list_AccountLink)
        {
            if(accountLink.Retail_Delete_Flag__c == false)
            {
                if(accountLink.RecordTypeId == AccountLink_ContactSectorRecordTypeId && accountLink.Status__c == 'My Shops' &&
                   accountLink.fromRole__c != null && (accountLink.fromRole__c != map_AccountLinkIdAndRecord.get(accountLink.Id).fromRole__c || 
                                                       accountLink.Status__c != map_AccountLinkIdAndRecord.get(accountLink.Id).Status__c))
                {
                    
                    set_accountId.add(map_AccountLinkIdAndRecord.get(accountLink.Id).fromRole__c);
                    list_SharingToDelete.add(accountLink.Id);
                    
                    if(!map_AccountIdAndListAccountLinkId.containsKey(accountLink.fromRole__c))
                    {
                        map_AccountIdAndListAccountLinkId.put(accountLink.fromRole__c, new List<Id>());
                    }
                    map_AccountIdAndListAccountLinkId.get(accountLink.fromRole__c).add(accountLink.Id);
                }
                  if(Integrationusr.Profile.name == 'IntegrationApi' && accountLink.toRole__c != map_AccountLinkIdAndRecord.get(accountLink.id).toRole__c && accountLink.RecordTypeId == AccountLink_RetailPersonRecordTypeId || accountLink.RecordTypeId == AccountLink_RetailCompanyRecordTypeId)
                { 
              
                        if(accountLink.fromRole__c != null && accountLink.toRole__c!=null){
                            set_accountId.add(accountLink.fromRole__c);
                            dealerAccIdSetFromRetailPerson.add(accountLink.fromRole__c);
                            if(!SharingVrsFromAlk.containsKey(accountLink.toRole__c)){
                                SharingVrsFromAlk.put(accountLink.toRole__c, new List<Id>());
                            }
                            SharingVrsFromAlk.get(accountLink.toRole__c).add(accountLink.Id);
                           
                        }
                }
                
                if(accountLink.RecordTypeId == AccountLink_ContactSectorRecordTypeId && 
                   accountLink.Status__c != 'My Shops' && map_AccountLinkIdAndRecord.get(accountLink.Id).Status__c == 'My Shops')
                {
                    set_accountId.add(map_AccountLinkIdAndRecord.get(accountLink.Id).fromRole__c);
                    list_SharingToDelete.add(accountLink.Id);
                }
                
                if(accountLink.RecordTypeId != AccountLink_ContactSectorRecordTypeId && 
                   map_AccountLinkIdAndRecord.get(accountLink.Id).RecordTypeId == AccountLink_ContactSectorRecordTypeId)
                {
                    set_accountId.add(accountLink.fromRole__c);
                    list_SharingToDelete.add(accountLink.Id);
                }
                
                if((accountLink.RecordTypeId != AccountLink_CompanyCustomerRecordTypeId && map_AccountLinkIdAndRecord.get(accountLink.Id).RecordTypeId == AccountLink_CompanyCustomerRecordTypeId)
                   || (accountLink.RecordTypeId != AccountLink_Contact2ContactRecordTypeId && map_AccountLinkIdAndRecord.get(accountLink.Id).RecordTypeId == AccountLink_Contact2ContactRecordTypeId)
                   || (map_AccountLinkIdAndRecord.get(accountLink.Id).RecordTypeId == AccountLink_IndividualCustomerRecordTypeId && accountLink.RecordTypeId != AccountLink_IndividualCustomerRecordTypeId))
                {
                    
                    set_accountId.add(accountLink.fromRole__c);
                    list_SharingToDelete.add(accountLink.Id);
                }
                
                if(accountLink.fromRole__c != null && (accountLink.RecordTypeId == AccountLink_CompanyCustomerRecordTypeId || accountLink.RecordTypeId == AccountLink_Contact2ContactRecordTypeId
                                                       || accountLink.RecordTypeId == AccountLink_IndividualCustomerRecordTypeId) && accountLink.fromRole__c != map_AccountLinkIdAndRecord.get(accountLink.Id).fromRole__c)
                {
                    
                    set_accountId.add(map_AccountLinkIdAndRecord.get(accountLink.Id).fromRole__c);
                    list_SharingToDelete.add(accountLink.Id);
                    if(!map_PersonCompanyAccountIdAndListAccountLinkId.containsKey(accountLink.fromRole__c))
                    {
                        map_PersonCompanyAccountIdAndListAccountLinkId.put(accountLink.fromRole__c, new List<Id>());
                    }
                    map_PersonCompanyAccountIdAndListAccountLinkId.get(accountLink.fromRole__c).add(accountLink.Id);
                }
                
                if(accountLink.toRole__c != null && accountLink.RecordTypeId == AccountLink_Contact2ContactRecordTypeId
                   && accountLink.toRole__c != map_AccountLinkIdAndRecord.get(accountLink.Id).toRole__c)
                {
                    
                    set_accountId.add(map_AccountLinkIdAndRecord.get(accountLink.Id).toRole__c);
                    list_SharingToDelete.add(accountLink.Id);
                    if(!map_AccountIdAndListAccountLinkId.containsKey(accountLink.toRole__c))
                    {
                        map_AccountIdAndListAccountLinkId.put(accountLink.toRole__c, new List<Id>());
                    }
                    map_AccountIdAndListAccountLinkId.get(accountLink.toRole__c).add(accountLink.Id);
                }
                
                // Added for Retail Person - Account Link issue
                if(accountLink.RecordTypeId == AccountLink_RetailCompanyRecordTypeId || accountLink.RecordTypeId == AccountLink_RetailPersonRecordTypeId) 
                {
                    if(accountLink.fromRole__c !=null && accountLink.toRole__c != null &&(accountLink.fromRole__c != map_AccountLinkIdAndRecord.get(accountLink.Id).fromRole__c || accountLink.torole__c != map_AccountLinkIdAndRecord.get(accountLink.Id).torole__c))
                    {
                        set_accountId.add(map_AccountLinkIdAndRecord.get(accountLink.Id).fromRole__c);
                        list_SharingToDelete.add(accountLink.Id);
                        oldAccId.add(map_AccountLinkIdAndRecord.get(accountLink.Id).torole__c);
                        
                        if(!map_PersonCompanyAccountIdAndListAccountLinkId.containsKey(accountLink.fromRole__c)) 
                        {
                            map_PersonCompanyAccountIdAndListAccountLinkId.put(accountLink.fromRole__c, new List<Id>());
                        }
                        map_PersonCompanyAccountIdAndListAccountLinkId.get(accountLink.fromRole__c).add(accountLink.Id);
                        
                        // For Individual
                        for(Id fromAccId : map_FromAccountToListIndividualAccountLinkId.keySet()) 
                        {
                            if(!map_PersonCompanyAccountIdAndListAccountLinkId.containsKey(fromAccId)) 
                            {
                                map_PersonCompanyAccountIdAndListAccountLinkId.putAll(map_FromAccountToListIndividualAccountLinkId);
                            } 
                            else 
                            {
                                map_PersonCompanyAccountIdAndListAccountLinkId.get(fromAccId).addAll(map_FromAccountToListIndividualAccountLinkId.get(fromAccId));
                            }
                        }
                        for(Id fromAccId : map_FromAccountToListIndividualAccountLinkId.keySet()) 
                        {
                            for(Id accLinkId : map_FromAccountToListIndividualAccountLinkId.get(fromAccId)) 
                            {
                                list_SharingToDelete.add(accLinkId);
                            }
                        }
                        
                    }
                }
            }
        }
        system.debug('oldAccId>>>' + oldAccId);
        system.debug('set_accountId>>>' + set_accountId);
        if(SharingVrsFromAlk.size() > 0){
           
          Map<Id, Set<Id>> dealerIdToSimilarGCCodeDealerAccountIdsMap = getAllDealerAccountWithSameGCCode(dealerAccIdSetFromRetailPerson);
            for(Id dealerId : dealerIdToSimilarGCCodeDealerAccountIdsMap.keySet()) {
                
                if(dealerIdToSimilarGCCodeDealerAccountIdsMap.get(dealerId).size() > 0) {
                    dealerAccIdSetFromRetailPerson.addAll(dealerIdToSimilarGCCodeDealerAccountIdsMap.get(dealerId));
                }
            }
            
            //system.assert(false, dealerAccIdSetFromRetailPerson + '\n\n' + set_ToAccountId);
            System.debug('daissize'+dealerAccIdSetFromRetailPerson.size());
             System.debug('daissize'+dealerAccIdSetFromRetailPerson);
            createVehicleRelationship(SharingVrsFromAlk, dealerAccIdSetFromRetailPerson);
            //createVehicleRelationship(SharingVrsFromAlk, set_ToAccountId);
        }
        if(set_accountId.size() > 0 || oldAccId.size() > 0)
        {
            List<User> list_User = new List<User>( [SELECT Id, AccountId FROM User WHERE AccountId IN:set_accountId AND IsPortalEnabled = true]);
            List<Account> dealerAccList = [select Name,MD__c,Dealer_GC_Code__c from Account where Id IN: set_accountId];
            Set<String> dealerAccNameSet = new Set<String>();
            for(Account dealerRec : dealerAccList) 
            {    //SN20180601- Added condition for checking GC Code if yes remove both GC code group and dealerName group
                if(string.isnotblank(dealerRec.Dealer_GC_Code__c)? Label.JPALSharingGCCode.contains(dealerRec.Dealer_GC_Code__c):false)
                    dealerAccNameSet.add(dealerRec.MD__c+dealerRec.Dealer_GC_Code__c);
                dealerAccNameSet.add(dealerRec.Name);
            }
         
            List<Group> groupList = [select Id, Name, Type from Group where Name IN: dealerAccNameSet];
            
            List<Account_Link__Share> list_SharingDele = new List<Account_Link__Share>([SELECT Id FROM Account_Link__Share 
                                                                                        WHERE ParentId IN:list_SharingToDelete 
                                                                                        AND (UserOrGroupId IN :list_User OR UserOrGroupId IN :groupList)]);
            List<AccountShare> oldAccShareList = new List<AccountShare>();
            oldAccShareList = [select Id from AccountShare Where AccountId =:oldAccId AND UserOrGroupId IN :groupList];
            
            
            //system.assert(false, list_SharingDele);
            if(list_SharingDele.size() > 0)
            {
                Database.delete(list_SharingDele, false);
            }
            
            if(oldAccShareList.size() > 0)
            {
                Database.delete(oldAccShareList, false);
            }
        }
        
        if(map_AccountIdAndListAccountLinkId.size() > 0)
        {
            createSharingRecord(map_AccountIdAndListAccountLinkId);
        }
        
        if(map_PersonCompanyAccountIdAndListAccountLinkId.size() > 0)
        {
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
            for(Account acc : [Select Name, RecordTypeId,md__c,Dealer_GC_Code__c From Account Where Id IN: fromRoleIdSet OR Id IN: toRoleIdSet]) {   
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
        set<Account_Link__Share> set_SharingRecord = new set<Account_Link__Share>();
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
                            set_SharingRecord.add(accountLinkShare);
                        }
                        
                    }
                }
            }
        }
        
        
      
        if(set_SharingRecord.size() > 0){
            List<Account_Link__Share> list_SharingRecord = new List<Account_Link__Share>(set_SharingRecord);
            
            Database.insert(list_SharingRecord, false);
        }
    }
    //If Alk record type is person or company or vehicle external share alk records to Dealer user
    private static void SharePersonCompanyVehicleALK(Map<Id, List<Id>> map_AccountIdAndListAccountLinkId,Set<Id> set_ToAccountId){
        set<Account_Link__Share> set_SharingRecord = new set<Account_Link__Share>();
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
                            set_SharingRecord.add(accountLinkShare);
                        }
                    }
                }
            }
        }
        
        system.debug('set_SharingRecord@@@@'+set_SharingRecord);
        if(set_SharingRecord.size() > 0){
            List<Account_Link__Share> list_SharingRecord = new List<Account_Link__Share>(set_SharingRecord);
            
            Database.insert(list_SharingRecord, false);
        }
    }
    
     
    
    private static void createSharingRecord ( Map<Id, List<Id>> map_AccountIdAndListAccountLinkId) {
        
       if(LeadUtil.createSharingRecord ){ 
       
        // Changing Sharing from User to Public Group
        List<Account> dealerAccList = [select Name,Md__c,Dealer_GC_Code__c from Account where Id IN: map_AccountIdAndListAccountLinkId.keySet()];
         System.debug('mapdelers??????'+map_AccountIdAndListAccountLinkId.keySet());
        Set<String> dealerAccNameSet = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        Map<id,string> GCCodeMap= new map<id,string>();
        for(Account dealerRec : dealerAccList) {
            
            System.debug('similaraccounts'+dealerRec.name);
            //SN20180601- Added condition for checking GC Code sharing else existing ND code sharing
                if(string.isnotblank(dealerRec.Dealer_GC_Code__c)? Label.JPALSharingGCCode.contains(dealerRec.Dealer_GC_Code__c):false){                
                dealerAccNameSet.add(dealerRec.MD__c+dealerRec.Dealer_GC_Code__c);
                dealerAccNameSet.add(dealerRec.Name);
                accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);                
                 if(!GCCodeMap.containsKey(dealerRec.Id))
                    {
                        GCCodeMap.put(dealerRec.Id,dealerRec.MD__c+dealerRec.Dealer_GC_Code__c);
                    }                                                
            }
            else{ //SN20180601
            dealerAccNameSet.add(dealerRec.Name);
            accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
        }
        
     }
        
        set<Account_Link__Share> set_SharingRecord = new set<Account_Link__Share>();
        Map<string,group> grplist= new map<string,group>();
        if(dealerAccNameSet.size()>0){
            for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]) {
                grplist.put(groupRec.name,groupRec);            
            }
        }
        if(grplist.size()>0){
            //for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]){
            for(Group groupRec: grplist.values() ){
                 System.debug('groupRecname>>>>>'+groupRec.name);
                if(accNameToAccIdMap.containsKey(groupRec.Name) && map_AccountIdAndListAccountLinkId.containsKey(accNameToAccIdMap.get(groupRec.Name))){
                    for(Id accountLinkId : map_AccountIdAndListAccountLinkId.get(accNameToAccIdMap.get(groupRec.Name))){
                        Account_Link__Share accountLinkShare = new Account_Link__Share();
                        accountLinkShare.AccessLevel = 'Edit';
                        //SN20180601- Added condition for checking GC Code sharing else existing ND code sharing
                         if( GCCodeMap.containskey(accNameToAccIdMap.get(groupRec.Name)))
                        accountLinkShare.UserOrGroupId=grplist.get(GCCodeMap.get(accNameToAccIdMap.get(groupRec.Name))).id;
                        else
                        accountLinkShare.UserOrGroupId = groupRec.Id;
                        accountLinkShare.ParentId = accountLinkId;
                        accountLinkShare.RowCause = Schema.Account_Link__Share.RowCause.Manual;
                        set_SharingRecord.add(accountLinkShare);
                    }
                }
            }
        }
        if(set_SharingRecord.size() > 0){
            List<Account_Link__Share> list_SharingRecord = new List<Account_Link__Share>(set_SharingRecord);
             
            Database.insert(list_SharingRecord, false);
        }
        }
       LeadUtil.createSharingRecord = false; 
    }
    
    
    private static void createPCSharingRecord(Map<Id, List<Id>> map_AccountIdAndListAccountLinkId){
        // Changing Sharing from User to Public Group
        if(LeadUtil.createPCSharingRecord){
        List<Account> dealerAccList = [select Name,id,Md__c,Dealer_GC_Code__c from Account where Id IN: map_AccountIdAndListAccountLinkId.keySet()];
        Set<String> dealerAccNameSet = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        Map<id,string> GCCodeMap= new map<id,string>();
        for(Account dealerRec : dealerAccList) {
        //SN20180601- Added condition for checking GC Code sharing else existing ND code sharing
             if(string.isnotblank(dealerRec.Dealer_GC_Code__c)? Label.JPALSharingGCCode.contains(dealerRec.Dealer_GC_Code__c):false){                
                dealerAccNameSet.add(dealerRec.MD__c+dealerRec.Dealer_GC_Code__c);
                dealerAccNameSet.add(dealerRec.Name);
                accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);                
                 if(!GCCodeMap.containsKey(dealerRec.Id))
                    {
                        GCCodeMap.put(dealerRec.Id,dealerRec.MD__c+dealerRec.Dealer_GC_Code__c);
                    }
            }
            else{ //SN20180601
            dealerAccNameSet.add(dealerRec.Name);
            accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
            }
        }
        
        set<Account_Link__Share> set_SharingRecord = new set<Account_Link__Share>(); 
        Map<string,group> grplist= new map<string,group>();
        if(dealerAccNameSet.size()>0){
            for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]) {
                grplist.put(groupRec.name,groupRec);                
            }
        }
        if(grplist.size()>0){ 
        // for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]) {
        for(Group groupRec: grplist.values() ){
            if(accNameToAccIdMap.containsKey(groupRec.Name) && map_AccountIdAndListAccountLinkId.containsKey(accNameToAccIdMap.get(groupRec.Name))){
                for(Id accountLinkId : map_AccountIdAndListAccountLinkId.get(accNameToAccIdMap.get(groupRec.Name))){
                    Account_Link__Share accountLinkShare = new Account_Link__Share();
                    accountLinkShare.AccessLevel = 'Edit';
                    //SN20180601- Added condition for checking GC Code sharing else existing ND code sharing to get group id
                     if( GCCodeMap.containskey(accNameToAccIdMap.get(groupRec.Name)))
                        accountLinkShare.UserOrGroupId=grplist.get(GCCodeMap.get(accNameToAccIdMap.get(groupRec.Name))).id;
                    else
                    accountLinkShare.UserOrGroupId = groupRec.Id;
                    accountLinkShare.ParentId = accountLinkId;
                    accountLinkShare.RowCause = Schema.Account_Link__Share.RowCause.Manual;
                    set_SharingRecord.add(accountLinkShare);
                }

            }
        }
        }
        if(set_SharingRecord.size() > 0){
            List<Account_Link__Share> list_SharingRecord = new List<Account_Link__Share>(set_SharingRecord);
            System.debug('listsharing2>>>>>>>>>'+list_SharingRecord);
            Database.insert(list_SharingRecord, false);
        }
        }
        LeadUtil.createPCSharingRecord = false;
    }
    
    
    
    private static void createDealerSharingRecord(Map<Id, List<Id>> map_AccountIdAndListAccountLinkId){
        
        // Changing Sharing from User to Public Group
        List<Account> dealerAccList = [select Name,Dealer_GC_Code__c,MD__c from Account where Id IN: map_AccountIdAndListAccountLinkId.keySet()];
        List<Account_Link__Share> list_SharingRecord = new List<Account_Link__Share>();
        Set<String> dealerAccNameSet = new Set<String>();
        set<Account_Link__Share> set_SharingRecord = new set<Account_Link__Share>();
                                                                                                                   
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        Map<id,string> GCCodeMap= new map<id,string>();
        for(Account dealerRec : dealerAccList) {
        //SN20180601- Added condition for checking GC Code sharing else existing ND code sharing
        if(string.isnotblank(dealerRec.Dealer_GC_Code__c)? Label.JPALSharingGCCode.contains(dealerRec.Dealer_GC_Code__c):false){                
                dealerAccNameSet.add(dealerRec.MD__c+dealerRec.Dealer_GC_Code__c);
                dealerAccNameSet.add(dealerRec.Name);
                accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);                
                 if(!GCCodeMap.containsKey(dealerRec.Id))
                    {
                        GCCodeMap.put(dealerRec.Id,dealerRec.MD__c+dealerRec.Dealer_GC_Code__c);
                    }                                                                
            }
            else{ //SN20180601
                dealerAccNameSet.add(dealerRec.Name);
                accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
            }
        }
        Map<string,group> grplist= new map<string,group>();
        if(dealerAccNameSet.size()>0){
            for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]) {
                grplist.put(groupRec.name,groupRec);                 
            }
        }
       if(grplist.size()>0){ 
       // for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]) {
       set<string> DuplicateCheck= new set<string>();
       for(Group groupRec: grplist.values() ){
                 if(accNameToAccIdMap.containsKey(groupRec.Name) && map_AccountIdAndListAccountLinkId.containsKey(accNameToAccIdMap.get(groupRec.Name))){
                 for(Id accountLinkId : map_AccountIdAndListAccountLinkId.get(accNameToAccIdMap.get(groupRec.Name))){ 
                    Account_Link__Share accountLinkShare = new Account_Link__Share();
                    accountLinkShare.AccessLevel = 'Edit';
                    //SN20180601- Added condition for checking GC Code sharing else existing ND code sharing
                    if( GCCodeMap.containskey(accNameToAccIdMap.get(groupRec.Name))){     
                       if(!DuplicateCheck.contains(accountLinkId+''+grplist.get(GCCodeMap.get(accNameToAccIdMap.get(groupRec.Name))).id)){                   
                        accountLinkShare.UserOrGroupId=grplist.get(GCCodeMap.get(accNameToAccIdMap.get(groupRec.Name))).id;
                        DuplicateCheck.add(accountLinkId+''+accountLinkShare.UserOrGroupId);
                        accountLinkShare.ParentId = accountLinkId;
                        accountLinkShare.RowCause = Schema.Account_Link__Share.RowCause.Manual;
                        list_SharingRecord.add(accountLinkShare);
                       }
                    }
                    else{
                    //SN20180601
                        accountLinkShare.UserOrGroupId = groupRec.Id;                    
                        accountLinkShare.ParentId = accountLinkId;
                        accountLinkShare.RowCause = Schema.Account_Link__Share.RowCause.Manual;
                        list_SharingRecord.add(accountLinkShare);
                    }
                    
                }
            }
          }
        }
        if(list_SharingRecord.size() > 0){
           // List<Account_Link__Share> list_SharingRecord = new List<Account_Link__Share>(set_SharingRecord);
           
            Database.insert(list_SharingRecord, false);
        }
    }
    
    
    private static void createVehicleRelationship(Map<Id, List<Id>> map_FromAccountIdAndListToAccountId, Set<Id> set_ToAccountId){
        // Changing Sharing from User to Public Group
        List<Account> dealerAccList = [select Name,Dealer_GC_Code__c,Md__c from Account where Id IN: set_ToAccountId];
        Set<String> dealerAccNameSet = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
        for(Account dealerRec : dealerAccList) {
            dealerAccNameSet.add(dealerRec.Name);
            accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
        }
        
      /*  Map<Id, List<Id>> map_AccountIdListUser = new Map<Id, List<Id>>();
       
        set<Vehicle_Relationship__Share> set_SharingRecord = new set<Vehicle_Relationship__Share>();
        List<Vehicle_Relationship__c> list_VehicleRelationRecord = new List<Vehicle_Relationship__c>([SELECT Id, Contact__c 
                                                                                                        FROM Vehicle_Relationship__c 
                                                                                                        WHERE Contact__c IN: map_FromAccountIdAndListToAccountId.keySet()]);
       
        if(list_VehicleRelationRecord.size() > 0){
            List<Group>groupList=[select Id, Name, Type from Group where Name IN: dealerAccNameSet];
            for(Group groupRec : groupList){
                for(Vehicle_Relationship__c vehicleR : list_VehicleRelationRecord){
                    if(map_FromAccountIdAndListToAccountId.containsKey(vehicleR.Contact__c)){
                      //  for(Id toAccId : map_FromAccountIdAndListToAccountId.get(vehicleR.Contact__c)){                           
                                 
                                    Vehicle_Relationship__Share vehicleRelationShare = new Vehicle_Relationship__Share();
                                    vehicleRelationShare.AccessLevel = 'Edit';
                                    vehicleRelationShare.UserOrGroupId = groupRec.id;
                                    vehicleRelationShare.ParentId = vehicleR.Id;
                                    vehicleRelationShare.RowCause = Schema.Vehicle_Relationship__Share.RowCause.Manual;
                                    set_SharingRecord.add(vehicleRelationShare);                                
                             
                       // }
                    }
                }
            }
            
            if(set_SharingRecord.size() > 0){
                 list<Vehicle_Relationship__Share> list_SharingRecord = new List<Vehicle_Relationship__Share>(set_SharingRecord);
                Database.insert(list_SharingRecord, false);
            }
        }*/
        
        if(!System.isBatch()){
    
        Batch_VRSharingJP batcher = new Batch_VRSharingJP (dealerAccNameSet,map_FromAccountIdAndListToAccountId,set_ToAccountId );
            Database.executeBatch(batcher, 50);
            }
    }
 
    public static void updateRetailCopy(boolean isUpdate, boolean isinsert,List<Account_Link__c> accLst,map<id,Account_Link__c> accLinkOldmap)
    {
        Set<id> AccountIds = new set<id>();
        set<string> dealerGCCode = new set<string>();
        set<id> accLinkIds = new set<id>();
        List<Account_Link__c> ExistC2CList = new List<Account_Link__c>();
        List<Account_Link__c> retailcopyList = new List<Account_Link__c>();
        List<Account> delaerList = new List<Account>();
        Set<String> FromAccountIds = new set<String>();
        
        for(Account_Link__c aclnk : accLst)
        {
            if(aclnk.toRole__c!= null && aclnk.MD__c == label.MarketJp && (aclnk.RecordTypeId == AccountLink_RetailPersonRecordTypeId || aclnk.RecordTypeId == AccountLink_RetailCompanyRecordTypeId 
                                                                           || aclnk.RecordTypeId == AccountLink_contact2conatctRecordTypeId))
            { 
                AccountIds.add(aclnk.toRole__c);
            }
            if(aclnk.fromRole__c != null && aclnk.MD__c == label.MarketJp)
            {   
                FromAccountIds.add(aclnk.fromRole__c);
            }
        }
       
        system.debug('FromAccountIds<><><' + FromAccountIds);
        if(!FromAccountIds.isEmpty() && FromAccountIds != null)
        {
            delaerList = [select id ,dealer_gc_code__c,dealer_rollout_status__c from Account where Id =:FromAccountIds];
        }
        if(!delaerList.isEmpty() && delaerList != null)
        {
            for(Account acc : delaerList)
            {
                if(acc.Dealer_Rollout_Status__c == 'Done')
                {
                    dealerGCCode.add(acc.Dealer_GC_Code__c);
                }
            }
        }
        system.debug('dealerGCCode><><><' + dealerGCCode);
        if(!AccountIds.isEmpty() && AccountIds != null && !FromAccountIds.isEmpty() && FromAccountIds != null)
        {
            ExistC2CList = [Select id,Retail_Duplicate_Flag__c,Retail_Delete_Flag__c,recordtypeid from Account_Link__c where fromRole__c IN:FromAccountIds AND toRole__c IN: AccountIds AND Retail_Delete_Flag__c = false AND (recordtypeid =: AccountLink_contact2conatctRecordTypeId OR recordtypeid =:AccountLink_RetailPersonRecordTypeId OR recordtypeid =: AccountLink_RetailCompanyRecordTypeId) AND Retail_Duplicate_Flag__c = False AND Retail_Delete_Flag__c = False ];
        }
        if(!AccountIds.isEmpty() && !FromAccountIds.isEmpty() && FromAccountIds != null)
        {
            retailcopyList = [Select id,Retail_Duplicate_Flag__c,Retail_Delete_Flag__c,Vehicle__c,Retail_Individual_Home_Phone__c,torole__c,fromRole__c,fromRole__r.Dealer_GC_Code__c,recordtypeid from Account_Link__c where torole__c =:AccountIds AND fromrole__r.Dealer_GC_Code__c =:dealerGCCode AND Retail_Duplicate_Flag__c = False AND Retail_Delete_Flag__c = False AND (recordtypeid =:AccountLink_RetailPersonRecordTypeId OR recordtypeid =: AccountLink_RetailCompanyRecordTypeId) Order BY CreatedDate ASC];
        }
        system.debug('retailcopyList><><>' + retailcopyList);
        system.debug('ExistC2CList><><>' + retailcopyList);
        if(!retailcopyList.isEmpty() && retailcopyList != null)
        {
            for(Account_Link__c aclinks : retailcopyList)
            {
                accLinkIds.add(aclinks.Id);
            }
        }
        system.debug('accLinkIds><><>' + accLinkIds);
        for(Account_Link__c acclink : accLst )
        {
            if(ExistC2CList.size()>0 && acclink.recordtypeid==AccountLink_contact2conatctRecordTypeId)
            {
                acclink.addError(Label.Account_Link_record_with_the_same_Role_1_and_Role2_exists);
            }
            if(isInsert && ExistC2CList.size()>0 && ExistC2CList != null && (acclink.RecordTypeId == AccountLink_RetailPersonRecordTypeId || acclink.RecordTypeId == AccountLink_RetailCompanyRecordTypeId))
            {
                acclink.addError(Label.Retail_copy_is_already_present);
            }
        }
        system.debug('accLinkIds>>>' + accLinkIds);
        if(!retailcopyList.isEmpty() && retailcopyList != null)
        {
            createUpdateRetailCopy.updateRetailCopyFromAccountLinkbeforeInsert(accLinkIds, accLst);
        }
        else if(!accLst.isEmpty() && accLst != null)
        {
            createUpdateRetailCopy.updateRetailCopyFromAccount(AccountIds, accLst,dealerGCCode);
        }
    }
    public static void updateRetailCopyafterUpdate(List<Account_Link__c> acclnkList ,map<id,Account_Link__c> oldacclnkMap)
    {
        set<id> customerIds = new set<id>();
        set<id> dealerIds = new set<id>();
        set<string> dealerGCCodeList = new set<string>();
        for(Account_Link__c acclnk : acclnkList)
        {
            if(acclnk.toRole__c != null && acclnk.fromRole__c != null && acclnk.RecordTypeId == AccountLink_RetailPersonRecordTypeId
               || acclnk.RecordTypeId == AccountLink_RetailCompanyRecordTypeId)
            {
                if(acclnk.Name != oldacclnkMap.get(acclnk.Id).Name ||
                   acclnk.Retail_FirstName__c != oldacclnkMap.get(acclnk.Id).Retail_FirstName__c ||
                   acclnk.Retail_LastName__c != oldacclnkMap.get(acclnk.Id).Retail_LastName__c ||
                   acclnk.Retail_Full_Name__c != oldacclnkMap.get(acclnk.Id).Retail_Full_Name__c ||
                   acclnk.Retail_Full_Name_Title__c != oldacclnkMap.get(acclnk.Id).Retail_Full_Name_Title__c ||
                   acclnk.Retail_LastName_Native__c != oldacclnkMap.get(acclnk.Id).Retail_LastName_Native__c ||
                   acclnk.Retail_FirstName_Native__c != oldacclnkMap.get(acclnk.Id).Retail_FirstName_Native__c ||
                   acclnk.Retail_Full_Name_Native__c != oldacclnkMap.get(acclnk.Id).Retail_Full_Name_Native__c ||
                   acclnk.Retail_Gender__c != oldacclnkMap.get(acclnk.Id).Retail_Gender__c ||
                   acclnk.Retail_PersonBirthdate__c != oldacclnkMap.get(acclnk.Id).Retail_PersonBirthdate__c ||
                   acclnk.Retail_Occupation__c != oldacclnkMap.get(acclnk.Id).Retail_Occupation__c ||
                   acclnk.Retail_Preferred_Language__c != oldacclnkMap.get(acclnk.Id).Retail_Preferred_Language__c ||
                   acclnk.Retail_Primary_Phone__c != oldacclnkMap.get(acclnk.Id).Retail_Primary_Phone__c ||
                   acclnk.Retail_Special_Care__c != oldacclnkMap.get(acclnk.Id).Retail_Special_Care__c ||
                   acclnk.Retail_Special_Needs_Class__c != oldacclnkMap.get(acclnk.Id).Retail_Special_Needs_Class__c ||
                   acclnk.Retail_Allow_Data_Sharing__c != oldacclnkMap.get(acclnk.Id).Retail_Allow_Data_Sharing__c ||
                   acclnk.Retail_Mobile__c != oldacclnkMap.get(acclnk.Id).Retail_Mobile__c ||
                   acclnk.Retail_Email__c != oldacclnkMap.get(acclnk.Id).Retail_Email__c ||
                   acclnk.Retail_Individual_Home_Phone__c != oldacclnkMap.get(acclnk.Id).Retail_Individual_Home_Phone__c ||
                   acclnk.Retail_Sales_Sanction_Comment__c != oldacclnkMap.get(acclnk.Id).Retail_Sales_Sanction_Comment__c ||
                   acclnk.Retail_Company_Name__c != oldacclnkMap.get(acclnk.Id).Retail_Company_Name__c ||
                   acclnk.Retail_Company_Name_Native1__c != oldacclnkMap.get(acclnk.Id).Retail_Company_Name_Native1__c ||
                   acclnk.Retail_Commercial_Reg_No__c != oldacclnkMap.get(acclnk.Id).Retail_Commercial_Reg_No__c ||
                   acclnk.Retail_Vat_No__c != oldacclnkMap.get(acclnk.Id).Retail_Vat_No__c ||
                   acclnk.Retail_Foundation_Month__c != oldacclnkMap.get(acclnk.Id).Retail_Foundation_Month__c ||
                   acclnk.Retail_Company_Phone__c != oldacclnkMap.get(acclnk.Id).Retail_Company_Phone__c ||
                   acclnk.Retail_Company_Other_Phone__c != oldacclnkMap.get(acclnk.Id).Retail_Company_Other_Phone__c ||
                   acclnk.Retail_Industry__c != oldacclnkMap.get(acclnk.Id).Retail_Industry__c ||
                   acclnk.Retail_Website__c != oldacclnkMap.get(acclnk.Id).Retail_Website__c ||
                   acclnk.Retail_Fax__c != oldacclnkMap.get(acclnk.Id).Retail_Fax__c ||
                   acclnk.Retail_UCID__c != oldacclnkMap.get(acclnk.Id).Retail_UCID__c ||
                   acclnk.Retail_Sales_Sanction__c != oldacclnkMap.get(acclnk.Id).Retail_Sales_Sanction__c ||
                   acclnk.Retail_Duplicate_Flag__c != oldacclnkMap.get(acclnk.Id).Retail_Duplicate_Flag__c ||
                   acclnk.Retail_Delete_Flag__c != oldacclnkMap.get(acclnk.Id).Retail_Delete_Flag__c ||
                   acclnk.Retail_Email_OptOut__c != oldacclnkMap.get(acclnk.Id).Retail_Email_OptOut__c ||
                   acclnk.Retail_Fax_OptOut__c != oldacclnkMap.get(acclnk.Id).Retail_Fax_OptOut__c ||
                   acclnk.Retail_Phone_OptOut__c != oldacclnkMap.get(acclnk.Id).Retail_Phone_OptOut__c ||
                   acclnk.Retail_Position__c != oldacclnkMap.get(acclnk.Id).Retail_Position__c ||
                   acclnk.Retail_Visit_OptOut__c != oldacclnkMap.get(acclnk.Id).Retail_Visit_OptOut__c ||
                   acclnk.Selling_Dealer__c != oldacclnkMap.get(acclnk.Id).Selling_Dealer__c ||
                   acclnk.To_Be_Deleted__c != oldacclnkMap.get(acclnk.Id).To_Be_Deleted__c ||
                   acclnk.Retail_DMS_Customer_ID__c != oldacclnkMap.get(acclnk.Id).Retail_DMS_Customer_ID__c ||
                   acclnk.Retail_Sales_Consultant__c != oldacclnkMap.get(acclnk.Id).Retail_Sales_Consultant__c ||
                   acclnk.Retail_Complaint_Amount__c != oldacclnkMap.get(acclnk.Id).Retail_Complaint_Amount__c ||
                   acclnk.Retail_Comments__c != oldacclnkMap.get(acclnk.Id).Retail_Comments__c ||
                   acclnk.Retail_OptOutContact_Reason__c != oldacclnkMap.get(acclnk.Id).Retail_OptOutContact_Reason__c ||
                   acclnk.Retail_Related_Company__c != oldacclnkMap.get(acclnk.Id).Retail_Related_Company__c)
                {
                    customerIds.add(acclnk.toRole__c);
                    dealerIds.add(acclnk.fromRole__c);
                    dealerGCCodeList.add(acclnk.Retail_Dealer_CompanyCode__c);
                }
            }
            else if(acclnk.Vehicle__c != null && acclnk.fromRole__c != null && acclnk.RecordTypeId == AccountLink_VehicleExternalRecordTypeId &&
                   acclnk.LastServiceDate__c != oldacclnkMap.get(acclnk.Id).LastServiceDate__c ||
                   acclnk.LastServiceMileage__c != oldacclnkMap.get(acclnk.Id).LastServiceMileage__c ||
                   acclnk.Service_Dealer__c != oldacclnkMap.get(acclnk.Id).Service_Dealer__c ||
                   acclnk.NextInspectionDate__c != oldacclnkMap.get(acclnk.Id).NextInspectionDate__c ||
                   acclnk.NextServiceDate__c != oldacclnkMap.get(acclnk.Id).NextServiceDate__c ||
                   acclnk.NextMileage__c != oldacclnkMap.get(acclnk.Id).NextMileage__c ||
                   acclnk.Responsible_Dealer__c != oldacclnkMap.get(acclnk.Id).Responsible_Dealer__c ||
                   acclnk.Sales_Representative__c != oldacclnkMap.get(acclnk.Id).Sales_Representative__c ||
                   acclnk.Selling_Dealer__c != oldacclnkMap.get(acclnk.Id).Selling_Dealer__c ||
                   acclnk.Service_Advisor__c != oldacclnkMap.get(acclnk.Id).Service_Advisor__c)
            {
                customerIds.add(acclnk.Vehicle__c);
                dealerIds.add(acclnk.fromRole__c);
                dealerGCCodeList.add(acclnk.Retail_Dealer_CompanyCode__c);
            }
        }
        system.debug('customerIds>>>>' + customerIds);
        system.debug('dealerIds>>>>' + dealerIds);
        system.debug('dealerGCCodeList>>>>' + dealerGCCodeList);
        if(!customerIds.isEmpty() && customerIds != null && !dealerIds.isEmpty() && dealerIds != null && !dealerGCCodeList.isEmpty() && dealerGCCodeList != null)
        {
            createUpdateRetailCopy.updateRetailCopyFromAccountLinkafterUpdate(customerIds, dealerIds, dealerGCCodeList, acclnkList);
        }
    }
 
//created by:surya varma
//sfdcjp-578
  /*created by :Surya Varma
     Desc:Trigger handler code for sharing account record when after insert and delete event
     Update date:28/12/2016
      */
    public static void afterInsertDeleteEvent(List<Account_Link__c> aclnklist, map<id,Account_Link__c> oldAclnkMap,boolean isInsert,boolean isUpdate)
    {
        //if(LeadUtil.AccountLinkTrigger){
        
        map<string,list<String>> dealeraccntMap = new Map<string,list<String>>();
        map<string,id> assgroupMap = new map<string,id>();
        list<Account_Link__c> allist = [select id,md__c,Retail_Dealer_CompanyCode__c ,name,recordtypeId,fromRole__c,toRole__c,fromRole__r.name,fromRole__r.Dealer_GC_Code__c,fromRole__r.RecordTypeid,toRole__r.RecordTypeid,toRole__r.id from Account_Link__c where id IN :aclnklist and (Recordtypeid=:AccountLink_RetailPersonRecordTypeId or RecordtypeId=:AccountLink_RetailCompanyRecordTypeId)];
        set<id>toroleidlist=new set<id>();
        set<id>fromroleidlist=new set<id>();
        set<String> GCCode = new set<String>();
        list<String> AccountNAme = new List<String>();
        list<Accountshare> acclist=new list<Accountshare>(); 
        
        for(Account_Link__c atl:allist)
        {
            if(atl.toRole__c != null && atl.fromRole__c != null && atl.fromRole__r.Dealer_GC_Code__c != null
              && (isInsert || (isUpdate && atl.toRole__c != oldAclnkMap.get(atl.Id).toRole__c)))
            {
                System.debug('Entered For Loop for Acc Link >>>>>');
                toroleidlist.add(atl.toRole__c);
                fromroleidlist.add(atl.fromRole__c);
                GCCode.add(atl.fromRole__r.Dealer_GC_Code__c);
            }
        }
        list<account> acolist = [select id,Md__c,Name, RecordTypeId,Dealer_GC_Code__c from Account WHERE Dealer_GC_Code__c IN: GCCode AND RecordTypeid=:Dealer_RecordTypeId];
        System.debug('Entered After Loop for Acc Link >>>>>'+acolist.size());
        
        for(Account acc :acolist)
        {
            system.debug('acc.Name'+acc.Name);
            if(!dealeraccntMap.containsKey(acc.Dealer_GC_Code__c))
            {
                dealeraccntMap.put(acc.Dealer_GC_Code__c, new List<string>());
            }
            //SN20180601- Added condition for checking GC Code sharing else existing ND code sharing
            if(string.isnotblank(acc.Dealer_GC_Code__c)? Label.JPALSharingGCCode.contains(acc.Dealer_GC_Code__c):false){
                if(dealeraccntMap.get(acc.Dealer_GC_Code__c).size()==0) dealeraccntMap.get(acc.Dealer_GC_Code__c).add(acc.MD__c+acc.Dealer_GC_Code__c);
                AccountNAme.add(acc.MD__c+acc.Dealer_GC_Code__c);
            }
            else{                                                                                      
                dealeraccntMap.get(acc.Dealer_GC_Code__c).add(acc.Name);
                AccountNAme.add(acc.Name);
            }
        }
        system.debug('dealeraccntMap><><><' + dealeraccntMap);
        list<group> glist=[select id ,Name ,Type from Group where Name IN:AccountNAme];
        if( glist !=null && !glist.isempty())
        {
            System.debug('Entered After Loop for Acc Link $$$$$'+glist.size());
            for(Group assg:glist)
            {
                
                assgroupMap.put(assg.Name, assg.id);
                
            }
            
            for(Account_Link__c alnk: allist) 
            {
                if(AccountNAme.size()>0)
                {
                    for(integer i=0 ; i < dealeraccntMap.get(alnk.Retail_Dealer_CompanyCode__c).size();i++)
                    {
                        if(assgroupMap.get(dealeraccntMap.get(alnk.Retail_Dealer_CompanyCode__c)[i]) != null)
                        {
                            system.debug('Inserting1' + assgroupMap.get(dealeraccntMap.get(alnk.Retail_Dealer_CompanyCode__c)[i]));
                            Accountshare a=new Accountshare();
                            a.Accountid=alnk.toRole__c;
                            /*if(string.isnotblank(alnk.Retail_Dealer_CompanyCode__c)?Label.JPALSharingGCCode.contains(alnk.Retail_Dealer_CompanyCode__c):false)
                                a.UserOrGroupId = assgroupMap.get(dealeraccntMap.get(alnk.Retail_Dealer_CompanyCode__c)[i]);
                            else */
                            a.UserOrGroupId = assgroupMap.get(dealeraccntMap.get(alnk.Retail_Dealer_CompanyCode__c)[i]);
                            a.AccountAccessLevel='edit';
                            a.RowCause = Schema.Accountshare.RowCause.Manual;
                            a.OpportunityAccessLevel ='edit';
                            acclist.add(a);
                        }
                    }
                }
           // }
            
        }
        
   }
   if(acclist.size()>0)
        {
            insert acclist;
        }
 //}
 //LeadUtil.AccountLinkTrigger = false;
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
   //SN20180601- Added md and dealer code
   for(Account acc:[Select id, Name,RecordtypeId,md__c,Dealer_GC_Code__c From Account Where Id IN:fromRoleIdList]){      
      fromAccountRecordTypeMap.put(acc.id,acc);
   
   }
   
   Map<Id,Account> ToAccountRecordTypeMap = new Map<Id,Account>();
   //SN20180601- Added md and dealer code
   for(Account acc:[Select id, Name,RecordtypeId,md__c,Dealer_GC_Code__c From Account Where Id IN:toroleidlist]){      
      ToAccountRecordTypeMap.put(acc.id,acc);
   
   }
   
   list<Account_Link__c>allist1 = new list<Account_Link__c>();
  list<Account> aclist;
  list<string> aclistnames = new list<string>();
  Map<string,set<id>> GCCodeMap= new Map<string,set<id>>();                                                                                                             
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
                 {  //SN20180601- Added condition for checking GC Code sharing else existing ND code sharing
                    if(string.isnotblank(fromAccountRecordTypeMap.get(al.fromRole__c).Dealer_GC_Code__c)? Label.JPALSharingGCCode.contains(fromAccountRecordTypeMap.get(al.fromRole__c).Dealer_GC_Code__c):false){
                        if(!GCCodeMap.containskey(fromAccountRecordTypeMap.get(al.fromRole__c).MD__c+fromAccountRecordTypeMap.get(al.fromRole__c).Dealer_GC_Code__c)){
                            aclistnames.add(fromAccountRecordTypeMap.get(al.fromRole__c).MD__c+fromAccountRecordTypeMap.get(al.fromRole__c).Dealer_GC_Code__c);
                           // GCCodeMap.get(fromAccountRecordTypeMap.get(al.fromRole__c).MD__c+fromAccountRecordTypeMap.get(al.fromRole__c).Dealer_GC_Code__c).add(fromAccountRecordTypeMap.get(al.fromRole__c));
                        }
                        else {
                            GCCodeMap.put(fromAccountRecordTypeMap.get(al.fromRole__c).MD__c+fromAccountRecordTypeMap.get(al.fromRole__c).Dealer_GC_Code__c,new set<ID>());
                        }
                     }                                                                                                                                                                                             
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
                //SN20180601- Added condition for checking GC Code sharing else existing ND code sharing
                if(string.isnotblank(fromAccountRecordTypeMap.get(alnk.fromRole__c).Dealer_GC_Code__c)? Label.JPALSharingGCCode.contains(fromAccountRecordTypeMap.get(alnk.fromRole__c).Dealer_GC_Code__c):false){
                a.UserOrGroupId = assgroupMap.get(fromAccountRecordTypeMap.get(alnk.fromRole__c).MD__c+fromAccountRecordTypeMap.get(alnk.fromRole__c).Dealer_GC_Code__c);
                }                                                                                                                                                                                                 
                else                                                                                                                                                                                      
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
            if(string.isnotblank(dealerRec.Dealer_GC_Code__c)? Label.JPALSharingGCCode.contains(dealerRec.Dealer_GC_Code__c):false){
            dealerAccNameSet.add(dealerRec.Md__c+dealerRec.Dealer_GC_Code__c);
            }                                                                                                              
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
  /*
    LastModifiedDate : 3rd Mar, 2017
    LastModifedBY    : Lokesh M
    JIRA No          : SFDCJP-1893
    Method           : updateRetailCopyfromC2C
    Event            : Before Update
  */
  public static void updateRetailCopyfromC2C(boolean isUpdate,boolean isBefore , boolean isInsert ,List<Account_Link__c> accLst){
       
       if(LeadUtil.updateRetailCopyfromC2C ){ 
        Map<Id,Account_Link__c> updateMap = new Map<Id,Account_Link__C>();
        Set<Id> comId = new Set<Id>();
        Set<Id> perAccIdSet = new Set<Id>();
        Set<Id> comAccIdSet = new Set<Id>();
        Map<Id,Id> retComAccLinkMap = new Map<Id,Id>();
        if((isInsert || isUpdate) && isBefore && Integrationusr.Profile.Name != 'IntegrationAPI'){
            for(Account_Link__c accLink : accLst){
                if(accLink.RecordtypeId == AccountLink_RetailPersonRecordTypeId && accLink.Retail_Related_Company__c != NULL && accLink.MD__c == label.MarketJp){
                    comId.add(accLInk.Retail_Related_Company__c);
                    perAccIdSet.add(accLink.toRole__c);
                    System.debug('apostion<><><'+accLink.Position__c);
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
            List<Account_Link__c> accLinkConToCon = [SELECT Id,Position__c,fromRole__c,Retail_Position__c,toRole__C  FROM Account_Link__c WHERE (fromRole__c IN: perAccIdSet AND toRole__c IN: comAccIdSet) OR (fromRole__c IN: comAccIdSet AND toRole__c IN: perAccIdSet)];
            if(accLinkConToCon != NULL && !accLinkConToCon.isEmpty()){
                for(Account_Link__c acLink : accLinkConToCon){
                    if(!String.isBlank(acLink.Position__c)){
                        if(retComAccLinkMap.get(acLInk.toRole__c) != NULL)
                        updateMap.get(retComAccLinkMap.get(acLInk.toRole__c)).Retail_Position__c = acLink.Position__c;
                        else if(retComAccLinkMap.get(acLInk.fromRole__c) != NULL && acLink.Retail_Position__c  != null) {
                            updateMap.get(retComAccLinkMap.get(acLInk.fromRole__c)).Retail_Position__c = acLink.Position__c;
                        }
                    }
                }    
            }
        }        
    }
    LeadUtil.updateRetailCopyfromC2C=false; 
    }
     
    /*
        LastModifiedDate : 15th Mar, 2017
        LastModifedBY    : Srinivas Pendli
        JIRA No          : SFDCKR-484
        Method           : afterInsertEventKR
        Event            : Before insert
    */
    
    public static void afterInsertEventKR(List<Account_Link__c> list_AccountLink){
        map<Id, List<Id>> map_AccountIdAndListAccountLinkId = new Map<Id, List<Id>>();
        for(Account_Link__c accountLink : list_AccountLink){
            if(!map_AccountIdAndListAccountLinkId.containsKey(accountLink.fromRole__c)){
                map_AccountIdAndListAccountLinkId.put(accountLink.fromRole__c, new List<Id>());
            }
            map_AccountIdAndListAccountLinkId.get(accountLink.fromRole__c).add(accountLink.Id);
        }
        if(map_AccountIdAndListAccountLinkId.size() > 0){
            //createSharingRecord(map_AccountIdAndListAccountLinkId);
            List<Account> dealerAccList = [select Name, Dealer_ND_Code__c from Account where Id IN: map_AccountIdAndListAccountLinkId.keySet()];
            Set<String> dealerAccNameSet = new Set<String>();
            Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
            for(Account dealerRec : dealerAccList) {
                dealerAccNameSet.add(dealerRec.Dealer_ND_Code__c);
                accNameToAccIdMap.put(dealerRec.Dealer_ND_Code__c, dealerRec.Id);
            }
        
            List<Account_Link__Share> list_SharingRecord = new List<Account_Link__Share>();
            for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]){
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
    }
    public static void afterUpdateEventKR(List<Account_Link__c> list_AccountLink, Map<Id, Account_Link__c> map_AccountLinkIdAndRecord){
        Map<Id, List<Id>> map_AccountIdAndListAccountLinkId = new Map<Id, List<Id>>();
        for(Account_Link__c accountLink : list_AccountLink){
            if(accountLink.RecordTypeId == AccountLink_ContactSectorRecordTypeId && accountLink.Status__c == 'My Shops' &&
                accountLink.fromRole__c != null && (accountLink.fromRole__c != map_AccountLinkIdAndRecord.get(accountLink.Id).fromRole__c || 
                accountLink.Status__c != map_AccountLinkIdAndRecord.get(accountLink.Id).Status__c)){
                if(!map_AccountIdAndListAccountLinkId.containsKey(accountLink.fromRole__c)){
                    map_AccountIdAndListAccountLinkId.put(accountLink.fromRole__c, new List<Id>());
                }
                map_AccountIdAndListAccountLinkId.get(accountLink.fromRole__c).add(accountLink.Id);
            }
        }
        if(map_AccountIdAndListAccountLinkId.size() > 0){
            //createSharingRecord(map_AccountIdAndListAccountLinkId);
            List<Account> dealerAccList = [select Name,Dealer_ND_Code__c from Account where Id IN: map_AccountIdAndListAccountLinkId.keySet()];
            Set<String> dealerAccNameSet = new Set<String>();
            Map<String, Id> accNameToAccIdMap = new Map<String, Id>();
            for(Account dealerRec : dealerAccList) {
                dealerAccNameSet.add(dealerRec.Dealer_ND_Code__c);
                accNameToAccIdMap.put(dealerRec.Dealer_ND_Code__c, dealerRec.Id);
            }
            
            List<Account_Link__Share> list_SharingRecord = new List<Account_Link__Share>();
            for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet]){
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
    }
     /*   created by:Dinesh
    [CISM:0038992405]
     Desc:Retail_Copy_Accountlink_Retail_Address_Reference.
     Update date:07/12/2016*/
      
      public static void updateAccountlinks(List<Account_Link__c> list_AccountLink,Map<id,Account_Link__c> oldMap,boolean isUpdate, boolean isinsert){
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
                acc.Retail_Distinct__c = acc.Retail_Address_Reference__r.District__c  ;
                acc.Retail_Address_Line_1__c  = acc.Retail_Address_Reference__r.Address_Line_1__c;
                acc.Retail_Address_Line_2__c =  acc.Retail_Address_Reference__r.Address_Line_2__c;
                acc.Retail_ZipCode__c = acc.Retail_Address_Reference__r.ZipCode__c;
                if(addtrmap1.containsKey(acc.Retail_Address_Reference__r.Province__c) )
                {
                    province = addtrmap1.get(acc.Retail_Address_Reference__r.Province__c);
                }                
                acc.Retail_Province__c = province ;//+ acc.Retail_Address_Reference__r.City__c + acc.Retail_Address_Reference__r.District__c + acc.Retail_Address_Reference__r.Block__c+ acc.Retail_Address_Reference__r.Address_Line_1__c + ' ' + acc.Retail_Address_Reference__r.Address_Line_2__c ;
                //acc.Retail_Province__c  =acc.Retail_Province__c.replaceAll(regexForNullValue,nullValue);
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
    //Added venky changes related to SFDCJP-2617
    public static void Sharecontact2conatct(boolean isUpdate,boolean isBefore , boolean isInsert ,List<Account_Link__c> accLst)
    {
    
    if(leadUtil.Share2contactUpdate || leadUtil.Share2contactInsert)
    {
        Map<Id, List<Id>> map_AccountIdAndListAccountLinkId = new Map<Id, List<Id>>();
        Set<Id> RetailPersonID=new Set<Id>();
        Set<Id> RetailcompanyID=new Set<Id>();
        Set<Id> FromRoleID=new Set<Id>();
        Set<Id> ToRoleID=new Set<Id>();
        Set<Id> RetailPersonDealerID=new Set<Id>();
        Set<Id> RetailcompanyDealerID=new Set<Id>();
        List<Account_Link__c> lstC2c=new List<Account_Link__c>();
        List<Account_Link__c> lstPersonCompany=new List<Account_Link__c>();
        List<Id> acclnkid = new List<id>();
        Set<String> dealerAccNameSet = new Set<String>();
        Set<String> GcCode = new Set<String>();
        List<Account> dealerAccList =new  List<Account>();
        Set<String> dealerAccNameSet1 = new Set<String>();
        Map<String, Id> accNameToAccIdMap = new Map<String, Id>(); 
        List<Account_Link__Share> Sharealk= new List<Account_Link__Share>();
        for(Account_Link__c alk:accLst)
        {
            acclnkid.add(alk.id);
            if(alk.RecordtypeID== AccountLink_Contact2ContactRecordTypeId )
            {
                FromRoleID.add(alk.fromRole__c);
                ToRoleID.add(alk.toRole__c);
            }
            if(alk.RecordtypeID== AccountLink_RetailPersonRecordTypeId)
            {
                RetailPersonDealerID.add(alk.fromRole__c);  // Dealer Acc
                RetailPersonID.add(alk.toRole__c);        //Customer Acc
            }
            if(alk.RecordtypeID== AccountLink_RetailCompanyRecordTypeId )
            {
                RetailcompanyDealerID.add(alk.fromRole__c);  // Dealer Acc
                RetailcompanyID.add(alk.toRole__c);     //Customer Acc
            }
        }

        if(RetailcompanyID !=null && RetailPersonID !=null)
        {
            lstC2c=[Select id,fromRole__c,Retail_Delete_Flag__c ,toRole__c,fromRole__r.Name,fromRole__r.Dealer_GC_Code__c from Account_Link__c  where  ( (fromRole__c=: RetailPersonID OR fromRole__c=:RetailcompanyID) OR (toRole__c=: RetailPersonID OR toRole__c=:RetailcompanyID)) and RecordtypeId=:AccountLink_Contact2ContactRecordTypeId  ];
        }

        if( ToRoleID !=null && FromRoleID!=null)
        {
            lstPersonCompany=[ Select id,Retail_Delete_Flag__c ,fromRole__c,toRole__c,fromRole__r.Name,fromRole__r.Dealer_GC_Code__c from Account_Link__c  where (toRole__c =:ToRoleID OR toRole__c=:FromRoleID) AND (RecordtypeId =:AccountLink_RetailPersonRecordTypeId OR RecordtypeId=:AccountLink_RetailCompanyRecordTypeId)];
        }

        if(lstC2c!=null)
        {
            for(Account_Link__c accountLink : lstC2c)
            {
                if(accountLink.Retail_Delete_Flag__c == false)
                {   
                    dealerAccNameSet.add(accountLink.fromRole__r.Name);
                    GcCode.add(accountLink.fromRole__r.Dealer_GC_Code__c);
                }
            }
        }
        
        System.debug('%&%&%&%&%&%&%& lstPersonCompany'+lstPersonCompany);
        
        if(lstPersonCompany !=null)
        {
            for(Account_Link__c acctLink : lstPersonCompany)
            {
                if(acctLink.Retail_Delete_Flag__c == false)
                {
                    GcCode.add(acctLink.fromRole__r.Dealer_GC_Code__c);
                    dealerAccNameSet.add(acctLink.fromRole__r.Name);
                }
            }
        }
        
        system.debug('dealerAccNameSet dealerAccNameSet>>>> ' + dealerAccNameSet);
        if(  dealerAccNameSet !=null)
        {
            
            dealerAccList = [select Name from Account where Dealer_GC_Code__c=:GcCode and RecordtypeId=:DealerAccid];
            system.debug('dealerAccList>>>> ' + dealerAccList );
        }
        
        
        if(dealerAccList !=null)
        {
            for(Account dealerRec : dealerAccList) 
            {
                dealerAccNameSet1.add(dealerRec.Name);
                accNameToAccIdMap.put(dealerRec.Name, dealerRec.Id);
            }
        }
        system.debug('dealerAccNameSet>>>> ' + dealerAccNameSet1);
        system.debug('accNameToAccIdMap>>>> ' + accNameToAccIdMap);
        if(dealerAccNameSet1 !=null)
        {
            for(Group groupRec : [select Id, Name, Type from Group where Name IN: dealerAccNameSet1])
            {
                system.debug('INsertedededsd>>>>');
                if(lstC2c!=null )
                {
                    for(Account_Link__c aclink : lstC2c)
                    {
                        if(accNameToAccIdMap.containsKey(groupRec.Name))
                        {
                            Account_Link__Share accountLinkShare = new Account_Link__Share();
                            accountLinkShare.AccessLevel = 'Edit';
                            accountLinkShare.UserOrGroupId = groupRec.Id;
                            accountLinkShare.ParentId = aclink.id;
                            accountLinkShare.RowCause = Schema.Account_Link__Share.RowCause.Manual;
                            Sharealk.add(accountLinkShare);
                        }
                    }
                }
                for(Account_Link__c aclink : accLst)
                {
                    if(accNameToAccIdMap.containsKey(groupRec.Name))
                    {
                        Account_Link__Share accountLinkShare = new Account_Link__Share();
                        accountLinkShare.AccessLevel = 'Edit';
                        accountLinkShare.UserOrGroupId = groupRec.Id;
                        accountLinkShare.ParentId = aclink.id;
                        accountLinkShare.RowCause = Schema.Account_Link__Share.RowCause.Manual;
                        Sharealk.add(accountLinkShare);
                    }
                }
            }
        }
        if(Sharealk.size() > 0)
        {
            Database.insert(Sharealk, false);
        }
     }
    }
    /* Data Migration Explicit Fix - Santosh Mohanty */
    public static void updatemarket(List<Account_link__c> accLinkList){        
        
               for(Account_link__c accLinkRec : accLinkList){
                   if(Test.isRunningTest()){
                      accLinkRec.isTestRunning__c=true;
                    }
                   if(accLinkRec.Market__c =='' || accLinkRec.Market__c==NULL){
                     accLinkRec.Market__c=accLinkRec.MD__c;
                  }  
              }       
    }
    
    /*Added changes related to SFDCJP-3221*/
    public static void deleteduplicatec2calk(List<Account_link__c> accLinkList){
        Set<Id> fromId=new Set<Id>();
        Set<Id> toId=new Set<Id>();
        Set<String> Role1=new Set<String>();
        Set<String> Role2=new Set<String>();
        List<Account_link__c> duplicatealk=new List<Account_link__c>();
        List<Account_link__c> Deletealk=new List<Account_link__c>();
         List<Account_link__c> deleteDupAlk=new List<Account_link__c>();
       // Map<Id,Account_link__c> deleteDupAlk=new Map<Id,Account_link__c>();
        try
        {
            
       
        for(Account_link__c dupal:accLinkList)
       {
           if(dupal.recordtypeId == AccountLink_contact2conatctRecordTypeId)
           {
                fromId.add(dupal.fromRole__c);
              toId.add(dupal.toRole__c);
               Role1.add(dupal.Role__c);
               Role2.add(dupal.Role2__c);
           }
           
       }
         if(fromId !=null && toId!=null && Role1!=null && Role2!=null)
              {
              duplicatealk=[Select id,fromRole__c,toRole__c,Role__c,Role2__c from Account_link__c where fromRole__c=:fromId and toRole__c=:toId and recordtypeId=:AccountLink_contact2conatctRecordTypeId and Role__c=:Role1 and Role2__c=:Role2];
               System.debug('^&&&&&&&&&&&&&&&duplicatealk'+duplicatealk );
                System.debug('^&&&&&&&&&&&&&&&duplicatealk'+duplicatealk.size());
                  if(duplicatealk.size() >1)
                  {
                      Deletealk=[Select id,fromRole__c,toRole__c,Role__c,Role2__c from Account_link__c where fromRole__c=:fromId and toRole__c=:toId and recordtypeId=:AccountLink_contact2conatctRecordTypeId and Role__c=:Role1 and Role2__c=:Role2 limit 1];
                      if(Deletealk !=null)
                      {
                           for(Account_link__c alks:Deletealk)
                          {
                              deleteDupAlk.add(alks);
                          }
                          
                      }
                     
                  }
              }
        if(deleteDupAlk !=null)
        {
            Database.delete(deleteDupAlk);
        }
             }Catch(Exception e){}
    }
}