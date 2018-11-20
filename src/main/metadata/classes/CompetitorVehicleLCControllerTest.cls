/**************************************************************************************************************************************************************************** 
* File Name     : CompetitorVehicleLCController
* Description   : This Class is Unit test for the CompetitorVehicleLCControllerTest.  
* Copyright     : Daimler
* @author       : Infosys 
* Author Modification & Ver.Date : Raju & 12/09/2018
******************************************************************************************************************************************************************************/ 
@isTest
public class CompetitorVehicleLCControllerTest {
    //Success Scenario  
    @isTest
    private static void testretrievevehicleListInfo(){
    test.startTest();
    User usr = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
    System.runAs(usr) {
        Id recTypeIdLeadDetail = Schema.SObjectType.Lead_Details__c.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    	Opportunity oppt = leadDetailsLCCtrlTest.perAccOppSetup(RecordTypeIdAcc,'Testing', 'Account','1234560789','AU');
    	Opportunity opp = [Select id from Opportunity where id=: oppt.Id];
        List<Lead_Details__c> leadDetlst= IntrestedVehicleLCControllerTest.CompetitorLeadDetailSetup(recTypeIdLeadDetail,1,opp.Id);
        
        CompetitorVehicleLCController.createWrapper wrap = CompetitorVehicleLCController.retrievevehicleListInfo(opp.Id);
        system.debug('Wrapper: '+wrap.compVehicleList.size());
        system.assertEquals(leadDetlst.size(), wrap.compVehicleList.size());
        
        /*List<Lead_Details__c> lstOFleadDet = CompetitorVehicleLCController.addCompRecord(leadDetlst, opp.id);
        system.debug('++++ :'+ CompetitorVehicleLCController.addCompRecord(leadDetlst, opp.id));
        for(Lead_Details__c leadDetails : lstOFleadDet){
            system.assertEquals(leadDetails.RecordTypeId, UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type));
            system.assertEquals(leadDetails.Related_Lead__c, opp.id);
        }*/
        
        String strSobjects;
        strSobjects = JSON.serialize(leadDetlst);
        list<Lead_Details__c> carmodel=[Select id, Car_Model_Competitor__c from Lead_Details__c];
        system.debug('carmodellst: '+carmodel);
        Id cm = carmodel[0].Car_Model_Competitor__c;
        system.debug('strSobjects+'+strSobjects);
        system.debug('carmodelID++++:'+cm);
        Lead_Details__c leadDetl = CompetitorVehicleLCController.cardmodelParametersSC(cm, strSobjects);
        system.assertEquals(carmodel[0].Car_Model_Competitor__c, leadDetl.Car_Model_Competitor__c);
        
        List<Lead_Details__c> leadDetlst1= IntrestedVehicleLCControllerTest.CompetitorLeadDetailSetup(recTypeIdLeadDetail,1,opp.Id);
        String strSobjects1;
        strSobjects1 = JSON.serialize(leadDetlst1);
        CompetitorVehicleLCController.responseWrap wraper = CompetitorVehicleLCController.savecompVehicles(strSobjects1, opp.Id, 0);
        List<Lead_Details__c> vehleadDetlst1 = wraper.vehicleList ;
        for(Lead_Details__c leadDetails : vehleadDetlst1){
            system.assertEquals(leadDetails.RecordTypeId, UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type));
            system.assertEquals(leadDetails.Related_Lead__c, opp.id);           
 			}
    }
    test.stopTest();
    }

}