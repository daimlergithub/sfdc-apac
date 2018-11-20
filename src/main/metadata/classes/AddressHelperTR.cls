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
        Map<String,string> countryMap = new map<string,string>();
     for(CountryTranslation__mdt cmdt: [select id, Country__c,Country_Translation__c,Market__c from CountryTranslation__mdt where Market__c=:Label.TR])
     {
        countryMap.put(cmdt.Country__c,cmdt.Country_Translation__c);
     }
        for(Address__c addr : listNewAddress){
            if(addr.preferred__c)
                AccIdSet.add(addr.Customer__c);
        } 
        if(AccIdSet!=null && !AccIdSet.isEmpty()){
            List<Account> accList = [select id,Primary_Address_Display__c,Primary_Address_Reference__c,Market__C from Account where id in : AccIdSet Limit 10];     
            if(accList!=null && !accList.isEmpty()){
                for(Account acc : accList){  
                    for(Address__c addr : listNewAddress){
                        if(acc.Id==addr.Customer__c){
                             if(addr.Country__c != null && countryMap != null && countryMap.containskey(addr.Country__c))
                                acc.Primary_Address_Display__c = addr.Address_Line_1__c + ' ' + addr.Address_Line_2__c+' '+addr.City__c+' '+addr.Province__c + ' ' +addr.District__c+' '+addr.Zipcode__c+countryMap.get(addr.Country__c);                  
                             else 
                                acc.Primary_Address_Display__c = addr.Address_Line_1__c + ' ' + addr.Address_Line_2__c+' '+addr.City__c+' '+addr.Province__c + ' ' +addr.District__c+' '+addr.Zipcode__c+' '+addr.Country__c;                  
                            system.debug(addr.Preferred__c+addr.Market__c);
                            if(addr.Preferred__c ==True && addr.Market__c=='TR')
                                acc.Primary_Address_Reference__c =addr.Id; 
                            acc.Primary_Address_Display__c =  acc.Primary_Address_Display__c.replaceAll('null','');                              
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
        try{
            DMLManagerService.updateAsSystem(updateAccntList);  
            }
            catch(Exception e)
            {    
                system.debug('exception --> '+e);
            }
            //update updateAccntList;
        }
    } 

    public static void validateSameAddressType(List<Address__c> triggerNew,map<id,Address__c> addressOldMap,boolean isInsert,boolean isUpdate){
       set<id> accountId = new set<id>(); 
        if(IsInsert){                
            //get the related accountIds
            for(Address__c add:triggerNew){
                accountId.add(add.Customer__c);
            }
            
            
            for(Address__c addresList:[select Address_Type__c,customer__c from Address__c where Customer__c IN:accountId]){
                for(Address__c addType:triggerNew){
                    if(
                        (addType.MD__c==System.Label.TR)&& 
                        (addType.Address_Type__c=='Home' ||addType.Address_Type__c=='Business') && 
                        (addresList.Address_Type__c==addType.Address_Type__c)
                    ){                   
                        addType.Address_Type__c.adderror(Label.AddressType_Validation);                               
                    }
               
                }
            }
        
        }
        if(isUpdate){
            for(Address__c add:triggerNew){                 
                Address__c oldaddress = addressOldMap.get(add.Id);                     
                if(oldaddress.Address_Type__c!= add.Address_Type__c){
                    accountId.add(add.Customer__c);                         
                }
            }
            for(Address__c addresList:[select Address_Type__c from Address__c where Customer__c IN:accountId]){
                for(Address__c addType:triggerNew){
                    if((addType.MD__c==System.Label.TR)&& (addType.Address_Type__c=='Home' ||addType.Address_Type__c=='Business') && 
                    ((addresList.Address_Type__c==addType.Address_Type__c)&&(addType.Address_Type__c!=null))){                                           
                        addType.Address_Type__c.adderror(Label.AddressType_Validation);
                    }
                }                
            }
        }
    } 

        public static void updatePrimaryAddressOnAccount(map<ID,Address__c> newMap){
        set<id> accountId = new set<id>();  
        list<Account> accountList = new list<Account>();
        Map<String,string> countryMap = new map<string,string>();
        for(CountryTranslation__mdt cmdt: [select id, Country__c,Country_Translation__c,Market__c from CountryTranslation__mdt where Market__c=:Label.TR])
        {
            countryMap.put(cmdt.Country__c,cmdt.Country_Translation__c);
        }
        //get the related accountIds
        for(Address__c add:newMap.values()){
            accountId.add(add.Customer__c);
        } 
        for(Account acc:[select id,Primary_Address_Reference__c,market__c from Account where id IN:accountId]){
            if((acc.Primary_Address_Reference__c!=null)&&(newMap.containsKey(acc.Primary_Address_Reference__c))){
                if(newMap.get(acc.Primary_Address_Reference__c).Customer__c==acc.id){
                    Address__c add = newMap.get(acc.Primary_Address_Reference__c);
                    acc.Primary_Address_Display__c=add.Address_Line_1__c+add.Address_Line_2__c+add.zipcode__c+add.District__c+add.Province__c+add.City__c+add.Country__c;
                    if(add.Country__c != null && countryMap != null && countryMap.containskey(add.Country__c))
                        acc.Primary_Address_Display__c = add.Address_Line_1__c + ' ' + add.Address_Line_2__c+' '+add.City__c+' '+add.Province__c + ' ' +add.District__c+' '+add.Zipcode__c+' ' +countryMap.get(add.Country__c);                  
                    else 
                        acc.Primary_Address_Display__c = add.Address_Line_1__c + ' ' + add.Address_Line_2__c+' '+add.City__c+' '+add.Province__c + ' ' +add.District__c+' '+add.Zipcode__c+' ' +add.Country__c;                  
                    acc.Primary_Address_Display__c =  acc.Primary_Address_Display__c.replaceAll('null','');   
                    system.debug('-----'+acc.Primary_Address_Display__c);
                    accountList.add(acc);
                }
            }
        }
        if(!accountList.isEmpty()||accountList!=null){
        try{
            DMLManagerService.updateAsSystem(accountList);  
            }
            catch(Exception e)
            {
                system.debug('exception ---> '+e);
            }
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