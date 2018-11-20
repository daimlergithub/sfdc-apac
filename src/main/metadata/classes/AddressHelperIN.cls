/*
    Type:      class
    Purpose:   1.Validates SameAddressType (validateSameAddressType)
               2.update Primary_Address_Display__c field on account on update of address(updatePrimaryAddressOnAccount)
    Create By: Sravanthi Gudibandi
*/
public with sharing class AddressHelperIN {

    public static void updateAddressOnAccount(list<Address__c> listNewAddress){
        AddressHelperBase.updateAddressOnAccount(listNewAddress);
    } 

    public static void setPreferredFlag(list<Address__c> listNewAddress){
        AddressHelperBase.setPreferredFlag(listNewAddress);
    } 

    public static void validateSameAddressType(List<Address__c> triggerNew,map<id,Address__c> addressOldMap,boolean isInsert,boolean isUpdate){
        AddressHelperBase.validateSameAddressType(triggerNew,addressOldMap,isInsert,isUpdate,System.Label.MarketIN);
    } 

    public static void updatePrimaryAddressOnAccount(map<ID,Address__c> newMap){
        AddressHelperBase.updatePrimaryAddressOnAccount(newMap);
    }

    public static void updateAccountonDeletion(List<Address__c> OldAddress){
        AddressHelperBase.updateAccountonDeletion(OldAddress);
    }

    public static void updateAddressCDM(List<Address__c> Address, string MarketDiscriminator, string updateType){
        AddressHelperBase.updateAddressCDM(Address,MarketDiscriminator,updateType);
    }
    
   
}