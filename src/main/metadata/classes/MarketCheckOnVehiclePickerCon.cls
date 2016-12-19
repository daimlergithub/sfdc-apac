public with sharing class MarketCheckOnVehiclePickerCon{

    public user usr{get;set;}
    public MarketCheckOnVehiclePickerCon(ApexPages.StandardController con){
        usr = [select id, Market__c from user where id=: userInfo.getUserId()];
    }

}