@isTest()
public class InlineVFToShowVehicleDetailTest {
     private static String PersonRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
     private static final String leadVehicleRT = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Vehicle Lead').getRecordTypeId();
     private static final String leadFinanceRT = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Finance Lead').getRecordTypeId();
     private static string LeadTypeValue1 = 'New Car';
     private static string CACLeadStatusValue1='New Enquiry';
     private static string LeadSourceValue = 'Campaign';
     private static string FinanceLeadType = 'Key 2 Key';
     private static string BusinessUnitValue = 'Alliance';
     private static string SubBusinessUnitValue1 = 'Finance & Insurance';
     private static Account personaccount;
     private static Vehicle__c vehicles1;
    
    private static void createAccount(){
            personaccount = new Account(Allow_Data_Sharing__c = 'No', Phone = '56392243', RecordTypeId = PersonRecordtypeid, LastName = 'sichao9');           
            personaccount.FirstName = 'Testfirst';
            personaccount.Salutation='Brother';
            personaccount.Gender__c = 'Male';
            personaccount.Province__c = 'Shanghai';
            personaccount.City__c = 'Anqing city';
            personaccount.Preferred_Language__c = 'English';
            personaccount.Dealer_Lead_System__c = 'Salesforce';
            personaccount.Allow_Data_Sharing__c = 'Yes';
            
            insert personaccount;   
         vehicles1 = new Vehicle__c(EuroVIN__c = '12345678901111111',UsVIN__c = '12345678902222222',Brand__c='Toyota',ModelYear__c='1990');
        insert vehicles1;
        
    }
     @istest
    public static void testInlineVFToShowVehicleDetailController1() {
        
       createAccount();             
       
        
        Lead__c lead = new Lead__c();
        lead.Current_Vehicle__c=vehicles1.id;
        lead.Contact__c = personaccount.Id;
        lead.recordTypeId = leadVehicleRT;
        lead.Lead_Type__c = LeadTypeValue1;
        lead.CAC_Lead_Status__c = CACLeadStatusValue1;
        lead.Lead_Source__c = LeadSourceValue;
        lead.Nature_of_Request__c=FinanceLeadType;
        lead.Business_Unit__c= BusinessUnitValue;
        lead.Sub_BusinessUnit__c=SubBusinessUnitValue1;        
        insert lead;
        
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',lead.id);
        ApexPages.StandardController objSc = new ApexPages.StandardController(lead);
        InlineVFToShowVehicleDetailController objLead= new InlineVFToShowVehicleDetailController(objSc);
        test.stopTest();
         system.assertNotEquals(null, objLead);
    }   
    @istest
    public static void testInlineVFToShowVehicleDetailController2() {
        
       createAccount();           
        
        
        Lead__c lead = new Lead__c();
        lead.Current_Vehicle__c=vehicles1.id;
        lead.Contact__c = personaccount.Id;
        lead.recordTypeId = leadFinanceRT;
        lead.Lead_Type__c = LeadTypeValue1;
        lead.CAC_Lead_Status__c = CACLeadStatusValue1;
        lead.Lead_Source__c = LeadSourceValue;
        lead.Nature_of_Request__c=FinanceLeadType;
        lead.Business_Unit__c= BusinessUnitValue;
        lead.Sub_BusinessUnit__c=SubBusinessUnitValue1;        
        insert lead;
        
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',lead.id);
        ApexPages.StandardController objSc = new ApexPages.StandardController(lead);
        InlineVFToShowVehicleDetailController objLead= new InlineVFToShowVehicleDetailController(objSc);
        test.stopTest();
        system.assertNotEquals(null, objLead);
    }   
    
    

}