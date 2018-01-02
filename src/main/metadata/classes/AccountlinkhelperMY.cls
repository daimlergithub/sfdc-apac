public class AccountlinkhelperMY{

    AccountLinkHelperBase alb=new AccountLinkHelperBase();
    
    public void ValidateC2CAfterUpdateInsert(List<Account_link__C> acclinklist){
        alb.validateC2C(acclinklist,Label.MY);
    }
    
   
}