public class LeaseRetailTask
{
public LeaseRetailTask() 
{
}
public list<Retail_Task__c>Leaselist{get;set;}
public id acc;
public LeaseRetailTask(apexpages.standardcontroller controller)
{
    acc= ApexPages.currentPage().getParameters().get('id');
    Leaselist=[Select Name,Common_Comments__c,Maximum_lease_extention_Date__c,Re_lease_Prohibit_flag__c,Source_System__c,Status__c,Suspend_Payment__c,Balance_Update_Date__c,Loan_Principal__c,Parent_Flag__c,Split_Payment_Comission_Fee__c,Total_Split_Payment__c from Retail_Task__c  where Account__c=:acc and Recordtype.name=:'Lease Contract'];
}
}