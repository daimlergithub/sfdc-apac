@isTest
public class PicklistMappingHelperTest {

    @isTest
    public static void testExternalKeyNotEmpty() {
        Integration_Picklist__c ip = new Integration_Picklist__c();
        ip.External_Key__c = 'IP-123456';
        
        List<Integration_Picklist__c> triggerNew = new List<Integration_Picklist__c>();
        triggerNew.add(ip);
        
        PicklistMappingHelper.updateExternalKey(triggerNew, 'IP'); 
        
        System.assert('IP-123456'.equals(triggerNew[0].External_Key__c));
    }
    
    @isTest
    public static void testExternalKeyNotEmptyFormatMismatch() {
        Integration_Picklist__c ip = new Integration_Picklist__c();
        ip.External_Key__c = 'IP-12345';
        
        List<Integration_Picklist__c> triggerNew = new List<Integration_Picklist__c>();
        triggerNew.add(ip);
        
        PicklistMappingHelper.updateExternalKey(triggerNew, 'IP'); 
        
        System.assert('IP-000001'.equals(triggerNew[0].External_Key__c));
    }
    
    @isTest
    public static void testNoExistingObjects() {
        List<Integration_Picklist__c> triggerNew = new List<Integration_Picklist__c>();
        triggerNew.add(new Integration_Picklist__c());
        
        PicklistMappingHelper.updateExternalKey(triggerNew, 'IP');
        
        System.assert('IP-000001'.equals(triggerNew[0].External_Key__c));   
    }
    
    @isTest
    public static void testExistingObjects() {
        Picklist_Mapping__c existingPM = new Picklist_Mapping__c(External_Key__c='PM-000122', Name='LOV', Integration_Only__c=true);
        insert existingPM;
        
        List<Picklist_Mapping__c> triggerNew = new List<Picklist_Mapping__c>();
        triggerNew.add(new Picklist_Mapping__c());
        
        PicklistMappingHelper.updateExternalKey(triggerNew, 'PM');
        
        System.assert('PM-000123'.equals(triggerNew[0].External_Key__c));   
    }
    
    @isTest
    public static void testMultipleNewValues() {
        List<Integration_Picklist__c> triggerNew = new List<Integration_Picklist__c>();
        triggerNew.add(new Integration_Picklist__c());
        
        Integration_Picklist__c ip = new Integration_Picklist__c();
        ip.External_Key__c = 'IP-000006';
        triggerNew.add(ip);
        triggerNew.add(new Integration_Picklist__c());
        
        PicklistMappingHelper.updateExternalKey(triggerNew, 'IP');
        
        System.assert(3 == triggerNew.size());
        System.assert('IP-000007'.equals(triggerNew[0].External_Key__c));
        System.assert('IP-000006'.equals(triggerNew[1].External_Key__c));
        System.assert('IP-000008'.equals(triggerNew[2].External_Key__c));
    }
    
    @isTest
    public static void testPicklistMappingBeforeTrigger() {
        Picklist_Mapping__c newPM = new Picklist_Mapping__c(Name='LOV', Integration_Only__c=true);
        insert newPM;
        
        Picklist_Mapping__c savedPM = [SELECT External_Key__c FROM Picklist_Mapping__c WHERE Id =: newPM.Id];
        
        System.assertEquals('PM-000001', savedPM.External_Key__c);
    }
    
    @isTest
    public static void testIntegrationPicklistBeforeTrigger() {
        Picklist_Mapping__c newPM = new Picklist_Mapping__c(Name='LOV', Integration_Only__c=true);
        insert newPM;
        
        Integration_Picklist__c newIP = new Integration_Picklist__c(Picklist_Mapping__c=newPM.Id, Name='IV', Integration_Only__c=true);
        insert newIP;
        
        Integration_Picklist__c savedIP = [SELECT External_Key__c FROM Integration_Picklist__c WHERE Id =: newIP.Id];
        
        System.assertEquals('IP-000001', savedIP.External_Key__c);
    }
    
    @isTest
    public static void testExternalPicklistBeforeTrigger() {
        Picklist_Mapping__c newPM = new Picklist_Mapping__c(Name='LOV', Integration_Only__c=true);
        insert newPM;
        
        Integration_Picklist__c newIP = new Integration_Picklist__c(Picklist_Mapping__c=newPM.Id, Name='IV', Integration_Only__c=true);
        insert newIP;
        //TODO: Added External_Key__c='EP-000001'
        External_Picklist__c newEP = new External_Picklist__c(Integration_Picklist__c=newIP.Id,External_Key__c='EP-000001');
        insert newEP;
        
        External_Picklist__c savedEP = [SELECT External_Key__c FROM External_Picklist__c WHERE Id =: newEP.Id];
        
        System.assertEquals('EP-000001', savedEP.External_Key__c);
    }
}