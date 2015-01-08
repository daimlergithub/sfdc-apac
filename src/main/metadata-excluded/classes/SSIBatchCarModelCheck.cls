/*
    Type:       SSI car model cleansing 
    Purpose:    Clean car model
    User Story: US-SSI-003
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Chris Created on 2013-05-24

*/
global class SSIBatchCarModelCheck implements Database.Batchable<SObject>, Database.Stateful  {
    
    private String query;
    
    private Integer successCount = 0;
    
    private Map<String, String> cmMap;
    
    global SSIBatchCarModelCheck(String q) {
        this.query = q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    /*
    ** a).  Check if 'VehicleDesc' field equals to correct Vehicle Model (refers to data dictionary Vehicle Model value). 
            If match, update CarModelCheck Status=’Valid’, otherwise update CarModelCheck Status=’Suspect’.
    ** b).  If CarModelCheck Status=’Valid’, it will continue with the rest of rule(EP), refer to US-SSI-004. 
    */
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        
        if(cmMap == null){
            cmMap = new Map<String, String>();
            for(List<Vehicle_Model_Mapping__c> cmList : [Select Source_Model__c, SSI_Model__c From Vehicle_Model_Mapping__c]){
                for(Vehicle_Model_Mapping__c vmm : cmList){
                    cmMap.put(vmm.Source_Model__c, vmm.SSI_Model__c );
                }
            }
        }
        
        /*
        Set<String> modelSet = new Set<String>();
        Schema.DescribeFieldResult fieldResult = Vehicle__c.Model__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();       
        for( Schema.PicklistEntry f : ple){
            if(!modelSet.contains(f.getLabel())){
                modelSet.add(f.getLabel());
            }
        }
        
        for(SSI__c ssi : (List<SSI__c>)scope){
            if(ssi.VehicleDesc__c!=null && ssi.VehicleDesc__c.length()>0 && modelSet.contains(ssi.VehicleDesc__c)){
                ssi.CarModelCheck_Status__c = 'Valid';
            }else{
                ssi.CarModelCheck_Status__c = 'Pending';
            }
        }  
      */
      for(SSI__c ssi : (List<SSI__c>)scope){
        
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