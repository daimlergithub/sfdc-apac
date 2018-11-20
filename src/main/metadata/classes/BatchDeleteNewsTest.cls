/**
Type:       Test Class 
Purpose:    1. Code coverage for UserTriggerRCP, UserTriggerRCPHandler and BatchDeleteNews batch class. 

User Story: RCP-26
Used By:    
---------------------------------------------------------------
History:

14-August-2018 Surendranath  Created
*/
@isTest
private class BatchDeleteNewsTest {
    
    static testmethod void test_multiple() {
        Map<String,ID> profiles = new Map<String,ID>();
        List<Profile> ps = [select id, name from Profile where name =
                            'Standard User' or name = 'System Administrator'];
        for(Profile p : ps){
            profiles.put(p.name, p.id);
        }
        
        User userTest = new User(alias = 'standt',email='usertest@testorg.com',
                                 emailencodingkey='UTF-8',lastname='Testing', languagelocalekey='en_US',localesidkey='en_US',
                                 profileid = profiles.get('System Administrator'),timezonesidkey='America/Los_Angeles',
                                 username=System.now().millisecond() + 'testDaimlerUser212121@Daimler-test.com',isActive = true);
        insert userTest;
        
         User userTest1 = new User(alias = 'standt1',email='usertest1@testorg.com',
                                 emailencodingkey='UTF-8',lastname='Testing1', languagelocalekey='en_US',localesidkey='en_US',
                                 profileid = profiles.get('System Administrator'),timezonesidkey='America/Los_Angeles',
                                 username=System.now().millisecond() + 'testDaimlerUser2121221211@Daimler-test.com',isActive = true);
        insert userTest1;
        
        List<News__c> lstNews = new List<News__c>();
        Date dt= System.today();
        for(Integer j=0;j<50;j++){
            lstNews.add(new News__c(Title__c='TestNews'+j, Start_date__c = dt+1, Expiration_date__c= dt+5,Save_As_Draft__c = true, ownerid = userTest.Id));
        }
        insert lstNews;
        User user = new user(ID = UserInfo.getUserID());
        System.runAs(user){   
            Test.startTest();
            List<user> userList = new List<User>();
            User u=new User();
            u.IsActive = false;
            u.Id = userTest.Id;
            userList.add(u);
 			User u1=new User();
            u1.IsActive = false;
            u1.Id = userTest1.Id;
			userList.add(u1);
			update userList;            
            Test.stopTest();
        }
        // after the testing stops, assert records were updated properly
        System.assertEquals(0, [select count() from News__c where Save_As_draft__c = true and OwnerId =: userTest.Id]);
    }    
    
}