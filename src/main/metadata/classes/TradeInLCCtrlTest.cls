/**************************************************************************************************************************************************************************** 
* File Name     : TradeInLCCtrlTest
* Description   : This Class is Unit test for the TradeInLCCtrl.  
* Copyright     : Daimler
* @author       : Infosys 
* Author Modification & Ver.Date : Raju & 10/09/2018
******************************************************************************************************************************************************************************/ 
@isTest
public class TradeInLCCtrlTest {
    public static Case perAccCaseSetup(Id RecordTypeIdAcc, String firstname, String lastname, String mobile, String market) {
        Account acc= new Account(firstname=firstname, lastname=lastname,Mobile__c=mobile,recordtypeID=RecordTypeIdAcc,Market__c=market);
        insert acc;
        Case tradeCase = new Case();
        tradeCase.Subject = 'Test';
        tradeCase.Status = 'Open';
        tradeCase.AccountId = acc.Id;
        insert tradeCase;
        return tradeCase;
    }
    
    //Success Scenario
    @isTest
    public static void testgetTradeInVehicleList(){
        test.startTest();
        User usr = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
        System.runAs(usr) {
            Id recTypeIdLeadDetail = Schema.SObjectType.Lead_Details__c.getRecordTypeInfosByName().get('Trade In').getRecordTypeId();
            Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            
            
            Id traLeadID = TradeInLCCtrl.getRecordTypeID();
            system.debug('traLeadID: '+traLeadID);
            system.assertNotEquals(null, traLeadID);
            
            Opportunity oppt = leadDetailsLCCtrlTest.perAccOppSetup(RecordTypeIdAcc,'Testing', 'Account','1234560789','AU');
            Opportunity opp=[Select id from Opportunity where id=: oppt.Id];
            List<Lead_Details__c> leadDetlst= IntrestedVehicleLCControllerTest.LeadDetailSetup(recTypeIdLeadDetail,1,opp.Id);
            
            //For opportunity part
            String ObjName = opp.Id.getSObjectType().getDescribe().getName();
            system.debug('sObjectName:'+ObjName);
            list<Lead_Details__c> tradeLeads = TradeInLCCtrl.getTradeInVehicleList(opp.Id);
            system.debug(leadDetlst.size()+'+++No of Lead Details:'+tradeLeads.size());
            system.assertEquals(leadDetlst.size(), tradeLeads.size());
            
            Case tradeInCase = TradeInLCCtrlTest.perAccCaseSetup(RecordTypeIdAcc,'Test', 'Account','1234560789','AU');
            list<Lead_Details__c> tradeLeads1 = TradeInLCCtrl.getTradeInVehicleList(opp.Id);
            tradeLeads1[0].Related_Case__c=tradeInCase.Id;
            update tradeLeads1;  
            //for case part
            String ObjNameCase = tradeInCase.Id.getSObjectType().getDescribe().getName();
            system.debug('sObjectName:'+ObjName);
            list<Lead_Details__c> traCaseLeads = TradeInLCCtrl.getTradeInVehicleList(tradeInCase.Id);
            system.debug(leadDetlst.size()+ 'No of Case Lead Details'+traCaseLeads.size());
            system.assertEquals(leadDetlst.size(), traCaseLeads.size());
        	}
         test.stopTest();
    }
    //Success Scenario
    @isTest
    public static void testsaveTradeInList(){
        test.startTest();
        User usr = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
        System.runAs(usr) {
            Id recTypeIdLeadDetail = Schema.SObjectType.Lead_Details__c.getRecordTypeInfosByName().get('Trade In').getRecordTypeId();
            Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Opportunity oppt = leadDetailsLCCtrlTest.perAccOppSetup(RecordTypeIdAcc,'Testing', 'Account','1234560789','AU');
            Opportunity opp=[Select id from Opportunity where id=: oppt.Id];
            List<Lead_Details__c> leadDetlst1= IntrestedVehicleLCControllerTest.LeadDetailSetup(recTypeIdLeadDetail,1,opp.Id);
            String strSobjects;
            strSobjects = JSON.serialize(leadDetlst1);
            TradeInLCCtrl.saveTradeInList(strSobjects, opp.id);
            
            for(Lead_Details__c leadDetails : leadDetlst1){
            system.assertEquals(leadDetails.RecordTypeId, UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_TradeIn_Record_Type));
            system.assertEquals(leadDetails.Related_Lead__c, opp.id);           
 			}
	 	}
        test.stopTest();
    }
    
    
   
    @isTest
    public static void testsaveTradeInListExcpt(){
        test.startTest();
        User usr = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
        System.runAs(usr) {
            Id recTypeIdLeadDetail = Schema.SObjectType.Lead_Details__c.getRecordTypeInfosByName().get('Trade In').getRecordTypeId();
            Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Opportunity oppt = leadDetailsLCCtrlTest.perAccOppSetup(RecordTypeIdAcc,'Testing', 'Account','1234560789','AU');
            Opportunity opp=[Select id from Opportunity where id=: oppt.Id];
            List<Lead_Details__c> leadDetlst= IntrestedVehicleLCControllerTest.LeadDetailSetup(recTypeIdLeadDetail,1,opp.Id);
            
            String strSobjects;
            strSobjects = JSON.serialize(leadDetlst);
            system.debug('strSobjects: '+strSobjects);
            STring strng ='Test';
            Case tradeInCase = TradeInLCCtrlTest.perAccCaseSetup(RecordTypeIdAcc,'Test', 'Account','1234560789','AU');
            TradeInLCCtrl.saveTradeInList(strng, tradeInCase.id);
            for(Lead_Details__c leadDetails : leadDetlst){
            system.assertNotEquals(leadDetails.Related_Lead__c, tradeInCase.id);
        	}
    	}
        test.stopTest();
  }
}