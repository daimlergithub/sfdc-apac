trigger ShareToolKits on Tool_Kit__c (after insert, after update) {
    if (!UtilCustomSettings.isEnabled('ShareToolKits')) {
        return;
    }
    
    if(Trigger.isAfter && Trigger.isInsert) {
        // Shares new tool kits to campaign users and 3rd party users.
        TookKitSharingWrapService wrapService = new TookKitSharingWrapService();
        SharingService.shareToolKits(wrapService.wrapToolKits(Trigger.new));
        SharingService.shareToolKits(wrapService.wrapToolKitsFor3rdPartyUsers(Trigger.new));
    }
    else if(Trigger.isAfter && Trigger.isUpdate) {
        // Updates the dealer sharing if a tool kit's dealer has changed.
        List<Tool_Kit__c> dealerChangedToolKits = new List<Tool_Kit__c>();
        for(Id toolKitId : Trigger.newMap.keySet()){
            if(Trigger.oldMap.get(toolKitId).Dealer_Name__c != Trigger.newMap.get(toolKitId).Dealer_Name__c){
                dealerChangedToolKits.add(Trigger.newMap.get(toolKitId));    
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
            if(Trigger.oldMap.get(toolKitId).Vendor_Employee__c != Trigger.newMap.get(toolKitId).Vendor_Employee__c){
                vendorChangedToolKits.add(Trigger.newMap.get(toolKitId));    
            }
        }
        delete [select Id from Tool_Kit__Share where parentId in :vendorChangedToolKits and RowCause = :Schema.Tool_Kit__Share.RowCause.Third_Party_User_Share__c];
        if(!vendorChangedToolKits.isEmpty()){
            SharingService.shareToolKits(wrapService.wrapToolKitsFor3rdPartyUsers(vendorChangedToolKits));
        }
    }
}