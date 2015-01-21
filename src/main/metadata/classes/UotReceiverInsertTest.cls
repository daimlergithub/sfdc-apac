@isTest
public class UotReceiverInsertTest
{
    public static testmethod void testExecuteAtomicSingleInsert()
    {
        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-900001"}, {"Name":"Name","Value":"MY_FIRST_PICKLIST"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-900002"}, {"Name":"Name","Value":"MY_SECOND_PICKLIST"}, {"Name":"Object_Name__c","Value":"OBJECT2"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_SINGLE, '4711', '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}'));

        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-900003"}, {"Name":"Name","Value":"MY_THIRD_PICKLIST"}, {"Name":"Object_Name__c","Value":"OBJECT3"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
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
        System.assert(result1.operationResult.get(0).entityId == 1);
        System.assert(result1.operationResult.get(0).sfdcId != null);
        System.assert(result1.operationResult.get(0).success);
        System.assert(result1.operationResult.get(0).created);
        System.assert(result1.operationResult.get(0).errors == null);
        System.assert(result1.operationResult.get(1).entityId == 2);
        System.assert(result1.operationResult.get(1).sfdcId != null);
        System.assert(result1.operationResult.get(1).success);
        System.assert(result1.operationResult.get(1).created);
        System.assert(result1.operationResult.get(1).errors == null);

        Picklist_Mapping__c account1 = [select Name from Picklist_Mapping__c where Id = :result1.operationResult.get(0).sfdcId];
        System.assertEquals('MY_FIRST_PICKLIST', account1.Name);

        Picklist_Mapping__c account2 = [select Name from Picklist_Mapping__c where Id = :result1.operationResult.get(1).sfdcId];
        System.assertEquals('MY_SECOND_PICKLIST', account2.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork1 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result1.sfdcId];
        System.assertEquals(1l, epAdapterUnitOfWork1.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_SINGLE', epAdapterUnitOfWork1.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork1.Status__c);

        UnitOfWorkResponse result2 = result.get(1);
        System.assert(result2.unitOfWorkId == 2l);
        System.assert(result2.sfdcId != null);
        System.assert(result2.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result2.operationResult.size() == 1);
        System.assert(result2.operationResult.get(0).entityId == 3);
        System.assert(result2.operationResult.get(0).sfdcId != null);
        System.assert(result2.operationResult.get(0).success);
        System.assert(result2.operationResult.get(0).created);
        System.assert(result2.operationResult.get(0).errors == null);

        Picklist_Mapping__c account3 = [Select Name From Picklist_Mapping__c Where Id = :result2.operationResult.get(0).sfdcId];
        System.assertEquals('MY_THIRD_PICKLIST', account3.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork2 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result2.sfdcId];
        System.assertEquals(2l, epAdapterUnitOfWork2.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_SINGLE', epAdapterUnitOfWork2.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork2.Status__c);
    }

    public static testmethod void testExecuteAtomicSingleInsertWithFailure()
    {
        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-900001"}, {"Name":"Name","Value":"MY_FIRST_PICKLIST"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-900002"}, {"Name":"Name","Value":"MY_SECOND_PICKLIST"}, {"Name":"Object_Name__c","Value":"OBJECT2"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_SINGLE, '4711', '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}'));

        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-900003"}, {"Name":"Name","Value":"MY_THIRD_PICKLIST"}, {"Name":"Object_Name__c","Value":"A MUCH TOO LONG PHONE NUMBER 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"}]}';
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
        System.assert(result1.operationResult.get(0).entityId == 1);
        System.assert(result1.operationResult.get(0).sfdcId != null);
        System.assert(result1.operationResult.get(0).success);
        System.assert(result1.operationResult.get(0).created);
        System.assert(result1.operationResult.get(0).errors == null);
        System.assert(result1.operationResult.get(1).entityId == 2);
        System.assert(result1.operationResult.get(1).sfdcId != null);
        System.assert(result1.operationResult.get(1).success);
        System.assert(result1.operationResult.get(1).created);
        System.assert(result1.operationResult.get(1).errors == null);

        Picklist_Mapping__c account1 = [select Name from Picklist_Mapping__c where Id = :result1.operationResult.get(0).sfdcId];
        System.assertEquals('MY_FIRST_PICKLIST', account1.Name);

        Picklist_Mapping__c account2 = [select Name from Picklist_Mapping__c where Id = :result1.operationResult.get(1).sfdcId];
        System.assertEquals('MY_SECOND_PICKLIST', account2.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork1 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result1.sfdcId];
        System.assertEquals(1l, epAdapterUnitOfWork1.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_SINGLE', epAdapterUnitOfWork1.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork1.Status__c);

        UnitOfWorkResponse result2 = result.get(1);
        System.assert(result2.unitOfWorkId == 2l);
        System.assert(result2.sfdcId != null);
        System.assert(result2.status == UnitOfWorkStatus.FAILED);
        System.assert(result2.operationResult.size() == 1);
        System.assert(result2.operationResult.get(0).entityId == 3);
        System.assert(result2.operationResult.get(0).sfdcId == null);
        System.assert(!result2.operationResult.get(0).success);
        System.assert(!result2.operationResult.get(0).created);
        System.assert(result2.operationResult.get(0).errors != null);

        List<Picklist_Mapping__c> notInsertedAccount3 = [Select Name From Picklist_Mapping__c Where Name = 'MY_THIRD_PICKLIST'];
        System.assert(notInsertedAccount3.size() == 0);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork2 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result2.sfdcId];
        System.assertEquals(2l, epAdapterUnitOfWork2.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_SINGLE', epAdapterUnitOfWork2.Type__c);
        System.assertEquals('FAILED', epAdapterUnitOfWork2.Status__c);
    }

    public static testmethod void testExecuteAtomicMultipleInsert()
    {
        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-900001"}, {"Name":"Name","Value":"MY_FIRST_PICKLIST"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-900002"}, {"Name":"Name","Value":"MY_SECOND_PICKLIST"}, {"Name":"Object_Name__c","Value":"OBJECT2"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_MULTIPLE, '4711', '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}'));

        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-900003"}, {"Name":"Name","Value":"MY_THIRD_PICKLIST"}, {"Name":"Object_Name__c","Value":"OBJECT3"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        unitsOfWork.add(createUnitOfWork(2l, DateTime.now(), UnitOfWorkType.ATOMIC_MULTIPLE, '4712', '{"entityList":[' + object3AsJson + ']}'));

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
        System.assert(result1.operationResult.get(0).sfdcId != null);
        System.assert(result1.operationResult.get(0).success);
        System.assert(result1.operationResult.get(0).created);
        System.assert(result1.operationResult.get(0).errors == null);
        System.assert(result1.operationResult.get(1).entityId == 2);
        System.assert(result1.operationResult.get(1).sfdcId != null);
        System.assert(result1.operationResult.get(1).success);
        System.assert(result1.operationResult.get(1).created);
        System.assert(result1.operationResult.get(1).errors == null);

        Picklist_Mapping__c account1 = [select Name from Picklist_Mapping__c where Id = :result1.operationResult.get(0).sfdcId];
        System.assertEquals('MY_FIRST_PICKLIST', account1.Name);

        Picklist_Mapping__c account2 = [select Name from Picklist_Mapping__c where Id = :result1.operationResult.get(1).sfdcId];
        System.assertEquals('MY_SECOND_PICKLIST', account2.Name);

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
        System.assert(result2.operationResult.get(0).sfdcId != null);
        System.assert(result2.operationResult.get(0).success);
        System.assert(result2.operationResult.get(0).created);
        System.assert(result2.operationResult.get(0).errors == null);

        Picklist_Mapping__c account3 = [Select Name From Picklist_Mapping__c Where Id = :result2.operationResult.get(0).sfdcId];
        System.assertEquals('MY_THIRD_PICKLIST', account3.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork2 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result2.sfdcId];
        System.assertEquals(2l, epAdapterUnitOfWork2.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_MULTIPLE', epAdapterUnitOfWork2.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork2.Status__c);
    }

    public static testmethod void testExecuteCompoundSameTypeInsert()
    {
        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-900001"}, {"Name":"Name","Value":"MY_FIRST_PICKLIST"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-900002"}, {"Name":"Name","Value":"MY_SECOND_PICKLIST"}, {"Name":"Object_Name__c","Value":"OBJECT2"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.COMPOUND_SAME_TYPE, '4711', '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}'));

        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-900003"}, {"Name":"Name","Value":"MY_THIRD_PICKLIST"}, {"Name":"Object_Name__c","Value":"OBJECT3"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String object4AsJson = '{"uniqueId":4, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-900004"}, {"Name":"Name","Value":"MY_FOURTH_PICKLIST"}, {"Name":"Object_Name__c","Value":"00498999364444"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        unitsOfWork.add(createUnitOfWork(2l, DateTime.now(), UnitOfWorkType.COMPOUND_SAME_TYPE, '4712', '{"entityList":[' + object3AsJson + ', ' + object4AsJson + ']}'));

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
        System.assert(result1.operationResult.get(0).sfdcId != null);
        System.assert(result1.operationResult.get(0).success);
        System.assert(result1.operationResult.get(0).created);
        System.assert(result1.operationResult.get(0).errors == null);
        System.assert(result1.operationResult.get(1).entityId == 2);
        System.assert(result1.operationResult.get(1).sfdcId != null);
        System.assert(result1.operationResult.get(1).success);
        System.assert(result1.operationResult.get(1).created);
        System.assert(result1.operationResult.get(1).errors == null);

        Picklist_Mapping__c account1 = [select Name from Picklist_Mapping__c where Id = :result1.operationResult.get(0).sfdcId];
        System.assertEquals('MY_FIRST_PICKLIST', account1.Name);

        Picklist_Mapping__c account2 = [select Name from Picklist_Mapping__c where Id = :result1.operationResult.get(1).sfdcId];
        System.assertEquals('MY_SECOND_PICKLIST', account2.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork1 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result1.sfdcId];
        System.assertEquals(1l, epAdapterUnitOfWork1.UnitOfWorkId__c);
        System.assertEquals('COMPOUND_SAME_TYPE', epAdapterUnitOfWork1.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork1.Status__c);

        UnitOfWorkResponse result2 = result.get(1);
        System.assert(result2.unitOfWorkId == 2l);
        System.assert(result2.sfdcId != null);
        System.assert(result2.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result2.operationResult.size() == 2);
        System.assert(result2.operationResult.get(0).entityId == 3);
        System.assert(result2.operationResult.get(0).sfdcId != null);
        System.assert(result2.operationResult.get(0).success);
        System.assert(result2.operationResult.get(0).created);
        System.assert(result2.operationResult.get(0).errors == null);
        System.assert(result2.operationResult.get(1).entityId == 4);
        System.assert(result2.operationResult.get(1).sfdcId != null);
        System.assert(result2.operationResult.get(1).success);
        System.assert(result2.operationResult.get(1).created);
        System.assert(result2.operationResult.get(1).errors == null);

        Picklist_Mapping__c account3 = [Select Name From Picklist_Mapping__c Where Id = :result2.operationResult.get(0).sfdcId];
        System.assertEquals('MY_THIRD_PICKLIST', account3.Name);

        Picklist_Mapping__c account4 = [Select Name From Picklist_Mapping__c Where Id = :result2.operationResult.get(1).sfdcId];
        System.assertEquals('MY_FOURTH_PICKLIST', account4.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork2 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result2.sfdcId];
        System.assertEquals(2l, epAdapterUnitOfWork2.UnitOfWorkId__c);
        System.assertEquals('COMPOUND_SAME_TYPE', epAdapterUnitOfWork2.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork2.Status__c);
    }

    public static testmethod void testExecuteCompoundSameTypeInsertWithFailure()
    {
        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-900001"}, {"Name":"Name","Value":"MY_FIRST_PICKLIST"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-900002"}, {"Name":"Name","Value":"MY_SECOND_PICKLIST"}, {"Name":"Object_Name__c","Value":"OBJECT2"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.COMPOUND_SAME_TYPE, '4711', '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}'));

        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-900003"}, {"Name":"Name","Value":"MY_THIRD_PICKLIST"}, {"Name":"Object_Name__c","Value":"A MUCH TOO LONG PHONE NUMBER 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String object4AsJson = '{"uniqueId":4, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-900004"}, {"Name":"Name","Value":"MY_FOURTH_PICKLIST"}, {"Name":"Object_Name__c","Value":"00498999364444"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        unitsOfWork.add(createUnitOfWork(2l, DateTime.now(), UnitOfWorkType.COMPOUND_SAME_TYPE, '4712', '{"entityList":[' + object3AsJson + ', ' + object4AsJson + ']}'));

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
        System.assert(result1.operationResult.get(0).sfdcId != null);
        System.assert(result1.operationResult.get(0).success);
        System.assert(result1.operationResult.get(0).created);
        System.assert(result1.operationResult.get(0).errors == null);
        System.assert(result1.operationResult.get(1).entityId == 2);
        System.assert(result1.operationResult.get(1).sfdcId != null);
        System.assert(result1.operationResult.get(1).success);
        System.assert(result1.operationResult.get(1).created);
        System.assert(result1.operationResult.get(1).errors == null);

        Picklist_Mapping__c account1 = [select Name from Picklist_Mapping__c where Id = :result1.operationResult.get(0).sfdcId];
        System.assertEquals('MY_FIRST_PICKLIST', account1.Name);

        Picklist_Mapping__c account2 = [select Name from Picklist_Mapping__c where Id = :result1.operationResult.get(1).sfdcId];
        System.assertEquals('MY_SECOND_PICKLIST', account2.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork1 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result1.sfdcId];
        System.assertEquals(1l, epAdapterUnitOfWork1.UnitOfWorkId__c);
        System.assertEquals('COMPOUND_SAME_TYPE', epAdapterUnitOfWork1.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork1.Status__c);

        UnitOfWorkResponse result2 = result.get(1);
        System.assert(result2.unitOfWorkId == 2l);
        System.assert(result2.sfdcId != null);
        System.debug('result2.status : ' + result2.status);
        System.debug('result2.get(0).errors : ' + result2.operationResult.get(0).errors);
        System.debug('result2.get(1).errors : ' + result2.operationResult.get(1).errors);
        System.assert(result2.status == UnitOfWorkStatus.FAILED);
        System.assert(result2.operationResult.size() == 2);
        System.assert(result2.operationResult.get(0).entityId == 3);
        System.assert(result2.operationResult.get(0).sfdcId == null);
        System.assert(!result2.operationResult.get(0).success);
        System.assert(!result2.operationResult.get(0).created);
        System.assert(result2.operationResult.get(0).errors != null);
        System.assert(result2.operationResult.get(1).entityId == 4);
        System.assert(result2.operationResult.get(1).sfdcId == null);
        System.assert(!result2.operationResult.get(1).success);
        System.assert(!result2.operationResult.get(1).created);
        System.assert(result2.operationResult.get(1).errors == null);

        List<Picklist_Mapping__c> notInsertedAccount3 = [Select Name From Picklist_Mapping__c Where Name = 'MY_THIRD_PICKLIST'];
        System.assert(notInsertedAccount3.size() == 0);

        List<Picklist_Mapping__c> notInsertedAccount4 = [Select Name From Picklist_Mapping__c Where Name = 'My Fourth Account'];
        System.assert(notInsertedAccount4.size() == 0);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork2 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result2.sfdcId];
        System.assertEquals(2l, epAdapterUnitOfWork2.UnitOfWorkId__c);
        System.assertEquals('COMPOUND_SAME_TYPE', epAdapterUnitOfWork2.Type__c);
        System.assertEquals('FAILED', epAdapterUnitOfWork2.Status__c);
    }

    public static testmethod void testExecuteCompoundSameTypeInsertMoreThan200Records()
    {
        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();
        Integer numRecords = 402;
        String objectsAsString = '';

        for (Integer i = 0; i < numRecords; i++) {
          if (objectsAsString.length() > 0) {
            objectsAsString += ', ';
          }
          objectsAsString += '{"uniqueId":' + i + ', "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-90' + fillLeft(i, 4) + '"}, {"Name":"Name","Value":"MY_PICKLIST_' + fillLeft(i, 4) + '"}, {"Name":"Object_Name__c","Value":"00498999360' + fillLeft(i, 4) + '"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        }

        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.COMPOUND_SAME_TYPE, '4711', '{"entityList":[' + objectsAsString + ']}'));

        test.startTest();
        List<UnitOfWorkResponse> result = UotReceiver.execute(1, unitsOfWork, true).UnitOfWorkResponses;
        test.stopTest();

        System.assert(result.size() == 1);

        UnitOfWorkResponse result1 = result.get(0);
        System.assert(result1.unitOfWorkId == 1l);
        System.assert(result1.sfdcId != null);
        System.debug('result1.status : ' + result1.status);
        System.debug('result1.get(0).errors : ' + result1.operationResult.get(0).errors);
        System.debug('result1.get(1).errors : ' + result1.operationResult.get(1).errors);
        System.assert(result1.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result1.operationResult.size() == numRecords);

        List<String> accountIds = new List<String>();
        for (Integer i = 0; i < numRecords; i++) {
            System.assert(result1.operationResult.get(i).entityId == i);
            System.assert(result1.operationResult.get(i).sfdcId != null);
            System.assert(result1.operationResult.get(i).success);
            System.assert(result1.operationResult.get(i).created);
            System.assert(result1.operationResult.get(i).errors == null);
            accountIds.add(result1.operationResult.get(i).sfdcId);
        }

        List<Picklist_Mapping__c> accounts = [select Name from Picklist_Mapping__c where Name like 'MY_PICKLIST_%' order by Name];
        System.assertEquals(numRecords, accounts.size());

        for (Integer i = 0; i < numRecords; i++) {
            System.assertEquals('MY_PICKLIST_' + fillLeft(i, 4), accounts.get(i).Name);
        }

        EpAdapterUnitOfWork__c epAdapterUnitOfWork1 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result1.sfdcId];
        System.assertEquals(1l, epAdapterUnitOfWork1.UnitOfWorkId__c);
        System.assertEquals('COMPOUND_SAME_TYPE', epAdapterUnitOfWork1.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork1.Status__c);
    }

    public static testmethod void testExecuteCompoundSameTypeInsertMoreThan200RecordsFailure()
    {
        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();
        Integer numRecords = 402;
        Integer recordWithError = 272;
        String objectsAsString = '';

        for (Integer i = 0; i < numRecords; i++) {
        	if (objectsAsString.length() > 0) {
        		objectsAsString += ', ';
        	}

        	if (i == recordWithError) {
              objectsAsString += '{"uniqueId":' + i + ', "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"External_Key1_0000' + fillLeft(i, 4) + '"}, {"Name":"Name","Value":"MY_PICKLIST_' + fillLeft(i, 4) + '"}, {"Name":"Object_Name__c","Value":"A MUCH TOO LONG PHONE NUMBER 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';

        	}
        	else {
        	    objectsAsString += '{"uniqueId":' + i + ', "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"External_Key1_0000' + fillLeft(i, 4) + '"}, {"Name":"Name","Value":"MY_PICKLIST_' + fillLeft(i, 4) + '"}, {"Name":"Object_Name__c","Value":"00498999360' + fillLeft(i, 4) + '"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        	}
        }

        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.COMPOUND_SAME_TYPE, '4711', '{"entityList":[' + objectsAsString + ']}'));

        test.startTest();
        List<UnitOfWorkResponse> result = UotReceiver.execute(1, unitsOfWork, true).UnitOfWorkResponses;
        test.stopTest();

        System.assert(result.size() == 1);

        UnitOfWorkResponse result1 = result.get(0);
        System.assert(result1.unitOfWorkId == 1l);
        System.assert(result1.sfdcId != null);
        System.assert(result1.status == UnitOfWorkStatus.FAILED);
        System.assert(result1.operationResult.size() == numRecords);

        List<String> accountIds = new List<String>();
        for (Integer i = 0; i < numRecords; i++) {
		        System.assert(result1.operationResult.get(i).entityId == i);
		        System.assert(result1.operationResult.get(i).sfdcId == null);
		        System.assert(!result1.operationResult.get(i).success);
		        System.assert(!result1.operationResult.get(i).created);
        }

        List<Picklist_Mapping__c> accounts = [select Name from Picklist_Mapping__c where Name like 'My Account %' order by Name];
        System.assertEquals(0, accounts.size());

        EpAdapterUnitOfWork__c epAdapterUnitOfWork1 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result1.sfdcId];
        System.assertEquals(1l, epAdapterUnitOfWork1.UnitOfWorkId__c);
        System.assertEquals('COMPOUND_SAME_TYPE', epAdapterUnitOfWork1.Type__c);
        System.assertEquals('FAILED', epAdapterUnitOfWork1.Status__c);
    }

    private static String fillLeft(Integer aNumberToFill, Integer aLength)
    {
    	String result = '' + aNumberToFill;

    	while (result.length() < aLength) {
    		result = '0' + result;
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