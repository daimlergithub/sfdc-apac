@isTest
Public class ChangeContactTargetTest{
Private static String externalLinkType = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Individual Customer External Link').getRecordTypeId();
     static testMethod void myUnitTest() {
     Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();     // Person Account.
     ID VRRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();    //VehicleRelationship
     ID AccountLinkRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Vehicle External Link').getRecordTypeId();    //Account_Link__c
       Id dealerType =Schema.SObjectType.Account.getRecordTypeInfosByName().get(UtilTestData.ACCOUNT_RT_DEALER).getRecordTypeId();
         ID C2CRecordTypeId = Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();    //Account_Link__c
                                            
     
    
     
     Account account1 = new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_SR_Code__c='Test_SR_Code1',
                                    //Status__c='Unknown',
                                    City__c='Beijing',
                                    Phone = '080801010',
                                    Area_Code__c = '010',
                                    LastName = 'Beijing XING Limited',                                    
                                    RecordTypeId=accPerson_RecordTypeId);

     Account account2 = new Account(Dealer_Default_Flag__c=true,
                                   Dealer_DMS_SR_Code__c='Test_SR_Code2',
                                    //Status__c='Other',
                                    City__c='Beijing',
                                    Phone = '080801011',
                                    Area_Code__c = '010',            
                                    Name = 'Test',                                  
                                    RecordTypeId=accPerson_RecordTypeId);
    
     Account  dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType, Name = 'test dealer');
        insert dealer;
   
   
    // CR-000119
     Vehicle_Relationship__c VR1 = new Vehicle_Relationship__c(Recall__c = FALSE, Car_Relation__c = 'Purchaser', Owner_Relation__c='Same',
                                                Contact__c=account1.id,RecordTypeId = VRRecordTypeId);
                                                
     
    
    Vehicle__c vehicles = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222');
                                                
                                                insert vehicles;
                                                
    Account_Link__c accln = new Account_Link__c(Name='Test',Vehicle__c=vehicles.id,RecordTypeId =AccountLinkRecordTypeId,fromRole__c =dealer.id);
    insert accln;
         
         Account_Link__c accln1 = new Account_Link__c(Name='Test',Vehicle__c=vehicles.id,RecordTypeId =C2CRecordTypeId,fromRole__c =dealer.id);
    insert accln1;
         
         Account_Link__c accln2 = new Account_Link__c(Name='Test',Vehicle__c=vehicles.id,RecordTypeId =C2CRecordTypeId,toRole__c=account2.id,fromRole__c =dealer.id);
    insert accln2;
         
         Account_Link__c accln3 = new Account_Link__c(Name='Test',Vehicle__c=vehicles.id,RecordTypeId =C2CRecordTypeId,fromRole__c = account2.id,toRole__c=dealer.id);
    insert accln3;
                                                
   Vehicle_Relationship__c VR = new Vehicle_Relationship__c(Recall__c = FALSE, Car_Relation__c = 'Purchaser',
                                                Owner_Relation__c='Same',Vehicle_ID__c = vehicles.id,
                                                Contact__c=account1.id, RecordTypeId = VRRecordTypeId);
       insert VR; 
       
        Vehicle_Relationship__c VR3 = new Vehicle_Relationship__c(Recall__c = FALSE, Car_Relation__c = 'Sales Contact Target',
                                                Owner_Relation__c='Same',Vehicle_ID__c = vehicles.id,
                                                Contact__c=account1.id, RecordTypeId = VRRecordTypeId);
       insert VR3;
       
        Vehicle_Relationship__c VR4 = new Vehicle_Relationship__c(Recall__c = FALSE, Car_Relation__c = 'Aftersales Contact Target 1',
                                                Owner_Relation__c='Same',Vehicle_ID__c = vehicles.id,
                                                Contact__c=account1.id, RecordTypeId = VRRecordTypeId);
       insert VR4;       
       
       
       
       
                                        
    Account_Link__c externalLink = new Account_Link__c(RecordTypeId = externalLinkType, Name = 'externalLink', Vehicle__c = vehicles.Id);
   // ChangeContactTarget.vehicleId=vehicles.id;
  // ChangeContactTarget ext = new ChangeContactTarget(new ApexPages.StandardController(vehicles));
    apexpages.currentpage().getparameters().put('id' , VR.id);
     apexpages.currentpage().getparameters().put('id' , VR3.id);
      apexpages.currentpage().getparameters().put('id' , VR4.id);
         apexpages.currentpage().getparameters().put('id' , vehicles.id);
         //apexpages.currentpage().getparameters().put('id' , accln.id);
  //ApexPages.currentPage().getParameters().put('id',vehicles);
  ChangeContactTarget ext = new ChangeContactTarget(new ApexPages.StandardController(vehicles));
  
    //ChangeContactTarget cct = new ChangeContactTarget();
         ext.updateit();
    //pageReference pager = page.ChangeContactTarget;
    //    Test.setCurrentPage(pager);
    
    } 
                                         
}