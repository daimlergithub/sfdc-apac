/**
Type:       Test class for EventRegTriggerHandler class and EventRegTrigger    
Purpose:    1. Code coverage for EventRegTriggerHandler class

User Story: RCP-83
Used By:    
---------------------------------------------------------------
History:

31-August-2018 Surendranath  Created
*/
@istest
public class EventRegTriggerHandler_Test {
    public static testMethod void testMethod1() {
        Events__c event = insertMethod();
        Registration__c er1= new Registration__c();
        er1.First_Name__c = 'Test1';
        er1.Last_Name__c = 'User1';
        er1.Email_Id__c = 'surendranath.p@infosys.com';
        er1.Contact_Number__c = '6886989765';
        er1.Country__c = 'India';
        er1.State__c = 'AP';
        er1.Related_Event__c = event.id;        
        Test.StartTest();
        try{
            insert er1;
        }
        catch(Exception e){            
            String expectedExceptionThrown =  e.getMessage();
            Boolean br = expectedExceptionThrown.contains('You are not allowed to register with the same email Id. Please use different email Id.');
            System.AssertEquals(true, br);           
        }		        
        Test.stopTest();
    }
    public static testMethod void testMethod2() {
        Events__c event = insertMethod();
        Test.StartTest();
        event.Name = 'Test Name123';
        update event;
        System.AssertEquals('Test Name123', [select Id,Name from Events__c where Id=:event.Id].Name);
        Test.stopTest();
    }
    
    public static Events__c insertMethod(){
        Date dt= System.today();
        Events__c event= new Events__c();
        event.Name = 'Test Event';
        event.Start_Time__c = dt;
        event.End_Time__c = dt+1;
        event.Details__c = 'Test Details';
        event.Agenda__c = 'Test Agenda';
        insert event;
        Registration__c er= new Registration__c();
        er.First_Name__c = 'Test';
        er.Last_Name__c = 'User';
        er.Email_Id__c = 'surendranath.p@infosys.com';
        er.Contact_Number__c = '6886989';
        er.Country__c = 'India';
        er.State__c = 'AP';
        er.Related_Event__c = event.id;
        insert er;
        return event;
    }
}