/*
    Type:       Page Controller
    ---------------------------------------------------------------
    History:
    
    1. 2014-03-27 Created By Justin Yu
*/
@isTest
public class UserLookupResultControllerTest {
    
     @isTest 
    static void testUserLookupResultController(){
    String assignmentType = ApexPages.currentPage().getParameters().get('assignment');
        String assignmentType1 = ApexPages.currentPage().getParameters().get('recall');

    List<User> users = new List<User>();
    Set<String> userIds = new Set<String>();
    if(assignmentType == 'assignment')
    {
    List<Profile> userProfile = new List<Profile>([SELECT Id,name FROM profile WHERE name='CAC SSI QC' ]);
     
     //data for user object
     User result = new User(alias = 'standt', email = 'test@9876test.com', 
                                    emailencodingkey = 'UTF-8', lastname = 'TestLasName', languagelocalekey = 'en_US', 
                                    localesidkey = 'en_US', profileid = userProfile.get(0).id ,
                                    timezonesidkey = 'America/Los_Angeles',  username = 'testUniqudeName@test.com');
                                    insert result;
                                    }
                                    
                                    if(assignmentType == 'recall')
    {
    List<Profile> recallProfile = new List<Profile>([SELECT Id,name FROM profile WHERE name='CAC SSI SV' ]);
     
     //data for user object
     User result1 = new User(alias = 'standt', email = 'test@9876test.com', 
                                    emailencodingkey = 'UTF-8', lastname = 'TestLasName', languagelocalekey = 'en_US', 
                                    localesidkey = 'en_US', profileid = recallProfile .get(0).id ,
                                    timezonesidkey = 'America/Los_Angeles',  username = 'testUniqudeName@test.com');
                                    insert result1;
                                    }
        Test.startTest();
        PageReference page = new PageReference('/apex/UserLookupResult?type=assignment');
        Test.setCurrentPage(page);
        
        UserLookupResultController controller = new UserLookupResultController();
        UserInfo u=new UserInfo();
        Test.stopTest();
    }
      @isTest 
    static void testUserInfo(){
    
     Test.startTest();
     
     Integer qcCount=12;
            UserInfo u=new UserInfo();
        Test.stopTest();

    }
}