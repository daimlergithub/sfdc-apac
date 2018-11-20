/**************************************************************************************************************************************************************************** 
* File Name     : CurrentVehicleLCControllerTest
* Description   : This Class is Unit test for the CurrentVehicleLCController.  
* Copyright     : Daimler
* @author       : Infosys 
* Author Modification & Ver.Date : Raju & 11/09/2018
******************************************************************************************************************************************************************************/ 
@isTest
public class CurrentVehicleLCControllerTest {
    
    //Success Scenario
     @isTest
    public static void testretrievevehicleListInfoFromAcctID(){
        test.startTest();
        User usr = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
        System.runAs(usr) {
            Id recTypeIdLeadDetail = Schema.SObjectType.Lead_Details__c.getRecordTypeInfosByName().get('Interested Vehicle').getRecordTypeId();
            Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Opportunity oppt = leadDetailsLCCtrlTest.perAccOppSetup(RecordTypeIdAcc,'Testing', 'Account','1234560789','AU');
            Opportunity opp = [Select id,AccountId from Opportunity where id=: oppt.Id];
            List<Vehicle_Relationship__c> accrelCurVehLst = [Select Vehicle_Model__c,Vehicle_Brand__c,Vehicle_Class__c,Mileage_start__c,Mileage_End__c 
                                                             FROM Vehicle_Relationship__c where Contact__c =: opp.AccountId];
            CurrentVehicleLCController.createWrapper wrap = CurrentVehicleLCController.retrievevehicleListInfoFromAcctID(opp.AccountId);
            List<Vehicle_Relationship__c> currentvehlst = wrap.currentVehicleList ;
            system.assertEquals(accrelCurVehLst.size(), currentvehlst.size());
            
            CurrentVehicleLCController.createWrapper wrapOpp = CurrentVehicleLCController.retrievevehicleListInfoFromOpptyID(opp.Id);
            List<Vehicle_Relationship__c> currentvehlstOpp = wrapOpp.currentVehicleList ;
            system.assertEquals(accrelCurVehLst.size(), currentvehlstOpp.size());
            
            Case cmpCase = TradeInLCCtrlTest.perAccCaseSetup(RecordTypeIdAcc,'Test', 'Account','1234560789','AU');
            
            //insert cmpCase;
            system.debug('case'+cmpCase.id);
            CurrentVehicleLCController.createWrapper wrapOpp1 = CurrentVehicleLCController.retrievevehicleListInfoFromOpptyID(cmpCase.Id);
            
        }
        test.stopTest();
    }

}