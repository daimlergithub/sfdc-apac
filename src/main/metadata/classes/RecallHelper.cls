
/**
**  User Story: US-CP-022
**1.If VIN of recall record matches UsVin of one vehicle record, 
        system will link the recall record to this vehicle record automatically. 
        System flags ?Recall? on related vehicle, vehicle relationship and customer record automatically.
**2.If VIN of recall record matches UsVin of one vehicle record, and if system deletes recall record, 
       system removes ?Recall? flag on related vehicle, vehicle relationship and customer record automatically.
              
** Created By: Sichao Lai,Lio Huang
** Date: 2013-06-07,2013-11-05

**Modified By : sriram
**Modified date : 2015-10-27
**/


public with sharing class RecallHelper {
	
	
	/**    
     * @Description : Gets the old recall records and extracts vehicle ids.
     * @author      : Sichao Lai,Lio Huang
     * @Date        : 2013-06-07,2013-11-05
     * @param       : all the old recall records 
     * @return      : returns set of vehicle ids.
     * @see         : TriggerRecallTriggerHandler
    **/	


    public static void beforeDeleteEvent(List<Recall__c> recallOld)
    {
        Set<Id> VehicleIds = new Set<Id>();
        // get VIN and Vehicle ID from Recall
        if(recallOld!=Null && (!recallOld.isEmpty())){
           for (Recall__c r : recallOld)
            {
                VehicleIds .add(r.Vehicle_ID__c);
            }
            // update Recall checkbox status
          if (VehicleIds!=null && (!VehicleIds.IsEmpty()))
            {
               removeRecall(VehicleIds);
            } 
        }
    }
    
    /**    
     * @Description : Gets the new recall records and extracts vehicle ids.
     * @author      : Sichao Lai,Lio Huang
     * @Date        : 2013-06-07,2013-11-05
     * @param       : all the new  recall records 
     * @return      : returns set of vehicle ids.
     * @see         : TriggerRecallTriggerHandler
    **/	
    public static void AfterInsertEvent(List<Recall__c> recallNew)
       {
        Set<Id> VehicleIds = new Set<Id>();
        // get VIN and Vehicle ID from Recall
        if (recallNew!=null && (!recallNew.IsEmpty())){
            for (Recall__c r : recallNew)
            {
                VehicleIds .add(r.Vehicle_ID__c);
            }
            // update Recall checkbox status
            if(VehicleIds!=null && (!VehicleIds.IsEmpty()))
            {
               updateRecall(VehicleIds);
            } 
         }
      }
   
     
   /**    
     * @Description : Update Recall for Vehicle Relationship, Vehicle, Customer.
     * @author      : Sichao Lai,Lio Huang
     * @Date        : 2013-06-07,2013-11-05
     * @param       : gets the vehicle ids to be processed.
     * @return      : returns list of sObjects whitch are to be updated.
     * @see         : AfterInsertEvent
    **/	
    public static void updateRecall(Set<Id> vehicleIds) {
    
        List<SObject> objectsToUpdate = new List<SObject>();
        Set<Id> customerIds = new Set<Id>();
        if(vehicleIds!=Null && (!vehicleIds.isEmpty())) {    
            for(Vehicle_Relationship__c vr : [select Id, Contact__c, Recall__c from Vehicle_Relationship__c where Vehicle_ID__c in :vehicleIds])
            {
                vr.Recall__c = true;
                customerIds.add(vr.Contact__c);
                objectsToUpdate.add(vr);
            }
            
            for(Vehicle__c v : [select Id, Recall__c from Vehicle__c where Id in :vehicleIds]) {
                v.Recall__c = true;
                objectsToUpdate.add(v);
            }
        }
        if(customerIds!=Null && (!customerIds.isEmpty())) {    
            for(Account acc : [select Id, Recall__c from Account where Id in :customerIds ]) {
                acc.Recall__c = true;
                objectsToUpdate.add(acc);
            }
        }
        if(objectsToUpdate!=null && !objectsToUpdate.IsEMpty()) {
            UtilSobject.updateSobjects(objectsToUpdate);
        }
    }
    
    /**    
     * @Description : remove Recall for Vehicle Relationship, Vehicle, Customer.
     * @author      : Sichao Lai,Lio Huang
     * @Date        : 2013-06-07,2013-11-05
     * @param       : gets the vehicle ids to be processed.
     * @return      : returns list of sObjects whitch are to be updated.
     * @see         : beforeDeleteEvent
    **/	
    public static void removeRecall(Set<Id> vehicleIds) {
    
        List<SObject> objsToUpdate = new List<SObject>();
        Set<Id> accIds = new Set<Id>();
              
        for(Vehicle_Relationship__c vr : [select Id, Contact__c, Recall__c from Vehicle_Relationship__c where Vehicle_ID__c in :vehicleIds])
        {
            vr.Recall__c = false;
            accIds.add(vr.Contact__c);
            objsToUpdate.add(vr);
        }
        
        for(Vehicle__c v : [select Id, Recall__c from Vehicle__c where Id in :vehicleIds]) {
            v.Recall__c = false;
            objsToUpdate.add(v);
        }
        
        for(Account acc : [select Id, Recall__c from Account where Id in :accIds ]) {
            acc.Recall__c = false;
            objsToUpdate.add(acc);
        }
        
        if(objsToUpdate!=null && !objsToUpdate.IsEMpty()) {
            UtilSobject.updateSobjects(objsToUpdate);
        }
    }
}