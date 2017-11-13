global class LeadShareBatch implements Database.Batchable<sobject>,database.stateful, Schedulable
{
    public static List<string> dealerGCCodeList = new list<string>();
    public static List<string> dealerNDCodeList = new List<string>();
    public static Map<string,string> groupGcCodeMap = new Map<string,string>();
    public static Map<string,string> groupNdCodeMap = new Map<string,string>();
    public static List<Lead__Share> leadShareList = new List<Lead__Share>();
    
  global database.QueryLocator start(database.BatchableContext bc)
    { 
        string query = 'Select Id,assigned_Dealer__c,assigned_Dealer__r.Dealer_GC_Code__c, assigned_Dealer__r.Dealer_ND_Code__c from Lead__c where assigned_Dealer__r.Dealer_GC_Code__c in '+ '(\'GC0037971\',\'GC0011433\',\'GC0037972\',\'GC0011422\',\'GC0011432\',\'GC0011423\',\'GC0037973\',\'GC0037970\',\'GC0011430\',\'GC0037969\',\'GC0011434\') '+ 'and Assigned_Dealer__c != null and MD__C =' +'\'KR\''+ '';
        return database.getQueryLocator(query);
    }
    global void execute(database.BatchableContext bc,List<Lead__c> scope)
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
        
                For(Lead__c lead : scope)
                {
                if((groupNdCodeMap.get(lead.assigned_Dealer__r.Dealer_ND_Code__c))!=null && groupNdCodeMap!=null)
            {
            
                                Lead__Share ledShre = new Lead__Share();
                                ledShre.AccessLevel = 'Edit';
                                ledShre.ParentId = lead.Id;
                                ledShre.UserOrGroupId = groupNdCodeMap.get(lead.assigned_Dealer__r.Dealer_ND_Code__c);
                                leadShareList.add(ledShre);
                }

if((groupGcCodeMap.get(lead.assigned_Dealer__r.Dealer_GC_Code__c))!=null && groupGcCodeMap!=null )
            {
            
            Lead__Share ledShre = new Lead__Share();
                                ledShre.AccessLevel = 'Edit';
                                ledShre.ParentId = lead.Id;
                                ledShre.UserOrGroupId = groupGcCodeMap.get(lead.assigned_Dealer__r.Dealer_GC_Code__c);
                                leadShareList.add(ledShre);
                                }

}
if(!leadShareList.isEmpty() && leadShareList != null)
{
                insert leadShareList;
}
    }
    global void finish(database.BatchableContext bc)
    {
        
    }
     global void execute(SchedulableContext ctx) {
    Database.ExecuteBatch(new LeadShareBatch(),200);
    }
}