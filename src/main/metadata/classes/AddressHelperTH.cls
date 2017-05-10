/*
    Type:      class
    Purpose:   1.Validates SameAddressType (validateSameAddressType)
               2.update Primary_Address_Display__c field on account on update of address(updatePrimaryAddressOnAccount)
    Create By: Mohammed Touseef Ahmed
*/
public with sharing class AddressHelperTH {
    
     /**             
        * @Description: Updates Primary Address related details on account once Preferred__c is checked.
       * @author     : Mohammed Touseef Ahmed
        * @Date       : 02/07/2017
        * @param      : list of new addresses 
        * @return     : void
        * @see:       : AddressHelperTH
        */
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
          List<Account> accList = [select id,Primary_Address__c from Account where id in : AccIdSet Limit 10];     
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
    
    /**             
        * @Description: Gives arror message if we try to enter Address with same  Address_Type__c for an account
        * @author     : Mohammed Touseef Ahmed
        * @Date       : 02/07/2017
        * @param      : list of new addresses 
        * @return     : void
        * @see:       : AddressHelperTH
        */
            public static void validateSameAddressType(List<Address__c> triggerNew,map<id,Address__c> addressOldMap,boolean isInsert,boolean isUpdate)
            {                
               set<id> accountId = new set<id>(); 
               if(IsInsert)
               {                
                //get the related accountIds
                for(Address__c add:triggerNew){
                    accountId.add(add.Customer__c);
                }                   
                
                    for(Address__c addresList:[select Address_Type__c from Address__c where Customer__c IN:accountId]){
                        for(Address__c addType:triggerNew)
                        {
                            if(
                                (addType.MD__c==Label.TH)&& 
                                (addType.Address_Type__c=='Home' ||addType.Address_Type__c=='Business') && 
                                (addresList.Address_Type__c==addType.Address_Type__c)
                            )
                            {                   
                                addType.Address_Type__c.adderror(Label.AddressType_Validation);                               
                            }
                        }
                
                    }
            
                }
                if(isUpdate)
                {
                    for(Address__c add:triggerNew)
                    {                 
                        Address__c oldaddress = addressOldMap.get(add.Id);                     
                        if(oldaddress.Address_Type__c!= add.Address_Type__c)
                        {
                            accountId.add(add.Customer__c);                         
                        }
                    }
                    for(Address__c addresList:[select Address_Type__c from Address__c where Customer__c IN:accountId]){
                        for(Address__c addType:triggerNew)
                        {
                            if((addType.MD__c==Label.TH)&& (addType.Address_Type__c=='Home' ||addType.Address_Type__c=='Business') && 
                                ((addresList.Address_Type__c==addType.Address_Type__c)&&(addType.Address_Type__c!=null)))
                            {                                           
                                addType.Address_Type__c.adderror(Label.AddressType_Validation);
                            }
                        }                
                    }
                } 
            } 
      
       /**             
        * @Description: update Primary_Address_Display__c field on account on update of address
          * @author     : Mohammed Touseef Ahmed
        * @Date       : 02/07/2017
        * @param      : list of new addresses 
        * @return     : void
        * @see:       : AddressHelperTH
        */
    
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
                                 Address__c add =newMap.get(acc.Primary_Address_Reference__c);
                                 acc.Primary_Address_Display__c=add.Province__c+add.City__c+add.District__c+add.Block__c+add.Address_Line_1__c+add.Address_Line_2__c;
                                 accountList.add(acc);
                         }
                     }
                 }
            
                if(!accountList.isEmpty()||accountList!=null)
                {
                  update accountList; 
                }
                 
        
          }
          
           /**             
        * @Description: update Account on Delete of address       
        * @Date       : 15/11/2016
        * @param      : list of old addresses 
        * @return     : void
        * @see:       : AddressHelperTH
        */
    
       public static void updateAccountonDeletion(List<Address__c> OldAddress){         
                 set<id> accountId = new set<id>();  
                 list<Account> accountList = new list<Account>();                  
                 //get the related accountIds
                 for(Address__c add:OldAddress){
                        accountId.add(add.Customer__c);
                        System.debug('Customer__c'+accountId);
                  } 
          
                 for(Account acc:[select id,Primary_Address_Reference__c,Customer_LastUpdatedDate__c from Account where id IN:accountId]){
                    acc.Customer_LastUpdatedDate__c = Datetime.now();
                    System.debug('Customer__date'+acc.Customer_LastUpdatedDate__c);
                         accountList.add(acc);
                }                  
            
                if(!accountList.isEmpty()||accountList!=null)
                {
                  update accountList; 
                }
                 
        
          }
    
}