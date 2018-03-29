/************************************************************************************
* Created By:Sarath M
* Created Date:16-Mar-18
* Company:Infosys Ltd
* Description:Test class for BbqStatusUpdate 
*********************************************************************************************/
@isTest
public class BbqStatusUpdate_test {    
    @istest
    Public static void refStatusUpdateWonTest(){
        employee__c emp=new employee__c(First_Name__c='Test',Last_Name__c='Infy',UserName__c='Test Infy',Email__c='testBBq@daimler.com');
        insert emp;
		Id TaskRecTypeId = Schema.SObjectType.lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
        lead__c led=new lead__c(Lead_Type__c='New Car',Dealer_Lead_Status__c='Won',CAC_Lead_Status__c='Won',RecordTypeId=TaskRecTypeId);
        insert led;
       	Referral__c ref= new Referral__c(Address__c='Housing Board Colony',Dealer__c='Test',
                                         Email__c='test@infy.com',First_Name__c='Sarat',Last_Name__c='Test',
                                         ReferredEmployee__c=emp.id,Status__c='Submitted',Model_Type__c='E-Class',Phone__c='2134345',Zip_code__c='3454376',Lead__c=led.id);    
        insert ref;
        String CRON_EXP = '0 0 0 2 6 ? 2022'; 
        test.startTest();
            BbqStatusUpdate batch=new BbqStatusUpdate();
            Database.executeBatch(batch);            
            String jobId = System.schedule('Status Update', CRON_EXP,batch);
        test.stopTest();
        System.assertnotEquals(ref.id,null);
      
    }    
}