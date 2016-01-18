public class TestUserCreate{
    
    private static Profile profile = [select Id from Profile where Name = 'System Administrator'];
    private static string en_US='en_US';

    //This method creates market specific user for testing.
    public static User createuserrecord(String market){
        User user1 = new User(ProfileId = profile.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichaof',
        Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
        TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = en_US,
        EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = en_US,Market__c = market);
        insert user1; 
        
        return user1;
    }

}