/************************************************************************************
* Created By:Sarath Kumar M
* Created Date:20-Mar-18
* Company:Infosys Ltd
* Description: Test class for BbqTriggerHelperBase	
*********************************************************************************************/
@isTest
public class BbqTriggerHelperBaseTest {   
    @isTest
    public static void methodToCreateTaskAfterRecordIsCreated(){   
     	Test.startTest();
        User usr =TestUtils.IntegrationAPIUser();
        TriggerUtil.userCreate=false;
        System.runas(usr) {   
      	Trigger__c TriggerAddress = new Trigger__c(Name = 'BBQReferralSG', Trigger_Name__c = 'TriggerReferral', Trigger_Handler__c = 'BbqTriggerHandler', update__c = True, insert__c = True, delete__c = True, after__c = True, before__c = True, enabled__c = True, Market__c = 'SG');
        upsert TriggerAddress;
        employee__c emp=new employee__c(First_Name__c='Test',Last_Name__c='daimler',UserName__c='test daimler',Email__c='testdaimler@daimler.com');
        insert emp;
        BbqTaskData__c obj = new BbqTaskData__c(name='CreateTask',taskActivityDate__c=10,taskRecordType__c='OB Call',taskReminderDate__c=2);
  		insert obj;
        BbqCreateTask__c obj1 = new BbqCreateTask__c(Name='JP',User__c=usr.id);
  		insert obj1;  
        TriggerRecursiveCheck.ReferralCalcFlag = true;
        Referral__c ref= new Referral__c(Address__c='Housing Board Colony',Dealer__c='Test',
                                         Email__c='test@infy.com',First_Name__c='Sarat',Last_Name__c='Test',
                                         ReferredEmployee__c=emp.id,Status__c='Submitted',Model_Type__c='E-Class',Phone__c='2134345',Zip_code__c='3454376');  
        insert ref;
        ref.Status__c='Won';            
        TriggerRecursiveCheck.ReferralCalcFlag = true;
        update ref;
        system.assertNotEquals(null, ref.id);
        }        
        test.stopTest();
    }    
}