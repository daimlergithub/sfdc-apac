@isTest
public class UtilCustomSettingsTest {
    private static testmethod void testCustomSettings(){
         Community_License_Switch__c cls=new Community_License_Switch__c();
        cls.name='Community Enabled';
        cls.Enable__c=true;
        insert cls;
        UtilCustomSettings.getOrgWideDefaultAddress('test');       
        UtilCustomSettings.getProfileId('System Administrator');
        UtilCustomSettings.getIsEnableCommunity('Community Enabled');
        system.assertEquals(true, UtilCustomSettings.getIsEnableCommunity('Community Enabled'));
        
    }

}