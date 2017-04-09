/**
    Purpose: test class for VehicleExtension controller  
    created: sriram kalluri
    Date   : 11/20/2015
*/
@isTest
public class VehicleExtensionTest {
    public static Car_Model__c objCarmodel;
    public static Vehicle__c vehicleobj;
    public static string VehicleMBRecordtypeid = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
   
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
    public static testmethod void testsave() {
      createCarModel();
      vehicleobj = new Vehicle__c();
      vehicleobj.RecordTypeId=VehicleMBRecordtypeid;
      vehicleobj.Vehicle_Name__c ='Test1';
      vehicleobj.UsVIN__c ='abchgdtrsghtredfr';
      //vehicleobj.Car_Model__c=objCarmodel.id;
      vehicleobj.Brand__c='Mercedes-Benz';
      vehicleobj.Class__c='A-Class';
      vehicleobj.Model__c='R350L 4MATIC';
      vehicleobj.FirstRegistrationDate__c = date.valueOf(date.today());
      vehicleobj.Purchase_Month__c ='02';
      vehicleobj.Purchase_Year__c = '2004';
      vehicleobj.RegistrationNo__c = '333';
      vehicleobj.Competitor_Brand__c='AMC';
      vehicleobj.Range__c='testrange';
      vehicleobj.Modification_Package__c='modPackage';
      vehicleobj.Vehicle_Group__c='SUV';
      vehicleobj.BaumusterEx__c='LeftManual';
      vehicleobj.Competitor_Model__c='compModel';
      //insert vehicleobj;
      system.debug('$$$$$$$$$$$$$'+vehicleobj);
      ApexPages.StandardController objSc = new ApexPages.StandardController(vehicleobj);    
      system.debug('$$$$$$$$$$$$$'+objSc);
      VehicleExtension VehicleobjExtension= new VehicleExtension(objSc);
      //RecordType rType = [select id, name from RecordType where id =: VehicleMBRecordtypeid];
      //VehicleobjExtension.recordType = rType.Name;
      VehicleobjExtension.recordType=UtilConstant.MB;
      VehicleobjExtension.brand=UtilConstant.Question;
      VehicleobjExtension.class1=UtilConstant.Question;
      VehicleobjExtension.compBrand=UtilConstant.Question;
      VehicleobjExtension.model=UtilConstant.Question;
      VehicleobjExtension.range=UtilConstant.Question;
      VehicleobjExtension.modPackage=UtilConstant.Question;
      VehicleobjExtension.VG=UtilConstant.Question;
      VehicleobjExtension.steering=UtilConstant.Question;
      VehicleobjExtension.compModel=UtilConstant.Question;
      VehicleobjExtension.brand=UtilConstant.Question;
      system.debug('$$$$$$$$$$$$$'+objSc);
      
      VehicleobjExtension.save();
    }
    
    public static testMethod void testSaveValNegative(){
      //create test data
      createCarModel();
      //Car_Model__c cmobj = new Car_Model__c();
      //cmobj.save(); 
      //start test
      test.startTest();
      Vehicle__c vehicle = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222',
                                                Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today(),Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
      ApexPages.StandardController objSc = new ApexPages.StandardController(vehicle);      
      VehicleExtension objVehicleExtension= new VehicleExtension(objSc);
      objVehicleExtension.brand=UtilConstant.Question;
      objVehicleExtension.model=UtilConstant.Question;
      objVehicleExtension.class1=UtilConstant.Question;
      objVehicleExtension.recordType=UtilConstant.MB;
      objVehicleExtension.saveVal();
      //objVehicleExtension.save();
      objVehicleExtension.saveAndNew();
      
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
       objVehicleExtension.Cancel();
      //stop test
      test.stopTest();
        
      //verify test
      //vehicle=[select Brand__c from Vehicle__c where Brand__c=:objCarmodel.Brand__c];
      //system.assertEquals('smart', vehicle.Brand__c);     
    }

  public static testMethod void testVehicleSave(){
    //create test data
        createCarModel();
         
        //start test
        test.startTest();
        
        // Vehicle
        Vehicle__c vehicle = new Vehicle__c(Recall__c = false, EuroVIN__c = '12345678901111111', UsVIN__c = '12345678902222222'
                            ,Brand__c ='Mercedes-Benz', FirstRegistrationDate__c = date.today(), Purchase_Month__c ='02'
                              , Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004'
                                ,RegistrationNo__c = '12345');
    
    ApexPages.StandardController objSc = new ApexPages.StandardController(vehicle); 
    VehicleExtension objVehicleExtension= new VehicleExtension(objSc);
         
         objVehicleExtension.recordType= 'Vehicle Product';
    objVehicleExtension.brand= 'Smart';
    objVehicleExtension.model= 'A160';
    objVehicleExtension.compBrand= 'Smart';
    objVehicleExtension.compModel= 'A160';
    objVehicleExtension.saveVal();
    
    system.assertEquals(vehicle.Brand__c,objVehicleExtension.brand);
    system.assertEquals(vehicle.Model__c,objVehicleExtension.model);
    
         objVehicleExtension.recordType= 'Vehicle Product';
    objVehicleExtension.brand= 'Smart';
    objVehicleExtension.model= 'A160';
    objVehicleExtension.compBrand= 'Smart';
    objVehicleExtension.compModel= 'A160';
    objVehicleExtension.saveAndNew();

    system.assertEquals(vehicle.Brand__c,objVehicleExtension.brand);
    system.assertEquals(vehicle.Model__c,objVehicleExtension.model);
      
    //stop test
    test.stopTest();   
    }






}