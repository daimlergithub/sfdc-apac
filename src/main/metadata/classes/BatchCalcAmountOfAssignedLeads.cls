/*
    Type:       Schedule Apex
    Purpose:    Scheduleable calculate assigned lead amount of dealer every day
    User Story: US-Lead-015
    Used By:    ScheduleCalcAmountOfAssignedLeads
    ---------------------------------------------------------------
    History:
    
    1. Mouse Created on 2013-5-23
*/
global class BatchCalcAmountOfAssignedLeads implements Database.Batchable<SObject> {
    private String query;
    
    global BatchCalcAmountOfAssignedLeads(String q) {
        this.query = q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) { 
        return Database.getQueryLocator(query);
    }
    
    // Clear passed dealer info and caculate assigned lead info of today
    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Account> dealers = new List<Account>();
        for (Account dealer : (List<Account>)scope) {
            List<Lead__c> leads = dealer.Lead_Assigned_Dealer__r;
            
            // If yesterday assigned leads is not 0 and today is 0
            if (dealer.Assigned_Lead_Amount_of_Everyday__c != 0 
                    && dealer.Assigned_Lead_Amount_of_Everyday__c != null
                    && leads.isEmpty()) {
                        
                dealer.Assigned_Lead_Amount_of_Everyday__c = 0;
                dealer.Dealer_Lead_Gate_Keeper__c = null;
                dealers.add(dealer);
            }

            // If today is not 0
            if (leads!=Null && !leads.isEmpty()) {               
            
                dealer.Assigned_Lead_Amount_of_Everyday__c = leads.size();
                dealer.Dealer_Lead_Gate_Keeper__c = leads[0].OwnerId;
                dealers.add(dealer);
            }
        }

        update dealers;
    }

    global void finish(Database.BatchableContext bc) {
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                                   JobItemsProcessed, TotalJobItems
                            FROM AsyncApexJob
                            WHERE Id = :bc.getJobId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Map<String,App_Setting__c> assignedLeads_eMailAddress = App_Setting__c.getAll();
        String dailyAssignedLeads_ReporteMailAddress=assignedLeads_eMailAddress.get('DailyAssignedLeadsReport eMail Address').Value__c;    
       String[] toAddresses = new String[] {dailyAssignedLeads_ReporteMailAddress};
            
            if(toAddresses!=Null && !toAddresses.isEmpty()){
                mail.setToAddresses(toAddresses);
            }
                mail.setSubject('Daily Assigned Leads Amount of Dealer Batch Status: ' + job.Status);
                mail.setPlainTextBody('The batch Apex job processed ' + job.TotalJobItems +
                ' batches with '+ job.NumberOfErrors + ' failures.');
           try{
              Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
           }catch(EmailException ex){
              system.debug('============== email exception caught!!!Destination email address does not exist============='+ex.getMessage());             
           }        
    }
}