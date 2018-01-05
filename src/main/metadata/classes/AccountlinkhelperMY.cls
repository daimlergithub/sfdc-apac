/**
* Handler for Trigger on Case for MY(Malaysia)
* Author:Sanjay Nandi
* Created Date : 26th Sep 2017
* Utility for helperon Account_Link for MY(Malaysia)
* It will validate the duplicate
*/
public class AccountlinkhelperMY{

   
    public void ValidateC2CAfterUpdateInsert(List<Account_link__C> acclinklist,String Market,boolean isinsert, boolean isupdate,Map<id,sobject> oldmapAL ){
        AccountLinkHelperBase.validateC2C(acclinklist,Label.MY,isinsert,isupdate,oldmapAL );
    }
    
   
}