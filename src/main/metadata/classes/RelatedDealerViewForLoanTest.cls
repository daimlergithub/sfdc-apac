@isTest
public class RelatedDealerViewForLoanTest
{
    public static Retail_Task__c Loann;
    static Testmethod void ValidateLoan()
        {
            Loann=new Retail_Task__c();
            Loann.Bank_Account_Name_Native__c='Test1';
            Loann.Bank_Account_Name__c='may';
            Loann.Actual_Maturity_Date__c=date.today()-10;
            Loann.Contractor_Address1_Native__c='Vcs';
            Loann.Contractor_Address1__c='Test2';
            Loann.Annual_Income__c=10000;
            Loann.Balloon_RV_Amount__c=2000;
            Loann.Bonus_Amount1__c=250;
            Loann.Bonus_Amount2__c=300;
            Loann.Bonus_Month1__c='200';
            Loann.Bonus_Month2__c='250';
            Loann.Campaign_Description__c='Test3';
            Loann.Contractor_BirthDate__c=date.today();
            Loann.Contractor_Company_Name_Native__c='Test5';
            Loann.Contractor_Company_Name__c='ccs';
            Loann.Contractor_Mail__c='jsdn@gmail.com';
            Loann.Contractor_Gender__c='male';
            Loann.Credit_Loan_Company_Name__c='Test4';
        insert Loann;
        Test.StartTest();
        ApexPages.currentPage().getParameters().put('Id',Loann.id);
        ApexPages.StandardController controller = new ApexPages.StandardController(Loann);
        RelatedDealerViewForLoan Lo= new RelatedDealerViewForLoan(controller);
        Test.StopTest();
        }
}