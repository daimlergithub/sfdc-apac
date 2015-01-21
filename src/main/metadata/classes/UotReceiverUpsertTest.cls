@isTest
public class UotReceiverUpsertTest
{
    static testmethod void testExecuteAtomicSingleUpsert()
    {
        Picklist_Mapping__c account1 = new Picklist_Mapping__c(Name = 'MY_FIRST_PICKLIST', Object_Name__c = 'OBJECT1', Field_Name__c = 'FIELD');
        insert account1;
        Picklist_Mapping__c account3 = new Picklist_Mapping__c(Name = 'MY_THIRD_PICKLIST', External_Key__c = 'PM-000003', Object_Name__c = 'OBJECT3', Field_Name__c = 'FIELD');
        insert account3;

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"Id","Value":"' + account1.ID + '"}, {"Name":"Name","Value":"MY_FIRST_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000002"}, {"Name":"Name","Value":"MY_SECOND_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT2"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_SINGLE, '4711', '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}'));

        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000003"}, {"Name":"Name","Value":"MY_THIRD_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT3"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        String object4AsJson = '{"uniqueId":4, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"Name","Value":"MY_FOURTH_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT4"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        unitsOfWork.add(createUnitOfWork(2l, DateTime.now(), UnitOfWorkType.ATOMIC_SINGLE, '4712', '{"entityList":[' + object3AsJson + ', ' + object4AsJson + ']}'));

        test.startTest();
        List<UnitOfWorkResponse> result = UotReceiver.execute(1, unitsOfWork, true).UnitOfWorkResponses;
        test.stopTest();

        System.assert(result.size() == 2);

        UnitOfWorkResponse result1 = result.get(0);
        System.assert(result1.unitOfWorkId == 1l);
        System.assert(result1.sfdcId != null);
        System.assert(result1.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result1.operationResult.size() == 2);
        System.assert(result1.operationResult.get(0).entityId == 1);
        System.assert(result1.operationResult.get(0).sfdcId == account1.ID);
        System.assert(result1.operationResult.get(0).success);
        System.assert(!result1.operationResult.get(0).created);
        System.assert(result1.operationResult.get(0).errors == null);
        System.assert(result1.operationResult.get(1).entityId == 2);
        System.assert(result1.operationResult.get(1).sfdcId != null);
        System.assert(result1.operationResult.get(1).success);
        System.assert(result1.operationResult.get(1).created);
        System.assert(result1.operationResult.get(1).errors == null);

        Picklist_Mapping__c changedAccount1 = [Select Name From Picklist_Mapping__c Where Id = :result1.operationResult.get(0).sfdcId];
        System.assertEquals('MY_FIRST_PICKLIST_CHANGED', changedAccount1.Name);

        Picklist_Mapping__c changedAccount2 = [Select Name From Picklist_Mapping__c Where Id = :result1.operationResult.get(1).sfdcId];
        System.assertEquals('MY_SECOND_PICKLIST_CHANGED', changedAccount2.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork1 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result1.sfdcId];
        System.assertEquals(1l, epAdapterUnitOfWork1.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_SINGLE', epAdapterUnitOfWork1.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork1.Status__c);

        UnitOfWorkResponse result2 = result.get(1);
        System.assert(result2.unitOfWorkId == 2l);
        System.assert(result2.sfdcId != null);
        System.assert(result2.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result2.operationResult.size() == 2);
        System.assert(result2.operationResult.get(0).entityId == 3);
        System.assert(result2.operationResult.get(0).sfdcId == account3.ID);
        System.assert(result2.operationResult.get(0).success);
        System.assert(!result2.operationResult.get(0).created);
        System.assert(result2.operationResult.get(0).errors == null);
        System.assert(result2.operationResult.get(1).entityId == 4);
        System.assert(result2.operationResult.get(0).sfdcId != null);
        System.assert(result2.operationResult.get(1).success);
        System.assert(result2.operationResult.get(1).created);
        System.assert(result2.operationResult.get(1).errors == null);

        Picklist_Mapping__c changedAccount3 = [Select Name From Picklist_Mapping__c Where Id = :result2.operationResult.get(0).sfdcId];
        System.assertEquals('MY_THIRD_PICKLIST_CHANGED', changedAccount3.Name);

        Picklist_Mapping__c changedAccount4 = [Select Name From Picklist_Mapping__c Where Id = :result2.operationResult.get(1).sfdcId];
        System.assertEquals('MY_FOURTH_PICKLIST_CHANGED', changedAccount4.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork2 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result2.sfdcId];
        System.assertEquals(2l, epAdapterUnitOfWork2.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_SINGLE', epAdapterUnitOfWork2.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork2.Status__c);
    }

    static testmethod void testExecuteAtomicMultipleUpsert()
    {
        Picklist_Mapping__c account1 = new Picklist_Mapping__c(Name = 'MY_FIRST_PICKLIST', Object_Name__c = 'OBJECT1', Field_Name__c = 'FIELD');
        insert account1;
        Picklist_Mapping__c account3 = new Picklist_Mapping__c(Name = 'MY_THIRD_PICKLIST', Object_Name__c = 'OBJECT3', Field_Name__c = 'FIELD');
        account3.External_Key__c = 'PM-000003';
        insert account3;

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"Id","Value":"' + account1.ID + '"}, {"Name":"Name","Value":"MY_FIRST_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000002"}, {"Name":"Name","Value":"MY_SECOND_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT2"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_MULTIPLE, '4711', '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}'));

        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000003"}, {"Name":"Name","Value":"MY_THIRD_PICKLIST_CHANGED"}], "externalIdField":"External_Key__c" }';
        String object4AsJson = '{"uniqueId":4, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"Name","Value":"MY_FOURTH_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT4"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        String object5AsJson = '{"uniqueId":5, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"Name","Value":"MY_FIFTH_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT5"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        unitsOfWork.add(createUnitOfWork(2l, DateTime.now(), UnitOfWorkType.ATOMIC_MULTIPLE, '4712', '{"entityList":[' + object3AsJson + ', ' + object4AsJson + ', ' + object5AsJson + ']}'));

        test.startTest();
        List<UnitOfWorkResponse> result = UotReceiver.execute(1, unitsOfWork, true).UnitOfWorkResponses;
        test.stopTest();

        System.assert(result.size() == 2);

        UnitOfWorkResponse result1 = result.get(0);
        System.assert(result1.unitOfWorkId == 1l);
        System.assert(result1.sfdcId != null);
        System.assert(result1.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result1.operationResult.size() == 2);
        System.assert(result1.operationResult.get(0).entityId == 1);
        System.assert(result1.operationResult.get(0).sfdcId == account1.ID);
        System.assert(result1.operationResult.get(0).success);
        System.assert(!result1.operationResult.get(0).created);
        System.assert(result1.operationResult.get(0).errors == null);
        System.assert(result1.operationResult.get(1).entityId == 2);
        System.assert(result1.operationResult.get(1).sfdcId != null);
        System.assert(result1.operationResult.get(1).success);
        System.assert(result1.operationResult.get(1).created);
        System.assert(result1.operationResult.get(1).errors == null);

        Picklist_Mapping__c changedAccount1 = [Select Name From Picklist_Mapping__c Where Id = :result1.operationResult.get(0).sfdcId];
        System.assertEquals('MY_FIRST_PICKLIST_CHANGED', changedAccount1.Name);

        Picklist_Mapping__c changedAccount2 = [Select Name From Picklist_Mapping__c Where Id = :result1.operationResult.get(1).sfdcId];
        System.assertEquals('MY_SECOND_PICKLIST_CHANGED', changedAccount2.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork1 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result1.sfdcId];
        System.assertEquals(1l, epAdapterUnitOfWork1.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_MULTIPLE', epAdapterUnitOfWork1.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork1.Status__c);

        UnitOfWorkResponse result2 = result.get(1);
        System.assert(result2.unitOfWorkId == 2l);
        System.assert(result2.sfdcId != null);
        System.assert(result2.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result2.operationResult.size() == 3);
        System.assert(result2.operationResult.get(0).entityId == 3);
        System.assert(result2.operationResult.get(0).sfdcId == account3.ID);
        System.assert(result2.operationResult.get(0).success);
        System.assert(!result2.operationResult.get(0).created);
        System.assert(result2.operationResult.get(0).errors == null);
        System.assert(result2.operationResult.get(1).entityId == 4);
        System.assert(result2.operationResult.get(1).sfdcId != null);
        System.assert(result2.operationResult.get(1).success);
        System.assert(result2.operationResult.get(1).created);
        System.assert(result2.operationResult.get(1).errors == null);
        System.assert(result2.operationResult.get(2).entityId == 5);
        System.assert(result2.operationResult.get(2).sfdcId != null);
        System.assert(result2.operationResult.get(2).success);
        System.assert(result2.operationResult.get(2).created);
        System.assert(result2.operationResult.get(2).errors == null);

        Picklist_Mapping__c changedAccount3 = [Select Name From Picklist_Mapping__c Where Id = :result2.operationResult.get(0).sfdcId];
        System.assertEquals('MY_THIRD_PICKLIST_CHANGED', changedAccount3.Name);

        Picklist_Mapping__c changedAccount4 = [Select Name From Picklist_Mapping__c Where Id = :result2.operationResult.get(1).sfdcId];
        System.assertEquals('MY_FOURTH_PICKLIST_CHANGED', changedAccount4.Name);

        Picklist_Mapping__c changedAccount5 = [Select Name From Picklist_Mapping__c Where Id = :result2.operationResult.get(2).sfdcId];
        System.assertEquals('MY_FIFTH_PICKLIST_CHANGED', changedAccount5.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork2 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result2.sfdcId];
        System.assertEquals(2l, epAdapterUnitOfWork2.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_MULTIPLE', epAdapterUnitOfWork2.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork2.Status__c);
    }

/*
    static testmethod void testExecuteAtomicMultipleUpsertWithFailure()
    {
        Picklist_Mapping__c account1 = new Picklist_Mapping__c(Name = 'MY_FIRST_PICKLIST', Object_Name__c = 'OBJECT1', Field_Name__c = 'FIELD');
        insert account1;
        Picklist_Mapping__c account3 = new Picklist_Mapping__c(Name = 'MY_THIRD_PICKLIST', Object_Name__c = 'OBJECT3', Field_Name__c = 'FIELD');
        account3.External_Key__c = 'PM-000003';
        insert account3;
        Picklist_Mapping__c account4 = new Picklist_Mapping__c(Name = 'MY_FOURTH_PICKLIST', Object_Name__c = 'OBJECT4', Field_Name__c = 'FIELD');
        insert account4;
        Picklist_Mapping__c account5 = new Picklist_Mapping__c(Name = 'MY_FIFTH_PICKLIST', Object_Name__c = 'OBJECT5', Field_Name__c = 'FIELD');
        insert account5;

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"Id","Value":"' + account1.ID + '"}, {"Name":"Name","Value":"MY_FIRST_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000002"}, {"Name":"Name","Value":"MY_SECOND_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT2"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_MULTIPLE, '4711', '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}'));

        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000003"}, {"Name":"Name","Value":"MY_THIRD_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT3"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        String object4AsJson = '{"uniqueId":4, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"Id","Value":"' + account4.ID + '"}, {"Name":"External_Key__c","Value":"PM-000004"}, {"Name":"Name","Value":"MY_FOURTH_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT4"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        String object5AsJson = '{"uniqueId":5, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"Id","Value":"' + account5.ID + '"}, {"Name":"External_Key__c","Value":"PM-000004"}, {"Name":"Name","Value":"MY_FIFTH_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT5"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        unitsOfWork.add(createUnitOfWork(2l, DateTime.now(), UnitOfWorkType.ATOMIC_MULTIPLE, '4712', '{"entityList":[' + object3AsJson + ', ' + object4AsJson + ', ' + object5AsJson + ']}'));

        test.startTest();
        List<UnitOfWorkResponse> result = UotReceiver.execute(1, unitsOfWork, true).UnitOfWorkResponses;
        test.stopTest();

        System.assert(result.size() == 2);

        UnitOfWorkResponse result1 = result.get(0);
        System.assert(result1.unitOfWorkId == 1l);
        System.assert(result1.sfdcId != null);
        System.assert(result1.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result1.operationResult.size() == 2);
        System.assert(result1.operationResult.get(0).entityId == 1);
        System.assert(result1.operationResult.get(0).sfdcId == account1.ID);
        System.assert(result1.operationResult.get(0).success);
        System.assert(!result1.operationResult.get(0).created);
        System.assert(result1.operationResult.get(0).errors == null);
        System.assert(result1.operationResult.get(1).entityId == 2);
        System.assert(result1.operationResult.get(1).sfdcId != null);
        System.assert(result1.operationResult.get(1).success);
        System.assert(result1.operationResult.get(1).created);
        System.assert(result1.operationResult.get(1).errors == null);

        Picklist_Mapping__c changedAccount1 = [Select Name From Picklist_Mapping__c Where Id = :result1.operationResult.get(0).sfdcId];
        System.assertEquals('MY_FIRST_PICKLIST_CHANGED', changedAccount1.Name);

        Picklist_Mapping__c changedAccount2 = [Select Name From Picklist_Mapping__c Where Id = :result1.operationResult.get(1).sfdcId];
        System.assertEquals('MY_SECOND_PICKLIST_CHANGED', changedAccount2.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork1 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result1.sfdcId];
        System.assertEquals(1l, epAdapterUnitOfWork1.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_MULTIPLE', epAdapterUnitOfWork1.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork1.Status__c);

        UnitOfWorkResponse result2 = result.get(1);
        System.assert(result2.unitOfWorkId == 2l);
        System.assert(result2.sfdcId != null);
        System.assert(result2.status == UnitOfWorkStatus.FAILED);
        System.assert(result2.operationResult.size() == 3);
        System.assert(result2.operationResult.get(0).entityId == 3);
        System.assert(result2.operationResult.get(0).sfdcId == account3.ID);
        System.assert(result2.operationResult.get(0).success);
        System.assert(!result2.operationResult.get(0).created);
        System.assert(result2.operationResult.get(0).errors == null);
        System.assert(result2.operationResult.get(1).entityId == 4);
        System.assert(result2.operationResult.get(1).sfdcId != null);
        System.assert(result2.operationResult.get(1).success);
        System.assert(!result2.operationResult.get(1).created);
        System.assert(result2.operationResult.get(1).errors == null);
        System.assert(result2.operationResult.get(2).entityId == 5);
        System.assert(result2.operationResult.get(2).sfdcId == null);
        System.assert(!result2.operationResult.get(2).success);
        System.assert(!result2.operationResult.get(2).created);
        System.assert(result2.operationResult.get(2).errors.size() == 1);
        System.assert(result2.operationResult.get(2).errors.get(0).statusCode != null);

        Picklist_Mapping__c changedAccount3 = [Select Name From Picklist_Mapping__c Where Id = :result2.operationResult.get(0).sfdcId];
        System.assertEquals('MY_THIRD_PICKLIST_CHANGED', changedAccount3.Name);

        Picklist_Mapping__c changedAccount4 = [Select Name From Picklist_Mapping__c Where Id = :account4.ID];
        System.assertEquals('MY_FOURTH_PICKLIST_CHANGED', changedAccount4.Name);

        Picklist_Mapping__c changedAccount5 = [Select Name From Picklist_Mapping__c Where Id = :account5.ID];
        System.assertEquals('MY_FIFTH_PICKLIST', changedAccount5.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork2 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result2.sfdcId];
        System.assertEquals(2l, epAdapterUnitOfWork2.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_MULTIPLE', epAdapterUnitOfWork2.Type__c);
        System.assertEquals('FAILED', epAdapterUnitOfWork2.Status__c);
    }
*/

    static testmethod void testExecuteCompoundSameType()
    {
        Picklist_Mapping__c account1 = new Picklist_Mapping__c(Name = 'MY_FIRST_PICKLIST', Object_Name__c = 'OBJECT1', Field_Name__c = 'FIELD');
        insert account1;
        Picklist_Mapping__c account3 = new Picklist_Mapping__c(Name = 'MY_THIRD_PICKLIST', Object_Name__c = 'OBJECT3', Field_Name__c = 'FIELD');
        account3.External_Key__c = 'PM-000003';
        insert account3;

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"Id","Value":"' + account1.ID + '"}, {"Name":"Name","Value":"MY_FIRST_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000002"}, {"Name":"Name","Value":"MY_SECOND_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT2"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.COMPOUND_SAME_TYPE, '4711', '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}'));

        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000003"}, {"Name":"Name","Value":"MY_THIRD_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT3"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        String object4AsJson = '{"uniqueId":4, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"Name","Value":"MY_FOURTH_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT4"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        String object5AsJson = '{"uniqueId":5, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"Name","Value":"MY_FIFTH_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT5"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        unitsOfWork.add(createUnitOfWork(2l, DateTime.now(), UnitOfWorkType.COMPOUND_SAME_TYPE, '4712', '{"entityList":[' + object3AsJson + ', ' + object4AsJson + ', ' + object5AsJson + ']}'));

        test.startTest();
        List<UnitOfWorkResponse> result = UotReceiver.execute(1, unitsOfWork, true).UnitOfWorkResponses;
        test.stopTest();

        System.assert(result.size() == 2);

        UnitOfWorkResponse result1 = result.get(0);
        System.assert(result1.unitOfWorkId == 1l);
        System.assert(result1.sfdcId != null);
        System.assert(result1.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result1.operationResult.size() == 2, 'Expected 2, but was ' + result1.operationResult.size());
        System.assert(result1.operationResult.get(0).entityId == 1);
        System.assert(result1.operationResult.get(0).sfdcId == account1.ID);
        System.assert(result1.operationResult.get(0).success);
        System.assert(!result1.operationResult.get(0).created);
        System.assert(result1.operationResult.get(0).errors == null);
        System.assert(result1.operationResult.get(1).entityId == 2);
        System.assert(result1.operationResult.get(1).sfdcId != null);
        System.assert(result1.operationResult.get(1).success);
        System.assert(result1.operationResult.get(1).created);
        System.assert(result1.operationResult.get(1).errors == null);

        Picklist_Mapping__c changedAccount1 = [Select Name From Picklist_Mapping__c Where Id = :result1.operationResult.get(0).sfdcId];
        System.assertEquals('MY_FIRST_PICKLIST_CHANGED', changedAccount1.Name);

        Picklist_Mapping__c changedAccount2 = [Select Name From Picklist_Mapping__c Where Id = :result1.operationResult.get(1).sfdcId];
        System.assertEquals('MY_SECOND_PICKLIST_CHANGED', changedAccount2.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork1 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result1.sfdcId];
        System.assertEquals(1l, epAdapterUnitOfWork1.UnitOfWorkId__c);
        System.assertEquals('COMPOUND_SAME_TYPE', epAdapterUnitOfWork1.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork1.Status__c);

        UnitOfWorkResponse result2 = result.get(1);
        System.assert(result2.unitOfWorkId == 2l);
        System.assert(result2.sfdcId != null);
        System.assert(result2.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result2.operationResult.size() == 3);
        System.assert(result2.operationResult.get(0).entityId == 3);
        System.assert(result2.operationResult.get(0).sfdcId == account3.ID);
        System.assert(result2.operationResult.get(0).success);
        System.assert(!result2.operationResult.get(0).created);
        System.assert(result2.operationResult.get(0).errors == null);
        System.assert(result2.operationResult.get(1).entityId == 4);
        System.assert(result2.operationResult.get(1).sfdcId != null);
        System.assert(result2.operationResult.get(1).success);
        System.assert(result2.operationResult.get(1).created);
        System.assert(result2.operationResult.get(1).errors == null);
        System.assert(result2.operationResult.get(2).entityId == 5);
        System.assert(result2.operationResult.get(2).sfdcId != null);
        System.assert(result2.operationResult.get(2).success);
        System.assert(result2.operationResult.get(2).created);
        System.assert(result2.operationResult.get(2).errors == null);

        Picklist_Mapping__c changedAccount3 = [Select Name From Picklist_Mapping__c Where Id = :result2.operationResult.get(0).sfdcId];
        System.assertEquals('MY_THIRD_PICKLIST_CHANGED', changedAccount3.Name);

        Picklist_Mapping__c changedAccount4 = [Select Name From Picklist_Mapping__c Where Id = :result2.operationResult.get(1).sfdcId];
        System.assertEquals('MY_FOURTH_PICKLIST_CHANGED', changedAccount4.Name);

        Picklist_Mapping__c changedAccount5 = [Select Name From Picklist_Mapping__c Where Id = :result2.operationResult.get(2).sfdcId];
        System.assertEquals('MY_FIFTH_PICKLIST_CHANGED', changedAccount5.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork2 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result2.sfdcId];
        System.assertEquals(2l, epAdapterUnitOfWork2.UnitOfWorkId__c);
        System.assertEquals('COMPOUND_SAME_TYPE', epAdapterUnitOfWork2.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork2.Status__c);
    }

