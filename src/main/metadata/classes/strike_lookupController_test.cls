/* @purpose : Test Class for "strike_lookupController"
 * @auther  : Raju-Infosys
*/ 

@isTest
private class strike_lookupController_test {

    @isTest 
    static void test_getRecentRecords() {
        String jsonString = '{"searchField":"Name", "object": "Account", "filter": "Name = \'Test Account\'"}';
		User u = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
        System.runAs(u) {
            Test.startTest();
            String responseString = strike_lookupController.getRecentRecords(jsonString);
            // Test.stopTest();
            
            Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
            Map<string, Object> results = (Map<String, Object>)response.get('results');
            
            System.assertEquals(true, response.get('isSuccess'));
        }
    }

    @isTest 
    static void test_getRecordLabel() {
        User u = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
        System.runAs(u) {
        Account a = new Account(Name='Test Account',Corporate_Category__c='Rental',Market__c='AU',Mobile__c='1234567');
        a.BillingStreet ='Stan Avenue Street';
        	a.BillingCity ='Melbourne';
         	a.BillingCountry = 'Australia';
        	a.BillingPostalCode = '546546';
        	a.BillingState = 'Sydney';
        	a.ShippingCity = 'Melbourne';
        	a.ShippingCountry ='Australia';
        	a.ShippingPostalCode = '564665';
        	a.ShippingState = 'Sydney';
        	a.ShippingStreet = 'Montana Street';
        insert a;

        String jsonString = '{"searchField":"Name", "object": "Account", "filter": "Name = \'Test Account\'"}';
            Test.startTest();
            String responseString = strike_lookupController.getRecordLabel(jsonString);
            Test.stopTest();
            
            Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
            Map<string, Object> results = (Map<String, Object>)response.get('results');
            String objectLabel = String.valueOf(results.get('objectLabel'));
            
            System.assertEquals('Account', objectLabel); 
        }
    }

    @isTest 
    static void test_getData() {
        User u = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
        System.runAs(u) {
            Account a = new Account(Name='Test Account',Corporate_Category__c='Rental',Market__c='AU',Mobile__c='1234567');
            a.BillingStreet ='Stan Avenue Street';
            a.BillingCity ='Melbourne';
            a.BillingCountry = 'Australia';
            a.BillingPostalCode = '546546';
            a.BillingState = 'Sydney';
            a.ShippingCity = 'Melbourne';
            a.ShippingCountry ='Australia';
            a.ShippingPostalCode = '564665';
            a.ShippingState = 'Sydney';
            a.ShippingStreet = 'Montana Street';
            insert a;
            
            String jsonString = '{"searchField":"Name", "object": "Account", "filter": "Name = \'Test Account\'", "order": "Name", "limit": "5", "searchTerm": "Test"}';
            
            Test.startTest();
            String responseString = strike_lookupController.getRecords(jsonString);
            Test.stopTest();
            
            Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
            Map<string, Object> results = (Map<String, Object>)response.get('results');
            List<Object> data =(List<Object>)results.get('data');
            
            System.assertEquals(1, data.size());
            
            Map<String, Object> record = (Map<String, Object>)data.get(0);
            
            System.assertEquals(a.Id, record.get('value'));
        }
    }

    @isTest 
    static void test_getData_subtitleField() {
        User u = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
        System.runAs(u) {
            Account a = new Account(Name='Test Account',Corporate_Category__c='Rental',Market__c='AU',Mobile__c='1234567');
        a.BillingStreet ='Stan Avenue Street';
        	a.BillingCity ='Melbourne';
         	a.BillingCountry = 'Australia';
        	a.BillingPostalCode = '546546';
        	a.BillingState = 'Sydney';
        	a.ShippingCity = 'Melbourne';
        	a.ShippingCountry ='Australia';
        	a.ShippingPostalCode = '564665';
        	a.ShippingState = 'Sydney';
        	a.ShippingStreet = 'Montana Street';
        insert a;

        String jsonString = '{"searchField":"Name", "subtitleField": "Name", "object": "Account", "filter": "Name = \'Test Account\'", "searchTerm": "Test"}';

        Test.startTest();
        String responseString = strike_lookupController.getRecords(jsonString);
        Test.stopTest();

        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        Map<string, Object> results = (Map<String, Object>)response.get('results');
        List<Object> data =(List<Object>)results.get('data');

        System.assertEquals(1, data.size());

        Map<String, Object> record = (Map<String, Object>)data.get(0);

        System.assertEquals(a.Id, record.get('value'));
        }
    }
    
