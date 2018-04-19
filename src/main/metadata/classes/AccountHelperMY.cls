/**
* Utility for Trigger on Account for MY(Malaysia)
* Author: Mohammed Touseef Ahmed
* Created Date : 2017-01-23
*History:
    Author                         Date                    Description
    Mohd Touseef(MT20170913)    2017/09/13            //MT20170913- Added market Descrminator MY
    
*/

public class AccountHelperMY{

    public static void updateAccountFieldsBeforeInsert(list<Account> listNewAccounts,boolean isInsert){
        AccountHelperBase.updateAccountFieldsBeforeInsert(listNewAccounts,isInsert);
        AccountHelperBase.updateMarketingFields(listNewAccounts);
    }
    
	public static void updateAccountFieldsBeforeInsertInt(list<Account> listNewAccounts,boolean isInsert){
        AccountHelperBase.updateAccountFieldsBeforeInsertInt(listNewAccounts,isInsert);
        AccountHelperBase.updateMarketingFields(listNewAccounts);
    }
	
    public static void ValidateNationalid(List<account> ListAccount){
        AccountHelperBase.ValidateNationalid(ListAccount);
    }
    
    public static void updateAccountFieldsBeforeUpdate(list<Account> listNewAccounts,map<id,Account> accountOldMap,boolean isUpdate){
        AccountHelperBase.updateAccountFieldsBeforeUpdate(listNewAccounts,accountOldMap,isUpdate);
        AccountHelperBase.updateMarketingFields(listNewAccounts);
    }
	
    public static void updateAccountFieldsBeforeIntUpdate(list<Account> listNewAccounts,map<id,Account> accountOldMap,boolean isUpdate){
        AccountHelperBase.updateAccountFieldsBeforeIntUpdate(listNewAccounts,accountOldMap,isUpdate);
        AccountHelperBase.updateMarketingFields(listNewAccounts);
    }
	
    public static void updatePrimaryAddressdisplay(list<Account> listNewAccounts,boolean isUpdate,Map<id,account>accountOldMap ){
        AccountHelperBase.updatePrimaryAddressdisplay(listNewAccounts,isUpdate,accountOldMap);
    } 
    
    public static void updateOnDoNotCall(list<Account> listNewAccounts){
        AccountHelperBase.updateOnDoNotCall(listNewAccounts);
    }
    
    public static void updateOnPostalOptout(list<Account> listNewAccounts){
        AccountHelperBase.updateOnPostalOptout(listNewAccounts);
    }
    
    public static void updateOnEmailOptout(list<Account> listNewAccounts){
        AccountHelperBase.updateOnEmailOptout(listNewAccounts);
    }
    
    public static void updateAgeRange(list<Account> listNewAccounts){
        AccountHelperBase.updateAgeRange(listNewAccounts);
        for(account acc : listNewAccounts ){
            if(string.isnotblank(acc.Age_Range__c)?acc.Age_Range__c=='Unknown':False)
            acc.Age_Range__c = '0-17';
        
        }
    }
    
    public static void activeContracts(list<Account> listNewAccounts){
        AccountHelperBase.activeContracts(listNewAccounts);    
    }
    
    public static void createUCID(list<Account> TriggerNew,boolean isInsert){
        AccountHelperBase.createUCID(TriggerNew,isInsert);    
    }
    
    public static void createUpdateCDMUCID(string updateType, string MarketDiscriminator, list <account> accountlist){
        AccountHelperBase.createUpdateCDMUCID(updateType,MarketDiscriminator,accountlist);    
    }
    
    public static void CreateRetailCopy(list<Account> accLst, boolean isInsert, boolean isUpdate){
        AccountHelperBase.CreateRetailCopy(accLst,isInsert,isUpdate);    
    }
    
    public static void updateRetailCopy(boolean isUpdate, boolean isinsert,boolean isafter,List<Account> accLst){
        AccountHelperBase.updateRetailCopy(isUpdate,isinsert,isafter,accLst);    
    } 
    
	/*
                //Created By : Mohammed Touseef Ahmed
                //Date: 01/09/2018
                //Description: Create Account Link record in CDM as Retail Copy
            
    */
    public static void createAccountLinkCDM(list<Account> listNewAccounts,map<id,Account> accountOldMap){
        AccountHelperBase.DealerCommAccountlinkcreatecdm(listNewAccounts,accountOldMap);        
    }
     @future(callout=true)
    public static void entityNotifyUpdate(string updateType,String sfdcId,String MarketDiscriminator,string serlializedObject){
        AccountHelperBase.entityNotifyUpdate(updateType,sfdcId,MarketDiscriminator,serlializedObject);    
    }
	 public static void updatePrimaryAddressDetailsOnALK(List<Account> newAcc, Map<ID, Account> oldAccMap){
        AccountHelperBase.updatePrimaryAddressDetailsOnALK(newAcc, oldAccMap);
    } 
    
         /**
     *SN20171411-  SM1-177
    * Calculate “Age Range” based on birthdate.
    * Change from the previous method is if the birthdate is less than 18 years then it will have 0-16
    */
    
    
}