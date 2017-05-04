/*
Share case record with Japan Dealer Company Manager,Japan Dealer Sales Manager,Japan Dealer Service Manager,
if this Case record belongs to the dealer user's company and Dealer_Contact__c value as "Yes" and
Dealer_GC_Code_c field value of the Account linked to the "Case_Dealer_c" field of target Case match the Dealer_GC_Code__c and Dealer_GS_Code__c of the target User
*/
public class CaseHelperKR
{
    public static Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static void shareCasewithDealerCompany(List<Case> caseList,Map<Id,Case> caseOldMap)
    {
        List<Case> dealerCaseList = new List<Case>();
        List<account> dealerAccountList =new List<account>();
        set<id> caseId = new set<id>();
        set<id> parentIds = new set<id>();
        Set<String> DealerNDCode= new Set<String>();
        map<string,id> assgroupMap = new map<string,id>();
        List<Group> grplist=new List<Group>();
        List<CaseShare> caseshrList = new List<CaseShare>();
        
        for(Case cse : caseList)
        {
            if(cse.Case_Dealer__c != null && (trigger.isinsert || (trigger.isupdate && cse.OwnerId != caseOldMap.get(cse.Id).OwnerId || cse.Case_Dealer__c != caseOldMap.get(cse.id).Case_Dealer__c)))
            {
                caseId.add(cse.Case_Dealer__c);
            }
        }
        if(!caseId.isEmpty() && caseId != null)
        {
            dealerCaseList = [select id,Case_Dealer__c,Case_Dealer__r.ParentId,Case_Dealer__r.Dealer_ND_Code__c
                              ,Case_Dealer__r.Dealer_Type__c from Case where id =:caseId];
        }
        if(!dealerCaseList.isEmpty() && dealerCaseList != null)
        {
            for(Case cs: dealerCaseList)
            {
                if(cs.Case_Dealer__r.ParentId != null && cs.Case_Dealer__r.Dealer_Type__c == 'Outlet')
                {
                    parentIds.add(cs.Case_Dealer__r.ParentId);
                }
            }
        }
        if(!parentIds.isEmpty() && parentIds != null)
        {
            dealerAccountList = [select id,Dealer_ND_Code__c from Account where id =:parentIds];
        }
        for(Case ca : dealerCaseList)
        {
            if(ca.Case_Dealer__r.Dealer_Type__c == 'Company' && ca.Case_Dealer__r.Dealer_ND_Code__c != null && ca.Case_Dealer__r.Dealer_ND_Code__c != '')
            {
                DealerNDCode.add(ca.Case_Dealer__r.Dealer_ND_Code__c);
            }
            if(!dealerAccountList.isEmpty() && dealerAccountList != null)
            {
                for(Account parntacc: dealerAccountList)
                {
                    if(ca.Case_Dealer__r.ParentId == parntacc.id && ca.Case_Dealer__r.Dealer_Type__c == 'Outlet')
                    {
                        if(parntacc.Dealer_ND_Code__c != null && parntacc.Dealer_ND_Code__c != '')
                        {
                            DealerNDCode.add(parntacc.Dealer_ND_Code__c);
                        }
                    }
                }
            }
        }
        if(!DealerNDCode.isEmpty() && DealerNDCode != null)
        {
            grplist = [select id ,Name ,Type from Group where Name IN: DealerNDCode];
        }
        if(!grplist.isEmpty() && grplist != null)
        {
            for(Group assg:grplist)
            {               
                assgroupMap.put(assg.Name, assg.id);
                system.debug('assg.Name'+assg.Name);
            }
        }
        for(Case shrCs : dealerCaseList)  
        {        
            for(id m:assgroupMap.values())
            {
         		CaseShare cshre = new CaseShare();
                cshre.CaseId = shrCs.Id;
                cshre.CaseAccessLevel = 'Edit';
                cshre.UserOrGroupId = m;
                caseshrList.add(cshre);
            }
        }
        if(!caseshrList.isEmpty() && caseshrList != null)
        {
            insert caseshrList;
        }
    }
    /*public static void CaseHelperKR(List<Case> shcaseList)
    {
        Set<String> DealerGccode = new Set<String>();
        Set<String> DealerGScode = new Set<String>();
        Set<String> DealerNDCode= new Set<String>();
        List<Account> DealeAcc=new List<Account>();  
        Id caseRecId = UtilRecordType.getRecordTypeIdByName('Case', UtilConstant.INQUIRY);
        List<CaseShare> CaseSharingRecord = new List<CaseShare>();        
        List<Case> caserecList = new List<Case>();
        set<id> shrcaseId = new set<id>();
        set<id> userId = new set<id>();      
        List<Group> partnerUserList = new List<Group>();       
        set<id> dealerId = new set<id>();     
        set<id> CaseDealerUserId = new set<id>();
        
        
        if(shcaseList!=null && !shcaseList.isempty())
        {
            for(Case c : shcaseList)
            {
                if(c.RecordTypeId == caseRecId && c.Dealer_Contact__c == 'Yes' && c.Case_Dealer__c != null)
                {
                    shrcaseId.add(c.Id);
                    dealerId.add(c.Case_Dealer__c);
                }
                
            }
        }
        if(!shrcaseId.isEmpty() && shrcaseId != null)
        { 
            caserecList = [select id,Case_Dealer__c,Case_Dealer_User__c,Case_Dealer__r.Dealer_ND_Code__c,Case_Dealer__r.Name,Case_Dealer_User__r.Dealer_GC_Code__c,Case_Dealer__r.Dealer_GS_Code__c from Case where ID =:shrcaseId];                
        }
        if(!caserecList.isEmpty() && caserecList != null)
        {
            for(Case listca:caserecList)
            {           
                userId.add(listca.Case_Dealer__c);  
                CaseDealerUserId.add(listca.Case_Dealer_User__c); 
                if(listca.Case_Dealer_User__r.Dealer_GC_Code__c !=null)
                {
                    DealerGccode.add(listca.Case_Dealer_User__r.Dealer_GC_Code__c);
                }                       
                if(listca.Case_Dealer__r.Dealer_GS_Code__c!=null)
                {
                    DealerGScode.add(listca.Case_Dealer__r.Dealer_GS_Code__c); 
                }              
            }
        }
        if(DealerGccode!=null || DealerGScode!=null)
        {
            DealeAcc=[Select id,Dealer_GC_Code__c from Account where RecordtypeId=:Dealer_RecordTypeId and (Dealer_GC_Code__c=:DealerGccode OR Dealer_GS_Code__c =:DealerGScode)];
        }
        if(DealeAcc!=null)
            for(Account dealerac:DealeAcc)
        {
            if(dealerac.Dealer_ND_Code__c !=null)
                DealerNDCode.add(dealerac.Dealer_ND_Code__c);
        }     
        System.debug('@@@@@@ userId venky'+userId);
        
        if(!DealerNDCode.isempty() && DealerNDCode != null)
        {
            partnerUserList = [select id,name,developername from group where name =:DealerNDCode];
        }
        
        if(!caserecList.isEmpty() && caserecList != null)
        { 
            for(group us : partnerUserList)
            {
                for(Case shrcs : caserecList)
                {           
                    CaseShare shrcase = new CaseShare();
                    shrcase.CaseId = shrcs.id;
                    shrcase.CaseAccessLevel = 'edit';
                    shrcase.UserOrGroupId = us.id;
                    CaseSharingRecord.add(shrcase);                 
                }
            } 
        }
        Database.SaveResult[] lsr = Database.insert(CaseSharingRecord,false);       
    }  */
}