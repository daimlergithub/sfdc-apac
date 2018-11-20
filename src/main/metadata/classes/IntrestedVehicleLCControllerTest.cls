/**************************************************************************************************************************************************************************** 
* File Name     : IntrestedVehicleLCControllerTest
* Description   : This Class is Unit test for the IntrestedVehicleLCController.  
* Copyright     : Daimler
* @author       : Infosys 
* Author Modification & Ver.Date : Raju & 07/09/2018
******************************************************************************************************************************************************************************/ 
@isTest
public class IntrestedVehicleLCControllerTest {
    public static List<Lead_Details__c> LeadDetailSetup(id recordTypeID, integer noOfleads,id oppId) {
        List<Lead_Details__c> lstLeadDetails = new List<Lead_Details__c>();
        Car_Model__c cmod = new Car_Model__c(Name='Test', Status__c='Own Sellable');
        insert cmod;
        Car_Model__c cm =[select id,name from Car_Model__c where name ='Test' limit 1];
        system.debug('ModelName: '+cm.Name);
        for(integer i=0; i<noOfleads; i++){
            Lead_Details__c lstLead = new Lead_Details__c();
            lstLead.RecordTypeId = recordTypeID;
            lstLead.Related_Lead__c = oppId;
            lstLead.Trim__c = 'Testing||thecretaedleads';
            lstLead.Preferred__c = true;
            lstLead.Car_Model__c = cm.id;
            lstLead.Type__c='Trade In';
            lstLeadDetails.add(lstLead);
            system.debug('++++++++ :'+ lstLead.Car_Model__c);
        }
        insert lstLeadDetails;
        return lstLeadDetails;
    }
    public static List<Lead_Details__c> CompetitorLeadDetailSetup(id recordTypeID, integer noOfleads,id oppId) {
        List<Lead_Details__c> lstLeadDetails = new List<Lead_Details__c>();
        Car_Model__c cmodComp = new Car_Model__c(Name='Test', Status__c='Competitor');
        insert cmodComp;
        Car_Model__c cm =[select id,name from Car_Model__c where id =:cmodComp.Id limit 1];
        system.debug('ModelName: '+cm.Name);
        for(integer i=0; i<noOfleads; i++){
            Lead_Details__c lstLead = new Lead_Details__c();
            lstLead.RecordTypeId = recordTypeID;
            lstLead.Related_Lead__c = oppId;
            lstLead.Trim__c = 'Testing||thecretaedleads';
            lstLead.Preferred__c = true;
            lstLead.Car_Model_Competitor__c = cm.id;
            lstLead.Type__c='Competitor';
            lstLeadDetails.add(lstLead);
        }
        insert lstLeadDetails;
        return lstLeadDetails;
    }
    
    //Test cases for Success Scenarios
    @isTest
    public static void testretrievevehicleListIn(){
    test.startTest();
    User usr = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
    System.runAs(usr) {
        Id recTypeIdLeadDetail = Schema.SObjectType.Lead_Details__c.getRecordTypeInfosByName().get('Interested Vehicle').getRecordTypeId();
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    	Opportunity oppt = leadDetailsLCCtrlTest.perAccOppSetup(RecordTypeIdAcc,'Testing', 'Account','1234560789','AU');
    	Opportunity opp = [Select id from Opportunity where id=: oppt.Id];
        List<Lead_Details__c> leadDetlst= LeadDetailSetup(recTypeIdLeadDetail,1,opp.Id);
        
        IntrestedVehicleLCController.createWrapper creWrap = IntrestedVehicleLCController.retrievevehicleListInfo(opp.id);
        system.debug('Wrapper: '+creWrap.intVehicleList.size());
        system.assertEquals(leadDetlst.size(), creWrap.intVehicleList.size());
        
        
       /* List<Lead_Details__c> lstOFleadDet = IntrestedVehicleLCController.addIntRecord(leadDetlst, opp.id);
        system.debug('++++ :'+ IntrestedVehicleLCController.addIntRecord(leadDetlst, opp.id));
        for(Lead_Details__c leadDetails : lstOFleadDet){
            system.assertEquals(leadDetails.RecordTypeId, UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Interested_Record_Type));
            system.assertEquals(leadDetails.Related_Lead__c, opp.id);
        }*/
        
        String strSobjects;
        strSobjects = JSON.serialize(leadDetlst);
        /*List<Lead_Details__c> lstOFleadDetail = IntrestedVehicleLCController.addIntRecordSec(strSobjects, opp.id);
        for(Lead_Details__c leadDetails : lstOFleadDetail){
            system.assertEquals(leadDetails.RecordTypeId, UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Interested_Record_Type));
            system.assertEquals(leadDetails.Related_Lead__c, opp.id);
        }*/
        
        
        list<Lead_Details__c> carmodel=[Select id, Car_Model__c from Lead_Details__c limit 1];
        Id cm = carmodel[0].Car_Model__c;
        system.debug('strSobjects+'+strSobjects);
        Lead_Details__c leaddet = IntrestedVehicleLCController.cardmodelParametersSC(cm, strSobjects);
        system.assertEquals(carmodel[0].Car_Model__c, leaddet.Car_Model__c);
        
        
        List<Lead_Details__c> leadDetlst1= LeadDetailSetup(recTypeIdLeadDetail,1,opp.Id);
        String strSobjects1;
        strSobjects1 = JSON.serialize(leadDetlst1);
        IntrestedVehicleLCController.responseWrap wrap = IntrestedVehicleLCController.saveIntVehicles(strSobjects1, opp.Id, 0);
        List<Lead_Details__c> vehleadDetlst1 = wrap.vehicleList ;
        for(Lead_Details__c leadDetails : vehleadDetlst1){
            system.assertEquals(leadDetails.RecordTypeId, UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Interested_Record_Type));
            system.assertEquals(leadDetails.Related_Lead__c, opp.id);           
 			}
        
        //Boolean tog=IntrestedVehicleLCController.checkIntVehiclePreferred(leadDetlst);
        //system.assertEquals(false, tog);
    }
	test.stopTest();
    }
    //Test case to save Competiror Car model
    @isTest
    public static void testsaveIntVehicles(){
    test.startTest();
    User usr = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
    System.runAs(usr) {
        Id recTypeIdLeadDetail = Schema.SObjectType.Lead_Details__c.getRecordTypeInfosByName().get('Interested Vehicle').getRecordTypeId();
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    	Opportunity oppt = leadDetailsLCCtrlTest.perAccOppSetup(RecordTypeIdAcc,'Testing', 'Account','1234560789','AU');
    	Opportunity opp = [Select id from Opportunity where id=: oppt.Id];
		List<Lead_Details__c> leadDetlst1= CompetitorLeadDetailSetup(recTypeIdLeadDetail,1,opp.Id);
        String strSobjects1;
        strSobjects1 = JSON.serialize(leadDetlst1);
        IntrestedVehicleLCController.responseWrap wrap = IntrestedVehicleLCController.saveIntVehicles(strSobjects1, opp.Id, 0);
        List<Lead_Details__c> vehleadDetlst1 = wrap.vehicleList ;
        for(Lead_Details__c leadDetails : vehleadDetlst1){
            system.assertEquals(leadDetails.RecordTypeId, UtilRecordType.getRecordTypeIdByName('Lead_Details__c', System.Label.Lead_Detail_Competitor_Record_Type));
            system.assertEquals(leadDetails.Related_Lead__c, opp.id);           
 			}
    }
    test.stopTest();
    }
    
}