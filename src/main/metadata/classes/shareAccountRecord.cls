public class shareAccountRecord
{    
    @future 
    public static void shareAccountRecordNow(List<Id> caseIds)
    {
        List<User> gateKeeperList = new List<User>();
        map<id, id> caseCustAccId = new map<id, id>();
        map<id, string> caseDealerAccName = new map<id, string>();
        List<Id> dealerAccIds = new List<Id>();
        map<string, Id> dealerAccNameCustomerAccid = new map<string, Id>();
        List<AccountShare> accShrLst = new List<AccountShare>();
        Map<Id, Id> dealerIdGateKeeperIds = new Map<Id, Id>(); 
        List<case> caseUpdLst = new List<case>();
        List<case> lstCase = new List<case>([select id,Case_Dealer__c, AccountId,Ownerid,Case_Dealer__r.Name from case where id in: caseIds]);
        for(case cs: lstCase)
        {
            if(string.valueOf(cs.Case_Dealer__c) != '' && string.valueOf(cs.AccountId)!= '')
            {
                caseDealerAccName.put(cs.id, cs.Case_Dealer__r.Name);
                caseCustAccId.put(cs.id, cs.AccountId);
                dealerAccIds.add(cs.Case_Dealer__c);
            }
        }
        system.debug('caseDealerAccName PSM '+ caseDealerAccName);
        system.debug('caseCustAccId PSM '+ caseCustAccId);
        for(case cs: lstCase)
        {
            dealerAccNameCustomerAccid.put(caseDealerAccName.get(cs.id), caseCustAccId.get(cs.id));
        }
        system.debug('dealerAccNameCustomerAccid PSM '+ dealerAccNameCustomerAccid);
        List<Account> caseDealerAccountLst = new List<Account>([select id, Name from Account where id in: dealerAccIds and RecordType.Name = 'Dealer']);
        List<Account> accPartnerLst = new List<Account>([select id, Name from Account where id in: caseCustAccId.values()]);
        List<Group> grpLst = new List<Group>([select id, Name from Group where Name in: caseDealerAccName.values()]);
        if(!dealerAccIds.isEmpty() && dealerAccIds != null)
        {
            gateKeeperList= [select Id, AccountId,contactId,Contact.AccountId from User where isActive = true and AccountId in :dealerAccIds and Contact.Dealer_Lead_Gate_Keeper__c = true];       
        }
        system.debug('gateKeeperList>>>>' + gateKeeperList);
        if(grpLst.size()>0)
        {
            for(Group grp: grpLst)
            {
                
                AccountShare ash = new AccountShare();
                ash.AccountAccessLevel = 'Read';
                ash.OpportunityAccessLevel = 'Read';
                ash.CaseAccessLevel = 'Edit';
                ash.AccountId = dealerAccNameCustomerAccid.get(grp.Name);
                ash.UserOrGroupId = grp.id;
                accShrLst.add(ash);
            }
            system.debug('accShrLst PSM '+ accShrLst);
            if(accShrLst.size()>0)
            {
                system.debug('PSM inside insert');
                insert accShrLst;
            }
            
        }
        
        for(User usr : gateKeeperList)
        {
            dealerIdGateKeeperIds.put(usr.AccountId, usr.Id);
        }
        
        for(Case cs : lstCase)
        {            
            if(dealerIdGateKeeperIds.containsKey(cs.Case_Dealer__c))
            {
                cs.ownerid = dealerIdGateKeeperIds.get(cs.Case_Dealer__c); 
                caseUpdLst.add(cs);
            }            
        }
        if(caseUpdLst.size()>0)
        {
            TriggerCaseTriggerHandlerKR.isFutureUpdate = true;
            update caseUpdLst;
        }
    }
    
}