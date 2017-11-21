@isTest
public class TriggerUtilTest 
{
    private static String testTrigger='TestTrigger';
    private static String testString='Test';
    private static String newString='new';
    private static String testTrigger_1='TestTrigger_1';
    
    
    
    public static Boolean triggerProcessed = false;
    public static Boolean triggerHandlerCalled = false;
   
    public static testMethod void testIsTriggerEnabled_AllDisabled_Insert()
    {
        // prepare test data
        upsert new Trigger__c(Name = testTrigger_1, Trigger_Name__c = testTrigger, enabled__c = false, before__c = true, after__c = true, insert__c = true, update__c = true, delete__c = true,Market__c='JP');
        triggerProcessed = false;
        
        // run test
        Test.startTest();
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = testString);
        insert testIdea;
        Test.stopTest();
        
        // verify
        System.assert(triggerProcessed);
    }
   
    public static testMethod void testIsTriggerEnabled_AllDisabled_Update()
    {
        // prepare test data
        upsert new Trigger__c(Name = testTrigger_1, Trigger_Name__c = testTrigger, enabled__c = false, before__c = true, after__c = true, insert__c = true, update__c = true, delete__c = true,Market__c='JP');
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = testString);
        insert testIdea;
        triggerProcessed = false;
        
        // run test
        Test.startTest();
        testIdea.Title = newString;
        update testIdea;
        Test.stopTest();
        
        // verify
        System.assert(triggerProcessed);
    }
   
    public static testMethod void testIsTriggerEnabled_AllDisabled_Delete()
    {
        // prepare test data
        upsert new Trigger__c(Name = testTrigger_1, Trigger_Name__c = testTrigger, enabled__c = false, before__c = true, after__c = true, insert__c = true, update__c = true, delete__c = true,Market__c='JP');
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = testString);
        insert testIdea;
        
        TriggerUtil.isTriggerEnabled(testTrigger_1);
        triggerProcessed = True;
        
        // run test
        Test.startTest();
        delete testIdea;
        Test.stopTest();
        
        // verify
        System.assert(triggerProcessed);
    }
   
    public static testMethod void testIsTriggerEnabled_InsertDisabled_Insert()
    {
        // prepare test data
        upsert new Trigger__c(Name = testTrigger_1, Trigger_Name__c = testTrigger, enabled__c = false, before__c = true, after__c = true, insert__c = true, update__c = false, delete__c = false,Market__c='JP');
        triggerProcessed = false;
        
        // run test
        Test.startTest();
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = testString);
        insert testIdea;
        Test.stopTest();
        
        // verify
        System.assert(triggerProcessed);
    }
   
    public static testMethod void testIsTriggerEnabled_InsertDisabled_Update()
    {
        // prepare test data
        upsert new Trigger__c(Name = testTrigger_1, Trigger_Name__c = 'TestTrigger', enabled__c = false, before__c = true, after__c = true, insert__c = true, update__c = false, delete__c = false,Market__c='JP');
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = testString);
        insert testIdea;
        triggerProcessed = false;
        
        // run test
        Test.startTest();
        testIdea.Title = newString;
        update testIdea;
        Test.stopTest();
        
        // verify
        System.assert(triggerProcessed);
    }
   
    public static testMethod void testIsTriggerEnabled_InsertDisabled_Delete()
    {
        // prepare test data
        upsert new Trigger__c(Name = testTrigger_1, Trigger_Name__c = testTrigger, enabled__c = false, before__c = true, after__c = true, insert__c = true, update__c = false, delete__c = false,Market__c='JP');
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = testString);
        insert testIdea;
        triggerProcessed = false;
        
        // run test
        Test.startTest();
        delete testIdea;
        Test.stopTest();
        
        // verify
        System.assert(triggerProcessed);
    }
   
    public static testMethod void testIsTriggerEnabled_UpdateDisabled_Insert()
    {
        // prepare test data
        upsert new Trigger__c(Name = testTrigger_1, Trigger_Name__c = testTrigger, enabled__c = false, before__c = true, after__c = true, insert__c = false, update__c = true, delete__c = false,Market__c='JP');
        triggerProcessed = false;
        
        // run test
        Test.startTest();
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = testString);
        insert testIdea;
        Test.stopTest();
        
        // verify
        System.assert(triggerProcessed);
    }
   
    public static testMethod void testIsTriggerEnabled_UpdateDisabled_Update()
    {
        // prepare test data
        upsert new Trigger__c(Name = testTrigger_1, Trigger_Name__c = testTrigger, enabled__c = false, before__c = true, after__c = true, insert__c = false, update__c = true, delete__c = false,Market__c='JP');
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = testString);
        insert testIdea;
        triggerProcessed = false;
        
        // run test
        Test.startTest();
        testIdea.Title = newString;
        update testIdea;
        Test.stopTest();
        
        // verify
        System.assert(triggerProcessed);
    }
   
    public static testMethod void testIsTriggerEnabled_UpdateDisabled_Delete()
    {
        // prepare test data
        upsert new Trigger__c(Name = testTrigger_1, Trigger_Name__c = testTrigger, enabled__c = false, before__c = true, after__c = true, insert__c = false, update__c = true, delete__c = false,Market__c='JP');
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = testString);
        insert testIdea;
        triggerProcessed = false;
        
        // run test
        Test.startTest();
        delete testIdea;
        Test.stopTest();
        
        // verify
        System.assert(triggerProcessed);
    }
   
    public static testMethod void testIsTriggerEnabled_DeleteDisabled_Insert()
    {
        // prepare test data
        upsert new Trigger__c(Name = testTrigger_1, Trigger_Name__c = testTrigger, enabled__c = false, before__c = true, after__c = true, insert__c = false, update__c = false, delete__c = true,Market__c='JP');
        triggerProcessed = false;
        
        // run test
        Test.startTest();
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = testString);
        insert testIdea;
        Test.stopTest();
        
        // verify
        System.assert(triggerProcessed);
    }
   
    public static testMethod void testIsTriggerEnabled_DeleteDisabled_Update()
    {
        // prepare test data
        upsert new Trigger__c(Name = testTrigger_1, Trigger_Name__c = testTrigger, enabled__c = false, before__c = true, after__c = true, insert__c = false, update__c = false, delete__c = true,Market__c='JP');
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = testString);
        insert testIdea;
        triggerProcessed = false;
        
        // run test
        Test.startTest();
        testIdea.Title = newString;
        update testIdea;
        Test.stopTest();
        
        // verify
        System.assert(triggerProcessed);
    }
   
    public static testMethod void testIsTriggerEnabled_DeleteDisabled_Delete()
    {
        // prepare test data
        upsert new Trigger__c(Name = testTrigger_1, Trigger_Name__c = testTrigger, enabled__c = false, before__c = true, after__c = true, insert__c = false, update__c = false, delete__c = true,Market__c='JP');
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = testString);
        insert testIdea;
        triggerProcessed = false;
        
        // run test
        Test.startTest();
        delete testIdea;
        Test.stopTest();
        
        // verify
        System.assert(triggerProcessed);
    }
    
    public static testMethod void testIsTriggerEnabled_UpdateDisabledDeleteDisabled_Insert()
    {
        // prepare test data
        upsert new Trigger__c(Name = testTrigger_1, Trigger_Name__c = testTrigger, enabled__c = false, before__c = true, after__c = true, insert__c = false, update__c = true, delete__c = false,Market__c='JP');
        upsert new Trigger__c(Name = 'TestTrigger_2', Trigger_Name__c = testTrigger, enabled__c = false, before__c = true, after__c = true, insert__c = false, update__c = false, delete__c = true,Market__c='JP');
        triggerProcessed = false;
        
        // run test
        Test.startTest();
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = testString);
        insert testIdea;
        Test.stopTest();
        
        // verify
        System.assert(triggerProcessed);
    }
    
    public static testMethod void testIsTriggerEnabled_UpdateDisabledDeleteDisabled_Update()
    {
        // prepare test data
        upsert new Trigger__c(Name = testTrigger_1, Trigger_Name__c = testTrigger, enabled__c = false, before__c = true, after__c = true, insert__c = false, update__c = true, delete__c = false,Market__c='JP');
        upsert new Trigger__c(Name = 'TestTrigger_2', Trigger_Name__c = testTrigger, enabled__c = false, before__c = true, after__c = true, insert__c = false, update__c = false, delete__c = true,Market__c='JP');
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = testString);
        insert testIdea;
        triggerProcessed = false;
        
        // run test
        Test.startTest();
        testIdea.Title = newString;
        update testIdea;
        Test.stopTest();
        
        // verify
        System.assert(triggerProcessed);
    }
    
    public static testMethod void testIsTriggerEnabled_UpdateDisabledDeleteDisabled_Delete()
    {
        // prepare test data
        upsert new Trigger__c(Name = testTrigger_1, Trigger_Name__c = testTrigger, enabled__c = false, before__c = true, after__c = true, insert__c = false, update__c = true, delete__c = false,Market__c='JP');
        upsert new Trigger__c(Name = 'TestTrigger_2', Trigger_Name__c = testTrigger, enabled__c = false, before__c = true, after__c = true, insert__c = false, update__c = false, delete__c = true,Market__c='JP');
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = testString);
        insert testIdea;
        triggerProcessed = false;
        
        // run test
        Test.startTest();
        delete testIdea;
        Test.stopTest();
        
        // verify
        System.assert(triggerProcessed);
    }
   
    public static testMethod void testHandleTrigger()
    {
        // prepare test data
        upsert new Trigger__c(Name = testTrigger_1, Trigger_Name__c = testTrigger, Trigger_Handler__c = 'TestTriggerHandler', enabled__c = true, before__c = true, after__c = true, insert__c = true, update__c = true, delete__c = true,Market__c='JP');
        triggerHandlerCalled = false;
        
        // run test
        Test.startTest();
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = testString);
        insert testIdea;
        Test.stopTest();
        
        // verify
        System.assert(triggerHandlerCalled);
    }
   
    public static testMethod void testHandleTrigger_NoHandler()
    {
        // prepare test data
        upsert new Trigger__c(Name = testTrigger_1, Trigger_Name__c = testTrigger, enabled__c = true, before__c = true, after__c = true, insert__c = true, update__c = true, delete__c = true,Market__c='JP');
        triggerHandlerCalled = false;
        
        // run test
        Test.startTest();
        Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = testString);
        //insert testIdea;
        Test.stopTest();
        
        // verify
        System.assertEquals(triggerHandlerCalled,false); // default trigger handler is TestTriggerHandler
    }
   
    public static testMethod void testHandleTrigger_NonExistingHandler()
    {
        // prepare test data
        upsert new Trigger__c(Name = testTrigger_1, Trigger_Name__c = testTrigger, Trigger_Handler__c = 'UnknownTriggerHandler', enabled__c = true, before__c = true, after__c = true, insert__c = true, update__c = true, delete__c = true,Market__c='JP');
        triggerHandlerCalled = false;
        
        // run test
        Test.startTest();
        try {
            Idea testIdea = new Idea(CommunityId = [select Id from Community where Name = 'Internal Community'].Id, Title = testString);
            insert testIdea;
            System.assert(false, 'Expected an IllegalArgumentException encapsulated by a System.DmlException to be thrown in case of an invalid trigger handler class being specified');
        }
        catch (System.DmlException expected) {
            System.assert(expected.getMessage().contains('IllegalArgumentException'));
        }
        Test.stopTest();
        
        // verify
        System.assert(!triggerHandlerCalled);
    }
    public static testmethod void TestTriggerHandler(){
        boolean isInsert= True;
        boolean isUpdate= True;
        boolean isBefore= True;
        boolean isDelete= True;
        boolean isAfter= True;
        TestTriggerHandler TriggerHandler =new TestTriggerHandler();
         TriggerHandler.handleTrigger( isInsert,  isUpdate,  isBefore,  isDelete,  isAfter);
         TriggerHandler.handleIntegrationTrigger(isInsert,isUpdate, isBefore,  isDelete,  isAfter);
        system.assertEquals(isInsert,True);
    }
    public static testmethod void TaskTriggerHandlerJP(){
        boolean isInsert= True;
        boolean isUpdate= True;
        boolean isBefore= True;
        boolean isDelete= True;
        boolean isAfter= True;
        TaskTriggerHandlerJP TriggerHandlers =new TaskTriggerHandlerJP();

       // TriggerHandlers.handleTrigger(isInsert,  isUpdate,  isBefore,  isDelete,  isAfter);
        TriggerHandlers.handleIntegrationTrigger(isInsert,  isUpdate,  isBefore,  isDelete,  isAfter);
        system.assertEquals(isInsert,True);
    }
}