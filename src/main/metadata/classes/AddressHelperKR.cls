/*
    Type:      class
    Purpose:   1.update Primary_Address_Display__c field on account on update of address(updatePrimaryAddressOnAccount)
    Create By: Sampath Reddy
*/
public with sharing class AddressHelperKR {    
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
                             acc.Primary_Address_Display__c=add.Province__c+add.City__c+add.District__c+add.HouseNumber__c+add.Address_Line_1__c+add.Address_Line_2__c;
                             accountList.add(acc);
                     }
                 }
             }
        
            if(!accountList.isEmpty()||accountList!=null)
            {
              update accountList; 
            }                
    
      }
      
       @Future(callout=true)
    public static void entityNotifyUpdate(string updateType,String sfdcId,string serlializedObject)
    {
        string sfdcMarketDiscriminator = 'KR';
        string orgId=UserInfo.getOrganizationId();
       
        string sfdcTypeName='Address__c';
        if(!test.isrunningtest())
            
            UtilWebService.entityUpdateNotification(orgId,sfdcId,sfdcTypeName,sfdcMarketDiscriminator,updateType,serlializedObject);
        
        System.debug('@@@ orgId'+ orgId +'@@@@@@ sfdcTypeName'+ sfdcTypeName +'@@ updateType'+updateType +'### sfdcId'+sfdcId +'$$$$$$ serlializedObject'+serlializedObject+'@@@@ sfdcMarketDiscriminator'+sfdcMarketDiscriminator);
    }
      
}