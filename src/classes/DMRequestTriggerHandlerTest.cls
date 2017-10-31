@isTest
private with sharing class DMRequestTriggerHandlerTest {
    
    public static testMethod void testMyController() {
    
       
        User user1 = UtilTestData.createUser('SSI CSR','CAC SSI CSR');
        System.runAs ( user1 ) {
         
            Trigger__c TriggerDMRequest = new Trigger__c(Name='DMRequest',Trigger_Name__c='TriggerDMRequest',Trigger_Handler__c='TriggerDMRequestTriggerHandler',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
            upsert TriggerDMRequest;
            
            Test.startTest();
            // DM Material
            DM_Material__c dm1 = new DM_Material__c(Name='TEST-DM-1'+DateTime.now().formatLong(),Active__c=true);
            DM_Material__c dm2 = new DM_Material__c(Name='TEST-DM-2'+DateTime.now().formatLong(),Active__c=true);
            DM_Material__c dm3 = new DM_Material__c(Name='TEST-DM-3'+DateTime.now().formatLong(),Active__c=true);
            
            insert dm1;
            insert dm2;
            insert dm3;
            
            //init openning stock
            DM_Stock_Flow__c dsf1 = new DM_Stock_Flow__c(Stock_Type__c='Increase Stock', Valid__c=true, Material_Name__c=dm1.Id,Quantity__c=10);
            DM_Stock_Flow__c dsf2 = new DM_Stock_Flow__c(Stock_Type__c='Increase Stock', Valid__c=true, Material_Name__c=dm2.Id,Quantity__c=20);
            DM_Stock_Flow__c dsf3 = new DM_Stock_Flow__c(Stock_Type__c='Increase Stock', Valid__c=true, Material_Name__c=dm3.Id,Quantity__c=30);
            
            insert dsf1;
            insert dsf2;
            insert dsf3;
            
            dm1 = [Select Id,Name,Stock__c From DM_Material__c Where Id=:dm1.Id];
            dm2 = [Select Id,Name,Stock__c From DM_Material__c Where Id=:dm2.Id];
            dm3 = [Select Id,Name,Stock__c From DM_Material__c Where Id=:dm3.Id];
            
                         
            Account customer = new Account(
                                     Phone = '1234567',
                                     Last_Successful_Call_Office_Phone__c = System.today() - 10,
                                     DMS_Address__c = 'dmsaddress1');

            customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);        
            
                        

            // Scenario 1:
            DM_Request__c dmr1 = new DM_Request__c(Actual_DM_Material1__c=dm1.Id, Status__c='Open', Customer_Name__c=customer.Id );
            insert dmr1;
            
            dmr1.Actual_DM_Material1__c = dm1.Id;
            dmr1.Actual_DM_Material2__c = dm2.Id;
            dmr1.Actual_DM_Material3__c = dm3.Id;
            dmr1.Status__c = 'Sent';
            update dmr1;
            dm1 = [Select Id,Name,Stock__c From DM_Material__c Where Id=:dm1.Id];
            dm2 = [Select Id,Name,Stock__c From DM_Material__c Where Id=:dm2.Id];
            dm3 = [Select Id,Name,Stock__c From DM_Material__c Where Id=:dm3.Id];
            
            // Scenario 2
            dmr1.Comment__c = 'Scenario 2';
            update dmr1;
            dm1 = [Select Id,Name,Stock__c From DM_Material__c Where Id=:dm1.Id];
            dm2 = [Select Id,Name,Stock__c From DM_Material__c Where Id=:dm2.Id];
            dm3 = [Select Id,Name,Stock__c From DM_Material__c Where Id=:dm3.Id];
            
            // Scenario 3.2
            DM_Request__c dmr2 = new DM_Request__c(Actual_DM_Material1__c=dm2.Id, Actual_DM_Material2__c=dm2.Id, Actual_DM_Material3__c=dm2.Id, Status__c='Sent', Customer_Name__c=customer.Id);
            insert dmr2;
            dm1 = [Select Id,Name,Stock__c From DM_Material__c Where Id=:dm1.Id];
            dm2 = [Select Id,Name,Stock__c From DM_Material__c Where Id=:dm2.Id];
            dm3 = [Select Id,Name,Stock__c From DM_Material__c Where Id=:dm3.Id];

            //test auto update activity status.
            ApexPages.currentPage().getParameters().put('accountId',customer.Id);
            ApexPages.standardController controller3 = new ApexPages.standardController(new DM_Request__c());
            DMControllerExtension extension3 = new DMControllerExtension(controller3);
            extension3.send();
            DM_Request__c taskDMR = [Select Id, Status__c From DM_Request__c Where Id=:extension3.dm.Id Order by Id Desc Limit 1];
            System.assertEquals(taskDMR.Status__c,'Open');
            
            taskDMR.Status__c = 'Sent';
            update taskDMR;
            
            Test.stopTest();
            System.assertEquals(dmr1.Actual_DM_Material1__c, dm1.Id);
            System.assertEquals(dmr1.Actual_DM_Material2__c, dm2.Id);
            System.assertEquals(dmr1.Actual_DM_Material3__c, dm3.Id);  
          
    }
    }
    
    
}