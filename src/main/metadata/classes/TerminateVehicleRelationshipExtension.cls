/**
** Onclicking on "Terminate VehicleRelationship" button,It will terminate all the vehicle_Relationship for the respective Vehicle
** and update End Date ,End reason and comments for all Vehicle Relationship records
** Created By: Sneha Chail
** Date: 2015-10-11
Modified by	: Venky
Modification Date : 2017-2-12
Description : Dealer USers are not able to select End Date,End Reason ,End Reason due to sharing security reason, given permission on updated code.
Fix : End Date,End Reason ,End Reason Test fields are given permission to dealer user
**/

public class TerminateVehicleRelationshipExtension   
{
    //Variable Declaration 
    public Vehicle__c vehicle{get;set;}
    public Vehicle_Relationship__c objVehicleRelation{get;set;} 
    private List<Vehicle_Relationship__c> listvehicleRelation=new List<Vehicle_Relationship__c>();
 
     public terminateVehicleRelationshipExtension(ApexPages.StandardController controller) {
          objVehicleRelation= new Vehicle_Relationship__c();
          this.vehicle= (Vehicle__c)controller.getRecord();
    }
    /**  
     * @Description Gets all the records from Vehicle Relationship of the current associated Vehicle.  
     * @author  Sneha chail
     * @Date  28/10/2015(mm/dd/yy)  
     * @return all records of VehicleRelationship having current VehicleID
     * @see   TerminateVehicleRelationship(Vf Page)
    */    
    public List<Vehicle_Relationship__c> getlstVehicleRelation() {      
          listvehicleRelation=[select Contact__c,Start_Date__c,Car_Relation__c,Owner_Relation__c,End_Date__c from Vehicle_Relationship__c where End_Date__c=NULL AND Vehicle_ID__c=:vehicle.Id];
          return listvehicleRelation;
    }
    /**  
     * @Description Update End_Date__c,End_Reason__c,End_Setting_User__c and End_Setting_DateTime__c of the selected vehicleRelationships
     * @author  Sneha chail
     * @Date  28/10/2015(mm/dd/yy)  
     * @return Redirect to the parent page of Vehicle record.
     * @see   TerminateVehicleRelationship(Vf Page)
    */ 
    public PageReference Save() {
           
       List<Vehicle_Relationship__c> lstVehiRelation=new List<Vehicle_Relationship__c>();
       getlstVehicleRelation();
            for(Vehicle_Relationship__c veR:listvehicleRelation){
               veR.End_Date__c=objVehicleRelation.End_Date__c;
               veR.End_Reason__c=objVehicleRelation.End_Reason__c;
               veR.Comments__c=objVehicleRelation.Comments__c;
               veR.End_Setting_User__c=UserInfo.getUserId();
               veR.End_Setting_DateTime__c=system.now();
               lstVehiRelation.add(veR);
            }
        try {   
            if(lstVehiRelation.size()>0)
            update lstVehiRelation;
         } catch(System.DMLException e) {
            ApexPages.addMessages(e);          
         }
        //  After successful Save, navigate to the default view page
        PageReference redirectSuccess = new ApexPages.StandardController(this.vehicle).view();
        return (redirectSuccess);
    }
    /**  
     * @Description Redirect to the parent page of Vehicle record.
     * @author  Sneha chail
     * @Date  28/10/2015(mm/dd/yy)  
     * @return Redirect to the parent page of Vehicle record.
     * @see   TerminateVehicleRelationship(Vf Page)
    */ 
    public PageReference cancel() {
        PageReference redirectSuccess = new ApexPages.StandardController(this.vehicle).view();
        return (redirectSuccess);
    } 
}