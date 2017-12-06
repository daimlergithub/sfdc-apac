public class TriggerAccountlinkHandlerTH implements TriggerHandlerIf
{
    public void handleTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
    Set<ID> acclids=new Set<ID>();
    List<Account_Link__c>acclinkr=[Select Id from Account_Link__c where id IN:trigger.new];
    for(Account_Link__c accrec:acclinkr){
        acclids.add(accrec.id);
    }
    AccountLinkHelperTH acchelper=new AccountLinkHelperTH();
    /* Data Migration Explicit Fix - Santosh Mohanty */
    if(Trigger.isBefore && Trigger.isUpdate){
       AccountLinkHelper.updatemarket(Trigger.New);
    }
    if(Trigger.isAfter && (Trigger.isupdate||Trigger.isInsert)){
    System.debug('hello');
        acchelper.afterInsertEventShareRetailCopy(Trigger.new);
        acchelper.afterInsertEventShareAccount(Trigger.new); 
        if(Trigger.isInsert && acclids.size() >0)  
        {   
            if(TriggerRecursiveCheck.run){
                TriggerRecursiveCheck.runOnce();
                CDMInformatica_Services.createAccountLink(acclids,'TH','insert');
            }
        }
    }
    Map<id,Id> ldMap =new Map<Id,Id>();
    
    for(Lead__c ld : [select id,name,Retail_Contact__c,Retail_Company__c from Lead__c where Retail_Contact__c in:acclids OR Retail_Company__c in :acclids])
    {
        if(ld.Retail_Contact__c != null)
            ldMap.put(ld.Retail_Contact__c,ld.id);
        if(ld.Retail_Company__c != null)
            ldMap.put(ld.Retail_Company__c,ld.id);
    }
    if(Trigger.isAfter && Trigger.isupdate){
    for(Account_Link__c al: (List<Account_Link__c>)Trigger.new)
    {   
        if(TriggerRecursiveCheck.run)
        {
            TriggerRecursiveCheck.runOnce();
            CDMInformatica_Services.createAccountLink(acclids,'TH','update');
        }
        Account_Link__c alold = (Account_Link__c)Trigger.oldMap.get(al.Id);
        if(al.Retail_DMS_Customer_ID__c != alold.Retail_DMS_Customer_ID__c && alold.Retail_DMS_Customer_ID__c == '' && ldMap.containskey(al.Id))
        {
            //callout CDM === lead +accountlinkMagicno + UCID
            //ldMap.value(al.Id)
            
        }
        
    }
    acchelper.RevokeApexSharingAfterUpdate(Trigger.new,(Map<Id,Account_Link__c>)Trigger.oldmap,Trigger.Old);
    }
    }
    public void handleIntegrationTrigger(boolean isInsert,boolean isUpdate,boolean isBefore, boolean isDelete,boolean isAfter)
    {
      // Implementation to addedd as required in market
    }
}
