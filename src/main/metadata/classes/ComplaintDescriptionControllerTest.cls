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
    static List<Complaint_Description__c> lstComplaintDsc=new List<Complaint_Description__c>(); 
    static ComplaintDescriptionController extension;
    static PageReference ComplaintDescriptionViewAll;
    static PageReference BASE_URL;
    
    private static void init(){
         cas = (Case)UtilTestData.createSobject(new Case(), UtilTestData.CASE_RT_MB_COMPLAINT);
         Complaint_Description__c c_Desc1 = new Complaint_Description__c (Case__c = cas.id,Description__c='Description1');
         Complaint_Description__c c_Desc2 = new Complaint_Description__c (Case__c = cas.id,Description__c='Description2');
         Complaint_Description__c c_Desc3 = new Complaint_Description__c (Case__c = cas.id,Description__c='Description3');
         Complaint_Description__c c_Desc4 = new Complaint_Description__c (Case__c = cas.id,Description__c='Description4');
         Complaint_Description__c c_Desc5 = new Complaint_Description__c (Case__c = cas.id);
         Complaint_Description__c c_Desc6 = new Complaint_Description__c (Case__c = cas.id);
         lstComplaintDsc.add(c_Desc1);
         lstComplaintDsc.add(c_Desc2);
         lstComplaintDsc.add(c_Desc3);
         lstComplaintDsc.add(c_Desc4);
         lstComplaintDsc.add(c_Desc5);
         lstComplaintDsc.add(c_Desc6);
        
        ComplaintDescriptionViewAll=Page.ComplaintDescriptionViewAll;
        ComplaintDescriptionViewAll.getParameters().put('caseId',cas.Id);       
        Test.setCurrentPage(ComplaintDescriptionViewAll);    
        extension= new ComplaintDescriptionController();
    }
    //static PageReference BASE_URL; 
    public static testMethod void test_getTheResults(){       
        init();      
        insert lstComplaintDsc;               
        Test.startTest();  
         extension.getTheResults();    
        List<Complaint_Description__c> lstComplaintDsctest=new List<Complaint_Description__c>(); 
         for(Complaint_Description__c description : [SELECT  Name, Date_Time__c, Created_By__r.name, Description__c, CreatedDate FROM Complaint_Description__c where Case__c = :cas.Id order by Date_Time__c desc]) {
            if(!String.isBlank(description.Description__c)) {
                lstComplaintDsctest.add(description);
            }
        }    
        Test.stopTest();       
       // system.assertEquals(extension.getTheResults(),lstComplaintDsctest);
    }
      public static testMethod void test_Cancel(){  
        init(); 
        Test.startTest();      
        extension.cancel();      
        Test.stopTest();  
        system.assert(extension.cancel()!=Null);        
    }
}