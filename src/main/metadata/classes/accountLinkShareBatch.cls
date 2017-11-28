global class accountLinkShareBatch implements Database.Batchable<sobject>,database.stateful, Schedulable
{
    public static List<string> dealerGCCodeList = new list<string>();
    public static List<string> dealerNDCodeList = new List<string>();
    public static Map<string,string> groupGcCodeMap = new Map<string,string>();
    public static Map<string,string> groupNdCodeMap = new Map<string,string>();
    public static map<string,list<String>> dealeraccntMap = new Map<string,list<String>>();
    public static List<Account_Link__Share> updateaclnkShareList = new List<Account_Link__Share>();
    public static List<AccountShare> updateAccShareList = new List<AccountShare>();
    public static map<string,id> assignedgroupMap = new map<string,id>();
  global database.QueryLocator start(database.BatchableContext bc)
    { 
        string query = 'Select id,fromRole__c,toRole__c,fromRole__r.Dealer_GC_Code__c,fromRole__r.Dealer_ND_Code__c,fromRole__r.Dealer_Type__c from Account_Link__c where fromRole__r.Dealer_GC_Code__c in '+ '(\'GC0037971\',\'GC0011433\',\'GC0037972\',\'GC0011422\',\'GC0011432\',\'GC0011423\',\'GC0037973\',\'GC0037970\',\'GC0011430\',\'GC0037969\',\'GC0011434\') '+ 'and fromRole__c != null and toRole__c != null and MD__C =' +'\'KR\''+ 'and (Recordtype.Name =' +'\'Retail Person\'' + 'or Recordtype.Name = ' +'\'Retail Company\')';
        return database.getQueryLocator(query);
    }
    global void execute(database.BatchableContext bc,List<Account_Link__c> scope)
    {
    
        dealerGCCodeList.add('GC0037971');
        dealerGCCodeList.add('GC0037972');
        dealerGCCodeList.add('GC0011433');
        dealerGCCodeList.add('GC0011434');
        dealerGCCodeList.add('GC0011430');
        dealerGCCodeList.add('GC0011422');
        dealerGCCodeList.add('GC0037969');
        dealerGCCodeList.add('GC0011432');
        dealerGCCodeList.add('GC0011423');
        dealerGCCodeList.add('GC0037973');
        dealerGCCodeList.add('GC0037970');
        Set<string> ndCodeList = New Set<String>();
        
        List<Account> accntList = [select Id, Dealer_ND_Code__c, Dealer_GC_Code__c, Dealer_Type__c from Account where Recordtype.Name = 'Dealer' and Dealer_GC_Code__c =:dealerGCCodeList and MD__c = 'KR'];
        for(Account acc : accntList){
        
           ndCodeList.add(acc.Dealer_ND_Code__c);
           if(!dealeraccntMap.containsKey(acc.Dealer_GC_Code__c))
            {
                dealeraccntMap.put(acc.Dealer_GC_Code__c, new List<string>());
            }
            dealeraccntMap.get(acc.Dealer_GC_Code__c).add(acc.Dealer_ND_Code__c);
           
        }
        
        system.debug('+++++++++++++'+ndCodeList);
        List<group> grpList = [select Id, Name, Type from Group where Name in :ndCodeList];
        if(!accntList.isEmpty() && accntList != null && !grpList.isEmpty() && grpList != null)
        {
            for(group gr : grpList)
            {
               
               
               assignedgroupMap.put(gr.Name, gr.id);
               
               
               
              
            }
        }
        for(Account_Link__c acclnk : Scope)
        {
            
            if(dealeraccntMap.get(acclnk.fromRole__r.Dealer_GC_Code__c) != null){
            for(integer i=0 ; i < dealeraccntMap.get(acclnk.fromRole__r.Dealer_GC_Code__c).size();i++)
                    
            {
                if(assignedgroupMap.get(dealeraccntMap.get(acclnk.fromRole__r.Dealer_GC_Code__c)[i]) != null)
                        {
           
            
            AccountShare achsare = new Accountshare();
            achsare.Accountid=acclnk.toRole__c;
            
            achsare.UserOrGroupId = assignedgroupMap.get(dealeraccntMap.get(acclnk.fromRole__r.Dealer_GC_Code__c)[i]);
            achsare.AccountAccessLevel='edit';
            achsare.OpportunityAccessLevel ='none';
            updateAccShareList.add(achsare);  
            }
            } 
        }  
        }      
        
        if(!updateAccShareList.isEmpty() && updateAccShareList != null)
        {
            insert updateAccShareList;
        }        
    }
    global void finish(database.BatchableContext bc)
    {
        
    }
    global void execute(SchedulableContext ctx) {
    Database.ExecuteBatch(new accountLinkShareBatch(),50);
    }
}