/*
    static testmethod void testExecuteAtomicCompoundSameTypeWithFailure()
    {
        Picklist_Mapping__c account1 = new Picklist_Mapping__c(Name = 'MY_FIRST_PICKLIST', External_Key__c='PM-000001', Object_Name__c = 'OBJECT1', Field_Name__c = 'FIELD');
        insert account1;
        Picklist_Mapping__c account4 = new Picklist_Mapping__c(Name = 'MY_FOURTH_PICKLIST', External_Key__c='PM-000004', Object_Name__c = 'OBJECT4', Field_Name__c = 'FIELD');
        insert account4;
        Picklist_Mapping__c account5 = new Picklist_Mapping__c(Name = 'MY_FIFTH_PICKLIST', External_Key__c='PM-000005', Object_Name__c = 'OBJECT5', Field_Name__c = 'FIELD');
        insert account5;

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"Id","Value":"' + account1.ID + '"}, {"Name":"Name","Value":"MY_FIRST_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000002"}, {"Name":"Name","Value":"MY_SECOND_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT2"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.COMPOUND_SAME_TYPE, '4711', '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}'));

        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000003"}, {"Name":"Name","Value":"MY_THIRD_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT3"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        String object4AsJson = '{"uniqueId":4, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"Id","Value":"' + account4.ID + '"}, {"Name":"External_Key__c","Value":"PM-000004"}, {"Name":"Name","Value":"MY_FOURTH_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT4"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        String object5AsJson = '{"uniqueId":5, "sObjectType":"Picklist_Mapping__c", "operationType":"UPSERT", "fields": [{"Name":"Id","Value":"' + account5.ID + '"}, {"Name":"External_Key__c","Value":"PM-000004"}, {"Name":"Name","Value":"MY_FIFTH_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT5"}, {"Name":"Field_Name__c","Value":"FIELD"}], "externalIdField":"External_Key__c" }';
        unitsOfWork.add(createUnitOfWork(2l, DateTime.now(), UnitOfWorkType.COMPOUND_SAME_TYPE, '4712', '{"entityList":[' + object3AsJson + ', ' + object4AsJson + ', ' + object5AsJson + ']}'));

        test.startTest();
        List<UnitOfWorkResponse> result = UotReceiver.execute(1, unitsOfWork, true).UnitOfWorkResponses;
        test.stopTest();

        System.assert(result.size() == 2);

        UnitOfWorkResponse result1 = result.get(0);
        System.assert(result1.unitOfWorkId == 1l);
        System.assert(result1.sfdcId != null);
        System.assert(result1.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result1.operationResult.size() == 2);
        System.assert(result1.operationResult.get(0).entityId == 1);
        System.assert(result1.operationResult.get(0).sfdcId == account1.ID);
        System.assert(result1.operationResult.get(0).success);
        System.assert(!result1.operationResult.get(0).created);
        System.assert(result1.operationResult.get(0).errors == null);
        System.assert(result1.operationResult.get(1).entityId == 2);
        System.assert(result1.operationResult.get(1).sfdcId != null);
        System.assert(result1.operationResult.get(1).success);
        System.assert(result1.operationResult.get(1).created);
        System.assert(result1.operationResult.get(1).errors == null);

        Picklist_Mapping__c changedAccount1 = [Select Name From Picklist_Mapping__c Where Id = :result1.operationResult.get(0).sfdcId];
        System.assertEquals('MY_FIRST_PICKLIST_CHANGED', changedAccount1.Name);

        Picklist_Mapping__c changedAccount2 = [Select Name From Picklist_Mapping__c Where Id = :result1.operationResult.get(1).sfdcId];
        System.assertEquals('MY_SECOND_PICKLIST_CHANGED', changedAccount2.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork1 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result1.sfdcId];
        System.assertEquals(1l, epAdapterUnitOfWork1.UnitOfWorkId__c);
        System.assertEquals('COMPOUND_SAME_TYPE', epAdapterUnitOfWork1.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork1.Status__c);

        UnitOfWorkResponse result2 = result.get(1);
        System.assert(result2.unitOfWorkId == 2l);
        System.assert(result2.sfdcId != null);
        System.assert(result2.status == UnitOfWorkStatus.FAILED);
        System.assert(result2.operationResult.size() == 3);
        System.assert(result2.operationResult.get(0).entityId == 3);
        System.assert(result2.operationResult.get(0).sfdcId == null);
        System.assert(!result2.operationResult.get(0).success);
        System.assert(!result2.operationResult.get(0).created);
        System.assert(result2.operationResult.get(0).errors == null);
        System.assert(result2.operationResult.get(1).entityId == 4);
        System.assert(result2.operationResult.get(1).sfdcId == null);
        System.assert(!result2.operationResult.get(1).success);
        System.assert(!result2.operationResult.get(1).created);
        System.assert(result2.operationResult.get(1).errors == null);
        System.assert(result2.operationResult.get(2).entityId == 5);
        System.assert(result2.operationResult.get(2).sfdcId == null);
        System.assert(!result2.operationResult.get(2).success);
        System.assert(!result2.operationResult.get(2).created);
        System.assert(result2.operationResult.get(2).errors.size() == 1);
        System.assert(result2.operationResult.get(2).errors.get(0).statusCode != null);

        List<Picklist_Mapping__c> changedAccount3 = [Select Name From Picklist_Mapping__c Where External_Key__c = 'PM-000003'];
        System.assertEquals(0, changedAccount3.size());

        Picklist_Mapping__c changedAccount4 = [Select Name From Picklist_Mapping__c Where Id = :account4.ID];
        System.assertEquals('MY_FOURTH_PICKLIST', changedAccount4.Name);

        Picklist_Mapping__c changedAccount5 = [Select Name From Picklist_Mapping__c Where Id = :account5.ID];
        System.assertEquals('MY_FIFTH_PICKLIST', changedAccount5.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork2 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result2.sfdcId];
        System.assertEquals(2l, epAdapterUnitOfWork2.UnitOfWorkId__c);
        System.assertEquals('COMPOUND_SAME_TYPE', epAdapterUnitOfWork2.Type__c);
        System.assertEquals('FAILED', epAdapterUnitOfWork2.Status__c);
    }
*/

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