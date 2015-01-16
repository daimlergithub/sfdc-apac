/*
    Type:       Trigger
    Purpose:    ToolKit 
    User Story: ToolKit
    Used By:    
    ---------------------------------------------------------------
    History:
    
    18-jun-2014 Shuang Li    Created
    3rd-July-2014 CC    Updated
    2014-10-17 zhongyang.si updated for Release 1.3 CR7(automatically assign the vendor for the tool kit)
*/
trigger ToolKitBeforeInsertUpdateDelete on Tool_Kit__c (before insert, before update) {
   if (!UtilCustomSettings.isEnabled('ToolKitBeforeInsertUpdateDelete')) {
        return;
   }
    
   Map<String, Schema.RecordTypeInfo> tkRecordTypeMap = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName();
   Id sEventTK = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('smart Event').getRecordTypeId();
   Id eventTK = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('Event').getRecordTypeId();
   Id mediaTK = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('Media').getRecordTypeId();
   Map<Id, Id> TKIdDealerId = new Map<Id, Id>();
   Map<Id, Account> DealerIDAccount = new Map<Id, Account>();
   
   // zhongyang.si add for Release 1.3 CR7, load the Model_Mapping__c data
   List<Model_Mapping__c> vendorForToolKitList = new List<Model_Mapping__c>();
   for(Model_Mapping__c vtk : [SELECT id,Brand__c,RecordType__c, Region__c, User__c FROM Model_Mapping__c WHERE recordtype.developername = 'Tool_Kit']){
       vendorForToolKitList.add(vtk);
   }
   // zhongyang.si add for Release 1.3 CR7, load the Model_Mapping__c data
   
   for(Tool_Kit__c tk1 : trigger.new) {
    if(tk1.Dealer_Name__c != null) {
        TKIdDealerId.put(tk1.id, tk1.Dealer_Name__c);
    }
   }
   for(Account a : [select id, Dealer_Region__c, Dealer_MB_Sub_Region__c, Retail_AMG_Owner__c, Ownerid, Retail_AS_Owner__c, Retail_Star_Elite_Owner__c, Retail_MB_Owner__c, Retail_smart_Owner__c from Account where id in :TKIdDealerId.values()]) {
        DealerIDAccount.put(a.id, a);
   }
   for(Tool_Kit__c tk : trigger.new) {
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
          
            // zhongyang.si add for Release 1.3 CR7, When user created Took Kit record, the system automatically finds vendor according to the tool kit information
            for(Model_Mapping__c vtk : vendorForToolKitList){
                if (vtk.region__c!=null && vtk.RecordType__c!=null && vtk.Brand__c!=null){
                    if ( vtk.region__c.equalsIgnoreCase(tk.Dealer_Region__c) && vtk.RecordType__c.equalsIgnoreCase(Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByID().get(tk.recordtypeid).getName()) && vtk.Brand__c.containsIgnoreCase(tk.Brand__c)){
                        tk.Vendor_Employee__c = vtk.user__c;
                    }                
                }
            }
            // zhongyang.si add for Release 1.3 CR7, When user created Took Kit record, the system automatically finds vendor according to the tool kit information
        }
    }
}