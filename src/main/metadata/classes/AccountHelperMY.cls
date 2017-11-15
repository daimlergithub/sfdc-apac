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
    }
    
    public static void ValidateNationalid(List<account> ListAccount){
        AccountHelperBase.ValidateNationalid(ListAccount);
    }
    
    public static void updateAccountFieldsBeforeUpdate(list<Account> listNewAccounts,map<id,Account> accountOldMap,boolean isUpdate){
        AccountHelperBase.updateAccountFieldsBeforeUpdate(listNewAccounts,accountOldMap,isUpdate);
    }
    
    public static void updatePrimaryAddressdisplay(list<Account> listNewAccounts,boolean isUpdate){
        AccountHelperBase.updatePrimaryAddressdisplay(listNewAccounts,isUpdate,System.Label.MarketMY);
    } 
    
    public static void updateOnDoNotCall(list<Account> listNewAccounts){
        AccountHelperBase.updateOnDoNotCall(listNewAccounts,System.Label.MarketMY);
    }
    
    public static void updateOnPostalOptout(list<Account> listNewAccounts){
        AccountHelperBase.updateOnPostalOptout(listNewAccounts,System.Label.MarketMY);
    }
    
    public static void updateOnEmailOptout(list<Account> listNewAccounts){
        AccountHelperBase.updateOnEmailOptout(listNewAccounts,System.Label.MarketMY);
    }
    
    public static void updateAgeRange(list<Account> listNewAccounts){
        AccountHelperBase.updateAgeRange(listNewAccounts,System.Label.MarketMY);
		for(account acc : listNewAccounts ){
			if(string.isnotblank(acc.Age_Range__c)?acc.Age_Range__c=='Unknown':False)
			acc.Age_Range__c = '0-17';
		
		}
    }
    
    public static void activeContracts(list<Account> listNewAccounts){
        AccountHelperBase.activeContracts(listNewAccounts);    
    }
    
    public static void createUCID(list<Account> TriggerNew,boolean isInsert){
        AccountHelperBase.createUCID(TriggerNew,isInsert,System.Label.MarketMY);    
    }
    
    public static void createUpdateCDMUCID(string updateType, string MarketDiscriminator, list <account> accountlist){
        AccountHelperBase.createUpdateCDMUCID(updateType,MarketDiscriminator,accountlist);    
    }
    
    public static void CreateRetailCopy(list<Account> accLst, boolean isInsert, boolean isUpdate){
        AccountHelperBase.CreateRetailCopy(accLst,isInsert,isUpdate,System.Label.MarketMY);    
    }
    
    public static void updateRetailCopy(boolean isUpdate, boolean isinsert,boolean isafter,List<Account> accLst){
        AccountHelperBase.updateRetailCopy(isUpdate,isinsert,isafter,accLst,System.Label.MarketMY);    
    } 
    
    @Future(callout=true)   
    public static void entityNotifyUpdate(string updateType,String sfdcId,String MarketDiscriminator,string serlializedObject){
        AccountHelperBase.entityNotifyUpdate(updateType,sfdcId,MarketDiscriminator,serlializedObject);    
    }
	
		 /**
	 *SN20171411-  SM1-177
    * Calculate “Age Range” based on birthdate.
	* Change from the previous method is if the birthdate is less than 18 years then it will have 0-16
    */
	
	
}