public class ToolKitTriggerHelper
{
    public static Map<String, Schema.RecordTypeInfo> tkRecordTypeMap = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName();
    public static Map<String, Schema.RecordTypeInfo> taskRecordTypeMap = Schema.SObjectType.task.getRecordTypeInfosByName();
    public static Id sEventTK = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('smart Event').getRecordTypeId();
    public static Id eventTK = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('Event').getRecordTypeId();
    public static Id mediaTK = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('Media').getRecordTypeId();  
    
    public static void beforeInsertUpdateDeleteEvents(list<Tool_Kit__c> toolKitNew,boolean isInsert)
    {
        Map<Id, Id> TKIdDealerId = new Map<Id, Id>();
        Map<Id, Account> DealerIDAccount = new Map<Id, Account>();
        
        for(Tool_Kit__c tk1 : toolKitNew)
        {
            if(tk1.Dealer_Name__c != null)
            {
                TKIdDealerId.put(tk1.id, tk1.Dealer_Name__c);
            }
       }
       if(TKIdDealerId!=null && !TKIdDealerId.IsEmpty())
       {
            for(Account a : [select id, Dealer_Region__c, Dealer_MB_Sub_Region__c, Retail_AMG_Owner__c, Ownerid, Retail_AS_Owner__c, Retail_Star_Elite_Owner__c, Retail_MB_Owner__c, Retail_smart_Owner__c from Account where id in :TKIdDealerId.values()])
           {
                DealerIDAccount.put(a.id, a);
           }
           
           for(Tool_Kit__c tk : toolKitNew)
           {
                if(sEventTK == tk.RecordTypeId || eventTK == tk.RecordTypeId || mediaTK == tk.RecordTypeId)
                {
                    if(sEventTK == tk.RecordTypeId )
                    {
                        tk.Approver__c = DealerIDAccount.get(TKIdDealerId.get(tk.id)).Retail_smart_Owner__c;
                    }
                    else if(tk.Brand__c == 'MB')
                    {
                        tk.Approver__c = DealerIDAccount.get(TKIdDealerId.get(tk.id)).Retail_MB_Owner__c;
                    }
                    else if (tk.Brand__c == 'smart')
                    {
                        tk.Approver__c = DealerIDAccount.get(TKIdDealerId.get(tk.id)).Retail_smart_Owner__c;
                    }
                    else if (tk.Brand__c == 'AMG')
                    {
                        tk.Approver__c = DealerIDAccount.get(TKIdDealerId.get(tk.id)).Retail_AMG_Owner__c;
                    }
                    else if (tk.Brand__c == 'StarElite')
                    {
                        tk.Approver__c = DealerIDAccount.get(TKIdDealerId.get(tk.id)).Retail_Star_Elite_Owner__c;
                    }
                    if(tk.Approver__c == null && DealerIDAccount.containsKey(TKIdDealerId.get(tk.id)))
                    {
                       tk.Approver__c = DealerIDAccount.get(TKIdDealerId.get(tk.id)).Ownerid;
                    }
                }
                if(isInsert)
                {
                    if(sEventTK == tk.RecordTypeId )
                    {
                        tk.Apply_Status__c = 'Tool Kit Finished';
                    }
                    if (tk.Plan_Start_Date__c == null)
                    {
                        tk.Original_Plan_Start_Date__c = System.today();
                    }
                    else 
                    {
                        tk.Original_Plan_Start_Date__c = tk.Plan_Start_Date__c;
                    }
                    // Set the region information according to the dealer.
                    if(DealerIDAccount.get(tk.Dealer_Name__c) != null)
                    {
                        tk.Dealer_Region__c = DealerIDAccount.get(tk.Dealer_Name__c).Dealer_Region__c;
                        tk.Dealer_Sub_Region__c = DealerIDAccount.get(tk.Dealer_Name__c).Dealer_MB_Sub_Region__c;
                    }
                }
            }   
       }
    }
    
