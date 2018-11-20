/**
Type:       Test class for BatchNewsReminderEmails    
Purpose:    1. Code coverage for BatchNewsReminderEmails class

User Story: RCP-53
Used By:    
---------------------------------------------------------------
History:

23-August-2018 Surendranath  Created
*/
@istest
public class BatchNewsReminderEmails_Test { 
    public static testMethod void testschedule() {
        List<News__c> lstNews = new List<News__c>();
        Date dt= System.today();
        for(Integer j=0;j<5;j++){
            lstNews.add(new News__c(Title__c='TestNews'+j, Start_date__c = dt+1, Expiration_date__c= dt+5,Save_As_Draft__c = false,Need_Approval__c= true, WorkFlow_Group__c = 'Sales', Approver_List__c='Sales Manager;Sales Director',Approval_Status__c='Pending',Send_Reminder__c=true));
        }
        for(Integer j=5;j<10;j++){
            lstNews.add(new News__c(Title__c='TestNews'+j, Start_date__c = dt+1, Expiration_date__c= dt+5,Save_As_Draft__c = false,Need_Approval__c= true, WorkFlow_Group__c = 'After Sales', Approver_List__c='After Sales Committee;After Sales Manager',Approval_Status__c='Pending',Send_Reminder__c=true));
        }
        for(Integer j=10;j<15;j++){
            lstNews.add(new News__c(Title__c='TestNews'+j, Start_date__c = dt+1, Expiration_date__c= dt+5,Save_As_Draft__c = false,Need_Approval__c= true, WorkFlow_Group__c = 'Marketing', Approver_List__c='Marketing Manager',Approval_Status__c='Pending',Send_Reminder__c=true));
        }
        for(Integer j=15;j<20;j++){
            lstNews.add(new News__c(Title__c='TestNews'+j, Start_date__c = dt+1, Expiration_date__c= dt+5,Save_As_Draft__c = false,Need_Approval__c= true, WorkFlow_Group__c = 'Network Development', Approver_List__c='ND Manager',Approval_Status__c='Pending',Send_Reminder__c=true));
        }
        insert lstNews;
        Test.StartTest();
        BatchNewsReminderEmails testsche = new BatchNewsReminderEmails();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
    }
}