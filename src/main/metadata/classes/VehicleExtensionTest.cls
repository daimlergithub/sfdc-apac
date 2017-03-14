/**
    Purpose: test class for VehicleExtension controller  
    created: sriram kalluri
    Date   : 11/20/2015
*/
@isTest
public class VehicleExtensionTest {
    public static Car_Model__c objCarmodel;
    
    public static void createCarModel(){
        
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsJP.customSettingDetails();
        insert updatecustomsettings;

        //create test data
        objCarmodel = new Car_Model__c ();
        objCarmodel.Name='Daimler';
        objCarmodel.Brand__c='Smart';
        objCarmodel.Series__c='A-CLASS';
        objCarmodel.Model__c='A160';
        objCarmodel.Status__c = 'Own Sellable';
        insert objCarmodel;
        
    }

    public static testMethod void testSaveValNegative(){
      //create test data
      createCarModel();
        
      //start test
      test.startTest();
      Vehicle__c vehicle = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222',
                                                Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
      ApexPages.StandardController objSc = new ApexPages.StandardController(vehicle);      
      VehicleExtension objVehicleExtension= new VehicleExtension(objSc);
      objVehicleExtension.brand=UtilConstant.Question;
      objVehicleExtension.class1=UtilConstant.Question;
      objVehicleExtension.recordType=UtilConstant.MB;
      objVehicleExtension.saveVal();
      objVehicleExtension.saveAndNew();
      objVehicleExtension.save();
      
      //stop test
      test.stopTest();
        
      //verify test
      system.assertEquals(objVehicleExtension.saveVal(), null);
      system.assertEquals(objVehicleExtension.saveAndNew(), null);
        
        
    }
     public static testMethod void testSaveVal(){
     
     //create test data
      createCarModel();
         
      //start test
      test.startTest();
      Vehicle__c vehicle = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222',
                                                Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
      ApexPages.StandardController objSc = new ApexPages.StandardController(vehicle); 
      VehicleExtension objVehicleExtension= new VehicleExtension(objSc);
       objVehicleExtension.recordType=UtilConstant.Competitor;
       VehicleExtension.getCarModelValues(UtilConstant.Competitor);
       VehicleExtension.getCarModelValues(UtilConstant.MB);
       objVehicleExtension.compBrand=objCarmodel.Brand__c;
       objVehicleExtension.class1=UtilConstant.Question;
       objVehicleExtension.model=UtilConstant.Question;
       objVehicleExtension.range=UtilConstant.Question;
       objVehicleExtension.modPackage=UtilConstant.Question;
       objVehicleExtension.VG=UtilConstant.Question;
       objVehicleExtension.steering=UtilConstant.Question;
       objVehicleExtension.compModel=UtilConstant.Question;
       objVehicleExtension.brand=UtilConstant.Question;
       objVehicleExtension.saveVal();
       objVehicleExtension.saveAndNew();
       objVehicleExtension.save();
       objVehicleExtension.Cancel();
      //stop test
      test.stopTest();
        
      //verify test
      //vehicle=[select Competitor_Brand__c from Vehicle__c where Competitor_Brand__c=:objCarmodel.Brand__c];
     // system.assertEquals(objVehicleExtension.compBrand, vehicle.Competitor_Brand__c);  
        
    }
    
    public static testMethod void testSaveAndNewVal(){
     
     //create test data
      createCarModel();
         
      //start test
      test.startTest();
      Vehicle__c vehicle = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222',
                                                Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
      ApexPages.StandardController objSc = new ApexPages.StandardController(vehicle); 
      VehicleExtension objVehicleExtension= new VehicleExtension(objSc);
       objVehicleExtension.recordType=UtilConstant.MB;
       VehicleExtension.getCarModelValues(UtilConstant.MB);
       objVehicleExtension.compBrand=UtilConstant.Question;
       objVehicleExtension.class1=UtilConstant.Question;
       objVehicleExtension.model=UtilConstant.Question;
       objVehicleExtension.range=UtilConstant.Question;
       objVehicleExtension.modPackage=UtilConstant.Question;
       objVehicleExtension.VG=UtilConstant.Question;
       objVehicleExtension.steering=UtilConstant.Question;
       objVehicleExtension.compModel=UtilConstant.Question;
       objVehicleExtension.brand=objCarmodel.Brand__c;
       objVehicleExtension.saveVal();
       objVehicleExtension.saveAndNew();
      objVehicleExtension.save();
       objVehicleExtension.Cancel();
      //stop test
      test.stopTest();
        
      //verify test
      //vehicle=[select Brand__c from Vehicle__c where Brand__c=:objCarmodel.Brand__c];
      //system.assertEquals('smart', vehicle.Brand__c);  
        
    }
    
    
}