/**
* Test class for Batch_AutoSegmentation_Generic
* Author:Sushma Bharti
* Created Date : 07-03-2018
*/

@isTest
public class Batch_AutoSegmentation_GenericTest{

    public static Id camIdExec= RecordTypeAccessService.getRecordTypeId('Retail_Campaign__c','Campaign Execution');
    public static Id personAccRecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account');
    
    static testmethod void Batch_AutoSegmentation_GenericTestMethod(){
    
        Profile p1 = [select id, name from profile where Name='System Administrator' limit 1];
        User user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
      
        System.runAs (user1) {
            test.startTest();       
            Account accobj = new Account();
            accobj.FirstName = 'testaccount';
            accobj.lastName = 'testaccount';
            accobj.Email__c = 'Test@test.com';
            accobj.RecordTypeId = personAccRecordTypeId;
            //accobj.Name = 'testaccount';
            accobj.Phone = '012310086';
            accobj.MBK_Data_Source__c='Email';
            accobj.Mobile__c = '00000009642'; 
            insert accobj;
                   
            Segmentation_Criteria__c scb = New Segmentation_Criteria__c();
            scb.Name = 'sample';
            scb.Criteria__c='select Id, Name, RecordTypeId, Individual_Home_Phone__c, Work_Phone__c, fax, Mobile__c, MD__c from Account';
            insert scb ;
            
            Retail_Campaign__c rcobj1=new Retail_Campaign__c();
            rcobj1.Name='Test Campaign1';
            rcobj1.Child_Campaign_Status__c='Planning';
            rcobj1.Status__c='Draft';
            rcobj1.Close_Date__c=system.today()+1;
            rcobj1.Execution_Start_Date__c=system.today()+1;
            rcobj1.Segmentation_Date__c=system.today()+1;
            rcobj1.Execution_Type__c='eMail';
            rcobj1.RecordTypeId=camIdExec;
            rcobj1.Auto_Segmentation__c = true;
            rcobj1.Segmentation_Criteria__c = scb.id;
            rcobj1.IsAutoSegmentationExecuted__c = false;
            rcobj1.md__c='MY';        
            insert rcobj1;
                    
            String market=System.Label.MarketMY;
            Database.BatchableContext bc;
            Date todaydate=DATE.TODAY();
            Date nextdate=todaydate.addDays(1);
            Batch_AutoSegmentation_Generic batchSch = New Batch_AutoSegmentation_Generic();
            batchSch.method1(bc,'Daimler Community Malaysia',market);
            List<Retail_Campaign__c> rcList=[select id,RecordTypeId,Name,Parent_Campaign1__c,Start_Date__c,Owner.Name, owner.Email,OwnerId,MD__c,Close_Date__c,Auto_Segmentation__c,Execution_Type__c,Execution_Start_Date__c,Segmentation_Base__c,Segmentation_Date__c,Response_Date__c,child_campaign_status__c,Dealer_Name__c,IsAutoSegmentationExecuted__c,Segmentation_Criteria__c,Segmentation_Criteria__r.Criteria__c from Retail_Campaign__c Where Auto_Segmentation__c = true AND Segmentation_Date__c =: nextdate AND IsAutoSegmentationExecuted__c = false and recordtypeid=:camIdExec and md__c=:market];
            batchSch.method2(bc,rcList);
            test.stopTest();
        }
     }
}