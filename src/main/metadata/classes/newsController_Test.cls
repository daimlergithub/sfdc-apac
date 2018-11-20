/************************************************************************************
* Project:RCP Indonesia : Dealer Community Indonesia
* Created By:Narendra.I
* Created Date:12-July-2018
* Company:Infosys Ltd
* Description:Test class for newsController class.
* **********************************************************************************/
@isTest
public class newsController_Test {
    @isTest
    public static void SubscribeNews_Test(){
        newsController.SubscribeNews(true);
        newsController.SubscribeNews(false);
    }
    @isTest
    public static void recentNews_Test(){
        newsController.recentNews();        
    }
    @isTest
    public static void detailedFile_Test(){
        News__c news = new News__c();
        news.Title__c = 'Test News';
        news.Start_Date__c = Date.today();
        news.Expiration_Date__c = Date.today().adddays(5);
        news.Share_With_Groups__c = 'RCP_NewsReader_All';
        //news.Document_Status__c = 'Expired';
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
        newsController.detailedFile(documents[0].Id, news.Id);
    }
    @isTest
    public static void getFiles_Test(){
        
        News__c news = new News__c();
        news.Title__c = 'Test News';
        news.Start_Date__c = Date.today().adddays(1);
        news.Expiration_Date__c = Date.today().adddays(5);
        news.Share_With_Groups__c = 'RCP_NewsReader_All';
        //news.Document_Status__c = 'Expired';
        news.Save_As_draft__c = true;
        news.Need_approval__c = false;
        news.Description__c = 'test';
        insert news; 
        //
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
        newsController.getFiles(news.Id);
        
    }
    @isTest
    public static void approveNews(){
        
        try{
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User u = new User(Alias = 'standt', Email='admin@testorg.com', 
                              EmailEncodingKey='UTF-8', LastName='Testing123', LanguageLocaleKey='en_US', 
                              LocaleSidKey='en_US', ProfileId = p.Id, 
                              TimeZoneSidKey='America/Los_Angeles', UserName=System.now().millisecond() + 'testDaimler@Daimler-test.com');
            
            System.runAs(u) {
                // The following code runs as user 'u' 
                System.debug('Current User: ' + UserInfo.getUserName());
                System.debug('Current Profile: ' + UserInfo.getProfileId()); 
                
                News__c news = new News__c();
                news.Title__c = 'Test News 1';
                news.Start_Date__c = Date.today();
                news.Expiration_Date__c= Date.today() +1;
                news.Description__c = 'test news';
                news.Share_With_Groups__c='RCP_NewsReader_Restricted_1';
                news.Need_approval__c = true;
                news.WorkFlow_Group__c='Sales';
                news.Approver_List__c='Sales Director';
                insert news;
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitting request for approval.');
                req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                req.setObjectId(news.Id);
                Approval.ProcessResult resu = Approval.process(req);
                // Verify the results
                system.debug('status for approval::'+resu.getInstanceStatus());
                
                List<Id> newWorkItemIds = resu.getNewWorkitemIds();
                system.debug('newWorkItemIds ::'+newWorkItemIds );
                
                Approval.ProcessWorkitemRequest req2 =  new Approval.ProcessWorkitemRequest();
                req2.setComments('Approving request.');
                req2.setAction('Approve');
                req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});//UserInfo.getUserId()
                system.debug('req2::'+req2);
                // Use the ID from the newly created item to specify the item to be worked
                req2.setWorkitemId(newWorkItemIds.get(0));
                system.debug('req3::'+req2);
                // Submit the request for approval
                Approval.ProcessResult result2 =  Approval.process(req2);
                // Verify the results
                system.debug('status for approval::'+result2.getInstanceStatus());
                
            }
        }catch(Exception e){
            system.debug('Exception in catch:'+e);
        }
        
    }
    @isTest
    public static void updateNews_Test(){
        News__c news = new News__c();
        news.Title__c = 'Test News 1';
        news.Start_Date__c = Date.today();
        news.Expiration_Date__c= Date.today() +1;
        news.Description__c = 'test news';
        news.Share_With_Groups__c='RCP_NewsReader_Restricted_1';
        news.Need_approval__c = false;
        insert news;
        system.assert(news.Id != null);
        newsController.updateNews(news.Id);        
        
    }
}