    public static void afterInsertUpdateDeleteEvents(list<Tool_Kit__c> toolKitNew,list<Tool_Kit__c> toolKitOld,map<id,Tool_Kit__c> toolKitOldmap,map<id,Tool_Kit__c> toolKitNewmap,boolean isInsert,boolean isUpdate,boolean isDelete)
    {
        Map<Id, Id> tkVandorMap = new Map<Id, Id>();
        Set<Id> vandorIds = new Set<Id>();
        Map<Id, Id> vandorContactMap = new Map<Id, Id>();
        List<Tool_Kit__Share> tkShares = new List<Tool_Kit__Share>();
        List<Task> taskList = new List<Task>();
        
        // When new or update tool kit, share it to Vendor
        if (isInsert || isUpdate)
        {
            for(Tool_Kit__c tkNew : toolKitNew)
            {
                if (tkNew.RecordTypeId == eventTK || tkNew.Vendor_Employee__c == null || (isUpdate && tkNew.Vendor_Employee__c == toolKitOldmap.get(tkNew.id).Vendor_Employee__c))
                {
                    continue;
                }
                tkVandorMap.put(tkNew.Id, tkNew.Vendor_Employee__c);
                vandorIds.add(tkNew.Vendor_Employee__c);
            }
        }
        
        // Get contact Ids
        for (User u : [select Id, ContactId from User where isActive = true and Id in :vandorIds])
        {
            vandorContactMap.put(u.Id, u.ContactId);
        }
        
        // Create sharing records and Tasks
        for (Id tkId : tkVandorMap.keySet())
        {
            // Create Tool Kit sharing records
            Tool_Kit__Share share = new Tool_Kit__Share();
            share.AccessLevel = 'Edit';
            share.ParentId = tkId;
            share.RowCause = Schema.Tool_Kit__Share.RowCause.Manual;
            share.UserOrGroupId = tkVandorMap.get(tkId);
            tkShares.add(share);
            
            // Create notification Tasks
            taskList.add(new Task(
                Subject= 'You have new kit production needs', 
                RecordTypeId = taskRecordTypeMap.get('General Task').getRecordTypeId(),
                OwnerId = tkVandorMap.get(tkId),
                Status = 'open',
                WhoId = vandorContactMap.get(tkVandorMap.get(tkId)),
                WhatId = tkId,
                ActivityDate = date.today()));
        }
        
        // Insert sharing records
        if (tkShares!=null && !tkShares.IsEmpty())
        {
            try {
                insert tkShares;
            } catch (DMLException e)
            {
                System.debug('DMLException Exception occured when sharing Tool Kit to Vendor: ' + e);
            }
        }
        
        // Insert notification Tasks
        if(taskList!=null && !taskList.isEmpty())
        {
            try {
                insert taskList;
            }
            catch(Exception ex)
            {
                System.debug('DMLException Exception occured when creating Task for Vendor: ' + ex.getMessage());
            }
        }
        
        // When delete or update tool kit, delete old shared records from Vendor
        Map<Id, Id> tkVandorMapDel = new Map<Id, Id>();
        Set<Id> tkIdsDel = new Set<Id>();
        Set<Id> vendorIdsDel = new Set<Id>();
        List<Tool_Kit__Share> tkSharesDel = new List<Tool_Kit__Share>();
        
        // Get the shared Tool Kits
        if (isUpdate || isDelete)
        {
            for(Tool_Kit__c tkOld : toolKitOld)
            {
                if (tkOld.RecordTypeId == eventTK || tkOld.Vendor_Employee__c == null || (isUpdate && tkOld.Vendor_Employee__c == toolKitNewmap.get(tkOld.id).Vendor_Employee__c))
                {
                    continue;
                }
                tkVandorMapDel.put(tkOld.Id, tkOld.Vendor_Employee__c);
                tkIdsDel.add(tkOld.Id);
                vendorIdsDel.add(tkOld.Vendor_Employee__c);
            }
        }
        
        // Get the old shared records
        for (Tool_Kit__Share tks : [select Id, ParentId, UserOrGroupId from Tool_Kit__Share where ParentId in :tkIdsDel and UserOrGroupId in :vendorIdsDel])
        {
            if (tkVandorMapDel.get(tks.ParentId) == tks.UserOrGroupId) {
                tkSharesDel.add(tks);
            }
        }
        
        // Delete the old shared records
        if (tkSharesDel!=null && !tkSharesDel.isEmpty())
        {
            try {
                delete tkSharesDel;
            } catch (DMLException ex)
            {
                System.debug('DMLException Exception occured when deleting shared Tool Kit from Vendor: ' + ex.getMessage());
            }
        }
    }
    
    public static void shareToolKit(map<id,Tool_Kit__c> toolKitOldmap,map<id,Tool_Kit__c> toolKitNewmap)
    {
        List<Tool_Kit__c> dealerChangedToolKits = new List<Tool_Kit__c>();
        for(Id toolKitId : Trigger.newMap.keySet())
        {
            if(toolKitOldmap.get(toolKitId).Dealer_Name__c != toolKitNewmap.get(toolKitId).Dealer_Name__c)
            {
                dealerChangedToolKits.add(toolKitNewmap.get(toolKitId));    
            }
        }
        delete [select Id from Tool_Kit__Share where parentId in :dealerChangedToolKits and RowCause = :Schema.Tool_Kit__Share.RowCause.Dealer_Campaign_Share__c];
        TookKitSharingWrapService wrapService = new TookKitSharingWrapService();
        if(!dealerChangedToolKits.isEmpty())
        {
            SharingService.shareToolKits(wrapService.wrapToolKits(dealerChangedToolKits));
        }

        // Updates the 3rd party sharing if a tool kit's vendor has changed.
        List<Tool_Kit__c> vendorChangedToolKits = new List<Tool_Kit__c>();
        for(Id toolKitId : toolKitNewmap.keySet())
        {
            if(toolKitOldmap.get(toolKitId).Vendor_Employee__c != toolKitNewmap.get(toolKitId).Vendor_Employee__c)
            {
                vendorChangedToolKits.add(toolKitNewmap.get(toolKitId));    
            }
        }
        delete [select Id from Tool_Kit__Share where parentId in :vendorChangedToolKits and RowCause = :Schema.Tool_Kit__Share.RowCause.Third_Party_User_Share__c];
        if(!vendorChangedToolKits.isEmpty())
        {
            SharingService.shareToolKits(wrapService.wrapToolKitsFor3rdPartyUsers(vendorChangedToolKits));
        }
    }
}