/************************************************************************************
* Project:RCP Indonesia : Dealer Community Indonesia
* Created By:Narendra.I
* Created Date:02-Aug-2018
* Company:Infosys Ltd
* Description:Test class for FileUploadController class.
* **********************************************************************************/
@isTest
public class FileUploadController_Test {
    @isTest
    public static void getFileStatus_Test(){
        Community_Files__c CF = createrec();
        ContentVersion contentVersion = new ContentVersion(
            Title = 'Penguins',
            PathOnClient = 'Penguins.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );
        insert contentVersion;    
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = CF.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        insert cdl;
        FileUploadController.getFileStatus(CF.Id);        
    }    
    @isTest
    public static Community_Files__c createrec(){
        Community_Files__c CF = new Community_Files__c();
        CF.Name = 'Test File';
        CF.Expiration_Date__c = Date.today().adddays(1);
        CF.Sharing_Level__c = 'Viewer';
        CF.SelectedGroups__c = 'Test';
        CF.SelectedUsers__c = 'Standard User';
        insert CF; 
        return CF;
    }
    @isTest
    public static void getFileDetails_Test(){
        FileUploadController.getFileDetails(createrec().Id);
    }
    @isTest
    public static void UpdateFile_Test(){
        Community_Files__c CF = createrec();
        String dt = String.valueOf(CF.Expiration_Date__c);
        //FileUploadController.UpdateFile(CF.Name, dt, CF.Sharing_Level__c, CF.Id, CF.SelectedUsers__c, CF.SelectedGroups__c);
    }
    @isTest
    public static void getrelatedFileStatus_Test(){
        FileUploadController.getrelatedFileStatus(createrec().Id);
    }
    
}