public class SsiHelper 
{
    private static String  validString = 'Valid';
    public static void fieldsValidationRule(Map<Id,SSI__c> newMap, Map<Id,SSI__c> oldMap){
        for(SSI__c ssi : newMap.values()){
            SSI__c old = oldMap.get(ssi.Id);

            if(ssi.DealerCheck_Status__c == validString
                && (old.DealerCheck_Status__c == 'Pending' 
                    || old.DealerCheck_Status__c == 'Reject'
                    || old.DealerCheck_Status__c == 'Accept')){
                ssi.addError('DealerCheck Status cannot be changed to Valid.');
            }
            if(old.DealerCheck_Status__c == validString && ssi.DealerCheck_Status__c != validString ){
                ssi.addError('DealerCheck Status cannot be changed.');
            }

            if(ssi.CarModelCheck_Status__c == validString 
                && (old.CarModelCheck_Status__c == 'Pending' 
                    || old.CarModelCheck_Status__c == 'Reject'
                    || old.CarModelCheck_Status__c == 'Accept')){
                ssi.addError('CarModelCheck Status cannot be changed to Valid.');
            }
            if(old.CarModelCheck_Status__c == validString && ssi.CarModelCheck_Status__c != validString ){
                ssi.addError('CarModelCheck Status cannot be changed.');
            }
        }
    }
    
    
    public static void autoGenerate2ndSurveyTasks(Map<Id,SSI__c> newMap, Map<Id,SSI__c> oldMap){
        List<Task> existtasks = [Select Id, WhatId From Task Where WhatId = :newMap.keySet() And Subject = '2nd Survey Call'];
        Set<Id> keys = new Set<Id>();
        for(Task t : existtasks){
            if(!keys.contains(t.WhatId)){
                keys.add(t.WhatId);
            }
        }
        Map<Id,SSI__c> updateMap = new Map<Id,SSI__c>();
        Set<String> customerName = new Set<String>();
        for(SSI__c ssi : newMap.values()){
            if(!keys.contains(ssi.Id) && oldMap.containsKey(ssi.Id) && ssi.Need_2nd_Survey__c && !oldMap.get(ssi.Id).Need_2nd_Survey__c){
                updateMap.put(ssi.Id, ssi);
                if(!customerName.contains(ssi.CustomerName__c)){
                    customerName.add(ssi.CustomerName__c);
                }
            }
        }
        
        List<Contact> relatedContacts = [Select Id, Name From Contact Where Name = :customerName];
        Map<String, Id> contactMap = new Map<String, Id>();
        for(Contact acc : relatedContacts){
            if(!contactMap.containsKey(acc.Name)){
                contactMap.put(acc.Name, acc.Id);
            }
        }

        User ssisv = null;
        List<Profile> ps = [Select Id From Profile Where Name = 'CAC SSI SV' Limit 1];
        if(ps != null && ps.size() > 0){
            List<User> us = [Select Id From User Where ProfileId = :ps[0].Id  And IsActive = true  Limit 1];
            if(us != null && us.size() > 0){
                ssisv = us[0];
            }
        }

        List<Task> generateTasks = new List<Task>();
        Id rtid = Schema.SObjectType.task.getRecordTypeInfosByName().get('SSI Task').getRecordTypeId();
        for(SSI__c ssi : updateMap.values()){
            Task t = new Task(
                OwnerId = ssisv.Id,
                recordtypeid = rtid,
                Subject = '2nd Survey Call',
                WhatId = ssi.Id,
                WhoId = contactMap.containsKey(ssi.CustomerName__c)?contactMap.get(ssi.CustomerName__c):null,
                HomeMobilePhone__c = ssi.HomeMobilePhone__c,
                OfficePhone__c = ssi.OfficePhone__c,
                CustomerName__c = ssi.CustomerName__c,
                Status = 'Open'
            );
            generateTasks.add(t);
        }
        
        if(!generateTasks.IsEmpty()){
            insert generateTasks;
        }
    }
    
    
      public static void fieldUpdates(Map<Id,SSI__c> newMap, Map<Id,SSI__c> oldMap){
        for(SSI__c ssi : newMap.values()){
            // update urlencode dealer name
            if(ssi.DealerName__c!=null && ssi.DealerName__c.length()>0){
                ssi.Encode_Dealer_Name__c = EncodingUtil.urlEncode(ssi.DealerName__c, 'UTF-8');
            }    

            SSI__c old = oldMap.get(ssi.Id);
            if (old != null && (old.Status__c == 'Matched' || old.Status__c == 'Unmatched')) {
                if (ssi.Mark__c == null) {
                    ssi.Mark__c = '';
                }
                if(ssi.CustomerName__c != old.CustomerName__c && ssi.CustomerName__c != null && old.CustomerName__c != null){
                    ssi.Mark__c += ssi.CustomerName__c + ';';
                }
                if(ssi.OfficePhone__c != old.OfficePhone__c && ssi.OfficePhone__c != null && old.OfficePhone__c != null){
                    ssi.Mark__c += ssi.OfficePhone__c + ';';
                }
                if(ssi.HomeMobilePhone__c != old.HomeMobilePhone__c && ssi.HomeMobilePhone__c != null && old.HomeMobilePhone__c != null){
                    ssi.Mark__c += ssi.HomeMobilePhone__c + ';';
                }
            }
        }
    }

}