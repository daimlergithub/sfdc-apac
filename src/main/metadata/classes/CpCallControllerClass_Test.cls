/*
    Type:       Test Class
    Purpose:    Test On Campaign Trigger Coding
     4-June-2013 Stephano Shi (Breakingpoint)    Created
    Patrick Zhang(Breakingpoint) updated on 2013-10-12

*/
@isTest
public with sharing class CpCallControllerClass_Test{
    private static string blank='';
    static testMethod void runCpCallControllerClass_Test(){
    List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
    insert updatecustomsettings;
        Map<String, Schema.RecordTypeInfo> cpRecordTypeMap = Schema.SObjectType.Campaign.getRecordTypeInfosByName();
       
        /* Test Method queAllCamps */
        // DATA Preparation
        // Central Marketing Campaign
        Campaign centralCamp1 = new Campaign(Name='Central Campaign 1',
                                            RecordTypeId=cpRecordTypeMap.get('Central Marketing Campaign').getRecordTypeId(),
                                            Campaign_Code__c='Central Campaign 1',
                                            Type='Other',
                                            Status='Open',
                                            Campaign_Objectives__c='OB',
                                            StartDate=date.newinstance(2013, 5, 17),
                                            EndDate=date.newinstance(2013, 10, 17),
                                            Description = blank 
                                            );
        
        // CAC Campaign
        Campaign cacCamp1 = new Campaign(Name='CAC Campaign 1',
                                         Campaign_Code__c='CAC Campaign 1',
                                         ParentId=centralCamp1.Id,
                                         Repeat_From__c=datetime.newinstance(2013, 5, 17),
                                         Repeat_End__c=datetime.newinstance(2013, 10, 17),
                                         RecordTypeId=cpRecordTypeMap.get('CAC Campaign').getRecordTypeId()
                                         );
        
        // CAC Campaign 2
        Campaign cacCamp2 = new Campaign(Name='CAC Campaign 2',
                                         Campaign_Code__c='CAC Campaign 2',
                                         ParentId=centralCamp1.Id,
                                         Repeated_Campaign__c=true,
                                         Repeat_Frequency__c='Daily',
                                         RecordTypeId=cpRecordTypeMap.get('CAC Campaign').getRecordTypeId()
                                         );     
        
        // Execution Campaign
        Campaign exeCamp1 = new Campaign(Name='Execution Campaign 1',
                                         Campaign_Code__c='Execution Campaign 1',
                                         Execution_Type__c='OB Call',
                                         Task_Created_By__c='Contact',
                                         ParentId=cacCamp1.Id,
                                         RecordTypeId=cpRecordTypeMap.get('Campaign Execution - Simple').getRecordTypeId()
                                         );  
        
        // CAC CRM Campaign
        Campaign cacCrmCamp1 = new Campaign(Name='CAC CRM Campaign 1',
                                            Campaign_Code__c='CAC CRM Campaign 1',
                                            CAC_Campaign_Type__c='Others',
                                            CAC_Frequency_Category__c='Ad Hoc',
                                            Campaign_Objectives__c='objective',
                                            Description='123',
                                            StartDate=date.newinstance(2013, 5, 17),
                                            EndDate=date.newinstance(2013, 10, 17),   
                                            RecordTypeId=cpRecordTypeMap.get('CAC CRM Campaign').getRecordTypeId()
                                            ); 
        
        // CAS Campaign
        Campaign casCamp1 = new Campaign(Name='CAS Campaign 1',
                                            Campaign_Code__c='CAS Campaign 1',                                            
                                            Type='other',
                                            Campaign_Objectives__c='dsfda',
                                            Description='123',
                                            Status='Planned',
                                            StartDate=date.newinstance(2013, 5, 17),
                                            EndDate=date.newinstance(2013, 10, 17),   
                                            RecordTypeId=cpRecordTypeMap.get('CAS Marketing Campaign').getRecordTypeId()
                                            );
       
        Test.startTest();
        insert(centralCamp1);
        insert(cacCamp1);
        insert(cacCamp2);
        insert(exeCamp1);
        insert(cacCrmCamp1);
        insert(casCamp1);
        list<Campaign> listCamp =new list<Campaign> ();
        listCamp.add(casCamp1);
       Campaign casCamp = [select Name,Campaign_Code__c,Description from Campaign where id IN: listCamp];
       
        cpCalController.queAllCamps(blank,blank,blank,blank,blank,blank);
        cpCalController.queAllCamps('2012','2014', String.valueOf(centralCamp1.Id),'Regular-Continuous','CRM Acquisition Program','Auto Show');
        Test.stopTest();
        system.assertEquals(casCamp1.Name, casCamp.Name);
    }
}