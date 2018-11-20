/************************************************************************************
* Project:RCP Indonesia : Dealer Community Indonesia
* Created By:Narendra.I
* Created Date:31-Aug-2018
* Company:Infosys Ltd
* Description:Test class for eventController.
* **********************************************************************************/
@isTest
public class eventController_Test {
    @isTest
    public static void LatestEvents_Test(){
        Test.StartTest();
        eventController.LatestEvents();
        eventController.SubscribeEvents(true);
        eventController.SubscribeEvents(false);
        eventController.getSubscribeEvent();       
        Test.stopTest();
    }
    @isTest
    public static void LatestEvents_Test1(){
        Test.StartTest();
        Events__c event = new Events__c();
        Date dt= System.today();
        event.Name='Test';
        event.Start_Time__c = dt.addDays(1);
        event.End_Time__c = dt.addDays(2);
        event.Registration_Start_Time__c = dt.addDays(0);
        event.Registration_End_Time__c = dt.addDays(1);
        event.Number_of_Registrations__c = 2;
        insert event;
        eventController.validate(event.Id);
        Test.stopTest();
    }
}