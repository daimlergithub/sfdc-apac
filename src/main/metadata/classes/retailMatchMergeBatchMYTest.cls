@isTest
public class retailMatchMergeBatchMYTest {

    public static Id accPerson_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
    public static Id accDealer_RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
    public static Id retailVR_RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();
    public static Id SoftdeletedPersonAccountRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account Soft Deleted').getRecordTypeId();static Id SoftdeletedCompanyAccountRecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company Soft Deleted').getRecordTypeId();
    public static final String salesRecordTypeId = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get(UtilConstant.SALES_LEADS).getRecordTypeId();
    public static Account_Link__c acclink;
    public static String testEmail = 'test@test.com';
    public static String market= 'MY';
    public static Contact contact;
    public static Contact contact1;
    public static List<Contact> contacts;
    public static Account_Link__c acclink1;
    public static User portaluser;
    public static Id C2CRecordTypeId = Schema.SObjectType.Account_link__c.getRecordTypeInfosByName().get('Contact2Contact').getRecordTypeId();
    public static List<Duplicate_Merge_Info__c> dmiList=new List<Duplicate_Merge_Info__c>();
    public static List<Vehicle__c> VehicleList=new List<Vehicle__c>();
    public static User user1;
 
    public static void init()
    { 
       Account dealer =  new Account(RecordTypeId = accDealer_RecordTypeId, Name = 'test dealer',Dealer_GC_Code__c = 'GC0011422',Dealer_Type__c='Company',Dealer_ND_Code__c='12345',MD__C='MY'); 
       insert dealer;
       Account  personAcc=new Account(RecordTypeId = accPerson_RecordTypeId, LastName = 'testacc', FirstName = 'testacc',MD__C='MY',Data_Source__c='Dealer Outlet',Mobile__c='+6082563441');
        insert personAcc;
        
        List<Group> groupLst=new List<Group>();
        groupLst.add(new Group(Name='MY12345'));
        insert groupLst;
        
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        Profile p2=[select id from Profile where Name='Malaysia Dealer Delegate Admin' Limit 1];
     //   User Delaer_User= new User(LastName='User'+System.Today(),,Market__c='MY',country='Malaysia',firstName='BCI');
        contact = new Contact();
            contact.FirstName = 'a';
            contact.LastName = 'b';
            contact.Email = testEmail;
           // contact.account.Dealer_Nd_code__c='MBK09Shq';
            contact.Phone = '1212313';
            contact.Title = 'contact title';
            contact.Name_English__c = 'c';
            contact.AccountId = dealer.Id;
            
            contact1 = new Contact();
            contact1.FirstName = 'a';
            contact1.LastName = 'b';
            contact1.Email = testEmail;
            contact1.Phone = '1212313';
            contact1.Title = 'contact title';
            contact1.Name_English__c = 'c';
           
            contact1.AccountId = dealer.Id;
            
            contacts = new List<Contact>();
            contacts.add(contact); 
            contacts.add(contact1); 
            insert contacts; 
         user1 = new User(LastName='User'+System.Today(),contact=contacts[0],Market__c='MY',country='Malaysia',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01'+String.valueof(DateTime.now().getTime()));
        insert user1;
      
        system.runas(user1){
          
        Account duplicate_account= TestUtils.createPersonAccountAsUserAsOwner(user1);
        duplicate_account= TestUtils.UpdateAccount(duplicate_account.id);
        update duplicate_account;
        Account master_account = TestUtils.createCompanyAccount(user1);
        master_account.Primary_Address_Reference__c = TestUtils.createAddress(master_account.ID).ID;
        update master_account;
        Account dealer_account = TestUtils.createPersonAccountAsUserAsOwner(user1);
        dealer_account.Primary_Address_Reference__c = TestUtils.createAddress(dealer_account.ID).ID;
        update dealer_account;
          /*contact = new Contact();
            contact.FirstName = 'a';
            contact.LastName = 'b';
            contact.Email = testEmail;
           // contact.account.Dealer_Nd_code__c='MBK09Shq';
            contact.Phone = '1212313';
            contact.Title = 'contact title';
            contact.Name_English__c = 'c';
            contact.AccountId = dealer.Id;
            
            contact1 = new Contact();
            contact1.FirstName = 'a';
            contact1.LastName = 'b';
            contact1.Email = testEmail;
            contact1.Phone = '1212313';
            contact1.Title = 'contact title';
            contact1.Name_English__c = 'c';
           
            contact1.AccountId = dealer.Id;
            
            contacts = new List<Contact>();
            contacts.add(contact); 
            contacts.add(contact1); 
            insert contacts;*/
         Id p = [SELECT Id FROM Profile WHERE UserType = 'PowerPartner' Limit 1].id;
            portaluser = new User(alias = 'test123', email='test123@noemail.com',
                            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p, country='India',IsActive =true,
                            ContactId = contacts[0].Id, market__c='MY',
                            timezonesidkey='America/Los_Angeles', username='testdealer@noemail.com'+String.valueof(DateTime.now().getTime()));
            insert portaluser;
 
        list<DateTimeForShareBatch__c> lstContacts=new   list<DateTimeForShareBatch__c>();
 DateTimeForShareBatch__c csContactFields=new DateTimeForShareBatch__c(); 
csContactFields.Name='RetailMatchMergeBatchMY';
     csContactFields.noOfHours__c= 24;
lstContacts.add(csContactFields);
    insert lstContacts;
            
            Logic_Switch__c  LS= new Logic_Switch__c();
            LS.Name='VRDeletionOperation';
            insert LS;
            
        
                
        List<String> CaseFields=new List<String>();
        CaseFields.add('Status');
        CaseFields.add('Case_RepeatCause__c');
        CaseFields.add('accountid');
        CaseFields.add('Recordtypeid');   
        CaseFields.add('MD__c');
        CaseFields.add('priority');
        List<Case> CaseFieldsList=DataFactoryServices.createRecords('Case',CaseFields,'',2);
        CaseFieldsList[0].RecordTypeId=RecordTypeAccessService.getRecordTypeId('Case',Label.Inquiry);
        CaseFieldsList[0].accountid=duplicate_account.id;
        CaseFieldsList[0].MD__c='MY';
        CaseFieldsList[0].status='Open';
        CaseFieldsList[0].Case_RepeatCause__c='';
        CaseFieldsList[0].priority='A';
        CaseFieldsList[1].RecordTypeId=RecordTypeAccessService.getRecordTypeId('Case',Label.MB_Complaint);
        CaseFieldsList[1].accountid=master_account.id;
        CaseFieldsList[1].MD__c='MY';
        CaseFieldsList[1].status='Open';
        CaseFieldsList[1].Case_RepeatCause__c='';
        CaseFieldsList[1].priority='Green <= 2';
        insert CaseFieldsList;
            
        Lead__c lead = new Lead__c();
        lead.Contact__c = personAcc.Id;
        lead.CAC_Lead_Status__c = 'New';
        lead.Lead_Type__c = 'New Car';
        lead.Relation_With_The_Leads__c = 'testR';
        lead.Lead_Desired_Service__c = 'Trade-In';
        lead.Purchase_Time__c = '0 - 3 months';
        lead.Interested_Vehicle_Brand__c = 'testI';
        lead.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead.Trade_In_Vehicle_Brand__c = 'c230';
        lead.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead.Trade_In_Other_Vehicle_Model__c = 'testT';
        lead.Interested_Vehicle_Brand__c = 'Smart';
        lead.md__c='MY';
        Boolean flag = true;
        lead.Received_Date_Time__c=system.today();
        lead.Accepted_Date_Time__c=system.today();
        lead.RecordTypeId=salesRecordTypeId;
        lead.Assigned_Dealer__c = dealer.Id;
            
            acclink = new Account_Link__c(); 
            acclink.RecordTypeId = C2CRecordTypeId;
            acclink.Name = 'testaccounlink';
            acclink.fromRole__c = personAcc.Id;
            acclink.toRole__c = duplicate_account.Id;
            acclink.Retail_PersonBirthdate__c=system.today();
            acclink.Retail_Special_Care__c='testing';
            acclink.Retail_Individual_Home_Phone__c='045878956';
            acclink.Retail_Work_Phone__c='0455862358';
            acclink.Retail_Mobile__c='076-789-1452';
            acclink.Retail_Email__c='asdfg@gmail.com';
            acclink.Retail_Gender__c='female';
            acclink.Retail_Occupation__c='Business';
            acclink.Retail_Preferred_Language__c='english';
            acclink.Retail_Preferred_Contact_Method__c='phone';
            insert acclink;
            
            acclink1 = new Account_Link__c(); 
            acclink1.RecordTypeId = C2CRecordTypeId;
            acclink1.Name = 'testaccounlink';
            acclink1.fromRole__c = master_account.Id;
            acclink1.toRole__c = personAcc.Id;
            acclink1.Retail_PersonBirthdate__c=system.today();
            acclink1.Retail_Special_Care__c='testing';
            acclink1.Retail_Individual_Home_Phone__c='045878956';
            acclink1.Retail_Work_Phone__c='0455862358';
            acclink1.Retail_Mobile__c='076-789-1452';
            acclink1.Retail_Email__c='asdfg@gmail.com';
            acclink1.Retail_Gender__c='female';
            acclink1.Retail_Occupation__c='Business';
            acclink1.Retail_Preferred_Language__c='english';
            acclink1.Retail_Preferred_Contact_Method__c='phone';
            insert acclink1;
 
            Vehicle__c  vehicles = new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B200',
                                                  EuroVIN__c='11111222221111122', UsVIN__c='11111222221111122',Latest_Sales_Person__c='xxx', market__c='MY', MD__c='MY',
                                                  Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'),Purchase_Month__c ='02',Purchase_Year__c='2004',RegistrationNo__c ='787878');
            
            VehicleList.add(vehicles);
            insert VehicleList;
            Vehicle_Relationship__c vRel = new Vehicle_Relationship__c(Recall__c = FALSE,vehicle_fax_picklist__c = 'FAX',vehicle_mail_picklist__c = 'Email Home',Car_Relation__c = 'User', RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId());
            vRel.Contact__c = duplicate_account.id;
            vRel.Vehicle_ID__c = vehicles.id;
            vRel.start_date__c=System.today();
            vRel.End_Date__c = System.today()+5;
            vRel.End_Reason__c='Replacement';
            vRel.Vehicle_address_picklist__c = 'Home Address';
            vRel.car_Relation__c='Sales';
            vRel.Owner_Dealer__c=dealer.id;
            vRel.MD__c='MY';
            vRel.Market__c='MY';
            insert vRel;
        
        Vehicle_Relationship__c vRel2 = new Vehicle_Relationship__c(Recall__c = FALSE,vehicle_fax_picklist__c = 'FAX',vehicle_mail_picklist__c = 'Email Home',Car_Relation__c = 'User', RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId());
            vRel2.Contact__c = master_account.id;
            vRel2.Vehicle_ID__c = vehicles.id;
            vRel2.start_date__c=System.today();
            vRel2.End_Date__c = System.today()+9;
            vRel2.End_Reason__c='Replacement';
            vRel2.car_Relation__c='Sales';
            vRel2.Vehicle_address_picklist__c = 'Home Address';
            vRel2.Owner_Dealer__c=dealer_account.id;
            vRel2.MD__c='MY';
            vRel2.Market__c='MY';
            insert vRel2;
        
        Task obTask = new Task(
            RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId(),
            WhatId = duplicate_account.Id,
            Subject = 'Merge Task');
        insert obTask;
        
        Task obTask2 = new Task(
            RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId(),
            WhatId = duplicate_account.Id,
            Subject = 'Merge Task2');
        insert obTask2;
        
        Event evnt = new Event( Whatid=duplicate_account.id,Subject='Test subject',StartDateTime=system.today(),ActivityDate=system.today()+1,EndDateTime=system.today()+2);
        insert evnt;
        
        Event evnt2 = new Event( Whatid=duplicate_account.id,Subject='Test subject2',StartDateTime=system.today(),ActivityDate=system.today()+1,EndDateTime=system.today()+2);
        insert evnt2;
        
        Note nte=new Note(parentId=duplicate_account.Id,Title='Test merge');
        insert nte;
        
        Note nte2=new Note(parentId=duplicate_account.Id,Title='Test merge2');
        insert nte2;
        
        Attachment atchmnt=new Attachment(parentId=duplicate_account.Id,Body=Blob.valueOf('Test merge'),Name='Test Attachment Merge');
        insert atchmnt;
        
        Attachment atchmnt2=new Attachment(parentId=duplicate_account.Id,Body=Blob.valueOf('Test merge2'),Name='Test Attachment Merge2');
        insert atchmnt2;
        
        Duplicate_Merge_Info__c dmi=new Duplicate_Merge_Info__c(
                                    Duplicate_Customer__c=duplicate_account.id,
                                    Duplicate_Reason__c='Reason',
                                    status__c='New',
                                    Master_Customer__c=master_account.id,
                                    Duplicate_Retail_Customer__c = acclink1.id,
                                    Master_Retail_Customer__c = acclink.id,
                                    MD__c='MY'
        );
        
        dmiList.add(dmi);
        insert dmiList;
        
        List<Account> AccountList=[select id,(select id from tasks),(select id from events),(select id from notes),(select id from Attachments),(select id from Vehicle_Relationships2__r) from Account where id in (:dmi.Master_Customer__c,:dmi.Duplicate_Customer__c)];
        Integer masterAccountTasks;
        Integer duplicateAccountTasks;
        Integer masterAccountevents;
        Integer duplicateAccountevents;
        Integer masterAccountnotes;
        Integer duplicateAccountnotes;
        Integer masterAccountattachments;
        Integer duplicateAccountattachments;
        Integer masterAccountVR;
        Integer duplicateAccountVR;
        for(Account a:AccountList){
            if(a.id==dmi.Master_Customer__c){
                masterAccountTasks=a.Tasks.size();
                masterAccountevents=a.Events.size();
                masterAccountnotes=a.Notes.size();
                masterAccountattachments=a.Attachments.size();
                masterAccountVR=a.Vehicle_Relationships2__r.size();
            }
            else if(a.id==dmi.Duplicate_Customer__c){
                duplicateAccountTasks=a.Tasks.size();
                duplicateAccountevents=a.Events.size();
                duplicateAccountnotes=a.Notes.size();
                duplicateAccountattachments=a.Attachments.size();
                duplicateAccountVR=a.Vehicle_Relationships2__r.size();
            }
        }

        List<Account> AccountList2=[select id,(select id from tasks),(select id from events),(select id from notes),(select id from Attachments),(select id from Vehicle_Relationships2__r) from Account where id = :dmi.Master_Customer__c];
        Integer masterAccountTasks_aftermerge;
        Integer masterAccountevents_aftermerge;        
        Integer masterAccountnotes_aftermerge;        
        Integer masterAccountattachments_aftermerge;        
        Integer masterAccountVR_aftermerge;
        for(Account a:AccountList2){
            masterAccountTasks_aftermerge=a.Tasks.size();
            masterAccountevents_aftermerge=a.Events.size();
            masterAccountnotes_aftermerge=a.Notes.size();
            masterAccountattachments_aftermerge=a.Attachments.size();
            masterAccountVR_aftermerge=a.Vehicle_Relationships2__r.size();
        }
      
        }

    }
	
    public static void initTR()
    { 
       Account dealer =  new Account(RecordTypeId = accDealer_RecordTypeId, Name = 'test dealer',Dealer_GC_Code__c = 'GC0011422',Dealer_Type__c='Company',Dealer_ND_Code__c='12345',Market__c='TR'); 
       insert dealer;
       Account  personAcc=new Account(RecordTypeId = accPerson_RecordTypeId, LastName = 'testacc', FirstName = 'testacc',Market__c='TR',Data_Source__c='Dealer Outlet',Mobile__c='+6082563441');
        insert personAcc;
        
        List<Group> groupLst=new List<Group>();
        groupLst.add(new Group(Name='TR12345'));
        insert groupLst;
        
        Profile p1 = [select id from profile where Name='System Administrator' limit 1];
        Profile p2=[select id from Profile where Name='Turkey Dealer Delegate Admin' Limit 1];
     //   User Delaer_User= new User(LastName='User'+System.Today(),,Market__c='MY',country='Malaysia',firstName='BCI');
        contact = new Contact();
            contact.FirstName = 'a';
            contact.LastName = 'b';
            contact.Email = testEmail;
           // contact.account.Dealer_Nd_code__c='MBK09Shq';
            contact.Phone = '1212313';
            contact.Title = 'contact title';
            contact.Name_English__c = 'c';
            contact.AccountId = dealer.Id;
            
            contact1 = new Contact();
            contact1.FirstName = 'a';
            contact1.LastName = 'b';
            contact1.Email = testEmail;
            contact1.Phone = '1212313';
            contact1.Title = 'contact title';
            contact1.Name_English__c = 'c';
           
            contact1.AccountId = dealer.Id;
            
            contacts = new List<Contact>();
            contacts.add(contact); 
            contacts.add(contact1); 
            insert contacts; 
      //   user1 = new User(LastName='User'+System.Today(),contact=contacts[0],Market__c='TR',country='Turkey',firstName='BCI',ProfileId=p1.Id,Alias='ain123',EmailEncodingKey='UTF-8',TimeZoneSidKey='America/New_York',LocaleSidKey='en_US',LanguageLocaleKey='en_US',Email='Ibtesamuddin_M@infosys.com',UserName='sam@usgboral.com.dev01'+String.valueof(DateTime.now().getTime()));
        //insert user1;
      
        system.runas(user1){
          
        Account duplicate_account= TestUtils.createPersonAccountAsUserAsOwner(user1);
        duplicate_account= TestUtils.UpdateAccount(duplicate_account.id);
        update duplicate_account;
        Account master_account = TestUtils.createCompanyAccount(user1);
        master_account.Primary_Address_Reference__c = TestUtils.createAddressTR(master_account.ID).ID;
        update master_account;
        Account dealer_account = TestUtils.createPersonAccountAsUserAsOwner(user1);
        dealer_account.Primary_Address_Reference__c = TestUtils.createAddressTR(dealer_account.ID).ID;
        update dealer_account;
         
         Id p = [SELECT Id FROM Profile WHERE UserType = 'PowerPartner' Limit 1].id;
            portaluser = new User(alias = 'test123', email='test123@noemail.com',
                            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p, country='India',IsActive =true,
                            ContactId = contacts[0].Id, market__c='TR',
                            timezonesidkey='America/Los_Angeles', username='testdealer@noemail.com'+String.valueof(DateTime.now().getTime()));
            insert portaluser;
 
        list<DateTimeForShareBatch__c> lstContacts=new   list<DateTimeForShareBatch__c>();
 DateTimeForShareBatch__c csContactFields=new DateTimeForShareBatch__c(); 
csContactFields.Name='RetailMatchMergeBatchMY';
     csContactFields.noOfHours__c= 24;
lstContacts.add(csContactFields);
    insert lstContacts;
            
            Logic_Switch__c  LS= new Logic_Switch__c();
            LS.Name='VRDeletionOperation';
            insert LS;
            
        
                
        List<String> CaseFields=new List<String>();
        CaseFields.add('Status');
        CaseFields.add('Case_RepeatCause__c');
        CaseFields.add('accountid');
        CaseFields.add('Recordtypeid');   
        CaseFields.add('Market__c');
        CaseFields.add('priority');
        List<Case> CaseFieldsList=DataFactoryServices.createRecords('Case',CaseFields,'',2);
        CaseFieldsList[0].RecordTypeId=RecordTypeAccessService.getRecordTypeId('Case',Label.Inquiry);
        CaseFieldsList[0].accountid=duplicate_account.id;
        CaseFieldsList[0].Market__c='TR';
        CaseFieldsList[0].status='Open';
        CaseFieldsList[0].Case_RepeatCause__c='';
        CaseFieldsList[0].priority='A';
		caseFieldsList[0].subject ='case 1 ';
        CaseFieldsList[0].Description ='case 1 ';
		CaseFieldsList[0].accountId =personAcc.Id;
		CaseFieldsList[0].contactId =contact1.Id;
        CaseFieldsList[0].case_class__c = 'Satisfaction';
        CaseFieldsList[0].Case_Type_tr__c = 'Bayi';
        CaseFieldsList[0].Case_Sub_Type__c = 'Reklam teklifleri';
        CaseFieldsList[0].Case_Sub_Type_Detail_tr__c ='Sorular';
        CaseFieldsList[1].RecordTypeId=RecordTypeAccessService.getRecordTypeId('Case',Label.MB_Complaint);
        CaseFieldsList[1].accountid=master_account.id;
        CaseFieldsList[1].Market__c='TR';
		caseFieldsList[1].subject ='case 1 ';
        CaseFieldsList[1].Description ='case 1 ';
        CaseFieldsList[1].case_class__c = 'Satisfaction';
        CaseFieldsList[1].Case_Type_tr__c = 'Bayi';
        CaseFieldsList[1].Case_Sub_Type__c = 'Reklam teklifleri';
        CaseFieldsList[1].Case_Sub_Type_Detail_tr__c ='Sorular';
        CaseFieldsList[1].status='Open';
		CaseFieldsList[1].accountId =personAcc.Id;
		CaseFieldsList[1].contactId =contact1.Id;
        CaseFieldsList[1].Case_RepeatCause__c='';
        CaseFieldsList[1].priority='Green <= 2';
        insert CaseFieldsList;
            
        Opportunity lead = new Opportunity();
        lead.Contact__c = personAcc.Id;
        lead.stageName = 'New';
        lead.Lead_Type__c = 'New Car';
        lead.Purchase_Time__c = '0 - 1 month';
        lead.Interested_Vehicle_Brand__c = 'testI';
		lead.closedate = system.today();
        /*lead.Trade_In_MB_Vehicle_Model__c = 'benz';
        lead.Trade_In_Vehicle_Brand__c = 'c230';
        lead.Trade_In_Vehicle_Class__c = 'C-CLASS';
        lead.Trade_In_Other_Vehicle_Model__c = 'testT';
        lead.Interested_Vehicle_Brand__c = 'Smart';*/
        lead.Market__c='TR';
        Boolean flag = true;
        lead.Received_Date_Time__c=system.today();
        lead.Accepted_Date_Time__c=system.today();
        lead.RecordTypeId=salesRecordTypeId;
        lead.Assigned_Dealer__c = dealer.Id;
            
            acclink = new Account_Link__c(); 
            acclink.RecordTypeId = C2CRecordTypeId;
            acclink.Name = 'testaccounlink';
            acclink.fromRole__c = personAcc.Id;
            acclink.toRole__c = duplicate_account.Id;
            acclink.Retail_PersonBirthdate__c=system.today();
            acclink.Retail_Special_Care__c='testing';
            acclink.Retail_Individual_Home_Phone__c='045878956';
            acclink.Retail_Work_Phone__c='0455862358';
            acclink.Retail_Mobile__c='076-789-1452';
            acclink.Retail_Email__c='asdfg@gmail.com';
            acclink.Retail_Gender__c='female';
            acclink.Retail_Occupation__c='Business';
            acclink.Retail_Preferred_Language__c='english';
            acclink.Retail_Preferred_Contact_Method__c='phone';
            insert acclink;
            
            acclink1 = new Account_Link__c(); 
            acclink1.RecordTypeId = C2CRecordTypeId;
            acclink1.Name = 'testaccounlink';
            acclink1.fromRole__c = master_account.Id;
            acclink1.toRole__c = personAcc.Id;
            acclink1.Retail_PersonBirthdate__c=system.today();
            acclink1.Retail_Special_Care__c='testing';
            acclink1.Retail_Individual_Home_Phone__c='045878956';
            acclink1.Retail_Work_Phone__c='0455862358';
            acclink1.Retail_Mobile__c='076-789-1452';
            acclink1.Retail_Email__c='asdfg@gmail.com';
            acclink1.Retail_Gender__c='female';
            acclink1.Retail_Occupation__c='Business';
            acclink1.Retail_Preferred_Language__c='english';
            acclink1.Retail_Preferred_Contact_Method__c='phone';
            insert acclink1;
 
            Vehicle__c  vehicles = new Vehicle__c(Baumuster__c='forTest',Class__c='class-B',Brand__c='BENZ',Model__c='B200',
                                                  EuroVIN__c='11111222221111122', UsVIN__c='11111222221111122',Latest_Sales_Person__c='xxx', market__c='TR', MD__c='TR',
                                                  Warranty_Start_Date__c=date.valueOf('2012-10-02'),FirstRegistrationDate__c=date.valueOf('2012-10-03'),Purchase_Month__c ='02',Purchase_Year__c='2004',RegistrationNo__c ='787878');
            
            VehicleList.add(vehicles);
            insert VehicleList;
            Vehicle_Relationship__c vRel = new Vehicle_Relationship__c(Recall__c = FALSE,vehicle_fax_picklist__c = 'FAX',vehicle_mail_picklist__c = 'Email Home',Car_Relation__c = 'User', RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId());
            vRel.Contact__c = duplicate_account.id;
            vRel.Vehicle_ID__c = vehicles.id;
            vRel.start_date__c=System.today();
            vRel.End_Date__c = System.today()+5;
            vRel.End_Reason__c='Replacement';
            vRel.Vehicle_address_picklist__c = 'Home Address';
            vRel.car_Relation__c='Sales';
            vRel.Owner_Dealer__c=dealer.id;
            vRel.MD__c='TR';
            vRel.Market__c='TR';
            insert vRel;
        
        Vehicle_Relationship__c vRel2 = new Vehicle_Relationship__c(Recall__c = FALSE,vehicle_fax_picklist__c = 'FAX',vehicle_mail_picklist__c = 'Email Home',Car_Relation__c = 'User', RecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId());
            vRel2.Contact__c = master_account.id;
            vRel2.Vehicle_ID__c = vehicles.id;
            vRel2.start_date__c=System.today();
            vRel2.End_Date__c = System.today()+9;
            vRel2.End_Reason__c='Replacement';
            vRel2.car_Relation__c='Sales';
            vRel2.Vehicle_address_picklist__c = 'Home Address';
            vRel2.Owner_Dealer__c=dealer_account.id;
            vRel2.MD__c='TR';
            vRel2.Market__c='TR';
            insert vRel2;
        
        Task obTask = new Task(
            RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId(),
            WhatId = duplicate_account.Id,
            Subject = 'Merge Task');
        insert obTask;
        
        Task obTask2 = new Task(
            RecordTypeId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('OB Call').getRecordTypeId(),
            WhatId = duplicate_account.Id,
            Subject = 'Merge Task2');
        insert obTask2;
        
        Event evnt = new Event( Whatid=duplicate_account.id,Subject='Test subject',StartDateTime=system.today(),ActivityDate=system.today()+1,EndDateTime=system.today()+2);
        insert evnt;
        
        Event evnt2 = new Event( Whatid=duplicate_account.id,Subject='Test subject2',StartDateTime=system.today(),ActivityDate=system.today()+1,EndDateTime=system.today()+2);
        insert evnt2;
        
        Note nte=new Note(parentId=duplicate_account.Id,Title='Test merge');
        insert nte;
        
        Note nte2=new Note(parentId=duplicate_account.Id,Title='Test merge2');
        insert nte2;
        
        Attachment atchmnt=new Attachment(parentId=duplicate_account.Id,Body=Blob.valueOf('Test merge'),Name='Test Attachment Merge');
        insert atchmnt;
        
        Attachment atchmnt2=new Attachment(parentId=duplicate_account.Id,Body=Blob.valueOf('Test merge2'),Name='Test Attachment Merge2');
        insert atchmnt2;
        
        Duplicate_Merge_Info__c dmi=new Duplicate_Merge_Info__c(
                                    Duplicate_Customer__c=duplicate_account.id,
                                    Duplicate_Reason__c='Reason',
                                    status__c='New',
                                    Master_Customer__c=master_account.id,
                                    Duplicate_Retail_Customer__c = acclink1.id,
                                    Master_Retail_Customer__c = acclink.id,
                                    MD__c='TR'
        );
        
        dmiList.add(dmi);
        insert dmiList;
        
        List<Account> AccountList=[select id,(select id from tasks),(select id from events),(select id from notes),(select id from Attachments),(select id from Vehicle_Relationships2__r) from Account where id in (:dmi.Master_Customer__c,:dmi.Duplicate_Customer__c)];
        Integer masterAccountTasks;
        Integer duplicateAccountTasks;
        Integer masterAccountevents;
        Integer duplicateAccountevents;
        Integer masterAccountnotes;
        Integer duplicateAccountnotes;
        Integer masterAccountattachments;
        Integer duplicateAccountattachments;
        Integer masterAccountVR;
        Integer duplicateAccountVR;
        for(Account a:AccountList){
            if(a.id==dmi.Master_Customer__c){
                masterAccountTasks=a.Tasks.size();
                masterAccountevents=a.Events.size();
                masterAccountnotes=a.Notes.size();
                masterAccountattachments=a.Attachments.size();
                masterAccountVR=a.Vehicle_Relationships2__r.size();
            }
            else if(a.id==dmi.Duplicate_Customer__c){
                duplicateAccountTasks=a.Tasks.size();
                duplicateAccountevents=a.Events.size();
                duplicateAccountnotes=a.Notes.size();
                duplicateAccountattachments=a.Attachments.size();
                duplicateAccountVR=a.Vehicle_Relationships2__r.size();
            }
        }

        List<Account> AccountList2=[select id,(select id from tasks),(select id from events),(select id from notes),(select id from Attachments),(select id from Vehicle_Relationships2__r) from Account where id = :dmi.Master_Customer__c];
        Integer masterAccountTasks_aftermerge;
        Integer masterAccountevents_aftermerge;        
        Integer masterAccountnotes_aftermerge;        
        Integer masterAccountattachments_aftermerge;        
        Integer masterAccountVR_aftermerge;
        for(Account a:AccountList2){
            masterAccountTasks_aftermerge=a.Tasks.size();
            masterAccountevents_aftermerge=a.Events.size();
            masterAccountnotes_aftermerge=a.Notes.size();
            masterAccountattachments_aftermerge=a.Attachments.size();
            masterAccountVR_aftermerge=a.Vehicle_Relationships2__r.size();
        }
      
        }

    }
    public static testmethod void batchAugment()
    {
       Test.startTest();
    
           init(); 
        retailMatchMergeBatchMY cb = new retailMatchMergeBatchMY(1,'MY');
        Database.QueryLocator ql = cb.start(null);
        cb.execute(null,dmiList);
      //  cb.execute(null,VehicleList);
        cb.Finish(null);
        
        retailMatchMergeBatchMY cb2 = new retailMatchMergeBatchMY(2,'MY');
        Database.QueryLocator ql2 = cb2.start(null);
        cb2.execute(null,VehicleList);
        cb2.Finish(null);
        
         
        retailMatchMergeBatchMY cb3 = new retailMatchMergeBatchMY(3,'MY');
        Database.QueryLocator ql3 = cb3.start(null);
        cb3.execute(null,dmiList);
        cb3.Finish(null);
       
         Test.stopTest();
        
    
       
        
    }
	public static testmethod void batchAugmentTR()
    {
		   user1 = TestUtils.createTRAdminUser();
		   userrole ur = [select id,name from userrole where name='MBTR Management'];
		   user1.userroleId = ur.Id;
		   update user1;
        system.runas(user1){
       Test.startTest();
    
           initTR(); 
        retailMatchMergeBatchMY cb = new retailMatchMergeBatchMY(1,'TR');
        Database.QueryLocator ql = cb.start(null);
        cb.execute(null,dmiList);
      //  cb.execute(null,VehicleList);
        cb.Finish(null);
        
        retailMatchMergeBatchMY cb2 = new retailMatchMergeBatchMY(2,'TR');
        Database.QueryLocator ql2 = cb2.start(null);
        cb2.execute(null,VehicleList);
        cb2.Finish(null);
        
         
        retailMatchMergeBatchMY cb3 = new retailMatchMergeBatchMY(3,'TR');
        Database.QueryLocator ql3 = cb3.start(null);
        cb3.execute(null,dmiList);
        cb3.Finish(null);
	
         Test.stopTest();
        
    }
       
        
    }
}