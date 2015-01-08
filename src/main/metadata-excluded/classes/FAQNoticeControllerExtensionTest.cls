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
public class FAQNoticeControllerExtensionTest {

    public static testMethod void testMyController() {
                
        User user1 = UtilTestData.createUser('IB Supervisor','CAC IB SV');
        
        System.runAs ( user1 ) {        
            // Create FAQ Notice           
            FAQ_Notice__c faq1 = new FAQ_Notice__c(
            	Name='FAQ Notice 1', 
            	Message_Detail__c='Test message.', 
            	FAQ_Notice_Type__c = 'IB');
            insert faq1;    
            
            FAQ_Notice__c faq2 = new FAQ_Notice__c(
            	Name='FAQ Notice 2', 
            	Message_Detail__c='Test message.', 
            	FAQ_Notice_Type__c = 'OB');
            insert faq2;  
            
            FAQ_Notice__c faq3 = new FAQ_Notice__c(
            	Name='FAQ Notice 3', 
            	Message_Detail__c='Test message.', 
            	FAQ_Notice_Type__c = 'IB');
            insert faq3;     
            
        }
                
        User user2 = UtilTestData.createUser('IB CSR','CAC IB CSR');
        
        System.runAs ( user2 ) {
            // Testing FAQNoticeControllerExtension           
            ApexPages.standardController controller = new ApexPages.standardController(new FAQ_Notice__c());
            FAQNoticeControllerExtension ext = new FAQNoticeControllerExtension(controller);
            System.assertEquals(ext.noticeTitle, 'FAQ Notice 3');            
            System.debug('-----Last 10 Days FAQ Notice:-----'+ext.results.size());
            
            //delete all FAQ Notice
            ext.results=null;
            ext.noticeTitle=null;
            System.assertEquals(0,ext.results.size());
            System.assertEquals('',ext.noticeTitle);
            System.debug('======Completed======');
        }
        
        User user3 = UtilTestData.createUser('OB CSR','CAC OB CSR');
        
        System.runAs ( user3 ) {
            // Testing FAQNoticeControllerExtension           
            ApexPages.standardController controller = new ApexPages.standardController(new FAQ_Notice__c());
            FAQNoticeControllerExtension ext = new FAQNoticeControllerExtension(controller);
            System.assertEquals(ext.noticeTitle, 'FAQ Notice 2');            
            System.debug('-----Last 10 Days FAQ Notice:-----'+ext.results.size());
            
            //delete all FAQ Notice
            ext.results=null;
            ext.noticeTitle=null;
            System.assertEquals(0,ext.results.size());
            System.assertEquals('',ext.noticeTitle);
            System.debug('======Completed======');
        }
        
        User user4 = UtilTestData.createUser('','CAC E-CSR');
        
        System.runAs ( user4 ) {
            // Testing FAQNoticeControllerExtension           
            ApexPages.standardController controller = new ApexPages.standardController(new FAQ_Notice__c());
            FAQNoticeControllerExtension ext = new FAQNoticeControllerExtension(controller);
            System.assertEquals(ext.noticeTitle, 'FAQ Notice 3');            
            System.debug('-----Last 10 Days FAQ Notice:-----'+ext.results.size());
            System.assertEquals(3,ext.results.size());
            
            //delete all FAQ Notice
            ext.results=null;
            ext.noticeTitle=null;
            System.assertEquals(0,ext.results.size());
            System.assertEquals('',ext.noticeTitle);
            System.debug('======Completed======');
        }
    }
}