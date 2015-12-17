/*
    Type:       Test class of ViewVoiceRecordingController
    Purpose:    1. ViewVoiceRecording page Controller    
    User Story: US-CTI-001 - view voice recording for a IB Call or OB Call
    Used By:   VF Page - ViewVoiceRecording.page 
    History:    
    19-Jul-2013 Barney Lai (NTTData)  Created
*/  

@isTest
public with sharing class ViewVoiceRecordingControllerTest {
Private static ViewVoiceRecordingController extension;
Private static App_Setting__c app;
    public static testMethod void testViewVoiceRecordingController1(){
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;
        Task t1 = new Task(InteractionIds__c = 'test');
        app= new App_Setting__c ();
        app.name='Voice Recording Location';
        app.Value__c='test@gmail.com';
                
        Test.StartTest();
        insert t1;
        insert app;        
        ApexPages.standardController controller = new ApexPages.standardController(t1);
        extension = new ViewVoiceRecordingController(controller);
        Test.stopTest();
        system.assertNotEquals(null,t1);
        system.assertEquals(app.name,'Voice Recording Location');
        system.assertNotEquals(null,extension);
    }
}