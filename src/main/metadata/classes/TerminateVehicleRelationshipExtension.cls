/**
** Onclicking on "Terminate VehicleRelationship" button,It will terminate all the vehicle_Relationship for the respective Vehicle
** and update End Date ,End reason and comments for all Vehicle Relationship records
** Created By: Sneha Chail
** Date: 2015-10-11
**/

public  class TerminateVehicleRelationshipExtension   
{
    //Variable Declaration 
    public Vehicle__c vehiclerec{get;set;}
    public String vehicleID{get;set;}
    public Vehicle_Relationship__c objVehicleRelation{get;set;} 
    public Account newacc{get;set;} 
    private List<Vehicle_Relationship__c> listvehicleRelation=new List<Vehicle_Relationship__c>();
   Public String End_Reason{get;set;} 
    Public String End_ReasonText{get;set;}  
   Public Date End_Date{get;set;} 
   Public User us{get;set;}
  public String selectedEndReason{get;set;}
   public String datename {get; set;}
     public terminateVehicleRelationshipExtension() {
       us = [select id,ContactID,Dealer_GC_Code__c,User_Type__c from User WHERE Id =:UserInfo.getUserId()];
         objVehicleRelation= new Vehicle_Relationship__c();  
         // this.vehicle= (Vehicle__c)controller.getRecord();
         // End_Date=objVehicleRelation.End_Date__c ; 
         newacc=new Account();
          vehicleID=ApexPages.currentPage().getParameters().get('ID');
          vehiclerec=[Select id,Name,UsVIN__c,Brand__c,Class__c,Model__c from Vehicle__c  where id=:vehicleID];
        //  objVehicleRelation=[select Contact__c,Start_Date__c,Car_Relation__c,Owner_Relation__c,End_Date__c from Vehicle_Relationship__c where End_Date__c=NULL AND Vehicle_ID__c=:vehicle.Id limit 1];
    }
    
    public List<SelectOption> getEndReason() {
        List<SelectOption> countryOptions = new List<SelectOption>();
        countryOptions.add(new SelectOption('','-None-'));
        countryOptions.add(new SelectOption('MBへの乗換','MBへの乗換'));
        countryOptions.add(new SelectOption('競合車への乗換','競合車への乗換'));
        countryOptions.add(new SelectOption('車の保有を止めた(売却)','車の保有を止めた(売却)'));
        countryOptions.add(new SelectOption('車の保有を止めた(譲渡)','車の保有を止めた(譲渡)'));
    /** countryOptions.add(new SelectOption('Warranty system','Warranty system'));
        countryOptions.add(new SelectOption('MB Online','MB Online'));  
        countryOptions.add(new SelectOption('DMS','DMS'));   **/

        countryOptions.add(new SelectOption('その他','その他'));
 
        return countryOptions;
    }
    
    /**  
     * @Description Gets all the records from Vehicle Relationship of the current associated Vehicle.  
     * @author  Sneha chail
     * @Date  28/10/2015(mm/dd/yy)  
     * @return all records of VehicleRelationship having current VehicleID
     * @see   TerminateVehicleRelationship(Vf Page)
    */    
    public List<Vehicle_Relationship__c> getlstVehicleRelation() { 
        us = [select id,ContactID,Dealer_GC_Code__c,User_Type__c from User WHERE Id =:UserInfo.getUserId()];     
          listvehicleRelation=[select Contact__c,Start_Date__c,Car_Relation__c,Owner_Relation__c,End_Date__c from Vehicle_Relationship__c where End_Date__c=NULL AND Vehicle_ID__c=:vehicleID];
         
          return listvehicleRelation;
    }
    /**  
     * @Description Update End_Date__c,End_Reason__c,End_Setting_User__c and End_Setting_DateTime__c of the selected vehicleRelationships
     * @author  Sneha chail
     * @Date  28/10/2015(mm/dd/yy)  
     * @return Redirect to the parent page of Vehicle record.
     * @see   TerminateVehicleRelationship(Vf Page)
    */ 
    public PageReference SaveRecords() {
           
           
       List<Vehicle_Relationship__c> lstVehiRelation=new List<Vehicle_Relationship__c>();
       getlstVehicleRelation();
            for(Vehicle_Relationship__c veR:listvehicleRelation){
               veR.End_Date__c=newacc.Dealer_Active_to__c;
               veR.End_Reason__c=selectedEndReason;
               veR.Comments__c=End_ReasonText;
               veR.End_Setting_User__c=UserInfo.getUserId();
               veR.End_Setting_DateTime__c=system.now();
               lstVehiRelation.add(veR);
            }
            system.debug('###@@@@@ lstVehiRelation'+lstVehiRelation);
        try {   
            if(lstVehiRelation.size()>0)
            Database.SaveResult[] lsr = Database.update(lstVehiRelation,false);
            
         } catch(System.DMLException e) {
            ApexPages.addMessages(e);          
         }
          system.debug('###@@@@@ lstVehiRelation'+lstVehiRelation);
        //  After successful Save, navigate to the default view page
         
        return new PageReference('/' + vehicleid);
    }
    /**  
     * @Description Redirect to the parent page of Vehicle record.
     * @author  Sneha chail
     * @Date  28/10/2015(mm/dd/yy)  
     * @return Redirect to the parent page of Vehicle record.
     * @see   TerminateVehicleRelationship(Vf Page)
    */ 
    public pageReference cancelpage() {
    
return new PageReference('/' + vehicleid);
         
    } 
}