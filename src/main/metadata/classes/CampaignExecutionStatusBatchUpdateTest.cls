@isTest
public class CampaignExecutionStatusBatchUpdateTest {
    public static Id camIdExec= RecordTypeAccessService.getRecordTypeId('Retail_Campaign__c','Campaign Execution');
    public static Id personAccRecordTypeId = RecordTypeAccessService.getRecordTypeId('Account','Person Account');
    static testmethod void CampaignExecutionStatusBatchUpdateMethod(){
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
        insert scb ;
        
        Retail_Campaign__c rcobj1=new Retail_Campaign__c();
        rcobj1.Name='Test Campaign1';
        rcobj1.Child_Campaign_Status__c='Planning';
        rcobj1.Status__c='Draft';
        rcobj1.Close_Date__c=system.today()+1;
        rcobj1.Execution_Start_Date__c=system.today()+1;
        rcobj1.Segmentation_Date__c=system.today();
        rcobj1.Execution_Type__c='eMail';
        rcobj1.RecordTypeId=camIdExec;
        rcobj1.Auto_Segmentation__c = true;
        rcobj1.Segmentation_Criteria__c = scb.id;
        rcobj1.IsAutoSegmentationExecuted__c = false;
        rcobj1.md__c='MY';
        insert rcobj1;
        
        List<Campaign_Member__c> cmr=new List<Campaign_Member__c>();
        cmr.add(new Campaign_member__c(Status__c='Ready',Retail_Campaign_Id__c=rcobj1.id,Contact_Id__c=accobj.id));
        cmr.add(new Campaign_member__c(Status__c='Execution',Retail_Campaign_Id__c=rcobj1.id,Contact_Id__c=accobj.id));
        insert cmr;
        
        String market=System.Label.MarketMY;
        Database.BatchableContext bc;
        CampaignExecutionStatusBatchUpdate cbsbut=new CampaignExecutionStatusBatchUpdate();
        cbsbut.querymethod(bc,market);
        test.stopTest();
    }
}