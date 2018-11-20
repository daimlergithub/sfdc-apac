public class AccountlinkhelperMY{
    public static Id retailPerson_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c','Retail Person');
    public static Id retailCompany_RecordTypeId = RecordTypeAccessService.getRecordTypeId('Account_Link__c','Retail Company');
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
    
    public void InvokeCDMAccountlinkContaxt(List<Account_link__C> acclinklist,String Market,string context ){
        AccountLinkHelperBase.CDMAccountlinkContextGroup(acclinklist,market,context );
    }
     public void OnAfterUpdateCreateC2CRetailCopy(List<Account_Link__c> alinks,Map<id,Account_Link__c> oldals){
        AccountLinkHelperBase.OnAfterUpdateCreateC2CRetailCopy(alinks,oldals);
    }
    
    public void updateFoundationMonth(List<Account_link__C> acclinklist,boolean isinsert, boolean isupdate){
    Map<id,account> accMap= new Map<id,account>();
    set<id> strId= new set<id>();
     for(Account_link__C retailacc: acclinklist){
            if(retailacc.recordtypeid == retailCompany_RecordTypeId){
                if((isinsert || isupdate) && string.isnotblank(retailacc.Retail_Foundation_Month__c) && string.isnotblank(retailacc.torole__c)) strId.add(retailacc.torole__c); 
            }
        }
    if(strId.size()>0){
        accMap.putall([select id,Foundation_Date__c from account where id in: strId]);
        for(Account_link__C retailacc: acclinklist){
        if(retailacc.recordtypeid == retailCompany_RecordTypeId){
            if(string.isnotblank(retailacc.Retail_Foundation_Month__c) && string.isnotblank(retailacc.torole__c)){
                Account a = accMap.get(retailacc.torole__c);
                retailacc.Retail_Foundation_Month__c =  (String.ValueOf(a.Foundation_Date__c.month()).length() == 1 ? ('0' + String.ValueOf(a.Foundation_Date__c.month())) :String.ValueOf(a.Foundation_Date__c.month()))+String.valueOf(a.Foundation_Date__c.year());
            }
        }
     }
    }
    }
    
    public void RemoveAccessofUsers(List<Account_Link__c> alinks){
        AccountLinkHelperBase.RemoveAccessofUsers(alinks,Label.MY);
    }
    
    //Added below code for Calling Informatica service for Integration user for Stouch By Ashish Jadhav 5th Oct, 2018 
    public void callCDMServiceforInsertUpdateForStouch(List<Account_link__C> acclinklist,String market,boolean isinsert, boolean isupdate,Map<id,Account_link__C> oldmapAL ){
        AccountLinkHelperBase.callCDMServiceforInsertUpdateForStouch(acclinklist,market,isinsert,isupdate,oldmapAL);
    }
}