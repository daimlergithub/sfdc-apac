@istest
public class cSendVehicletoSPOConfirmationJPTest{
public static List<Account> accList;
    public static Account accObj;
    public static Account accObj1;
    public static Account accObj2;
    public static Account accObj3;
    public static Vehicle__c vehicleObj;
    public static Vehicle_Relationship__c vehicleRelationshipObj ;
   public static Vehicle_Relationship__c vehRel1  ;
    
    public static Contact contactObj;
    public static Contact contactObj1;
    public static List<Contact> contactlst;
    
    
    
    public static testmethod void testmethod1  ()
    
    
     {
        PageReference pageRef = Page.SendVehicletoSPOConfirmationJP;
        Test.setCurrentPage(pageRef);
       
       createData();
       Test.startTest();
       ApexPages.currentPage().getParameters().put('Id',vehicleRelationshipObj.Id);
       //ApexPages.StandardController sc = new ApexPages.standardController(vehicleRelationshipObj.Id );
       
       cSendVehicletoSPOConfirmationJP csvi = New cSendVehicletoSPOConfirmationJP ( );
       
       csvi.MarketDiscriminator = 'JP';
       csvi.CustomerId = '001p00000042AN0AAM';
       csvi.Organisationid = '00Dp00000000eeVEAQ';
       csvi.UserProfile = 'Dealer Community User' ;
       
      // csvi.sendtoSPO();
         
  
   
   Test.stopTest();
       
       
       
       
}

      
  
  
    public static testmethod void testmethod3  (){
         
         PageReference pageRef = Page.SendVehicletoSPOConfirmationJP;
        Test.setCurrentPage(pageRef);
       
       createData();
       
       
       ApexPages.currentPage().getParameters().put('Id',vehRel1.Id);
       cSendVehicletoSPOConfirmationJP csvi = New cSendVehicletoSPOConfirmationJP ( );
       
       csvi.MarketDiscriminator = 'JP';
       csvi.CustomerId = '001p00000042AN0AAM';
       csvi.Organisationid = '00Dp00000000eeVEAQ';
       csvi.UserProfile = 'Dealer Community User' ;
       csvi.Response = vehRel1.Id;
       
       
      // Test.setMock(WebServiceTestClass.class, new WebServiceMockImpl());
       
       // String output = csvi.sendtoSPO();
        
        
      // System.assertEquals('Mock response', output); 
       if(!test.isrunningtest()){
        
         //csvi.sendtoSPO( );
         
       
      
     
        
        //csvi.response = 'JP,00Dp00000000eeVEAQ,001p00000042AN0AAM,001p00000036R54AAE';
        //csvi.Response =vehicleRelationshipObj.Id ;
        csvi.sendtoSPO( );
      } 
         
         
  
   
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
        
        //List<Vehicle_Relationship__c> vehicleRelationshiplst = new List<Vehicle_Relationship__c>();
        vehicleRelationshipObj = new Vehicle_Relationship__c(Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Purchase_Date__c=system.today(),Owner_Dealer__c =accObj.Id,RecordTypeId = recordTypeVehicleRObjId,New_Used__c ='New');
       
        vehRel1 = new Vehicle_Relationship__c(Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Contact__c =accObj.Id, Purchase_Date__c=system.today(),Owner_Dealer__c = accObj.Id,RecordTypeId = recordTypeVehicleRObjId);
        insert vehRel1  ;
        
        insert vehicleRelationshipObj ;
        
        contactObj = new Contact(FirstName='Test',LastName='User',AccountId =accObj.Id,Dealer_Complaint_Gate_Keeper__c =true);
        

insert contactObj ;



}
}