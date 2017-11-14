@isTest
public class ConsentHistoryInlinepage_TH_Ctrl_Test{
    static testMethod void testConsent(){
        Account accTest = new Account();
        accTest.Name = 'Test Consent';
        accTest.Mobile__c = '123456789';
        insert accTest;
        Test.StartTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(accTest);
        ConsentHistoryInlinepage_TH_Ctrl consHist = new ConsentHistoryInlinepage_TH_Ctrl(sc);
        PageReference pageref = Page.ConsentHistoryInlinePage_TH;
        pageref.getParameters().put('id',String.valueOf(accTest.Id));
        Test.setCurrentPage(pageref);
        Test.StopTest();
    }
}