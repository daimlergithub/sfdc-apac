@isTest
Public class NiceWebServicesTest{
    
  static testMethod void testNiceWebServices()
  {
      NiceWebServices.Exception_x Except=new NiceWebServices.Exception_x();
      NiceWebServices.Throwable_element Throwable= new NiceWebServices.Throwable_element();    
  }
  public static testMethod void testNiceServiceHttpSoap11Endpoint()
    {
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
      User usr = new User(Alias = 'tData888', Email='testdata888@testing.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='testdata888@testing.com');
      insert usr;     
      String InteractionId=AvatoHelper.getInteractionIds(usr.id,system.now());
    } 
 }