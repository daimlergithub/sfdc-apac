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
}