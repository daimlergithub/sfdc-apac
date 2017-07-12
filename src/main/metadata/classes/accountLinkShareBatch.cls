global class accountLinkShareBatch implements Database.Batchable<sobject>,database.stateful
{
    public static List<string> dealerGCCodeList = new list<string>();
    //{'GC0011422','GC0011430','GC0037972'};
    public static List<string> dealerNDCodeList = new List<string>();
    //{'MBK09Shq','MBK31Shq','MBK11Whq'};
    public static Map<string,string> groupGcCodeMap = new Map<string,string>();
    
    public static List<Account_Link__Share> updateaclnkShareList = new List<Account_Link__Share>();
    public static List<AccountShare> updateAccShareList = new List<AccountShare>();
  global database.QueryLocator start(database.BatchableContext bc)
    { 
        dealerGCCodeList.add('GC0011422');
        dealerGCCodeList.add('GC0011430');
        dealerGCCodeList.add('GC0037972');
        string query = 'Select id,fromRole__c,toRole__c,fromRole__r.Dealer_GC_Code__c from Account_Link__c where fromRole__r.Dealer_GC_Code__c in '+ '(\'GC0011422\',\'GC0011430\',\'GC0037972\') '+ 'and fromRole__c != null and toRole__c != null and MD__C =' +'\'KR\''+ 'and (Recordtype.Name =' +'\'Retail Person\'' + 'or Recordtype.Name = ' +'\'Retail Company\')';
        return database.getQueryLocator(query);
    }
    global void execute(database.BatchableContext bc,List<Account_Link__c> scope)
    {
        dealerGCCodeList.add('GC0011422');
        dealerGCCodeList.add('GC0011430');
        dealerGCCodeList.add('GC0037972');
        dealerNDCodeList.add('MBK09Shq');
        dealerNDCodeList.add('MBK31Shq');
        dealerNDCodeList.add('MBK11Whq');
        List<Account> accntList = [select Id, Dealer_ND_Code__c, Dealer_GC_Code__c, Dealer_Type__c from Account where Recordtype.Name = 'Dealer' and Dealer_GC_Code__c =:dealerGCCodeList];
        List<group> grpList = [select Id, Name, Type from Group where Name in :dealerNDCodeList];
        if(!accntList.isEmpty() && accntList != null && !grpList.isEmpty() && grpList != null)
        {
            for(group gr : grpList)
            {
                for(Account acc : accntList)
                {
                    if(acc.Dealer_Type__c == 'Company' && gr.Name == acc.Dealer_ND_Code__c)
                    {
                        groupGcCodeMap.put(acc.Dealer_GC_Code__c,gr.Id);
                    }
                }
            }
        }
        for(Account_Link__c acclnk : Scope)
        {
            Account_Link__Share aclnkshare = new Account_Link__Share();
            aclnkshare.ParentId = acclnk.Id;
            aclnkshare.UserOrGroupId = groupGcCodeMap.get(acclnk.fromRole__r.Dealer_GC_Code__c);
            aclnkshare.AccessLevel = 'Edit';
            updateaclnkShareList.add(aclnkshare);
            
            AccountShare achsare = new Accountshare();
             achsare.Accountid=acclnk.toRole__c;
             achsare.UserOrGroupId = groupGcCodeMap.get(acclnk.fromRole__r.Dealer_GC_Code__c);
             achsare.AccountAccessLevel='edit';
             achsare.OpportunityAccessLevel ='none';
             updateAccShareList.add(achsare);
        }
        if(!updateaclnkShareList.isEmpty() && updateaclnkShareList != null)
        {
            insert updateaclnkShareList; 
        }
        if(!updateAccShareList.isEmpty() && updateAccShareList != null)
        {
            insert updateAccShareList;
        }
    }
    global void finish(database.BatchableContext bc)
    {
        
    }
}