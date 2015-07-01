@isTest
public class ReportUserControllerTest {

    public static testmethod void testGetTheResults()
    {
        ReportUserController objReportUserController = new ReportUserController();
         objReportUserController.getTheResults();
        system.assertNotEquals(null, objReportUserController.getTheResults());
    }
}