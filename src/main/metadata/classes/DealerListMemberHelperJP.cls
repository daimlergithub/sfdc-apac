public class DealerListMemberHelperJP 
{
    public static Id da=Schema.SObjectType.Account.getRecordtypeInfosByName().get('Dealer').getRecordTypeId();
    public static void afterInsertEvent(List<Dealer_List_Member__c> newList){
     Set<Id> recordIds = New Set<id>();
        Set<Id> recordIds1 = New Set<id>();
        List<Dealer_List_Member__c> newDLMList = new  List<Dealer_List_Member__c>();
        List<Account> dealerAccList = new List<Account>();
        Map<string,list<string>> dealeraccntMap = new Map<string,list<string>>();
        List<Group>groupList = new List<Group>();
        Map<string,id>assigngroupMap = new Map<string,id>();
        if(newList !=null)
        {
         for(Dealer_List_Member__c dl:newList)
        {
            recordIds.add(dl.id);  
        }
        }
        if(recordIds != null){
             newDLMList = [Select id,name,Participating_Dealer__c,Participating_Dealer__r.Dealer__r.name,Participating_Dealer__r.Dealer__r.Dealer_GC_Code__c  from Dealer_List_Member__c where ID IN:recordIds]; 
        }
        Map<Id,String> UserMap = New Map<Id,String>();
        Set<String> dealerCode = New Set<String>();
        Set<String> accountName = New Set<String>();
        List<Dealer_List_Member__Share> DealerListMemberShare = New List<Dealer_List_Member__Share>();
        List<Account> accountlist = new list<Account>();
        
        for(Dealer_List_Member__c RetMem : newDLMList)
        {
            If( RetMem.Participating_Dealer__r.Dealer__c != null)
            {                     
                recordIds1.add(RetMem.Participating_Dealer__r.Dealer__c);
            }           
        }
        
        if(recordIds1 != null)
        {
            accountlist =[select id,Dealer_GC_Code__c From Account Where Id IN : recordIds1];
        }
                    
        if(accountlist != null){            
            for(Account acc : accountlist ){
            
                    UserMap.put(acc.id,acc.Dealer_GC_Code__c);  
                    dealerCode.add(acc.Dealer_GC_Code__c);
                
            }
        }
        if(dealerCode != null){
        
                 dealerAccList = [select id,Name,Dealer_GC_Code__c from Account where Dealer_GC_Code__c =:dealerCode AND RecordtypeId=:da];
        }
        if(dealerAccList != null){
            for(Account acc :dealerAccList){
                if(!dealeraccntMap.containsKey(acc.Dealer_GC_Code__c))
                {
                    dealeraccntMap.put(acc.Dealer_GC_Code__c, new List<string>());
                }
                    dealeraccntMap.get(acc.Dealer_GC_Code__c).add(acc.Name);
                    accountName.add(acc.Name);
            }
        }
        if(accountName != null){
            groupList = [select Id, Name, Type from Group where Name =: accountName];
        }
        if(recordIds1.size()>0 && accountName != null){
                      
            for(Group assg : groupList){
                assigngroupMap.put(assg.Name, assg.id);
            }
        }                 
        for(Dealer_List_Member__c dlm : newDLMList)  
        {
           if(dealeraccntMap.get(dlm.Participating_Dealer__r.Dealer__r.Dealer_GC_Code__c) != null){
            for(integer i=0 ; i < dealeraccntMap.get(dlm.Participating_Dealer__r.Dealer__r.Dealer_GC_Code__c).size();i++)
            {
                    
                if(assigngroupMap.get(dealeraccntMap.get(dlm.Participating_Dealer__r.Dealer__r.Dealer_GC_Code__c)[i]) != null)
                {
                    Dealer_List_Member__Share dlmShare = new Dealer_List_Member__Share();
                    dlmShare.ParentId=dlm.id;
                    dlmShare.UserOrGroupId = assigngroupMap.get(dealeraccntMap.get(dlm.Participating_Dealer__r.Dealer__r.Dealer_GC_Code__c)[i]);
                    dlmShare.rowcause = Schema.Lead__Share.rowcause.Manual;  
                    dlmShare.AccessLevel='edit';
                    DealerListMemberShare.add(dlmShare);
                }
            }
           }
        }
        If(DealerListMemberShare.size()>0)
        {
            System.debug(DealerListMemberShare);
            insert DealerListMemberShare;
        }
    }
}