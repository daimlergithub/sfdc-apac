/**
    *@Description : This Class will incresse coverage AnnouncementController.
    *@Author : Kiran P.
    *@Date : 4/12/2017
    *@Release : Japan J4
    */
@isTest
public class AnnouncementController_test{
    public static testMethod void AnnouncementController_MT(){
       CollaborationGroup gp = new CollaborationGroup(Name = 'Dealer Community',CollaborationType = 'Public');
       insert gp;       
       AnnouncementController obj = new AnnouncementController();
       obj.detail = 'test';  
        obj.message= 'test';   
        obj.groupId ='test';   
      try{
       obj.doPost();
       }catch(exception e){}
    }
}