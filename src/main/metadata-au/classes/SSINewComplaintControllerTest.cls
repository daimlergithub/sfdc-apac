@isTest
private class SSINewComplaintControllerTest {

    static testMethod void myUnitTest() {
        SSINewComplaintController con = new SSINewComplaintController();
        con.newComplaint();
        system.assertNotEquals(null, con);
       
    }
}