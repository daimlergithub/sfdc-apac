/*
    Type:      class
    Purpose:   1.Validates SameAddressType 
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
            public static void validateSameAddressType(List<Address__c> triggerNew){
                set<id> accountId = new set<id>();        
                for(Address__c add:triggerNew){
                    accountId.add(add.Customer__c);
                }        
                           
                for(Address__c addresList:[select Address_Type__c from Address__c where Customer__c IN:accountId]){
                    for(Address__c addType:triggerNew){
                        if((addresList.Address_Type__c==addType.Address_Type__c)&&(addType.Address_Type__c!=null)){                  
                           addType.Address_Type__c.adderror(Label.AddressType_Validation);
                        }
                    }
                
                }
            
            }
    
}