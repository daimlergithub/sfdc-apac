/*
    Type:       smart SSI car model cleansing 
    Purpose:    Clean car model
    User Story: smart SSI
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Barney Lai Created on 2014-03-14

*/
global class SmartSSIBatchCarModelCheck implements Database.Batchable<SObject>, Database.Stateful  {
    
    private String query;
    
    private Integer successCount = 0;
    
    private Map<String, String> cmMap;
    
    global SmartSSIBatchCarModelCheck(String q) {
        this.query = q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        if(cmMap == null){
            cmMap = new Map<String, String>();
            for(List<Vehicle_Model_Mapping__c> cmList : [Select Source_Model__c, SSI_Model__c From Vehicle_Model_Mapping__c]){
                for(Vehicle_Model_Mapping__c vmm : cmList){
                    cmMap.put(vmm.Source_Model__c, vmm.SSI_Model__c );
                }
            }
        }
        
      for(smart_SSI__c ssi : (List<smart_SSI__c>)scope){
        
        if(ssi.VehicleDesc__c != null && cmMap.containsKey(ssi.VehicleDesc__c)){
            ssi.VehicleModel__c = cmMap.get(ssi.VehicleDesc__c);
        }else{
            ssi.VehicleModel__c = null;
        }              
      
        if(ssi.VehicleModel__c!=null && ssi.VehicleModel__c.length()>0){
          ssi.CarModelCheck_Status__c = 'Valid';
        }else{
          ssi.CarModelCheck_Status__c = 'Pending';
        }
      }
        
        if(scope.size()>0){
            update scope;
            successCount += scope.size();
        }

    }
    
    global void finish(Database.BatchableContext bc) {
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                           JobItemsProcessed, TotalJobItems
                    FROM AsyncApexJob
                    WHERE Id = :bc.getJobId()]; 
                    
        User currentUser = [Select Email From User Where Id = :UserInfo.getUserId()];
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {currentUser.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Car Model Rule Batch Status: ' + job.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + job.TotalJobItems +
            ' batches with '+ job.NumberOfErrors + ' failures. \nTotal Records Updated: ' + successCount);
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(Exception ex) {
            system.debug('Send Car Model Rule Batch Status Email Exception ::' + ex.getMessage());
        }
    }
}