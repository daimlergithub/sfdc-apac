public class OrderHelper
{
     public static void Populate_VehicleClass(list<Preorder__c> Orderlist)
    {
        List<Preorder__c> UpdOrderlist= new List<Preorder__c>();

        for(Preorder__c Ord: Orderlist)
        {
            if(Ord.Vehicle_Model_Code__c != null)
                Ord.Vehicle_Model_Class__c = Vehicle_Class_mapping__c.getAll().get(Ord.Vehicle_Model_Code__c).Vehicle_Model_Class__c;
        }   
    }
}