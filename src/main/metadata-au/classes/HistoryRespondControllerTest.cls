/*
    Type:       test class
    Purpose:    HistoryRespondController test class
    User Story: SMS

    Used By:    HistoryRespondController
    ---------------------------------------------------------------
    History:

    2013-12-09 lishuang (Nttdata)    Created
*/
@isTest
public class HistoryRespondControllerTest {
    public static testMethod void testHistoryRespondController1(){
        Task t1 = new Task();
        insert t1;
        ApexPages.standardController controller = new ApexPages.standardController(t1);
        HistoryRespondController c1= new HistoryRespondController(controller);
        c1.getTheResults();
        system.assertNotEquals(null, c1.getTheResults());
    }
}