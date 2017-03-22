@isTest
public class RelatedDealerViewForInsuranceTest
{
    public static Retail_Task__c Ins;
    static Testmethod void ValidateInsurance()
        {
            Ins=new Retail_Task__c();
            Ins.Contractor_Address1__c='Test1';
            Ins.Booking_Month__c='may';
            Ins.Condition_Change__c='Test2';
            Ins.Premium_Change__c=3465;
            Ins.Company_Name__c='Vcs';
            Ins.Contractor_BirthDate__c=date.today()-10;
            Ins.Contractor_Name__c='rama';
            Ins.Contractor_Name_Native__c='rama1';
            Ins.Condition_Change_Date__c=date.today()-5;
            Ins.Insurance_Company__c='vccs';
            Ins.Insured_Name_Native__c='vccs1';
            Ins.Net_Premium__c=123.00;
            Ins.Net_Premium2__c=456.00;
            Ins.Net_Premium3__c=789.00;
            Ins.Non_MB_Insurance__c='Test4';
            Ins.Outlet_Name__c='Test5';
            Ins.Payment_Method__c='cash';
            Ins.Contractor_Phone1__c='7598623345';
            Ins.Vehicle_Registration_No__c='456738';
            Ins.Contractor_ZipCode1__c='5600032';
        insert Ins;
        Test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',Ins.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(Ins);
        RelatedDealerViewForInsurance I= new RelatedDealerViewForInsurance(controller);
        Test.StopTest();
		
		
        }
}