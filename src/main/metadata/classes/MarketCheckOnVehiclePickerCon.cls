public with sharing class MarketCheckOnVehiclePickerCon{

    public user usr{get;set;}
    public boolean marketChecker{get;set;}
    public boolean marketCheckerTH{get;set;}
    public boolean marketChecker2{get;set;}
    
    public MarketCheckOnVehiclePickerCon(ApexPages.StandardController con){
        usr = [select id, Market__c from user where id=: userInfo.getUserId()];
        if(usr.Market__c == 'KR'){
            marketChecker = true;  
        }
        else if(usr.Market__c == System.label.MarketTH){
            marketCheckerTH= true; 
        }
        else if(usr.Market__c == 'JP'){
            marketChecker2= true;  
        }    
    }
}