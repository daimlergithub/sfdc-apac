/*
    Type:       Page Controller
    ---------------------------------------------------------------
    History:
    
    1. 2014-03-27 Created By Justin Yu
*/
@isTest
public with sharing class UserLookupResultControllerTest {
    private static String QCRecordTypeId = Schema.SObjectType.QC__c.getRecordTypeInfosByName().get('SSI QC').getRecordTypeId();
    private static List<Profile> userProfile;
    private static List<User> us;
    private static User result;
    private static Set<String> userIds;
    private static  String en_US='en_US';
    private static  UserLookupResultController controller;
    public static void preparedTestData()
    { 
     
     userIds= new Set<String>();
    
     userProfile = new List<Profile>([SELECT Id,name FROM profile WHERE name='CAC SSI QC' ]);
     
     //data for user object
     us=new List<User>();
      
     for(integer i=0;i<1;i++)
     {
      result = new User(alias = 'standt', email = 'test@9876test.com', 
                                    emailencodingkey = 'UTF-8', lastname = 'TestLasName', languagelocalekey = en_US, 
                                    localesidkey = en_US, profileid = userProfile.get(0).id ,
                                    timezonesidkey = 'America/Los_Angeles',  username = 'testUniqudeName@test.com');
                                    us.add(result);
                                    
                                    }
                                    insert us;
                                    
                                    List<user> lstuser=new list<User>();
                                    lstuser=[select id,username,alias,localesidkey,timezonesidkey,lastname from user];
                                  for(user user : lstuser){
            userIds.add(user.Id);
        }
    }
   
     @isTest 
    static void testUserLookupResultController_TypeAssignment()
    {
             preparedTestData();   
        Test.startTest();        
        PageReference page = new PageReference('/apex/UserLookupResult?type=assignment');
        Test.setCurrentPage(page);
        QC__c qc=new QC__c();
        qc.Status__c='New';
        qc.RecordTypeId=QCRecordTypeId;
        qc.ownerid=result.id;
        insert qc;
        qc.Status__c='In Progress';
        update qc;
        List<AggregateResult> aresult=[select OwnerId, COUNT(Id) qcSize from QC__c where RecordTypeId = '012O00000000flz'and Status__c = 'New'
                                      and Status__c = 'In Progress' and OwnerId in :userIds group by OwnerId];
        for(AggregateResult results : aresult)
         {
                                      
          }
                                      
      controller = new UserLookupResultController();
        Test.stopTest();
        System.assert(us!=null);     
        System.assert(userIds!=null);  
        System.assertNOtEquals(null,controller);
    }
    
    @isTest 
    static void testUserLookupResultController_TypeRecall(){
    
   
    userProfile = new List<Profile>([SELECT Id,name FROM profile WHERE name='CAC SSI QC' ]);
     
     //data for user object
      result = new User(alias = 'standt', email = 'test@9876test.com', 
                                    emailencodingkey = 'UTF-8', lastname = 'TestLasName', languagelocalekey = en_US, 
                                    localesidkey = en_US, profileid = userProfile.get(0).id ,
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
       controller = new UserLookupResultController(); 
        Test.stopTest();
        System.assert(result!=null);
        System.assertNOtEquals(null,controller);

    
    } 
}