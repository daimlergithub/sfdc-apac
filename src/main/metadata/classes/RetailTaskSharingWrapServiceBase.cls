/**
** Wrap service for retail tasks to share.
** 1. Shares "Contract" retail tasks to active users of active dealers, who have both read access to the related person account and vehicle.
** 2. Shares "Retail Activity" retail tasks to active users of the related dealer and the active dealers with the same CRM Code.
** 3. Shares "Service" retail tasks to active users of the related dealer and the active dealers with the same CRM Code.
** 
** Created By: Sushma
** Date: 23-02-2018
**/
public with sharing class RetailTaskSharingWrapServiceBase {
    public RetailTaskSharingWrapServiceBase() {
    }

   /**  
     * @Description Gets all the required fields of retail tasks then wraps those retail tasks by record type.  
     * @author  Sneha chail
     * @Date 10/26/2015(mm/dd/yy)
     * @param  retailTasks is a list having all the new records of Retail_Task Object.
     * @return all records having Contract,Retail Activity and service recordtype to the list 
     * @see   TriggerRetailTaskTriggerHandler(RetailTaskSharingWrapServiceBase.wrapRetailTasks)
     */    
    public List<SharingWrapper> wrapRetailTasks(List<Retail_Task__c> retailTasks, String market) {       
        List<SharingWrapper> wrappers = new List<SharingWrapper>();
        List<Retail_Task__c> contracts = new List<Retail_Task__c>();
        List<Retail_Task__c> retailActivities = new List<Retail_Task__c>();
        List<Retail_Task__c> services = new List<Retail_Task__c>();
        List<Retail_Task__c> servicesVehDealer = new List<Retail_Task__c>();  
        User loggedInUser = [select Id, Market__c from User where Id = :UserInfo.getUserId()];                        
        
        for(Retail_Task__c retailTask : retailTasks) {       
            if(UtilRecordType.getRecordTypeNameByName('Retail_Task__c','Contract').equalsIgnoreCase('Contract')){
                    contracts.add(retailTask);
                }
             else if(UtilRecordType.getRecordTypeNameByName('Retail_Task__c','Retail Activity').equalsIgnoreCase('Retail Activity') && String.isNotBlank(retailTask.Related_Dealer__r.Dealer_DMS_CRM_Code__c)){
                  retailActivities.add(retailTask);                
                 } 
             else { 
                    services.add(retailTask);
                    //SB2018
                    // Checking all records having Services recordtype and vehicle and dealer data 
                    if(retailTask.Related_Dealer__c!=null && retailTask.Related_Vehicle__c!=null && loggedInUser.Market__c==market && retailTask.Related_Vehicle__r.Related_Dealer__c==retailTask.Related_Dealer__c){
                        servicesVehDealer.add(retailTask);
                    }
                 }
              }          
                  
      // Adding all records having Contract recordtype to the list 
       if(!contracts.isEmpty()){
            wrappers.addAll(wrapContracts(contracts));
          }
      // Adding all records having Retail Activity recordtype to the list 
       if(!retailActivities.isEmpty()){
            wrappers.addAll(wrapRetailActivities(retailActivities));
          }
       // Adding all records having Services recordtype to the list 
       if(!services.isEmpty()){
           wrappers.addAll(wrapServices(services,market));
          }  
          
        //SB2018  
       // Adding all records having Services recordtype and vehicle and dealer data to the list 
       if(!servicesVehDealer.isEmpty()){
           wrappers.addAll(wrapServicesVehDealer(servicesVehDealer));
          }           
       return wrappers;
    }
     /**    
     * @Description Wraps "Contract" retail tasks.
     * @Description Users to share are decidied by their access to contrats' vehicle and dealer.    
     * @author  Sneha chail
     * @Date 10/26/2015(mm/dd/yy)
     * @param  all records having Contract recordtype to the list .
     * @return read permission to to the dealers who has access to both related dealer and related vehicle.
     * @see   wrapRetailTasks
     */
  
    public List<SharingWrapper> wrapContracts(List<Retail_Task__c> contracts) { 
        UserService userService = new UserService();
        Map<Id, Set<Id>> contract2Users = userService.mapRetailTaskContract2Users(contracts);

        return SharingWrapperService.wrapSharings(contract2Users, Schema.Retail_Task__Share.RowCause.Contract_Share__c,UtilConstant.read_Access);
    }

    /** 
     * @Description Wraps "Service" retail tasks.
     *              Users to share are decidied by their access to contrats' vehicle and dealer.    
     * @author  Sneha chail
     * @Date 10/26/2015(mm/dd/yy)
     * @param  all records having Service recordtype to the list .
     * @return read permission to to the dealers who has access to both related dealer and related vehicle.
     * @see   wrapRetailTasks
     */
    public List<SharingWrapper> wrapServices(List<Retail_Task__c> services, String market) {
        User loggedInUser = [select Id, Market__c from User where Id = :UserInfo.getUserId()];
        if(loggedInUser.Market__c==market)
        {
            return wrapRetailTasksGeneric(Schema.Retail_Task__Share.RowCause.Service_Share__c, services,UtilConstant.edit_Access);
        }
        return wrapRetailTasks(Schema.Retail_Task__Share.RowCause.Service_Share__c, services,UtilConstant.read_Access);
    }
    
    
     /**    
     * @Description Wraps "Retail Activity" retail tasks.
     *              Users to share are decidied by their access to contrats' vehicle and dealer.    
     * @author  Sneha chail
     * @Date 10/26/2015(mm/dd/yy)
     * @param  all records having Retail Activity recordtype to the list .
     * @return read permission to to the dealers who has access to both related dealer and related vehicle.
     * @see   wrapRetailTasks
     */
    public List<SharingWrapper> wrapRetailActivities(List<Retail_Task__c> retailActivities) {
        return wrapRetailTasks(Schema.Retail_Task__Share.RowCause.Retail_Activity_Share__c, retailActivities,UtilConstant.read_Access);
    }
     /**    
     * @Description Wraps "Retail Activity" retail tasks.
     *              Users to share are decidied by their access to contrats' vehicle and dealer.    
     * @author  Sneha chail
     * @Date 10/26/2015(mm/dd/yy)
     * @param  RowCause for Retail_task_Share__c and all records of retail_task__c object and access level
     * @return read permission to to the dealers who has access to both related dealer and related vehicle.
     * @see   wrapRetailTasks
     */
    private List<SharingWrapper> wrapRetailTasks(String rowCause, List<Retail_Task__c> retailTasks, String accessLevel) {
        UserService userService = new UserService();
        Map<String, Set<Id>> crmCode2Users = userService.mapCrmCode2Users(retailTasks);
        Map<Id, Set<Id>> retailTask2Users = new Map<Id, Set<Id>>();
        for(Retail_Task__c retailTask : retailTasks) {
            if(crmCode2Users.get(retailTask.Related_Dealer__r.Dealer_DMS_CRM_Code__c) != null){
                retailTask2Users.put(retailTask.Id, crmCode2Users.get(retailTask.Related_Dealer__r.Dealer_DMS_CRM_Code__c));
            }
        }

        return SharingWrapperService.wrapSharings(retailTask2Users, rowCause, accessLevel);
    }
    
    /*Specific to TH and MY market*/
    private List<SharingWrapper> wrapRetailTasksGeneric(String rowCause, List<Retail_Task__c> retailTasks, String accessLevel) {
        UserService userService = new UserService();
        List<Retail_Task__c> retailTasksLst=[select Id,Service_Dealer__c,Service_Dealer__r.Dealer_ND_Code__c from Retail_Task__c where Id IN:retailTasks];
        Map<String, Set<Id>> dealerNdCode2Grp = userService.mapDealerNdCode2GrpGeneric(retailTasksLst);
        Map<Id, Set<Id>> retailTask2Grp = new Map<Id, Set<Id>>();
        User loggedInUser = [select Id, Market__c from User where Id = :UserInfo.getUserId()];        
        for(Retail_Task__c retailTask : retailTasksLst) {
            String grpName=loggedInUser.market__c+retailTask.Service_Dealer__r.Dealer_ND_Code__c;
            if(dealerNdCode2Grp.get(grpName) != null){
                retailTask2Grp.put(retailTask.Id, dealerNdCode2Grp.get(grpName));
            }
        }

        return SharingWrapperService.wrapSharings(retailTask2Grp, rowCause, accessLevel);
    }
    /*
     *@Specific for TH and MY market
     *@author tejbir Singh
     *@Share only service recordtype of retail task according to dealer and code of users 
     */
    public List<SharingWrapper> wrapRetailTasksGeneric(List<Retail_Task__c> retailTasks, String market)
    {
        List<Retail_Task__c> services = new List<Retail_Task__c>();
        List<SharingWrapper> wrappers = new List<SharingWrapper>();
        for(Retail_Task__c retailTask : retailTasks) {       
            if(UtilRecordType.getRecordTypeIdByName('Retail_Task__c','Service').equalsIgnoreCase(retailTask.RecordTypeId)){
                    
                services.add(retailTask);
            }
        }
        if(services!=null && services.size()>0)
        {
            wrappers.addAll(wrapServices(services,market));
        }
        return wrappers;
    }
     
     //SB2018
    /** 
     * @Description Wraps "Service" retail tasks.
     *              read permission to all the service history records of the vehicle to which dealers have access    
     * @author  Sushma
     * @Date   02/27/2018(mm/dd/yy)
     * @param  all records having Service recordtype to the list .
     * @return read permission to to the dealers who has access to both related dealer and related vehicle.
     * @see   wrapRetailTasks
     */
    public List<SharingWrapper> wrapServicesVehDealer(List<Retail_Task__c> services) {
            return wrapVehicleServiceHistory(Schema.Retail_Task__Share.RowCause.Service_Share__c, services,UtilConstant.read_Access);
    }
    
    //SB2018
    /**    
     * @Description Wraps "Service" retail tasks.
     *              read permission to all the service history records of the vehicle to which dealers have access 
     * @author  Sushma
     * @Date    02/27/2018(mm/dd/yy)
     * @param  all records having Service recordtype to the list .
     * @return read permission to all the service history records of the vehicle to which dealers have access
     * @see   wrapVehicleServiceHistory
     */
    public List<SharingWrapper> wrapVehicleServiceHistory(String rowCause, List<Retail_Task__c> retailTasks, String accessLevel) {
        UserService userService = new UserService();
        List<Retail_Task__c> retailTasksLst=[select Id,Related_Dealer__c,Related_Vehicle__c,Related_Dealer__r.Dealer_ND_Code__c from Retail_Task__c where Id IN:retailTasks];
        Map<String, Set<Id>> dealerNdCode2Grp = userService.mapRelatedDealerNdCode2GrpGeneric(retailTasksLst);
        Map<Id, Set<Id>> retailTask2Grp = new Map<Id, Set<Id>>();
        User loggedInUser = [select Id, Market__c from User where Id = :UserInfo.getUserId()];        
        for(Retail_Task__c retailTask : retailTasksLst) {
            String grpName=loggedInUser.market__c+retailTask.Related_Dealer__r.Dealer_ND_Code__c+retailTask.Related_Vehicle__c;
            if(dealerNdCode2Grp.get(grpName) != null){
                retailTask2Grp.put(retailTask.Id, dealerNdCode2Grp.get(grpName));
            }
        }

        return SharingWrapperService.wrapSharings(retailTask2Grp, rowCause, accessLevel);
    }
     
}