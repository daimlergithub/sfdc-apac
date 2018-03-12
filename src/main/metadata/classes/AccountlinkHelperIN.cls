/**
* Handler for Trigger on Case for IN(India)
* Author:Namitha
* Created Date : 6th Mar 2018
* Utility for helperon Account_Link for IN(India)
* It will validate the duplicate
*/
public class AccountlinkHelperIN{

   
    public void ValidateC2CAfterUpdateInsert(List<Account_link__C> acclinklist,String Market,boolean isinsert, boolean isupdate,Map<id,sobject> oldmapAL ){
        AccountLinkHelperBase.validateC2C(acclinklist,Label.IN,isinsert,isupdate,oldmapAL );
    }
    
   
}