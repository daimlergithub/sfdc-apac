public class ToolKitTriggerHelper {

 Private static Id seventTK = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('smart Event').getRecordTypeId();
 
 Map<String, Schema.RecordTypeInfo> tkRecordTypeMap = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName();
 Private static  Id eventTK = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('Event').getRecordTypeId();
  Private static Id mediaTK = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('Media').getRecordTypeId();
   
   
    public static void toolkitinsertupdate(List<Tool_Kit__c> toolinsertlist, Map<Id, Tool_Kit__c> oldMap)
    {
    Map<Id, Id> tkVandorMap = new Map<Id, Id>();
    Set<Id> vandorIds = new Set<Id>();
    Map<Id, Id> vandorContactMap = new Map<Id, Id>();
    List<Tool_Kit__Share> tkShares = new List<Tool_Kit__Share>();
    List<Task> taskList = new List<Task>();
    Map<String, Schema.RecordTypeInfo> taskRecordTypeMap = Schema.SObjectType.task.getRecordTypeInfosByName();
  for(Tool_Kit__c tkNew : toolinsertlist) {
            if (tkNew.RecordTypeId == seventTK || tkNew.Vendor_Employee__c == null || (trigger.isUpdate && tkNew.Vendor_Employee__c == oldMap.get(tkNew.id).Vendor_Employee__c)) {
                continue;                
            }
            tkVandorMap.put(tkNew.Id, tkNew.Vendor_Employee__c);
            vandorIds.add(tkNew.Vendor_Employee__c);
        }
        
        // Get contact Ids
    for (User u : [select Id, ContactId from User where isActive = true and Id in :vandorIds]) {
        vandorContactMap.put(u.Id, u.ContactId);
    }
    
    // Create sharing records and Tasks
    for (Id tkId : tkVandorMap.keySet()) {
        // Create Tool Kit sharing records
//TookKitSharingWrapService wrapService=new TookKitSharingWrapService();
       // SharingService.shareToolKits(wrapService.wrapToolKits(tkShares));
        
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
    if (tkShares.size() > 0) {
        try {
         //   insert tkShares;
        } catch (DMLException e) {
            System.debug('DMLException Exception occured when sharing Tool Kit to Vendor: ' + e);
        }
    }
    
    // Insert notification Tasks
    if(taskList.size() > 0){
        try {
            insert taskList;
        }
        catch(Exception ex) {
            System.debug('DMLException Exception occured when creating Task for Vendor: ' + ex.getMessage());
        }
    }
    
    } 
        public static void toolkitupdatedelete(List<Tool_Kit__c> toololdlist, Map<Id, Tool_Kit__c> newMap)
    {
         // When delete or update tool kit, delete old shared records from Vendor
    Map<Id, Id> tkVandorMapDel = new Map<Id, Id>();
    Set<Id> tkIdsDel = new Set<Id>();
    Set<Id> vendorIdsDel = new Set<Id>();
    List<Tool_Kit__Share> tkSharesDel = new List<Tool_Kit__Share>();
    // Get the shared Tool Kits
    for(Tool_Kit__c tkOld : toololdlist) {
            if (tkOld.RecordTypeId == seventTK || tkOld.Vendor_Employee__c == null || (trigger.isUpdate && tkOld.Vendor_Employee__c == newMap.get(tkOld.id).Vendor_Employee__c)) {
                continue;
            }
            tkVandorMapDel.put(tkOld.Id, tkOld.Vendor_Employee__c);
            tkIdsDel.add(tkOld.Id);
            vendorIdsDel.add(tkOld.Vendor_Employee__c);
        }
         // Get the old shared records
    for (Tool_Kit__Share tks : [select Id, ParentId, UserOrGroupId from Tool_Kit__Share where ParentId in :tkIdsDel and UserOrGroupId in :vendorIdsDel]) {
        if (tkVandorMapDel.get(tks.ParentId) == tks.UserOrGroupId) {
            tkSharesDel.add(tks);
        }
    }
    
    // Delete the old shared records
    if (tkSharesDel.size() > 0) {
        try {
            delete tkSharesDel;
        } catch (DMLException ex) {
            System.debug('DMLException Exception occured when deleting shared Tool Kit from Vendor: ' + ex.getMessage());
        }
    }
    }
    public static void sharetoolkitupdate(Map<Id, Tool_Kit__c> newMap,Map<Id, Tool_Kit__c> oldMap)
    {
        // Updates the dealer sharing if a tool kit's dealer has changed.
        List<Tool_Kit__c> dealerChangedToolKits = new List<Tool_Kit__c>();
        for(Id toolKitId : Trigger.newMap.keySet()){
            if(oldMap.get(toolKitId).Dealer_Name__c != newMap.get(toolKitId).Dealer_Name__c){
                dealerChangedToolKits.add(newMap.get(toolKitId));    
            }
        }
        delete [select Id from Tool_Kit__Share where parentId in :dealerChangedToolKits and RowCause = :Schema.Tool_Kit__Share.RowCause.Dealer_Campaign_Share__c];
        TookKitSharingWrapService wrapService = new TookKitSharingWrapService();
        if(!dealerChangedToolKits.isEmpty()){
            SharingService.shareToolKits(wrapService.wrapToolKits(dealerChangedToolKits));
        }

        // Updates the 3rd party sharing if a tool kit's vendor has changed.
        List<Tool_Kit__c> vendorChangedToolKits = new List<Tool_Kit__c>();
        for(Id toolKitId : Trigger.newMap.keySet()){
            if(oldMap.get(toolKitId).Vendor_Employee__c != newMap.get(toolKitId).Vendor_Employee__c){
                vendorChangedToolKits.add(newMap.get(toolKitId));    
            }
        }
        delete [select Id from Tool_Kit__Share where parentId in :vendorChangedToolKits and RowCause = :Schema.Tool_Kit__Share.RowCause.Third_Party_User_Share__c];
        if(!vendorChangedToolKits.isEmpty()){
            SharingService.shareToolKits(wrapService.wrapToolKitsFor3rdPartyUsers(vendorChangedToolKits));
        }
    } 
    
    public static void ToolKitBeforeInsertUpdateDelete(List<Tool_Kit__c> toolinsertlist)
    {
        Map<Id, Id> TKIdDealerId = new Map<Id, Id>();
        Map<Id, Account> DealerIDAccount = new Map<Id, Account>();
        
        /*
   // zhongyang.si add for Release 1.3 CR7, load the Model_Mapping__c data
   List<Model_Mapping__c> vendorForToolKitList = new List<Model_Mapping__c>();
   for(Model_Mapping__c vtk : [SELECT id,Brand__c,RecordType__c, Region__c, User__c FROM Model_Mapping__c WHERE recordtype.developername = 'Tool_Kit']){
       vendorForToolKitList.add(vtk);
   }
   // zhongyang.si add for Release 1.3 CR7, load the Model_Mapping__c data
   */
   
   for(Tool_Kit__c tk1 : toolinsertlist) {
    if(tk1.Dealer_Name__c != null) {
        TKIdDealerId.put(tk1.id, tk1.Dealer_Name__c);
    }
   }
   system.debug('@@@TKIdDealerId '+TKIdDealerId );
   for(Account a : [select id, Dealer_Region__c, Dealer_MB_Sub_Region__c, Retail_AMG_Owner__c, Ownerid, Retail_AS_Owner__c, Retail_Star_Elite_Owner__c, Retail_MB_Owner__c, Retail_smart_Owner__c from Account where id in :TKIdDealerId.values()]) {
        DealerIDAccount.put(a.id, a);
   }
      system.debug('@@@DealerIDAccount'+DealerIDAccount);

   for(Tool_Kit__c tk : toolinsertlist) {
        if(sEventTK == tk.RecordTypeId 
        || eventTK == tk.RecordTypeId
        || mediaTK == tk.RecordTypeId){
            if(sEventTK == tk.RecordTypeId ){
                tk.Approver__c = DealerIDAccount.get(TKIdDealerId.get(tk.id)).Retail_smart_Owner__c;
            }else if(tk.Brand__c == 'MB'){
                tk.Approver__c = DealerIDAccount.get(TKIdDealerId.get(tk.id)).Retail_MB_Owner__c;
            }else if (tk.Brand__c == 'smart'){
                tk.Approver__c = DealerIDAccount.get(TKIdDealerId.get(tk.id)).Retail_smart_Owner__c;
            }else if (tk.Brand__c == 'AMG'){
                tk.Approver__c = DealerIDAccount.get(TKIdDealerId.get(tk.id)).Retail_AMG_Owner__c;
            }else if (tk.Brand__c == 'StarElite'){
                tk.Approver__c = DealerIDAccount.get(TKIdDealerId.get(tk.id)).Retail_Star_Elite_Owner__c;
            }
            if(tk.Approver__c == null && DealerIDAccount.containsKey(TKIdDealerId.get(tk.id))){
               tk.Approver__c = DealerIDAccount.get(TKIdDealerId.get(tk.id)).Ownerid;
            }
        }
        if(Trigger.isInsert) {
            if(sEventTK == tk.RecordTypeId ){
                tk.Apply_Status__c = 'Tool Kit Finished';
            }
            if (tk.Plan_Start_Date__c == null) {
                tk.Original_Plan_Start_Date__c = System.today();
            } else {
                tk.Original_Plan_Start_Date__c = tk.Plan_Start_Date__c;
            }
            // Set the region information according to the dealer.
            if(DealerIDAccount.get(tk.Dealer_Name__c) != null) {
                tk.Dealer_Region__c = DealerIDAccount.get(tk.Dealer_Name__c).Dealer_Region__c;
                tk.Dealer_Sub_Region__c = DealerIDAccount.get(tk.Dealer_Name__c).Dealer_MB_Sub_Region__c;
            }
          
          /*
            // zhongyang.si add for Release 1.3 CR7, When user created Took Kit record, the system automatically finds vendor according to the tool kit information
            for(Model_Mapping__c vtk : vendorForToolKitList){
                if (vtk.region__c!=null && vtk.RecordType__c!=null && vtk.Brand__c!=null){
                    if ( vtk.region__c.equalsIgnoreCase(tk.Dealer_Region__c) && vtk.RecordType__c.equalsIgnoreCase(Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByID().get(tk.recordtypeid).getName()) && vtk.Brand__c.containsIgnoreCase(tk.Brand__c)){
                        tk.Vendor_Employee__c = vtk.user__c;
                    }                
                }
            }
            */
            // zhongyang.si add for Release 1.3 CR7, When user created Took Kit record, the system automatically finds vendor according to the tool kit information
        }
    }
        
    }
        
}