/*
Share case record with Japan Dealer Company Manager,Japan Dealer Sales Manager,Japan Dealer Service Manager,
if this Case record belongs to the dealer user's company and Dealer_Contact__c value as "Yes" and
Dealer_GC_Code_c field value of the Account linked to the "Case_Dealer_c" field of target Case match the Dealer_GC_Code__c and Dealer_GS_Code__c of the target User
*/
public class CaseHelperKR
{
    public static Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    
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
	
	public static void updateCaseDeadLine(List<Case> LstnewCase, Map<Id,Case> oldValcase, string action){
          List<Id> caseIds = new List<Id>();
          Id caseMBRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
           if(action == 'isUpdate')
        {
            for(case cs: LstnewCase)
            {
                
                if(TriggerCaseTriggerHandlerKR.isFutureUpdate != true && cs.Priority!= oldValcase.get(cs.id).Priority && cs.RecordTypeId == caseMBRecordTypeId)
                {
                    caseIds.add(cs.id);                
                }
            }        
        }
        if(action == 'isInsert')
        {
            for(case cs: LstnewCase)
            {
                
                if(TriggerCaseTriggerHandlerKR.isFutureUpdate != true && cs.RecordTypeId == caseMBRecordTypeId)
                {
                    caseIds.add(cs.id);                
                }
            }        
        }       
        
        if(caseIds.size()>0)
        {
            string caseJsonStr = JSON.serialize(caseIds);            
            system.debug('PSM caseJsonStr + caseIds '+'  '+caseJsonStr);
            updateCaseDeadLine.caseDeadLinesetter(caseJsonStr);
        }
    
    }
}