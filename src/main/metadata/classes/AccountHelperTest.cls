@isTest
Public class AccountHelperTest {
Private static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();     // Person Account.
Private static String DealerRecordtypeid= Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
Private static  Account customer1;
Private static Account customer2;
Private static Account customer3;
Private static Account dealer;
Private static Lead__c le1;

public static void preparedTestData()
{
 customer1 = new Account(Dealer_Default_Flag__c=false,
                                    Dealer_DMS_SR_Code__c='',
                                    Status__c='NoCustomer',
                                    City__c='Beijing',
                                    Gender__c = 'Male',
                                    Phone = '80801010',
                                    Area_code__c = '010',
                                    LastName = 'galaxy1',
                                    Province__c = 'Shanghai',
                                    ZipCode__c='000000',
                                    Allow_Data_Sharing__c='no',
                                    Preferred_Language__c = 'English',
                                    Dealer_Lead_System__c = 'Salesforce',
                                    RecordTypeId=accPerson_RecordTypeId); 
                           insert customer1;         
                           
                                    customer2 = new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_SR_Code__c='',
                                    Status__c='xCustomer',
                                    City__c='Beijing',
                                    Phone = '80801010',
                                    Area_code__c = '010',
                                    LastName = 'galaxy2',
                                    ZipCode__c='000000',
                                    RecordTypeId=accPerson_RecordTypeId);
                                     insert customer2;
                                     
                                    customer3 = new Account(
                                    Status__c='Unknown',
                                    City__c='Beijing',
                                    Phone = '80801010',
                                    Area_code__c = '010',
                                    LastName = 'galaxy2',
                                    ZipCode__c='000000',
                                    RecordTypeId=accPerson_RecordTypeId);   
                                   insert customer3;
                                   
                                   dealer = new Account();
                                   dealer.RecordTypeId =DealerRecordtypeid;
                                   dealer.Phone = '58392243';
                                   dealer.Name = 'testdealer';
                                   insert dealer;

        le1 = new Lead__c();
        //le1.Need_Assign_To_Dealer__c = 'Need';
        le1.Assigned_Dealer__c = dealer.id;
        le1.Lead_Type__c = 'New Car';
        le1.Relation_With_The_Leads__c = 'I owner';
        le1.Purchase_Time__c = '0 - 3 months';
        le1.Interested_Vehicle_Brand__c = 'MB';
        le1.Purchase_Time__c = '0 - 3 months';
        le1.Contact__c = customer1.id;
        insert le1;
        customer1.City__c = 'Shanghai';
        customer1.Dealer_Default_Flag__c = true;
        customer1.Allow_Data_Sharing__c = 'yes';
        update customer1;
        
           customer1.Status__c = 'Customer';
            update customer1;
}
 
  static testMethod void TestupdateLeads() {        
        User user1 = UtilTestData.createUser('IB CSR','CAC Data Manager');   
        system.runAs(user1){
          Test.startTest();
          preparedTestData();
          Test.stopTest();
          system.assertEquals(le1.Assigned_Dealer__c,dealer.id);
        }        
    } 
}