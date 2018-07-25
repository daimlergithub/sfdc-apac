@isTest
public class VrRecoveryTest
{
    static testmethod void createvrs()
    {
    Test.startTest();
    
    Account  Per= new Account();
        Per.RecordtypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Per.LastName='イゾ';
        Per.Status__c='Active';
        Per.Province__c='Province1';
        Per.City__c='Test';
        Per.ZipCode__c = '1004235';
        Per.Email__c='test@mbj.com';
        Per.Mobile__c ='0435488899';
        Per.Phone = '08022420181';
        Per.Customer_Lifecycle_Phase__c = 'Care';
        
        insert Per;
          
     
    Vehicle__c vehicleObj = new Vehicle__c(RecordTypeId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId(),
                                Brand__c = 'Maybach',
                                UsVIN__c ='12369854789632147',
                                EuroVIN__c ='1235478',CurrentMileage__c=5000,NextMileage__c=6000);
    insert vehicleObj;
    
    Vehicle_Relationship__c vr = new Vehicle_Relationship__c(RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship').getRecordTypeId(),
                                 Car_Relation__c ='Purchaser',
                                 Owner_Relation__c = 'Others',
                                 Vehicle_ID__c = vehicleObj.Id,
                                 Contact__c =Per.Id,
                                 MD__c = 'JP');
     insert vr;
     //List<Vehicle_Relationship__c> Vrlist = new List<Vehicle_Relationship__c>();
     //Vrlist.add(vr);
     
     delete vr;
        
        
        
        VrRecovery VrRecoveryobj = new VrRecovery();
        Database.executebatch(VrRecoveryobj);
        
        Test.StopTest();
        
    }

}
