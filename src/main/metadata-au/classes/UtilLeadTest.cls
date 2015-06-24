@isTest
public class UtilLeadTest {
    
	private static Account dealer;
    private static Account account;
    private static Account personaccount1;
	private static Lead__c lead;
     private static Lead__c lead1;
    
	private static String dealerRecordTypeId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    private static final String leadFinanceRT = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Sales Leads Soft Deleted').getRecordTypeId();
    
    private static String RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship').getRecordTypeId();
    private static String vehicleRecordTypeId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
   
    private static TestDataUtil testData = TestDataUtil.getInstance();

     
     public static testmethod void testUpdateLeadForDataSharing() {
         //prepare test data
       
        Profile profile = [select Id from Profile where Name = 'CAC IB CSR'];
        User user3 = new User(ProfileId = profile.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichao',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US');
        insert user3;

       
       
           system.runAs( user3) {
          
            //start test
            getAccount(user3);
                dealer = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58392243', Name = 'testdealer',Active__c='yes',Dealer_Allocation__c='MBAuP',Activation_Date__c=system.today());
                insert dealer;
                
            
             lead1=createLead(user3);
              
               
           list<Lead__c> listLead = new list<Lead__c>();
               listLead.add(lead1);
               UtilLead.updateLeadForDataSharing(listLead);
               UtilLead.updateRelatedVehicleRelFields(listLead);
           }
         
          Vehicle_Relationship__c vr=createVehicleRelationship();
          list<Lead__c> queryList = new list<Lead__c>();
               queryList.add(lead1);
                lead=[select Car_License__c,UsVIN__c,EuroVIN__c,Selling_Dealer__c,Car_Model__c,Vehicle_Purchase_Date__c from Lead__c where id in : queryList];
         
         //verify
         system.assertEquals(lead.Car_License__c, vr.Registration_Number__c);
         system.assertEquals(lead.UsVIN__c, vr.Vehicle_ID__r.UsVIN__c);
         system.assertEquals(lead.EuroVIN__c, vr.Vehicle_ID__r.EuroVIN__c);
         system.assertEquals(lead.Selling_Dealer__c, vr.Selling_Dealer__r.Name);
    }
    public static testmethod void testBeforeInsertUpdateEvents() {
         //prepare test data
        
        Profile profile = [select Id from Profile where Name = 'CAC IB CSR'];
        User user3 = new User(ProfileId = profile.Id, isActive = true, Username = 'lai1@nttdata.com', LastName = 'sichao',
                                  Email = 'sichao.lai@nttdata.com', Alias = 'laisc', CommunityNickname = 'barney1',
                                  TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
                                  EmailEncodingKey = 'ISO-8859-1', LanguageLocaleKey = 'en_US');
        insert user3;

       
       
           system.runAs( user3) {
          //start test
            
            getAccount(user3);
                dealer = new Account(RecordTypeId = DealerRecordtypeid, Phone = '58392243', Name = 'testdealer',Active__c='yes',Dealer_Allocation__c='MBAuP',Activation_Date__c=system.today());
                insert dealer;
                           
               lead1=createLead(user3);
              
               system.assertNotEquals(lead1.VehicleRel_No__c,NULL);
               
              
               lead1.CAC_Lead_Status__c='Lost(CAC)';
               update lead1;
               list<Lead__c> queryList = new list<Lead__c>();
               queryList.add(lead1);
                lead=[select CAC_Lead_Status__c,Assigned_Date_Time__c,Dealer_Audit__c,VehicleRel_No__c from Lead__c where id in : queryList];
        
        map<id,Lead__c> oldMap2 = new map<id,Lead__c>();
        oldMap2.put(lead.id, lead);
               
           list<Lead__c> listLead = new list<Lead__c>();
               listLead.add(lead1);
               
           map<id,Lead__c> newMap = new  map<id,Lead__c> ();
               newMap.put(lead1.id, lead1);
               UtilLead.beforeInsert_updateEvents(listLead,newMap,true,false);
                //verify
              
               UtilLead.beforeInsert_updateEvents(listLead,oldMap2,false,true);
              
           }
        //verify
       
        
    }
    static void getAccount(User usr){
        //User usr = UtilTestData.createUser('IB CSR','CAC IB CSR');
         account = new Account();
         account.Name = 'account name';
         account.Phone = '10086';
         account.Area_Code__c = '010';
         account.Dealer_Allocation__c='MBAuP';
         account.Activation_Date__c=system.today();
         account.Fax = '10086';
         account.BillingCity = 'San Francisco';
         account.BillingCountry = 'USA';
         account.BillingPostalCode = '94105';
         account.BillingState = 'CA';
        account.Email__c='test@mbau.com';
                    account.Email2__c = 'testemail2@test.com';
                    account.Home_Phone_2__c = '98765413';  
         account.BillingStreet = 'SnapBi 55 New Montgomery Street Suite 525';
         account.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
         insert account;
        
        personaccount1 = testData.standardPersonAccount;
        insert personaccount1;
         
        
      
    }
     static Lead__c createLead(User usr){
         Vehicle_Relationship__c vr=createVehicleRelationship();
        lead = new Lead__c();
        lead.Contact__c = personaccount1.Id;
        lead.recordTypeId = leadFinanceRT;
        lead.Lead_Type__c = 'New Car';
        lead.CAC_Lead_Status__c = 'New';
        lead.Lead_Source__c = 'Campaign';
        lead.Nature_of_Request__c='Key 2 Key';
        lead.Business_Unit__c= 'Alliance';
        lead.Sub_BusinessUnit__c='Finance & Insurance';
        lead.X24H_Untouched__c=false;
        lead.X72H_Untouched__c=false;
         lead.VehicleRel_No__c=vr.id;
        insert lead;
         //lead.CAC_Lead_Status__c = 'Qualified';
        
        
        return lead;
        
    }
     public static Vehicle_Relationship__c  createVehicleRelationship() {
        
        
        
        //create test data
       Car_Model__c car= new Car_Model__c();
        car.Name='A-Class';
        car.Vehicle_Group__c='PC';
        insert car;
        // Create Dealer
         dealer = (Account)UtilTestData.createSobject(new Account(), 
            UtilTestData.ACCOUNT_RT_DEALER);
        
      
        
        // Create Vehicle
        Vehicle__c vehicle = new Vehicle__c();
        vehicle.RecordTypeId=vehicleRecordTypeId;
       vehicle.Car_Model__c=car.Id;
        vehicle.Class__c='A-Class';
       
        vehicle=(Vehicle__c)UtilTestData.createSobject(vehicle, null);
        
        // Create Vehicle Relationship
        Vehicle_Relationship__c relationship = new Vehicle_Relationship__c();
        relationship.RecordTypeId=RecordTypeId;
        relationship.Vehicle_ID__c = vehicle.Id;
        relationship.Contact__c = personaccount1.Id;
        relationship.Selling_Dealer__c = dealer.Id;
         relationship = (Vehicle_Relationship__c)UtilTestData.createSobject(relationship, null);
        return relationship;
            }
}