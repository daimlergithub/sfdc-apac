@isTest
public class UowDecompilerTest
{
    static testmethod void testDecompileAtomicMultipleDifferentOperation()
    {
        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000001"}, {"Name":"Name","Value":"MY_FIRST_ACCOUNT"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000002"}, {"Name":"Name","Value":"MY_SECOND_ACCOUNT"}, {"Name":"Object_Name__c","Value":"OBJECT2"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String objectsAsJson = '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}';
        EpAdapterUnitOfWork__c unitOfWork = createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_MULTIPLE);

        test.startTest();
        UnitOfWorkResponse result = new UowDecompiler().decompile(unitOfWork, objectsAsJson);
        test.stopTest();

        System.assert(result.unitOfWorkId == 1l);
        System.assert(result.sfdcId != null);
        System.assert(result.status == UnitOfWorkStatus.FAILED);
        System.assertEquals(2, result.operationResult.size());

        System.assertEquals(1, result.operationResult.get(0).entityId);
        System.assert(result.operationResult.get(0).sfdcId == null);
        System.assert(!result.operationResult.get(0).success);
        System.assert(!result.operationResult.get(0).created);
        System.assert(result.operationResult.get(0).errors != null);
        System.assertEquals(1, result.operationResult.get(0).errors.size());
        System.assert(result.operationResult.get(0).errors.get(0).message != null);
        System.assertEquals('IllegalArgumentException', result.operationResult.get(0).errors.get(0).statusCode);

