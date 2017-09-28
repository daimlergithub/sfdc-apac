@IsTest
private class BusinessHrHolidaysRetrieverTest{
    
    static user usr;
    static profile pro;
    
    public static user makeUser(){
        Profile pro = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User usr = new User(Alias = 'standt1',Country='United Kingdom',Email='demo1@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = pro.Id,TimeZoneSidKey='America/Los_Angeles', UserName='dprobertdemo1@camfed.org');
        
        return usr;       
    }
    
    private static testMethod void testForInvalidData() {
        System.Test.startTest();
        try{
            BusinessHrHolidaysRetriever.retrieveHolidays(null, makeUser());
            System.assert(false);
        } catch(Exception e) {
            System.assert(true);
        }
        try{
            BusinessHrHolidaysRetriever.retrieveHolidays(new BusinessHours(), makeUser());
            System.assert(false);
        } catch(Exception e) {
            System.assert(true);
        }
        try{
            BusinessHrHolidaysRetriever.retrieveBusinessHrs(null);
            System.assert(false);
        } catch(Exception e) {
            System.assert(true);
        }
        try{
            BusinessHrHolidaysRetriever.retrieveBusinessHrs(new Holiday());
            System.assert(false);
        } catch(Exception e) {
            System.assert(true);
        }
        System.Test.stopTest();
    }
    
    private static testMethod void testForValidBusinessHr() {
        System.Test.startTest();
        List<BusinessHours> bHrs = [SELECT Id FROM BusinessHours];
        if(bHrs.isEmpty()) {
            return;
        }
        
        List<Holiday> holidays = BusinessHrHolidaysRetriever.retrieveHolidays(bHrs[0], makeUser());
        System.assert(holidays != null);
        System.Test.stopTest();
    }
    
    private static testMethod void testForValidHoliday() {
        System.Test.startTest();
        List<Holiday> holidays = [SELECT Id FROM Holiday];
        if(holidays.isEmpty()) {
            return;
        }
        
        List<BusinessHours> bHrs = BusinessHrHolidaysRetriever.retrieveBusinessHrs(holidays[0]);
        System.assert(bHrs != null);
        System.Test.stopTest();
    }
    
    private static testMethod void testweekendDatesLst() {
        Date sDate = system.today();
        Date eDate = system.today() + 30;
        List<Date> dateLst  = BusinessHrHolidaysRetriever.weekendDatesLst(sDate, eDate);
        system.assertNotEquals(dateLst, null);
            
    }
    
    private static testMethod void testupdateCaseDeadLine(){
        string caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(UtilConstant.INQUIRY).getRecordTypeId();
        string perAccountId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        List<Id> caseIds = new List<Id>();
        Account pAcc = new Account();
           pAcc.RecordTypeId = perAccountId;
           pAcc.LastName = 'test';
           pAcc.Data_Source__c = 'Dealer Outlet';
           pAcc.MBK_Data_Source__c='Dealers';
           pAcc.MB_Customer_Info_Remove__c=true;
           insert pAcc;
           
           case cs = new case();
               cs.RecordTypeId = caseRecordTypeId;
               cs.AccountId = pAcc.id;
               cs.Status='Waiting for Response approval';
               insert cs;
               caseIds.add(cs.id);
                string caseJsonStr = JSON.serialize(caseIds);
               updateCaseDeadLine.caseDeadLinesetter(caseJsonStr);
    }
    
   
}
