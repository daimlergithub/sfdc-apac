@isTest
public class ContentDocumentLinkHandler_Test {
    @isTest
    public static void shareFilesWithCommunityUsers_Test(){
        News__c news = new News__c();
        news.Title__c = 'Test News1';
        news.Start_Date__c = Date.today();
        news.Expiration_Date__c = Date.today().adddays(5);
        news.Share_With_Groups__c = 'RCP_NewsReader_All';
        news.Save_As_draft__c = true;
        news.Need_approval__c = false;
        news.Description__c = 'test';
        insert news; 
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
        cdl.LinkedEntityId = news.id;
        cdl.ContentDocumentId = documents[0].Id;
        //cdl.shareType = 'I';
        insert cdl;
      	system.assert(cdl.Id != null);
        news.Save_As_Draft__c=false;
        news.DocStatus_FileUpload__c=false;
        update news;
        
        //create ContentDocumentLink  record 
        ContentDocumentLink cdl2 = New ContentDocumentLink();
        cdl2.LinkedEntityId = news.id;
        cdl2.ContentDocumentId = documents[0].Id;
        //cdl1.shareType = 'I';
        DmlException expectedException;
        try
        {
            // save record which should be prevented from saving
              insert cdl2;
        }
        catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Insert failed') ? true : false;
            System.AssertEquals(expectedExceptionThrown, true);
        }
       
    }
}