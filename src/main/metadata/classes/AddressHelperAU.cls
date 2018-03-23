/*
    Type:      class
    Purpose:   1.Validates SameAddressType (validateSameAddressType)
               2.update Primary_Address_Display__c field on account on update of address(updatePrimaryAddressOnAccount)
    Create By: Honey
*/
public with sharing class AddressHelperAU {

    public static void updateAddressOnAccount(list<Address__c> listNewAddress){
        AddressHelperBase.updateAddressOnAccount(listNewAddress);
    } 

    public static void validateSameAddressType(List<Address__c> triggerNew,map<id,Address__c> addressOldMap,boolean isInsert,boolean isUpdate){
        AddressHelperBase.validateSameAddressType(triggerNew,addressOldMap,isInsert,isUpdate,System.Label.AU);
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
    
    /* Data Migration Explicit Fix - Santosh Mohanty */
    public static void updatemarket(List<Address__c> addList){                   
        AddressHelperBase.updatemarket(addList);                    
    }
  public static void updateAddressRetailCopies(map<ID,Address__c> newMap, string MarketDiscriminator){
    AddressHelperBase.updateAddressRetailCopies(newMap, MarketDiscriminator);
  }
}