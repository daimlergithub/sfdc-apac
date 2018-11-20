@isTest
public class newsReport_Test {

@isTest
public static void getDetails_test(){
    

    News__c news = new News__c();
    news.Title__c = 'Test News';
    news.Start_Date__c = Date.today();
    news.Expiration_Date__c = Date.today().adddays(5);
    news.Share_With_Groups__c = 'RCP_NewsReader_All';
    news.Save_As_draft__c = true;
    news.Need_approval__c = false;
    news.Description__c = 'test';
    news.Category_Type__c='Logistic';
    insert news; 
    //inserting File
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
    //
    newsReport.getDetails();
    
}
}