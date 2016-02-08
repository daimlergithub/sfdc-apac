@isTest
public class CustomLogUtilTest {
    public static testMethod void testCustomLoggingEntry() {        
        CustomLogUtil cl =new CustomLogUtil();
        CustomLogUtil.CustomLoggingEntry('debugString');
        CustomLogUtil.DebugLogInsert();
    } 
	
	

}