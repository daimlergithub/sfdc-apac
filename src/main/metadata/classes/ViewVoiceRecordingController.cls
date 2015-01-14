/*
    Type:       controller
    Purpose:    ViewVoiceRecording page Controller
    User Story: US-CTI-001 - view voice recording for a IB Call or OB Call

    Used By:    VF Page - ViewVoiceRecording.page
    ---------------------------------------------------------------
    History:

    21-June-2013 Sinow (Nttdate)    Created

*/
public class ViewVoiceRecordingController {
    
    public List<String> VoiceLinks { get; set; }
    private String WARNING = 'Voice url prifix is null, please contact administrator';
    
    public ViewVoiceRecordingController(ApexPages.StandardController stdController) {      
        Task task =  (Task)stdController.getRecord();
        task = [select InteractionIds__c from Task where Id = :task.Id];
        String InterActionIds = task.InteractionIds__c;
        List<App_Setting__c> appSetting = [select Value__c from App_Setting__c where Name = 'Voice Recording Location' limit 1];
        VoiceLinks = new List<String>();
        
        if(InterActionIds != null && InterActionIds != '') {
            if(appSetting.size() == 1) {
                for(String interActionId : InterActionIds.split(',')) {
                    VoiceLinks.add(appSetting[0].Value__c + interActionId.trim());
                }
            }
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,WARNING)); 
            }
        }
    }
}