@istest
public class cSendVehicleInformationtoSPOJPTest
{

    //public static List<Account> accList;
    public static Account accObj;
    public static Account accObj1;
    public static Account accObj2;
    public static Account accObj3;
    public static Vehicle__c vehicleObj;
    public static Vehicle_Relationship__c vehicleRelationshipObj;
    public static Vehicle_Relationship__c vehRel1  ;
    public static Contact contactObj;
    

    public static testMethod void testMethod1(){
    
    
    
    createData();
    
   
    ApexPages.currentPage().getParameters().put('recordType','company');
    ApexPages.StandardController objSc = new ApexPages.StandardController(accObj);
   cSendVehicleInformationtoSPOJP csvi = New cSendVehicleInformationtoSPOJP(objSc );
   csvi.SelectedType = '2';
    




     }
     public static testMethod void testMethod2(){
    
    
    
    createData();
    
   
    ApexPages.currentPage().getParameters().put('recordType','Person Account');
    ApexPages.StandardController objSc = new ApexPages.StandardController(accObj2);
   cSendVehicleInformationtoSPOJP csvi = New cSendVehicleInformationtoSPOJP(objSc );
   csvi.SelectedType = '1';
   csvi.recordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
   Test.startTest();
   
   csvi.checkSelectedValue();
  
   
   Test.stopTest();
    



     }
     public static testMethod void testMethod3(){
    
    
    
    createData();
    
   
    //ApexPages.currentPage().getParameters().put('recordType','Person Account');
    ApexPages.StandardController objSc = new ApexPages.StandardController(vehicleObj );
   cSendVehicleInformationtoSPOJP csvi = New cSendVehicleInformationtoSPOJP(objSc );
   Test.startTest();
   csvi.recordTypeId1 =Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
   csvi.SelectedType = '1';
   csvi.RecordSize = 2;
   csvi.Param1 = accObj3.Id;
   csvi.cancel();
   csvi.getSelected();
 
     Test.stopTest();


     }
     public static testMethod void testMethod4(){
    
    
    
    createData();
    
   
    //ApexPages.currentPage().getParameters().put('recordType','Person Account');
    Test.startTest();
    ApexPages.StandardController objSc = new ApexPages.StandardController(accObj3 );
    //Pagereference retPageRef    = new Pagereference('/apex/SendVehicletoSPOConfirmationJP?id='+accObj3.Id);
    //cSendVehicleInformationtoSPOJP csvi = New cSendVehicleInformationtoSPOJP(objSc );
    //csvi.Param1 = accObj3.Id;
       //Test.startTest();
       PageReference PageRef = page.SendVehicleInformationtoSPOJP;
      // retPageRef.getparameters().put(csvi.Param1 ,accObj3.Id);
       //Test.stopTest();
        //Test.SetCurrentPage(retPageRef);
        
        Test.setCurrentPage(pageRef);
   pageRef.getParameters().put('id',accObj3.id);
   ApexPages.StandardController sc = new ApexPages.standardController(accObj3 );
   cSendVehicleInformationtoSPOJP csvi = New cSendVehicleInformationtoSPOJP(objSc );
   System.assertNotEquals(null,csvi.Navigate());
   Test.stopTest();
   }
    public static testMethod void testMethod5(){
    
    
    
    createData();
    
   
    //ApexPages.currentPage().getParameters().put('recordType','Person Account');
    Test.startTest();
    ApexPages.StandardController objSc = new ApexPages.StandardController(accObj );
    //Pagereference retPageRef    = new Pagereference('/apex/SendVehicletoSPOConfirmationJP?id='+accObj3.Id);
    //cSendVehicleInformationtoSPOJP csvi = New cSendVehicleInformationtoSPOJP(objSc );
    //csvi.Param1 = accObj3.Id;
       //Test.startTest();
       PageReference PageRef = page.SendVehicleInformationtoSPOJP;
      // retPageRef.getparameters().put(csvi.Param1 ,accObj3.Id);
       //Test.stopTest();
        //Test.SetCurrentPage(retPageRef);
        
        Test.setCurrentPage(pageRef);
   pageRef.getParameters().put('id',accObj.id);
   ApexPages.StandardController sc = new ApexPages.standardController(accObj );
   cSendVehicleInformationtoSPOJP csvi = New cSendVehicleInformationtoSPOJP(objSc );
   System.assertNotEquals(null,csvi.Navigate());
   Test.stopTest();
   }
    
    
    public static void createData(){
        
        Id recordTypeAccCompanyObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
        Id recordTypeAccpersonObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        accObj = new Account(RecordTypeId = recordTypeAccCompanyObjId,Name = 'Mercedez',Dealer_DMS_CRM_Code__c ='569833');
       
        insert accObj; 
        
        accObj1 = new Account(RecordTypeId = recordTypeAccCompanyObjId,Name = 'Mercedez',Dealer_DMS_CRM_Code__c = '569833');
       
        insert accObj1;
        
        accObj2 = new Account(RecordTypeId = recordTypeAccpersonObjId,LastName  = 'Dasepalle');
       
        insert accObj2;
        accObj3 = new Account(RecordTypeId = recordTypeAccpersonObjId,LastName = 'Mercedez',Dealer_DMS_CRM_Code__c = '25413698');
        
        insert accObj3 ;
        Id recordTypeVehicleObjId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
        vehicleObj = new Vehicle__c(RecordTypeId = recordTypeVehicleObjId,Brand__c = 'Mercedes-Benz',Class__c ='B-Class',Model__c ='Model1',FirstRegistrationDate__c=date.valueOf('2012-10-03'),Purchase_Month__c='02',Purchase_Year__c ='2011',RegistrationNo__c ='23232323', UsVIN__c ='54545454545454545',EuroVIN__c ='545454545454545454',CurrentMileage__c=5000,NextMileage__c=6000);
        insert vehicleObj;
        Id recordTypeVehicleRObjId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();
        
        List<Vehicle_Relationship__c> vehicleRelationshiplst = new List<Vehicle_Relationship__c>();
        vehicleRelationshipObj = new Vehicle_Relationship__c(Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Purchase_Date__c=system.today(),Owner_Dealer__c = accObj.Id,RecordTypeId = recordTypeVehicleRObjId);
        vehicleRelationshiplst.add(vehicleRelationshipObj);
        vehicleRelationshipObj = new Vehicle_Relationship__c(Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Purchase_Date__c=system.today(),Owner_Dealer__c = accObj.Id,RecordTypeId = recordTypeVehicleRObjId);
        vehicleRelationshiplst.add(vehicleRelationshipObj);
        vehicleRelationshipObj = new Vehicle_Relationship__c(Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Purchase_Date__c=system.today(),Owner_Dealer__c = accObj3.Id,RecordTypeId = recordTypeVehicleRObjId);
        vehicleRelationshiplst.add(vehicleRelationshipObj);
        vehicleRelationshipObj = new Vehicle_Relationship__c(Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Purchase_Date__c=system.today(),Owner_Dealer__c = accObj3.Id,RecordTypeId = recordTypeVehicleRObjId);
        vehicleRelationshiplst.add(vehicleRelationshipObj);
        insert vehicleRelationshiplst;
         vehRel1 = new Vehicle_Relationship__c(Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Contact__c =accObj.Id, Purchase_Date__c=system.today(),Owner_Dealer__c = accObj.Id,RecordTypeId = recordTypeVehicleRObjId);
        insert vehRel1  ;
         contactObj = new Contact(FirstName='Test',LastName='User',AccountId =accObj.Id,Dealer_Complaint_Gate_Keeper__c =true);
}
}