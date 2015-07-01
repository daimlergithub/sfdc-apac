@isTest
public class UtilCampaignShareByCollaborationTest
{
    
    private static Collaboration_Team__c cbt;
    private static Campaign cmp;
    public static user u1;
    public static testMethod void test_au_After_Insert_Update_Delete_Eventsinsert()
    {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runAs(thisUser){
        test.startTest();
        createTestdata();
        test.stopTest();
        CampaignShare cs = [select CampaignAccessLevel from CampaignShare where CampaignId =: cmp.id and UserOrGroupId =: cbt.Member_Name__c] ;
        system.assertEquals('Edit', cs.CampaignAccessLevel);
        }
    }
    
    public static testMethod void test_au_After_Insert_Update_Delete_Eventsupdate()
    {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runAs(thisUser){
        test.startTest();
        createTestdata();
        cbt.Access_Type__c = 'Read Only';   
        update cbt;
        test.stopTest();
        CampaignShare cs = [select CampaignAccessLevel from CampaignShare where CampaignId =: cmp.id and UserOrGroupId =: cbt.Member_Name__c] ;
        system.assertEquals('Read', cs.CampaignAccessLevel);
        }
    }
    
    public static testMethod void test_au_After_Insert_Update_Delete_Eventsdelete()
    {
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        system.runAs(thisUser){
        test.startTest();
        createTestdata();
        delete cbt;
        test.stopTest();
       system.assertEquals(cbt.Member_Name__c, u1.id);
        }
    }
    
    static void createTestdata()
    {
        
        u1 = UtilTestData.createUser('IT Manager', 'CAC Data Manager');
        
            cmp  = new Campaign(
            Name = 'cac', 
            Status = 'Started', 
            StartDate = System.today(), 
            EndDate = System.today()
            );
        
        insert cmp;
        
        
        cbt = new Collaboration_Team__c();
        cbt.Campaign__c = cmp.id;
        cbt.Member_Name__c = u1.id;
        cbt.Access_Type__c = 'Read/Write';
        insert cbt;
    }
    
}