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
        Id dealerRTId
            = Schema.SObjectType.Account.getRecordTypeInfosByName()
              .get('Dealer').getRecordTypeId();
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
        NewVehicleRelationship.getParameters().put('retURL','retURL');
        Test.setCurrentPage(NewVehicleRelationship);
        NewVehicleRelationshipController controller = new NewVehicleRelationshipController();
        controller.save(); 
        Test.stopTest();
        
    }
}