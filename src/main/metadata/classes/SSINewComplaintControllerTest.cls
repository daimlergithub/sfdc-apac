@IsTest
private with sharing class SSINewComplaintControllerTest {

    static testMethod void myUnitTest() {
        Test.startTest();
         Test.setCurrentPage(Page.SSINewComplaintEnd);
        SSINewComplaintController con = new SSINewComplaintController();
        con.newComplaint();
        Test.stopTest();
        system.assertNotEquals(null, con);
    }
}