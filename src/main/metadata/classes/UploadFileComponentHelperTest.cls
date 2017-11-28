/************************************************************************************
* Created By:Sarath M
* Created Date:21-sept-17
* Company:Infosys Ltd
* Description: 
1. Testclass for uploadFileComponent controller
* ***********************************************************************************/

@isTest
private class UploadFileComponentHelperTest{
    
    static testMethod void uploadFileComponentNew_Test(){
        ideas__c ideaTest1=Rug_util.newIdea();        
        uploadFileComponentHelper.saveChunk(ideaTest1.id, 'abcd', 'testasbdc', 'text', '');
    }    
    
     static testMethod void uploadFileComponentAppend_Test(){
        ideas__c ideaTest1=Rug_util.newIdea();
        ContentVersion oAttachment = new ContentVersion();
        oAttachment.Title = 'abcd';
        oAttachment.VersionData = EncodingUtil.base64Decode('tesjhfsdf');
        oAttachment.PathOnClient='/' + 'test123' ;
        insert oAttachment;  
        uploadFileComponentHelper.saveChunk(ideaTest1.id, 'abcd', 'testasbdc', 'text', oAttachment.id);
    }
}