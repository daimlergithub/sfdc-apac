@istest
public class AccountHelperTest
{
   public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
   public static String DealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId(); 
   public static Account personAcc;
    public static Account personAcc2;
    public static Account Dealer;
    public static Account Dealer2;
   public static Lead__c testLead;
    public static user usr;
    public static Profile userProfile = [select Id from Profile where Name = 'System Administrator' limit 1];
   public static Vehicle_Relationship__c vRel;
   public static Contact testContact; 
   public static Vehicle__c vehicles;
   public static ID VRRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();
   public static final String leadFinanceRT = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Vehicle Lead').getRecordTypeId(); 
   
   public static testmethod void test_updateLeads()
   {
       createTestData();
       test.startTest();
       Set<Id> contactIds = new set<id>();
       contactIds.add(personAcc.id);
       testLead.Assigned_to_Dealer_Directly__c = true;
       update testLead;
       AccountHelper.updateLeads(contactIds);
       
       test.stopTest();
       system.assertEquals(true, testLead.Assigned_to_Dealer_Directly__c); 
       
   }
    
    public static testmethod void test_AccountHelper()
   {
       createTestData();
       test.startTest();
       Set<String> companyIds = new Set<String>();
       Set<Id> dealerIds = new set<Id>();
       Set<String> dealerIds2 = new set<String>();
       dealerIds2.add(Dealer.id);
       dealerIds.add(Dealer.id);
       
       companyIds.add(personAcc.id);
       AccountHelper.deleteDealerLocators(dealerIds);
       AccountHelper.flagPrimaryContact(companyIds);
       AccountHelper.cancelPrimaryContact(dealerIds2, companyIds);
       personAcc.Partner_Surname__c = 'galaxy2';
       update personAcc;
       Account TestAcc = AccountHelper.updateDisplayName(personAcc);
       //system.assertNotEquals(TestAcc.Display_Name__c, 'Unknown First Name galaxy1');
       personAcc.Partner_Surname__c = 'galaxy1';
       update personAcc;
       
       personAcc.Salutation = 'Sir';
       personAcc.Partner_Title__c = 'Sir';
       update personAcc;
       
       Account TestAcc1 = AccountHelper.updateDisplayName(personAcc);
       
       test.stopTest();
       system.assertEquals('Sir and Sir First Name and null galaxy1', TestAcc1.Display_Name__c);
   }
    
    
    
    public static testmethod void test_getDealerCountInfo()
   {
       createTestData();
       test.startTest();
       List<String> dealerCodes =new List<String>();
       List<id> ids = new List<id>();
       ids.add(personAcc.id);
       String TestDealerCode = 'Test Dealer Code';
       dealerCodes.add(TestDealerCode);
       Dealer.Dealer_Default_Flag__c = true;
       Dealer.Dealer_DMS_SR_Code__c = TestDealerCode;
       update Dealer;
       Map<String, boolean> testMapDealer = AccountHelper.getDealerCountInfo(dealerCodes);
       Set<Id> cp016Map = AccountHelper.getVSCountInfo(ids);
       
        Set<Id> customerIds = new Set<Id>();
       customerIds.add(Dealer.id);
       Integer PcCount=1;Integer CvCount=2;Integer VanCount=3;
        Map<String, Map<String,Date>> exsisedRecord = new Map<String, Map<String,Date>>();
        Map<String,Date>  preRecordsVAN = AccountHelper.getExsitedInfos(customerIds,'VAN');
       exsisedRecord.put('VAN', preRecordsVAN);
       Map<Id, Map<String,Integer>> Vehiclecount=new Map<Id, Map<String,Integer>>();
       Map<Id, Map<String,Integer>> Vehicletenure=new  Map<Id, Map<String,Integer>>();
               Map<String,Integer> tempcount=new Map<String,Integer>();
               tempcount.put('PC',PcCount);
                tempcount.put('CV',CvCount);
                tempcount.put('Van',VanCount);
                Vehiclecount.put(Dealer.id,tempcount);
                Integer PcTenure=0;Integer CvTenure=0;Integer VanTenure=0;
                Map<String,Integer> counttenure = new Map<String,Integer>();  
                counttenure.put('PC',PcTenure);
                counttenure.put('CV',CvTenure);
                counttenure.put('Van',VanTenure);
                Vehicletenure.put(Dealer.id,counttenure);
       AccountHelper.updatePCCVField(Dealer,'VAN',exsisedRecord,true,Vehiclecount,Vehicletenure);
       
       test.stopTest();
       system.assertNotEquals(null,testMapDealer);
       system.assertNotEquals(null,cp016Map);
   }
    
    
   
    
    
