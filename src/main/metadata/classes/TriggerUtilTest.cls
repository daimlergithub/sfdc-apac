@isTest
public class TriggerUtilTest 
{
    public static Boolean triggerProcessed = false;
    
    public static testMethod void testIsTriggerEnabledAllDisabled()
    {
        upsert new Trigger_Enabled__c(Name = 'TestTrigger_1', Trigger_Name__c = 'TestTrigger', enabled__c = false, before__c = true, after__c = true, insert__c = true, update__c = true, delete__c = true);
        
        triggerProcessed = false;
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = 'Test');
        insert testIdea;
        System.assert(!triggerProcessed);
        
        triggerProcessed = false;
        testIdea.Title = 'New';
        update testIdea;
        System.assert(!triggerProcessed);
        
        triggerProcessed = false;
        delete testIdea;
        System.assert(!triggerProcessed);
    }
    
    public static testMethod void testIsTriggerEnabledInsertDisabled()
    {
        upsert new Trigger_Enabled__c(Name = 'TestTrigger_1', Trigger_Name__c = 'TestTrigger', enabled__c = false, before__c = true, after__c = true, insert__c = true, update__c = false, delete__c = false);
        
        triggerProcessed = false;
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = 'Test');
        insert testIdea;
        System.assert(!triggerProcessed);
        
        triggerProcessed = false;
        testIdea.Title = 'New';
        update testIdea;
        System.assert(triggerProcessed);
        
        triggerProcessed = false;
        delete testIdea;
        System.assert(triggerProcessed);
    }
    
    public static testMethod void testIsTriggerEnabledUpdateDisabled()
    {
        upsert new Trigger_Enabled__c(Name = 'TestTrigger_1', Trigger_Name__c = 'TestTrigger', enabled__c = false, before__c = true, after__c = true, insert__c = false, update__c = true, delete__c = false);
        
        triggerProcessed = false;
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = 'Test');
        insert testIdea;
        System.assert(triggerProcessed);
        
        triggerProcessed = false;
        testIdea.Title = 'New';
        update testIdea;
        System.assert(!triggerProcessed);
        
        triggerProcessed = false;
        delete testIdea;
        System.assert(triggerProcessed);
    }
    
    public static testMethod void testIsTriggerEnabledDeleteDisabled()
    {
        upsert new Trigger_Enabled__c(Name = 'TestTrigger_1', Trigger_Name__c = 'TestTrigger', enabled__c = false, before__c = true, after__c = true, insert__c = false, update__c = false, delete__c = true);
        
        triggerProcessed = false;
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = 'Test');
        insert testIdea;
        System.assert(triggerProcessed);
        
        triggerProcessed = false;
        testIdea.Title = 'New';
        update testIdea;
        System.assert(triggerProcessed);
        
        triggerProcessed = false;
        delete testIdea;
        System.assert(!triggerProcessed);
    }
    
    public static testMethod void testIsTriggerEnabledMultipleCustomSettings()
    {
        
        upsert new Trigger_Enabled__c(Name = 'TestTrigger_1', Trigger_Name__c = 'TestTrigger', enabled__c = false, before__c = true, after__c = true, insert__c = false, update__c = true, delete__c = false);
        upsert new Trigger_Enabled__c(Name = 'TestTrigger_2', Trigger_Name__c = 'TestTrigger', enabled__c = false, before__c = true, after__c = true, insert__c = false, update__c = false, delete__c = true);
        
        triggerProcessed = false;
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = 'Test');
        insert testIdea;
        System.assert(triggerProcessed);
        
        triggerProcessed = false;
        testIdea.Title = 'New';
        update testIdea;
        System.assert(!triggerProcessed);
        
        triggerProcessed = false;
        delete testIdea;
        System.assert(!triggerProcessed);
    }
}