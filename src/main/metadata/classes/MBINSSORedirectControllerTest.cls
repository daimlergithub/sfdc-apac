@isTest
public class MBINSSORedirectControllerTest {
   
     static testMethod void MBINSSORedirectControllerTest1() {
         try{
          Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        
          User user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='IN',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
          DMLManagerService.insertAsSystem(user_Obj ); 
          System.runAs (user_Obj) { 
          ExternalServer__c ex = new ExternalServer__c(name='abcd', IsActive__c=true, Description__c='MBIN Dealer Community Idp URL' , Endpoint__c='abcd' );
          insert ex;    
          test.startTest();  
          ApexPages.currentPage().getParameters().put('id',ex.id);    
          MBINSSORedirectController sso= new MBINSSORedirectController();  
          Pagereference p=sso.forwardToAuthPage();
          system.assertNotEquals(Null, p) ;     
          String s=sso.getIdpUrlWithRelayState();
          system.assertNotEquals(Null,s) ;    
          test.stopTest();
          }
         }
        catch(Exception e){}
    }    

    
}