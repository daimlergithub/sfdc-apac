@isTest
public class UotReceiverUpdateTest
{
    static testmethod void testExecuteAtomicSingleUpdate()
    {
        Picklist_Mapping__c picklist1 = new Picklist_Mapping__c(Name = 'MY_FIRST_PICKLIST', Object_Name__c = 'OBJECT1', Field_Name__c = 'FIELD');
        insert picklist1;
        Picklist_Mapping__c picklist2 = new Picklist_Mapping__c(Name = 'MY_SECOND_PICKLIST', Object_Name__c = 'OBJECT2', Field_Name__c = 'FIELD');
        insert picklist2;
        Picklist_Mapping__c picklist3 = new Picklist_Mapping__c(Name = 'MY_THIRD_PICKLIST', Object_Name__c = 'OBJECT3', Field_Name__c = 'FIELD');
        insert picklist3;

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"' + picklist1.ID + '"}, {"Name":"Name","Value":"MY_FIRST_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"' + picklist2.ID + '"}, {"Name":"Name","Value":"MY_SECOND_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT2"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_SINGLE, '4711', '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}'));

        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"' + picklist3.ID + '"}, {"Name":"Name","Value":"MY_THIRD_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT3"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
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
        System.assert(!result1.operationResult.get(0).created);
        System.assert(result1.operationResult.get(0).errors == null);
        System.assert(result1.operationResult.get(1).entityId == 2);
        System.assert(result1.operationResult.get(1).sfdcId != null);
        System.assert(result1.operationResult.get(1).success);
        System.assert(!result1.operationResult.get(1).created);
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
        System.assert(result2.operationResult.size() == 1);
        System.assert(result2.operationResult.get(0).entityId == 3);
        System.assert(result2.operationResult.get(0).sfdcId != null);
        System.assert(result2.operationResult.get(0).success);
        System.assert(!result2.operationResult.get(0).created);
        System.assert(result2.operationResult.get(0).errors == null);

        Picklist_Mapping__c changedAccount3 = [Select Name From Picklist_Mapping__c Where Id = :result2.operationResult.get(0).sfdcId];
        System.assertEquals('MY_THIRD_PICKLIST_CHANGED', changedAccount3.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork2 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result2.sfdcId];
        System.assertEquals(2l, epAdapterUnitOfWork2.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_SINGLE', epAdapterUnitOfWork2.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork2.Status__c);
    }

    static testmethod void testExecuteAtomicSingleUpdateWithFailure()
    {
        Picklist_Mapping__c picklist1 = new Picklist_Mapping__c(Name = 'MY_FIRST_PICKLIST', Object_Name__c = 'OBJECT1', Field_Name__c = 'FIELD');
        insert picklist1;
        Picklist_Mapping__c picklist3 = new Picklist_Mapping__c(Name = 'MY_THIRD_PICKLIST', Object_Name__c = 'OBJECT2', Field_Name__c = 'FIELD');
        insert picklist3;

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"' + picklist1.ID + '"}, {"Name":"Name","Value":"MY_FIRST_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"UNKNOWN"}, {"Name":"Name","Value":"MY_SECOND_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT2"}]}';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_SINGLE, '4711', '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}'));

        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"' + picklist3.ID + '"}, {"Name":"Name","Value":"MY_THIRD_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT3"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        unitsOfWork.add(createUnitOfWork(2l, DateTime.now(), UnitOfWorkType.ATOMIC_SINGLE, '4712', '{"entityList":[' + object3AsJson + ']}'));

        test.startTest();
        List<UnitOfWorkResponse> result = UotReceiver.execute(1, unitsOfWork, true).UnitOfWorkResponses;
        test.stopTest();

        System.assert(result.size() == 2);

        UnitOfWorkResponse result1 = result.get(0);
        System.assert(result1.unitOfWorkId == 1l);
        System.assert(result1.sfdcId != null);
        System.assert(result1.status == UnitOfWorkStatus.FAILED);
        System.assert(result1.operationResult.size() == 2);
        System.assert(result1.operationResult.get(0).entityId == 1);
        System.assert(result1.operationResult.get(0).sfdcId != null);
        System.assert(result1.operationResult.get(0).success);
        System.assert(!result1.operationResult.get(0).created);
        System.assert(result1.operationResult.get(0).errors == null);
        System.assert(result1.operationResult.get(1).entityId == 2);
        System.assert(result1.operationResult.get(1).sfdcId == null);
        System.assert(!result1.operationResult.get(1).success);
        System.assert(!result1.operationResult.get(1).created);
        System.assert(result1.operationResult.get(1).errors.size() == 1);
        System.assert(result1.operationResult.get(1).errors.get(0).statusCode != null);

        Picklist_Mapping__c changedAccount1 = [Select Name From Picklist_Mapping__c Where Id = :result1.operationResult.get(0).sfdcId];
        System.assertEquals('MY_FIRST_PICKLIST_CHANGED', changedAccount1.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork1 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result1.sfdcId];
        System.assertEquals(1l, epAdapterUnitOfWork1.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_SINGLE', epAdapterUnitOfWork1.Type__c);
        System.assertEquals('FAILED', epAdapterUnitOfWork1.Status__c);

        UnitOfWorkResponse result2 = result.get(1);
        System.assert(result2.unitOfWorkId == 2l);
        System.assert(result2.sfdcId != null);
        System.assert(result2.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result2.operationResult.size() == 1);
        System.assert(result2.operationResult.get(0).entityId == 3);
        System.assert(result2.operationResult.get(0).sfdcId != null);
        System.assert(result2.operationResult.get(0).success);
        System.assert(!result2.operationResult.get(0).created);
        System.assert(result2.operationResult.get(0).errors == null);

        Picklist_Mapping__c changedAccount3 = [Select Name From Picklist_Mapping__c Where Id = :result2.operationResult.get(0).sfdcId];
        System.assertEquals('MY_THIRD_PICKLIST_CHANGED', changedAccount3.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork2 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result2.sfdcId];
        System.assertEquals(2l, epAdapterUnitOfWork2.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_SINGLE', epAdapterUnitOfWork2.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork2.Status__c);
    }

    static testmethod void testExecuteAtomicMultipleUpdate()
    {
        Picklist_Mapping__c picklist1 = new Picklist_Mapping__c(Name = 'MY_FIRST_PICKLIST', Object_Name__c = 'OBJECT1', Field_Name__c = 'FIELD1');
        insert picklist1;
        Picklist_Mapping__c picklist2 = new Picklist_Mapping__c(Name = 'MY_SECOND_PICKLIST', Object_Name__c = 'OBJECT2', Field_Name__c = 'FIELD2');
        insert picklist2;
        Picklist_Mapping__c picklist3 = new Picklist_Mapping__c(Name = 'MY_THIRD_PICKLIST', Object_Name__c = 'OBJECT3', Field_Name__c = 'FIELD3');
        insert picklist3;

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"' + picklist1.ID + '"}, {"Name":"Name","Value":"MY_FIRST_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD1"}]}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"' + picklist2.ID + '"}, {"Name":"Name","Value":"MY_SECOND_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT2"}, {"Name":"Field_Name__c","Value":"FIELD2"}]}';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_MULTIPLE, '4711', '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}'));

        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"' + picklist3.ID + '"}, {"Name":"Name","Value":"MY_THIRD_PICKLIST_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT3"}, {"Name":"Field_Name__c","Value":"FIELD3"}]}';
        unitsOfWork.add(createUnitOfWork(2l, DateTime.now(), UnitOfWorkType.ATOMIC_MULTIPLE, '4712', '{"entityList":[' + object3AsJson + ']}'));

        List<UnitOfWorkResponse> result = UotReceiver.execute(1, unitsOfWork, true).UnitOfWorkResponses;

        System.assert(result.size() == 2);

        UnitOfWorkResponse result1 = result.get(0);
        System.assert(result1.unitOfWorkId == 1l);
        System.assert(result1.sfdcId != null);
        System.assert(result1.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result1.operationResult.size() == 2);
        System.assert(result1.operationResult.get(0).entityId == 1);
        System.assert(result1.operationResult.get(0).sfdcId != null);
        System.assert(result1.operationResult.get(0).success);
        System.assert(!result1.operationResult.get(0).created);
        System.assert(result1.operationResult.get(0).errors == null);
        System.assert(result1.operationResult.get(1).entityId == 2);
        System.assert(result1.operationResult.get(1).sfdcId != null);
        System.assert(result1.operationResult.get(1).success);
        System.assert(!result1.operationResult.get(1).created);
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
        System.assert(result2.operationResult.size() == 1);
        System.assert(result2.operationResult.get(0).entityId == 3);
        System.assert(result2.operationResult.get(0).sfdcId != null);
        System.assert(result2.operationResult.get(0).success);
        System.assert(!result2.operationResult.get(0).created);
        System.assert(result2.operationResult.get(0).errors == null);

        Picklist_Mapping__c changedAccount3 = [Select Name From Picklist_Mapping__c Where Id = :result2.operationResult.get(0).sfdcId];
        System.assertEquals('MY_THIRD_PICKLIST_CHANGED', changedAccount3.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork2 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result2.sfdcId];
        System.assertEquals(2l, epAdapterUnitOfWork2.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_MULTIPLE', epAdapterUnitOfWork2.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork2.Status__c);
    }

    public static testmethod void testExecuteCompoundSameTypeUpdateMoreThan200Records()
    {
        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();
        Integer numRecords = 402;

        List<Picklist_Mapping__c> picklists = new List<Picklist_Mapping__c>();
        for (Integer i = 0; i < numRecords; i++) {
        	 picklists.add(new Picklist_Mapping__c(Name = 'MY_PICKLIST_' + fillLeft(i, 4), Object_Name__c = 'OBJECT0' + fillLeft(i, 4), Field_Name__c = 'FIELD'));
        }
        insert picklists;

        String objectsAsString = '';

        for (Integer i = 0; i < numRecords; i++) {
          if (objectsAsString.length() > 0) {
            objectsAsString += ', ';
          }
          objectsAsString += '{"uniqueId":' + i + ', "sObjectType":"Picklist_Mapping__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"' + picklists.get(i).Id + '"}, {"Name":"ExternalSystem1Id__c","Value":"ExternalSystem1_0000' + fillLeft(i, 4) + '"}, {"Name":"Name","Value":"MY_PICKLIST_' + fillLeft(i, 4) + '_CHANGED"}, {"Name":"Object_Name__c","Value":"OBJECT0' + fillLeft(i, 4) + '"}]}';
        }

        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.COMPOUND_SAME_TYPE, '4711', '{"entityList":[' + objectsAsString + ']}'));

        test.startTest();
        List<UnitOfWorkResponse> result = UotReceiver.execute(1, unitsOfWork, true).UnitOfWorkResponses;
        test.stopTest();

        System.assert(result.size() == 1);

        UnitOfWorkResponse result1 = result.get(0);
        System.assert(result1.unitOfWorkId == 1l);
        System.assert(result1.sfdcId != null);
        System.assert(result1.status == UnitOfWorkStatus.PROCESSED);
        System.assert(result1.operationResult.size() == numRecords);

        for (Integer i = 0; i < numRecords; i++) {
            System.assert(result1.operationResult.get(i).entityId == i);
            System.assert(result1.operationResult.get(i).sfdcId != null);
            System.assert(result1.operationResult.get(i).success);
            System.assert(!result1.operationResult.get(i).created);
            System.assert(result1.operationResult.get(i).errors == null);
        }

        picklists = [select Name from Picklist_Mapping__c where Name like 'MY_PICKLIST_%' order by Name];
        System.assertEquals(numRecords, picklists.size());

        for (Integer i = 0; i < numRecords; i++) {
            System.assertEquals('MY_PICKLIST_' + fillLeft(i, 4) + '_CHANGED', picklists.get(i).Name);
        }

        EpAdapterUnitOfWork__c epAdapterUnitOfWork1 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result1.sfdcId];
        System.assertEquals(1l, epAdapterUnitOfWork1.UnitOfWorkId__c);
        System.assertEquals('COMPOUND_SAME_TYPE', epAdapterUnitOfWork1.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork1.Status__c);
    }

    public static testmethod void testExecuteCompoundSameTypeUpdateMoreThan200RecordsFailure()
    {
        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();
        Integer numRecords = 402;
        Integer recordWithError = 272;

        List<Picklist_Mapping__c> picklists = new List<Picklist_Mapping__c>();
        for (Integer i = 0; i < numRecords; i++) {
            picklists.add(new Picklist_Mapping__c(Name = 'MY_PICKLIST_' + fillLeft(i, 4), Object_Name__c = 'OBJECT0' + fillLeft(i, 4), Field_Name__c = 'FIELD'));
        }
        insert picklists;

        String objectsAsString = '';

        for (Integer i = 0; i < numRecords; i++) {
          if (objectsAsString.length() > 0) {
            objectsAsString += ', ';
          }

          if (i == recordWithError) {
              objectsAsString += '{"uniqueId":' + i + ', "sObjectType":"Picklist_Mapping__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"' +picklists.get(i).Id + '"}, {"Name":"ExternalSystem1Id__c","Value":"ExternalSystem1_0000' + fillLeft(i, 4) + '"}, {"Name":"Name","Value":"MY_PICKLIST_' + fillLeft(i, 4) + '"}, {"Name":"Object_Name__c","Value":"A MUCH TOO LONG PHONE NUMBER 12345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';

          }
          else {
              objectsAsString += '{"uniqueId":' + i + ', "sObjectType":"Picklist_Mapping__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"' +picklists.get(i).Id + '"}, {"Name":"ExternalSystem1Id__c","Value":"ExternalSystem1_0000' + fillLeft(i, 4) + '"}, {"Name":"Name","Value":"MY_PICKLIST_' + fillLeft(i, 4) + '"}, {"Name":"Object_Name__c","Value":"OBJECT0' + fillLeft(i, 4) + '"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
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
        System.assertEquals(numRecords, result1.operationResult.size());

        for (Integer i = 0; i < numRecords; i++) {
            System.assert(result1.operationResult.get(i).entityId == i);
            System.assert(result1.operationResult.get(i).sfdcId == null);
            System.assert(!result1.operationResult.get(i).success);
            System.assert(!result1.operationResult.get(i).created);
        }

        picklists = [select Name from Picklist_Mapping__c where Name like 'MY_PICKLIST_%' order by Name];
        System.assertEquals(numRecords, picklists.size());

        for (Integer i = 0; i < numRecords; i++) {
            System.assertEquals('MY_PICKLIST_' + fillLeft(i, 4), picklists.get(i).Name);
        }

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