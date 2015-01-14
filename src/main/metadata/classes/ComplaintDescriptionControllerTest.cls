/*
    Type:       test class
    Purpose:    ComplaintDescriptionController test class
    User Story: SMS

    Used By:    ComplaintDescriptionController
    ---------------------------------------------------------------
    History:

    2013-12-09 lishuang (Nttdata)    Created
*/
@isTest
public class ComplaintDescriptionControllerTest {
    public static testMethod void testComplaintDescriptionController1(){

        ComplaintDescriptionController c1= new ComplaintDescriptionController();
        c1.getTheResults();
        c1.cancel();
    }
}