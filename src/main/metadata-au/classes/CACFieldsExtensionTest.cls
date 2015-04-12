/*
    Type:       test class
    Purpose:    CACFieldsExtension test class
    User Story: US-DPCR-002 - View and edit CAC Fields

    Used By:    CACFieldsExtension
    ---------------------------------------------------------------
    History:

    16-Jul-2013 Barney Lai (Nttdata)    Created
*/
@isTest(SeeAllData=true)
public class CACFieldsExtensionTest {
    public static testMethod void testCACFieldsExtension1(){
        Case c1 = new Case();
        insert c1;
        ApexPages.standardController controller = new ApexPages.standardController(c1);
        CACFieldsExtension extension = new CACFieldsExtension(controller);
        extension.isEdit = true; 
        extension.edit();
       
        extension.cancel();
        extension.save();
    }
}