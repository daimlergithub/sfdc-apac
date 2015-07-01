/*
    Type:       Test class of ViewVoiceRecordingController
    Purpose:    1. ViewVoiceRecording page Controller
    
    User Story: US-CTI-001 - view voice recording for a IB Call or OB Call
    Used By:   VF Page - ViewVoiceRecording.page 
    ---------------------------------------------------------------
    History:
    
    19-Jul-2013 Barney Lai (NTTData)  Created
*/  

@isTest(SeeAllData=true)
public class ViewVoiceRecordingControllerTest {
    public static testMethod void testViewVoiceRecordingController1(){
        Task t1 = new Task(InteractionIds__c = 'test');
        insert t1;
        ApexPages.standardController controller = new ApexPages.standardController(t1);
        ViewVoiceRecordingController extension = new ViewVoiceRecordingController(controller);
        system.assertNotEquals(null, extension);
    }
}