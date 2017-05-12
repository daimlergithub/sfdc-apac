public class shareAccountRecord
{
    public static Id dealerRecordTypeId = Schema.SObjectType.Account.getRecordtypeInfosByName().get('Dealer').getRecordTypeId();
    public static void shareAccountRecordNow(List<Id> caseIds)
    {
        List<User> gateKeeperList = new List<User>();
        map<id, id> caseCustAccId = new map<id, id>();
        map<string, id> caseDealerAccName = new map<string, id>();
        List<Id> dealerAccIds = new List<Id>();
        set<Id> dealerCompanyIds = new set<id>();
        set<string> allDealerNdCode = new set<string>();
        set<string> dealerGCCodeSet = new set<string>();
        Set<String> DealerNDCode= new Set<String>();
        List<Account> dealerAccountList = new List<Account>();
        map<string, Id> dealerAccNameCustomerAccid = new map<string, Id>();
        map<string, Id> groupCaseMap = new map<string, Id>();
        List<AccountShare> accShrLst = new List<AccountShare>();
        List<CaseShare> caseShrLst = new List<CaseShare>();
        Map<Id, Id> dealerIdGateKeeperIds = new Map<Id, Id>(); 
        List<case> caseUpdLst = new List<case>();
        List<Group> companyGroupList = new List<Group>();
        List<case> lstCase = new List<case>([select id,Case_Dealer__c, AccountId,Ownerid,Case_Dealer__r.Dealer_ND_Code__c,Case_Dealer__r.Dealer_Type__c,
                                             Case_Dealer__r.Dealer_GC_Code__c,Case_Dealer__r.ParentId from case where id in: caseIds]);
        for(case cs: lstCase)
        {
            if(string.valueOf(cs.Case_Dealer__c) != '' && string.valueOf(cs.AccountId)!= '')
            {
                if(cs.Case_Dealer__r.Dealer_Type__c != null && cs.Case_Dealer__r.Dealer_Type__c != '' && cs.Case_Dealer__r.Dealer_Type__c == 'Outlet')
                {
                    dealerCompanyIds.add(cs.Case_Dealer__r.ParentID);
                }
                caseDealerAccName.put(cs.Case_Dealer__r.Dealer_GC_Code__c, cs.AccountId);
                caseCustAccId.put(cs.id, cs.AccountId);
                dealerAccIds.add(cs.Case_Dealer__c);
                dealerGCCodeSet.add(cs.Case_Dealer__r.Dealer_GC_Code__c);
            }
        }
        system.debug('dealerGCCodeSet>>>>' + dealerGCCodeSet);
        system.debug('caseDealerAccName PSM '+ caseDealerAccName);
        system.debug('caseCustAccId PSM '+ caseCustAccId);
        if(!dealerCompanyIds.isEmpty() && dealerCompanyIds != null)
        {
            dealerAccountList = [select id,Dealer_ND_Code__c,Dealer_Type__c from Account where id =:dealerCompanyIds];
        }
        for(case cas: lstCase)
        {
            if(cas.Case_Dealer__r.Dealer_Type__c == 'Company')
            {
                if(cas.Case_Dealer__r.Dealer_ND_Code__c != null && cas.Case_Dealer__r.Dealer_ND_Code__c != '')
                {
                    DealerNDCode.add(cas.Case_Dealer__r.Dealer_ND_Code__c);
                    groupCaseMap.put(cas.Case_Dealer__r.Dealer_ND_Code__c, cas.Id);
                }
            }
            else if(!dealerAccountList.isEmpty() && dealerAccountList != null)
            {
                for(Account parntacc: dealerAccountList)
                {
                    if(cas.Case_Dealer__r.ParentId == parntacc.id && cas.Case_Dealer__r.Dealer_Type__c == 'Outlet')
                    {
                        if(parntacc.Dealer_ND_Code__c != null && parntacc.Dealer_ND_Code__c != '')
                        {
                            DealerNDCode.add(parntacc.Dealer_ND_Code__c);
                            groupCaseMap.put(parntacc.Dealer_ND_Code__c, cas.Id);
                        }
                    }
                }
            }
        }
        if(!DealerNDCode.isEmpty() && DealerNDCode != null)
        {
            companyGroupList = [select id, Name from Group where Name in:DealerNDCode];
        }
        system.debug('DelarNDCode>>>>>' + DealerNDCode);
        system.debug('dealerAccNameCustomerAccid PSM '+ dealerAccNameCustomerAccid);
        List<Account> caseDealerAccountLst = new List<Account>([select id, Name, Dealer_GC_Code__c,Dealer_ND_Code__c from Account where RecordTypeId =:dealerRecordTypeId]);
        List<Account> accPartnerLst = new List<Account>([select id, Name from Account where id in: caseCustAccId.values()]);
        if(!caseDealerAccountLst.isEmpty() && caseDealerAccountLst != null)
        {
            for(case cse: lstCase)
            {
                for(Account allacc : caseDealerAccountLst)
                {
                    if(cse.case_Dealer__r.Dealer_GC_Code__c == allacc.Dealer_GC_Code__c)
                    {
                        allDealerNdCode.add(allacc.Dealer_ND_Code__c);
                    }
                }
            }
        }
        List<Group> grpLst = new List<Group>([select id, Name from Group where Name in: allDealerNdCode]);
        system.debug('grpLst>>>>' + grpLst);
        if(!dealerAccIds.isEmpty() && dealerAccIds != null)
        {
            gateKeeperList= [select Id, AccountId,contactId,Contact.AccountId from User where isActive = true and AccountId in :dealerAccIds and Contact.Dealer_Lead_Gate_Keeper__c = true];       
        }
        system.debug('gateKeeperList>>>>' + gateKeeperList);
        system.debug('companyGroupList>>>>' + companyGroupList);

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
        for(Case Cashre :lstCase)
        {
            if(grpLst.size()>0)
            {
                for(Group grp: grpLst)
                {   
                    AccountShare ash = new AccountShare();
                    ash.AccountAccessLevel = 'Read';
                    ash.OpportunityAccessLevel = 'None';
                    ash.CaseAccessLevel = 'None';
                    ash.AccountId = cashre.AccountId;
                    ash.UserOrGroupId = grp.id;
                    accShrLst.add(ash);
                }
            }
            if(!companyGroupList.isEmpty() && companyGroupList != null)
            {
                for(Group grpShr : companyGroupList)
                {
                    CaseShare cseshr = new CaseShare();
                    cseshr.CaseId = cashre.Id;
                    cseshr.CaseAccessLevel = 'Edit';
                    cseshr.UserOrGroupId = grpShr.id;
                    caseShrLst.add(cseshr);
                }
            }
        }
        system.debug('accShrLst PSM '+ accShrLst);
        if(accShrLst.size()>0)
        {
            system.debug('PSM inside insert');
            insert accShrLst;
        }
        system.debug('caseShrLst>>>> '+ caseShrLst);
        if(!caseShrLst.isEmpty() && caseShrLst != null)
        {
            insert caseShrLst;
        }
    }
}