public with sharing class MarketCheckOnVehiclePickerConKR{

    public user usr{get;set;}
    public boolean marketChecker{get;set;}
    public MarketCheckOnVehiclePickerConKR(ApexPages.StandardController con){
        usr = [select id, Market__c from user where id=: userInfo.getUserId()];
        
    }

}