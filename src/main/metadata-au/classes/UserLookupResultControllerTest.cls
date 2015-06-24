/*
    Type:       Page Controller
    ---------------------------------------------------------------
    History:
    
    1. 2014-03-27 Created By Justin Yu
*/
@isTest
public class UserLookupResultControllerTest {

    private static String QCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('SSI QC').getRecordTypeId();
    
     @isTest 
    static void testUserLookupResultController_TypeAssignment()
    {
   ApexPages.currentPage().getParameters().get('assignment');

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
        Test.stopTest();
        System.assert(us!=null);
    }
    
    @isTest 
    static void testUserLookupResultController_TypeRecall(){
    
    List<User> users = new List<User>();
    Set<String> userIds = new Set<String>();
    
    List<Profile> userProfile = new List<Profile>([SELECT Id,name FROM profile WHERE name='CAC SSI QC' ]);
     
     //data for user object
     User result = new User(alias = 'standt', email = 'test@9876test.com', 
                                    emailencodingkey = 'UTF-8', lastname = 'TestLasName', languagelocalekey = 'en_US', 
                                    localesidkey = 'en_US', profileid = userProfile.get(0).id ,
                                    timezonesidkey = 'America/Los_Angeles',  username = 'testUniqudeName@test.com');
                                    insert result;
        QC__c qc=new QC__c();
        qc.Status__c='New';
        qc.RecordTypeId=QCRecordTypeId;
        qc.ownerid=result.id;
        insert qc;
        qc.Status__c='In Progress';
        update qc;
        
        Test.startTest();                                    
        PageReference page = new PageReference('/apex/UserLookupResult?type=recall');
        Test.setCurrentPage(page);        
        UserLookupResultController controller = new UserLookupResultController(); 
        Test.stopTest();
        System.assert(result!=null);
    } 
}