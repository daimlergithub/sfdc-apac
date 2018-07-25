/**
* Handler for Trigger on Case for TR(Turkey)
* Author:Hildaa
* Created Date : 27-02-2018
* Utility for helperon Account_Link for TR(Turkey)
* It will validate the duplicate
*/
public class AccountlinkhelperTR{

   
    public void ValidateC2CAfterUpdateInsert(List<Account_link__C> acclinklist,String Market,boolean isinsert, boolean isupdate,Map<id,sobject> oldmapAL ){
        AccountLinkHelperBase.validateC2C(acclinklist,Label.TR,isinsert,isupdate,oldmapAL );
    }
    //Added by Hildaa for Data of Consent Information
    public static void updateOnPostalOptout(list<Account_link__C> listNewAccounts){
       for(Account_link__C acclnk: listNewAccounts){
            if(!acclnk.Retail_Postal_OptIn__c){
                //acclnk.Retail_Postal_OptIn__c = false;
                acclnk.Retail_Address_Line_1__c = '';
                acclnk.Retail_Address_Line_2__c = '';
            }
       }
    }

    /**
    * Use Email Opt Out (Retail_Email_OptOut__c) to automate opt-out from email options.
    */
    public static void updateOnEmailOptout(list<Account_link__C> listNewAccounts){        
        for(Account_link__C acc: listNewAccounts){
            if(!acc.Retail_Email_OptIn__c){
                //acc.Retail_Email_OptIn__c = false;
                acc.Retail_Email__c = '';
            }
        }
    }
    
    public static void updateOnPhoneSMSoptout(list<Account_link__C> listNewAccounts){
        for(Account_link__C acc: listNewAccounts){
            if(!acc.Retail_Phone_OptIn__c && !acc.Retail_SMS_OptIn__c){
                acc.Retail_Mobile__c = '';
        acc.Retail_Individual_Home_Phone__c = '';
        acc.Retail_Work_Phone__c = '';
            }
            else if(!acc.Retail_Phone_OptIn__c && acc.Retail_SMS_OptIn__c)
            {
                acc.Retail_Individual_Home_Phone__c = '';
                
            }
            /*if(acc.Retail_Phone_OptOut__c ){
                acc.Retail_Phone_OptIn__c = false;
            }
            if(acc.Retail_SMS_OptOut__c ){
                acc.Retail_SMS_OptIn__c = false;
            }*/
            
        }
    }
    
   
    //END
}