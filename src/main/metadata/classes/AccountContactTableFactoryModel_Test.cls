@isTest
public class AccountContactTableFactoryModel_Test {
    @isTest
    public static void testcomnFields(){
        test.startTest();
        AccountContactTableFactoryModel.fieldsAvailabilityWrapper  wrap 
            = new AccountContactTableFactoryModel.fieldsAvailabilityWrapper('AU', 'Test', 
                                                                            'test', 'Test', true, 
                                                                            true, false);
        
        AccountContactTableFactoryModel.japanMarketFields();
        List<AccountContactTableFactoryModel.fieldsAvailabilityWrapper> fieldWrap = AccountContactTableFactoryModel.commonFields();
        system.assertNotEquals(null, fieldWrap.size());
        test.stopTest();
    }
	
}