    public static testmethod void test_trackUpdatHistoryForFsInfo()
   {
       createTestData();
       test.startTest();
       
       personAcc.FS_Opt_In_Email__c = true;
       personAcc2.FS_Opt_In_Email__c = false;
       personAcc.FS_Opt_In_SMS__c = true;
       personAcc2.FS_Opt_In_SMS__c = false;
       personAcc.Opt_In_Email__c = true;
       personAcc2.Opt_In_Email__c = false;
       personAcc.Opt_In_SMS__c  = true;
       personAcc.FS_Opt_In_SMS2__c=true;
       personAcc2.Opt_In_SMS__c  = false;
       personAcc.FS_Opt_In_Home_Phone__c=true;
       personAcc.FS_Opt_In_Home_Phone2__c=true;
        personAcc.FS_Opt_In_Work_Phone__c=true;
        personAcc.FS_Opt_In_Work_Phone2__c=true;
       personAcc.FS_Opt_In_Email2__c=true;
        personAcc.Opt_In_SMS2__c=true;
       personAcc.Opt_In_Home_Phone__c=true;
         personAcc.Opt_In_Home_Phone2__c=true;
         personAcc.Opt_In_Work_Phone__c=true;
        personAcc.Opt_In_Work_Phone2__c=true;
       personAcc.Opt_In_Email2__c=true;
       update personAcc2;
       update personAcc;
       
       list<Account> lstPACC =new list<Account>();
       lstPACC.add(personAcc);
       AccountHelper.trackUpdatHistoryForFsInfo(personAcc, personAcc2);
       AccountHelper.auAfter_Update_UpdatePc_Status_Values(lstPACC);
      
       test.stopTest();
       system.assertEquals(UserInfo.getName(), personAcc.SMS_Last_Modified_By__c);
       
   }
    
     public static testMethod void testupdatePCCVFieldUnknownVehicleGroup()
    {
        Map<String,Map<String,Date>> preRecords = new Map<String,Map<String,Date>>();
        preRecords.put('blabla', new Map<String, Date>());
               createTestData();
               Integer PcCount=1;Integer CvCount=2;Integer VanCount=3;        
               Map<Id, Map<String,Integer>> Vehiclecount=new Map<Id, Map<String,Integer>>();
               Map<Id, Map<String,Integer>> Vehicletenure=new  Map<Id, Map<String,Integer>>();
               Map<String,Integer> tempcount=new Map<String,Integer>();
               tempcount.put('PC',PcCount);
                tempcount.put('CV',CvCount);
                tempcount.put('Van',VanCount);
                Vehiclecount.put(Dealer.id,tempcount);
                Integer PcTenure=0;Integer CvTenure=0;Integer VanTenure=0;
                Map<String,Integer> counttenure = new Map<String,Integer>();  
                counttenure.put('PC',PcTenure);
                counttenure.put('CV',CvTenure);
                counttenure.put('Van',VanTenure);
                Vehicletenure.put(Dealer.id,counttenure);
      
       
        Test.startTest();
         Account ac=AccountHelper.updatePCCVField(Dealer,'blabla',preRecords,true,Vehiclecount,Vehicletenure);
        Test.stopTest();
        system.assertNotEquals(ac,NULL);
    }
    
    public static testMethod void testupdatePCCVField()
    {
        Map<String,Map<String,Date>> preRecords = new Map<String,Map<String,Date>>();
        preRecords.put('PC', new Map<String, Date>());
        createTestData();
              Integer PcCount=1;Integer CvCount=2;Integer VanCount=3;        
               Map<Id, Map<String,Integer>> Vehiclecount=new Map<Id, Map<String,Integer>>();
               Map<Id, Map<String,Integer>> Vehicletenure=new  Map<Id, Map<String,Integer>>();
               Map<String,Integer> tempcount=new Map<String,Integer>();
               tempcount.put('PC',PcCount);
                tempcount.put('CV',CvCount);
                tempcount.put('Van',VanCount);
                Vehiclecount.put(Dealer.id,tempcount);
                Integer PcTenure=0;Integer CvTenure=0;Integer VanTenure=0;
                Map<String,Integer> counttenure = new Map<String,Integer>();  
                counttenure.put('PC',PcTenure);
                counttenure.put('CV',CvTenure);
                counttenure.put('Van',VanTenure);
                Vehicletenure.put(Dealer.id,counttenure);
      
        Test.startTest();
        Account ac=AccountHelper.updatePCCVField(Dealer,'PC',preRecords,true,Vehiclecount,Vehicletenure);
        Test.stopTest();
         system.assertNotEquals(ac,NULL);
    }
    
