**
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
    ** Gets all the required fields of retail tasks then wraps those retail tasks by record type.
    **/
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
    ** Wraps "Contract" retail tasks. 
    ** Users to share are decidied by their access to contrats' vehicle and dealer.
    **/
    public List<SharingWrapper> wrapContracts(List<Retail_Task__c> contracts) {
        UserService userService = new UserService();
        Map<Id, Set<Id>> contract2Users = userService.mapRetailTaskContract2Users(contracts);

        return SharingWrapperService.wrapSharings(contract2Users, Schema.Retail_Task__Share.RowCause.Contract_Share__c,UtilConstant.read_Access);
    }

    /**
    ** Wraps "Service" retail tasks.
    **/
    public List<SharingWrapper> wrapServices(List<Retail_Task__c> services) {
        return wrapRetailTasks(Schema.Retail_Task__Share.RowCause.Service_Share__c, services,UtilConstant.read_Access);
    }

    /**
    ** Wraps "Retail Activity" retail tasks.
    **/
    public List<SharingWrapper> wrapRetailActivities(List<Retail_Task__c> retailActivities) {
        return wrapRetailTasks(Schema.Retail_Task__Share.RowCause.Retail_Activity_Share__c, retailActivities,UtilConstant.read_Access);
    }

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
}