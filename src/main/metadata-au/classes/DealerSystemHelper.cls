/*
    Type:       Utility for Dealer System trigger
	Purpose:    Share dealer system record with dealer groups
	Created By: Sudhir
*/


public with sharing class DealerSystemHelper 
{
	public static void shareWithDealer(List<Dealer_System__c> dealList)
    {
        set<id> dsId = new set<Id>();
        set<string> grpName = new set<string>();
        List<Group> groupList = new List<Group>();
        map<string,id> groupMap = new map<string,id>();
        List<Dealer_System__c> dealsysList = new List<Dealer_System__c>();
        List <Dealer_System__Share> shareDsList = new List<Dealer_System__Share>();
        for(Dealer_System__c deal : dealList)
        {
            if(deal.Dealer__c != null)
            {
                dsId.add(deal.Dealer__c);
            }
        }
        if(!dsId.isEmpty() && dealsysList != null)
        {
            dealsysList = [select id, Customer_No__c, Dealer__c, Dealer__r.Name from Dealer_System__c where Dealer__c =:dsId];
        }
        for(Dealer_System__c ds : dealsysList)
        {
            grpName.add(ds.Dealer__r.Name);
        }
        if(!grpName.isEmpty() && grpName != null)
        {
            groupList = [select id ,DeveloperName ,Name ,Type from Group where Name =:grpName];
        }
		if(!groupList.isEmpty() && groupList != null)
        {
            for(Group g : groupList)
            {
            	groupMap.put(g.Name, g.id);
            }
        }
        for(Dealer_System__c shrDs : dealsysList)
        {
         	Dealer_System__Share shareds = new Dealer_System__Share();
            shareds.ParentId = shrDs.Id;
            shareds.UserOrGroupId = groupMap.get(shrDs.Dealer__r.Name);
            shareds.AccessLevel = 'Edit';
            shareDsList.add(shareds);
        }
        if(!shareDsList.isEmpty() && shareDsList != null)
        {
            insert shareDsList;
        }
    }
}