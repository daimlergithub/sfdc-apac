/*
Once Sales or After-Sales lead is approved (created as approved lead or updated to the approved status):
Update sharing rule so that Dealer User, who belongs to the company to which the Assigned Dealer outlet of lead, can view/edit that lead. 
Created by:Surya Varma
Date:1/12/2016
*/
public class LeadHelperKR
{  
    private static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    private static final String afterSalesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.AFTER_SALES_LEADS).getRecordTypeId();
    
    public static void handleAfterInsertOrUpdate(list<lead__c> leadlist1,Map<Id,Lead__C> leadOldMap)
    {
        Id Dealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        list<lead__c> leadlist = new list<lead__c>();
        list<account> dealerAccountList =new list<account>();
        Map<String,account>accountMap=new Map<String,account>();
        // Map<id,account>aMap=new Map<id,account>();
        set<id>dealerAccountIds = new set<id>();
        set<String> GCCode = new set<String>();
        Set<String> DealerGScode = new Set<String>();
        set<id> leadIds = new set<id>();
        Set<String> DealerNDCode= new Set<String>();
        list<Lead__share>  leadshare=new list<lead__share>();       
        map<string,id> assgroupMap = new map<string,id>();
        List<Group> grplist=new List<Group>();
        
        for(Lead__c lead:leadlist1)
        {
            if((lead.RecordTypeId ==salesRecordTypeId )||(lead.RecordTypeId ==afterSalesRecordTypeId))
            {
                if(lead.Assigned_Dealer__c!=null && (trigger.isinsert || (trigger.isupdate && lead.OwnerId != leadOldMap.get(lead.Id).OwnerId || lead.Assigned_Dealer__c!=leadOldMap.get(lead.id).Assigned_Dealer__c)))
                { 
                    leadIds.add(lead.id);         
                }
            }
        }
        if(!leadIds.isEmpty() && leadIds != null)
        {
            leadlist = [Select id,recordtypeId,Assigned_Dealer__r.Parent.Dealer_ND_Code__c,CAC_Lead_Status__c,Assigned_Dealer__r.Parent.Dealer_Type__c,
                        Assigned_Dealer__r.Dealer_ND_Code__c,Assigned_Dealer__r.Dealer_GC_Code__c,Assigned_Dealer__r.Dealer_Type__c,
                        Assigned_Dealer__r.Dealer_GS_Code__c,Assigned_Dealer__c from Lead__c where Id IN:leadIds];
        }
        
        for(lead__c le:leadlist)
        {
            /*SFDCKR-1044
              if(le.Assigned_Dealer__c != null)
            {
                dealerAccountIds.add(le.Assigned_Dealer__c);
            }
            if(le.Assigned_Dealer__r.Dealer_GC_Code__c  !=null)
            {
                GCCode.add(le.Assigned_Dealer__r.Dealer_GC_Code__c );
            }                       
            if(le.Assigned_Dealer__r.Dealer_GS_Code__c!=null)
            {
                DealerGScode.add(le.Assigned_Dealer__r.Dealer_GS_Code__c );
            }
        }
        if(dealerAccountIds.size()>0)
        {
            dealerAccountList = [Select id,Dealer_GC_Code__c ,Dealer_ND_Code__c from Account where RecordtypeId=:Dealer_RecordTypeId and (Dealer_GC_Code__c=:GCCode OR Dealer_GS_Code__c =:DealerGScode)];
        }
        if(dealerAccountList.size()>0)
        {
            for(account a:dealerAccountList)
            {
                if(a.Dealer_ND_Code__c != null)
                {
                    DealerNDCode.add(a.Dealer_ND_Code__c);
                    
                }
            }*/
            if(le.Assigned_Dealer__r.Dealer_Type__c == 'Outlet')
            {
                if(le.Assigned_Dealer__r.Parent.Dealer_ND_Code__c != null && le.Assigned_Dealer__r.Parent.Dealer_ND_Code__c != '')
                {
                    DealerNDCode.add(le.Assigned_Dealer__r.Parent.Dealer_ND_Code__c);
                }
            }
            else if(le.Assigned_Dealer__r.Dealer_Type__c == 'Company')
            {
                if(le.Assigned_Dealer__r.Dealer_ND_Code__c != null && le.Assigned_Dealer__r.Dealer_ND_Code__c != '')
                {
                    DealerNDCode.add(le.Assigned_Dealer__r.Dealer_ND_Code__c);
                }
            }
        }
        if(!DealerNDCode.isEmpty() && DealerNDCode != null)
        {
        	grplist = [select id ,Name ,Type from Group where Name IN: DealerNDCode];
        }
        for(Group assg:grplist)
        {               
            assgroupMap.put(assg.Name, assg.id);
            system.debug('assg.Name'+assg.Name);
        }
        
        for(Lead__c lead:leadlist)  
        {        
            for(id m:assgroupMap.values())
            {                       
                Lead__share l=new Lead__share();
                l.ParentId=lead.id;
                l.UserOrGroupId = m;                   
                l.AccessLevel='edit';
                leadshare.add(l);
            }           
        }              
        Database.SaveResult[] lsr = Database.insert(leadshare,false); 
    }
}