@isTest
private class TestBatchSharingVehicle {

    static Id recordTypeRetail = 
        Schema.SObjectType.Vehicle_Relationship__c.getRecordTypeInfosByName().get('Vehicle Relationship Retail').getRecordTypeId();

    static List<Account> accounts = new List<Account>();
    static List<Contact> contacts = new List<Contact>();
    static List<Vehicle__C> cars = new List<Vehicle__C>();
    static List<Vehicle_Relationship__c> vehicleRelates = 
            new List<Vehicle_Relationship__c>();
    static List<User> newUsers = new List<User>();    
    private static void initialData(){
        //Following is Create Dealer info
        //A and B have same CRM code

        for (integer i = 0; i<6 ; i++){
            //Dealer
            Account dealer = (Account)UtilTestData.createSobject(new Account(), 
                UtilTestData.ACCOUNT_RT_DEALER);
            //Contact
            Contact contact = (Contact)UtilTestData.createSobject(new Contact(), 
                '');
            //Vehicle
            Vehicle__C car = (Vehicle__C)UtilTestData.createSobject(new Vehicle__C(), 
                '');
            //Vehicle relationship
            Vehicle_Relationship__c vrc = 
                (Vehicle_Relationship__c)UtilTestData.createSobject(new Vehicle_Relationship__c(), 
                '');
            //setting realtionship field
            vrc.recordtypeid = recordTypeRetail;
            vrc.Vehicle_ID__c = car.id;
            vrc.Owner_Dealer__c = dealer.id;
            cars.add(car);
            vehicleRelates.add(vrc);
            //setting dealer field
            dealer.Dealer_Active__c = true;
            accounts.add(dealer);
            //setting contact field
            contact.AccountId = dealer.id;
            contacts.add(contact);

        }
        update contacts;
        update accounts;
        update cars;
        update vehicleRelates;

        //Create users
        integer i = 0;
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        System.runAs ( thisUser ) {
        
            String[] csrProfiles = new String[]{
                'Dealer-Complaint Manager',
                'Dealer-Complaint User',
                'Dealer-Delegated Admin',
                'Dealer-Lead Manager',
                'Dealer-Lead+Complaint Manager',
                'Dealer-Marketing Manager'
            };
            List<Profile> profileIds = [
                Select Id 
                From Profile 
                Where Name In :csrProfiles];
            
            for(Profile p : profileIds){
                User usr = new User();
                usr.UserName = 'test' + Math.rint(Math.random() * 100000) + '@daimler.com';
                usr.ProfileId = p.Id;
                usr.LastName = 'Test User';
                usr.Email = 'test001@daimler.com.full';
                usr.Alias = 'test';
                usr.TimeZoneSidKey = 'Asia/Shanghai';
                usr.EmailEncodingKey = 'UTF-8';
                usr.LanguageLocaleKey = 'en_US';
                usr.localesidkey='en_US';
                usr.contactId = contacts[i].ID;
                i++;
                newUsers.add(usr);
            }
            system.debug('========newUsers==========:' + newUsers);
            insert newUsers;

        }
    }

    @isTest
    static void test_method_one() {

        initialData();

        //set CRM_CODE
        accounts.get(0).Dealer_DMS_CRM_Code__c = 'KL';
        accounts.get(1).Dealer_DMS_CRM_Code__c = 'KL';
        accounts.get(2).Dealer_DMS_CRM_Code__c = 'AL';
        accounts.get(3).Dealer_DMS_CRM_Code__c = 'AL';
        accounts.get(4).Dealer_DMS_CRM_Code__c = 'AL';
        accounts.get(5).Dealer_DMS_CRM_Code__c = 'BL';

        update accounts;


        Vehicle__share shareObj = new Vehicle__share();

        shareObj.put('parentId', cars[0].id);
        shareObj.put('UserOrGroupId', newusers.get(0).id);
        shareObj.put('AccessLevel', 'Read');

        insert shareObj;

        Test.StartTest();
        system.debug('Insert object:' + shareObj);
        
        BatchSharingVehicle reassign = new BatchSharingVehicle();
        ID batchprocessid = Database.executeBatch(reassign);

        List<Vehicle__share> result1 = 
            [select parentId , userorgroupId from Vehicle__share where parentId = :cars[0].id];
        system.assertEquals(2 , result1.size());

        Test.stopTest();

    }

}