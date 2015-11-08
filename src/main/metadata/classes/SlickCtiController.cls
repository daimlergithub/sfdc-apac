global class SlickCtiController {
private static String selectString = 'SELECT ';
/*
    webservice static String createCase(String personAccountId, String caseType, 
                                        String subType, String callerVerified, 
                                        String waitTime, String ivrPath) {
        // get the contact ID from the person account so it can populate the case fields...
        Contact contactRec = [select ID, FirstName, LastName from contact where AccountId =: personAccountId];

        Case newCase = new Case();
        newCase.accountId = personAccountId;
        newCase.contactId = contactRec.Id;
        newCase.Type = caseType;
        newCase.subject = contactRec.FirstName + ' ' + contactRec.LastName + ' - ' + caseType;
        newCase.origin = 'Phone';
        //newCase.SDG_Status__c = 'NOT RUN';
        newCase.Description = createDescriptionMessage(waitTime, ivrPath, callerVerified, personAccountId);

        insert newCase;

        return newCase.Id;
    }

    private static String createDescriptionMessage(String waitTime, String ivrPath, String callerVerified, String personAccountId) {
        // 35s in queue -> IVR -> Billing Enquiry (1) -> Plan Bills (4) -> 0418642243 -> PIN Verified 
        String callerVerifiedMessage;
        String caseDescriptionMsg;

        if (Boolean.valueOf(callerVerified)) {
            callerVerifiedMessage = 'PIN Verified';
        } else {
            callerVerifiedMessage = 'PIN Not Verified';
        }

        Contact personAccount = [select ID, MobilePhone FROM Contact WHERE AccountId =: personAccountId];
        caseDescriptionMsg = waitTime + ' in queue --> IVR --> ' + ivrPath + ' --> ' +  personAccount.MobilePhone + ' --> ' +callerVerifiedMessage;
        return caseDescriptionMsg;
    }
    */

    webservice static String getRecordDetails(String recordId) {
        SObject recordObject;                
        String objectType = SlickCtiObjectHelper.getObjectType(recordId);                                                
        RecordResultWrapper recordResult = new RecordResultWrapper();        
        String jsonResponse = 'back from getRecordDetails that passed record ID: ' + recordId + ' and object type is: ' + objectType;
        
        recordId = recordId.replace('/','');  
        recordResult.objectType = objectType;      
        
        System.debug('****** Object Type is: ' + objectType);
        
        if (objectType.equalsIgnoreCase('Contact')) {
            recordResult.recordObject = getContactFields(recordId);
        } else if(objectType.equalsIgnoreCase('Lead')) {
            recordResult.recordObject = getLeadFields(recordId);        
        } else if(objectType.equalsIgnoreCase('Account')) {
            recordResult.recordObject = getAccountFields(recordId);                    
        } else if(objectType.equalsIgnoreCase('Case')) {
            recordResult.recordObject = getCaseFields(recordId);              
        } else {
            System.debug('This is not a Contact or a case so you need to implement a proper handler here');
        }                                                    
        return JSON.serialize(recordResult);
    }
    
    public class RecordResultWrapper {
        public sObject recordObject {set;get;}
        public String objectType {set;get;}
    }    

    // ------  Getting the fields to return for the Case Record ------    
    public static String setContactCurrentToken(String recordId, String token) {   
        System.debug('setContactCurrentToken(recordId='+recordId+', token='+token+')'); 
        update new Contact (id=recordId, description=token);
        return recordId;
    }

    // ------  Getting the fields to return for the Case Record ------    
    public static Case getCaseFields(String recordId) {        
        String query = selectString;
        for(Schema.FieldSetMember f : getCaseFieldSet()) {
            query += f.getFieldPath() + ',';
        }           
        query += 'Id FROM Case where id=: recordId';
        return Database.query(query);        
    }
    
    public static List<Schema.FieldSetMember> getCaseFieldSet() {
        return SObjectType.Case.FieldSets.SLICK_CTI_CASE.getFields();
    }    
        
    // ------  Getting the fields to return for the Contact Record ------    
    public static Contact getContactFields(String recordId) {        
        String query = selectString;
        for(Schema.FieldSetMember f : getContactFieldSet()) {
            query += f.getFieldPath() + ',';
        }           
        query += 'Id FROM Contact where id=: recordId';
        return Database.query(query);        
    }
    
    public static List<Schema.FieldSetMember> getContactFieldSet() {
        return SObjectType.Contact.FieldSets.SLICK_CTI_CONTACT.getFields();
    }
        
    // ------  Getting the fields to return for the Lead Record ------        
    public static Lead getLeadFields(String recordId) {
        String query = selectString;
        for(Schema.FieldSetMember f : getLeadFieldSet()) {
            query += f.getFieldPath() + ',';
        }        
        query += 'Id FROM Lead where id=: recordId';
        return Database.query(query); 
    }
    
    public static List<Schema.FieldSetMember> getLeadFieldSet() {
        return SObjectType.Lead.FieldSets.SLICK_CTI_LEAD.getFields();
    }     
    
    // ------  Getting the fields to return for the Account Record ------        
    public static Account getAccountFields(String recordId) {
        String query = selectString;
        for(Schema.FieldSetMember f : getAccountFieldSet()) {
            query += f.getFieldPath() + ',';
        }        
        query += 'Id FROM Account where id=: recordId';
        return Database.query(query); 
    }
    
    public static List<Schema.FieldSetMember> getAccountFieldSet() {
        return SObjectType.Account.FieldSets.SLICK_CTI_ACCOUNT.getFields();
    }     
        
}