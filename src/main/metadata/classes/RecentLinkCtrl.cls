/************************************************************************************
* Created By:Anwesh k
* Created Date:07-July-18
* Company:Infosys Ltd
* Description: Used in RecentLinks lightning component to get the latest 5 links.
*************************************************************************************/
public class RecentLinkCtrl {
    @AuraEnabled
    public static List<Link__c> getRecentLinks (){  
        List<Link__c> linkList = new List<Link__c>();
        linkList = [SELECT id,Name,URL__c FROM Link__c ORDER BY CreatedDate desc limit 5];        
        return linkList;
    }
}