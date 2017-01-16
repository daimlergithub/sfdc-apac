public class InsuranceRetailTask
{
public InsuranceRetailTask(ApexPages.StandardSetController controller) 
{
}
public list<Retail_Task__c> inslist{get;set;}
public id acc;
public InsuranceRetailTask(apexpages.standardcontroller controller)
{
    acc= ApexPages.currentPage().getParameters().get('id');
    inslist=[Select ContractNumber__c,Name,Contract_Invalid_Flag__c,StartDate__c,EndDate__c,ApplicationDate__c,Contract_Category__c,Related_Vehicle__c,VIN__c,Common_Comments__c from Retail_Task__c  where Related_Contact__c=:acc and Recordtype.Name=:'Insurance Contract'];
}
}