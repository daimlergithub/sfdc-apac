/**
* Handler for Trigger on Case for IN(India)
* Author:Namitha
* Created Date : 6th Mar 2018
* Utility for helperon Account_Link for IN(India)
* It will validate the duplicate
*/
public class AccountlinkHelperIN{

    AccountLinkHelperBase alb=new AccountLinkHelperBase();
    public void ValidateC2CAfterUpdateInsert(List<Account_link__C> acclinklist,String Market,boolean isinsert, boolean isupdate,Map<id,sobject> oldmapAL ){
        AccountLinkHelperBase.validateC2C(acclinklist,Label.IN,isinsert,isupdate,oldmapAL);
    }
    //Start 07042018 : Namitha added to invoke share retailcopy and Account as part of ph2.
    public  void afterInsertEventShareRetailCopy(List<Account_link__C> acclinklist){
        alb.afterInsertEventShareRetailCopy(acclinklist);
    }
    public  void afterInsertEventShareAccount(List<Account_link__C> acclinklist){
        alb.afterInsertEventShareAccount(acclinklist);
    }
    //ends
}