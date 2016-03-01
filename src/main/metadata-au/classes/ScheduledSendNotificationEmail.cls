/*
    Type:       Utility for Lead__c
    Purpose:    For send email notifications to the Dealer recipient 
    User Story: US_AU-Lead-013,US_AU-Lead-014,US_AU-Lead-015,US_AU-Lead-016,US_AU-Lead-017
    Used By:    
    ---------------------------------------------------------------
    History:
        1. Barney Lai Created on 2013-09-18
*/

global class ScheduledSendNotificationEmail implements Schedulable{

    private static final String leadFinanceRT = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Finance Lead').getRecordTypeId();
    private static final String leadFleetRT = Schema.SObjectType.Lead__c.getRecordTypeInfosByName().get('Finance Fleet Lead').getRecordTypeId();

    global void execute(SchedulableContext SC) {
        
        List<Lead__c> financeLeads = new List<Lead__c>();
        List<Lead__c> fleetLeads = new List<Lead__c>();
        Map<Lead__c, Id> financeLeadsContractId = new Map<Lead__c, Id>();
        Map<Lead__c, Id> fleetLeadsContractId = new Map<Lead__c, Id>();
        Map<Lead__c, Retail_Task__c> financeLeadsContract = new Map<Lead__c, Retail_Task__c>();
        Map<Lead__c, Retail_Task__c> fleetLeadsContract = new Map<Lead__c, Retail_Task__c>();
        List<Lead__c> prepareLeads = new List<Lead__c>();
        
        financeLeads = [select id, Status_Category__c, Lead_Source__c, Existing_Contract__c,
            Is_Finance_Send_Email_Before_15_Days__c, Is_Finance_Send_Email_Before_20_Days__c,
             Is_Finance_Send_Email_Before_60_Days__c, Is_Fleet_Send_Email_Before_45_Days__c 
            from Lead__c where RecordTypeId = :leadFinanceRT and Status_Category__c = 'Open' and Lead_Source__c = 'End of Contract'];
        
        fleetLeads = [select id, Status_Category__c, Lead_Source__c, Existing_Contract__c,
            Is_Fleet_Send_Email_Before_15_Days__c , Is_Fleet_Send_Email_Before_20_Days__c ,
            Is_Fleet_Send_Email_Before_60_Days__c from Lead__c where RecordTypeId = :leadFleetRT and Status_Category__c = 'Open' and Lead_Source__c = 'End of Contract'];
        
        for(Lead__c lead : financeLeads) {
            if(lead.Existing_Contract__c != null) {
                financeLeadsContractId.put(lead, lead.Existing_Contract__c);
            }
        }
        for(Lead__c lead : fleetLeads) {
            if(lead.Existing_Contract__c != null) {
                fleetLeadsContractId.put(lead, lead.Existing_Contract__c);
            }
        }
        if(financeLeadsContractId.size() > 0) {
            for(Retail_Task__c Retail_Task: [select id, EndDate__c from Retail_Task__c where id in :financeLeadsContractId.values()]) {
                for(Lead__c lead : financeLeadsContractId.keyset()) {
                    if(Retail_Task.id == financeLeadsContractId.get(lead)) {
                        financeLeadsContract.put(lead,Retail_Task);
                    }
                }
            }
        }
        if(fleetLeadsContractId.size() > 0) {
            for(Retail_Task__c Retail_Task: [select id,EndDate__c from Retail_Task__c where id in :fleetLeadsContractId.values()]) {
                for(Lead__c lead : fleetLeadsContractId.keyset()) {
                    if(Retail_Task.id == fleetLeadsContractId.get(lead)) {
                        fleetLeadsContract.put(lead,Retail_Task);
                    }
                }
            }
        }
        
        for(Lead__c lead : financeLeadsContract.keyset()) {
            if(lead.Is_Finance_Send_Email_Before_15_Days__c == false) {
                Retail_Task__c c = financeLeadsContract.get(lead);
                if(c != null && c.EndDate__c == Date.today() + 15) {
                    lead.Is_Finance_Send_Email_Before_15_Days__c = true;
                    prepareLeads.add(lead);
                }
            }
            
            if(lead.Is_Finance_Send_Email_Before_20_Days__c == false) {
                Retail_Task__c c = financeLeadsContract.get(lead);
                if(c != null && c.EndDate__c == Date.today() + 20) {
                    lead.Is_Finance_Send_Email_Before_20_Days__c = true;
                    prepareLeads.add(lead);
                }
            }
           
            if(lead.Is_FLeet_Send_Email_Before_45_Days__c == false) {
                Retail_Task__c c = financeLeadsContract.get(lead);
                if(c != null && c.EndDate__c == Date.today() + 45) {
                    lead.Is_Fleet_Send_Email_Before_45_Days__c = true;
                    prepareLeads.add(lead);
                }
            }
            
            if(lead.Is_Finance_Send_Email_Before_60_Days__c == false) {
                Retail_Task__c c = financeLeadsContract.get(lead);
                if(c != null && c.EndDate__c == Date.today() + 60) {
                    lead.Is_Finance_Send_Email_Before_60_Days__c = true;
                    prepareLeads.add(lead);
                }
            }
        }
        
        for(Lead__c lead : fleetLeadsContract.keyset()) {
            if(lead.Is_Fleet_Send_Email_Before_15_Days__c == false) {
                Retail_Task__c c = fleetLeadsContract.get(lead);
                if(c.EndDate__c == Date.today() + 15) {
                    lead.Is_Fleet_Send_Email_Before_15_Days__c = true;
                    prepareLeads.add(lead);
                }
            }
            
            if(lead.Is_Fleet_Send_Email_Before_20_Days__c == false) {
                Retail_Task__c c = fleetLeadsContract.get(lead);
                if(c.EndDate__c == Date.today() + 20) {
                    lead.Is_Fleet_Send_Email_Before_20_Days__c = true;
                    prepareLeads.add(lead);
                }
            }
            
            if(lead.Is_Fleet_Send_Email_Before_60_Days__c == false) {
                Retail_Task__c c = fleetLeadsContract.get(lead);
                if(c.EndDate__c == Date.today() + 60) {
                    lead.Is_Fleet_Send_Email_Before_60_Days__c = true;
                    prepareLeads.add(lead);
                }
            }
        }
        
        if(prepareLeads.size() > 0) {
            try{
                update prepareLeads;
            }
            catch(DMLException e){
                System.debug('Debug Output ======> {Error: '+ e + '}');
            }    
        }
    }
}