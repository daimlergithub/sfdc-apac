@isTest
public class Batch_AutoSegmentationTest  {

      public static Id camIdExec= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Campaign Execution').getRecordTypeId();
      public static Id camIdPlan= Schema.SObjectType.Retail_Campaign__c.getRecordTypeInfosByName().get('Planning & Design Campaign').getRecordTypeId();
      public static Id personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
       //public static Retail_Campaign__c  rcobj1;
    
   static testmethod void batchAugment()
   {
   
   
      //String mainQuery = ;
     Test.startTest(); 
    Account accobj = new Account();
    accobj.FirstName = '刊勘';
    accobj.lastName = '冠寒';
    accobj.Email__c = 'Test@test.com';
    accobj.RecordTypeId = personAccRecordTypeId;
    //accobj.Name = 'testaccount';
    accobj.Phone = '012310086';
    accobj.MBK_Data_Source__c='Email';
    accobj.Mobile__c = '00000009642';
    
    insert accobj;
    Vehicle__c vehicles = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222',Brand__c ='Mercedes-Benz',FirstRegistrationDate__c = date.today() , Purchase_Month__c ='02', Model__c = 'R350L 4MATIC', Class__c = 'A-Class', Purchase_Year__c = '2004',RegistrationNo__c = '12345');
                        insert  vehicles;                      
   Vehicle_Relationship__c VR= new Vehicle_Relationship__c();
          
            VR.Contact__c = accobj.id;
            VR.Car_Relation__c = 'Aftersales Contact Target 1';
            VR.Vehicle_ID__c = vehicles.id;
            //VR.Owner_Dealer__c = accList.get(1).id;
            VR.New_Used__c= 'New';
            VR.End_Date__c= null;
            insert VR;
    Segmentation_Criteria__c scb = New Segmentation_Criteria__c();
   scb.Name = 'sample';
    scb.Criteria__c = 'Select Contact__c,Vehicle_ID__c,Car_Relation__c,End_Date__c,Vehicle_ID__r.FirstRegistrationDate__c,Vehicle_ID__r.Class__c,Vehicle_ID__r.Car_Model__r.Model_Name__c,Vehicle_ID__r.Model_Description__c,New_Used__c From Vehicle_Relationship__c where  End_Date__c= null LIMIT 2000' ;
   insert scb ;
   
   
   Segmentation_Criteria__c scb1 = New Segmentation_Criteria__c();
   scb1.Name = 'sample123';
   scb1.Criteria__c = 'Select id,Name From Account';
  // insert scb1 ;
   
   Retail_Campaign__c rcobj1=new Retail_Campaign__c();
    rcobj1.Name='Test Campaign1';
    rcobj1.Child_Campaign_Status__c='Segmentation';
    rcobj1.Status__c='Draft';
    rcobj1.Execution_Start_Date__c=system.today()+1;
    rcobj1.Segmentation_Date__c=system.today();
    rcobj1.Segmentation_Base__c='vehicle';
    rcobj1.Execution_Type__c='eMail';
    rcobj1.RecordTypeId=camIdExec;
    rcobj1.Auto_Segmentation__c = true;
    rcobj1.Segmentation_Criteria__c = scb.id;
    rcobj1.IsAutoSegmentationExecuted__c = false;
    
    
    insert rcobj1;
    
   Retail_Campaign__c rcobj2=new Retail_Campaign__c();
    rcobj2.Name='Test Campaign123';
    rcobj2.Child_Campaign_Status__c='Segmentation';
    rcobj2.Status__c='Draft';
    rcobj2.Execution_Start_Date__c=system.today()+1;
    rcobj2.Segmentation_Date__c=system.today();
    rcobj2.Execution_Type__c='eMail';
    rcobj2.Segmentation_Base__c='customer';
    rcobj2.RecordTypeId=camIdExec;
    rcobj2.Auto_Segmentation__c = true;
    rcobj2.Segmentation_Criteria__c = scb1.id;
    rcobj2.IsAutoSegmentationExecuted__c = false;
    
  //  insert rcobj2;  
    
    
    Batch_AutoSegmentation batchSch = New Batch_AutoSegmentation();
           
       
        Database.executeBatch(batchSch);
    

         Test.stopTest();
         

}



}