/*
    Type:       Test Class
    Purpose:    To test the Class ToolKitSelectContentController
    User Story: 
    1. Barney Lai Created on 2014-5-15
    2. zhongyang.si update on 2014-11-10
*/
@isTest 
public with sharing class ToolKitSelectContentControllerTest {
Private Static Id eventRT = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('Event').getRecordTypeId();
Private Static Id mediaRT = Schema.SObjectType.Tool_Kit__c.getRecordTypeInfosByName().get('Media').getRecordTypeId();
Private Static Account dealerAcc;
Private Static Account acc;
Private Static Tool_Kit__c etk1;
Private Static Tool_Kit__c mtk1;  
Private Static String recordNumbering;
Private Static Boolean hasNext=true;
Private Static Boolean hasPrev=true;
public static void preparedTestData()
{
    List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
		 insert updatecustomsettings;
 /*Insert account with record type Dealer*/
        Id dealerRecTypeId = [SELECT Id FROM RecordType WHERE Name = 'Dealer' limit 1].Id;
        dealerAcc = new Account (Name='Test Account', RecordTypeId=dealerRecTypeId, Dealer_Region__c='Test region');
        insert dealerAcc;
        
        acc = [select id from Account where RecordTypeId = :dealerRecTypeId and Dealer_Region__c!='' limit 1];
        
         etk1 = new Tool_Kit__c(RecordTypeId = eventRT,
                                           Dealer_Name__c = acc.id,
                                           Brand__c='MB',
                                           Plan_Start_Date__c = Date.today().addDays(-10),
                                           Plan_End_Date__c = Date.today().addDays(10),
                                           name = 'laitest01',
                                           Event_Director__c = 'laisichao',
                                           Plan_Expense__c = 1234,
                                           Location_Size__c = 123456,
                                           Event_Type__c = 'Test drive',
                                           Location__c = 'Indoor',
                                           Event_Participant__c = 'Media',
                                           Purpose__c ='OK',
                                           Background__c = 'back',
                                           Request__c = 'request'
                                          );
                                          
         mtk1 = new Tool_Kit__c(RecordTypeId = mediaRT,
                                           Dealer_Name__c = acc.id,
                                           Brand__c='AMG',
                                           Plan_Start_Date__c = Date.today().addDays(-10),
                                           Plan_End_Date__c = Date.today().addDays(10),
                                           name = 'laitest02',
                                           Purpose__c = 'OK',
                                           Background__c = 'back',
                                           Request__c = 'request',
                                           Media_Type__c = 'Outdoor',
                                           Ad_Color__c = 'Black and white',
                                           Ad_Copy__c = 'copy',
                                           Ad_Format__c = 'Picture download',
                                           Ad_Size_Height__c = 123,
                                           Ad_Size_Width__c = 456,
                                           Bleed_Size_Height__c = 789,
                                           Bleed_Size_Width__c = 798,
                                           Media_Name__c = 'laitest10',
                                           Deliver_Date__c = Date.today());                                                                                  
        insert etk1;
        insert mtk1;
       
          
}
    
    
    @isTest static void testToolKitSelectContentController(){       
        
        preparedTestData();
        Test.startTest();
        
        PageReference page = new PageReference('/apex/ToolKitSelectContent?toolkitId=' + etk1.id + '&today=2014-10-21');
        Test.setCurrentPage(page);
        ToolKitSelectContentController controller = new ToolKitSelectContentController();
        controller.contentVersion = new ContentVersion(PathOnClient='test',title='tests',Brand__c='MB',CBU_PbP__c='CBU',Class__c='A-Class',Due_Date__c=Date.newInstance(2014,10,21),Media_Type__c='Outdoor',Ad_Type__c='TEST');
        controller.query();
        controller.previous();
        controller.next();
        controller.first();
        controller.last();
        controller.choose();
        
        PageReference page2 = new PageReference('/apex/ToolKitSelectContent?toolkitId=' + mtk1.id + '&today=2014-10-21');
        Test.setCurrentPage(page2);
        ToolKitSelectContentController controller2 = new ToolKitSelectContentController();
        controller2.contentVersion = new ContentVersion(PathOnClient='testp',title='testt',Brand__c='MB',CBU_PbP__c='CBU',Class__c='A-Class',Event_Tool_Kit__c='testkit',Event_Type__c='Outreach/Roadshow',Due_Date__c=Date.newInstance(2014,10,21));
        controller2.query();
        controller2.choose();
         recordNumbering = controller2.recordNumbering;
         hasNext=controller2.hasNext;
         hasPrev=controller2.hasPrev;
        Test.stopTest();
        System.assertEquals(hasNext,controller2.hasNext);
        System.assertEquals(hasPrev,controller2.hasPrev);
        system.assertEquals(recordNumbering,controller2.recordNumbering);
    }
}