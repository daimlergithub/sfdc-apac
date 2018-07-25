@isTest
public class Batch_vehiclerelshareTest
{

public static Account personAccount;
public static List<Account> accList;
         public static testMethod void testAfterInsert()
    {
    
            UserRole portalRole1 = [Select Id From UserRole Where name='Call Center' Limit 1];           
        Profile p1 = [select id,name from profile WHERE Name='System Administrator'];  
        User user_Obj = new User(Alias = 'standt', Email='testUser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US',UserRoleId = portalRole1.Id, 
                          LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='JP',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser2@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
         system.runAs(user_Obj)
        {
    Date todaydate=System.today();
       Vehicle__c vehicles = new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B200',
                  EuroVIN__c='11111222221111122', UsVIN__c='11111222221111122',Latest_Sales_Person__c='xxx',
                  Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'),Purchase_Month__c ='02',Purchase_Year__c='2004',RegistrationNo__c ='787878');
       insert vehicles;  
        Account personAccount =  new Account(FirstName='Test',LastName='Person Account',Md__c='JP', Individual_Home_Phone__c='+66-9885857857', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT).getRecordTypeId());    
       Vehicle_Relationship__c vRel = new Vehicle_Relationship__c(Recall__c = FALSE,contact__c=personAccount.Id,selling_dealer__c=personAccount.Id, Car_Relation__c = 'User', RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId());
       
       vRel.Vehicle_ID__c = vehicles.id;
       insert vRel;  
          
     
     List <Vehicle_Relationship__c> lds = new List<Vehicle_Relationship__c>();
for(integer i = 0; i<200; i++){
 Vehicle_Relationship__c vRel1 = new Vehicle_Relationship__c(Recall__c = FALSE,contact__c=personAccount.Id,selling_dealer__c=personAccount.Id, Car_Relation__c = 'User', RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId());
       
       vRel1.Vehicle_ID__c = vehicles.id;
lds.add(vRel1);
}
insert lds;

   Test.startTest();
       Batch_vehiclerelshare batcher = new Batch_vehiclerelshare ();  
        Database.executeBatch(batcher, 300);
       batcher.execute(null,lds);

    Test.stopTest();   

}
}
}