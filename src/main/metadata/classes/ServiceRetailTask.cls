public class ServiceRetailTask
{

    public ServiceRetailTask(ApexPages.StandardController controller) {

    }


private integer counter=0;  //keeps track of the offset
   private integer list_size=5; //sets the page size or number of rows
   public integer total_size; //used to show user the total size of the list
  public list<Retail_Task__c> retlist{get;set;}
   public id acc;
    public ServiceRetailTask(ApexPages.StandardSetController controller) 
    {
    acc= ApexPages.currentPage().getParameters().get('id');
     total_size = [select count() from Retail_Task__c where ( (Related_Contact__c=:acc) OR (Related_Contact2__c=:acc) OR (Related_Contact3__c=:acc) OR (Related_Contact4__c=:acc)) and Recordtype.name=:'Service'];   
    System.debug('%^%^%^%^% total_size'+total_size);
    }

 public Retail_Task__c[] getNumbers() {
    {
    try
    {
        acc= ApexPages.currentPage().getParameters().get('id');
        if(acc!=null)
        {
         System.debug('%^%^%^%^% counter'+counter);
            retlist=[Select Name,Related_Contact__r.Name,Service_Number__c,Service_Code__c,Service_Vehicle__c,Service_Date__c,Service_Details__c,Service_Date_In__c,Related_Contact2__c,Related_Contact3__c,Related_Contact4__c,Service_Date_Out__c,Service_Mileage__c,Service_Invoice_Number__c,Service_Vehicle__r.Name,Related_Lead__r.Name,Related_Contact2__r.Name,Related_Contact3__r.Name,Service_Vehicle_VIN__c,Related_Dealer__r.Name,Recordtype.Name from Retail_Task__c  where ( (Related_Contact__c=:acc) OR (Related_Contact2__c=:acc) OR (Related_Contact3__c=:acc) OR (Related_Contact4__c=:acc)) and Recordtype.name=:'Service'   ORDER BY Service_Date__c DESC limit :list_size offset :counter ];
        }
         System.debug('%^%^%^%^% retlist'+retlist);
        return retlist;
      } catch (QueryException e) {
         ApexPages.addMessages(e);   
         return null;
      }
    }
}

public PageReference Beginning() { //user clicked beginning
      counter = 0;
      return null;
   }

   public PageReference Previous() { //user clicked previous button
      counter -= list_size;
      return null;
   }

   public PageReference Next() { //user clicked next button
      counter += list_size;
      return null;
   }

   public PageReference End() { //user clicked end
   System.debug('total_size'+total_size);
   System.debug('list_size'+list_size);
      counter = total_size - math.mod(total_size, list_size);
      return null;
   }
 
}