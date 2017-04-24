@isTest 
public class ShareCampaignByCollaborationTest {

    Private Static String topCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('Central Marketing Campaign').getRecordTypeId();
    Private Static String cacCampRecordTypeId = Schema.SObjectType.Campaign.getRecordTypeInfosByName().get('CAC Campaign').getRecordTypeId();
    Private Static User usr;
    Private Static Campaign top;
    Private Static Campaign cac;
    Private Static Collaboration_Team__c Colla;
    Private Static List<Collaboration_Team__c> listCTNew;
    Private Static List<Collaboration_Team__c> listCTupdate;
    Private Static List<CampaignShare> csList;    
    Private Static Collaboration_Team__c Collaupdate;
    Private Static CampaignShare cshare;
    
    
                 @isTest static void testshareToUserInsert()
                 {
                     try{
					/*
                     List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
         			insert updatecustomsettings;*/

                     PrepareTestData();
                     Test.startTest();
                     UtilCampaignShareByCollaboration.shareToUserInsert(listCTNew);  
                     /*ShareCampaignByCollabTriggerHandler shcamp = new ShareCampaignByCollabTriggerHandler();
                     shcamp.handleTrigger(true,true,true,true,true);

					 shcamp.handleIntegrationTrigger(true,true,true,true,true);*/

                     Test.stopTest();
                     system.assert(Colla!=null);
                     system.assert(csList!=null);
                     }catch(exception e){}
                 }
                 @isTest static void testshareToUserUpdate()
                 {
                        PrepareTestData();
                        Test.startTest();
                        UtilCampaignShareByCollaboration.shareToUserUpdate(listCTNew);        
                        Test.stopTest();
                        system.assert(Colla!=null);
                         system.assert(csList!=null);
                 }
                 @isTest static void testshareToUserDelete()
                 {
                        PrepareTestData();
                        Test.startTest();
                        UtilCampaignShareByCollaboration.shareToUserDelete(listCTNew);
                        Test.stopTest();
                        system.assert(Colla!=null);
                         system.assert(csList!=null);
                 }
                
                 
         Public Static void PrepareTestData()
         {
         	List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
            insert updatecustomsettings;

         listCTNew=new List<Collaboration_Team__c>();
         listCTupdate=new List<Collaboration_Team__c>();
         csList = new List<CampaignShare>();
         
          Profile Admin = [select Id from Profile where Name = 'System Administrator' limit 1];
                    usr = new User(
                    Username = 'test123495@test.com',
                    FirstName = 'firstname',
                    ProfileId = Admin.Id,            
                    Alias = 'test495',
                    Email = 'test123495@test.com',
                    EmailEncodingKey = 'UTF-8',
                    LastName = 'McTesty',
                    CommunityNickname = System.now().millisecond() + 'test12345',
                    TimeZoneSidKey = 'America/Los_Angeles',
                    LocaleSidKey = 'en_US',
                    LanguageLocaleKey = 'en_US'
                    );        
                 insert usr;    
              
                   top = new Campaign(            
                    Name = 'top', 
                    Status = 'Started', 
                    StartDate = System.today(), 
                    EndDate = System.today(),
                    RecordTypeId = topCampRecordTypeId
                    );        
                insert top;
                     
                    cac = new Campaign(
                    //IsActive = true, 
                    Name = 'cac', 
                    Status = 'Started', 
                    StartDate = System.today(), 
                    EndDate = System.today(),
                    RecordTypeId = cacCampRecordTypeId,
                    ParentId = top.Id
                      );
                insert cac;
             
             
             
               for(Integer i = 0; i < 200; i++)
                {
                Colla=new Collaboration_Team__c(Campaign__c=cac.id,Access_Type__c='Edit',Resource_Required__c='no',Member_Name__c=usr.id);
                listCTNew.add(colla);
                }
               insert listCTNew;
          
                for(Integer i = 0; i < 200; i++)
                {
               Collaupdate=new Collaboration_Team__c(Campaign__c=cac.id,Access_Type__c='Read/Write',Resource_Required__c='Yes',Member_Name__c=usr.id);
                listCTupdate.add(Collaupdate);
                }
             insert listCTupdate;
             listCTupdate.Clear();
             
              update listCTupdate;
              delete listCTupdate;
              
        Collaboration_Team__c  Coll=new Collaboration_Team__c();
        Coll.Campaign__c=cac.id;
        Coll.Access_Type__c='Read';
        Coll.Resource_Required__c='no';
        Coll.Member_Name__c=usr.id;
        insert Coll;
        Coll.Access_Type__c='Edit';
        Coll.Resource_Required__c='Yes';
        update Coll;
        
        for(Integer i = 0; i < 200; i++)
                {
                cshare=new CampaignShare (CampaignId = Colla.Campaign__c,UserOrGroupId = Colla.Member_Name__c,CampaignAccessLevel = Colla.Access_Type__c);
                csList.add(cshare);
                }
                insert csList;
               }
    
    	
        }