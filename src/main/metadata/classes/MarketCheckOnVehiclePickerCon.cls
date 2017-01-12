public with sharing class MarketCheckOnVehiclePickerCon{

    public user usr{get;set;}
    public boolean marketChecker{get;set;}
    public MarketCheckOnVehiclePickerCon(ApexPages.StandardController con){
        usr = [select id, Market__c from user where id=: userInfo.getUserId()];
        if(usr.Market__c == 'KR'){
            marketChecker = true;
        }else{
            marketChecker = false;
        }
    }

}