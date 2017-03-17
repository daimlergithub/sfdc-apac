@isTest
public class TriggerLeadTriggerHandlerKRTest{
 private static Account personAcc;
 private static Vehicle__c vehicle;
 private static Lead__c leadobj;

 private static List<Lead__c> leadobjList = new List<Lead__c>();
 
 public static Id LeadRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads').getRecordTypeId();
 public static void prepareTestData(){
  Trigger__c TriggerLeadKR = new Trigger__c(Name='TriggerLead',Trigger_Name__c='TriggerLead',Trigger_Handler__c='TriggerLeadTriggerHandlerKR',update__c=True,insert__c=True,delete__c=True,after__c=True,before__c=True,enabled__c=True,Market__c='KR');
  insert TriggerLeadKR;
  
  // Prepare test data for Account
  personAcc = new Account(Dealer_Default_Flag__c=false,
                           Dealer_DMS_SR_Code__c='test code 2',Individual_Home_Phone__c = '000-0000-9642',Home_Phone_2__c = '000-0000-9642',Work_Phone__c = '000-0000-9642',
                           Email__c = 'testemail@test.com',Email2__c = 'testemail2@test.com',Email3__c = 'testemail3@test.com',City__c='Beijing',Gender__c = 'Male',Phone = '000-0000-9642',
                           Area_code__c = '0101',MD__c = 'KR',LastName = 'galaxy1',FirstName = 'First Name',Salutation = 'Unknown',Province__c = 'Shanghai',ZipCode__c= '1002347',
                           MBK_Data_Source__c='Email',Mobile__c = '000-0000-9642',Mobile2__c = '000-0000-9642',Primary_Email__c = 'Email1',Primary_Fax__c = 'FAX2',Primary_Phone__c ='Other2',
                           RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId()); 
    insert personAcc;    
    
   
    leadobj = new Lead__c(Contact__c = personAcc.Id,RecordTypeId = LeadRecordTypeId,CAC_Lead_Status__c='New',
              Lead_Type__c = 'Used Car',Lead_Sub_Type__c = 'Demo Car',Interested_Vehicle_Model__c = 'A 180 Hatchback');
        insert leadobj;
    leadobjList.add(leadobj); 
                                          
                                                                                      
 } 
 
 
 public static testMethod void testHandlerInsert(){
     try{
     prepareTestData();
     insert leadobjList;
     }catch(exception e){}
 }
 
 public static testMethod void testHandlerUpdate(){
     try{
     prepareTestData();
     
     update leadobjList;
     }catch(exception e){}
 } 
 
 
 

/* 
  public static testMethod void testHandlerDelete(){
     prepareTestData();
     insert leadobjList;
     
     Delete ;
     
 } */
 
}