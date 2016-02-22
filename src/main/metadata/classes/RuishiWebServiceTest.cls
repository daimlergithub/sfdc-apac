@isTest
public class RuishiWebServiceTest
{
  
  
  static testMethod void testRuishiWebServerSoap1()
  {
      RuishiWebService.CreateUser_element CreateUser=new RuishiWebService.CreateUser_element();
      RuishiWebService.CreateUserResponse_element CreateUserResponse= new RuishiWebService.CreateUserResponse_element();      
  }

   static testMethod void testRuishiWebServerSoap2() {
     Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
     User usr = new User(Alias = 'tData171', Email='testdata171@testing.com', 
     EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
     LocaleSidKey='en_US', ProfileId = p.Id, 
     TimeZoneSidKey='America/Los_Angeles', UserName='testdata171@testing.com');
     insert usr;    
    try{
    Test.startTest();
          TestUserTriggerCalloutRequestMock fakeResponse = new TestUserTriggerCalloutRequestMock(200,
                                                 'Complete',
                                                 '[{"Name": "sForceTest1"}]',
                                                 null);
         Test.setMock(HttpCalloutMock.class, fakeResponse);
         
         UserTriggerCallout.syncUser(usr.Id,usr.Username,usr.UserRole.Name,usr.Profile.Name,usr.Phone,usr.Email);
         Test.stopTest();
         }
         catch(Exception e){
         }

    }

}