    public static testMethod void testupdatePCCVFieldDifferentVehicleGroup()
    {
        Map<String,Map<String,Date>> preRecords = new Map<String,Map<String,Date>>();
        preRecords.put('bloob', new Map<String, Date>());
        createTestData();
        Integer PcCount=1;Integer CvCount=2;Integer VanCount=3;        
               Map<Id, Map<String,Integer>> Vehiclecount=new Map<Id, Map<String,Integer>>();
               Map<Id, Map<String,Integer>> Vehicletenure=new  Map<Id, Map<String,Integer>>();
               Map<String,Integer> tempcount=new Map<String,Integer>();
               tempcount.put('PC',PcCount);
                tempcount.put('CV',CvCount);
                tempcount.put('Van',VanCount);
                Vehiclecount.put(Dealer.id,tempcount);
                Integer PcTenure=0;Integer CvTenure=0;Integer VanTenure=0;
                Map<String,Integer> counttenure = new Map<String,Integer>();  
                counttenure.put('PC',PcTenure);
                counttenure.put('CV',CvTenure);
                counttenure.put('Van',VanTenure);
                Vehicletenure.put(Dealer.id,counttenure);
      
        Test.startTest();
        Account ac=AccountHelper.updatePCCVField(Dealer, 'blabla', preRecords, true,Vehiclecount,Vehicletenure);
        
        Test.stopTest();
         system.assertNotEquals(ac,NULL);
    }
    
    public static testMethod void testupdatePCCVFieldEmptyVehicleGroup()
    {
        Map<String,Map<String,Date>> preRecords = new Map<String,Map<String,Date>>();
        preRecords.put('blabla', new Map<String, Date>());
         createTestData();
        Integer PcCount=1;Integer CvCount=2;Integer VanCount=3;        
               Map<Id, Map<String,Integer>> Vehiclecount=new Map<Id, Map<String,Integer>>();
               Map<Id, Map<String,Integer>> Vehicletenure=new  Map<Id, Map<String,Integer>>();
               Map<String,Integer> tempcount=new Map<String,Integer>();
               tempcount.put('PC',PcCount);
                tempcount.put('CV',CvCount);
                tempcount.put('Van',VanCount);
                Vehiclecount.put(Dealer.id,tempcount);
                Integer PcTenure=0;Integer CvTenure=0;Integer VanTenure=0;
                Map<String,Integer> counttenure = new Map<String,Integer>();  
                counttenure.put('PC',PcTenure);
                counttenure.put('CV',CvTenure);
                counttenure.put('Van',VanTenure);
                Vehicletenure.put(Dealer.id,counttenure);
        Test.startTest();
        Account ac=AccountHelper.updatePCCVField(Dealer, '', preRecords, true,Vehiclecount,Vehicletenure);
        Test.stopTest();
        system.assertNotEquals(ac,NULL);
       
    }
    
    public static testMethod void testupdatePCCVFieldNullVehicleGroup()
    {
        Map<String,Map<String,Date>> preRecords = new Map<String,Map<String,Date>>();
        preRecords.put('blabla', new Map<String, Date>());
         createTestData();
        Integer PcCount=1;Integer CvCount=2;Integer VanCount=3;        
               Map<Id, Map<String,Integer>> Vehiclecount=new Map<Id, Map<String,Integer>>();
               Map<Id, Map<String,Integer>> Vehicletenure=new  Map<Id, Map<String,Integer>>();
               Map<String,Integer> tempcount=new Map<String,Integer>();
               tempcount.put('PC',PcCount);
                tempcount.put('CV',CvCount);
                tempcount.put('Van',VanCount);
                Vehiclecount.put(Dealer.id,tempcount);
                Integer PcTenure=0;Integer CvTenure=0;Integer VanTenure=0;
                Map<String,Integer> counttenure = new Map<String,Integer>();  
                counttenure.put('PC',PcTenure);
                counttenure.put('CV',CvTenure);
                counttenure.put('Van',VanTenure);
                Vehicletenure.put(Dealer.id,counttenure);
        Test.startTest();
        Account ac=AccountHelper.updatePCCVField(Dealer, null, preRecords, true,Vehiclecount,Vehicletenure);
        Test.stopTest();
        system.assertNotEquals(ac,NULL);
    }
    
    static void createTestData()
   {
       
       Dealer = new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_SR_Code__c='test code',
                                    Status__c='xCustomer',
                                    City__c='Beijing',
                                    Phone = '180801010',
                                    Name = 'test dealer1',       
                                    Area_code__c = '010',
                                    
                                    ZipCode__c='000000',
                                    RecordTypeId=DealerRecordtypeid);
       
