/*
    Type:       smart SSI dealer cleansing 
    Purpose:    Clean dealer
    User Story: smart SSI
    Used By:    
    ---------------------------------------------------------------
    History:
    
    1. Barney Lai Created on 2014-03-14

*/
global class SmartSSIBatchDealerCheck implements Database.Batchable<SObject>, Database.Stateful  {
    
    private String query;
    
    private Integer successCount = 0;
    
    global SmartSSIBatchDealerCheck(String q) {
        this.query = q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    /*
    ** a).  'Dealer smart SSI Participation'  filed on Account object is the symbol of a valid dealer. 
    **      In SSI Record(Status='Original') if ‘Dealer’ filed can match ‘AccountName’ in Account Object, 
    **      and 'Dealer SSI Participation' filed on Account object is ‘True’. Then DealerCheck Status=’Valid’. 
    ** b).  Otherwise DealerCheck Status=’Suspect’. 
    ** c).  If DealerCheck Status=’Valid’, it will continue with the runCarModelRule, refer to US-SSI-003. 
    ** d).  Otherwise the data cleansing process will update DealerCheck status as 'Suspect'. 
    */
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        //System.debug('-------------scope.size()-------------->'+scope.size());
        Map<String, List<smart_SSI__c>> dealerMap = new Map<String, List<smart_SSI__c>>();
        List<smart_SSI__c> updateList = new List<smart_SSI__c>();
        List<smart_SSI__c> validList = new List<smart_SSI__c>();
        
        for(smart_SSI__c ssi: (List<smart_SSI__c>)scope){
            ssi.Status__c = 'In Process';
            if(ssi.Dealer__c !=null && ssi.Dealer__c.length()>0){
                if(!dealerMap.containsKey(ssi.Dealer__c)){
                    dealerMap.put(ssi.Dealer__c, new List<smart_SSI__c>());
                }
                dealerMap.get(ssi.Dealer__c).add(ssi);
            }else{
                ssi.DealerCheck_Status__c = 'Pending';
                updateList.add(ssi);
            }           
        }

        if(!dealerMap.isEmpty()){
            List<Account> dealers = [
                Select Dealer_DMS_SR_Code__c, Dealer_DMS_SR_Code_2__c 
                From Account 
                Where Dealer_smart_SSI_Participation__c = true 
                And (Dealer_DMS_SR_Code__c in :dealerMap.keySet() Or Dealer_DMS_SR_Code_2__c in :dealerMap.keySet())];
            for(Account acc : dealers){
                if(acc.Dealer_DMS_SR_Code__c!=null && dealerMap.containsKey(acc.Dealer_DMS_SR_Code__c)){
                    for(smart_SSI__c ssi : dealerMap.get(acc.Dealer_DMS_SR_Code__c)){
                        ssi.DealerCheck_Status__c = 'Valid';
                        updateList.add(ssi);
                        validList.add(ssi);
                    }
                    dealerMap.remove(acc.Dealer_DMS_SR_Code__c);
                }

                if(acc.Dealer_DMS_SR_Code_2__c!=null && dealerMap.containsKey(acc.Dealer_DMS_SR_Code_2__c)){
                    for(smart_SSI__c ssi : dealerMap.get(acc.Dealer_DMS_SR_Code_2__c)){
                        ssi.DealerCheck_Status__c = 'Valid';
                        updateList.add(ssi);
                        validList.add(ssi);
                    }
                    dealerMap.remove(acc.Dealer_DMS_SR_Code_2__c);
                }
            }
        }

        if(!dealerMap.isEmpty()){
            for(List<smart_SSI__c> suspects : dealerMap.values()){
                for(smart_SSI__c ssi : suspects){
                    ssi.DealerCheck_Status__c = 'Pending';
                    updateList.add(ssi);
                }
            }
        }
        
        if(updateList.size()>0){
            update updateList;
            successCount += updateList.size();
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
        mail.setSubject('Dealer Rule Batch Status: ' + job.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + job.TotalJobItems +
            ' batches with '+ job.NumberOfErrors + ' failures. \nTotal Records Updated: ' + successCount);
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(Exception ex) {
            system.debug('Send Dealer Rule Batch Status Email Exception ::' + ex.getMessage());
        }
    }
}