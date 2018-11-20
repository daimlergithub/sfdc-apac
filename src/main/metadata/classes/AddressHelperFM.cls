/*
    Type:      class
    Purpose:   1.Validates SameAddressType (validateSameAddressType)
               2.update Primary_Address_Display__c field on account on update of address(updatePrimaryAddressOnAccount)
    Create By: Shashi 
*/
public with sharing class AddressHelperFM {

    public static void updatemarket(List<Address__c> addList){
        for(Address__c addr : addList){
            addr.MD__c =addr.Market__c;  
        }        
    }
    
    public static void updateAddressOnAccount(list<Address__c> listNewAddress){
        AddressHelperBase.updateAddressOnAccount(listNewAddress);
    } 

    //@Description: Gives error message if we try to enter Address with same  Address_Type__c for an account
    public static void validateSameAddressType(List<Address__c> triggerNew,map<id,Address__c> addressOldMap,boolean isInsert,boolean isUpdate, string Market){
        AddressHelperBase.validateSameAddressType(triggerNew,addressOldMap,isInsert,isUpdate,Market);
    }
    
    public static void updatePrimaryAddressOnAccount(map<ID,Address__c> newMap){
        AddressHelperBase.updatePrimaryAddressOnAccount(newMap);
    }

    public static void updateAccountonDeletion(List<Address__c> OldAddress){
        AddressHelperBase.updateAccountonDeletion(OldAddress);
    }

    public static void updateAddressCDM(List<Address__c> Address, string Market, string updateType){
        AddressHelperBase.updateAddressCDM(Address,Market,updateType);
    }
    
    public static void updateAddressRetailCopies(map<ID,Address__c> newMap, string MarketDiscriminator){
		AddressHelperBase.updateAddressRetailCopies(newMap, MarketDiscriminator);
	}
}