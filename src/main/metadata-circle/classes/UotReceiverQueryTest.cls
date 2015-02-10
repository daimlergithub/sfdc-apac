@isTest
public class UotReceiverQueryTest
{
    static testmethod void testExecuteAtomicSingleQuery()
    {
        Picklist_Mapping__c account1 = new Picklist_Mapping__c(Name = 'MY_FIRST_ACCOUNT', Object_Name__c = 'OBJECT1', Field_Name__c = 'FIELD');
        insert account1;
        Picklist_Mapping__c account2 = new Picklist_Mapping__c(Name = 'MY_SECOND_ACCOUNT', Object_Name__c = 'OBJECT2', Field_Name__c = 'FIELD');
        insert account2;
        Picklist_Mapping__c account3 = new Picklist_Mapping__c(Name = 'MY_THIRD_ACCOUNT', Object_Name__c = 'OBJECT3', Field_Name__c = 'FIELD');
        insert account3;

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":11, "sObjectType":"Picklist_Mapping__c", "operationType":"QUERY", "fields": [{"name":"Id","value":""}, {"name":"Name","value":""}], "whereClause":"Name = \'MY_FIRST_ACCOUNT\'"}';
        String object2AsJson = '{"uniqueId":12, "sObjectType":"Picklist_Mapping__c", "operationType":"QUERY", "fields": [{"name":"Id","value":""}, {"name":"Name","value":""}], "whereClause":"Name = \'MY_SECOND_ACCOUNT\'"}';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_SINGLE, '4711', '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}'));

        String object3AsJson = '{"uniqueId":13, "sObjectType":"Picklist_Mapping__c", "operationType":"QUERY", "fields": [{"name":"Id","value":""}, {"name":"Name","value":""}], "whereClause":"Name = \'MY_THIRD_ACCOUNT\'"}';
        unitsOfWork.add(createUnitOfWork(2l, DateTime.now(), UnitOfWorkType.ATOMIC_SINGLE, '4712', '{"entityList":[' + object3AsJson + ']}'));

        test.startTest();
        List<UnitOfWorkResponse> result = UotReceiver.execute(1, unitsOfWork, true).UnitOfWorkResponses;
        test.stopTest();

        System.assert(result.size() == 2);

        UnitOfWorkResponse result1 = result.get(0);
        System.assert(result1.unitOfWorkId == 1l);
        System.assert(result1.sfdcId != null);
        System.assert(result1.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result1.operationResult.size() == 2);

        System.assert(result1.operationResult.get(0).entityId == 11);
        System.assert(result1.operationResult.get(0).sfdcId == null);
        System.assert(result1.operationResult.get(0).success);
        System.assert(!result1.operationResult.get(0).created);
        System.assert(result1.operationResult.get(0).errors == null);
        List<Entity> result1Entities = parseResultObjects(result1.operationResult.get(0).resultObjectsAsString);
        System.assertEquals(1, result1Entities.size());
        //TODO : Changing assertion values with the one expected with namespace prefix.
        System.assertEquals('oliverkoethap1__Picklist_Mapping__c', result1Entities.get(0).SObjectType);
        System.assertEquals(2, result1Entities.get(0).Fields.size());
        System.assertEquals('Id', result1Entities.get(0).Fields.get(0).Name);
        System.assert(result1Entities.get(0).Fields.get(0).Value != null);
        System.assertEquals('Name', result1Entities.get(0).Fields.get(1).Name);
        System.assertEquals('MY_FIRST_ACCOUNT', result1Entities.get(0).Fields.get(1).Value);

        System.assert(result1.operationResult.get(1).entityId == 12);
        System.assert(result1.operationResult.get(1).sfdcId == null);
        System.assert(result1.operationResult.get(1).success);
        System.assert(!result1.operationResult.get(1).created);
        System.assert(result1.operationResult.get(1).errors == null);
        List<Entity> result2Entities = parseResultObjects(result1.operationResult.get(1).resultObjectsAsString);
        System.assertEquals(1, result2Entities.size());
        //TODO changing assertion values.
        System.assertEquals('oliverkoethap1__Picklist_Mapping__c', result2Entities.get(0).SObjectType);
        System.assertEquals(2, result2Entities.get(0).Fields.size());
        System.assertEquals('Id', result2Entities.get(0).Fields.get(0).Name);
        System.assert(result2Entities.get(0).Fields.get(0).Value != null);
        System.assertEquals('Name', result2Entities.get(0).Fields.get(1).Name);
        System.assertEquals('MY_SECOND_ACCOUNT', result2Entities.get(0).Fields.get(1).Value);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork1 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result1.sfdcId];
        System.assertEquals(1l, epAdapterUnitOfWork1.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_SINGLE', epAdapterUnitOfWork1.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork1.Status__c);

        UnitOfWorkResponse result2 = result.get(1);
        System.assert(result2.unitOfWorkId == 2l);
        System.assert(result2.sfdcId != null);
        System.assert(result2.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result2.operationResult.size() == 1);
        System.assert(result2.operationResult.get(0).entityId == 13);
        System.assert(result2.operationResult.get(0).sfdcId == null);
        System.assert(result2.operationResult.get(0).success);
        System.assert(!result2.operationResult.get(0).created);
        System.assert(result2.operationResult.get(0).errors == null);
        List<Entity> result3Entities = parseResultObjects(result2.operationResult.get(0).resultObjectsAsString);
        System.assertEquals(1, result3Entities.size());
        System.assertEquals('Picklist_Mapping__c', result3Entities.get(0).SObjectType);
        System.assertEquals(2, result3Entities.get(0).Fields.size());
        System.assertEquals('Id', result3Entities.get(0).Fields.get(0).Name);
        System.assert(result3Entities.get(0).Fields.get(0).Value != null);
        System.assertEquals('Name', result3Entities.get(0).Fields.get(1).Name);
        System.assertEquals('MY_THIRD_ACCOUNT', result3Entities.get(0).Fields.get(1).Value);
    }

    static testmethod void testExecuteQueryChildObjects()
    {
        Picklist_Mapping__c parent1 = new Picklist_Mapping__c(Name = 'MY_FIRST_PARENT', Object_Name__c = 'OBJECT1', Field_Name__c = 'FIELD');
        insert parent1;

        Integration_Picklist__c child11 = new Integration_Picklist__c(Picklist_Mapping__c = parent1.Id, Name = 'MY_FIRST_CHILD', Picklist_Value__c = 'VALUE');
        insert child11;

        Integration_Picklist__c child12 = new Integration_Picklist__c(Picklist_Mapping__c = parent1.Id, Name = 'MY_SECOND_CHILD', Picklist_Value__c = 'VALUE');
        insert child12;

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"QUERY", "fields": [{"name":"Id"}, {"name":"Name"}, {"name":"Integration_Picklists__r","subEntities":[{"sObjectType":"Integration_Picklist__c", "fields": [{"name":"Id"}, {"name":"Name"}]}]}], "whereClause":"Name = \'MY_FIRST_PARENT\'"}';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_SINGLE, '4711', '{"entityList":[' + object1AsJson + ']}'));

        test.startTest();
        List<UnitOfWorkResponse> result = UotReceiver.execute(1, unitsOfWork, true).UnitOfWorkResponses;
        test.stopTest();

        System.assert(result.size() == 1);

        UnitOfWorkResponse result1 = result.get(0);
        System.assert(result1.unitOfWorkId == 1l);
        System.assert(result1.sfdcId != null);
        System.assert(result1.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result1.operationResult.size() == 1);

        System.assert(result1.operationResult.get(0).entityId == 1);
        System.assert(result1.operationResult.get(0).sfdcId == null);
        System.assert(result1.operationResult.get(0).success);
        System.assert(!result1.operationResult.get(0).created);
        System.assert(result1.operationResult.get(0).errors == null);
        List<Entity> result1Entities = parseResultObjects(result1.operationResult.get(0).resultObjectsAsString);
        System.assertEquals(1, result1Entities.size());
        System.assertEquals('Picklist_Mapping__c', result1Entities.get(0).SObjectType);
        System.assertEquals(3, result1Entities.get(0).Fields.size());
        System.assertEquals('Id', result1Entities.get(0).Fields.get(0).Name);
        System.assertEquals(parent1.Id, result1Entities.get(0).Fields.get(0).Value);
        System.assertEquals('Name', result1Entities.get(0).Fields.get(1).Name);
        System.assertEquals('MY_FIRST_PARENT', result1Entities.get(0).Fields.get(1).Value);
        System.assertEquals('Integration_Picklists__r', result1Entities.get(0).Fields.get(2).Name);
        System.assert(result1Entities.get(0).Fields.get(2).Value == null);
        System.assert(result1Entities.get(0).Fields.get(2).SubEntities != null);
        List<Entity> subEntities = result1Entities.get(0).Fields.get(2).SubEntities;
        System.assertEquals(2, subEntities.size());
        System.assertEquals('Id', subEntities.get(0).Fields.get(0).Name);
        System.assertEquals(child11.Id, subEntities.get(0).Fields.get(0).Value);
        System.assertEquals('Name', subEntities.get(0).Fields.get(1).Name);
        System.assertEquals('MY_FIRST_CHILD', subEntities.get(0).Fields.get(1).Value);
        System.assertEquals('Id', subEntities.get(1).Fields.get(0).Name);
        System.assertEquals(child12.Id, subEntities.get(1).Fields.get(0).Value);
        System.assertEquals('Name', subEntities.get(1).Fields.get(1).Name);
        System.assertEquals('MY_SECOND_CHILD', subEntities.get(1).Fields.get(1).Value);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork1 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result1.sfdcId];
        System.assertEquals(1l, epAdapterUnitOfWork1.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_SINGLE', epAdapterUnitOfWork1.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork1.Status__c);
    }

    static testmethod void testExecuteQueryParentObject()
    {
        Picklist_Mapping__c parent1 = new Picklist_Mapping__c(Name = 'MY_FIRST_PARENT', Object_Name__c = 'OBJECT1', Field_Name__c = 'FIELD');
        insert parent1;

        Integration_Picklist__c child11 = new Integration_Picklist__c(Picklist_Mapping__c = parent1.Id, Name = 'MY_FIRST_CHILD', Picklist_Value__c = 'VALUE');
        insert child11;

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Integration_Picklist__c", "operationType":"QUERY", "fields": [{"name":"Id"}, {"name":"Name"}, {"name":"Picklist_Mapping__r","subEntities":[{"sObjectType":"Picklist_Mapping__c", "fields": [{"name":"Id"}, {"name":"Name"}]}]}], "whereClause":"Name = \'MY_FIRST_CHILD\'"}';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_SINGLE, '4711', '{"entityList":[' + object1AsJson + ']}'));

        test.startTest();
        List<UnitOfWorkResponse> result = UotReceiver.execute(1, unitsOfWork, true).UnitOfWorkResponses;
        test.stopTest();

        System.assert(result.size() == 1);

        UnitOfWorkResponse result1 = result.get(0);
        System.assert(result1.unitOfWorkId == 1l);
        System.assert(result1.sfdcId != null);
        System.assert(result1.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result1.operationResult.size() == 1);

        System.assert(result1.operationResult.get(0).entityId == 1);
        System.assert(result1.operationResult.get(0).sfdcId == null);
        System.assert(result1.operationResult.get(0).success);
        System.assert(!result1.operationResult.get(0).created);
        System.assert(result1.operationResult.get(0).errors == null);
        List<Entity> result1Entities = parseResultObjects(result1.operationResult.get(0).resultObjectsAsString);
        System.assertEquals(1, result1Entities.size());
        //TODO changing assertion value.
        System.assertEquals('oliverkoethap1__Integration_Picklist__c', result1Entities.get(0).SObjectType);
        System.assertEquals(3, result1Entities.get(0).Fields.size());
        System.assertEquals('Id', result1Entities.get(0).Fields.get(0).Name);
        System.assertEquals(child11.Id, result1Entities.get(0).Fields.get(0).Value);
        System.assertEquals('Name', result1Entities.get(0).Fields.get(1).Name);
        System.assertEquals('MY_FIRST_CHILD', result1Entities.get(0).Fields.get(1).Value);
        System.assertEquals('Picklist_Mapping__r', result1Entities.get(0).Fields.get(2).Name);
        System.assert(result1Entities.get(0).Fields.get(2).Value == null);
        System.assert(result1Entities.get(0).Fields.get(2).SubEntities != null);
        List<Entity> subEntities = result1Entities.get(0).Fields.get(2).SubEntities;
        System.assertEquals(1, subEntities.size());
        System.assertEquals('Id', subEntities.get(0).Fields.get(0).Name);
        System.assertEquals(parent1.Id, subEntities.get(0).Fields.get(0).Value);
        System.assertEquals('Name', subEntities.get(0).Fields.get(1).Name);
        System.assertEquals('MY_FIRST_PARENT', subEntities.get(0).Fields.get(1).Value);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork1 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result1.sfdcId];
        System.assertEquals(1l, epAdapterUnitOfWork1.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_SINGLE', epAdapterUnitOfWork1.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork1.Status__c);
    }


    static testmethod void testExecuteAtomicMultipleQuery()
    {
        Picklist_Mapping__c account1 = new Picklist_Mapping__c(Name = 'MY_FIRST_ACCOUNT', Object_Name__c = 'OBJECT1', Field_Name__c = 'FIELD1');
        insert account1;
        Picklist_Mapping__c account2 = new Picklist_Mapping__c(Name = 'MY_SECOND_ACCOUNT', Object_Name__c = 'OBJECT2', Field_Name__c = 'FIELD2');
        insert account2;
        Picklist_Mapping__c account3 = new Picklist_Mapping__c(Name = 'MY_THIRD_ACCOUNT', Object_Name__c = 'OBJECT3', Field_Name__c = 'FIELD3');
        insert account3;

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"QUERY", "fields": [{"name":"Id","value":""}, {"name":"Name","value":""}], "whereClause":"Name = \'MY_FIRST_ACCOUNT\'"}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"QUERY", "fields": [{"name":"Id","value":""}, {"name":"Name","value":""}], "whereClause":"Name = \'MY_SECOND_ACCOUNT\'"}';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_MULTIPLE, '4711', '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}'));

        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"QUERY", "fields": [{"name":"Id","value":""}, {"name":"Name","value":""}], "whereClause":"Name = \'MY_THIRD_ACCOUNT\'"}';
        unitsOfWork.add(createUnitOfWork(2l, DateTime.now(), UnitOfWorkType.ATOMIC_MULTIPLE, '4712', '{"entityList":[' + object3AsJson + ']}'));

        List<UnitOfWorkResponse> result = UotReceiver.execute(1, unitsOfWork, true).UnitOfWorkResponses;

        System.assert(result.size() == 2);

        UnitOfWorkResponse result1 = result.get(0);
        System.assert(result1.unitOfWorkId == 1l);
        System.assert(result1.sfdcId != null);
        System.assert(result1.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result1.operationResult.size() == 2);

        System.assert(result1.operationResult.get(0).entityId == 1);
        System.assert(result1.operationResult.get(0).sfdcId == null);
        System.assert(result1.operationResult.get(0).success);
        System.assert(!result1.operationResult.get(0).created);
        System.assert(result1.operationResult.get(0).errors == null);
        List<Entity> result1Entities = parseResultObjects(result1.operationResult.get(0).resultObjectsAsString);
        System.assertEquals(1, result1Entities.size());
        //TODO : Changing assertion values with the one expected with namespace prefix.
        System.assertEquals('oliverkoethap1__Picklist_Mapping__c', result1Entities.get(0).SObjectType);
        System.assertEquals(2, result1Entities.get(0).Fields.size());
        System.assertEquals('Id', result1Entities.get(0).Fields.get(0).Name);
        System.assert(result1Entities.get(0).Fields.get(0).Value != null);
        System.assertEquals('Name', result1Entities.get(0).Fields.get(1).Name);
        System.assertEquals('MY_FIRST_ACCOUNT', result1Entities.get(0).Fields.get(1).Value);

        System.assert(result1.operationResult.get(1).entityId == 2);
        System.assert(result1.operationResult.get(1).sfdcId == null);
        System.assert(result1.operationResult.get(1).success);
        System.assert(!result1.operationResult.get(1).created);
        System.assert(result1.operationResult.get(1).errors == null);
        List<Entity> result2Entities = parseResultObjects(result1.operationResult.get(1).resultObjectsAsString);
        System.assertEquals(1, result2Entities.size());
        //TODO : Changing assertion values with the one expected with namespace prefix.
        System.assertEquals('oliverkoethap1__Picklist_Mapping__c', result2Entities.get(0).SObjectType);
        System.assertEquals(2, result2Entities.get(0).Fields.size());
        System.assertEquals('Id', result2Entities.get(0).Fields.get(0).Name);
        System.assert(result2Entities.get(0).Fields.get(0).Value != null);
        System.assertEquals('Name', result2Entities.get(0).Fields.get(1).Name);
        System.assertEquals('MY_SECOND_ACCOUNT', result2Entities.get(0).Fields.get(1).Value);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork1 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result1.sfdcId];
        System.assertEquals(1l, epAdapterUnitOfWork1.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_MULTIPLE', epAdapterUnitOfWork1.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork1.Status__c);

        UnitOfWorkResponse result2 = result.get(1);
        System.assert(result2.unitOfWorkId == 2l);
        System.assert(result2.sfdcId != null);
        System.assert(result2.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result2.operationResult.size() == 1);
        System.assert(result2.operationResult.get(0).entityId == 3);
        System.assert(result2.operationResult.get(0).sfdcId == null);
        System.assert(result2.operationResult.get(0).success);
        System.assert(!result2.operationResult.get(0).created);
        System.assert(result2.operationResult.get(0).errors == null);
        List<Entity> result3Entities = parseResultObjects(result2.operationResult.get(0).resultObjectsAsString);
        System.assertEquals(1, result3Entities.size());
        //TODO changing assertion value.
        System.assertEquals('oliverkoethap1__Picklist_Mapping__c', result3Entities.get(0).SObjectType);
        System.assertEquals(2, result3Entities.get(0).Fields.size());
        System.assertEquals('Id', result3Entities.get(0).Fields.get(0).Name);
        System.assert(result3Entities.get(0).Fields.get(0).Value != null);
        System.assertEquals('Name', result3Entities.get(0).Fields.get(1).Name);
        System.assertEquals('MY_THIRD_ACCOUNT', result3Entities.get(0).Fields.get(1).Value);
    }

    static testmethod void testExecuteStandardRelationships()
    {
          Contact contact1 = new Contact(LastName = 'Contact 1');
        insert contact1;
        Account account1 = new Account(Name = 'Account 1');
        insert account1;
        AccountContactRole role = new AccountContactRole(ContactId = contact1.Id, AccountId = account1.Id, Role = 'Role');
        insert role;

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"AccountContactRole", "operationType":"QUERY", "fields": [{"name":"Id","value":""}, {"name":"Role","value":""}, {"name":"Contact","subEntities":[{"sObjectType":"Contact","fields":[{"name":"Id"},{"name":"Name"}]}]}], "whereClause":"ContactId=\'' + contact1.Id + '\'"}';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_SINGLE, '4711', '{"entityList":[' + object1AsJson + ']}'));

        test.startTest();
        List<UnitOfWorkResponse> result = UotReceiver.execute(1, unitsOfWork, true).UnitOfWorkResponses;
        test.stopTest();

        System.assert(result.size() == 1);

        UnitOfWorkResponse result1 = result.get(0);
        System.assert(result1.unitOfWorkId == 1l);
        System.assert(result1.sfdcId != null);
        System.assert(result1.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result1.operationResult.size() == 1);

        System.assert(result1.operationResult.get(0).entityId == 1);
        System.assert(result1.operationResult.get(0).sfdcId == null);
        System.assert(result1.operationResult.get(0).success);
        System.assert(!result1.operationResult.get(0).created);
        System.assert(result1.operationResult.get(0).errors == null);
        List<Entity> result1Entities = parseResultObjects(result1.operationResult.get(0).resultObjectsAsString);
        System.assertEquals(1, result1Entities.size());
        System.assertEquals('AccountContactRole', result1Entities.get(0).SObjectType);
        System.assertEquals(3, result1Entities.get(0).Fields.size());
        System.assertEquals('Id', result1Entities.get(0).Fields.get(0).Name);
        System.assert(result1Entities.get(0).Fields.get(0).Value != null);
        System.assertEquals('Role', result1Entities.get(0).Fields.get(1).Name);
        System.assertEquals('Role', result1Entities.get(0).Fields.get(1).Value);
        System.assertEquals('Contact', result1Entities.get(0).Fields.get(2).Name);
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

    private static UnitOfWork createUnitOfWork(long aUnitOfWorkId, Datetime aTriggeredDateTime, UnitOfWorkType aType, String aBtlId, String aObjectsAsString)
    {
        UnitOfWork result = new UnitOfWork();
        result.unitOfWorkId = aUnitOfWorkId;
        result.triggeredDateTime = aTriggeredDateTime;
        result.type = aType;
        result.btlId = aBtlId;
        result.objectsAsString = aObjectsAsString;
        return result;
    }
}