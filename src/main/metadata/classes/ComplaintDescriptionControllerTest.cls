/*
    Type:       test class
    Purpose:    ComplaintDescriptionController test class
    User Story: SMS

    Used By:    ComplaintDescriptionController
    ---------------------------------------------------------------
    History:

    2013-12-09 lishuang (Nttdata)    Created
*/
@isTest
public class ComplaintDescriptionControllerTest {
	static PageReference BASE_URL; 
    public static testMethod void testComplaintDescriptionController1(){
        
        Case cas = (Case)UtilTestData.createSobject(new Case(), UtilTestData.CASE_RT_MB_COMPLAINT);
        Complaint_Description__c sm = new Complaint_Description__c (
            Case__c = cas.id,
            Description__c='Description'
            );
        try {
            insert sm;
        } catch (DMLException e) {
            System.debug('new description error : ' + e.getDMLMessage(0));
        }
         
        Test.startTest();    
        ApexPages.currentPage().getParameters().put('caseId',cas.Id);
        ComplaintDescriptionController c1= new ComplaintDescriptionController();
        c1.getTheResults();        
        c1.cancel();      
        BASE_URL=new PageReference('/'+cas.Id);
        Test.stopTest();
        List<Complaint_Description__c> lstComplaintDsc=new List<Complaint_Description__c>(); 
        lstComplaintDsc=[SELECT Name,Date_Time__c,Created_By__r.name,Description__c,CreatedDate FROM Complaint_Description__c where Id=:sm.id order by Date_Time__c desc];
        
        c1.getTheResults().clear();
        system.assertEquals(sm.Case__c,cas.Id);
        system.assertEquals(c1.getTheResults().size(),lstComplaintDsc.size());      
        system.assert(c1.getTheResults()!=NUll);
        system.assert(c1.cancel()!=NUll);         
    }
}