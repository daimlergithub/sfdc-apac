/***********************************************************************************
Created By          :    Sergio Kobayashi    
Created Date        :    10.18.2017
Company             :    NTT Data Coporation
Usage               :    The functionality of this batch is to check and correct the Lead_Share__c records.
                          * This will execute twice a day as batch.
JIRA NO             :    JP-2552                                                

MODIFICATION DETAILS:

1. Modified By      :    
   Modifide Date    :    
************************************************************************************/
global class CheckAndCorrectLeadSharingJP implements Database.Batchable<sObject>,Schedulable{
    //START METHOD 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([select Id, Name, Lead_Assignment_Notification_Done__c, 
                                         CreatedBy.Name, Drop_off_Time__c, Portal_Request_ID__c, 
                                         Assigned_Dealer__r.Name, Assigned_Dealer__r.Dealer_GC_Code__c, 
                                         CreatedDate, Created_By_EP_Transaction__c from Lead__c 
                                         where CAC_Lead_Status__c = 'Allocated' and CreatedDate = LAST_N_DAYS:2 
                                         and Assigned_dealer__c != '' and RecordType.ID IN ('012280000006I7s', '012280000006I7q') 
                                         and Id Not in (select ParentID from Lead__Share where Rowcause IN('Assigned_Dealer__c', 'Manual'))]);
    }
    //EXECUTE METHOD
    global void execute(Database.BatchableContext BC, List<Lead__c> scope){
        system.debug('Lead Scope :'+Scope);
        
        Set<String> LeadGcCodes = new Set<String>();
                
        for(Lead__c ld : Scope){
            LeadGcCodes.add(ld.Assigned_Dealer__r.Dealer_GC_Code__c);
        }
        
        List<Account> assignedDealerAccounts = [select Name, Dealer_GC_Code__c from Account where Dealer_GC_Code__c in: LeadGcCodes];
        
        Set<String> assignedDealerAccountNames = new Set<String>();
        
        if (assignedDealerAccounts != null){
            for (Account a: assignedDealerAccounts){
                assignedDealerAccountNames.add(a.Name);
            }
        }
        
        Map<String, List<String>> assignedGccodesAccountNamesMap = new Map<String, List<String>>();
        
        if (assignedDealerAccounts != null){
            for (Account a: assignedDealerAccounts){
                if (!assignedGccodesAccountNamesMap.containsKey(a.Dealer_GC_Code__c)){
                    List<String> accountNameList = new List<String>();
                    accountNameList.add(a.Name);
                    assignedGccodesAccountNamesMap.put(a.Dealer_GC_Code__c, accountNameList);
                } else {
                    assignedGccodesAccountNamesMap.get(a.Dealer_GC_Code__c).add(a.Name);
                }
            }
        }
        
        Map<Id, List<String>> leadAssignedDealerNamesMap = new Map<Id, List<String>>();
        
        for(Lead__c ld : Scope){
            leadAssignedDealerNamesMap.put(ld.Id, assignedGccodesAccountNamesMap.get(ld.Assigned_Dealer__r.Dealer_GC_Code__c));            
        }
        
        Map<String, Id> groupIdNameMap = new Map<String, Id>();
        
        List<Group> assignedDealerPG = [select id ,Name from Group where Name IN: assignedDealerAccountNames];
        
        if (assignedDealerPG != null){
            for (Group g: assignedDealerPG){
                groupIdNameMap.put(g.Name, g.Id);
            }
        }
        
        Map<Id, List<Id>> leadAssignedPublicGroupMap = new Map<Id, List<Id>>();
        
        for (Id lid: (Set<Id>)leadAssignedDealerNamesMap.keySet()){
            List<Id> groupIdList = new List<Id>();
            for (String accountName: leadAssignedDealerNamesMap.get(lid)){
                groupIdList.add(groupIdNameMap.get(accountName));
            }                
            leadAssignedPublicGroupMap.put(lid, groupIdList);
        }
        
        List<Lead__share> leadShareList = new List<Lead__share>();
        
        for (Id lid: (Set<Id>)leadAssignedPublicGroupMap.keySet()){
            for (Id gid: leadAssignedPublicGroupMap.get(lid)){
                Lead__share leadShare =new Lead__share();
                leadShare.ParentId=lid;
                leadShare.UserOrGroupId = gid;
                leadShare.rowcause = Schema.Lead__Share.rowcause.Assigned_Dealer__c ;  
                leadShare.AccessLevel='edit';
                leadShareList.add(leadShare);
            }
        }
        
        List<Database.SaveResult> SRList = new List<Database.SaveResult>();
        
        if(!leadShareList.isEmpty() && leadShareList != Null){
            SRList = Database.insert(leadShareList, false);
        }
        
        for (Database.SaveResult sr : SRList) {
            if(!sr.isSuccess()){
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred:' + err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Fields that affected this error: ' + err.getFields());
                }
            }
        }
    } 
    //FINISH METHOD
    global void finish(Database.BatchableContext BC){
       
    }
   
    global void execute(SchedulableContext ctx) {
        Database.executeBatch(new CheckAndCorrectLeadSharingJP());
    }
}