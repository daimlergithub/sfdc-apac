public class AccountlinkhelperMY{

    AccountLinkHelperBase alb=new AccountLinkHelperBase();
    
    public void ValidateC2CAfterUpdateInsert(List<Account_link__C> acclinklist,String Market,boolean isinsert, boolean isupdate,Map<id,sobject> oldmapAL ){
        AccountLinkHelperBase.validateC2C(acclinklist,Label.MY,isinsert,isupdate,oldmapAL );
    }
    
    public  void afterInsertEventShareRetailCopy(List<Account_link__C> acclinklist){
        alb.afterInsertEventShareRetailCopy(acclinklist);
    }
    
    public  void afterInsertEventShareAccount(List<Account_link__C> acclinklist){
        alb.afterInsertEventShareAccount(acclinklist);
    }
    
    public void addressupdateRT(List<Account_Link__c> alinks,Map<id,Account_Link__c> oldals){
        AccountLinkHelperBase.addressupdateRT(alinks,oldals);
    }
        
    public  void RevokeApexSharingAfterUpdate(List<Account_Link__c> newacclinkmap,Map<Id, Account_Link__c> oldacclinkmap,List<Account_Link__c> oldrec){
        alb.RevokeApexSharingAfterUpdate(newacclinkmap,oldacclinkmap,oldrec);
    }
}