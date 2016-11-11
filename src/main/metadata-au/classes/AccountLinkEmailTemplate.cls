/*
Type    : Apex class on Account Link
Purpose : To get the account link fields to display visualforce email template through AccountLinkComponent
Created Date : 18th Oct, 2016
*/
public class AccountLinkEmailTemplate {
    public Id accLinkId {get;set;}
    public list<Account_Link__c> accLinkList;
    
    public list<Account_Link__c> getaccLinkList(){
        accLinkList = [SELECT name,System__c FROM Account_Link__c WHERE system__c = 'MBOnline' AND toRole__c = : accLinkId];
        return accLinkList;
    }
    
}