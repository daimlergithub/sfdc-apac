public class ContractRetailTask
{

    public ContractRetailTask(RetailTask controller) {

    }

public ContractRetailTask() 
{
}
public list<Retail_Task__c>Contractlist{get;set;}
public id acc;
public ContractRetailTask(apexpages.standardcontroller controller)
{
    acc= ApexPages.currentPage().getParameters().get('id');
    Contractlist=[Select Account__c,ContractNumber__c,Type__c,Status__c,StartDate__c,EndDate__c,Duration__c,ApplicationDate__c,Related_Dealer__c,Related_Vehicle__c,VIN__c,Membership_Accept_Date__c,Contract_Cancellation_Date__c,Product_Name__c,Total_Split_Payment__c,Balance_Update_Date__c from Retail_Task__c  where Related_Contact__c=:acc and Recordtype.name=:'Loan Contract'];
}
}