    @isTest 
    static void test_ValueLabel() {
        User u = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
        System.runAs(u) {
            Product2 productRec = new Product2( Name='BXCD', isActive=true);
            insert productRec;
            
            Test.startTest();
            String productName = strike_lookupController.ValueLabel(productRec.Id);
            Test.stopTest();
            
            System.assertEquals(productRec.Name, productName);
        }
    }

    @isTest 
    static void test_getData_addressField() {
        User u = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
        System.runAs(u) {
            Account a = new Account(Name='Test Account',Corporate_Category__c='Rental',Market__c='AU',Mobile__c='1234567',
                                    BillingStreet='Test Street',
                                    BillingCity='Test City',
                                    BillingState='Test State',
                                    BillingCountry='Test Country',
                                    BillingPostalCode='Test Postal Code');
            
            a.ShippingCity = 'Melbourne';
            a.ShippingCountry ='Australia';
            a.ShippingPostalCode = '564665';
            a.ShippingState = 'Sydney';
            a.ShippingStreet = 'Montana Street';
            insert a;
            
            String jsonString = '{"searchField":"Name", "subtitleField": "BillingAddress", "object": "Account", "filter": "Name = \'Test Account\'", "searchTerm": "Test"}';
            
            Test.startTest();
            String responseString = strike_lookupController.getRecords(jsonString);
            Test.stopTest();
            
            Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
            Map<string, Object> results = (Map<String, Object>)response.get('results');
            List<Object> data =(List<Object>)results.get('data');
            
            System.assertEquals(1, data.size());
            
            Map<String, Object> record = (Map<String, Object>)data.get(0);
            
            System.assertEquals(a.Id, record.get('value'));
        }
    }

    @isTest 
    static void test_getData_reference() {
        User u = createRetailCopyLCControllerTest.userSetup('System Administrator', 'AU');
        System.runAs(u) {
            Account a = new Account(Name='Test Account',Corporate_Category__c='Rental',Market__c='AU',Mobile__c='1234567');
        a.BillingStreet ='Stan Avenue Street';
        	a.BillingCity ='Melbourne';
         	a.BillingCountry = 'Australia';
        	a.BillingPostalCode = '546546';
        	a.BillingState = 'Sydney';
        	a.ShippingCity = 'Melbourne';
        	a.ShippingCountry ='Australia';
        	a.ShippingPostalCode = '564665';
        	a.ShippingState = 'Sydney';
        	a.ShippingStreet = 'Montana Street';
        insert a;

        Contact c = new Contact(LastName='Contact',
                                FirstName='Test',
                                Phone='0123456789',
                                Email='abc@test.com',
                                AccountId = a.Id);
        insert c;

        String jsonString = '{"searchField":"FirstName", "subtitleField": "Account.Name", "object": "Contact", "filter": "Name = \'Test Contact\'", "searchTerm": "Test"}';

        Test.startTest();
        String responseString = strike_lookupController.getRecords(jsonString);
        
        String jsonString2 = '{ "limit": "5", "object": "Contact", "order": "Name", "searchField": "Name", "subtitleField": "Email", "subsubtitleField": "Phone", "multiColSearch": "Email,Phone", "searchTerm": "test" }';
        responseString = strike_lookupController.getRecords(jsonString2);
        
        jsonString2 = '{ "limit": "5", "object": "Contact", "order": "Name", "searchField": "Name", "subsubtitleField": "Phone", "multiColSearch": "Email,Phone", "searchTerm": "test" }';
        responseString = strike_lookupController.getRecords(jsonString2);
        Test.stopTest();

        Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(responseString);
        Map<string, Object> results = (Map<String, Object>)response.get('results');
        List<Object> data =(List<Object>)results.get('data');

        //System.assertEquals(1, data.size());

        //Map<String, Object> record = (Map<String, Object>)data.get(0);

        //System.assertEquals(c.Id, record.get('value')); 
        }
    }
}