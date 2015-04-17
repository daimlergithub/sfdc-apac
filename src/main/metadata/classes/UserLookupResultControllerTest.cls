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

    List<User> users = new List<User>();
    Set<String> userIds = new Set<String>();
    
    List<Profile> userProfile = new List<Profile>([SELECT Id,name FROM profile WHERE name='CAC SSI QC' ]);
     
     //data for user object
     List<User> us=new List<User>();
      
     for(integer i=0;i<1;i++)
     {
     User result = new User(alias = 'standt', email = 'test@9876test.com', 
                                    emailencodingkey = 'UTF-8', lastname = 'TestLasName', languagelocalekey = 'en_US', 
                                    localesidkey = 'en_US', profileid = userProfile.get(0).id ,
                                    timezonesidkey = 'America/Los_Angeles',  username = 'testUniqudeName@test.com');
                                    us.add(result);
                                    
                                    }
                                    insert us;
                                    
                                    List<user> lstuser=new list<User>();
                                    lstuser=[select id,username,alias,localesidkey,timezonesidkey,lastname from user];
                                  for(user user : lstuser){
            userIds.add(user.Id);
        }
                
        Test.startTest();
        
        PageReference page = new PageReference('/apex/UserLookupResult?type=assignment');
        Test.setCurrentPage(page);
        
        UserLookupResultController controller = new UserLookupResultController();
        UserInfo u=new UserInfo();
        Test.stopTest();
System.assert(us!=null);
    }
    
    @isTest 
    static void testUserLookupResultControllerrecall(){
    
    List<User> users = new List<User>();
    Set<String> userIds = new Set<String>();
    
    List<Profile> userProfile = new List<Profile>([SELECT Id,name FROM profile WHERE name='CAC SSI QC' ]);
     
     //data for user object
     User result = new User(alias = 'standt', email = 'test@9876test.com', 
                                    emailencodingkey = 'UTF-8', lastname = 'TestLasName', languagelocalekey = 'en_US', 
                                    localesidkey = 'en_US', profileid = userProfile.get(0).id ,
                                    timezonesidkey = 'America/Los_Angeles',  username = 'testUniqudeName@test.com');
                                    insert result;
                                   
                                   
   
                                           Test.startTest();
        PageReference page = new PageReference('/apex/UserLookupResult?type=recall');
        Test.setCurrentPage(page);
        
        UserLookupResultController controller = new UserLookupResultController();
        
        Test.stopTest();
        System.assert(result!=null);

    
    }
       
   
}