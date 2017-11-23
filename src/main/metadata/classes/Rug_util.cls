/****************************************************************
 * Modified by : Sarath
 * Last Modified On : 11 Oct 2017
 * Company: Infosys Ltd
 * Description : Util Class for Test Methods
*****************************************************************/
@istest
public class Rug_util {
    
	public static testMethod list<Registered_Users__c> Registereduser(){    
        list<Registered_Users__c> regList=new list<Registered_Users__c>();
        Trigger__C rugtrigger=new Trigger__C(name='RegisteredUsersTriggerTH',after__c=true,before__c=true,delete__c=true,enabled__c=true,insert__c=true,Market__c='TH',Trigger_Handler__c='RegisteredUsersTriggerHandler',Trigger_Name__c='RegisteredUsersTrigger',update__c=true);
	    insert rugtrigger;
       /* String orgId = userInfo.getOrganizationId().substring(0,5);
    	String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        string datestr=dateString.substring(0,5);
    	Integer randomInt = Integer.valueOf(math.rint(math.random()*1000));
    	String uniqueName = orgId + datestr;
        Integer randomInt2 = Integer.valueOf(math.rint(math.random()*1000));
        String uniqueName2 = orgId + datestr + randomInt2;**/        
        Registered_Users__c TestRegUserUtil = new Registered_Users__c();
        TestRegUserUtil.First_Name__c = 'test324'+System.now().millisecond();
        TestRegUserUtil.EmailId__c = '1'+System.now().millisecond() +'@infosys.com';
        TestRegUserUtil.Last_Name__c='2'+System.now().millisecond();
        TestRegUserUtil.Request_Status__c='New';
        TestRegUserUtil.UserName__c='4'+System.now().millisecond()+'@rugcollaboration.com';
        insert TestRegUserUtil;
        reglist.clear();
        reglist.add(TestRegUserUtil);
		//insert regList;        
        return reglist;
    }
    public static testMethod list<user> userCreated(){        
        Profile p = [SELECT Id FROM Profile WHERE Name='Honorary Membership'];
        list<user> userlist=new list<user>();
        User TestUserUtil = new User();
        TestUserUtil.Alias = 'TestUser';
        TestUserUtil.Email='TestUser@testorg.daimlerasia.com';
        TestUserUtil.EmailEncodingKey='UTF-8';
        TestUserUtil.LastName='TestUser';
        TestUserUtil.LanguageLocaleKey='en_US';
        TestUserUtil.LocaleSidKey='en_US';
        TestUserUtil.ProfileId = p.Id;
        TestUserUtil.TimeZoneSidKey='America/Los_Angeles';
        TestUserUtil.UserName='TestUser@testorg.com.daimlerasia';
        
        insert TestUserUtil;
        userlist.add(TestUserUtil);
        system.assertEquals(TestUserUtil.LastName, 'TestUser');
        return userlist;
    }
    
     public static testMethod user honoraryProfileUser(){        
        Profile p = [SELECT Id FROM Profile WHERE Name='Honorary Member'];
        Account ac = new Account(name ='Grazitti') ;    
        User testUser = new User();
        testUser.Alias = 'TestUser';
        testUser.Email='TestUser@testorg.daimlerasia.com';
        testUser.EmailEncodingKey='UTF-8';
        testUser.LastName='TestUser';
        testUser.LanguageLocaleKey='en_US';
        testUser.LocaleSidKey='en_US';
        testUser.ProfileId = p.Id;
        testUser.TimeZoneSidKey='America/Los_Angeles';
        testUser.UserName='12346g@testorg.com.daimlerasia445645' ;
        insert testUser;   
		return testUser;
     }
    public static testMethod Ideas__c newIdea(){ 
   		Ideas__c newIdea = new Ideas__c(Name = 'Name251',Category__c = 'oCRM', Status__c = 'Open', Classification__c = 'Quality Improvement');
      
        Insert newIdea;
        return newIdea;
    }

}