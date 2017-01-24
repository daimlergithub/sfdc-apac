/*
    Type:       Test class
    Purpose:    Test Class for 
    User Story: US-CC-002, US-CC-003
    1. 2013-05-20 Bing bai (NDC)  Created
*/
@isTest
public With Sharing class CaseHelperTest {
    public static Id C_INQUIRY_RECORD_TYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get(UtilConstant.INQUIRY).getRecordTypeId();
    public static Id C_MBDA_RECORD_TYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get(UtilConstant.MBDA_COMPLAINT).getRecordTypeId();
    public static Map<String, Schema.SObjectField> FLDOBJ_MAP = schema.SObjectType.Case.fields.getMap();
    public static Id RETAIL_CAMPAIGN_RECORD_TYPE = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Retail Campaign').getRecordTypeId();
    final static String personRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    final static String dealerRecordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    final static String MBRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('MB Complaint').getRecordTypeId();
    final static String CHRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Chrysler Complaint').getRecordTypeId();
    final static String INQUIRYRecordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Inquiry').getRecordTypeId();
    static Account acc = new Account(LastName='acme', Phone='011111222', Area_Code__c = '010' ,MBK_Data_Source__c='Email',RecordTypeId = personRecordtypeid);
    static Account acc1 = new Account(Name='acme',MBK_Data_Source__c='Email',RecordTypeId = dealerRecordtypeid);
    static Account acc2 = new Account(Name='acme23',MBK_Data_Source__c='Email',RecordTypeId = dealerRecordtypeid);
    private static String DealerUser='Dealer User';
    private static String DealerDelegateAdmin='Dealer Delegate Admin';
    static Vehicle__c ve1 = new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B200', EuroVIN__c='11111222221111122', UsVIN__c='11111222221111122',Latest_Sales_Person__c='xxx',Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'),Purchase_Month__c ='02',Purchase_Year__c = '2004',RegistrationNo__c = '12345');            
    static Vehicle__c ve2 = new Vehicle__c(Baumuster__c='forTest',Class__c='C-Class Coupe',Brand__c='BENZ',Model__c='B220', EuroVIN__c='11111222222111122', UsVIN__c='11111222222111122',Latest_Sales_Person__c='xxx2',Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'),Purchase_Month__c ='02',Purchase_Year__c = '2004',RegistrationNo__c = '12345');   
    public static Account testDealer;
      
   Private static String Dealer_after_sales_service_attitude ='Dealer-after sales service attitude';
   
   static void init( ){
        List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
        insert updatecustomsettings;
        
        /*Create a Vehicle*/
        Vehicle__c testVehicle = new Vehicle__c(
            Brand__c = 'Maybach',
            Class__c = 'A-Class',
            Model__c = 'A160',
            UsVIN__c = '46578934237654873',
            EuroVIN__c = '362534778873636924',
            Latest_Sales_Person__c = 'Shantaram',
            Warranty_Start_Date__c = Date.today(),
            FirstRegistrationDate__c = Date.today(),
            Purchase_Month__c ='02',
            Purchase_Year__c = '2004',
            RegistrationNo__c = '12345'
        );
        
        insert testVehicle;
        
        Vehicle__c vehicle = [Select Id from Vehicle__c Where Latest_Sales_Person__c = 'Shantaram'];
        /*Create a Vehicle Relationship*/
        Vehicle_Relationship__c vr = new Vehicle_Relationship__c(
            Vehicle_ID__c = vehicle.Id,
            Registration_Number__c = '23456789585'         
        );
        insert vr;
        
        //Dealer Account
        testDealer = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_DEALER);
        Contact contact = new Contact(
            AccountId = testDealer.Id, 
            LastName = 'b', 
            Phone = '01212313', 
            email = 's@s.s',
            
            Dealer_Complaint_Gate_Keeper__c = true
        );
        insert contact;
        
        User runUser = [select Id from User Where Id =: UserInfo.getUserId()];
        User usr=new User();
        System.runAs ( runUser ) {               
                usr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';
                usr.ProfileId=UtilTestData.getProfileId('CAC Data Manager');
                usr.UserRoleId=UtilTestData.getUserRoleId('Dealer User');
                usr.LastName = 'TestCreateUser';
                usr.Email = 'test001@daimler.com.full';
                usr.Alias = 'test1';
                usr.TimeZoneSidKey = 'Asia/Shanghai';
                usr.EmailEncodingKey = 'UTF-8';
                usr.LanguageLocaleKey = 'en_US';
                usr.localesidkey='en_US';
                usr.isActive = true;
                Database.insert(usr); 
                system.debug('!!!!! User Records'+usr); 
        }
        
        User runUser1 = [select Id from User Where LastName = 'TestCreateUser'];
        User usr1=new User();       
        System.runAs ( runUser ) {               
                usr1.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';
                usr1.ProfileId=UtilTestData.getProfileId('Dealer Community User');
                //usr.UserRoleId=UtilTestData.getUserRoleId('Dealer User');
                usr1.LastName = 'Test User';
                usr1.Email = 'test001@daimler.com.full';
                usr1.Alias = 'test1';
                usr1.TimeZoneSidKey = 'Asia/Shanghai';
                usr1.EmailEncodingKey = 'UTF-8';
                usr1.LanguageLocaleKey = 'en_US';
                usr1.localesidkey='en_US';
                usr1.isActive = true;
                usr1.ContactId =contact.Id;
                Database.insert(usr1); 
                system.debug('!!!!! User Records'+usr1); 
         }                           
  }
  
   public static final List<String> COLS_MB_TRACKING = new List<String>{'Case_Type__c', 
                                        'Case_SubType__c',
                                        'Case_Dealer__c',
                                        'Subject', 
                                        'Vehicle_Relationship__c', 
                                        'Vehicle_Brand__c', 
                                        'Vehicle_Class__c', 
                                        'Vehicle_Model__c',
                                        'VIN_Code__c', 
                                        'Vehicle_Source__c', 
                                        'Dealer_Contact__c',
                                        'Dealer_Case_Type__c',
                                        'Dealer_Case_SubType__c',
                                        'Case_RepeatCause__c', 
                                        'Repeat_Complaint_Times__c', 
                                        'Final__c', 
                                        'Results_Response__c', 
                                        'Description',
                                        'OwnerId',
                                        'Case_Department__c',
                                        'Follow_Up_Inquiry__c', 
                                        'Complaint_Date__c', 
                                        'Case_Involvement_MPC__c', 
                                        'Case_Source__c', 
                                        'ParentId', 
                                        'AccountId', 
                                        'Region__c', 
                                        'Handling_Level__c', 
                                        'Data_Source__c',
                                        'Data_Subsource__c', 
                                        'Case_Status__c', 
                                        'Progress_Status__c', 
                                        'Escalate_Date_to_RO__c', 
                                        'Escalate_Date_to_CO__c', 
                                        'Suspended_Date__c', 
                                        'Suspended_Reason__c', 
                                        'Overdue__c', 
                                        'Overdue_Reason__c', 
                                        'X1st_FP_Position_Release_Date__c', 
                                        'X2nd_FP_Position_Release_Date__c', 
                                        'SFPositionDate__c', 
                                        'FFPositionDate__c', 
                                        'Release_Date__c', 
                                        'Resolved_Date__c', 
                                        'Contact_Person__c', 
                                        'Perferred_Contact_Number__c', 
                                        'Contact_Person_Tele__c', 
                                        'Perferred_Contact_Email__c', 
                                        'Customer_Background_Info__c', 
                                        'Government_Background__c', 
                                        'Car_Owner__c', 
                                        'Gender__c', 
                                        'Occupation__c', 
                                        'Title__c', 
                                        'Owner_Tele__c', 
                                        'Date_of_Birth__c', 
                                        'Address__c', 
                                        'Licence_Number__c', 
                                        'Other_Brand__c', 
                                        'Owned_MB_Vehicle__c', 
                                        'Vehicle_In_Workshop__c', 
                                        'Dealer_Provides_Transport__c', 
                                        'Customer_Requests_Transport__c', 
                                        'Selling_Dealer__c', 
                                        'Order_No__c', 
                                        'Last_Known_Sales_Person__c', 
                                        'Date_of_Warranty_Expiry__c', 
                                        'Last_Known_Mileage__c', 
                                        'Date_of_1st_Registration__c', 
                                        'US_VIN__c', 
                                        'EU_VIN__c', 
                                        'Defective_Item__c', 
                                        'Defective_SubItem__c', 
                                        'Car_Type__c', 
                                        'Engine_Number__c', 
                                        'Special_Goodwill__c', 
                                        'Goodwill_Category__c', 
                                        'Goodwill_Details__c', 
                                        'Goodwill_Cost__c',
                                        'Ref_No_Central__c',
                                        'Ref_No_Regional__c',
                                        'Dealer_Case_Category__c',
                                        'Dealer_Feedback__c'
                                        };
        
    
    public static testMethod void testUSCC002()
    {
        init( );
        system.debug('test&&&&&>>'+UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH));
        //Added community license switching mechanism
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
        {
            Test.startTest();
            List<Sobject> sos = new List<Sobject>();        
            insert acc;
            insert ve1;
            insert ve2;        
            Vehicle_Relationship__c vrData1 = new Vehicle_Relationship__c(Vehicle_ID__c=ve1.id, 
                                                  Contact__c = acc.Id,Registration_Number__c ='5');
            Vehicle_Relationship__c vrData2 = new Vehicle_Relationship__c(Vehicle_ID__c=ve2.id, 
                                                  Contact__c = acc.Id,Registration_Number__c ='2');
            insert vrData1;
            insert vrData2;                
            User user1 = UtilTestData.createPortalUser(DealerUser,DealerDelegateAdmin);
            User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];
    
            Case c1 = new Case(Vehicle_Relationship__c = vrData1.Id, AccountId = acc.Id, RecordTypeId = MBRecordtypeid,
                               Case_SubType__c=Dealer_after_sales_service_attitude, Case_Dealer__c = portalUser1.AccountId);
            sos.add(c1);
            if(sos!=null && !sos.IsEmpty())
            UtilSobject.insertSobjects(sos);        
            c1 = [select Case_SubType__c,Subject,Vehicle_Brand__c,Vehicle_Class__c,Vehicle_Model__c,VIN_Code__c from case where id=:c1.id];
            c1.Vehicle_Relationship__c = vrData2.id;
            update c1;
            List<Complaint_Tracking__c> ctcs = [select Action__c from Complaint_Tracking__c where Case__c=:c1.id];           
            Test.stopTest();
            
            system.assertEquals(c1.Vehicle_Class__c,'class-B');
            system.assertEquals(c1.Vehicle_Model__c,'B200');
            system.assertEquals(c1.VIN_Code__c,ve1.UsVIN__c);  
            system.assert(!ctcs.isEmpty());
            system.assertEquals(c1.Vehicle_Relationship__c,vrData2.id);
        } 
    }
    
    public static testMethod void testUSCC003()
    {
        init( );
        Vehicle__c vehicle = [Select Id from Vehicle__c Where Latest_Sales_Person__c = 'Shantaram'];
        Vehicle_Relationship__c vr = [Select Id,Vehicle_Brand__c,Vehicle_Class__c,Vehicle_Model__c, 
                                        Vehicle_ID__r.UsVIN__c,Vehicle_ID__r.EuroVIN__c,Vehicle_ID__r.Latest_Sales_Person__c,Vehicle_ID__r.Warranty_Start_Date__c,Registration_Number__c,Vehicle_ID__r.FirstRegistrationDate__c
                                        from Vehicle_Relationship__c Where Vehicle_ID__c =: vehicle.Id ];
        Case caseAssign = CaseHelper.setVehicleInfo(new Case(), vr);
        //Case testCase = (Case)UtilTestData.createSObject(new Case(), 'MB Complaint');
        Case testCase = new Case(Others__c = 'other@163.com',RecordTypeId = MBRecordtypeid);
        insert testCase;
        testCase.Case_Dealer__c = acc.Id;
        update testCase;
        
        Complaint_Description__c cd = CaseHelper.newCaseDescription(caseAssign.Id, 'label','newValue','oldValue');
        Complaint_Tracking__c ct = CaseHelper.newCaseHistory(caseAssign.Id, 'label','newValue','oldValue');
        CaseHelper.creatCaseDescription(new List<Case>{caseAssign});
        Map<Id,Id> caseIds = new Map<Id,Id>();
        
        caseIds.put(testCase.Id, testCase.Id);
        CaseHelper.shareDealer(caseIds);
        CaseHelper.shareCaseToRO(caseIds);
        
        Account newAccount = new Account(RecordTypeId = personRecordtypeid);
        //newAccount.PersonBirthdate = Date.today();
        newAccount.LastName='Pref chck test';
        newAccount.Gender__c = 'Male';
        newAccount.Occupation__c = 'Others';
        newAccount.Phone = '09088767547';
        newAccount.Province__c = 'Province1';
        newAccount.Primary_Address__c = 'sdfsdfsdfsdf';
        newAccount.City__c = 'asdfsf';
        newAccount.ZipCode__c = '1234567';
        newAccount.MBK_Data_Source__c='Email';
        newAccount.Mobile__c = '000-0000-9642';
        insert newAccount;
        
        testCase.Car_Owner__c = newAccount.Id;
        update testCase;
        
        String accountId = String.valueOf(newAccount.Id);
        CaseHelper.populateCarOwnerValuesToCase(new Set<String>{accountId}, new List<Case>{testCase});
        
        //Added community license switching mechanism
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
        {
            Test.startTest();
            List<Sobject> sos = new List<Sobject>();
            insert acc;
            insert ve1;
            Vehicle_Relationship__c vrData = new Vehicle_Relationship__c(Vehicle_ID__c=ve1.id, Contact__c = acc.Id,Registration_Number__c ='3');
            insert vrData;
            User user1 = UtilTestData.createPortalUser('Dealer User','Dealer Community User');
            User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];
    
            Case c1 = new Case(Vehicle_Relationship__c = vrData.Id, AccountId = acc.Id, RecordTypeId = CHRecordtypeid,Problem1__c='ttt', Case_Dealer__c = portalUser1.AccountId);
            insert c1;        
            c1.Problem1__c = 'xxx';
            sos.add(c1);
            if(sos!=null && !sos.IsEmpty())
            UtilSobject.updateSobjects(sos);
            List<Complaint_Tracking__c> ctcs = [select Action__c from Complaint_Tracking__c where Case__c=:c1.id];               
            Test.stopTest();
             
            system.assertEquals(c1.Problem1__c,'xxx');
            system.assert(!ctcs.isEmpty());
        }
    }
      public static testMethod void testUSCC004()
      {
        init( );
        Set<Id> dealerId = new Set<Id>();
        dealerId.add(testDealer.Id);
        Map<Id,String> retmap = CaseHelper.getComplaintGateKeeperEmail(dealerId);
        
        List<String> roles = new List<String>{'Regional CRM Mgr (E)', 'Regional CRM Mgr (S)', 'Regional CRM Mgr (W)', 'Regional CRM Mgr (N)'};        
        //Case testCase = (Case)UtilTestData.createSObject(new Case(), 'MB Complaint');
        Case testCase = new Case(Others__c = 'other@163.com',RecordTypeId = MBRecordtypeid);
        insert testCase;
        User runUser = [select Id from User Where Id =: UserInfo.getUserId()];
        for (String role : roles){
            User usr=new User();       
            System.runAs ( runUser ) {               
                    usr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';
                    usr.ProfileId=UtilTestData.getProfileId('System Administrator');
                    usr.UserRoleId=UtilTestData.getUserRoleId(role);
                    usr.LastName = 'Test User';
                    usr.Email = 'test001@daimler.com.full';
                    usr.Alias = 'test1';
                    usr.TimeZoneSidKey = 'Asia/Shanghai';
                    usr.EmailEncodingKey = 'UTF-8';
                    usr.LanguageLocaleKey = 'en_US';
                    usr.localesidkey='en_US';
                    usr.isActive = true;
                    Database.insert(usr); 
                    system.debug('!!!!! User Records'+usr.UserRoleId); 
             }
        }
        CaseHelper.shareCaseToRO(new List<Case>{testCase});
        
        //Added community license switching mechanism
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
        {
            Test.startTest();        
            acc.PersonMobilePhone = '01301111111';
            insert acc;
            insert ve1;
            Vehicle_Relationship__c vrData = new Vehicle_Relationship__c(Vehicle_ID__c=ve1.id, Contact__c =acc.Id,Registration_Number__c ='4');
            insert vrData;
            User user1 = UtilTestData.createPortalUser('Dealer User','Dealer Delegate Admin');
            User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];
    
            Case c1 = new Case(Vehicle__c = ve1.Id, AccountId = acc.Id, RecordTypeId = MBRecordtypeid,
                               Case_SubType__c=Dealer_after_sales_service_attitude,Case_type__c='After-Sales', Case_Dealer__c = portalUser1.AccountId);
            Case c2 = new Case(Vehicle__c = ve1.Id, AccountId = acc.Id, RecordTypeId = MBRecordtypeid,
                               Case_SubType__c=Dealer_after_sales_service_attitude,Case_type__c='After-Sales', Case_Dealer__c = portalUser1.AccountId, Case_RepeatCause__c = 'test case');
            Case c3 = new Case(Vehicle__c = ve1.Id, AccountId = acc.Id, RecordTypeId = MBRecordtypeid,
                               Case_SubType__c=Dealer_after_sales_service_attitude,Case_type__c='After-Sales', Case_Dealer__c = portalUser1.AccountId);
            
            insert c1;
            //Complaint is a primary complaint(No Parent Case),
            // there will be a SMS sent to customer
            List<Task> tasks = [select id from Task where Phone__c='01301111111'];        
            //After add sub Complaint, the field in sub Complaint will auto plus 1
            c2.ParentId = c1.id;
            c2.Case_RepeatCause__c = '0=No contact with customer';
            upsert c2;
            c1 = [select Repeat_Complaint_Times__c from case where id=:c1.id];
                   
            //If the original Complaint already has a parent complaint
           // c3.ParentId = c2.id;
            try{
           
                insert c3;
                
            }catch(DMLException e){
                System.debug('update case error : ' + e.getDMLMessage(0));
            }
            Test.stopTest();
            
            system.assert(!tasks.isEmpty());
            system.assertEquals(1,c1.Repeat_Complaint_Times__c);
            system.assertEquals(c2.Case_RepeatCause__c ,'0=No contact with customer');
        }
    } 
    
     @isTest
    static void testUSCC008()
    {
        init( );
        //Added community license switching mechanism
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
        {
            User u = new User();
            u.Username = 'username@dddd.com';
            u.Email = 'username@dddd.com';
            u.CommunityNickname = 'communityNickname';
            insert acc;
            String accountId = acc.id;
    
            // lastName is a required field on user, but if it isn't specified, 
            //   the code uses the username
            Site.createPortalUser(u, accountId, '1qaz@WSX3e');
            User user1 = UtilTestData.createPortalUser('Dealer User','Dealer Delegate Admin');
            User portalUser = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];
    
            Test.startTest();        
            Case c = new Case(Subject='For Mail test',RecordTypeId = INQUIRYRecordtypeid);
            c.Case_Dealer__c = portalUser.AccountId;
            insert c;
            c.Dealer_Contact__c = 'YES';
            update c;
            c = [select ownerId from Case where id = :c.Id];        
            Test.stopTest();
            System.assertEquals([SELECT id FROM case WHERE Id = :c.id].size(), 1);
            System.assertEquals([SELECT id,Dealer_Contact__c FROM case WHERE Id = :c.id].Dealer_Contact__c,'Yes');
        }
    }
    
    @isTest
    public static void testUSCC024() 
    {
        init( );
        //Added community license switching mechanism
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
        {
            Test.startTest();
            insert acc1;
            insert acc2;
            User user1 = UtilTestData.createPortalUser(DealerUser,DealerDelegateAdmin);
            User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];
    
            Case c1 = new Case( Customer_Care_Owner__c=user1.id,CheckFlag_48H__c=true,Notice_Others__c=true,Notice_SM__c=false,Notice_GM__c=true,RecordTypeId = MBRecordtypeid, Description = 'test des', Case_Dealer__c = portalUser1.AccountId, Status = 'Open',Handling_Level__c = 'Dealer',Notice_AS__c=true,Notice_CRM__c=true);
            insert c1;
            c1.Status = 'Closed';
            c1.Handling_Level__c = 'Central Office';
            c1.Description_Changed__c=true;
            c1.Settlement_Changed__c=true;
            c1.CheckFlag_48H__c=false;
           // c1.Support_Dealer_1__c = acc1.id;
            c1.Notice_SM__c=true;
            c1.Notice_AS__c=true;
           
            update c1;
            c1 = [SELECT CreatedbyId FROM Case WHERE id = :c1.id];        
            Test.stopTest();
            System.assertEquals([SELECT id FROM case WHERE Id = :c1.id].size(), 1);
        }
    }
     @isTest
    public static void testUSCC026() 
    {
        init( );
        //Added community license switching mechanism
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
        {
            Test.startTest();
            insert acc1;
            insert acc2;
            User user1 = UtilTestData.createPortalUser(DealerUser,DealerDelegateAdmin);
            User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];
    
            Case c1 = new Case( Customer_Care_Owner__c=user1.id,CheckFlag_48H__c=true,Notice_Others__c=true,Notice_SM__c=false,Notice_GM__c=true,RecordTypeId = C_INQUIRY_RECORD_TYPE, Description = 'des test', Case_Dealer__c = portalUser1.AccountId, Status = 'Open',Handling_Level__c = 'Dealer',Notice_AS__c=true,Notice_CRM__c=true);
            insert c1;
            c1.Status = 'Closed';
            c1.Handling_Level__c = 'Central Office';
            c1.Description_Changed__c=true;
            c1.Settlement_Changed__c=true;
            c1.CheckFlag_48H__c=false;
           // c1.Support_Dealer_1__c = acc1.id;
            c1.Notice_SM__c=true;
            c1.Notice_AS__c=true;
           
            update c1;
            list<Case> listCase = new  list<Case>();
            listCase.add(c1);
            CaseHelper.closeRelatedCase(listCase);
            Test.stopTest();
            System.assertEquals([SELECT id FROM case WHERE Id = :c1.id].size(), 1);
        }
       
    }
    @isTest
    public static void testUSCC025()
    {
        init( );
        //Added community license switching mechanism
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
        {
            Test.startTest();
            User user1 = UtilTestData.createPortalUser(DealerUser,DealerDelegateAdmin);
            User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];
    
            Case c1 = new Case(RecordTypeId = C_MBDA_RECORD_TYPE, Description = 'test', Case_Dealer__c = portalUser1.AccountId);
            insert c1;
            c1 = [SELECT CreatedbyId FROM Case WHERE id = :c1.id];        
            
              Case c = new Case(Subject='For Mail test',RecordTypeId = INQUIRYRecordtypeid); 
              c.Case_Dealer__c = portalUser1.AccountId;          
              insert c;          
                        
              c = [select ownerId from Case where id = :c.Id];                  
              Test.stopTest();          
              System.assertEquals([SELECT id FROM case WHERE Id = :c.id].size(), 1);          
              
        }
    }
  
   @isTest
    public static void testUSCC031()
    { 
        init( );
        //Added community license switching mechanism
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
        {
            Test.startTest();            
            User user1 = UtilTestData.createPortalUser(DealerUser,DealerDelegateAdmin);     
            User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];
    
           //User portalUser2 = [select accountId , email from user   
           // where contact.Dealer_Complaint_Gate_Keeper__c = true and id=:user2.Id 
           //and isActive = true and AccountId <> :portalUser1.AccountId limit 1];
            Case c1 = new Case(RecordTypeId = MBRecordtypeid, Description = 'test d', Case_Dealer__c = portalUser1.AccountId);
            insert c1;
        
            c1.Support_Dealer_1__c = null;
            c1.Support_Dealer_2__c = null;
            update c1;
            
            c1 = [SELECT CreatedbyId,Support_Dealer_2__c,Support_Dealer_1__c FROM Case WHERE id = :c1.id];
            Complaint_Description__c cd=new Complaint_Description__c();
            cd.Case__c = c1.Id;
            cd.Created_By__c = UserInfo.getUserId();
            cd.Date_Time__c = System.now();
            cd.Action__c = 'Changed';
            insert cd; 
            Test.stopTest();
            System.assert([SELECT id FROM Complaint_Description__c WHERE Case__c = :c1.id].size()>0);  
            System.assert([select Id from case where id=:c1.id].size()>0);      
            System.assertEquals(c1.Support_Dealer_1__c, null);
            System.assertEquals(c1.Support_Dealer_2__c, null);
        }    
    } 
    
    public static testMethod void testRelease11b01()
    {
        //init( );
        Test.startTest();
        Account dealer = new Account(Name='acme23',MBK_Data_Source__c='Email',RecordTypeId = dealerRecordtypeid);
        insert dealer;
        Case cas = new Case(Case_Dealer__c = dealer.id, Others__c = 'test@163.com',RecordTypeId = MBRecordtypeid );
        insert cas;
        cas.Notice_AS__c = true;
        cas.Notice_CRM__c = true;
        cas.Notice_GM__c = true;
        cas.Notice_Others__c = true;
        cas.Notice_SM__c = true;
        try {
            update cas;
        } catch (DMLException e) {
            System.debug('update case error : ' + e.getDMLMessage(0));
       }
        Test.stopTest();
        System.assertEquals(cas.Notice_SM__c,true);
        System.assertEquals(cas.Notice_AS__c,true);
        system.assert([Select Id from Account where Id=:dealer.id].size()>0);
        system.assert([Select id from Case where id=:cas.Id].size()>0); 
    }
    
    public static testMethod void testRelease11b02()
    {
        //init( );
        Test.startTest();
        insert ve1;
        Account dealer = new Account(Dealer_General_Manager_Email__c = 'gm@163.com',Dealer_Sales_Manager_Email__c = 'ds@163.com',Name='acme23',MBK_Data_Source__c='Email',RecordTypeId = dealerRecordtypeid);
        insert dealer;
        Case cas = new Case(Case_Dealer__c = dealer.id,Vehicle__c =ve1.id , Others__c = 'other@163.com',RecordTypeId = MBRecordtypeid);
        insert cas;
        cas.Notice_AS__c = true;
        cas.Notice_CRM__c = true;
        cas.Notice_GM__c = true;
        cas.Notice_Others__c = true;
        cas.Notice_SM__c = true;
        cas.Case_Status__c = 'In-progress';
       try {
            update cas;
        } catch (DMLException e) {
           System.debug('update case error : ' + e.getDMLMessage(0));
       }
        Test.stopTest();
        System.assertEquals(cas.Notice_SM__c,true);
        System.assertEquals(cas.Notice_AS__c,true);
        System.assertEquals(cas.Case_Status__c,'In-progress');
        system.assert([Select Id from Account where Id=:dealer.id].size()>0);
        system.assert([Select id from Case where id=:cas.Id].size()>0); 
    }
    public static testMethod void testUSCC005()
    {
        init( );
       //Added community license switching mechanism
        if(UtilCustomSettings.getIsEnableCommunity(UtilConstant.COMMUNITY_LICENSE_SWITCH))
        { 
            Test.startTest();
            List<String> targetList = null;   
            List<Sobject> sos = new List<Sobject>();        
            insert acc;
            insert ve1;
            insert ve2;        
            Vehicle_Relationship__c vrData1 = new Vehicle_Relationship__c(Vehicle_ID__c=ve1.id, 
                                                  Contact__c = acc.Id,Registration_Number__c ='6');
            Vehicle_Relationship__c vrData2 = new Vehicle_Relationship__c(Vehicle_ID__c=ve2.id, 
                                                  Contact__c = acc.Id,Registration_Number__c ='1');
            insert vrData1;
            insert vrData2;                
            User user1 = UtilTestData.createPortalUser(DealerUser,DealerDelegateAdmin);
            
            User portalUser1 = [select accountId , email, contact.Dealer_Complaint_Gate_Keeper__c from user where id=:user1.Id and contact.Dealer_Complaint_Gate_Keeper__c = true and isActive = true limit 1];
               
            system.debug('accountid---------->>>>>'+portalUser1);
            Case c1 = new Case(Vehicle_Relationship__c = vrData1.Id, AccountId = acc.Id, RecordTypeId = MBRecordtypeid,
                               Case_SubType__c=Dealer_after_sales_service_attitude, Case_Dealer__c = portalUser1.AccountId,Car_Owner__c=acc.id);
            sos.add(c1);
            if(sos!=null && !sos.IsEmpty())
            UtilSobject.insertSobjects(sos);        
            c1 = [select Case_SubType__c,Subject,Vehicle_Brand__c,Vehicle_Class__c,Vehicle_Model__c,VIN_Code__c from case where id=:c1.id];
            c1.Vehicle_Relationship__c = vrData2.id;
            c1.SendEmailToGateKeeper__c=true;
            update c1;
            List<Complaint_Tracking__c> ctcs = [select Action__c from Complaint_Tracking__c where Case__c=:c1.id]; 
                    
            targetList = COLS_MB_TRACKING;                                      

            for(String cloName: targetList){
                String newValue = String.valueOf(c1.get(cloName));
                String oldValue = String.valueOf(c1.get(cloName));
                String labelName = FLDOBJ_MAP.get(cloName).getDescribe().getLabel();
              CaseHelper.newCaseDescription(c1.id, labelName, newValue, oldValue);
            }
            map<id,id> casesForShare= new  map<id,id>(); 
            casesForShare.put(c1.id, c1.id);
            
            UtilCaseShare.getGateKeepers(sos);
            CaseHelper.shareDealer(casesForShare);
            CaseHelper.shareCaseToRO(sos);
            CaseHelper.shareCaseToRO(casesForShare);
            Test.stopTest();
            system.assertEquals(c1.Vehicle_Class__c,'class-B');
            system.assertEquals(c1.Vehicle_Model__c,'B200');
            system.assertEquals(c1.VIN_Code__c,ve1.UsVIN__c);  
            system.assert(!ctcs.isEmpty());
           
            system.assertEquals(c1.Vehicle_Relationship__c,vrData2.id);
        } 
    }
}