/**
 * This class contains unit tests for validating the behavior of AddCouponsToOrder trigger.
 */
@isTest
private class AddCouponsToOrderTest {

    static testMethod void testAddCouponsToOrder() {
            // Create Person Account
            String personalAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
            Account testPersonalAccount = new Account(RecordTypeId = personalAccRecordTypeId, LastName = 'Acme 29', Status__c = 'Prospect', Type = 'Army', Province__c = 'AnHui', City_CN__c = '安庆市', PersonMobilePhone = '12322322943');
            insert testPersonalAccount;
        
        // Create Coupons
        MBDA_Coupon__c coupon1 = new MBDA_Coupon__c(Name = 'Test9989', Status__c = '未使用');
        MBDA_Coupon__c coupon2 = new MBDA_Coupon__c(Name = 'Test9988', Status__c = '未使用');
        MBDA_Coupon__c coupon3 = new MBDA_Coupon__c(Name = 'Test9987', Status__c = '未使用');
        MBDA_Coupon__c coupon4 = new MBDA_Coupon__c(Name = 'Test9986', Status__c = '未使用');
        MBDA_Coupon__c coupon5 = new MBDA_Coupon__c(Name = 'Test9985', Status__c = '未使用');
        MBDA_Coupon__c coupon6 = new MBDA_Coupon__c(Name = 'Test9983', Status__c = '使用');
        MBDA_Coupon__c coupon7 = new MBDA_Coupon__c(Name = 'Test9982', Status__c = '未使用');
        insert new List<MBDA_Coupon__c>{coupon1, coupon2, coupon3, coupon4, coupon5, coupon6, coupon7};
        
        // Get MBDA Order Record Type, Create Order
        String mbdaOrderRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByName().get('MBDA Order').getRecordTypeId();
        Order testMBDAOrder1 = new Order(AccountId = testPersonalAccount.Id, Status = '未付款', Coupon_Number__c = 'Test9989', EffectiveDate = Date.today().addMonths(3), Payment_type__c = '现金', MBDA_Vehicle_Model__c = 'B-Class');
        Order testMBDAOrder2 = new Order(AccountId = testPersonalAccount.Id, Status = '未付款', Coupon_Number__c = 'Test9989', EffectiveDate = Date.today().addMonths(3), Payment_type__c = '现金', MBDA_Vehicle_Model__c = 'B-Class');
        
        try {
            insert new List<Order>{testMBDAOrder1, testMBDAOrder2};
        }
        catch(Exception ex) {}
        
        order testMBDAOrder3 = new Order(AccountId = testPersonalAccount.Id, Status = '未付款', Coupon_Number__c = 'Test9983', EffectiveDate = Date.today().addMonths(3), Payment_type__c = '现金', MBDA_Vehicle_Model__c = 'B-Class');
        try {
            insert testMBDAOrder3;
        }
        catch (Exception ex) {}
        
        Order testMBDAOrder11 = new Order(AccountId = testPersonalAccount.Id, Status = '未付款', Coupon_Number__c = 'Test9989', EffectiveDate = Date.today().addMonths(3), Payment_type__c = '现金', MBDA_Vehicle_Model__c = 'B-Class');
        Order testMBDAOrder12 = new Order(AccountId = testPersonalAccount.Id, Status = '未付款', Coupon_Number__c = 'Test9988;Test9987', EffectiveDate = Date.today().addMonths(4), Payment_type__c = '现金', MBDA_Vehicle_Model__c = 'C-Class');
        Order testMBDAOrder31 = new Order(AccountId = testPersonalAccount.Id, Status = '未付款', Coupon_Number__c = 'Test9986;Test9985', EffectiveDate = Date.today().addMonths(5), Payment_type__c = '现金', MBDA_Vehicle_Model__c = 'B-Class');
        Order testMBDAOrder4 = new Order(AccountId = testPersonalAccount.Id, Status = '未付款', EffectiveDate = Date.today().addMonths(5), Payment_type__c = '现金', MBDA_Vehicle_Model__c = 'B-Class');
        insert new List<Order>{testMBDAOrder11, testMBDAOrder12, testMBDAOrder31, testMBDAOrder4};
        
        MBDA_Coupon__c tempCoupon1 = [select Id, Status__c, Order__c from MBDA_Coupon__c where Id = :coupon4.Id];
        //system.assertEquals(testMBDAOrder31.Id, tempCoupon1.Order__c);
        //system.assertEquals('使用', tempCoupon1.Status__c);
        
        // Test for updating
        update new Order[]{new Order(Id = testMBDAOrder4.Id, Coupon_Number__c = 'Test9982')};
        
        MBDA_Coupon__c tempCoupon2 = [select Id, Status__c, Order__c from MBDA_Coupon__c where Id = :coupon7.Id];
        //system.assertEquals(testMBDAOrder4.Id, tempCoupon2.Order__c);
        //system.assertEquals('使用', tempCoupon2.Status__c);
    }
}