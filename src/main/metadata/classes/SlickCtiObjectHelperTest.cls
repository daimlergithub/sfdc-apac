@isTest
public with sharing class SlickCtiObjectHelperTest
{

 static testMethod void TestThisSlick() {
 List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
insert updatecustomsettings;

 Test.StartTest();
        String objectId = '/003d000000kCQtI';
        String returnedObjectType =  SlickCtiObjectHelper.getObjectType(objectId);
        SlickCtiObjectHelper soh=new SlickCtiObjectHelper();
        Test.StopTest();
        // I should assert that it returns Contact but 
        //I don't want that to get in the way of the installation if it doesn't so commented it out
        System.assertEquals(returnedObjectType, 'Contact');     
        system.assertNotEquals(null,soh);  
    }    
    

}