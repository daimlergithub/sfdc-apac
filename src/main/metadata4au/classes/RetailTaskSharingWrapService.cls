/**
** Wrap service for retail tasks to share.
** 1. Shares "Contract" retail tasks to active users of active dealers, who have both read access to the related person account and vehicle.
** 2. Shares "Retail Activity" retail tasks to active users of the related dealer and the active dealers with the same CRM Code.
** 3. Shares "Service" retail tasks to active users of the related dealer and the active dealers with the same CRM Code.
** 
** Created By: CC
** Date: 2014-6-15
**/
public with sharing class RetailTaskSharingWrapService {
    public RetailTaskSharingWrapService() {
    }

    /**
    ** Gets all the required fields of retail tasks then wraps those retail tasks by record type.
    **/
    public List<SharingWrapper> wrapRetailTasks(List<Retail_Task__c> retailTasks) {
        retailTasks = [select Id, RecordTypeId, Related_Contact__c, Related_Dealer__c, Related_Dealer__r.Dealer_DMS_CRM_Code__c, Related_Vehicle__c from Retail_Task__c where Id in :retailTasks];
        List<SharingWrapper> wrappers = new List<SharingWrapper>();
        Map<Id, RecordType> retailTaskTypes = new Map<Id, RecordType>([select Id, DeveloperName from RecordType where SObjectType = 'Retail_Task__c']);
        List<Retail_Task__c> contracts = new List<Retail_Task__c>();
        List<Retail_Task__c> retailActivities = new List<Retail_Task__c>();
        List<Retail_Task__c> services = new List<Retail_Task__c>();
        for(Retail_Task__c retailTask : retailTasks) {
            if(retailTaskTypes.get(retailTask.RecordTypeId) != null){
                if(retailTaskTypes.get(retailTask.RecordTypeId).DeveloperName.equalsIgnoreCase('contract')) {
                    contracts.add(retailTask);
                } else if(retailTaskTypes.get(retailTask.RecordTypeId).DeveloperName.equalsIgnoreCase('Retail_Activity')) {
                    if(String.isNotBlank(retailTask.Related_Dealer__r.Dealer_DMS_CRM_Code__c)) {
                        retailActivities.add(retailTask);
                    }
                } else if(retailTaskTypes.get(retailTask.RecordTypeId).DeveloperName.equalsIgnoreCase('Service')) {
                    if(String.isNotBlank(retailTask.Related_Dealer__r.Dealer_DMS_CRM_Code__c)) {
                        services.add(retailTask);
                    }
                }
            }
        }
        if(!contracts.isEmpty()){
            wrappers.addAll(wrapContracts(contracts));
        }
        if(!retailActivities.isEmpty()){
            wrappers.addAll(wrapRetailActivities(retailActivities));
        }
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

        return SharingWrapperService.wrapSharings(contract2Users, Schema.Retail_Task__Share.RowCause.Contract_Share__c, 'Read');
    }

    /**
    ** Wraps "Service" retail tasks.
    **/
    public List<SharingWrapper> wrapServices(List<Retail_Task__c> services) {
        return wrapRetailTasks(Schema.Retail_Task__Share.RowCause.Service_Share__c, services, 'Read');
    }

    /**
    ** Wraps "Retail Activity" retail tasks.
    **/
    public List<SharingWrapper> wrapRetailActivities(List<Retail_Task__c> retailActivities) {
        return wrapRetailTasks(Schema.Retail_Task__Share.RowCause.Retail_Activity_Share__c, retailActivities, 'Read');
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