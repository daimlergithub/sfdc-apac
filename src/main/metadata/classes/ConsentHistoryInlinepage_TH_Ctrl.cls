public with sharing class ConsentHistoryInlinepage_TH_Ctrl {
    
    public String AccountId { get;set; }
    public List<Account_Field_History_Tracker__c> fieldHistoryList { get;set; }
    
    public ConsentHistoryInlinepage_TH_Ctrl(ApexPages.StandardController controller) {
        Account acc = (Account)controller.getRecord();
        AccountId = acc.Id;
        fieldHistoryList = [Select Id, Account_Record_Id__c, Lastest_Consent_Date__c, Personal_Agreement__c, System_Data_Source__c,Updated_Consent_Date__c, User_Organization__c,
                                    Updated_Consent_User__c, Changed_By_Id__c from Account_Field_History_Tracker__c where Account_Record_Id__c =: AccountId 
                                    ORDER BY CreatedDate DESC];
    }

}