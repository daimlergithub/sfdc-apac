/*
    Type:       Utility for Settlement management trigger
    Purpose:    1. Calculate Total amount when settlement is changed
    User Story: US-DPCR-001
    Used By:    
    ---------------------------------------------------------------
    History:
    
    15-July-2013 Sinow Zhang (NTTData) Created
*/
public with sharing class SettlementHelper {
    
    public static void upsertSobjects(List<Sobject> sos) {
        try {
            upsert sos;
        }
        catch (DMLException e) {
            trigger.new[0].addError(e.getDMLMessage(0));
            System.debug('Exception message is :' + e.getDMLMessage(0));
        }
    }
    
    public static void updateSettlementTotalAmount(set<Id> caseIds) {
        List<Settlement_Management__c> settlements = new List<Settlement_Management__c>();
        Map<Id, Decimal> caseIdTotalMB_Amounts = new Map<Id, Decimal>();
        Map<Id, Decimal> caseIdTotalDealer_Amounts = new Map<Id, Decimal>();
        Map<Id, Decimal> caseIdTotalCustomer_Amounts = new Map<Id, Decimal>();
          
        for(Settlement_Management__c sm : [select Id, Case__c, Settlement_Type__c, MB_Settlement_Amount__c, Dealer_Settlement_Amount__c, Customer_Settlement_Amount__c from Settlement_Management__c where Case__c in :caseIds and Settlement_Type__c != 'Total Complaint Settlement' and isDeleted = false]) {
            if(!caseIdTotalMB_Amounts.containsKey(sm.Case__c)) {
                caseIdTotalMB_Amounts.put(sm.Case__c, 0);
            }
            if(!caseIdTotalDealer_Amounts.containsKey(sm.Case__c)) {
                caseIdTotalDealer_Amounts.put(sm.Case__c, 0);
            }
            if(!caseIdTotalCustomer_Amounts.containsKey(sm.Case__c)) {
                caseIdTotalCustomer_Amounts.put(sm.Case__c, 0);
            }
            if(sm.MB_Settlement_Amount__c == null) {
                sm.MB_Settlement_Amount__c = 0;
            }
            if(sm.Dealer_Settlement_Amount__c == null) {
                sm.Dealer_Settlement_Amount__c = 0;
            }
            if(sm.Customer_Settlement_Amount__c == null) {
                sm.Customer_Settlement_Amount__c = 0;
            }
            caseIdTotalMB_Amounts.put(sm.Case__c, caseIdTotalMB_Amounts.get(sm.Case__c) + sm.MB_Settlement_Amount__c);
            caseIdTotalDealer_Amounts.put(sm.Case__c, caseIdTotalDealer_Amounts.get(sm.Case__c) + sm.Dealer_Settlement_Amount__c);
            caseIdTotalCustomer_Amounts.put(sm.Case__c, caseIdTotalCustomer_Amounts.get(sm.Case__c) + sm.Customer_Settlement_Amount__c);
        }
    
        for(Settlement_Management__c sm : [select Id, Case__c, Settlement_Type__c, MB_Settlement_Amount__c, Dealer_Settlement_Amount__c, Customer_Settlement_Amount__c from Settlement_Management__c where Case__c in :caseIds and Settlement_Type__c = 'Total Complaint Settlement' and isDeleted = false]) {
            if(caseIdTotalMB_Amounts.containsKey(sm.Case__c) && caseIdTotalDealer_Amounts.containsKey(sm.Case__c) && caseIdTotalCustomer_Amounts.containsKey(sm.Case__c)) {
                sm.MB_Settlement_Amount__c = caseIdTotalMB_Amounts.get(sm.Case__c);
                sm.Dealer_Settlement_Amount__c = caseIdTotalDealer_Amounts.get(sm.Case__c);
                sm.Customer_Settlement_Amount__c = caseIdTotalCustomer_Amounts.get(sm.Case__c);
                settlements.add(sm);
                caseIds.remove(sm.Case__c);
            }
        }
        
        Settlement_Management__c newSettlement;
        for(Id id : caseIds) {
            if(caseIdTotalMB_Amounts.containsKey(id) && caseIdTotalDealer_Amounts.containsKey(id) && caseIdTotalCustomer_Amounts.containsKey(id)) {
                newSettlement = new Settlement_Management__c();
                newSettlement.Case__c = id;
                newSettlement.Settlement_Type__c = 'Total Complaint Settlement';
                newSettlement.MB_Settlement_Amount__c = caseIdTotalMB_Amounts.get(id);
                newSettlement.Dealer_Settlement_Amount__c = caseIdTotalDealer_Amounts.get(id);
                newSettlement.Customer_Settlement_Amount__c = caseIdTotalCustomer_Amounts.get(id);
                settlements.add(newSettlement);
            }
        }
        
        if(settlements.size() > 0) {
            upsertSobjects(settlements);
        }
    }
}