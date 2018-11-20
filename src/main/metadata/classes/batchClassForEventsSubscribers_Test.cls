/************************************************************************************
* Project:RCP Indonesia : Dealer Community Indonesia
* Created By:Narendra.I
* Created Date:26-Oct-2018
* Company:Infosys Ltd
* Description:Test class for batchClassForEventsSubscribers
* **********************************************************************************/
@istest
public class batchClassForEventsSubscribers_Test {
    @istest    
    public static void testschedule() {
        Events__c event = new Events__c();
        Date dt= System.today();
        event.Name='Test';
        event.Start_Time__c = dt.addDays(1);
        event.End_Time__c = dt.addDays(2);
        event.Registration_Start_Time__c = dt.addDays(0);
        event.Registration_End_Time__c = dt.addDays(1);
        event.Number_of_Registrations__c = 2;
        insert event;
        
        Test.StartTest();
        batchClassForEventsSubscribers sh1 = new batchClassForEventsSubscribers();      
        String sch = '0 0 23 * * ?';
        system.schedule('Test check', sch, sh1);
        Test.stopTest();        
    }

}