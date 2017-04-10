@isTest
public class testusernotification{

public static testmethod void init(){

Profile p = [select id from profile where name='Standard User'];

        User u = new User(alias = 'test123', email='test123@noemail.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
           Notification_Lead_Dealer_Assignment__c='789',Notification_Lead_Not_Assigned__c='123', Notification_Lead_No_Update__c='456',
            timezonesidkey='America/Los_Angeles', username='test123@noemail.com');
        insert u;
       
System.runas(u){


 String DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
      
      
       pagereference p1 = page.usernotificationsetting;
        test.setCurrentPage(p1);
         
         Account a1=new Account();       
        a1.RecordtypeId=DealerAccRecordTypeId;
        a1.Name='Test Person 1st';
        a1.Type='Personal';
        a1.Dealer_ND_Code__c='123';
        a1.Dealer_Email__c='test123@noemail.com';
        insert a1;
       
        apexpages.currentPage().getparameters().put('id', u.id);
        
       
 ApexPages.StandardController stdDS = new ApexPages.StandardController(u);
 usernotificationsetting uns=new usernotificationsetting(stdDS);
List<SelectOption> selOpts=uns.leftacc ;

system.assertEquals(1,selOpts.size());


}
}
public static testmethod void testaddit(){
Profile p = [select id from profile where name='Standard User'];
String DealerAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        User u = new User(alias = 'test123', email='test123@noemail.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
           Notification_Lead_Dealer_Assignment__c='789',Notification_Lead_Not_Assigned__c='123', Notification_Lead_No_Update__c='456',
            timezonesidkey='America/Los_Angeles', username='test123@noemail.com');
        insert u;
     Account a2=new Account();       
        a2.RecordtypeId=DealerAccRecordTypeId;
        a2.Name='Test Person 1st';
        a2.Type='Personal';
        a2.Dealer_ND_Code__c='123';
       insert a2;
        
 pagereference p1 = page.usernotificationsetting;
        test.setCurrentPage(p1);
         apexpages.currentPage().getparameters().put('id', u.id);
ApexPages.StandardController std = new ApexPages.StandardController(a2);
usernotificationsetting usernoti=new usernotificationsetting(std);
List<SelectOption> selectopt=usernoti.rightacc;
usernoti.addit();
usernoti.addit1();
usernoti.addit2();
usernoti.updateit();
//usernoti.cancelit();
system.assertEquals(0,selectopt.size());
}



}