@isTest
public class SObjectCloneCtrlTest {
	@isTest
    public static void test() {
        Account a = new Account(Name = 'asdf');
        insert a; 
        SObjectCloneCtrl.getSObjRecordWithAllFields(a.Id);
    }
}