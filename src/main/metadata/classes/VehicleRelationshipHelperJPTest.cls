@isTest(seeAllData=false)
public with sharing class VehicleRelationshipHelperJPTest{
    
       public static Vehicle_Relationship__c vehicle_relationship;
       public static List<Vehicle_Relationship__c> list_VR;
       public static Account testAccount;
       public static List<Account> accList;
       public static Account accObj;
       public static Vehicle__c vehicleObj;
       public static Vehicle_Relationship__c vehicleRelationshipObj;
       public static Lead__c leadObj;
       public static List<Lead__c> leadlst;
       static List<Vehicle_Relationship__c> vrlst;
       public static void createTestData(Date startDate, Date endDate){ 
           
           List<Trigger__c> updatecustomsettings =  UtilCustomSettingsKernel.customSettingDetails();
           insert updatecustomsettings;
      
           testAccount = (Account)UtilTestData.createSobject(new Account(), UtilTestData.ACCOUNT_RT_PERSON_ACCOUNT);   
           vehicle_relationship = (Vehicle_Relationship__c)UtilTestData.createSobject(new Vehicle_Relationship__c(), UtilTestData.VEHICLE_RELATIONSHIP);
           vehicle_relationship.Start_Date__c = startDate;
           vehicle_relationship.End_Date__c = endDate;
           vehicle_relationship.Contact__c = testAccount.Id;
           vehicle_relationship.End_Reason__c = 'DMS';
           update vehicle_relationship;
           system.assertNotEquals(vehicle_relationship,null);
       }
       
       public static testMethod void testInsertValidation(){
           VehicleRelationshipHelperJP vrHelperJP = new VehicleRelationshipHelperJP();
           Date today = Date.today();
           createTestData(today, today.addDays(1));          
           test.StartTest();         
           vehicle_relationship = new Vehicle_Relationship__c(Contact__c=testAccount.Id, Start_Date__c=today, End_Date__c=today.addDays(1), End_Reason__c = 'DMS');
           VehicleRelationshipHelperJP cls = new VehicleRelationshipHelperJP();
           cls.validateOverlappingVehicleRelationshiponInsert(new List<Vehicle_Relationship__c>{vehicle_relationship});
           list_VR = [Select Id from Vehicle_Relationship__c Where Contact__c =: testAccount.Id];
           map<Id,Vehicle_Relationship__c> mapLst = new map<Id,Vehicle_Relationship__c>();
           mapLst.put(vehicle_relationship.id, vehicle_relationship);
           cls.validateOverlappingVehicleRelationshiponUpdate(new List<Vehicle_Relationship__c>{vehicle_relationship},mapLst);
           map<Id,List<Id>> newmaplist = new map<Id,List<id>>();
           
           system.assertNotEquals(list_VR, null);
           
           
           test.StopTest();
           
       }
       
       public static testMethod void testInsert(){
           VehicleRelationshipHelperJP vrHelperJP = new VehicleRelationshipHelperJP();
           Date today = Date.today();
           createTestData(today, today.addDays(1));          
           test.StartTest();
           vehicle_relationship = new Vehicle_Relationship__c(Contact__c=testAccount.id, Start_Date__c=today, End_Date__c=today.addDays(2), End_Reason__c = 'DMS');
           VehicleRelationshipHelperJP cls = new VehicleRelationshipHelperJP();
           cls.validateOverlappingVehicleRelationshiponInsert(new List<Vehicle_Relationship__c>{vehicle_relationship});
           list_VR = [Select Id from Vehicle_Relationship__c Where Contact__c =: testAccount.Id];
           system.assertNotEquals(list_VR, null);
           test.StopTest();
       }
       public static testMethod void validateOverlappingVehicleRelationship_test(){
           creatTestData();
           Test.startTest();
              
               VehicleRelationshipHelperJP vrjpObj = new VehicleRelationshipHelperJP();
               //VehicleRelationshipHelperJP cls = new VehicleRelationshipHelperJP();
           //cls.validateOverlappingVehicleRelationshiponInsert(new List<Vehicle_Relationship__c>{vehicle_relationship});
               system.assertNotEquals(vrjpObj ,null);
           Test.stopTest();
       }
       public static testMethod void OnAfterInsert_test(){
           creatTestData();
           Test.startTest();
               VehicleRelationshipHelperJP.OnAfterInsert(vrlst);
                system.assertNotEquals(vrlst,null);
           Test.stopTest();
       }
        public static testMethod void OnAfterUpdate_test(){
           creatTestData();
           Test.startTest();
               vrlst.get(0).Car_Relation__c = 'Self-registered';
               vrlst.get(0).Owner_Relation__c = 'Friend';
               update vrlst.get(0);
               List<Vehicle_Relationship__c> vrlstnew = new List<Vehicle_Relationship__c>();
               vrlstnew.add(vrlst.get(0));
               vrlst.get(0).Car_Relation__c = 'Purchaser';
               vrlst.get(0).Owner_Relation__c = 'Others';
               update vrlst.get(0);
               Map<Id,Vehicle_Relationship__c> vrlstold = new  Map<Id,Vehicle_Relationship__c>();
               vrlstold.put(vrlst.get(0).Id,vrlst.get(0));
               VehicleRelationshipHelperJP.OnAfterUpdate(vrlstnew,vrlstold);
               system.assertNotEquals(vrlstold,null);
           Test.stopTest();
       }
        public static testMethod void OnAfterDelete_test(){
           creatTestData();
           Id recordTypeAccObjId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
          Account accObj1 = new Account(RecordTypeId = recordTypeAccObjId1,Name = 'ＭＡＹＢＡＣＨ販売店車両%');
          insert accObj1;
           Test.startTest();
               VehicleRelationshipHelperJP.IgnoredAccounts();
               VehicleRelationshipHelperJP.OnAfterDelete(vrlst);
               system.assertNotEquals(vrlst,null);
           Test.stopTest();
       }
       public static void creatTestData(){
            accList = new List<Account>();
            Id recordTypeAccObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Company').getRecordTypeId();
            accObj = new Account(RecordTypeId = recordTypeAccObjId,Name = 'Mercedez');
            accList.add(accObj);
            Id recordTypeAccDealerObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Dealer').getRecordTypeId();
            accObj = new Account(RecordTypeId = recordTypeAccDealerObjId,Name = 'Mercedez');
            accList.add(accObj);
            Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            accObj = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            accList.add(accObj);
            insert accList;
            Id recordTypeVehicleObjId = Schema.SObjectType.Vehicle__c.getRecordTypeInfosByName().get('MB').getRecordTypeId();
            vehicleObj = new Vehicle__c(RecordTypeId = recordTypeVehicleObjId,Brand__c = 'Maybach',UsVIN__c ='12369854789632147',EuroVIN__c ='tlikkkkkkkklllll66',CurrentMileage__c=5000,NextMileage__c=6000);
            insert vehicleObj;
            vrlst = new List<Vehicle_Relationship__c>();
            vehicleRelationshipObj = new Vehicle_Relationship__c( Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(1).Id,Purchase_Date__c=system.today(),Contact__c =accList.get(2).Id,Validity__c ='Yes',End_Date__c = system.today().addDays(1),Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data');
            vrlst.add(vehicleRelationshipObj);
            vehicleRelationshipObj = new Vehicle_Relationship__c( Car_Relation__c ='Purchaser',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(1).Id,Purchase_Date__c=system.today(),Contact__c =accList.get(2).Id,Validity__c ='Yes',End_Date__c = system.today().addDays(1),Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data');
            vrlst.add(vehicleRelationshipObj);
            insert vrlst;
            
       
       }
       
       
        public static testMethod void updatePortalApplyStatustest(){
           creatTestData();
             Account_Link__c al=new Account_Link__c(Name='new al',
            toRole__c=accList[0].id,
            System__C='My Mercedes',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
             );
             insert al;
           Address__c address=new Address__c();
             address.Address_Type__c='Home';
             address.Province__c='test1';
             address.City__c='bangalore';
            address.District__c='test2';
            address.Block__c='test3';
            address.Address_Line_1__c='testaddress1';
            address.Address_Line_2__c='testaddress2';
            address.Customer__c=accList[0].id;
            address.TitleOfHonor__c = 'To Person'; 
         
            
        insert address;
   
       
           List<Vehicle_Relationship__c> listcampaigns=new List<Vehicle_Relationship__c>();
           Vehicle_Relationship__c  vehicleRelationshipObj1 = new Vehicle_Relationship__c(vehicle_address_picklist__c='Home Address',Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(1).Id,Purchase_Date__c=system.today(),Contact__c =accList.get(2).Id,Validity__c ='Yes',Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data');
           listcampaigns.add(vehicleRelationshipObj1);
           insert listcampaigns;
           Vehicle_Relationship__c listCampaign =[select vehicle_address_picklist__c,Car_Relation__c,Owner_Relation__c,Registration_Number__c,Vehicle_ID__c,Selling_Dealer__c,Purchase_Date__c,Contact__c,Validity__c,Start_Date__c,End_Reason__c from Vehicle_Relationship__c where id IN:listcampaigns ];
           list<Vehicle_Relationship__c> oldList = new  list<Vehicle_Relationship__c>();
           oldList.add(listCampaign);
           map<id,Vehicle_Relationship__c> oldMap = new map<id,Vehicle_Relationship__c>();
           oldMap.put(listCampaign.id, listCampaign);
           vehicleRelationshipObj1.Car_Relation__c='Purchaser';
           update vehicleRelationshipObj1;
           Test.startTest();
               VehicleRelationshipHelperJP.updatePortalApplyStatus(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
               
               vehicleRelationshipObj1.vehicle_mail_picklist__c='Email Home';
               vehicleRelationshipObj1.vehicle_fax_picklist__c='FAX';
               vehicleRelationshipObj1.Vehicle_Phone_picklist__c='Home phone';
               update vehicleRelationshipObj1;
               
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
               
               vehicleRelationshipObj1.vehicle_mail_picklist__c='MyMercedes Email';
               vehicleRelationshipObj1.vehicle_fax_picklist__c='Work FAX';
               vehicleRelationshipObj1.Vehicle_Phone_picklist__c='work phone';
               update vehicleRelationshipObj1;
               
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
               system.assertNotEquals('ggg',listcampaigns[0].Car_Relation__c);
           Test.stopTest();
       }
       
       public static testMethod void beforeupdateEventAddressTest(){
           creatTestData();
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
             Account_Link__c al=new Account_Link__c(Name='new al',
            toRole__c=accobj1.id,
            System__C='My Mercedes',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
             );
             insert al;
             
           Address__c address=new Address__c();
           address.Address_Type__c='Home';
           address.Province__c='test1';
           address.City__c='bangalore';
            address.District__c='test2';
            address.Block__c='test3';
            address.Address_Line_1__c='testaddress1';
            address.Address_Line_2__c='testaddress2';
            address.Customer__c=accobj1.id;
            address.TitleOfHonor__c = 'To Person'; 
         
            
           insert address;
          
           Address__c address1=new Address__c();
           address1.Address_Type__c='Business';
           address1.Province__c='test1';
           address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj1.id;
            address1.TitleOfHonor__c = 'To Person'; 
         
            
           insert address1;
       
           List<Vehicle_Relationship__c> listcampaigns=new List<Vehicle_Relationship__c>();
           Vehicle_Relationship__c  vehicleRelationshipObj1 = new Vehicle_Relationship__c(vehicle_address_picklist__c='Home Address',vehicle_address__c=address.id,Vehicle_Phone_picklist__c='Home phone',vehicle_fax_picklist__c='FAX',vehicle_mail_picklist__c='Email Home',Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(1).Id,Purchase_Date__c=system.today(),Contact__c =accobj1.Id,Validity__c ='Yes',Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data');
           listcampaigns.add(vehicleRelationshipObj1);
           insert listcampaigns;
           Vehicle_Relationship__c listCampaign =[select vehicle_address_picklist__c,Car_Relation__c,Owner_Relation__c,vehicle_address__c,Registration_Number__c,Vehicle_Phone_picklist__c,Vehicle_ID__c,Selling_Dealer__c,Purchase_Date__c,Contact__c,Validity__c,Start_Date__c,End_Reason__c from Vehicle_Relationship__c where id IN:listcampaigns ];
           list<Vehicle_Relationship__c> oldList = new  list<Vehicle_Relationship__c>();
           oldList.add(listCampaign);
           map<id,Vehicle_Relationship__c> oldMap = new map<id,Vehicle_Relationship__c>();
           oldMap.put(listCampaign.id, listCampaign);
           vehicleRelationshipObj1.Car_Relation__c='Purchaser';
           vehicleRelationshipObj1.vehicle_address__c=address1.id;
           update vehicleRelationshipObj1;
          
               VehicleRelationshipHelperJP.beforeupdateEventAddress(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.updatePortalApplyStatus(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
               
               
               
               vehicleRelationshipObj1.vehicle_mail_picklist__c='MyMercedes Email';
               vehicleRelationshipObj1.vehicle_fax_picklist__c='Work FAX';
               vehicleRelationshipObj1.Vehicle_Phone_picklist__c='work phone';
               update vehicleRelationshipObj1;
               
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
               system.assertNotEquals('ggg',listcampaigns[0].Car_Relation__c);
           
       }
       
         public static testMethod void afterUpdateEventTest(){
           creatTestData();
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            Account accObj2 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj2;
             Account_Link__c al=new Account_Link__c(Name='new al',
            toRole__c=accobj1.id,
            System__C='My Mercedes',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
             );
             insert al;
             
           Address__c address=new Address__c();
           address.Address_Type__c='Home';
           address.Province__c='test1';
           address.City__c='bangalore';
            address.District__c='test2';
            address.Block__c='test3';
            address.Address_Line_1__c='testaddress1';
            address.Address_Line_2__c='testaddress2';
            address.Customer__c=accobj1.id;
            address.TitleOfHonor__c = 'To Person'; 
         
            
           insert address;
          
           
       
           List<Vehicle_Relationship__c> listcampaigns=new List<Vehicle_Relationship__c>();
           Vehicle_Relationship__c  vehicleRelationshipObj1 = new Vehicle_Relationship__c(Owner_Dealer__c=accobj1.id,vehicle_address_picklist__c='Home Address',vehicle_address__c=address.id,Vehicle_Phone_picklist__c='Home phone',vehicle_fax_picklist__c='FAX',vehicle_mail_picklist__c='Email Home',Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(1).Id,Purchase_Date__c=system.today(),Contact__c =accobj1.Id,Validity__c ='Yes',Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data');
           listcampaigns.add(vehicleRelationshipObj1);
           insert listcampaigns;
           Vehicle_Relationship__c listCampaign =[select vehicle_address_picklist__c,Owner_Dealer__c,Car_Relation__c,Owner_Relation__c,vehicle_address__c,Registration_Number__c,Vehicle_Phone_picklist__c,Vehicle_ID__c,Selling_Dealer__c,Purchase_Date__c,Contact__c,Validity__c,Start_Date__c,End_Reason__c from Vehicle_Relationship__c where id IN:listcampaigns ];
           list<Vehicle_Relationship__c> oldList = new  list<Vehicle_Relationship__c>();
           oldList.add(listCampaign);
           map<id,Vehicle_Relationship__c> oldMap = new map<id,Vehicle_Relationship__c>();
           oldMap.put(listCampaign.id, listCampaign);
           vehicleRelationshipObj1.Car_Relation__c='Purchaser';
           vehicleRelationshipObj1.Owner_Dealer__c=accobj2.id;
           update vehicleRelationshipObj1;
               VehicleRelationshipHelperJP.afterUpdateEvent(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.beforeupdateEventAddress(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.updatePortalApplyStatus(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
               
               
               
               vehicleRelationshipObj1.vehicle_mail_picklist__c='MyMercedes Email';
               vehicleRelationshipObj1.vehicle_fax_picklist__c='Work FAX';
               vehicleRelationshipObj1.Vehicle_Phone_picklist__c='work phone';
               update vehicleRelationshipObj1;
               
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
               system.assertNotEquals('ggg',listcampaigns[0].Car_Relation__c);
           
       }
        public static testMethod void afterInsertEventTest(){
           creatTestData();
          
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            Account accObj2 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj2;
             Account_Link__c al=new Account_Link__c(Name='new al',
            toRole__c=accobj1.id,
            System__C='My Mercedes',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
             );
             insert al;
            
           Address__c address=new Address__c();
           address.Address_Type__c='Home';
           address.Province__c='test1';
           address.City__c='bangalore';
            address.District__c='test2';
            address.Block__c='test3';
            address.Address_Line_1__c='testaddress1';
            address.Address_Line_2__c='testaddress2';
            address.Customer__c=accobj1.id;
            address.TitleOfHonor__c = 'To Person';
         
            
           insert address;
           Group g=new Group();
           g.name='Test Group';
           insert g;
       
           List<Vehicle_Relationship__c> listcampaigns=new List<Vehicle_Relationship__c>();
           Id VRRRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship').getRecordTypeId();
           Vehicle_Relationship__c  vehicleRelationshipObj1 = new Vehicle_Relationship__c(RecordTypeId=VRRRecordTypeId,Owner_Dealer__c=accobj1.id,vehicle_address_picklist__c='Home Address',vehicle_address__c=address.id,Vehicle_Phone_picklist__c='Home phone',vehicle_fax_picklist__c='FAX',vehicle_mail_picklist__c='Email Home',Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Partner',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(1).Id,Purchase_Date__c=system.today(),Contact__c =accobj1.Id,Validity__c ='Yes',Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data');
           listcampaigns.add(vehicleRelationshipObj1);
           insert listcampaigns;
          
                   Vehicle_Relationship__Share vehicleRelationShare = new Vehicle_Relationship__Share();
                    vehicleRelationShare.AccessLevel = 'Read';
                    vehicleRelationShare.UserOrGroupId = g.Id;
                    vehicleRelationShare.ParentId = listcampaigns[0].id;
                    insert vehicleRelationShare;
          
           Vehicle_Relationship__c listCampaign =[select vehicle_address_picklist__c,Owner_Dealer__c,Car_Relation__c,Owner_Relation__c,vehicle_address__c,Registration_Number__c,Vehicle_Phone_picklist__c,Vehicle_ID__c,Selling_Dealer__c,Purchase_Date__c,Contact__c,Validity__c,Start_Date__c,End_Reason__c from Vehicle_Relationship__c where id IN:listcampaigns ];
           list<Vehicle_Relationship__c> oldList = new  list<Vehicle_Relationship__c>();
           oldList.add(listCampaign);
           map<id,Vehicle_Relationship__c> oldMap = new map<id,Vehicle_Relationship__c>();
           oldMap.put(listCampaign.id, listCampaign);
           //vehicleRelationshipObj1.Owner_Dealer__c=accobj2.id;
           vehicleRelationshipObj1.Owner_Relation__c ='Friend';
            update vehicleRelationshipObj1;
            update listcampaigns;
               VehicleRelationshipHelperJP.afterInsertEvent(listcampaigns);
               VehicleRelationshipHelperJP.beforeupdateEventAddress(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.updatePortalApplyStatus(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
              
               VehicleRelationshipHelperJP.OnAfterInsert(listcampaigns);
               
               vehicleRelationshipObj1.vehicle_mail_picklist__c='MyMercedes Email';
               vehicleRelationshipObj1.vehicle_fax_picklist__c='Work FAX';
               vehicleRelationshipObj1.Vehicle_Phone_picklist__c='work phone';
               update vehicleRelationshipObj1;
              
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
               system.assertNotEquals('ggg',listcampaigns[0].Car_Relation__c);
          
       }
        public static testMethod void OnAfterInsertTest(){
           creatTestData();
          
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            Account accObj2 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj2;
             Account_Link__c al=new Account_Link__c(Name='new al',
            toRole__c=accobj1.id,
            System__C='My Mercedes',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
             );
             insert al;
            
           Address__c address=new Address__c();
           address.Address_Type__c='Home';
           address.Province__c='test1';
           address.City__c='bangalore';
            address.District__c='test2';
            address.Block__c='test3';
            address.Address_Line_1__c='testaddress1';
            address.Address_Line_2__c='testaddress2';
            address.Customer__c=accobj1.id;
            address.TitleOfHonor__c = 'To Person';
         
            
           insert address;
           Group g=new Group();
           g.name='Test Group';
           insert g;
       
           List<Vehicle_Relationship__c> listcampaigns=new List<Vehicle_Relationship__c>();
           Id VRRRecordTypeId = Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship').getRecordTypeId();
           Vehicle_Relationship__c  vehicleRelationshipObj1 = new Vehicle_Relationship__c(RecordTypeId=VRRRecordTypeId,Owner_Dealer__c=accobj1.id,vehicle_address_picklist__c='Home Address',vehicle_address__c=address.id,Vehicle_Phone_picklist__c='work phone',vehicle_fax_picklist__c='Work FAX',vehicle_mail_picklist__c='Email Home',Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Husband・Wife',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(1).Id,Purchase_Date__c=system.today(),Contact__c =accobj1.Id,End_Reason__c ='Test Data');
          
           listcampaigns.add(vehicleRelationshipObj1);
           insert listcampaigns;
          
                   Vehicle_Relationship__Share vehicleRelationShare = new Vehicle_Relationship__Share();
                    vehicleRelationShare.AccessLevel = 'Read';
                    vehicleRelationShare.UserOrGroupId = g.Id;
                    vehicleRelationShare.ParentId = listcampaigns[0].id;
                    insert vehicleRelationShare;
          
           Vehicle_Relationship__c listCampaign =[select vehicle_address_picklist__c,Owner_Dealer__c,Car_Relation__c,Owner_Relation__c,vehicle_address__c,Registration_Number__c,Vehicle_Phone_picklist__c,Vehicle_ID__c,Selling_Dealer__c,Purchase_Date__c,Contact__c,Validity__c,Start_Date__c,End_Reason__c from Vehicle_Relationship__c where id IN:listcampaigns ];
           list<Vehicle_Relationship__c> oldList = new  list<Vehicle_Relationship__c>();
           oldList.add(listCampaign);
           map<id,Vehicle_Relationship__c> oldMap = new map<id,Vehicle_Relationship__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
         
               //VehicleRelationshipHelperJP.OnAfterInsert(listcampaigns);
               VehicleRelationshipHelperJP.afterInsertEvent(listcampaigns);
               VehicleRelationshipHelperJP.beforeupdateEventAddress(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.updatePortalApplyStatus(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
              
                system.assertNotEquals('ggg',listcampaigns[0].Car_Relation__c);
          
       }

       public static testMethod void afterUpdateEventTest1(){
           creatTestData();
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            Account accObj2 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj2;
             Account_Link__c al=new Account_Link__c(Name='new al',
            toRole__c=accobj1.id,
            System__C='My Mercedes',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
             );
             insert al;
             
           Address__c address=new Address__c();
           address.Address_Type__c='Home';
           address.Province__c='test1';
           address.City__c='bangalore';
            address.District__c='test2';
            address.Block__c='test3';
            address.Address_Line_1__c='testaddress1';
            address.Address_Line_2__c='testaddress2';
            address.Customer__c=accobj1.id;
            address.TitleOfHonor__c = 'To Person'; 
         
            
           insert address;
           
           
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj2.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
            
                     Group g=new Group();
                     g.name='Test Group';
                    insert g;
           
                 
       
           List<Vehicle_Relationship__c> listcampaigns=new List<Vehicle_Relationship__c>();
           Vehicle_Relationship__c  vehicleRelationshipObj1 = new Vehicle_Relationship__c(Owner_Dealer__c=accobj1.id,vehicle_address_picklist__c='Home Address',vehicle_address__c=address.id,Vehicle_Phone_picklist__c='Home phone',vehicle_fax_picklist__c='FAX',vehicle_mail_picklist__c='Email Home',Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(1).Id,Purchase_Date__c=system.today(),Contact__c =accobj1.Id,Validity__c ='Yes',Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data');
            insert vehicleRelationshipObj1;
          
           listcampaigns.add(vehicleRelationshipObj1);
           
           
                    Vehicle_Relationship__Share vehicleRelationShare = new Vehicle_Relationship__Share();
                    vehicleRelationShare.AccessLevel = 'Read';
                    vehicleRelationShare.UserOrGroupId = g.Id;
                    vehicleRelationShare.ParentId = listcampaigns[0].id;
                    insert vehicleRelationShare;
           
           
           
           Vehicle_Relationship__c listCampaign =[select vehicle_address_picklist__c,Owner_Dealer__c,Car_Relation__c,Owner_Relation__c,vehicle_address__c,Registration_Number__c,Vehicle_Phone_picklist__c,Vehicle_ID__c,Selling_Dealer__c,Purchase_Date__c,Contact__c,Validity__c,Start_Date__c,End_Reason__c from Vehicle_Relationship__c where id IN:listcampaigns ];
           list<Vehicle_Relationship__c> oldList = new  list<Vehicle_Relationship__c>();
           oldList.add(listCampaign);
           map<id,Vehicle_Relationship__c> oldMap = new map<id,Vehicle_Relationship__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           
           //vehicleRelationshipObj1.Contact__c=accobj2.id;
           update vehicleRelationshipObj1;
           update listcampaigns;   
           
               
               VehicleRelationshipHelperJP.afterUpdateEvent(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.beforeupdateEventAddress(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.updatePortalApplyStatus(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
               
               
               
               vehicleRelationshipObj1.vehicle_mail_picklist__c='MyMercedes Email';
               vehicleRelationshipObj1.vehicle_fax_picklist__c='Work FAX';
               vehicleRelationshipObj1.Vehicle_Phone_picklist__c='work phone';
               update vehicleRelationshipObj1;
               
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
               system.assertNotEquals('ggg',listcampaigns[0].Car_Relation__c);
           
       }
       
       public static testMethod void createAccountLinkTest(){
           creatTestData();
           set<id> vh=new set<id>();
           vh.add(vehicleObj.id);
           set<id> vr=new set<id>();
           set<id> conn=new set<id>();
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            conn.add(accobj1.id);
            Account accObj2 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj2;
             Account_Link__c al=new Account_Link__c(Name='new al',
            toRole__c=accobj1.id,
            System__C='My Mercedes',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
             );
             insert al;
             
           Address__c address=new Address__c();
           address.Address_Type__c='Home';
           address.Province__c='test1';
           address.City__c='bangalore';
            address.District__c='test2';
            address.Block__c='test3';
            address.Address_Line_1__c='testaddress1';
            address.Address_Line_2__c='testaddress2';
            address.Customer__c=accobj1.id;
            address.TitleOfHonor__c = 'To Person'; 
         
            
           insert address;
           
           
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj2.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
            
                     Group g=new Group();
                     g.name='Test Group';
                    insert g;
          
            Vehicle_Relationship__c  vehicleRelationshipObj2 = new Vehicle_Relationship__c(Owner_Dealer__c=accobj1.id,vehicle_address_picklist__c='Home Address',vehicle_address__c=address.id,Vehicle_Phone_picklist__c='Home phone',vehicle_fax_picklist__c='FAX',vehicle_mail_picklist__c='Email Home',Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Parent',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(1).Id,Purchase_Date__c=system.today(),Contact__c =accobj1.Id,Validity__c ='Yes',Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data');
            insert vehicleRelationshipObj2;   
            vr.add(vehicleRelationshipObj2.id);
           List<Vehicle_Relationship__c> listcampaigns=new List<Vehicle_Relationship__c>();
           Vehicle_Relationship__c  vehicleRelationshipObj1 = new Vehicle_Relationship__c(Owner_Dealer__c=accobj1.id,vehicle_address_picklist__c='Home Address',vehicle_address__c=address.id,Vehicle_Phone_picklist__c='Home phone',vehicle_fax_picklist__c='FAX',vehicle_mail_picklist__c='Email Home',Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(1).Id,Purchase_Date__c=system.today(),Contact__c =accobj1.Id,Validity__c ='Yes',Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data');
            insert vehicleRelationshipObj1;
          
           listcampaigns.add(vehicleRelationshipObj1);
           
           
                    Vehicle_Relationship__Share vehicleRelationShare = new Vehicle_Relationship__Share();
                    vehicleRelationShare.AccessLevel = 'Read';
                    vehicleRelationShare.UserOrGroupId = g.Id;
                    vehicleRelationShare.ParentId = listcampaigns[0].id;
                    insert vehicleRelationShare;
           
           
           
           Vehicle_Relationship__c listCampaign =[select vehicle_address_picklist__c,Owner_Dealer__c,Car_Relation__c,Owner_Relation__c,vehicle_address__c,Registration_Number__c,Vehicle_Phone_picklist__c,Vehicle_ID__c,Selling_Dealer__c,Purchase_Date__c,Contact__c,Validity__c,Start_Date__c,End_Reason__c from Vehicle_Relationship__c where id IN:listcampaigns ];
           list<Vehicle_Relationship__c> oldList = new  list<Vehicle_Relationship__c>();
           oldList.add(listCampaign);
           map<id,Vehicle_Relationship__c> oldMap = new map<id,Vehicle_Relationship__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           
           //vehicleRelationshipObj1.Contact__c=accobj2.id;
           update vehicleRelationshipObj1;
           update listcampaigns;   
           
               VehicleRelationshipHelperJP.createAccountLink(vh,vr,conn);
               VehicleRelationshipHelperJP.afterUpdateEvent(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.beforeupdateEventAddress(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.updatePortalApplyStatus(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
               
               
           vehicleRelationshipObj2.Owner_Relation__c='Grand Parent';
           update vehicleRelationshipObj2;
            VehicleRelationshipHelperJP.createAccountLink(vh,vr,conn);
            
            
             vehicleRelationshipObj2.Owner_Relation__c='Grand Parent';
           update vehicleRelationshipObj2;
            VehicleRelationshipHelperJP.createAccountLink(vh,vr,conn);
            
             vehicleRelationshipObj2.Owner_Relation__c='Child';
           update vehicleRelationshipObj2;
            VehicleRelationshipHelperJP.createAccountLink(vh,vr,conn);
            
             vehicleRelationshipObj2.Owner_Relation__c='Grand Child';
           update vehicleRelationshipObj2;
            VehicleRelationshipHelperJP.createAccountLink(vh,vr,conn);
            
            vehicleRelationshipObj2.Owner_Relation__c='Employee';
           update vehicleRelationshipObj2;
            VehicleRelationshipHelperJP.createAccountLink(vh,vr,conn);
            
            vehicleRelationshipObj2.Owner_Relation__c='Manager';
           update vehicleRelationshipObj2;
            VehicleRelationshipHelperJP.createAccountLink(vh,vr,conn);
                
               vehicleRelationshipObj1.vehicle_mail_picklist__c='MyMercedes Email';
               vehicleRelationshipObj1.vehicle_fax_picklist__c='Work FAX';
               vehicleRelationshipObj1.Vehicle_Phone_picklist__c='work phone';
               update vehicleRelationshipObj1;
               
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
               system.assertNotEquals('ggg',listcampaigns[0].Car_Relation__c);
           
       } 

         public static testMethod void afterUpdateEventTest12(){
           creatTestData();
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            Account accObj2 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj2;
             Account_Link__c al=new Account_Link__c(Name='new al',
            toRole__c=accobj1.id,
            System__C='My Mercedes',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
             );
             insert al;
             
           Address__c address=new Address__c();
           address.Address_Type__c='Business';
           address.Province__c='test1';
           address.City__c='bangalore';
            address.District__c='test2';
            address.Block__c='test3';
            address.Address_Line_1__c='testaddress1';
            address.Address_Line_2__c='testaddress2';
            address.Customer__c=accobj1.id;
            address.TitleOfHonor__c = 'To Person'; 
         
            
           insert address;
           
           
            Address__c address1=new Address__c();
            address1.Address_Type__c='Home';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj2.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
            
                     Group g=new Group();
                     g.name='Test Group';
                    insert g;
           
                 
       
           List<Vehicle_Relationship__c> listcampaigns=new List<Vehicle_Relationship__c>();
           Vehicle_Relationship__c  vehicleRelationshipObj1 = new Vehicle_Relationship__c(Owner_Dealer__c=accobj1.id,vehicle_address_picklist__c='Work address',vehicle_address__c=address.id,Vehicle_Phone_picklist__c='Home Phone 2',vehicle_fax_picklist__c='FAX',vehicle_mail_picklist__c='Email Work',Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(1).Id,Purchase_Date__c=system.today(),Contact__c =accobj1.Id,Validity__c ='Yes',Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data');
            insert vehicleRelationshipObj1;
          
           listcampaigns.add(vehicleRelationshipObj1);
           
           
                    Vehicle_Relationship__Share vehicleRelationShare = new Vehicle_Relationship__Share();
                    vehicleRelationShare.AccessLevel = 'Read';
                    vehicleRelationShare.UserOrGroupId = g.Id;
                    vehicleRelationShare.ParentId = listcampaigns[0].id;
                    insert vehicleRelationShare;
           
           
           
           Vehicle_Relationship__c listCampaign =[select vehicle_address_picklist__c,Owner_Dealer__c,Car_Relation__c,Owner_Relation__c,vehicle_address__c,Registration_Number__c,Vehicle_Phone_picklist__c,Vehicle_ID__c,Selling_Dealer__c,Purchase_Date__c,Contact__c,Validity__c,Start_Date__c,End_Reason__c from Vehicle_Relationship__c where id IN:listcampaigns ];
           list<Vehicle_Relationship__c> oldList = new  list<Vehicle_Relationship__c>();
           oldList.add(listCampaign);
           map<id,Vehicle_Relationship__c> oldMap = new map<id,Vehicle_Relationship__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           
           //vehicleRelationshipObj1.Contact__c=accobj2.id;
           update vehicleRelationshipObj1;
           update listcampaigns;   
           
               
               VehicleRelationshipHelperJP.afterUpdateEvent(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.beforeupdateEventAddress(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.updatePortalApplyStatus(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
               
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
               system.assertNotEquals('ggg',listcampaigns[0].Car_Relation__c);
           
       }
       public static testMethod void afterUpdateEventTest13(){
           creatTestData();
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            Account accObj2 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj2;
             Account_Link__c al=new Account_Link__c(Name='new al',
            toRole__c=accobj1.id,
            System__C='My Mercedes',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
             );
             insert al;
             
           Address__c address=new Address__c();
           address.Address_Type__c='Business';
           address.Province__c='test1';
           address.City__c='bangalore';
            address.District__c='test2';
            address.Block__c='test3';
            address.Address_Line_1__c='testaddress1';
            address.Address_Line_2__c='testaddress2';
            address.Customer__c=accobj1.id;
            address.TitleOfHonor__c = 'To Person'; 
         
            
           insert address;
           
           
            Address__c address1=new Address__c();
            address1.Address_Type__c='Other Address 1';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj2.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
            
                     Group g=new Group();
                     g.name='Test Group';
                    insert g;
           
                 
       
           List<Vehicle_Relationship__c> listcampaigns=new List<Vehicle_Relationship__c>();
           Vehicle_Relationship__c  vehicleRelationshipObj1 = new Vehicle_Relationship__c(Owner_Dealer__c=accobj1.id,vehicle_address_picklist__c='Other Address 1',vehicle_address__c=address.id,Vehicle_Phone_picklist__c='Home Phone 2',vehicle_fax_picklist__c='FAX',vehicle_mail_picklist__c='Email Work',Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(1).Id,Purchase_Date__c=system.today(),Contact__c =accobj1.Id,Validity__c ='Yes',Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data');
            insert vehicleRelationshipObj1;
          
           listcampaigns.add(vehicleRelationshipObj1);
           
           
                    Vehicle_Relationship__Share vehicleRelationShare = new Vehicle_Relationship__Share();
                    vehicleRelationShare.AccessLevel = 'Read';
                    vehicleRelationShare.UserOrGroupId = g.Id;
                    vehicleRelationShare.ParentId = listcampaigns[0].id;
                    insert vehicleRelationShare;
           
           
           
           Vehicle_Relationship__c listCampaign =[select vehicle_address_picklist__c,Owner_Dealer__c,Car_Relation__c,Owner_Relation__c,vehicle_address__c,Registration_Number__c,Vehicle_Phone_picklist__c,Vehicle_ID__c,Selling_Dealer__c,Purchase_Date__c,Contact__c,Validity__c,Start_Date__c,End_Reason__c from Vehicle_Relationship__c where id IN:listcampaigns ];
           list<Vehicle_Relationship__c> oldList = new  list<Vehicle_Relationship__c>();
           oldList.add(listCampaign);
           map<id,Vehicle_Relationship__c> oldMap = new map<id,Vehicle_Relationship__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           
           //vehicleRelationshipObj1.Contact__c=accobj2.id;
           update vehicleRelationshipObj1;
           update listcampaigns;   
           
               
               VehicleRelationshipHelperJP.afterUpdateEvent(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.beforeupdateEventAddress(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.updatePortalApplyStatus(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
               
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
               system.assertNotEquals('ggg',listcampaigns[0].Car_Relation__c);
           
       }
       
        public static testMethod void afterUpdateEventTest14(){
           creatTestData();
           
           Id recordTypeAccPersonAccountObjId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account accObj1 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj1;
            Account accObj2 = new Account(RecordTypeId = recordTypeAccPersonAccountObjId,LastName = 'Mercedez',Allow_Data_Sharing__c='Yes',Phone ='09874760605');
            insert accobj2;
             Account_Link__c al=new Account_Link__c(Name='new al',
            toRole__c=accobj1.id,
            System__C='My Mercedes',
            RecordTypeId=Schema.SObjectType.Account_Link__c.getRecordTypeInfosByName().get('Retail Person').getRecordTypeId()
             );
             insert al;
             
           Address__c address=new Address__c();
           address.Address_Type__c='Business';
           address.Province__c='test1';
           address.City__c='bangalore';
            address.District__c='test2';
            address.Block__c='test3';
            address.Address_Line_1__c='testaddress1';
            address.Address_Line_2__c='testaddress2';
            address.Customer__c=accobj1.id;
            address.TitleOfHonor__c = 'To Person'; 
         
            
           insert address;
           
           
            Address__c address1=new Address__c();
            address1.Address_Type__c='Other Address 2';
            address1.Province__c='test1';
            address1.City__c='bangalore';
            address1.District__c='test2';
            address1.Block__c='test3';
            address1.Address_Line_1__c='testaddress1';
            address1.Address_Line_2__c='testaddress2';
            address1.Customer__c=accobj2.id;
            address1.TitleOfHonor__c = 'To Person'; 
            insert address1;
            
                     Group g=new Group();
                     g.name='Test Group';
                    insert g;
           
                 
       
           List<Vehicle_Relationship__c> listcampaigns=new List<Vehicle_Relationship__c>();
           Vehicle_Relationship__c  vehicleRelationshipObj1 = new Vehicle_Relationship__c(Owner_Dealer__c=accobj1.id,vehicle_address_picklist__c='Other Address 2',vehicle_address__c=address.id,Vehicle_Phone_picklist__c='Home Phone 2',vehicle_fax_picklist__c='FAX',vehicle_mail_picklist__c='Email Work',Car_Relation__c ='Sales Contact Target',Owner_Relation__c = 'Others',Registration_Number__c = 'tlikkkkkkkklllll',Vehicle_ID__c = vehicleObj.Id,Selling_Dealer__c = accList.get(1).Id,Purchase_Date__c=system.today(),Contact__c =accobj1.Id,Validity__c ='Yes',Start_Date__c = system.today().addDays(-1),End_Reason__c ='Test Data');
            insert vehicleRelationshipObj1;
          
           listcampaigns.add(vehicleRelationshipObj1);
           
           
                    Vehicle_Relationship__Share vehicleRelationShare = new Vehicle_Relationship__Share();
                    vehicleRelationShare.AccessLevel = 'Read';
                    vehicleRelationShare.UserOrGroupId = g.Id;
                    vehicleRelationShare.ParentId = listcampaigns[0].id;
                    insert vehicleRelationShare;
           
           
           
           Vehicle_Relationship__c listCampaign =[select vehicle_address_picklist__c,Owner_Dealer__c,Car_Relation__c,Owner_Relation__c,vehicle_address__c,Registration_Number__c,Vehicle_Phone_picklist__c,Vehicle_ID__c,Selling_Dealer__c,Purchase_Date__c,Contact__c,Validity__c,Start_Date__c,End_Reason__c from Vehicle_Relationship__c where id IN:listcampaigns ];
           list<Vehicle_Relationship__c> oldList = new  list<Vehicle_Relationship__c>();
           oldList.add(listCampaign);
           map<id,Vehicle_Relationship__c> oldMap = new map<id,Vehicle_Relationship__c>();
           oldMap.put(listCampaign.id, listCampaign);
           
           
           //vehicleRelationshipObj1.Contact__c=accobj2.id;
           update vehicleRelationshipObj1;
           update listcampaigns;   
           
               
               VehicleRelationshipHelperJP.afterUpdateEvent(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.beforeupdateEventAddress(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.updatePortalApplyStatus(listcampaigns,oldMap);
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
               
               VehicleRelationshipHelperJP.updateOnVehicleRelation(listcampaigns);
               system.assertNotEquals('ggg',listcampaigns[0].Car_Relation__c);
           
       }
       
}