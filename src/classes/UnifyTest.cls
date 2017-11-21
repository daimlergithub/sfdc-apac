@isTest(seeAllData=false)
public with sharing class UnifyTest{
 
       public static testMethod void testUnify()
        {
            Profile p1 = [select id from profile where Name='System Administrator' limit 1];
            User usera = new User(LastName='SAM',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',
            TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='test@email.com',
            UserName='dimeloblah@email.com',extension='0661234567');
            insert usera;
            test.StartTest();
            Unify.getExtension();
            test.stoptest();
                
        }
           
}