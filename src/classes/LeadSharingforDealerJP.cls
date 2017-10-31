public class LeadSharingforDealerJP{
    public static void LeadSharingforDealer(list<Lead__c> rtlst, map<id,Lead__c> leadOldMap, boolean isInsert, boolean isUpdate){
        // inserting new records
        if (isInsert) {
            List<Lead__Share> sharesToCreate = new List<Lead__Share>();
            for (Lead__c Led : rtlst) {
                if(Led.Recordtype.Name == 'Sales Leads' || Led.Recordtype.Name == 'Aftersales Leads'){
                    if (Led.Assigned_Dealer__c != NULL && Led.CAC_Lead_Status__c == 'Approved') {
                        // create the new share for group
                        Lead__Share cs = new Lead__Share();
                        cs.ParentId = Led.id;
                        cs.RowCause = schema.Lead__Share.rowcause.Manual;
                        cs.UserOrGroupId =  Led.Assigned_Dealer__r.OwnerId;
                        cs.AccessLevel = 'Edit';
                        sharesToCreate.add(cs);
                    }    
                }
            }
            // do the DML to create shares
            if (!sharesToCreate.isEmpty())
                insert sharesToCreate;
                // updating existing records
        }
        else if (isUpdate) {    
            List<Lead__Share> sharesToCreate = new List<Lead__Share>();
            List<ID> shareIdsToDelete = new List<ID>();
            for (Lead__c Led : rtlst) {
                Lead__C oldlead = leadOldMap.get(Led.id);
                if(Led.Recordtype.Name == 'Sales Leads' || Led.Recordtype.Name == 'Aftersales Leads'){
                    // if the record was public but is now private -- delete the existing share
                    if (Led.Assigned_Dealer__c != oldlead.Assigned_Dealer__c && Led.CAC_Lead_Status__c == 'Approved') {
                        shareIdsToDelete.add(oldlead.Assigned_Dealer__r.Ownerid);      
                    } 
                    // create the new share with read/write access
                    Lead__Share cs = new Lead__Share();
                    cs.ParentId = Led.id;
                    cs.RowCause = schema.Lead__Share.rowcause.Manual;
                    cs.UserOrGroupId =  Led.Assigned_Dealer__r.OwnerId;
                    cs.AccessLevel = 'Edit';
                    sharesToCreate.add(cs);  
                }
            }    
            // do the DML to delete shares
            if (!shareIdsToDelete.isEmpty())
                delete [select id from Lead__Share where UserOrGroupId IN :shareIdsToDelete ];
            // do the DML to create shares
            if (!sharesToCreate.isEmpty())
                insert sharesToCreate;
        }
    }
    
    public static void LeadSharing_Dealer(list<Lead__c> rtlst , map<id,Lead__c> leadOldMap,boolean isInsert,boolean isUpdate)
    {       
        list<Lead__c> rtlst1 = new list<Lead__c>();
        Set<id> dealerAccountIds = new Set<id>();
        Set<id> LeadIds = new Set<id>();
        Set<String> groupNames = new Set<String>();
        for (Lead__c Led : rtlst) 
        {
            if(led.Assigned_Dealer__c != null && (isInsert || (isUpdate && led.Assigned_Dealer__c != leadOldMap.get(Led.Id).Assigned_Dealer__c || led.OwnerId != leadOldMap.get(Led.Id).OwnerId)))
            {
                LeadIds.add(Led.Id);
                dealerAccountIds.add(Led.Assigned_Dealer__C);
            }
        }
        UtilShare.groupmembersadd(LeadIds,dealerAccountIds);                 
     
        Set<Id> accountIds = new Set<Id>();
        Set<Id> parentIdsVS = new Set<Id>();
        Set<Id> parentIdsVRS = new Set<Id>();
        Set<Id> groupIds = new Set<Id>();
        /**********************
        if(allGroups.size() > 0){
            system.debug('test 1 :');                     
            for (Lead__c Led : rtlst) {
                system.debug('test 2 :');
                account dealerName = mapAccountall.get(Led.Assigned_Dealer__c);   
                for(Group groupid : allGroups.values()){
                    system.debug('test 3 :'+dealerName);
                    if(Led.Recordtype.Name == 'Sales Leads' || Led.Recordtype.Name == 'Aftersales Leads'){                        
                        if (dealerName != NULL && dealerName.Name == groupid.Name) {
                            system.debug('test 4 :');
                            // create the new share for group                            
                            accountIds.add(Led.Assigned_Dealer__c);
                            parentIdsVS.add(Led.VehicleRel_No__c);
                            parentIdsVRS.add(Led.AfterSales_Vehicle__c);
                            groupIds.add(groupid.Id);                              
                        }    
                    }
                }
            }
            system.debug('accountIds>> :'+accountIds);
            system.debug('parentIdsVS>> :'+parentIdsVS);
            system.debug('parentIdsVRS>> :'+parentIdsVRS);
            system.debug('groupIds>> :'+groupIds); 
            if(accountIds != Null && groupIds != Null){    
                utis.createShareObject(accountIds,groupIds,'Read');
            }
            if(parentIdsVRS!= Null && groupIds != Null){
                utis.VehicleRelationshipShare(parentIdsVRS,groupIds,'Read');
            }
            if(parentIdsVS!= Null && groupIds != Null){
                utis.VehicleShare(parentIdsVS,groupIds,'Read');
            }               
        }
        ****************************/        
    }   
}