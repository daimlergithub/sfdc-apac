/*
    Type:       test class
    Purpose:    VehicleRelLookingController test class
    User Story: Release 1.2 Report S&M R006

    Used By:    VehicleRelLookingController
    ---------------------------------------------------------------
    History:

    9-Jun-2014 Sinow    Created
*/
@isTest(SeeAllData=true)
public class VehicleRelLookingControllerTest {
    public static testMethod void testVehicleRelLookingController ()
    {
    	Test.startTest();
        Account dealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        Contact conComplaint = new Contact(AccountId = dealer.Id, LastName = 'b', Phone = '1212313', email = 's@s.s', Dealer_Complaint_Gate_Keeper__c = true, Dealer_Presales__c = true);
        insert conComplaint;
        PageReference vehicleRelLooking = Page.VehicleRelLooking;
        vehicleRelLooking.getParameters().put('id',conComplaint.id);
        Test.setCurrentPage(vehicleRelLooking);
        VehicleRelLookingController extension = new VehicleRelLookingController();
        Test.stopTest();
        System.assertEquals(conComplaint.AccountId,dealer.Id);
        System.assert(conComplaint!=null);
    }
}