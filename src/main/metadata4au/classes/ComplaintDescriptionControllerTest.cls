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
    static Case cas;
    static Complaint_Description__c sm;
    static ComplaintDescriptionController extension;
    static PageReference ComplaintDescriptionViewAll;   
    private static void init(){
        cas = (Case)UtilTestData.createSobject(new Case(), UtilTestData.CASE_RT_MB_COMPLAINT);
        sm = new Complaint_Description__c (Case__c = cas.id,Description__c='Description');
        ComplaintDescriptionViewAll=Page.ComplaintDescriptionViewAll;
        ComplaintDescriptionViewAll.getParameters().put('caseId',cas.Id);       
        Test.setCurrentPage(ComplaintDescriptionViewAll);    
        extension= new ComplaintDescriptionController();
    }
    //static PageReference BASE_URL; 
    public static testMethod void test_getTheResults(){       
        init();
        try {
            insert sm;
        } catch (DMLException e) {
            System.debug('new description error : ' + e.getDMLMessage(0));
        }         
        Test.startTest();  
         extension.getTheResults();
        Test.stopTest();
        List<Complaint_Description__c> lstComplaintDsc=new List<Complaint_Description__c>(); 
        lstComplaintDsc=[SELECT Name,Date_Time__c,Created_By__r.name,Description__c,CreatedDate FROM Complaint_Description__c where Id=:sm.id order by Date_Time__c desc];
        extension.getTheResults().clear();        
        system.assertEquals(extension.getTheResults().size(),lstComplaintDsc.size());      
        system.assert(extension.getTheResults()!=NUll);  
    }
      public static testMethod void test_Cancel(){  
        init();
        Test.startTest();      
        extension.cancel();      
        Test.stopTest();
        system.assert(extension.cancel()!=NUll);   
    }
}