@isTest
public class ChildCampaignStatusToNoResponseTHTest{
static  testmethod void batchexecutetestmethod(){
Retail_Campaign__C retcamp=new Retail_campaign__c();
retcamp.name='parentretcamp';
retcamp.recordtypeid=RecordTypeAccessService.getRecordTypeId('Retail_Campaign__c','Planning & Design Campaign');
retcamp.start_date__C=system.today()+1;
retcamp.close_Date__c=system.today()+5;
retcamp.Status__c='ongoing';
Retail_Campaign__C retcampchild=new Retail_campaign__c();
retcampchild.name='pchildretcamp';
retcampchild.recordtypeid=RecordTypeAccessService.getRecordTypeId('Retail_Campaign__c','Campaign Execution');
retcampchild.start_date__C=system.today()+1;
retcampchild.close_date__C=system.today()+4;
retcampchild.Execution_Start_Date__c=system.today()+2;
retcampchild.Status__c='Execution';
retcampchild.md__C='TH';

User user1 = TestUtils.createAdminUser();
system.runas(user1){
test.starttest();
insert retcamp; 
retcampchild.Parent_Campaign1__c=retcamp.id;
insert retcampchild;

DataBase.ExecuteBatch(new UpdateChildCampaignStatusToNoResponseTH());
      UpdateChildCampaignStatusToNoResponseTH abc=new UpdateChildCampaignStatusToNoResponseTH();
     String sch = '20 30 8 10 2 ?';
    String jobID = system.schedule('Merge Job', sch, abc);
retcampchild.Segmentation_Date__c=system.today()+2;
retcampchild.Auto_Segmentation__c = true;
retcampchild.IsAutoSegmentationExecuted__c=false;
Account acc=new Account(lastName='Test',md__c='TH',Individual_home_phone__c='+66-9909',recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
insert acc;
Segmentation_Criteria__c seg=new Segmentation_Criteria__c();
seg.name='test';
seg.Criteria__c='select Id, Name, PersonHomePhone, PersonMobilePhone, Phone, PersonEmail, City__c from Account where Id in ('+'\''+acc.id+'\''+')';
seg.md__c='TH';
insert seg;
retcampchild.Segmentation_Criteria__c=seg.id;
update retcampchild;

DataBase.ExecuteBatch(new Batch_AutoSegmentationTH());
test.stoptest();
}
}

}