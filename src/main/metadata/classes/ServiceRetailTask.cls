public class ServiceRetailTask
{
	public ServiceRetailTask(ApexPages.StandardSetController controller) 
	{
		
	}
public list<Retail_Task__c> retlist{get;set;}
public id acc;
public ServiceRetailTask(apexpages.standardcontroller controller)
	{
		acc= ApexPages.currentPage().getParameters().get('id');
		if(acc!=null)
		{
			retlist=[Select Name,Related_Contact__r.Name,Service_Number__c,Service_Code__c,Service_Vehicle__c,Service_Date__c,Service_Details__c,Service_Date_In__c,Service_Date_Out__c,Service_Mileage__c,Service_Invoice_Number__c,Service_Vehicle__r.Name,Related_Lead__r.Name,Related_Contact2__r.Name,Related_Contact3__r.Name,Service_Vehicle_VIN__c,Related_Dealer__r.Name,Recordtype.Name from Retail_Task__c  where Related_Contact__c=:acc and Recordtype.name=:'Service'];
		}
	}
}