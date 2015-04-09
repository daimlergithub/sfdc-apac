/*
    Type:       Test class of NewVehicleRelationshipController
    Purpose:    
    
    User Story: CR_HLD_CAC_009
    Used By:    
    ---------------------------------------------------------------
    History:
    
    2014-03-10 Shuang Li (NTTData)  Created
*/     
@isTest
public class NewVehicleRelationshipControllerTest {
    @isTest
    static void testNewVehicleRelationshipController1(){
        Id dealerRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
        Account dealer1 = new Account(Status__c = 'new'
                                     , Name = 'TestDealer' + date.Today()
                                     , RecordTypeId = dealerRTId
                                     , Phone ='(01) 8677 0993'
                                     , Dealer_Active__c = true
                                     );
        insert dealer1;
        Test.startTest();
        PageReference NewVehicleRelationship = Page.NewVehicleRelationship;
        NewVehicleRelationship.getParameters().put('accountId',dealer1.id);
        vehicle__c vehicle= new vehicle__c();
        Vehicle_Relationship__c vehicleRelationship = new Vehicle_Relationship__c();
        vehicleRelationship.Contact__c = NewVehicleRelationship.getParameters().put('accountId',dealer1.id);
        NewVehicleRelationship.getParameters().put('retURL','retURL');
        Test.setCurrentPage(NewVehicleRelationship);
        NewVehicleRelationshipController controller = new NewVehicleRelationshipController();
        controller.save(); 
        Test.stopTest();
        system.assert(vehicle!=Null);
        system.assert(controller.save()!=Null);
        system.assertequals(vehicleRelationship.Vehicle_ID__c,vehicle.id);
        system.assert(vehicleRelationship!=Null);    
    }
}