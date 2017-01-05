/**
    *@Description : This Class will incresse coverage AnnouncementController.
    *@Author : Kiran P.
    *@Date : 4/12/2017
    *@Release : Japan J4
    */
@isTest
public class AnnouncementController_test{
    public static testMethod void AnnouncementController_MT(){
       CollaborationGroup gp = new CollaborationGroup(Name = 'All MgJ Users',CollaborationType = 'Private');
       insert gp;
       
       AnnouncementController obj = new AnnouncementController();
       obj.detail = 'test';
       obj.doPost();
    }
}