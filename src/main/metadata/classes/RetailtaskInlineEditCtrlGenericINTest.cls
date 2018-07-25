/**
** Class: RetailtaskInlineEditCtrlGenericINTest 
** Description: Test Class for RetailtaskInlineEditControllerGeneric for IN market
** Created By: Prem Kumar
** Date: 22/05/2018
**/
@IsTest
public class RetailtaskInlineEditCtrlGenericINTest {
    @IsTest
    public static void baseFunctionalityTest(){
        test.startTest();
        User usr = TestUtils.createGenericAdminUser('India', 'Asia/Kolkata', 'IN');
        
        System.runAs(usr){
            Retail_Task__c retailtaskref = new Retail_Task__c (Market__c = 'IN');
          insert retailtaskref;
            ApexPages.StandardController sc = new ApexPages.StandardController(retailtaskref);
            ApexPages.currentPage().getParameters().put('id', retailtaskref.Id);
            RetailtaskInlineEditControllerGeneric rec = new RetailtaskInlineEditControllerGeneric (sc);
        }
        test.stopTest();
    }
}