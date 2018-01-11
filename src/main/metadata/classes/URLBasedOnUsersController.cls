public class URLBasedOnUsersController
{
    public String siteUrl {get;set;}
    public String sfdcBaseURL{get;set;}
    public URLBasedOnUsersController()
    {
        Network myNetwork = [SELECT Id FROM Network WHERE Name ='Daimler Community Thailand'];
        siteUrl = Network.getLoginUrl(myNetwork.id);
        siteUrl =siteUrl.substringBefore('/login');
        sfdcBaseURL = URL.getSalesforceBaseUrl().toExternalForm();
    }
    
}