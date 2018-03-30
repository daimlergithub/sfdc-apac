/**
** Wrap service for retail tasks to share.
** 1. Shares "Contract" retail tasks to active users of active dealers, who have both read access to the related person account and vehicle.
** 2. Shares "Retail Activity" retail tasks to active users of the related dealer and the active dealers with the same CRM Code.
** 3. Shares "Service" retail tasks to active users of the related dealer and the active dealers with the same CRM Code.
** 
** Created By: CC
** Date: 2014-6-15
Modified By : Sneha Chail
Modified date : 10-oct-2015
**/
public with sharing class RetailTaskSharingWrapService {
    public RetailTaskSharingWrapService() {
    }

   /**	
     * @Description Gets all the required fields of retail tasks then wraps those retail tasks by record type.  
     * @author  Sneha chail
     * @Date 10/26/2015(mm/dd/yy)
	 * @param  retailTasks is a list having all the new records of Retail_Task Object.
	 * @return all records having Contract,Retail Activity and service recordtype to the list 
	 * @see   TriggerRetailTaskTriggerHandler(RetailTaskSharingWrapService.wrapRetailTasks)
	 */    
    public List<SharingWrapper> wrapRetailTasks(List<Retail_Task__c> retailTasks) {       
        List<SharingWrapper> wrappers = new List<SharingWrapper>();
        List<Retail_Task__c> contracts = new List<Retail_Task__c>();
        List<Retail_Task__c> retailActivities = new List<Retail_Task__c>();
        List<Retail_Task__c> services = new List<Retail_Task__c>();                          
        
        for(Retail_Task__c retailTask : retailTasks) {       
            if(UtilRecordType.getRecordTypeNameByName('Retail_Task__c','Contract').equalsIgnoreCase('Contract')){
                    contracts.add(retailTask);
                }
             else if(UtilRecordType.getRecordTypeNameByName('Retail_Task__c','Retail Activity').equalsIgnoreCase('Retail Activity') && String.isNotBlank(retailTask.Related_Dealer__r.Dealer_DMS_CRM_Code__c)){
                  retailActivities.add(retailTask);                
                 } 
             else { 
             	    services.add(retailTask);
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
           wrappers.addAll(wrapServices(services));
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
    public List<SharingWrapper> wrapServices(List<Retail_Task__c> services) {
        User loggedInUser = [select Id, Market__c from User where Id = :UserInfo.getUserId()];
        if(loggedInUser.Market__c=='TH')
        {
            return wrapRetailTasksTH(Schema.Retail_Task__Share.RowCause.Service_Share__c, services,UtilConstant.edit_Access);
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
    
    /*Specific to TH market*/
    private List<SharingWrapper> wrapRetailTasksTH(String rowCause, List<Retail_Task__c> retailTasks, String accessLevel) {
        UserService userService = new UserService();
        List<Retail_Task__c> retailTasksLst=[select Id,Service_Dealer__c,Service_Dealer__r.Dealer_ND_Code__c,Related_Dealer__c from Retail_Task__c where Id IN:retailTasks];
        Map<String, Set<Id>> dealerNdCode2Grp = userService.mapDealerNdCode2Grp(retailTasksLst);
        Map<Id, Set<Id>> retailTask2Grp = new Map<Id, Set<Id>>();
        for(Retail_Task__c retailTask : retailTasksLst) {
            String grpName='TH'+retailTask.Service_Dealer__r.Dealer_ND_Code__c;
            if(dealerNdCode2Grp.get(grpName) != null){
                retailTask2Grp.put(retailTask.Id, dealerNdCode2Grp.get(grpName));
            }
        }

        return SharingWrapperService.wrapSharings(retailTask2Grp, rowCause, accessLevel);
    }
    /*
     *@Specific for TH market
	 *@author tejbir Singh
	 *@Share only service recordtype of retail task according to dealer and code of users 
     */
    public List<SharingWrapper> wrapRetailTasksTH(List<Retail_Task__c> retailTasks)
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
            wrappers.addAll(wrapServices(services));
        }
        return wrappers;
    }
     
     
}