/*
    Type:      class
    Purpose:   1.Validates SameAddressType (validateSameAddressType)
               2.update Primary_Address_Display__c field on account on update of address(updatePrimaryAddressOnAccount)
    Create By: Sriram kalluri
*/
public with sharing class AddressHelperJP {
       
            
       /**             
        * @Description: Gives arror message if we try to enter Address with same  Address_Type__c for an account
        * @author     : sriram kalluri
        * @Date       : 12/14/2015
        * @param      : list of new addresses 
        * @return     : void
        * @see:       : AddressHelperJP
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
                            if(((addresList.Address_Type__c==addType.Address_Type__c)&&(addType.Address_Type__c!=null))&&(addType.MD__c=='JP')||((addType.MD__c=='KR')&& (addType.Address_Type__c=='Home' ||addType.Address_Type__c=='Business') && ((addresList.Address_Type__c==addType.Address_Type__c)&&(addType.Address_Type__c!=null))))
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
                            if(((addresList.Address_Type__c==addType.Address_Type__c)&&(addType.Address_Type__c!=null))&&(addType.MD__c=='JP')||((addType.MD__c=='KR')&& (addType.Address_Type__c=='Home' ||addType.Address_Type__c=='Business') && ((addresList.Address_Type__c==addType.Address_Type__c)&&(addType.Address_Type__c!=null))))
                            {                  
                            addType.Address_Type__c.adderror(Label.AddressType_Validation);
                            }
                        }
                
                    }
                } 
            } 
      
       /**             
        * @Description: update Primary_Address_Display__c field on account on update of address
        * @author     : sriram kalluri
        * @Date       : 1/10/2016
        * @param      : list of new addresses 
        * @return     : void
        * @see:       : AddressHelperJP
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
        * @see:       : AddressHelperJP
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
    @Future(callout=true)
    public static void entityNotifyUpdate(string updateType,String sfdcId,string serlializedObject)
    {
        string sfdcMarketDiscriminator = 'JP';
        string orgId=UserInfo.getOrganizationId();
       
        string sfdcTypeName='Address__c';
        if(!test.isrunningtest())
            
            UtilWebService.entityUpdateNotification(orgId,sfdcId,sfdcTypeName,sfdcMarketDiscriminator,updateType,serlializedObject);
        
        System.debug('@@@ orgId'+ orgId +'@@@@@@ sfdcTypeName'+ sfdcTypeName +'@@ updateType'+updateType +'### sfdcId'+sfdcId +'$$$$$$ serlializedObject'+serlializedObject+'@@@@ sfdcMarketDiscriminator'+sfdcMarketDiscriminator);
    }
    
}