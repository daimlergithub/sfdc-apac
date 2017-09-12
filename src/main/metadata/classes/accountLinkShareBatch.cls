global class accountLinkShareBatch implements Database.Batchable<sobject>,database.stateful
{
    public static List<string> dealerGCCodeList = new list<string>();
    public static List<string> dealerNDCodeList = new List<string>();
    public static Map<string,string> groupGcCodeMap = new Map<string,string>();
    public static Map<string,string> groupNdCodeMap = new Map<string,string>();
    public static List<Account_Link__Share> updateaclnkShareList = new List<Account_Link__Share>();
    public static List<AccountShare> updateAccShareList = new List<AccountShare>();
  global database.QueryLocator start(database.BatchableContext bc)
    { 
        string query = 'Select id,fromRole__c,toRole__c,fromRole__r.Dealer_GC_Code__c,fromRole__r.Dealer_ND_Code__c,fromRole__r.Dealer_Type__c from Account_Link__c where fromRole__r.Dealer_GC_Code__c in '+ '(\'GC0037971\',\'GC0011433\',\'GC0037972\',\'GC0011422\',\'GC0011430\',\'GC0037969\',\'GC0011434\') '+ 'and fromRole__c != null and toRole__c != null and MD__C =' +'\'KR\''+ 'and (Recordtype.Name =' +'\'Retail Person\'' + 'or Recordtype.Name = ' +'\'Retail Company\')';
        return database.getQueryLocator(query);
    }
    global void execute(database.BatchableContext bc,List<Account_Link__c> scope)
    {
    
           system.debug('+++++'+scope.size());
        dealerGCCodeList.add('GC0037971');
        dealerGCCodeList.add('GC0037972');
        dealerGCCodeList.add('GC0011433');
        dealerGCCodeList.add('GC0011434');
        dealerGCCodeList.add('GC0011430');
        dealerGCCodeList.add('GC0011422');
		dealerGCCodeList.add('GC0037969');
        Set<string> ndCodeList = New Set<String>();
        
        List<Account> accntList = [select Id, Dealer_ND_Code__c, Dealer_GC_Code__c, Dealer_Type__c from Account where Recordtype.Name = 'Dealer' and Dealer_GC_Code__c =:dealerGCCodeList and MD__c = 'KR'];
        for(Account acc : accntList){
        
           ndCodeList.add(acc.Dealer_ND_Code__c);
        }
        
        system.debug('+++++++++++++'+ndCodeList);
        List<group> grpList = [select Id, Name, Type from Group where Name in :ndCodeList];
        if(!accntList.isEmpty() && accntList != null && !grpList.isEmpty() && grpList != null)
        {
            for(group gr : grpList)
            {
                for(Account acc : accntList)
                {
                    if(acc.Dealer_Type__c == 'Company' && gr.Name == acc.Dealer_ND_Code__c)
                    {
                        groupGcCodeMap.put(acc.Dealer_ND_Code__c,gr.Id);
                    }
                    
                    if(acc.Dealer_Type__c == 'outlet' &&gr.Name == acc.Dealer_ND_Code__c)
                    {
                        groupNdCodeMap.put(acc.Dealer_ND_Code__c,gr.Id);
                    }
                }
            }
        }
        for(Account_Link__c acclnk : Scope)
        {
            if((groupNdCodeMap.get(acclnk.fromRole__r.Dealer_ND_Code__c))!=null && groupNdCodeMap!=null && acclnk.fromRole__r.Dealer_Type__c =='outlet')
            {
            Account_Link__Share aclnkshare = new Account_Link__Share();
            aclnkshare.ParentId = acclnk.Id;
            aclnkshare.UserOrGroupId = groupNdCodeMap.get(acclnk.fromRole__r.Dealer_ND_Code__c);
            aclnkshare.AccessLevel = 'Edit';
            updateaclnkShareList.add(aclnkshare);
            
            AccountShare achsare = new Accountshare();
            achsare.Accountid=acclnk.toRole__c;
            System.debug('uid>>>>'+groupNdCodeMap.get(acclnk.fromRole__r.Dealer_ND_Code__c));
            achsare.UserOrGroupId = groupNdCodeMap.get(acclnk.fromRole__r.Dealer_ND_Code__c);
            achsare.AccountAccessLevel='edit';
            achsare.OpportunityAccessLevel ='none';
            updateAccShareList.add(achsare);  
            }
            if((groupGcCodeMap.get(acclnk.fromRole__r.Dealer_GC_Code__c))!=null && groupGcCodeMap!=null )
            {
            Account_Link__Share aclnkshare = new Account_Link__Share();
            aclnkshare.ParentId = acclnk.Id;
            aclnkshare.UserOrGroupId = groupGcCodeMap.get(acclnk.fromRole__r.Dealer_ND_Code__c);
            aclnkshare.AccessLevel = 'Edit';
            updateaclnkShareList.add(aclnkshare);
            
            AccountShare achsare = new Accountshare();
            achsare.Accountid=acclnk.toRole__c;
            achsare.UserOrGroupId = groupGcCodeMap.get(acclnk.fromRole__r.Dealer_ND_Code__c);
            achsare.AccountAccessLevel='edit';
            achsare.OpportunityAccessLevel ='none';
            updateAccShareList.add(achsare);    
                
                
            }
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