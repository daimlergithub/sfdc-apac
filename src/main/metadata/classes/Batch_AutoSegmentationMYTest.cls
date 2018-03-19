/**
* Test class for Batch_AutoSegmentationMY
* Author:Sushma Bharti
* Created Date : 07-03-2018
*/

@isTest
public class Batch_AutoSegmentationMYTest{

    public static Id camIdExec= RecordTypeAccessService.getRecordTypeId('Retail_Campaign__c','Campaign Execution');
    public static Id personAccRecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account');
    
    static testmethod void Batch_AutoSegmentationMYTestMethod(){
    
        Profile p1 = [select id, name from profile where Name='System Administrator' limit 1];
        User user1 = new User(Alias = 'standt', Email='testUser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Test', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p1.Id, Market__c='MY',
            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1@testorg.com'+String.valueof(DateTime.now().getTime()), isActive=true);
            insert user1;
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
            accobj.MD__c='MY';
            accobj.Market__c='MY';
            insert accobj;
                   
            Segmentation_Criteria__c scb = New Segmentation_Criteria__c();
            scb.Name = 'sample';
            scb.MD__c='MY';
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
            rcobj1.market__c='MY';  
            insert rcobj1;  
            
           try{      
                    
            Batch_AutoSegmentationMY cbsbut=new Batch_AutoSegmentationMY();
            //String sch = '0 0 0 0 0 ?';
           //String sch = '20 30 8 10 2 ?';
          
			 String sch = '0 0 23 * * ?';
            String jobID = system.schedule('Autosegmentation Job', sch, cbsbut);
            //System.schedule('Schedule Name', sch, new Batch_AutoSegmentationMY ());
            }catch(Exception e){}
            test.stopTest();
        }
     }
}