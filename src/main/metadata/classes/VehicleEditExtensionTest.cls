/* created by saranya gotrala*/
@isTest
public with sharing class VehicleEditExtensionTest {
 
     public static string VehicleMBRecordtypeid = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
     public static string VehiclecompRecordtypeid = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
 public static testMethod void testVehicle1()
    {
    String recordType;
       Account personAcc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801110',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                LastName = '刈乾冠寒刊勘',
                                FirstName = '刈乾冠寒刊勘',
                                Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1002347',
                                Mobile__c = '023482832',
                                Mobile2__c = '035456232',
                                Primary_Email__c = 'Email1',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'JP',
                                Industry = 'Other',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
                                insert personAcc;
                                
        Car_Model__c objCarmodel = new Car_Model__c ();
        objCarmodel.Name='Daimler';
        objCarmodel.Brand__c='Smart';
        objCarmodel.Series__c='A-CLASS';
        objCarmodel.Model__c='A160';
        objCarmodel.Status__c = 'Own Sellable';
        insert objCarmodel;
        
      Vehicle__c vehicleobj = new Vehicle__c();
      vehicleobj.RecordTypeId=VehicleMBRecordtypeid;
      vehicleobj.Vehicle_Name__c ='Test1';
      vehicleobj.UsVIN__c ='abchgdtrsghtredfr';
      vehicleobj.Car_Model__c=objCarmodel.id;
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
      insert vehicleobj;     
      apexpages.currentpage().getparameters().put('id' , vehicleobj.id);
       ApexPages.StandardController objSc = new ApexPages.StandardController(vehicleobj);
      VehicleEditExtension cont = new VehicleEditExtension(objSc); 
      cont.getbrands();
      cont.getclasses();
      cont.getmodels();
      cont.getranges();
      cont.getmodeldesc();
      cont.getvgs();
      cont.getsteers(); 
      cont.saveveh();
      cont.saveAndNew();
      cont.Cancel();
      cont.getbrandtype();
      cont.getmodeltype(); 
    }
     public static testMethod void testVehicle2()
    {
       Account personAcc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801110',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                LastName = '刈乾冠寒刊勘',
                                FirstName = '刈乾冠寒刊勘',
                                Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1002347',
                                Mobile__c = '023482832',
                                Mobile2__c = '035456232',
                                Primary_Email__c = 'Email1',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'JP',
                                Industry = 'Other',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
                                insert personAcc;
                                
        Car_Model__c objCarmodel = new Car_Model__c ();
        objCarmodel.Name='Daimler';
        objCarmodel.Brand__c='Smart';
        objCarmodel.Series__c='A-CLASS';
        objCarmodel.Model__c='A160';
        objCarmodel.Status__c = 'Competitor';
        insert objCarmodel;
        
      Vehicle__c vehicleobj = new Vehicle__c();
      vehicleobj.RecordTypeId=VehiclecompRecordtypeid ;
      vehicleobj.Vehicle_Name__c ='Test1';
      vehicleobj.UsVIN__c ='abchgdtrsghtredfr';
      vehicleobj.Car_Model__c=objCarmodel.id;
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
      insert vehicleobj;                         
      
      apexpages.currentpage().getparameters().put('id' , vehicleobj.id);
       ApexPages.StandardController objSc = new ApexPages.StandardController(vehicleobj);
      VehicleEditExtension cont = new VehicleEditExtension(objSc); 
      cont.getcompbrands();
      cont.getcompmodels();
      cont.saveveh();
      cont.saveAndNew();
      cont.Cancel();
    }
    public static testMethod void testVehicle3()
    { 
     RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        Account dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer', MBK_Data_Source__c ='Email',Dealer_GC_Code__c = 'Test12');
        insert dealer;
       Contact contact = new Contact();
        contact.FirstName = 'a';
        contact.LastName = 'b';
        contact.Email = 'sysAdmin1@dialmer.com';
        contact.Phone = '1212313';
        contact.Title = 'contact title';
        contact.Name_English__c = 'c';
        contact.AccountId = dealer.Id;
        contact.Dealer_Presales__c = true;
        insert contact;
        
  // Fetch Profile Id
        Id sysAdminProfileId = [SELECT Id FROM Profile WHERE Name = 'Japan Dealer Sales Manager' limit 1].ID;
// Create User       
       User sysAdminUser1 = new User ( Alias = 'sysA1'
                                        , Email='sysAdmin1@dialmer.com'
                                        , EmailEncodingKey='UTF-8'
                                        , LastName='Adminstrator'
                                        , FirstName='System'
                                        , LanguageLocaleKey='en_US'
                                        , LocaleSidKey='en_US'
                                        , ProfileId = sysAdminProfileId
                                        , TimeZoneSidKey='America/Los_Angeles'
                                        , Market__c = 'JP'
                                        , UserName='sysAdmin1@mbj.daimler-apac.com.asiadev1'
                                        , User_Type__c = 'Dealer'
                                        , ContactId = contact.Id);
        insert sysAdminUser1;
       System.runas(sysAdminUser1) {
       Account personAcc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801110',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                LastName = '刈乾冠寒刊勘',
                                FirstName = '刈乾冠寒刊勘',
                                Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1002347',
                                Mobile__c = '023482832',
                                Mobile2__c = '035456232',
                                Primary_Email__c = 'Email1',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'JP',
                                Industry = 'Other',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
                                insert personAcc;
                                
        Car_Model__c objCarmodel = new Car_Model__c ();
        objCarmodel.Name='Daimler';
        objCarmodel.Brand__c='Smart';
        objCarmodel.Series__c='A-CLASS';
        objCarmodel.Model__c='A160';
        objCarmodel.Status__c = 'Own Sellable';
        insert objCarmodel;
        
      Vehicle__c vehicleobj = new Vehicle__c();
      vehicleobj.RecordTypeId=VehicleMBRecordtypeid;
      vehicleobj.Vehicle_Name__c ='Test1';
      vehicleobj.UsVIN__c ='abchgdtrsghtredfr';
      vehicleobj.Car_Model__c=objCarmodel.id;
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
      insert vehicleobj;                         
      
      apexpages.currentpage().getparameters().put('id' , vehicleobj.id);
       ApexPages.StandardController objSc = new ApexPages.StandardController(vehicleobj);
      VehicleEditExtension cont = new VehicleEditExtension(objSc); 
      cont.getbrands();
      cont.getclasses();
      cont.getmodels();
      cont.getranges();
      cont.getmodeldesc();
      cont.getvgs();
      cont.getsteers(); 
      cont.saveveh();
      cont.saveAndNew();
      cont.Cancel();
      }
    }
    public static testMethod void testVehicle5()
    {
       Account personAcc = new Account(Dealer_Default_Flag__c=false,
                                Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '046234824',Home_Phone_2__c = '025645435',Work_Phone__c = '023482322',
                                Status__c='NoCustomer',Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',
                                City__c='Beijing',
                                Gender__c = 'Male',
                                Phone = '0801801110',
                                Area_code__c = '0101',
                                //MD__c = 'JP',
                                LastName = '刈乾冠寒刊勘',
                                FirstName = '刈乾冠寒刊勘',
                                Salutation = 'Unknown',      
                                Province__c = 'Shanghai',
                                ZipCode__c= '1002347',
                                Mobile__c = '023482832',
                                Mobile2__c = '035456232',
                                Primary_Email__c = 'Email1',
                                Primary_Fax__c = 'FAX2',
                                Primary_Phone__c ='Other2',
                                MD__c = 'JP',
                                Industry = 'Other',
                                RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId());
                                insert personAcc;
                                
        Car_Model__c objCarmodel = new Car_Model__c ();
        objCarmodel.Name='Daimler';
        objCarmodel.Brand__c='Smart';
        objCarmodel.Series__c='A-CLASS';
        objCarmodel.Model__c='A160';
        objCarmodel.Range__c='Test Range';
        objCarmodel.Mod_Pack__c='test MP';
        
        objCarmodel.Status__c = 'Own Sellable';
        insert objCarmodel;
        
      Vehicle__c vehicleobj = new Vehicle__c();
      vehicleobj.RecordTypeId=VehicleMBRecordtypeid;
      vehicleobj.Vehicle_Name__c ='Test1';
      vehicleobj.UsVIN__c ='abchgdtrsghtredfr';
      vehicleobj.Brand__c=objCarmodel.Brand__c;
      vehicleobj.Class__c=objCarmodel.Series__c;
      vehicleobj.Model__c=objCarmodel.name;
      vehicleobj.Range__c=objCarmodel.Range__c;
      vehicleobj.Modification_Package__c=objCarmodel.Mod_Pack__c;
      vehicleobj.FirstRegistrationDate__c = date.valueOf(date.today());
      vehicleobj.Purchase_Month__c ='02';
      vehicleobj.Purchase_Year__c = '2004';
      vehicleobj.RegistrationNo__c = '333';
      vehicleobj.Vehicle_Group__c='SUV';
      insert vehicleobj;
      apexpages.currentpage().getparameters().put('id' , vehicleobj.id);
       ApexPages.StandardController objSc = new ApexPages.StandardController(vehicleobj);
      VehicleEditExtension cont = new VehicleEditExtension(objSc); 
      cont.getbrands();
      cont.getclasses();
      cont.getmodels();
      cont.getranges();
      cont.getmodeldesc();
      cont.getvgs();
      cont.getsteers(); 
      cont.saveveh();
      cont.saveAndNew();
      cont.Cancel(); 
      
       Car_Model__c objCarmodel1 = new Car_Model__c ();
        objCarmodel1.Name='Daimler';
        objCarmodel1.Brand__c='Smart';
        objCarmodel1.Series__c='A-CLASS';
        objCarmodel1.Model__c='A160';
        objCarmodel1.Range__c='Test Range';
        objCarmodel1.Mod_Pack__c='test MP';
        
        objCarmodel1.Status__c = 'Competitor';
        insert objCarmodel1;
        
      Vehicle__c vehicleobj1 = new Vehicle__c();
      vehicleobj1.RecordTypeId=VehiclecompRecordtypeid ;
      vehicleobj1.Vehicle_Name__c ='Test1';
      vehicleobj1.UsVIN__c ='abchgdtrsghtredfr';
      vehicleobj1.Brand__c=objCarmodel1.Brand__c;
      vehicleobj1.Class__c=objCarmodel1.Series__c;
      vehicleobj1.Model__c=objCarmodel1.name;
      vehicleobj1.Range__c=objCarmodel1.Range__c;
      vehicleobj1.Modification_Package__c=objCarmodel1.Mod_Pack__c;
      vehicleobj1.FirstRegistrationDate__c = date.valueOf(date.today());
      vehicleobj1.Purchase_Month__c ='02';
      vehicleobj1.Purchase_Year__c = '2004';
      vehicleobj1.RegistrationNo__c = '333';
      vehicleobj1.Vehicle_Group__c='SUV';
      insert vehicleobj1;
      apexpages.currentpage().getparameters().put('id' , vehicleobj1.id);
       ApexPages.StandardController objSc1 = new ApexPages.StandardController(vehicleobj1);
      VehicleEditExtension cont1 = new VehicleEditExtension(objSc1); 
      cont1.getcompbrands();
      cont1.getcompmodels();
      cont1.saveveh();
      cont1.saveAndNew();
       cont1.getaddtype();
       cont1.getclasstype();
    }
}