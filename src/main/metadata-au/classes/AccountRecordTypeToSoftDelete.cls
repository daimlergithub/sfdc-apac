/*
Type        : Scheduled Apex Class on Account
Purpose     : If a Lead is not modified for last 5 years and if the corresponding account PC_Status__c = 'Prospect' AND VAN_Status__c = 'Prospect' AND Insurance_Status__c = 'Prospect'
              then change the account record type to 'Company Soft Deleted'.
Issue nO    : SFDCAU-974
Created Date: 7th Oct, 2016
*/

global class AccountRecordTypeToSoftDelete implements Schedulable {
    global void execute(SchedulableContext sc){
        list<Account> accList = new list<Account>();
        list<Lead__c> leadList = new list<Lead__c>();
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> softRecordTypeId = new Set<Id>();
        String objectAPIName = 'Account' ; 
        Schema.DescribeSObjectResult sobjectResult = Schema.getGlobalDescribe().get(objectAPIName).getDescribe();
        List<Schema.RecordTypeInfo> recordTypeInfo = sobjectResult.getRecordTypeInfos();
        Map<String,Id> mapofAccountRecordTypeNameandId = new Map<String,Id>();
        for(Schema.RecordTypeInfo info : recordTypeInfo){
            mapofAccountRecordTypeNameandId.put(info.getName(),info.getRecordTypeId());
        }
        Id comSoftRecordTypeId = mapofAccountRecordTypeNameandId.get('Company Soft Deleted');
        Id perSoftRecordTypeId = mapofAccountRecordTypeNameandId.get('Person Account Soft Deleted');
        softRecordTypeId.add(comSoftRecordTypeId);
        softRecordTypeId.add(perSoftRecordTypeId);
        leadList = [SELECT  company_account__c,contact__c, recordtype.name FROM Lead__c WHERE lastModifiedDate < LAST_N_YEARS:5];
        for(Lead__c oldLead : leadList){
            if(oldLead.recordType.name == 'Fleet Vans' || oldLead.Contact__c == null){
                System.debug('Lead list'+leadList);
                accIdSet.add(oldLead.Company_Account__c);
            }
            else
            accIdSet.add(oldLead.contact__c);
        }
        accList = [SELECT Id, RecordType.name, RecordTypeId from Account WHERE PC_Status__c = 'Prospect' AND VAN_Status__c = 'Prospect' AND Insurance_Status__c = 'Prospect'  AND Id IN : accIdSet AND RecordTypeId NOT IN : softRecordTypeId];
        System.debug('Account list before changing record type====>'+accList);
        for(Account acc : accList ){
            if(acc.recordtype.name == 'Person Account'){
                acc.RecordTypeId = perSoftRecordTypeId;
            }
            else if(acc.recordtype.name == 'Company'){
                acc.RecordTypeId = comSoftRecordTypeId;
            }
        }
        try{
            if(!accList.isEmpty()){
                update accList;
            }
            System.debug('Account list after changing record type====>'+accList);
        }
        catch(DMLException ex){
        CustomLogUtil.DebugException(ex);
        }
    }
}