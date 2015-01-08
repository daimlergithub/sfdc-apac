/**
 *   Type:       Page Controller
 *   ---------------------------------------------------------------
 *   History:
 *   
 *   1. 2014-03-27 Created By Justin Yu
 */
@isTest
public class MassAssignSSIQCControllerTest {

    @isTest static void testMassAssignSSIQCController() {
    	SSI__c ssi = new SSI__c(
    		Status__c = 'In Process',
    		CustomerName__c = 'Test'
    	);
    	insert ssi;
    	
    	QC__c qc = new QC__c(
    		RecordTypeId = '01290000000rXmWAAU',
    		Status__c = 'New',
    		Ssi__c = ssi.Id
    	);
    	insert qc;
    	
    	User user = [select Id from User where ProfileId = '00e90000001K3nq' limit 1];
    	
    	MassAssignSSIQCController controller = new MassAssignSSIQCController();
    	controller.getAssignTypeOptions();
    	controller.applyFilter();
    	controller.assignQC();
    	controller.userIdString = user.Id;
    	controller.assignQC();
    	
    	controller.taskHandler.Subject__c = 'Subject';
    	controller.taskHandler.From__c = System.today().addDays(-5);
    	controller.taskHandler.To__c = System.today().addDays(1);
    	controller.assignType = 'Recall';
    	controller.applyFilter();
    	controller.assignQC();
    }
}