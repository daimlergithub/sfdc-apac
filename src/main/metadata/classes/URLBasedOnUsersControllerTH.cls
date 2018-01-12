public class URLBasedOnUsersControllerTH{
public Lead__c baseurl{set;get;}
public Network myNetwork{set;get;}
public string siteUrl{set;get;}

public URLBasedOnUsersControllerTH(){
myNetwork =[SELECT Id FROM Network WHERE Name ='Dealer Community Thailand'];
        siteUrl = Network.getLoginUrl(myNetwork.id)!=null?Network.getLoginUrl(myNetwork.id):'';
        siteUrl =siteUrl.substringBefore('/login');

}
}