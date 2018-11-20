/**************************************************************************************************************************************************************************** 
* File Name     : leadDetailsLCCtrlTest
* Description   : This Class is Unit test class for the leadDetailsLCCtrl.  
* Copyright     : Daimler
* @author       : Infosys 
* Author Modification & Ver.Date : Raju & 06/09/2018
******************************************************************************************************************************************************************************/ 
@isTest
public class leadDetailsLCCtrlTest {
	public static string salesLeadRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales Lead').getRecordTypeId();
	
    public static Opportunity perAccOppSetup(Id RecordTypeIdAcc, String firstname, String lastname, String mobile, String market) {
        Account acc= new Account(firstname=firstname, lastname=lastname,Mobile__c=mobile,recordtypeID=RecordTypeIdAcc,Market__c=market);
        insert acc;
        Opportunity opp = new Opportunity();
        opp.AccountId = acc.Id;
        opp.StageName = 'New';
        opp.Market__c = 'AU';
        opp.Name = 'Generic Opportunity';
        opp.RecordTypeId = salesLeadRecordTypeId;
        opp.CloseDate = Date.today();
        opp.Type_of_Sale__c='Government';
        opp.Selected_Car_Model__c ='CLA;A-Class'; 
        insert opp;  
	return opp;		
    }
    
    @isTest
    public static void testFieldSetForMkt(){
        test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
        User usr = [Select alias,Market__c from User where id=:u.id]; 
        system.debug('Alias'+usr.Alias);
        System.runAs(usr) {
            Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Opportunity oppt = leadDetailsLCCtrlTest.perAccOppSetup(RecordTypeIdAcc,'Testing', 'Account','1234560789','AU');
            Opportunity opp = [Select recordtypeid from Opportunity where id=: oppt.Id];
            String recordTypeName = Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(Opp.RecordTypeId).getname();  
            
            
            //Sucess Scenario
            Object obj = leadDetailsLCCtrl.getFIeldSetForMkt(opp.id,recordTypeName);
            system.assertNotEquals(null, obj);
            system.debug('Object: '+ (leadDetailsLCCtrl.Details)obj);
            
            
            //Exception Scenario
            Object objt = leadDetailsLCCtrl.getFIeldSetForMkt(salesLeadRecordTypeId,recordTypeName);
            system.assertEquals(null, objt);
            
            //Sucess scenario for get recordtype name
            String recTypename = leadDetailsLCCtrl.getRecTypeName(opp.id);
            String salesRecTypeName = Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(Opp.RecordTypeId).getname();
            system.assertEquals(recTypename, salesRecTypeName);
            
            // Exception scenario for getrecordtype id
            Id recTypeId = leadDetailsLCCtrl.getRecTypeId('Sales Lead');
            //String recrdTypeName = [SELECT name FROM RecordType WHERE id=:recTypeId];
            system.assertEquals(salesLeadRecordTypeId, recTypeId);  
            
            LeadDetailsDefault LD = new LeadDetailsDefault();
            String dummyString='test';
            List<String> fmapList=new List<String>();
            fmapList.add('test1');
            Map<String,List<String>> fMap=new Map<String,List<String>>();
            fMap.put(dummyString, fmapList);
            LD.setFieldMap(fMap);
            system.assertEquals(LD.getFieldMap(), fMap);
            LD.getFieldMap();
            system.assertEquals(fMap, LD.getFieldMap());
        }
         test.stopTest();
    }
    
}