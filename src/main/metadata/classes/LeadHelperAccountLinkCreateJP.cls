/*
1.New Account Link record will create when assigned dealer is populated.
Created By: Kiran
Date: 2016-9-23
*/
public class LeadHelperAccountLinkCreateJP 
{
    public static Id AccountLink_RetailPersonRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId();
    public static Id AccountLink_RetailCompanyRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Company').getRecordTypeId();
    public static Id personAccountRecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id companyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
    
    public static void leadAccountDetails(list<Lead__c> leadlst, map<id,Lead__c> leadOldMap, boolean isInsert, boolean isUpdate)
    {
        system.debug('leadAccountDetails :');
        set<String> leadId = new set<String>();
        
        for(Lead__c le : leadlst)
        {
            if(le.Assigned_Dealer__c != null && le.CAC_Lead_Status__c == 'Allocated' && leadOldMap.get(le.id).CAC_Lead_Status__c == 'Approved' && (le.MD__c == label.MarketJP))
            {
                if(isInsert || (isUpdate && le.CAC_Lead_Status__c != leadOldMap.get(le.id).CAC_Lead_Status__c))
                {
                    System.debug('Is Insert OR Update called -----:::::');
                    leadId.add(le.id);
                }
            } 
            else if(le.Assigned_Dealer__c != null && le.MD__c == Label.MarketKR)
            {
                if(isInsert || (isUpdate && le.Assigned_Dealer__c != leadOldMap.get(le.id).Assigned_Dealer__c))
                {
                    System.debug('Is Insert OR Update called -----:::::');
                    leadId.add(le.id);
                }
            }
            
        }
        system.debug('leadAccountDetails 2:');
        if(! leadId.isEmpty() )
        {
            system.debug('leadAccountDetails 3:');
            createAccountLinkRecord(leadId);
        }
        
    }
	/*
	1.Create Account Link record will create when assigned dealer is populated.
	2.Update Lead Retail Contact with the Account link Record.
	Modified By: Sudhir
	Date: 2017-04-07
	*/
    
    public static void createAccountLinkRecord(set<String> contactId)
    {
        List<Lead__c> leadList = new List<Lead__c>();
        List<Lead__c> updateLeadList = new List<Lead__c>();
        List<Account_Link__c> retailCopyList = new List<Account_Link__c>();
        List<Account_Link__c> insertRetailCopyList = new List<Account_Link__c>();
        set<id> leadContactId = new set<id>();
        set<id> leadassignedDealerId = new set<id>();
        set<id> leadcomapanyAccId = new set<id>();
        set<id> newretailCopyId = new set<id>();
        If(!contactId.isEmpty() && contactId != null)
        {
            leadList = [select id,Assigned_Dealer__c,contact__c,Contact__r.RecordTypeId,Company_Account__c,Company_Account__r.RecordTypeId from Lead__c where id =:contactId];
        }
        if(!leadList.isEmpty() && leadList != null)
        {
        	for(Lead__c led : leadList)
            {
                if(led.Contact__c != null)
                {
                    leadContactId.add(led.Contact__c);
                }
                if(led.Company_Account__c != null)
                {
                    leadcomapanyAccId.add(led.Company_Account__c);
                }
                if(led.Assigned_Dealer__c != null)
                {
                    leadassignedDealerId.add(led.Assigned_Dealer__c);
                }
            }
        }
        retailCopyList = [select id from Account_Link__c where fromRole__c =:leadassignedDealerId 
                      AND (toRole__c =:leadContactId OR toRole__c =:leadcomapanyAccId) 
                      AND (RecordtypeId =:AccountLink_RetailPersonRecordTypeId OR RecordtypeId =:AccountLink_RetailCompanyRecordTypeId)];
    	if(!retailCopyList.isEmpty() && retailCopyList != null && retailCopyList.size() >0)
        {
            for(Lead__c lead : leadList)
            {
                for(Account_Link__c acclnk : retailCopyList)
                {
                    if(lead.Contact__c == acclnk.toRole__c && lead.Assigned_Dealer__c == acclnk.fromRole__c)
                    {
                        lead.Retail_Contact__c = acclnk.id;
                        updateLeadList.add(lead);
                    }
                    else if(lead.Company_Account__c == acclnk.toRole__c && lead.Assigned_Dealer__c == acclnk.fromRole__c)
                    {
                        lead.Retail_Company__c = acclnk.Id;
                        updateLeadList.add(lead);
                    }
                }
            }
        }
        else
        {
            for(Lead__c lead : leadList)
            {
                if(lead.Assigned_Dealer__c != null && lead.Contact__r.recordtypeId == personAccountRecordtypeId)
                {
                    Account_link__c aclnk = new Account_Link__c();
                    aclnk.RecordTypeId = AccountLink_RetailPersonRecordTypeId;
                    aclnk.toRole__c = lead.Contact__c;
                    aclnk.fromRole__c = lead.Assigned_Dealer__c;
                    insertRetailCopyList.add(aclnk);
                }
                else if(lead.Assigned_Dealer__c != null && lead.Company_Account__c == companyRecordTypeId)
                {
                    Account_link__c aclnk = new Account_Link__c();
                    aclnk.RecordTypeId = AccountLink_RetailCompanyRecordTypeId;
                    aclnk.toRole__c = lead.Company_Account__c;
                    aclnk.fromRole__c = lead.Assigned_Dealer__c;
                    insertRetailCopyList.add(aclnk);
                }
            }
        }
        if(!insertRetailCopyList.isEmpty() && insertRetailCopyList != null)
        {
            Database.SaveResult[] srList = Database.insert(insertRetailCopyList,true);
            for(Database.SaveResult sr : srList)
            {
                if (sr.isSuccess())
                {
                    {
                        newretailCopyId.add(sr.getid());
                    }                    
                }
            }
        }
        if(!newretailCopyId.isEmpty() && newretailCopyId != null)
        {
            Account_Link__c acclink = [select id,Name, RecordType.DeveloperName from Account_Link__c WHERE id IN: newretailCopyId];
            for(lead__c newLeads : leadList)
            {
                newLeads.Retail_Contact__c = acclink.Id;
                updateLeadList.add(newLeads);
            }
        }
        if(!updateLeadList.isEmpty() && updateLeadList != null)
        {
            update updateLeadList;
        }
    }
}