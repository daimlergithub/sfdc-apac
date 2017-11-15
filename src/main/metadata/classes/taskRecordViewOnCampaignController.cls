public without sharing class taskRecordViewOnCampaignController 
{
    public list<Task> taskList;
    public list<Task> showTaskList {get;set;}
    public map<Id,Id> accountContactIdMap;
    public set<Id> customerIdSet;
    public map<Id,string> accountGroupNameMap;
    public Id campaignId = ApexPages.currentPage().getParameters().get('Id');
    public list<CampaignMember> campMembrList;
    public list<AccountShare> sharedAccountList;
    public User currentUser;
    
    public taskRecordViewOnCampaignController(ApexPages.StandardController controller)     
    {
        showTaskList = new list<Task>();
        accountContactIdMap = new map<Id,Id>();
        accountGroupNameMap = new map<Id,string>();
        customerIdSet = new set<Id>();
        
        if(userinfo.getUserType() !='PowerPartner')
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'This section is used for Dealer Users'));
        }
        else if(userinfo.getUserType() == 'PowerPartner')
        {
            currentUser = [Select Id,AccountId, Account.Dealer_ND_Code__c from User where Id =: UserInfo.getUserId()];
            campMembrList = [Select Id,Contact.AccountId from CampaignMember where CampaignId =: ApexPages.currentPage().getParameters().get('Id')];
            if(!campMembrList.isEmpty() && campMembrList != null)
            {
                for(CampaignMember camMbr : campMembrList)
                {               
                    accountContactIdMap.put(camMbr.Contact.AccountId,camMbr.ContactId);
                }
            }
            if(!accountContactIdMap.isEmpty() && accountContactIdMap != null)
            {
                sharedAccountList = [Select Id, AccountId, UserOrGroup.Name from AccountShare where AccountId in : accountContactIdMap.keySet()];
            }
            if(!sharedAccountList.isEmpty() && sharedAccountList != null)
            {
                for(AccountShare accShr : sharedAccountList)
                {
                    if(accountContactIdMap.containsKey(accShr.AccountId) && accShr.UserOrGroup.Name != null && accShr.UserOrGroup.Name != '' && accShr.UserOrGroup.Name == currentUser.Account.Dealer_ND_Code__c)
                    {
                        accountGroupNameMap.put(accountContactIdMap.get(accShr.AccountId), accShr.UserOrGroup.Name);
                    }                
                }
            }
            taskList = [select Id, Subject, What.Name, Who.Name, Status, WHoId, WhatId from Task where WhatId =: ApexPages.currentPage().getParameters().get('Id')];
            if(!taskList.isEmpty() && taskList != null)
            {
                for(Task tsk: taskList)
                {
                    system.debug(accountGroupNameMap + '  *$*$*$*$*   ' + accountGroupNameMap.get(tsk.WhoId));
                    if(accountGroupNameMap.get(tsk.WhoId) != null && accountGroupNameMap.get(tsk.WhoId).startsWith('MBK')  && accountGroupNameMap.containsKey(tsk.WhoId) && accountGroupNameMap.get(tsk.WhoId) == currentUser.Account.Dealer_ND_Code__c)
                    {
                        showTaskList.add(tsk);
                    }
                }
            }
        }
    }
}