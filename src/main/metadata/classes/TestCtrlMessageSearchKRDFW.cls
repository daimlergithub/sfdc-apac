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
@isTest(SeeAllData=true)
private class TestCtrlMessageSearchKRDFW {

    static testMethod void myUnitTestAcc() {
    	Account acc = [SELECT Id, Name FROM Account order by CreatedDate limit 1];
		Id [] fixedSearchResults= new Id[1];
       	fixedSearchResults[0] = acc.Id;
       	Test.setFixedSearchResults(fixedSearchResults);
    	
        CtrlMessageSearchKRDFW mbkTargets = new CtrlMessageSearchKRDFW();
        mbkTargets.searchStr = acc.Name;
        mbkTargets.targetSearch();           
    }
    
    static testMethod void myTestLead(){
		Lead__c lead = [SELECT Id, Name FROM Lead__c limit 1];
		Id [] fixedSearchResults= new Id[1];
       	fixedSearchResults[0] = lead.Id;
       	Test.setFixedSearchResults(fixedSearchResults);
       			
        CtrlMessageSearchKRDFW mbkTargets = new CtrlMessageSearchKRDFW();    	
    	mbkTargets.searchStr = lead.Name;
        mbkTargets.targetSearch();
    }
    
    static testMethod void myTestTask(){
    	Task task = [SELECT Id, Subject FROM Task limit 1];
		Id [] fixedSearchResults= new Id[1];
       	fixedSearchResults[0] = task.Id;
       	Test.setFixedSearchResults(fixedSearchResults);
       	    	
        CtrlMessageSearchKRDFW mbkTargets = new CtrlMessageSearchKRDFW();    	
    	mbkTargets.searchStr = task.Subject;
        mbkTargets.targetSearch();
    }
    
    static testMethod void myTestCampaign(){
    	Campaign cam = [SELECT Id, Name FROM Campaign WHERE HierarchyNumberOfContacts > 1 limit 1];
		Id [] fixedSearchResults= new Id[1];
       	fixedSearchResults[0] = cam.Id;
       	Test.setFixedSearchResults(fixedSearchResults);
       	    	
        CtrlMessageSearchKRDFW mbkTargets = new CtrlMessageSearchKRDFW();    	
    	mbkTargets.searchStr = cam.Name;
        mbkTargets.targetSearch();
    }
    
    static testMethod void myTestCase(){
    	Case cas = [SELECT Id,Subject FROM Case WHERE Subject <> null limit 1];
 		Id [] fixedSearchResults= new Id[1];
       	fixedSearchResults[0] = cas.Id;
       	Test.setFixedSearchResults(fixedSearchResults);
       	   	
        CtrlMessageSearchKRDFW mbkTargets = new CtrlMessageSearchKRDFW();    	
    	mbkTargets.searchStr = cas.Subject;
        mbkTargets.targetSearch();    	
    }       
    
    static testMethod void myTestOther(){
    	CtrlMessageSearchKRDFW mbkTargets = new CtrlMessageSearchKRDFW();
		mbkTargets.allChecking(); 
    }    
}