/************************************************************************************
* Project:RCP Indonesia : Dealer Community Indonesia
* Created By:Narendra.I
* Created Date:25-Sep-2018
* Company:Infosys Ltd
* Description:Test class for reportForGroups class.
* **********************************************************************************/
@isTest
public class communityFileReport_Test {
    @isTest
    public static void getfileDetails_Test(){
        Community_Files__c CF = new Community_Files__c();
        CF.Name = 'Test File';
        CF.Expiration_Date__c = Date.today().adddays(1);
        CF.Sharing_Level__c = 'Viewer';
        CF.SelectedGroups__c = 'Test';
        CF.SelectedUsers__c = 'Standard User';
        insert CF;
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
        communityFileReport.getfileDetails();
    }
}