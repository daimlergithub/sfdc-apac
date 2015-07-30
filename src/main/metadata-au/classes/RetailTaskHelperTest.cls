@isTest
public class RetailTaskHelperTest {
    private static Account dealer;
     private static Account objAccount;
     private static Account objAccount1;
    private static Vehicle__c vehicle;
     private static Vehicle__c vehicle1;
     private static Vehicle__c vehicle2;
    private static Retail_Task__c contract;
     private static Retail_Task__c contract1;
       private static Retail_Task__c contract2;
     private static Contact contact;
    
     private static String companyAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
     private static String  contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('DealerStaff').getRecordTypeId();
    private static String personAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    static {
        
         
         objAccount1= new Account();
	  objAccount1.RecordtypeId=personAccRecordTypeId;
	  objAccount1.LastName='Test Person 1st';
        objAccount1.FirstName = 'Test';
            objAccount1.Salutation='Brother';
	  objAccount1.Type='Personal';
	  objAccount1.Status__c='Active';
	  objAccount1.Province__c='Province1';
	  objAccount1.City__c='Test';
	  objAccount1.Email__c='test@mbau.com';
	  objAccount1.Mobile__c ='8884545243';
	  insert objAccount1;
        
        
         objAccount= new Account();
	  objAccount.RecordtypeId=companyAccRecordTypeId;
	  objAccount.Name='Test Person 1st';        
	  objAccount.Type='Personal';
	  objAccount.Status__c='Active';
	  objAccount.Province__c='Province1';
	  objAccount.City__c='Test';
	  objAccount.Email__c='test@mbau.com';
	  objAccount.Mobile__c ='8884545243';
	  insert objAccount;
        
        RecordType dealerType = [select Id from RecordType where SObjectType = 'Account' and DeveloperName = 'Dealer' limit 1];
        
       
        dealer =  new Account(Dealer_DMS_CRM_Code__c = 'DealerCode', RecordTypeId = dealerType.Id, Name = 'test dealer');
        insert dealer;
        
          contact = new Contact(RecordTypeId=contactRecordTypeId,FirstName = 'Test', Lastname = 'Amit',Salutation='Brother',Email='test@test2.com');
        contact.Account=dealer;
        insert contact;

        //Contact dealerContact = new Contact(FirstName = 'Test', Lastname = 'Amit', AccountId = objAccount.Id, Email = 'test@test.com');
       // insert dealerContact;

        vehicle = new Vehicle__c(Vehicle_Group__c='CV');
        insert vehicle;
        vehicle1 = new Vehicle__c(Vehicle_Group__c='PC');
        insert vehicle1;
         vehicle2 = new Vehicle__c(Vehicle_Group__c='Van');
        insert vehicle2;
       
    }
    
    private static void createRetailTask(){
        RecordType contractType = [select Id from RecordType where SObjectType = 'Retail_Task__c' and DeveloperName = 'contract' limit 1];
         contract = new Retail_Task__c(RecordTypeId = contractType.Id, Related_Dealer__c = dealer.Id, Related_Vehicle__c = vehicle1.Id,Account__c=objAccount.id);
          contract1 = new Retail_Task__c(RecordTypeId = contractType.Id, Related_Dealer__c = dealer.Id, Related_Vehicle__c = vehicle.Id,Account__c=objAccount.id);
         contract2 = new Retail_Task__c(RecordTypeId = contractType.Id, Related_Dealer__c = dealer.Id, Related_Vehicle__c = vehicle2.Id,Account__c=objAccount.id);
        
        
    }
    
    private static testmethod void testAuAfter_Insert_Update_Events(){
        createRetailTask();
        insert contract;
        
        contract.Related_Vehicle__c=vehicle1.Id;
        contract.Account__c=objAccount1.id;
        contract.Signer__c=dealer.id;
        contract.X150_Days_Before_EOC__c=true;
        contract.StartDate__c=system.today();
       contract.EndDate__c=system.today()+1;
        //contract.Fleet__c=true;
        
        update contract;
        system.assertEquals(contract.Fleet__c, false);
        
    }
    
    private static testmethod void testAuAfter_Insert_Update_Events1(){
        createRetailTask();
        insert contract1;
        
        contract1.Related_Vehicle__c=vehicle.Id;
        contract1.Account__c=objAccount.id;
        contract1.Signer__c=dealer.id;
        //contract.X150_Days_Before_EOC__c=true;
        contract1.StartDate__c=system.today();
       contract1.EndDate__c=system.today()+1;
        contract1.Fleet__c=false;
        
        update contract1;
          system.assertEquals(contract.Fleet__c, false);
        
    }
    private static testmethod void testAuAfter_Insert_Update_Events2(){
        createRetailTask();
        insert contract2;
        
        contract2.Related_Vehicle__c=vehicle2.Id;
        contract2.Account__c=objAccount.id;
        contract2.Signer__c=dealer.id;
        //contract.X150_Days_Before_EOC__c=true;
        contract2.StartDate__c=system.today();
       contract2.EndDate__c=system.today()+1;
        contract2.Fleet__c=false;
        
        update contract2;
          system.assertEquals(contract.Fleet__c, false);
        
    }
   


}