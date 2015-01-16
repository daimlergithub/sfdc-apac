/*
    Type:       SmartSSI Batch Vin Match
    Purpose:    Query "All Valid" SmartSSI, then do the Vin Match process.
    User Story: US-SMART_SSI-005
    Used By:    SmartVinMatchController.cls
    ---------------------------------------------------------------
    History:
    
    1. Shuang Li Created on 2014-03-17

*/
global class SmartSSIBatchVinMatch implements Database.Batchable<SObject>, Database.Stateful{

    private String query;

    private Integer successCount;

    private Id SSIRTID = Schema.Sobjecttype.Task.getRecordTypeInfosByName().get('smart SSI Task').getRecordTypeId();

    // default task assign user
    private User SSISV;

    private final String SUBJECT_WELCOMECALL = 'Welcome Call';
    private final String SUBJECT_WELCOMECALLAND1STSURVEYCALL = 'Welcome Call + 1st Survey Call';
    private final String SUBJECT_1STSURVEYCALL = '1st Survey Call';
    private final String SUBJECT_2NDSURVEYCALL = '2nd Survey Call';

    global SmartSSIBatchVinMatch (String query){
        System.debug('这里边的Query是：' + query);
        this.query = query;

    }
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> scope){

        if(SSISV == null){
            List<Profile> ps = [Select Id From Profile Where Name = 'CAC SSI SV' Limit 1];
            if(ps != null && ps.size() > 0){
                List<User> SSISVList = [Select Id From User Where ProfileId = :ps[0].Id And IsActive = true Limit 1];
                System.assertEquals(SSISVList.size(), 1);
                SSISV = SSISVList[0];               
            }
        }

        Map<String, smart_SSI__c> vinMatchs = new Map<String, smart_SSI__c>();

        if (scope.size() > 0) {
            for (smart_SSI__c ssi : (List<smart_SSI__c>)scope) {
                vinMatchs.put(ssi.VehicleUSvin__c, ssi);
            }
            runVINMatchProcess(vinMatchs);
            successCount = vinMatchs.size();
        }
    }

    /*
    VIN Match logic:
    1. 'VehicleUSvin' field on SSI record object match with 'UsVIN' field on Vehicle object.
    2. 'CustomerName' field on SSI record object match with 'Account Name' field on Account object.
    3. 'HomeMobilePhone' field on SSI record object match with 'Mobile'and 'Second Mobile'field on Account object.
    4. Once the VIN match is completed, SSI task will be generated automatically based on the result.
    5. If VIN matched, same customer name and mobile phone, generate Welcome Call + 1st Survey Call task immediately related to SSI record. SSI Status changed to be 'Matched'. Refers to US-SSI-008
    6. If VIN matched, different customer name or mobile phone, generate 1st Survey Call task immediately related to SSI record. SSI Status changed to be 'Matched'. Refers to US-SSI-0018
    7. If VIN unmatched, use SSI information generate 1st Survey Call task immediately related to SSI record. SSI Status changed to be 'Unmatched'. Refers to US-SSI-018.
    */
    private void runVINMatchProcess(Map<String, smart_SSI__c> ssiMap){
        List<Task> surveyTasks = new List<Task>();

        Map<String, Vehicle_Relationship__c> vrMap = new Map<String, Vehicle_Relationship__c>();
        
        List<Vehicle_Relationship__c> vrList = new List<Vehicle_Relationship__c>();
        for(List<Vehicle_Relationship__c> ls : [
            Select  v.Vehicle_ID__c, v.Vehicle_ID__r.UsVIN__c, 
                    v.Contact__c, 
                    v.Contact__r.Name,
                    v.Contact__r.Full_Name__c,
                    v.Contact__r.PersonContactId,
                    v.Contact__r.Customer_Number__c,  
                    v.Contact__r.PersonMobilePhone, 
                    v.Contact__r.PersonOtherPhone, 
                    v.Contact__r.Phone,
                    v.Contact__r.PersonHomePhone  
            From Vehicle_Relationship__c v 
            Where v.Vehicle_ID__r.UsVIN__c != null And v.Vehicle_ID__r.UsVIN__c In :ssiMap.keySet() And v.Contact__c != null]){
            vrList.addAll(ls);  
        }
        
        for(Vehicle_Relationship__c vr : vrList){
            if(!vrMap.containsKey(vr.Vehicle_ID__r.UsVIN__c)){
                vrMap.put(vr.Vehicle_ID__r.UsVIN__c, vr);
            }
        }
        
        for(smart_SSI__c ssi : ssiMap.values()){
            if(vrMap.containsKey(ssi.VehicleUSvin__c)){
                ssi.Status__c = 'Matched';
                ssi.OwnerId = SSISV.Id;
                Vehicle_Relationship__c vr = vrMap.get(ssi.VehicleUSvin__c);
                if(ssi.CustomerName__c == vr.Contact__r.Full_Name__c && (ssi.HomeMobilePhone__c == vr.Contact__r.PersonMobilePhone || ssi.HomeMobilePhone__c == vr.Contact__r.PersonOtherPhone)){
                    surveyTasks.add(createSurveyTask(ssi, vr, SUBJECT_WELCOMECALLAND1STSURVEYCALL));
                }else{
                    surveyTasks.add(createSurveyTask(ssi, vr, SUBJECT_1STSURVEYCALL));
                }
            }else{
                ssi.Status__c = 'Unmatched';
                ssi.OwnerId = SSISV.Id;
                surveyTasks.add(createSurveyTask(ssi, null, SUBJECT_1STSURVEYCALL));
            }

        }   
        
        if(surveyTasks.size()>0){
            insert surveyTasks;
        }

        if(!ssiMap.isEmpty()){
            update ssiMap.values();
        }
        
    }

    private Task createSurveyTask(smart_SSI__c ssi, Vehicle_Relationship__c vr, String subject){
        Task t = new Task();
        t.RecordTypeId = SSIRTID;
        t.Subject = subject;
        t.WhatId = ssi.Id;
        if(subject == SUBJECT_WELCOMECALLAND1STSURVEYCALL){
            t.WhoId = vr.Contact__r.PersonContactId;
        }
        t.CustomerName__c = ssi.CustomerName__c;
        t.Dealer_Name__c = ssi.DealerName__c;
        t.OwnerId = SSISV.Id;
        t.Status = 'Open';
        return t;
    }
    
    global void finish(Database.BatchableContext bc){
        AsyncApexJob job = [SELECT Id, Status, NumberOfErrors, 
                           JobItemsProcessed, TotalJobItems
                    FROM AsyncApexJob
                    WHERE Id = :bc.getJobId()];
        User currentUser = [SELECT Email FROM User WHERE Id = :UserInfo.getUserId()];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {currentUser.Email};
        mail.setToAddresses(toAddresses);
        mail.setSubject('smart SSI Data Vin Match Batch Status: ' + job.Status);
        mail.setPlainTextBody('smart VIN Match process had finished. Total tasks created: ' + successCount);
        try {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
        catch(Exception ex) {
            system.debug('Send smart SSI Data Vin Match Batch Status Email Exception :: ' + ex.getMessage());
        }
    }
}