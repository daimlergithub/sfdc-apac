/**
** Execute AvatoHelper 
** Created By: Sneha Chail
** Created Date: 2016-01-28
**/
@isTest
Public class AvatoHelperTest{

  // "AvatoHelper" class would be called //
  public static testMethod void testAvatoHelper()
    {
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User usr = new User(Alias = 'tData777', Email='testdata777@testing.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='testdata777@testing.com');
      insert usr;     
      String InteractionId=AvatoHelper.getInteractionIds(usr.id,system.now());
    }
    
 }