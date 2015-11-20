/**
    Purpose: test class for VehicleExtension controller  
    created: sriram kalluri
    Date   : 11/20/2015
*/
@isTest
public class VehicleExtensionTest {
    public static Car_Model__c objCarmodel;
    
    public static void createCarModel(){
        //create test data
        objCarmodel = new Car_Model__c ();
        objCarmodel.Name='Daimler';
        objCarmodel.Brand__c='smart';
        objCarmodel.Series__c='A-CLASS';
        objCarmodel.Model__c='A160';
        objCarmodel.Status__c = 'Own Sellable';
        insert objCarmodel;
        
    }

    public static testMethod void testSaveVal(){
      //create test data
      createCarModel();
        
      //start test
      test.startTest();
      Vehicle__c vehicle = new Vehicle__c();
      ApexPages.StandardController objSc = new ApexPages.StandardController(vehicle);      
      VehicleExtension objVehicleExtension= new VehicleExtension(objSc);
      objVehicleExtension.enteredText1=objCarmodel.Brand__c;
      objVehicleExtension.enteredText2='?';
      objVehicleExtension.enteredText3='?';  
      objVehicleExtension.saveVal();
      //stop test
      test.stopTest();
        
      //verify test
      vehicle=[select Brand__c from Vehicle__c where Brand__c=:objCarmodel.Brand__c];
      system.assertEquals(vehicle.Brand__c, objCarmodel.Brand__c);
        
        
    }
     public static testMethod void testSaveValNegative(){
     
     //create test data
      createCarModel();
         
      //start test
      test.startTest();
      Vehicle__c vehicle = new Vehicle__c();
      ApexPages.StandardController objSc = new ApexPages.StandardController(vehicle); 
      VehicleExtension objVehicleExtension= new VehicleExtension(objSc);
      objVehicleExtension.saveVal();
      //stop test
      test.stopTest();
        
      //verify test
      system.assertEquals(objVehicleExtension.enteredText1, null);  
        
    }
     public static testMethod void testSaveValnew(){
     //create test data
      createCarModel();
         
      //start test
      test.startTest();
      Vehicle__c vehicle = new Vehicle__c();
      ApexPages.StandardController objSc = new ApexPages.StandardController(vehicle);
      VehicleExtension objVehicleExtension= new VehicleExtension(objSc);
      objVehicleExtension.enteredText1=objCarmodel.Brand__c;
      objVehicleExtension.enteredText2='?';
      objVehicleExtension.enteredText3='?';    

      objVehicleExtension.saveValnew();
     //stop test
      test.stopTest();
        
      //verify test
       vehicle=[select Brand__c from Vehicle__c where Brand__c=:objCarmodel.Brand__c];
      system.assertEquals(vehicle.Brand__c, objCarmodel.Brand__c);  
        
    }
    public static testMethod void testSaveValnewNegetive(){
     //create test data
      createCarModel();
        
      //start test
      test.startTest();
      Vehicle__c vehicle = new Vehicle__c();
      ApexPages.StandardController objSc = new ApexPages.StandardController(vehicle);
      VehicleExtension objVehicleExtension= new VehicleExtension(objSc);
      objVehicleExtension.saveValnew();
     //stop test
      test.stopTest();
        
      //verify test
        system.assertEquals(objVehicleExtension.enteredText1, null);    
        
    }
    
}