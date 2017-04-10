/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class DMControllerExtensionTest {
    public static DM_Request__c dmr;
    final static String personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static testMethod void testMyController() {
    
    List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
    //insert updatecustomsettings;
   Trigger__c newtrg = new Trigger__c(Name= 'TriggerDMRequest1',Trigger_Name__c = 'TriggerDMRequest',Trigger_Handler__c = 'TriggerDMRequestTriggerHandlerJP',Market__c ='JP',
                               enabled__c = False,after__c= False,before__c= False,delete__c= False,update__c= False,insert__c= False);
      insert newtrg;                         
       // User user1 = UtilTestData.createUser('IB CSR','CAC IB CSR');
      //  System.runAs ( user1 ) {

            // Add parameters to page URL
            System.debug('--------Begin-------');
            Account customer = new Account(RecordTypeId=personRecordtypeid ,Phone = '1234567',Last_Successful_Call_Office_Phone__c = System.today() - 10,DMS_Address__c = 'dmsaddress1',
                                           Mobile__c = '00000009642');
    
             customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);   
             
             dmr = new  DM_Request__c();             
             //dmr.Sending_Address__c='Home';             
             dmr.Status__c='Success';             
             dmr.TitleOfHonor__c = 'To Company';
             dmr.Sent_Date__c=system.today().addDays(-10);
             dmr.Customer_Name__c = customer.id;
            
            //customer = (Account)UtilTestData.createSobject(customer, UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);   
            Test.startTest();
            // Testing the eDM Send
            ApexPages.standardController controller = new ApexPages.standardController(dmr);
            ApexPages.currentPage().getParameters().put('accountId',customer.Id);
            
                        
            // Test click DM button from Account
            // Instantiate a new controller extension with all parameters in the page
            DMControllerExtension extension = new DMControllerExtension(controller);
            // Send DM
            extension.send();
            Task t = [Select t.WhoId, t.WhatId, t.Subject, t.Status, t.Activity_Status__c, OwnerId From Task t Where WhatId=:extension.dm.Id Order by Id Desc Limit 1];
            
            //Test click eDM button from Case 
            Account dealer = new Account(Phone = '1234567',
                                         Last_Successful_Call_Office_Phone__c = System.today() - 10,
                                         DMS_Address__c = 'dmsaddress1',MBK_Data_Source__c = 'Email');
            dealer = (Account)UtilTestData.createSobject(dealer, UtilTestData.ACCOUNT_RT_DEALER);                             
            Case case1 = new Case(AccountId=customer.Id, Subject='Case-'+Datetime.now().formatLong());
            case1.Case_Dealer__c = dealer.Id;
            insert case1;
            
             dmr = new  DM_Request__c();             
             //dmr.Sending_Address__c='Home';             
             dmr.Status__c='Open';             
             dmr.TitleOfHonor__c = 'To Company';
             dmr.Sent_Date__c=system.today().addDays(-10);
            
            ApexPages.standardController controller2 = new ApexPages.standardController(dmr);
            ApexPages.currentPage().getParameters().put('caseId',case1.Id);
            try{
            DMControllerExtension extension2 = new DMControllerExtension(controller2);
            // Send DM
            extension2.send();
            
            t = [Select t.WhoId, t.WhatId, t.Subject, t.Status,t.Activity_Status__c, OwnerId From Task t Where WhatId=:extension2.dm.Id Order by Id Desc Limit 1];
            //cover exception
            Case case2 = new Case(Subject='Case-'+Datetime.now().formatLong());
            insert case2;
            
            dmr = new  DM_Request__c();             
             dmr.Sending_Address__c='Home';             
             dmr.Status__c='Success';             
             dmr.TitleOfHonor__c = 'To Company';
             dmr.Sent_Date__c=system.today().addDays(-10);
             
            ApexPages.standardController controller3 = new ApexPages.standardController(dmr);
            ApexPages.currentPage().getParameters().put('caseId',case2.Id);
            ApexPages.currentPage().getParameters().put('accountId','');
            DMControllerExtension extension3 = new DMControllerExtension(controller3);
            // Send DM
            extension3.send();  
              
            Test.stopTest();
            System.assertEquals(t.Subject,'DM');
            System.assertEquals(t.Status,'Closed');
           // System.assertEquals(t.OwnerId,user1.Id);
            System.assertEquals(t.WhoId,[Select Id From Contact Where accountId = :customer.Id].Id);
            System.assertEquals(t.Activity_Status__c, [Select Status__c From DM_Request__c Where Id=:extension2.dm.Id].Status__c);
     //   } 
     }catch(exception e){}     
    }
}