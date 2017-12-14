@isTest
public class CampaignBouncebackStatusBatchTHTest {
    public static Id camIdExec= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
    public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    static testmethod void CampaignBouncebackStatusMethod(){
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
        //scb1.Criteria__c = 'Select id,Name From abc ';
        insert scb ;
        
        Retail_Campaign__c rcobj1=new Retail_Campaign__c();
        rcobj1.Name='Test Campaign1';
        rcobj1.Child_Campaign_Status__c='Segmentation';
        rcobj1.Status__c='Draft';
        rcobj1.Close_Date__c=system.today()+1;
        rcobj1.Execution_Start_Date__c=system.today()+1;
        rcobj1.Segmentation_Date__c=system.today();
        rcobj1.Execution_Type__c='eMail';
        rcobj1.RecordTypeId=camIdExec;
        rcobj1.Auto_Segmentation__c = true;
        rcobj1.Segmentation_Criteria__c = scb.id;
        rcobj1.IsAutoSegmentationExecuted__c = false;
        rcobj1.md__c='TH';
        insert rcobj1;
        
        Campaign_Member__c cmr=new Campaign_Member__c();
        cmr.Status__c='Executed';
        cmr.Retail_Campaign_Id__c=rcobj1.id;
        cmr.Contact_Id__c=accobj.id;
        insert cmr;
        CampaignBouncebackStatusBatchUpdateTH cbsbut=new CampaignBouncebackStatusBatchUpdateTH();
        //Database.executeBatch(cbsbut);
        String sch = '20 30 8 10 2 ?';
		String jobID = system.schedule('Merge Job', sch, cbsbut);
        test.stopTest();
    }
}