/*
    Type:      class
    Purpose:   1.Validates SameAddressType (validateSameAddressType)
               2.update Primary_Address_Display__c field on account on update of address(updatePrimaryAddressOnAccount)
    Create By: Hildaa
*/
public with sharing class AddressHelperTR {

    public static void updateAddressOnAccount(list<Address__c> listNewAddress){
        Set<Id> AccIdSet = new Set<Id>();
        map<Id,Account> updateAccntMap = new map<Id,Account>();
        list<Account> updateAccntList = new list<Account>();
        for(Address__c addr : listNewAddress){
            if(addr.preferred__c)
                AccIdSet.add(addr.Customer__c);
        } 
        if(AccIdSet!=null && !AccIdSet.isEmpty()){
            List<Account> accList = [select id,Primary_Address_Display__c,Primary_Address_Reference__c from Account where id in : AccIdSet Limit 10];     
            if(accList!=null && !accList.isEmpty()){
                for(Account acc : accList){  
                    for(Address__c addr : listNewAddress){
                        if(acc.Id==addr.Customer__c){
                            if(addr.Address_Line_1__c!=null && addr.Address_Line_1__c!='')
                                acc.Primary_Address_Display__c = addr.Address_Line_1__c;
                            if(addr.Address_Line_2__c!=null && addr.Address_Line_2__c!='')  
                                acc.Primary_Address_Display__c +=' '+ addr.Address_Line_2__c;
              if(addr.City__c!=null && addr.City__c!='')
                                acc.Primary_Address_Display__c +=' '+ addr.City__c;
                            if(addr.Province__c!=null && addr.Province__c!='')
                                acc.Primary_Address_Display__c +=' '+ addr.Province__c;
              if(addr.District__c!=null && addr.District__c!='')
                                acc.Primary_Address_Display__c +=' '+ addr.District__c;
              
                            if(addr.Country__c!=null && addr.Country__c!='')
                                acc.Primary_Address_Display__c +=' '+ addr.Country__c;
                            if(addr.ZipCode__c!=null && addr.ZipCode__c!='')
                                acc.Primary_Address_Display__c +=' '+ addr.ZipCode__c; 
                            system.debug(addr.Preferred__c+addr.Market__c);
                            if(addr.Preferred__c ==True && addr.Market__c=='TR')
                                acc.Primary_Address_Reference__c =addr.Id; 
                                                           
                            updateAccntMap.put(acc.Id, acc);
                        }
                    } 
                    if(updateAccntMap.containsKey(acc.Id) && acc.Id != null){
                        updateAccntList.add(updateAccntMap.get(acc.Id));
                    }
                }                 
            }
        }
        if(updateAccntList != null && !updateAccntList.isEmpty()){
            DMLManagerService.updateAsSystem(updateAccntList);  
            //update updateAccntList;
        }
    } 

    public static void validateSameAddressType(List<Address__c> triggerNew,map<id,Address__c> addressOldMap,boolean isInsert,boolean isUpdate){
        AddressHelperBase.validateSameAddressType(triggerNew,addressOldMap,isInsert,isUpdate,System.Label.MarketMY);
    } 

        public static void updatePrimaryAddressOnAccount(map<ID,Address__c> newMap){
        set<id> accountId = new set<id>();  
        list<Account> accountList = new list<Account>();
        //get the related accountIds
        for(Address__c add:newMap.values()){
            accountId.add(add.Customer__c);
        } 
        for(Account acc:[select id,Primary_Address_Reference__c from Account where id IN:accountId]){
            if((acc.Primary_Address_Reference__c!=null)&&(newMap.containsKey(acc.Primary_Address_Reference__c))){
                if(newMap.get(acc.Primary_Address_Reference__c).Customer__c==acc.id){
                    Address__c add = newMap.get(acc.Primary_Address_Reference__c);
                    acc.Primary_Address_Display__c=add.Province__c+add.City__c+add.District__c+add.Address_Line_1__c+add.Address_Line_2__c;
                    accountList.add(acc);
                }
            }
        }
        if(!accountList.isEmpty()||accountList!=null){
            DMLManagerService.updateAsSystem(accountList);  
            //update accountList; 
        }
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
}