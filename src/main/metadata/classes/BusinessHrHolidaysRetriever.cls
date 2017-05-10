public with sharing class BusinessHrHolidaysRetriever {

    public static List<Holiday> retrieveHolidays(BusinessHours bh) {
        if(bh == null || bh.Id == null) {
            throw new InvalidDataException('Failed to retrieve holidays for a given business hour. Input business hour is invalid');
        }
        List<BusinessHours> bHrs = [SELECT Id FROM BusinessHours WHERE Id = :bh.Id];
        if(bHrs.isEmpty()) {
            throw new InvalidDataException('Failed to retrieve holidays for a given business hour. Input business hour is invalid');
        }
        PageReference pg = new PageReference(BusinessHrHolidaysRetrieverConstants.HOLIDAY_URL_PREFIX + bh.Id);
        Blob content = Blob.valueOf(BusinessHrHolidaysRetrieverConstants.BLOB_CONTENT_FOR_HOLIDAY_TEST);
        if(!System.Test.isRunningTest()) {
            content = pg.getContent();
        }
        Set<String> holidayIds = retrieveBusinessHourHolidays(BusinessHrHolidaysRetrieverConstants.HOLIDAY_PREFIX, content);
        List<Holiday> holidays = [  SELECT SystemModstamp, StartTimeInMinutes, RecurrenceType, RecurrenceStartDate, RecurrenceMonthOfYear, 
                                        RecurrenceInterval, RecurrenceInstance, RecurrenceEndDateOnly, RecurrenceDayOfWeekMask, RecurrenceDayOfMonth, Name,
                                        LastModifiedDate, LastModifiedById, IsRecurrence, IsAllDay, Id, EndTimeInMinutes, Description, CreatedDate, CreatedById, ActivityDate 
                                    FROM Holiday 
                                    WHERE Id IN :holidayIds ];
        return holidays;
    }
    
 
    public static List<BusinessHours> retrieveBusinessHrs(Holiday holiday) {
        if(holiday == null || holiday.Id == null) {
            throw new InvalidDataException('Failed to retrieve business hours for a given holiday. Input holiday is invalid');
        }
        List<Holiday> holidays = [SELECT Id FROM Holiday WHERE Id = :holiday.Id];
        if(holidays.isEmpty()) {
            throw new InvalidDataException('Failed to retrieve business hours for a given holiday. Input holiday is invalid');
        }
        PageReference pg = new PageReference(BusinessHrHolidaysRetrieverConstants.BUSINESS_HR_URL_PREFIX + holiday.Id);
        Blob content = Blob.valueOf(BusinessHrHolidaysRetrieverConstants.BLOB_CONTENT_FOR_HOLIDAY_TEST);
        if(!System.Test.isRunningTest()) {
            content = pg.getContent();
        }
        Set<String> businessHrIds = retrieveBusinessHourHolidays(BusinessHrHolidaysRetrieverConstants.BUSINESS_HR_PREFIX, content);        
        List<BusinessHours> bHrs = [SELECT WednesdayStartTime, WednesdayEndTime, TuesdayStartTime, TuesdayEndTime, TimeZoneSidKey, 
                                        ThursdayStartTime, ThursdayEndTime, SystemModstamp, SundayStartTime, SundayEndTime, SaturdayStartTime, 
                                        SaturdayEndTime, Name, MondayStartTime, MondayEndTime, LastModifiedDate, LastModifiedById, IsDefault, IsActive, 
                                        Id, FridayStartTime, FridayEndTime, CreatedDate, CreatedById 
                                    FROM BusinessHours WHERE Id IN :businessHrIds];
        return bHrs;
    }
    
    public static Set<String> retrieveBusinessHourHolidays(String keyPrefix, Blob content) {
        Integer tableStartIndex = content.toString().indexOf(BusinessHrHolidaysRetrieverConstants.PAGE_BODY_CLASS);
        String subStr = content.toString().substring(tableStartIndex);
        subStr = subStr.substring(subStr.indexOf(BusinessHrHolidaysRetrieverConstants.TABLE_ROW_END));
        String strWithBusinessHrHolidays = subStr.substring(subStr.indexOf(BusinessHrHolidaysRetrieverConstants.TABLE_HEADER_START));
        Set<String> recordIds = new Set<String>();
        while(strWithBusinessHrHolidays.contains(keyPrefix)) {
            String strWithRecordId = strWithBusinessHrHolidays.substring(strWithBusinessHrHolidays.indexOf(BusinessHrHolidaysRetrieverConstants.ANCHOR_TAG_START), strWithBusinessHrHolidays.indexOf(BusinessHrHolidaysRetrieverConstants.ANCHOR_TAG_END));
            String recordId = strWithRecordId.substring(strWithRecordId.indexOf(BusinessHrHolidaysRetrieverConstants.HREF_STRING) + BusinessHrHolidaysRetrieverConstants.HREF_STRING.length(),strWithRecordId.indexOf(BusinessHrHolidaysRetrieverConstants.CLOSING_TAG));
            String recordName = strWithRecordId.substring(strWithRecordId.indexOf(BusinessHrHolidaysRetrieverConstants.CLOSING_TAG) + BusinessHrHolidaysRetrieverConstants.CLOSING_TAG.length());
            if(!recordId.contains(BusinessHrHolidaysRetrieverConstants.ROWSPERPAGE)) {              
                recordIds.add(recordId);  
                System.debug(recordId);
                System.debug(recordName);            
            }   
            strWithBusinessHrHolidays = strWithBusinessHrHolidays.substring(strWithBusinessHrHolidays.indexOf(BusinessHrHolidaysRetrieverConstants.ANCHOR_TAG_END) + BusinessHrHolidaysRetrieverConstants.ANCHOR_TAG_END.length());
        }
        return recordIds;
    }
    
    // This method is used to get all the dates of saturday and sunday
       public static List<Date> weekendDatesLst(Datetime sDate, Datetime eDate){
        List<Date> wendDatesLst = new List<Date>();
             while (sdate < edate){
                 string dayOfWeek = sdate.format('E');
                 if ( dayOfWeek == 'Sat' || dayOfWeek == 'Sun'){
                     wendDatesLst.add(Date.ValueOf(sdate));
                 }
                 sdate = sdate.addDays(1);
             }
             return wendDatesLst;
        }  
    
    public class InvalidDataException extends Exception {}
}