       insert Dealer;
       
       Dealer2 = new Account(Dealer_Default_Flag__c=true,
                                    Dealer_DMS_SR_Code__c='test ',
                                    Status__c='xCustomer',
                                    City__c='Beijing',
                                    Phone = '80810100',
                                    Name = 'test dealer2',       
                                    Area_code__c = '010',
                                    Company__c = Dealer.id,
                                    ZipCode__c='00000',
                                    RecordTypeId=DealerRecordtypeid);
       insert Dealer2;
       
       personAcc = new Account(Dealer_Default_Flag__c=false,
                                    Dealer_DMS_SR_Code__c='test code 2',
                                    Status__c='NoCustomer',
                                    City__c='Beijing',
                                    Gender__c = 'Male',
                                    Phone = '801801010',
                                    Area_code__c = '0101',
                                    LastName = 'galaxy1',
                                    FirstName = 'First Name',
                                    Salutation = 'Unknown',      
                                    Province__c = 'Shanghai',
                                    ZipCode__c='0000001',
                                    Allow_Data_Sharing__c='no',
                                    Preferred_Language__c = 'English',
                                    Dealer_Lead_System__c = 'Salesforce',
                                    
                                    RecordTypeId=accPerson_RecordTypeId);
       
       insert personAcc;
       
       Address__c objAddress = new Address__c();
       objAddress.Customer__c=personAcc.id;
       objAddress.Address_Line_1__c='testAddres';
       objAddress.District__c='TestDist';
       objAddress.Country__c='Australia';
       objAddress.Province__c='ACT';
       
       insert objAddress;
       
       personAcc2 = new Account(Dealer_Default_Flag__c=false,
                                    Dealer_DMS_SR_Code__c='test code 1',
                                    Status__c='NoCustomer',
                                    City__c='Beijin',
                                    Gender__c = 'Male',
                                    Phone = '8080101',
                                    Area_code__c = '0100',
                                    LastName = 'galaxy1',
                                    FirstName = 'First Name',
                                    Salutation = 'Unknown',      
                                    Province__c = 'Shanghai',
                                    ZipCode__c='1000000',
                                    Allow_Data_Sharing__c='no',
                                    Preferred_Language__c = 'English',
                                    Dealer_Lead_System__c = 'Salesforce',
                                    
                                    RecordTypeId=accPerson_RecordTypeId);
       
       insert personAcc2;
       
       
        testLead = new Lead__c();
        //testLead.Need_Assign_To_Dealer__c = 'Need';
        testLead.Contact__c = personAcc.id;
        testLead.RecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Service/Parts Lead').getRecordTypeId();
        testLead.Lead_Type__c = 'New Car';
        testLead.Relation_With_The_Leads__c = 'I owner';
        testLead.Purchase_Time__c = '0 - 3 months';
        testLead.Interested_Vehicle_Brand__c = 'MB';
        testLead.Purchase_Time__c = '0 - 3 months';
        testLead.Assigned_Dealer__c = Dealer.id;
        insert testLead;
       
        vehicles = new Vehicle__c(Recall__c = FALSE,
                                                EuroVIN__c = '12345678901111111',
                                                UsVIN__c = '12345678902222222');
       insert vehicles;
       
        vRel = new Vehicle_Relationship__c(Recall__c = FALSE, Car_Relation__c = 'User', RecordTypeId = VRRecordTypeId);
        vRel.Contact__c = personAcc.id;
       vRel.Vehicle_ID__c = vehicles.id;
       vRel.Car_Relation__c='Owner';
        insert vRel;
       
       
       
       
         testContact = new Contact ( AccountId = Dealer.id,
                                         Dealer_Complaint_Gate_Keeper__c = true,      
                                         Inactive__c=false,
                                         Business_Unit__c='Alliance',
                                         Sub_BusinessUnit__c='Finance',
                                         FirstName = 'lai',
                                         LastName = 'sichao',
                                         Email = 'sichao.lai@nttdata.com',
                                         EOC_Recipient_Type__c = '60 Days Primary',
                                         Lead_Escalation_Recipient_Type__c='Immediate Notice',Dealer_Lead_Gate_Keeper__c=false);
          insert testContact;
       
       usr = new User(
            Username = System.now().millisecond() +math.random()+ '987654321test12345@test.com',
            FirstName = 'firstname',
            ProfileId = userProfile.Id,            
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = System.now().millisecond() + 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US'
        );
       //usr.ContactId = testContact.id;   //Community license not available.
        insert usr;
   }

}