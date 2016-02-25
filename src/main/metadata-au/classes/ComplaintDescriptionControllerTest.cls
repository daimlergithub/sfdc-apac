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
        upsert new Trigger__c(Name = 'TriggerComplaintDescription', Trigger_Name__c = 'TriggerComplaintDescription', Trigger_Handler__c = 'TriggerComplaintDescriptionHandler', enabled__c = true, before__c = true, after__c = true, insert__c = true, update__c = true, delete__c = true,Market__c='AU');
    }
    
    public static testMethod void test_getTheResults(){       
        init();      
        insert lstComplaintDsc;               
        Test.startTest();
        List<Complaint_Description__c> lstComplaintDsctest=new List<Complaint_Description__c>(); 
         for(Complaint_Description__c description : [SELECT  Name, Date_Time__c, Created_By__r.name, Description__c, CreatedDate FROM Complaint_Description__c where Case__c = :cas.Id order by Date_Time__c desc]) {
               if(description.Description__c!=Null && description.Description__c!='') {
                lstComplaintDsctest.add(description);
            }
        }    
        Test.stopTest();           
        system.assertEquals(extension.getTheResults(),lstComplaintDsctest);       
    }
      public static testMethod void test_Cancel(){        
        init(); 
        PageReference recordURL=new PageReference('/' +cas.Id);        
        Test.startTest();
        PageReference setPage=extension.cancel(); 
        Test.setCurrentPage(setPage);                  
        Test.stopTest();        
        system.assert(extension.cancel()!=Null);        
        system.assertEquals(setPage.getURL(),recordURL.getURL());    
    }
}