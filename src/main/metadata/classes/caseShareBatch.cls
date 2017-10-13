global class caseShareBatch implements Database.Batchable<sobject>,database.stateful
{
    public static List<string> dealerGCCodeList = new list<string>();
    public static List<string> dealerNDCodeList = new List<string>();
    public static Map<string,string> groupGcCodeMap = new Map<string,string>();
    public static Map<string,string> groupNdCodeMap = new Map<string,string>();
    public static List<CaseShare> caseShareList = new List<CaseShare>();
    
  global database.QueryLocator start(database.BatchableContext bc)
    { 
        string query = 'Select Id,Case_Dealer__c,Case_Dealer__r.Dealer_GC_Code__c,Case_Dealer__r.Dealer_ND_Code__c from Case where Case_Dealer__r.Dealer_GC_Code__c in '+ '(\'GC0037971\',\'GC0011433\',\'GC0037972\',\'GC0011422\',\'GC0011432\',\'GC0011423\',\'GC0037973\',\'GC0037970\',\'GC0011430\',\'GC0037969\',\'GC0011434\') '+ 'and Case_Dealer__c != null and MD__C =' +'\'KR\''+ '';
        return database.getQueryLocator(query);
    }
    global void execute(database.BatchableContext bc,List<case> scope)
    {
    
           system.debug('+++++'+scope.size());
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
                        groupGcCodeMap.put(acc.Dealer_GC_Code__c,gr.Id);
                    }
                    
                    if(acc.Dealer_Type__c == 'outlet' &&gr.Name == acc.Dealer_ND_Code__c)
                    {
                        groupNdCodeMap.put(acc.Dealer_ND_Code__c,gr.Id);
                    }
                }
            }
        }
        
                For(Case cas : scope)
                {
                if((groupNdCodeMap.get(cas.Case_Dealer__r.Dealer_ND_Code__c))!=null && groupNdCodeMap!=null)
            {
                                CaseShare casShre = new CaseShare();
                                casShre.CaseAccessLevel = 'Edit';
                                casShre.CaseId = cas.Id;
                                casShre.UserOrGroupId = groupGcCodeMap.get(cas.Case_Dealer__r.Dealer_ND_Code__c);
                                caseShareList.add(casShre);
                }
                
                if((groupGcCodeMap.get(cas.Case_Dealer__r.Dealer_GC_Code__c))!=null && groupGcCodeMap!=null )
            {
            CaseShare casShre = new CaseShare();
                                casShre.CaseAccessLevel = 'Edit';
                                casShre.CaseId = cas.Id;
                                casShre.UserOrGroupId = groupGcCodeMap.get(cas.Case_Dealer__r.Dealer_GC_Code__c);
                                caseShareList.add(casShre);
                }
                }

if(!caseShareList.isEmpty() && caseShareList != null)
{
                insert caseShareList;
}
    }
    global void finish(database.BatchableContext bc)
    {
        
    }
}