        System.assertEquals(2, result.operationResult.get(1).entityId);
        System.assert(result.operationResult.get(1).sfdcId == null);
        System.assert(!result.operationResult.get(1).success);
        System.assert(!result.operationResult.get(1).created);
        System.assert(result.operationResult.get(1).errors != null);
        System.assertEquals(1, result.operationResult.get(1).errors.size());
        System.assert(result.operationResult.get(1).errors.get(0).message != null);
        System.assertEquals('IllegalArgumentException', result.operationResult.get(1).errors.get(0).statusCode);
    }

    static testmethod void testDecompileAtomicMultipleDifferentObjectTypes()
    {
        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000001"}, {"Name":"Name","Value":"MY_FIRST_ACCOUNT"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Task", "operationType":"INSERT", "fields": [{"Name":"Description","Value":"My First Task"}]}';
        String objectsAsJson = '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}';
        EpAdapterUnitOfWork__c unitOfWork = createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_MULTIPLE);

        test.startTest();
        UnitOfWorkResponse result = new UowDecompiler().decompile(unitOfWork, objectsAsJson);
        test.stopTest();

        System.assert(result.unitOfWorkId == 1l);
        System.assert(result.sfdcId != null);
        System.assert(result.status == UnitOfWorkStatus.FAILED);
        System.assertEquals(2, result.operationResult.size());

        System.assertEquals(1, result.operationResult.get(0).entityId);
        System.assert(result.operationResult.get(0).sfdcId == null);
        System.assert(!result.operationResult.get(0).success);
        System.assert(!result.operationResult.get(0).created);
        System.assert(result.operationResult.get(0).errors != null);
        System.assertEquals(1, result.operationResult.get(0).errors.size());
        System.assert(result.operationResult.get(0).errors.get(0).message != null);
        System.assertEquals('IllegalArgumentException', result.operationResult.get(0).errors.get(0).statusCode);

        System.assertEquals(2, result.operationResult.get(1).entityId);
        System.assert(result.operationResult.get(1).sfdcId == null);
        System.assert(!result.operationResult.get(1).success);
        System.assert(!result.operationResult.get(1).created);
        System.assert(result.operationResult.get(1).errors != null);
        System.assertEquals(1, result.operationResult.get(1).errors.size());
        System.assert(result.operationResult.get(1).errors.get(0).message != null);
        System.assertEquals('IllegalArgumentException', result.operationResult.get(1).errors.get(0).statusCode);
    }

    static testmethod void testDecompileAtomicMultipleDifferentExternalIdField()
    {
        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000001"}, {"Name":"Name","Value":"MY_FIRST_ACCOUNT"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c"}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000002"}, {"Name":"Name","Value":"MY_SECOND_ACCOUNT"}, {"Name":"Object_Name__c","Value":"OBJECT2"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"ExternalSystem2Id__c"}';
        String objectsAsJson = '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}';
        EpAdapterUnitOfWork__c unitOfWork = createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_MULTIPLE);

        test.startTest();
        UnitOfWorkResponse result = new UowDecompiler().decompile(unitOfWork, objectsAsJson);
        test.stopTest();

        System.assert(result.unitOfWorkId == 1l);
        System.assert(result.sfdcId != null);
        System.assert(result.status == UnitOfWorkStatus.FAILED);
        System.assertEquals(2, result.operationResult.size());

        System.assertEquals(1, result.operationResult.get(0).entityId);
        System.assert(result.operationResult.get(0).sfdcId == null);
        System.assert(!result.operationResult.get(0).success);
        System.assert(!result.operationResult.get(0).created);
        System.assert(result.operationResult.get(0).errors != null);
        System.assertEquals(1, result.operationResult.get(0).errors.size());
        System.assert(result.operationResult.get(0).errors.get(0).message != null);
        System.assertEquals('IllegalArgumentException', result.operationResult.get(0).errors.get(0).statusCode);

        System.assertEquals(2, result.operationResult.get(1).entityId);
        System.assert(result.operationResult.get(1).sfdcId == null);
        System.assert(!result.operationResult.get(1).success);
        System.assert(!result.operationResult.get(1).created);
        System.assert(result.operationResult.get(1).errors != null);
        System.assertEquals(1, result.operationResult.get(1).errors.size());
        System.assert(result.operationResult.get(1).errors.get(0).message != null);
        System.assertEquals('IllegalArgumentException', result.operationResult.get(1).errors.get(0).statusCode);
    }

    public static testmethod void testExecuteCompoundMultipleTypes()
    {
        Picklist_Mapping__c account4 = new Picklist_Mapping__c(Name = 'MY_FOURTH_ACCOUNT', Object_Name__c = 'OBJECT4', Field_Name__c = 'FIELD');
        insert account4;

        Integration_Picklist__c account5 = new Integration_Picklist__c(Name = 'MY_FIFTH_ACCOUNT', Picklist_Mapping__c = account4.Id, Picklist_Value__c = 'VALUE');
        insert account5;

        Integration_Picklist__c account6 = new Integration_Picklist__c(Name = 'MY_SIXTH_ACCOUNT', Picklist_Mapping__c = account4.Id, Picklist_Value__c = 'VALUE');
        insert account6;

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000002"}, {"Name":"Name","Value":"MY_FIRST_ACCOUNT"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000003"}, {"Name":"Name","Value":"MY_SECOND_ACCOUNT"}, {"Name":"Object_Name__c","Value":"OBJECT2"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String object3AsJson = '{"uniqueId":3, "sObjectType":"Integration_Picklist__c", "operationType":"INSERT", "fields": [{"Name":"Name","Value":"MY_THIRD_ACCOUNT"}, {"Name":"Picklist_Mapping__c","Value":"' + account4.Id + '"}, {"Name":"Picklist_Value__c","Value":"VALUE"}]}';
        String object4AsJson = '{"uniqueId":4, "sObjectType":"Picklist_Mapping__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"' + account4.Id + '"}, {"Name":"Name","Value":"MY_FOURTH_ACCOUNT_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT4"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String object5AsJson = '{"uniqueId":5, "sObjectType":"Integration_Picklist__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"' + account5.Id + '"}, {"Name":"Name","Value":"MY_FIFTH_ACCOUNT_CHANGED"}]}';
        String object6AsJson = '{"uniqueId":6, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"Id","Value":"' + account4.Id + '"}, {"Name":"Name","Value":"MY_FOURTH_ACCOUNT_FIRST_CHANGE"}, {"Name":"Object_Name__c","Value":"OBJECT4"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String object7AsJson = '{"uniqueId":7, "sObjectType":"Picklist_Mapping__c", "operationType":"QUERY", "fields": [{"name":"Id","value":""}, {"name":"Name","value":""}], "whereClause":"Object_Name__c = \'OBJECT1\'"}';
        String object8AsJson = '{"uniqueId":8, "sObjectType":"Integration_Picklist__c", "operationType":"DELETE", "fields": [{"Name":"Id","Value":"' + account6.Id + '"}]}';
        String objectsAsJson = '{"entityList":[' + object4AsJson + ', ' + object1AsJson + ', ' + object2AsJson + ', ' + object3AsJson + ', ' + object5AsJson + ', ' + object6AsJson + ', ' + object7AsJson + ', ' + object8AsJson + ']}';
        EpAdapterUnitOfWork__c unitOfWork = createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.COMPOUND_MULTIPLE_TYPES);

        test.startTest();
        UnitOfWorkResponse result = new UowDecompiler().decompile(unitOfWork, objectsAsJson);
        test.stopTest();

        System.assert(result.unitOfWorkId == 1l);
        System.assert(result.sfdcId != null);
        System.assert(result.status == UnitOfWorkStatus.PROCESSED);
        System.assertEquals(8, result.operationResult.size());
        System.assertEquals(4, result.operationResult.get(0).entityId);
        System.assert(result.operationResult.get(0).sfdcId != null);
        System.assert(result.operationResult.get(0).success);
        System.assert(!result.operationResult.get(0).created);
        System.assert(result.operationResult.get(0).errors == null);
        System.assert(result.operationResult.get(1).entityId == 1);
        System.assert(result.operationResult.get(1).sfdcId != null);
        System.assert(result.operationResult.get(1).success);
        System.assert(result.operationResult.get(1).created);
        System.assert(result.operationResult.get(1).errors == null);
        System.assert(result.operationResult.get(2).entityId == 2);
        System.assert(result.operationResult.get(2).sfdcId != null);
        System.assert(result.operationResult.get(2).success);
        System.assert(result.operationResult.get(2).created);
        System.assert(result.operationResult.get(2).errors == null);
        System.assert(result.operationResult.get(3).entityId == 3);
        System.assert(result.operationResult.get(3).sfdcId != null);
        System.assert(result.operationResult.get(3).success);
        System.assert(result.operationResult.get(3).created);
        System.assert(result.operationResult.get(3).errors == null);
        System.assert(result.operationResult.get(4).entityId == 5);
        System.assert(result.operationResult.get(4).sfdcId != null);
        System.assert(result.operationResult.get(4).success);
        System.assert(!result.operationResult.get(4).created);
        System.assert(result.operationResult.get(4).errors == null);
        System.assert(result.operationResult.get(5).entityId == 6);
        System.assert(result.operationResult.get(5).sfdcId != null);
        System.assert(result.operationResult.get(5).success);
        System.assert(!result.operationResult.get(5).created);
        System.assert(result.operationResult.get(5).errors == null);

        System.assert(result.operationResult.get(6).entityId == 7);
        System.assert(result.operationResult.get(6).sfdcId == null);
        System.assert(result.operationResult.get(6).success);
        System.assert(!result.operationResult.get(6).created);
        System.assert(result.operationResult.get(6).errors == null);
        List<Entity> result7Entities = parseResultObjects(result.operationResult.get(6).resultObjectsAsString);
        System.assertEquals(1, result7Entities.size());
        System.assertEquals('Picklist_Mapping__c', result7Entities.get(0).SObjectType);
        System.assertEquals(2, result7Entities.get(0).Fields.size());
        System.assertEquals('Id', result7Entities.get(0).Fields.get(0).Name);
        System.assert(result7Entities.get(0).Fields.get(0).Value != null);
        System.assertEquals('Name', result7Entities.get(0).Fields.get(1).Name);
        System.assertEquals('MY_FIRST_ACCOUNT', result7Entities.get(0).Fields.get(1).Value);

        System.assert(result.operationResult.get(7).entityId == 8);
        System.assertEquals(account6.id, result.operationResult.get(7).sfdcId);
        System.assert(result.operationResult.get(7).success);
        System.assert(!result.operationResult.get(7).created);
        System.assert(result.operationResult.get(7).errors == null);

        account4 = [select Name from Picklist_Mapping__c where Id = :result.operationResult.get(0).sfdcId];
        System.assertEquals('MY_FOURTH_ACCOUNT_CHANGED', account4.Name);

        Picklist_Mapping__c account1 = [select Name from Picklist_Mapping__c where Id = :result.operationResult.get(1).sfdcId];
        System.assertEquals('MY_FIRST_ACCOUNT', account1.Name);

        Picklist_Mapping__c account2 = [select Name from Picklist_Mapping__c where Id = :result.operationResult.get(2).sfdcId];
        System.assertEquals('MY_SECOND_ACCOUNT', account2.Name);

        Integration_Picklist__c account3 = [select Name from Integration_Picklist__c where Id = :result.operationResult.get(3).sfdcId];
        System.assertEquals('MY_THIRD_ACCOUNT', account3.Name);

        account5 = [select Name from Integration_Picklist__c where Id = :result.operationResult.get(4).sfdcId];
        System.assertEquals('MY_FIFTH_ACCOUNT_CHANGED', account5.Name);

        List<Integration_Picklist__c> deletedAccount6 = [Select Name From Integration_Picklist__c Where Id = :account6.ID];
        System.assert(deletedAccount6.size() == 0);
    }

    public static testmethod void testExecuteCompoundMultipleTypesIllegalUpsert()
    {
        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000001"}, {"Name":"Name","Value":"MY_FIRST_ACCOUNT"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000002"}, {"Name":"Name","Value":"MY_SECOND_ACCOUNT"}, {"Name":"Object_Name__c","Value":"OBJECT2"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000002"}, {"Name":"Name","Value":"MY_SECOND_ACCOUNT_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT21"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c"}';
        String objectsAsJson = '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ', ' + object3AsJson + ']}';
        EpAdapterUnitOfWork__c unitOfWork = createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.COMPOUND_MULTIPLE_TYPES);

        test.startTest();
        UnitOfWorkResponse result = new UowDecompiler().decompile(unitOfWork, objectsAsJson);
        test.stopTest();

        System.assert(result.unitOfWorkId == 1l);
        System.assert(result.sfdcId != null);
        System.assert(result.status == UnitOfWorkStatus.PROCESSED);
        System.assertEquals(3, result.operationResult.size());

        // TODO futher assertions
    }

    public static testmethod void testExecuteUpdateSameId()
    {
        Picklist_Mapping__c account1 = new Picklist_Mapping__c(Name = 'MY_FIRST_ACCOUNT', Object_Name__c = 'OBJECT1', Field_Name__c = 'FIELD');
        insert account1;

        Picklist_Mapping__c account2 = new Picklist_Mapping__c(Name = 'MY_SECOND_ACCOUNT', Object_Name__c = 'OBJECT2', Field_Name__c = 'FIELD');
        insert account2;

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"' + account1.Id + '"}, {"Name":"Name","Value":"MY_FIRST_ACCOUNT_CHANGE_1"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"' + account2.Id + '"}, {"Name":"Name","Value":"MY_SECOND_ACCOUNT_CHANGE_1"}, {"Name":"Object_Name__c","Value":"OBJECT2"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"' + account1.Id + '"}, {"Name":"Name","Value":"MY_FIRST_ACCOUNT_CHANGE_2"}, {"Name":"Object_Name__c","Value":"OBJECT3"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String objectsAsJson = '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ', ' + object3AsJson + ']}';
        EpAdapterUnitOfWork__c unitOfWork = createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_MULTIPLE);

        test.startTest();
        UnitOfWorkResponse result = new UowDecompiler().decompile(unitOfWork, objectsAsJson);
        test.stopTest();

        System.assert(result.unitOfWorkId == 1l);
        System.assert(result.sfdcId != null);
        System.assert(result.status == UnitOfWorkStatus.PROCESSED);
        System.assertEquals(3, result.operationResult.size());
        System.assertEquals(1, result.operationResult.get(0).entityId);
        System.assert(result.operationResult.get(0).sfdcId != null);
        System.assert(result.operationResult.get(0).success);
        System.assert(!result.operationResult.get(0).created);
        System.assert(result.operationResult.get(0).errors == null);
        System.assert(result.operationResult.get(1).entityId == 2);
        System.assert(result.operationResult.get(1).sfdcId != null);
        System.assert(result.operationResult.get(1).success);
        System.assert(!result.operationResult.get(1).created);
        System.assert(result.operationResult.get(1).errors == null);
        System.assert(result.operationResult.get(2).entityId == 3);
        System.assert(result.operationResult.get(2).sfdcId != null);
        System.assert(result.operationResult.get(2).success);
        System.assert(!result.operationResult.get(2).created);
        System.assert(result.operationResult.get(2).errors == null);

        account1 = [select Name, Object_Name__c, Field_Name__c from Picklist_Mapping__c where Id = :result.operationResult.get(0).sfdcId];
        System.assertEquals('MY_FIRST_ACCOUNT_CHANGE_2', account1.Name);
        System.assertEquals('OBJECT3', account1.Object_Name__c);
        System.assertEquals('FIELD', account1.Field_Name__c);

        account2 = [select Name, Object_Name__c, Field_Name__c from Picklist_Mapping__c where Id = :result.operationResult.get(1).sfdcId];
        System.assertEquals('MY_SECOND_ACCOUNT_CHANGE_1', account2.Name);
        System.assertEquals('OBJECT2', account2.Object_Name__c);
    }

    public static testmethod void testExecuteDifferentAttributeTypes()
    {
        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Opportunity", "operationType":"INSERT", "fields": [{"name":"Name","value":"testExecuteDifferentAttributeTypes"},{"name":"TotalOpportunityQuantity","value":"10"},{"name":"IsPrivate","value":"true"},{"name":"CloseDate","value":"2015-03-17"},{"name":"StageName","value":"STAGE"}]}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Event", "operationType":"INSERT", "fields": [{"name":"DurationInMinutes","value":"10"},{"name":"IsVisibleInSelfService","value":"true"},{"name":"StartDateTime","value":"2015-03-18 12:13:14"}]}';
        String objectsAsJson = '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}';
        EpAdapterUnitOfWork__c unitOfWork = createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.COMPOUND_MULTIPLE_TYPES);

        test.startTest();
        UnitOfWorkResponse result = new UowDecompiler().decompile(unitOfWork, objectsAsJson);
        test.stopTest();

        System.assert(result.unitOfWorkId == 1l);
        System.assert(result.sfdcId != null);
        //System.assert(result.status == UnitOfWorkStatus.PROCESSED);
        System.assertEquals(2, result.operationResult.size());
        System.assertEquals(1, result.operationResult.get(0).entityId);
        //System.assert(result.operationResult.get(0).sfdcId != null);
        //System.assert(result.operationResult.get(0).success);
        //System.assert(result.operationResult.get(0).created);
        System.assert(result.operationResult.get(0).errors == null);
        System.assertEquals(2, result.operationResult.get(1).entityId);
        //System.assert(result.operationResult.get(1).sfdcId != null);
        //System.assert(result.operationResult.get(1).success);
        //System.assert(result.operationResult.get(1).created);
        //System.assert(result.operationResult.get(1).errors == null);

        /*Opportunity object1 = [select Name, TotalOpportunityQuantity, IsPrivate, CloseDate from Opportunity where Id = :result.operationResult.get(0).sfdcId];
        System.assertEquals('testExecuteDifferentAttributeTypes', object1.Name);
        System.assertEquals(10, object1.TotalOpportunityQuantity);
        System.assertEquals(true, object1.IsPrivate);
        System.assertEquals(2015, object1.CloseDate.year());
        System.assertEquals(3, object1.CloseDate.month());
        System.assertEquals(17, object1.CloseDate.day());

        Event object2 = [select DurationInMinutes, IsVisibleInSelfService, StartDateTime from Event where Id = :result.operationResult.get(1).sfdcId];
        System.assertEquals(10, object2.DurationInMinutes);
        System.assertEquals(true, object2.IsVisibleInSelfService);
        System.assertEquals(2015, object2.StartDateTime.year());
        System.assertEquals(3, object2.StartDateTime.month());
        System.assertEquals(18, object2.StartDateTime.day());
        System.assertEquals(12, object2.StartDateTime.hour());
        System.assertEquals(13, object2.StartDateTime.minute());
        System.assertEquals(14, object2.StartDateTime.second());*/
    }

    public static testmethod void testExecuteSoqlQuery()
    {
        Picklist_Mapping__c account1 = new Picklist_Mapping__c(Name = 'MY_FIRST_ACCOUNT', Object_Name__c = '4711', Field_Name__c = 'FIELD');
        insert account1;

        Picklist_Mapping__c account2 = new Picklist_Mapping__c(Name = 'MY_SECOND_ACCOUNT', Object_Name__c = 'OBJECT2', Field_Name__c = 'FIELD');
        insert account2;

        Picklist_Mapping__c account3 = new Picklist_Mapping__c(Name = 'MY_THIRD_ACCOUNT', Object_Name__c = '4711', Field_Name__c = 'FIELD');
        insert account3;

        Picklist_Mapping__c account4 = new Picklist_Mapping__c(Name = 'MY_FOURTH_ACCOUNT', Object_Name__c = 'OBJECT4', Field_Name__c = 'FIELD');
        insert account4;

        Integration_Picklist__c account5 = new Integration_Picklist__c(Name = 'MY_FIFTH_ACCOUNT', Picklist_Mapping__c = account1.Id, Picklist_Value__c = 'VALUE');
        insert account5;

        Integration_Picklist__c account6 = new Integration_Picklist__c(Name = 'MY_SIXTH_ACCOUNT', Picklist_Mapping__c = account1.Id, Picklist_Value__c = '4711');
        insert account6;

        Integration_Picklist__c account7 = new Integration_Picklist__c(Name = 'MY_SEVENTH_ACCOUNT', Picklist_Mapping__c = account1.Id, Picklist_Value__c = '4711');
        insert account7;

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "fields": [{"name":"Id","value":""}, {"name":"Name","value":""}], "whereClause":"Object_Name__c = \'4711\'"}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Integration_Picklist__c", "fields": [{"name":"Id","value":""}, {"name":"Name","value":""}], "whereClause":"Picklist_Value__c = \'4711\'"}';
        String objectsAsJson = '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}';
        EpAdapterUnitOfWork__c unitOfWork = createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.SOQL);

        test.startTest();
        UnitOfWorkResponse result = new UowDecompiler().decompile(unitOfWork, objectsAsJson);
        test.stopTest();

        System.assert(result.unitOfWorkId == 1l);
        System.assert(result.status == UnitOfWorkStatus.PROCESSED);
        System.assertEquals(2, result.operationResult.size());

        System.assertEquals(1, result.operationResult.get(0).entityId);
        System.assertEquals(true, result.operationResult.get(0).success);
        System.assertEquals(false, result.operationResult.get(0).created);
        List<Entity> result1Entities = parseResultObjects(result.operationResult.get(0).resultObjectsAsString);
        System.assertEquals(2, result1Entities.size());
        System.assertEquals('Picklist_Mapping__c', result1Entities.get(0).SObjectType);
        System.assertEquals(2, result1Entities.get(0).Fields.size());
        System.assertEquals('Id', result1Entities.get(0).Fields.get(0).Name);
        System.assert(result1Entities.get(0).Fields.get(0).Value != null);
        System.assertEquals('Name', result1Entities.get(0).Fields.get(1).Name);
        System.assertEquals('MY_FIRST_ACCOUNT', result1Entities.get(0).Fields.get(1).Value);
        System.assertEquals('Picklist_Mapping__c', result1Entities.get(1).SObjectType);
        System.assertEquals('Id', result1Entities.get(1).Fields.get(0).Name);
        System.assert(result1Entities.get(1).Fields.get(0).Value != null);
        System.assertEquals('Name', result1Entities.get(1).Fields.get(1).Name);
        System.assertEquals('MY_THIRD_ACCOUNT', result1Entities.get(1).Fields.get(1).Value);

        System.assertEquals(2, result.operationResult.get(1).entityId);
        System.assertEquals(true, result.operationResult.get(1).success);
        System.assertEquals(false, result.operationResult.get(1).created);
        List<Entity> result2Entities = parseResultObjects(result.operationResult.get(1).resultObjectsAsString);
        System.assertEquals(2, result2Entities.size());
        System.assertEquals('Integration_Picklist__c', result2Entities.get(0).SObjectType);
        System.assertEquals(2, result2Entities.get(0).Fields.size());
        System.assertEquals('Id', result2Entities.get(0).Fields.get(0).Name);
        System.assert(result2Entities.get(0).Fields.get(0).Value != null);
        System.assertEquals('Name', result2Entities.get(0).Fields.get(1).Name);
        System.assertEquals('MY_SIXTH_ACCOUNT', result2Entities.get(0).Fields.get(1).Value);
        System.assertEquals('Integration_Picklist__c', result2Entities.get(1).SObjectType);
        System.assertEquals('Id', result2Entities.get(1).Fields.get(0).Name);
        System.assert(result2Entities.get(1).Fields.get(0).Value != null);
        System.assertEquals('Name', result2Entities.get(1).Fields.get(1).Name);
        System.assertEquals('MY_SEVENTH_ACCOUNT', result2Entities.get(1).Fields.get(1).Value);

        System.debug(result.operationResult.get(0).resultObjectsAsString);
    }


    public static testmethod void testExecuteSoqlQueryFailure()
    {
        Picklist_Mapping__c account1 = new Picklist_Mapping__c(Name = 'MY_FIRST_ACCOUNT', Object_Name__c = '4711', Field_Name__c = 'FIELD');
        insert account1;

        Picklist_Mapping__c account2 = new Picklist_Mapping__c(Name = 'MY_SECOND_ACCOUNT', Object_Name__c = 'OBJECt2', Field_Name__c = 'FIELD');
        insert account2;

        Picklist_Mapping__c account3 = new Picklist_Mapping__c(Name = 'MY_THIRD_ACCOUNT', Object_Name__c = '4711', Field_Name__c = 'FIELD');
        insert account3;

        Picklist_Mapping__c account4 = new Picklist_Mapping__c(Name = 'MY_FOURTH_ACCOUNT', Object_Name__c = 'OBJECT4', Field_Name__c = 'FIELD');
        insert account4;

        Integration_Picklist__c account5 = new Integration_Picklist__c(Name = 'MY_FIFTH_ACCOUNT', Picklist_Mapping__c = account1.Id, Picklist_Value__c = 'VALUE');
        insert account5;

        Integration_Picklist__c account6 = new Integration_Picklist__c(Name = 'MY_SIXTH_ACCOUNT', Picklist_Mapping__c = account1.Id, Picklist_Value__c = '4711');
        insert account6;

        Integration_Picklist__c account7 = new Integration_Picklist__c(Name = 'MY_SEVENTH_ACCOUNT', Picklist_Mapping__c = account1.Id, Picklist_Value__c = '4711');
        insert account7;

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "fields": [{"name":"Id","value":""}, {"name":"Name","value":""}], "whereClause":"Object_Name__c equals \'4711\'"}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Integration_Picklist__c", "fields": [{"name":"Id","value":""}, {"name":"Name","value":""}], "whereClause":"Picklist_Value__c = \'4711\'"}';
        String objectsAsJson = '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}';
        EpAdapterUnitOfWork__c unitOfWork = createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.SOQL);

        test.startTest();
        UnitOfWorkResponse result = new UowDecompiler().decompile(unitOfWork, objectsAsJson);
        test.stopTest();

        System.assert(result.unitOfWorkId == 1l);
        System.assert(result.status == UnitOfWorkStatus.FAILED);
        System.assertEquals(2, result.operationResult.size());

        System.assertEquals(1, result.operationResult.get(0).entityId);
        System.assertEquals(false, result.operationResult.get(0).success);
        System.assertEquals(false, result.operationResult.get(0).created);

        System.assertEquals(2, result.operationResult.get(1).entityId);
        System.assertEquals(true, result.operationResult.get(1).success);
        System.assertEquals(false, result.operationResult.get(1).created);
        List<Entity> result2Entities = parseResultObjects(result.operationResult.get(1).resultObjectsAsString);
        System.assertEquals(2, result2Entities.size());
        System.assertEquals('Integration_Picklist__c', result2Entities.get(0).SObjectType);
        System.assertEquals(2, result2Entities.get(0).Fields.size());
        System.assertEquals('Id', result2Entities.get(0).Fields.get(0).Name);
        System.assert(result2Entities.get(0).Fields.get(0).Value != null);
        System.assertEquals('Name', result2Entities.get(0).Fields.get(1).Name);
        System.assertEquals('MY_SIXTH_ACCOUNT', result2Entities.get(0).Fields.get(1).Value);
        System.assertEquals('Integration_Picklist__c', result2Entities.get(1).SObjectType);
        System.assertEquals('Id', result2Entities.get(1).Fields.get(0).Name);
        System.assert(result2Entities.get(1).Fields.get(0).Value != null);
        System.assertEquals('Name', result2Entities.get(1).Fields.get(1).Name);
        System.assertEquals('MY_SEVENTH_ACCOUNT', result2Entities.get(1).Fields.get(1).Value);

        System.debug(result.operationResult.get(0).resultObjectsAsString);
    }

    private static List<Entity> parseResultObjects(String aResultObjectsAsJson)
    {
        List<Entity> result = new List<Entity>();
        JSONParser parser = JSON.createParser(aResultObjectsAsJson);

        while (parser.nextToken() != null) {
            // Start at the array of entities.
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    // Advance to the start object marker to
                    //  find next entity statement object.
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        // Read entire invoice object, including its array of fields.
                        Entity e = (Entity)parser.readValueAs(Entity.class);

                        result.add(e);

                        // Skip the child start array and start object markers.
                        parser.skipChildren();
                    }
                }
            }
        }

        return result;
    }

    private static EpAdapterUnitOfWork__c createUnitOfWork(long aUnitOfWorkId, Datetime aTriggeredDateTime, UnitOfWorkType aType)
    {
        EpAdapterUnitOfTransfer__c uot = new EpAdapterUnitOfTransfer__c();
        uot.UnitOfTransferId__c = 1l;
        insert uot;

        EpAdapterUnitOfWork__c result = new EpAdapterUnitOfWork__c();
        result.UnitOfWorkId__c = aUnitOfWorkId;
        result.TriggeredDateTime__c = aTriggeredDateTime;
        result.Type__c = aType.name();
        result.UnitOfTransfer__c = uot.Id;
        insert result;

        return result;
    }
}