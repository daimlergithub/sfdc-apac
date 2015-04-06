/*
    Type:       Test class of CaseEscalationController
    Purpose:    1. Escalate Case to Region Q
                2. Escalate Case to Central Q
    
    User Story: US-DP-013, US-DP-015
    Used By:    
    ---------------------------------------------------------------
    History:
    
    30-May-2013 Sinow Zhang (NTTData)  Created
*/     
@isTest
public class CaseEscalationControllerTest { 
  
    static CaseEscalationController controller;
    static Case c;
    static User currentUsr;
    static user objUsr;
    static{
       currentUsr = UtilTestData.createUser('Regional CRM Mgr (S)','Regional CRM Manager');
    }
    static{
        objUsr=[select id from user where id=:userinfo.getuserid()];
    }   
    static void init( boolean isrequired){
     Account dealer = new Account();
        dealer.Allow_Data_Sharing__c = 'Yes';
        dealer.Province__c = 'jiangsu';
        dealer.City__c = 'nanjing';
        dealer.Preferred_Language__c = 'English';
        dealer.Dealer_LMS__c = 'No';
        dealer.Name='shrek';
        dealer.Gender__c = '0=Male';
        dealer.ZipCode__c = '200235';
        dealer.Type = '0=Company';
        dealer.Phone = '00000000'; 
        dealer.Status__c = '0=contac1';
        dealer.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        dealer.No_of_Dealer_Portal_Licenses__c = Decimal.valueOf(20);
        dealer.Dealer_Region__c = 'West';
        insert dealer;
        Account Person = new Account();
        Person.lastName='PersonAccount';
        Person.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account Retail').getRecordTypeId();
        insert Person;
        c = new Case();
        c.Subject = 'For Mail test';
        c.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
        c.Case_Dealer__c = dealer.id;
        c.Case_Department__c = 'test';
        c.Description = 'test';
        c.Case_Type__c = 'test';
        c.Case_SubType__c = 'test'; 
        c.Case_Source__c = 'test';
        c.Date_of_1st_Registration__c = Date.Today();
        c.Selling_Dealer__c = 'test';
        c.Last_Known_Mileage__c = 1;
        c.Defective_Item__c = 'test';
        c.Defective_SubItem__c = 'test';
        c.Customer_Requests_Transport__c = 'test';
        c.Dealer_Provides_Transport__c = 'test';
        c.Customer_Background_Info__c = 'test';
        c.Region__c = 'North';
        c.Government_Background__c = 'test'; 
        c.Occupation__c = 'test';
        c.Owner_Tele__c = 'test';
        c.Owned_MB_Vehicle_PL__c = '1';
        c.EU_VIN__c = 'test';
        c.US_VIN__c = 'test';
        c.Order_No__c = '1';
        c.Vehicle_Class__c = 'test';
        c.CLB__c = 'test';
        c.Registration_Number__c  = 'test'; 
        c.Car_Type__c = 'test';
        if(isrequired)
            c.Dealer_Case_Type__c = 'test';
        else
            c.Dealer_Case_Type__c = null;   
        c.Dealer_Case_SubType__c = 'test';
        c.RO_CO_Case_Category__c = 'Aftersales';
        c.Vehicle_In_Workshop__c = 'Yes';
        c.Ref_No_Regional__c = 'SOUTH';
        c.Ref_No_Central__c='SOUTH';
        insert c;
              
        PageReference caseEscalation = Page.CaseEscalation;
        caseEscalation.getParameters().put('id',c.id);
        Test.setCurrentPage(caseEscalation);
        controller = new CaseEscalationController();   
    }
    
    @future
    static void test_EscalateCase_Dealer_Region_East(){    
        init(true);    
        controller.EscalateCase.Case_Dealer__r.Dealer_Region__c = 'EAST';          
        controller.escalate();      
      }    
    @future
    static void test_EscalateCase_Dealer_Region(){    
        init(true);    
        controller.EscalateCase.Case_Dealer__r.Dealer_Region__c = '';          
        controller.escalate();      
      } 
   @future
    static void test_EscalateCase_Dealer_Region_West_elsecondition(){    
        init(false);    
        controller.EscalateCase.Case_Dealer__r.Dealer_Region__c = 'WEST';          
        controller.escalate();      
      }             
    public static testMethod void test_escalate_Dealer_EastRegion(){      
         system.runAs(currentUsr){
            Test.startTest();
            test_EscalateCase_Dealer_Region_East();                     
            Test.stopTest();                       
            system.assert(controller.escalate()!=Null);  
            system.assertequals(Date.today(),controller.EscalateCase.Escalate_Date_to_CO__c);               
            system.assertequals('Awaiting MB',controller.EscalateCase.Status);  
            system.assertequals('Central Office',controller.EscalateCase.Handling_Level__c);             
         }        
     }       
     public static testMethod void test_escalate_Dealer_Region(){      
         system.runAs(currentUsr){
            Test.startTest();           
            test_EscalateCase_Dealer_Region();          
            Test.stopTest();         
            system.assert(controller.escalate()==Null);                            
         }        
      } 
     public static testMethod void testEscalate_West_elsecondition(){         
        system.runAs(objUsr){     
            Test.startTest();
            test_EscalateCase_Dealer_Region_West_elsecondition();
            Test.stopTest();  
            system.assert([select Id, Name from Profile where Id = :UserInfo.getProfileId()].name!='Regional CRM Manager'); 
            system.assertnotequals([select Id, Name from Profile where Id = :UserInfo.getProfileId()].name,'Regional CRM Manager');
        }       
     }    
 }

                                                

