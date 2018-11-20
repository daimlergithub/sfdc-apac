@isTest
public class VehicleInsightControllerTest {
  
    @isTest
    static void VehicleInsightTest(){
      string vehicleName;
      string vehicleId;
        
      string name;
      string recordId;
        account acc = new account(name='testconn');
        insert acc;
        Vehicle_Relationship__c vr= new Vehicle_Relationship__c();
        vr.contact__c = acc.id;
        insert vr;
      List <PrepopulateInsighstWrapper> lstPIW;
        VehicleInsightController.VehicleInsightWrapper viw = new VehicleInsightController.VehicleInsightWrapper('vehicleName', 'vehicleId','name','recordId',lstPIW);
      VehicleInsightController.VRByCustId(acc.id); 
    }

    
}
