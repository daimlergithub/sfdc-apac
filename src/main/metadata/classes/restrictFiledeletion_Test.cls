@isTest
public class restrictFiledeletion_Test {
    @isTest
    public static void restrictFiledeletiontrigger_Test(){
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

        //create ContentDocumentLink  record for that account
        ContentDocumentLink cdl = New ContentDocumentLink(
                    LinkedEntityId = CF.id, ContentDocumentId = documents[0].Id, shareType = 'V');
        insert cdl;

       

        Test.startTest();
        try { delete documents; }
        catch (Exception dmx) 
        { 
           Boolean expectedExceptionThrown = dmx.getMessage().contains('Approval pending. You do not have the permission to edit/delete this note/attachment, please contact your administrator.') ? true : false; 
           System.assertEquals(expectedExceptionThrown, true);  
        }

        //Also it can tested like this through Apexpages.Message

        List<Apexpages.Message> msgs;
        msgs = ApexPages.getMessages();
            boolean isErrorMessage = false;
            for(ApexPages.Message msg : msgs)
            {
                if (msg.getSummary().contains('Approval pending.') )
                {
                    isErrorMessage  = true;
                }
            }
        //System.debug('testing messages');
        //System.assert(isErrorMessage);

        Test.stopTest();    
        
    }
}