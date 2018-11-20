@isTest
public class ContentLinkRestriction_Test {
    @isTest
    Public static void InsertContentLinkRestriction_Test(){
        Community_Files__c CF = new Community_Files__c();
        CF.Name = 'Test File';
        CF.Expiration_Date__c = Date.today().adddays(1);
        //CF.Sharing_Level__c = 'Viewer';
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
        try{
            ContentDocumentLink cd2 = New ContentDocumentLink();
            cd2.LinkedEntityId = CF.id;
            cd2.ContentDocumentId = documents[0].Id;
            cd2.shareType = 'V';
            insert cd2;
        }catch(Exception e){
            Boolean expectedExceptionThrown =  e.getMessage().contains('Insert failed') ? true : false;
			System.AssertEquals(expectedExceptionThrown, true);
        }
        
        //System.assertEquals(System.DmlException, System.DmlException, 'true');
    }
}