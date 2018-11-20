public class Utility_FM {

    public static User getLoggedInUserInfo()
    {
        User loggedInUser=[select Id, market__c,ProfileId,Profile.Name from User where Id=:UserInfo.getUserId()];
        return loggedInUser;
    }
}