public class LoanRetailTask
{
public LoanRetailTask() 
{
}
public list<Retail_Task__c>loanlist{get;set;}
public id acc;
public LoanRetailTask(apexpages.standardcontroller controller)
{
    acc= ApexPages.currentPage().getParameters().get('id');
    loanlist=[Select Name,Bank_Account_Name__c,Actual_Maturity_Date__c,Loan_Remaining_Bal_Baloon_Dealer__c,Common_Comments__c,Credit_Loan_Company_Name__c,Parent_Number__c,First_Installment_Amount__c,Loan_Principal__c,Parent_Flag__c,Source_System__c,Status__c,Suspend_Payment__c,Split_Payment_Comission_Fee__c,Total_Split_Payment__c,Balance_Update_Date__c from Retail_Task__c  where Account__c=:acc and Recordtype.name=:'Loan Contract'];
}
}