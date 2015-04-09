public with sharing class GenericCSVLoaderController {

    @RemoteAction
    public static List<Database.SaveResult> uploadObjects(List<sObject> records) {
        Database.SaveResult[] result = Database.update(records, false);
        return result;
    }
    
    @RemoteAction
    public static List<Database.SaveResult> uploadAccounts(List<Account> records) {
        Integer Byear;
        Integer Bmonth;
        Integer Bday;
        String filename;
        Integer Index;
        String thirdPartyRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('3rd Party').getRecordTypeId();
        for(Account acc : records) {
            if(!String.isBlank(acc.Branch_name_CHS__c)) {
                system.debug('---------' + acc.Branch_name_CHS__c);
                if(acc.Branch_name_CHS__c.split('/').size() == 3) {
                    Byear = Integer.valueOf(acc.Branch_name_CHS__c.split('/')[0]);
                    Bmonth = Integer.valueOf(acc.Branch_name_CHS__c.split('/')[1]);
                    Bday = Integer.valueOf(acc.Branch_name_CHS__c.split('/')[2]);
                    acc.PersonBirthDate = date.newinstance(Byear, Bmonth, Bday);
                    acc.Branch_name_CHS__c = '';
                }
                else if(acc.Branch_name_CHS__c.split('-').size() == 3) {
                    Byear = Integer.valueOf(acc.Branch_name_CHS__c.split('-')[0]);
                    Bmonth = Integer.valueOf(acc.Branch_name_CHS__c.split('-')[1]);
                    Bday = Integer.valueOf(acc.Branch_name_CHS__c.split('-')[2]);
                    acc.PersonBirthDate = date.newinstance(Byear, Bmonth, Bday);
                    acc.Branch_name_CHS__c = '';
                }
            }
            filename = acc.File_Name__pc;
            Index = filename.LastIndexOf('\\');
            acc.RecordTypeId = thirdPartyRTId;
            acc.File_Name__pc = acc.File_Name__pc.Substring(Index + 1);
        }
        Database.SaveResult[] result = Database.insert(records, false);
        return result;
    }
}