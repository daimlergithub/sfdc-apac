/* ***********************************************************************************
* Created By:kavya 
* Created Date:12-July-2018
* Modified Date:23-Oct-2018
* Company:Infosys Ltd
* Description: Community File  handler test class.
* **********************************************************************************/
@isTest
public class CommunityFileHandler_Test {
     @isTest
    public static void CommunityFileShare_Test()
    {
        //create Community File
        Community_Files__c CF = new Community_Files__c();
        CF.Name = 'Test File';
        CF.Expiration_Date__c = Date.today().adddays(1);        
        CF.SelectedGroups__c = 'testgroup';
        CF.SelectedUsers__c = 'testuser';
        insert CF; 
        ContentVersion contentVersion = new ContentVersion(
            Title = 'PenguinsFile',
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
        CF.Expired__c=true;
        update CF;
    }
}