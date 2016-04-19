public class AddressHelper
{
     private static final String personAccountRTID = Schema.SObjectType.Address__c.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
    private static final String companyRTID =  Schema.SObjectType.Address__c.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    
    public static void auBeforeInsert_update_Events(list<Address__c> listNewAddress,map<Id,Address__c> addressOldMap, boolean isInsert,boolean isUpdate)
    {
         Set<String> csIds = new Set<String>();
         Set<String> suburbs = new Set<String>();
       
         for(Address__c addre : listNewAddress) {
             if(!csIds.contains(addre.Customer__c)){
                 csIds.add(addre.Customer__c);
             }
                
             //US_AU-CD-032 Make sure the letters of suburb is capital ones
             if(!String.isBlank(addre.District__c)){
                 addre.District__c = addre.District__c.toUpperCase();
                 suburbs.add(addre.District__c);
             }
             
             // US_AU-CD-001.6 Track the updating history for FS fields.
             if(isUpdate){
                 trackUpdatHistoryForFsInfo(addre, addressOldMap.get(addre.Id));
             }
         }
         
         
         Map<String,String> suburbAndPostCodeMapping = getMappingBetweenSuburbAndZip(suburbs);
         
         for(Address__c addre : listNewAddress){
             //US_AU-CD-003, Auto-fill the post code if the suburb-postcode mapping is existed 
             if(String.isBlank(addre.ZipCode__c) 
                 && !String.isBlank(addre.District__c) 
                 && suburbAndPostCodeMapping.containsKey(addre.District__c)
                 && (addre.RecordTypeId == personAccountRTID || addre.RecordTypeId == companyRTID)) {
                     
                 addre.ZipCode__c = suburbAndPostCodeMapping.get(addre.District__c);
             }
         }
         
         //US_AU-CD-003 No.4
         if(csIds.size()>0){
             Map<String,List<Address__c>> AddressInfoMap = getAllAddresses(csIds);
             for(Address__c addre : listNewAddress) {
                 if(AddressInfoMap.get(addre.Customer__c) != null && (addre.RecordTypeId == personAccountRTID || addre.RecordTypeId == companyRTID)){
                     for(Address__c oldInfo : AddressInfoMap.get(addre.Customer__c)){
                         if(addre.Address_Type__c != null && oldInfo.Address_Type__c == addre.Address_Type__c && (isInsert || (isUpdate && addressOldMap.get(addre.id).Address_Type__c != addre.Address_Type__c))){
                             addre.addError('Please use another address type, this one already exists for the customer!'); 
                         }
                     }           
                 }
             }
         }
    }
    
    public static void auAfter_Insert_Update_Delete_Events(list<Address__c> listNewAddress,list<Address__c> listOldAddress,map<id,Address__c> oldAddressMap,boolean isUpdate,boolean isDelete)
    {
         // 1. Searches the related records
         Set<String> customerIds = new Set<String>();
         if(isDelete){
             for(Address__c item : listOldAddress){
                 if(item.Preferred__c && (item.RecordTypeId == personAccountRTID || item.RecordTypeId == companyRTID)){
                     customerIds.add(item.Customer__c);
                 }
             }
             
         }
         else{
             for(Address__c address : listNewAddress) {
                 if(isUpdate && oldAddressMap.get(address.Id).Preferred__c != address.Preferred__c){
                     continue;
                 }
                 if(address.RecordTypeId == personAccountRTID || address.RecordTypeId == companyRTID){
                     customerIds.add(address.Customer__c);
                 }
             }
         }
         
         // 2. Business logics  -- preferred the address and populate the address info to its customer
         if(!customerIds.isEmpty()){
             flagPreferredAddressAndPopulateToCustomer(customerIds);
         }
    }
    
     //US-CD-003, Auto-fill the post code by the suburb    
    public static Map<String,String> getMappingBetweenSuburbAndZip(Set<String> suburbs){
        Map<String, String> SuburbZips = new Map<String, String>();
        if(suburbs.size() > 0){
            for(Suburb_Zip_Mapping__c sz : [select Name, Zip__c from Suburb_Zip_Mapping__c where Name in :suburbs]) {
                SuburbZips.put(sz.Name, sz.Zip__c);
            }
        }
        return SuburbZips;
    }
    
     //get All addresses of customer
    public static Map<String,List<Address__c>> getAllAddresses(Set<String> customerIds){
        Map<String,List<Address__c>> result = new Map<String, List<Address__c>>();
        for(Address__c address : [select Preferred__c, Status__c, Customer__c,Address_Line_1__c, Address_Line_2__c, Address_Type__c,
                                         Country__c, District__c, ZipCode__c, Province__c, Customer__r.Id
                                  from Address__c where Customer__c in :customerIds]){
            if(result.containsKey(address.Customer__c)){
                result.get(address.Customer__c).add(address);
            }
            else{
                result.put(address.Customer__c, new List<Address__c>{address});
            }
        }
        return result;
    }
    
    //flag prefferAddress
    public static void flagPreferredAddressAndPopulateToCustomer(Set<String> customerIds){
        Map<String,List<AddressWrapper>> addresses = getAllAddressWrapperes(customerIds);
        List<Address__c> preferredAddresses = new List<Address__c>();
        List<Address__c> originalPreferredAddresses = new List<Address__c>();
        List<Address__c> updatedAddresses = new List<Address__c>();
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        
        Map<String, Account> idAccount = new Map<String, Account>();
        //TODO
        /*for(Account acc : [select id, Status__c, Address_State__c,Address_Line_1__c, Address_Line_2__c, Address_Type__c,
                           Company_Name__c, Country__c, District__c, ZipCode__c from Account where id in :customerIds]) {
            idAccount.put(acc.id, acc);
        }*/
        
        List<Account> updateAccounts = new List<Account>();
        
        for(ID customerId : customerIds){
            List<AddressWrapper> addressList = new List<AddressWrapper>();
            if(addresses != null && addresses.keyset().contains(customerId)) {
                addressList = addresses.get(customerId);
            }
            //TODO
            /*if(addressList.size() == 0 && idAccount.size() > 0 && idAccount.keyset().contains(customerId)) {
                Account acc = idAccount.get(customerId);
                
                acc.Status__c = '';
                acc.Address_State__c = '';
                acc.Address_Line_1__c = '';
                acc.Address_Line_2__c = '';
                acc.Address_Type__c = '';
                acc.Company_Name__c = '';
                acc.Country__c = '';
                acc.District__c = '';
                acc.ZipCode__c = '';
                
                updateAccounts.add(acc);
            }*/
            
            // Sort address as the hierarchy of Type.
            if((addressList != null && !addressList.isEmpty())&& (profileName!= 'IntegrationAPI')){
                addressList.sort();
                
                // Flag the preferred address.
                if(!addressList[0].address.Preferred__c){
                    addressList[0].address.Preferred__c = true;
                    updatedAddresses.add(addressList[0].address);
                }
                preferredAddresses.add(addressList[0].address);
                
                // Cancel the original flag.
                addressList.remove(0);
                for(Integer i = 0; i < addressList.size(); i++){
                    if(addressList[i].address.Preferred__c){
                        addressList[i].address.Preferred__c = false;
                        updatedAddresses.add(addressList[i].address);
                    }
                }
            }
        }
        
        if(!updateAccounts.isEmpty()){
            update updateAccounts;
        }
        
        if(!preferredAddresses.isEmpty()){
            populatePreferredAddressToCustomer(preferredAddresses);
        }
        
        // Update addresses.
        if(!updatedAddresses.isEmpty()){
            update updatedAddresses;
        }
    }
    
      private static void populatePreferredAddressToCustomer(List<Address__c> preferredAddresses){
        List<Account> updateAccounts = new List<Account>();
        //todo
        /*for(Address__c address: preferredAddresses){
                address.Customer__r.Status__c = address.Status__c;
                address.Customer__r.Address_State__c = address.Province__c;
                address.Customer__r.Address_Line_1__c = address.Address_Line_1__c;
                address.Customer__r.Address_Line_2__c = address.Address_Line_2__c;
                address.Customer__r.Address_Type__c = address.Address_Type__c;
                //for CR-000202 start
                address.Customer__r.Company_Name__c = address.Company_Name__c;
                //for CR-000202 end
                address.Customer__r.Country__c = address.Country__c;
                address.Customer__r.District__c = address.District__c;
                address.Customer__r.ZipCode__c = String.valueOf(address.ZipCode__c);
                updateAccounts.add(address.Customer__r);
        }*/
        
        if(!updateAccounts.isEmpty()){
            update updateAccounts;
        }
    }
     private static Map<String,List<AddressWrapper>> getAllAddressWrapperes(Set<String> customerIds){
        Map<String,List<AddressWrapper>> result = new Map<String, List<AddressWrapper>>();
        //for CR-000202 start
        for(Address__c address : [select Preferred__c, Status__c, Customer__c,Address_Line_1__c, Address_Line_2__c, Address_Type__c,
                                         Company_Name__c, Country__c, District__c, ZipCode__c, Province__c, Customer__r.Id
                                  from Address__c where Customer__c in :customerIds]){
            if(result.containsKey(address.Customer__c)){
                result.get(address.Customer__c).add(new AddressWrapper(address));
            }
            else{
                result.put(address.Customer__c, new List<AddressWrapper>{new AddressWrapper(address)});
            }
        }
        //for CR-000202 end
        return result;
    }
    
    /**
     *  Sort class for address object. 
     *  For individual account, Mailing=>Home=>Business=>Prev Mailing.
     *  For company account, Mailing=>Company=>Prev Mailing
    **/
    public class AddressWrapper implements Comparable {

        private Address__c address;
        private Map<String, Integer> addressHierarchy = new Map<String, Integer>{'Mailing'=>1, 'Home'=>2, 'Business'=>3, 'Company'=>3, 'Prev Mailing'=>4};
        
        public AddressWrapper(Address__c ar) {
            address = ar;
        }
        
        public Integer compareTo(Object compareTo) {
            AddressWrapper compareToAddress = (AddressWrapper)compareTo;
            Integer returnValue = 0;
            if(String.isBlank(address.Status__c) && !String.isBlank(compareToAddress.address.Status__c)){
                returnValue = -1;
            }
            else if(String.isBlank(compareToAddress.address.Status__c) && !String.isBlank(address.Status__c)){
                returnValue = 1;
            }
            else{
                Integer a = addressHierarchy.get(address.Address_Type__c);
                Integer b = addressHierarchy.get(compareToAddress.address.Address_Type__c);
                if (a > b){
                    returnValue = 1;
                }
                else if (a < b) {
                    returnValue = -1;
                }
            }
            return returnValue;       
        }
    }
    
     // US_AU-CD-001.6 Track the updating history for FS fields
    public static void trackUpdatHistoryForFsInfo(Address__c updateAddress, Address__c oldAddress){
        
         Map<Id, GroupMember> groupMemberMap = new Map<Id, GroupMember>([Select GroupId, UserOrGroupId From GroupMember  Where Group.DeveloperName =: 'MB_Financial_Services' AND UserOrGroupId =: userinfo.getUserID()]);
        if(groupMemberMap!=null && !groupMemberMap.isEmpty())
        {
        
            if((updateAddress.Address_Type__c!= oldAddress.Address_Type__c) || (updateAddress.Company_Name__c!= oldAddress.Company_Name__c) || (updateAddress.Address_Line_1__c!= oldAddress.Address_Line_1__c) || (updateAddress.Address_Line_2__c!= oldAddress.Address_Line_2__c) || (updateAddress.District__c!= oldAddress.District__c) || (updateAddress.ZipCode__c!= oldAddress.ZipCode__c) || (updateAddress.Province__c!= oldAddress.Province__c) || (updateAddress.Country__c!= oldAddress.Country__c) || (updateAddress.Preferred__c!= oldAddress.Preferred__c) || (updateAddress.Status__c!= oldAddress.Status__c) || (updateAddress.Delivery_Point_ID__c!= oldAddress.Delivery_Point_ID__c) || (updateAddress.FS_Opt_In_Hardcopy__c != oldAddress.FS_Opt_In_Hardcopy__c ))
            {
           updateAddress.FS_Hardcopy_Last_Modified_By__c = UserInfo.getName();
            updateAddress.FS_Hardcopy_Last_Modified_Date__c = System.now();
            }
            }
       else 
       if((updateAddress.Address_Type__c!= oldAddress.Address_Type__c) || (updateAddress.Company_Name__c!= oldAddress.Company_Name__c) || (updateAddress.Address_Line_1__c!= oldAddress.Address_Line_1__c) || (updateAddress.Address_Line_2__c!= oldAddress.Address_Line_2__c) || (updateAddress.District__c!= oldAddress.District__c) || (updateAddress.ZipCode__c!= oldAddress.ZipCode__c) || (updateAddress.Province__c!= oldAddress.Province__c) || (updateAddress.Country__c!= oldAddress.Country__c) || (updateAddress.Preferred__c!= oldAddress.Preferred__c) || (updateAddress.Status__c!= oldAddress.Status__c) || (updateAddress.Delivery_Point_ID__c!= oldAddress.Delivery_Point_ID__c) || (updateAddress.Opt_In_Hardcopy__c!= oldAddress.Opt_In_Hardcopy__c))
            {
            updateAddress.Hardcopy_Last_Modified_By__c = UserInfo.getName();
            updateAddress.Hardcopy_Last_Modified_Date__c = System.now();
        }
    }
    
    public static void updateAddressOnAccount(list<Address__c> listNewAddress){
    Set<Id> AccIdSet = new Set<Id>();
    map<Id,Account> updateAccntMap = new map<Id,Account>();
    list<Account> updateAccntList = new list<Account>();
    for(Address__c addr : listNewAddress){
          if(addr.preferred__c)
              AccIdSet.add(addr.Customer__c);
    }
    
     if(AccIdSet!=null && !AccIdSet.isEmpty())
     {
          List<Account> accList = [select id,Primary_Address__c from Account where id in : AccIdSet];
          if(accList!=null && !accList.isEmpty())
          {
              for(Account acc : accList)
              {  
                   for(Address__c addr : listNewAddress)
                   {
                        if(acc.Id==addr.Customer__c)
                        {
                             if(addr.Address_Line_1__c!=null && addr.Address_Line_1__c!='')
                                  acc.Primary_Address__c = addr.Address_Line_1__c;
                             if(addr.Address_Line_2__c!=null && addr.Address_Line_2__c!='')  
                                  acc.Primary_Address__c +=' '+ addr.Address_Line_2__c;
                             if(addr.District__c!=null && addr.District__c!='')
                                  acc.Primary_Address__c +=' '+ addr.District__c;
                             if(addr.Province__c!=null && addr.Province__c!='')
                                  acc.Primary_Address__c +=' '+ addr.Province__c;
                             if(addr.Country__c!=null && addr.Country__c!='')
                                  acc.Primary_Address__c +=' '+ addr.Country__c;
                             if(addr.ZipCode__c!=null && addr.ZipCode__c!='')
                                  acc.Primary_Address__c +=' '+ addr.ZipCode__c;   
                            
                           updateAccntMap.put(acc.Id, acc);
                        }
                   } 
                  if(updateAccntMap.containsKey(acc.Id) && acc.Id != null)
                    {
                        updateAccntList.add(updateAccntMap.get(acc.Id));
                    }
              }                 
          }
      }
        if(updateAccntList != null && !updateAccntList.isEmpty())  
        {
             update updateAccntList;
        }
     
    } 
    
    @Future(callout=true)
    public static void entityNotifyUpdate(string updateType,String sfdcId,string serlializedObject)
    {
        string orgId=UserInfo.getOrganizationId();
        string sfdcTypeName='Address__c';
        string sfdcMarketDiscriminator='AU';
        if(!test.isrunningtest())
            UtilWebService.entityUpdateNotification(orgId,sfdcId,sfdcTypeName,sfdcMarketDiscriminator,updateType,serlializedObject);
    } 
}