@isTest
public class UotReceiverDeleteTest
{
    static testmethod void testExecuteAtomicSingleDelete()
    {
        Picklist_Mapping__c account1 = new Picklist_Mapping__c(Name = 'MY_FIRST_ACCOUNT', Object_Name__c='OBJECT1', Field_Name__c='FIELD1');
        insert account1;
        Picklist_Mapping__c account2 = new Picklist_Mapping__c(Name = 'MY_SECOND_ACCOUNT', Object_Name__c='OBJECT2', Field_Name__c='FIELD2');
        insert account2;
        Picklist_Mapping__c account3 = new Picklist_Mapping__c(Name = 'MY_THIRD_ACCOUNT', Object_Name__c='OBJECT3', Field_Name__c='FIELD3');
        insert account3;

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"DELETE", "fields": [{"Name":"Id","Value":"' + account1.ID + '"}]}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"DELETE", "fields": [{"Name":"Id","Value":"' + account2.ID + '"}]}';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_SINGLE, '4711', '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}'));

        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"DELETE", "fields": [{"Name":"Id","Value":"' + account3.ID + '"}]}';
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

        List<Picklist_Mapping__c> deletedAccount1 = [Select Name From Picklist_Mapping__c Where Id = :account1.ID];
        System.assert(deletedAccount1.size() == 0);

        List<Picklist_Mapping__c> deletedAccount2 = [Select Name From Picklist_Mapping__c Where Id = :account2.ID];
        System.assert(deletedAccount2.size() == 0);

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

        List<Picklist_Mapping__c> deletedAccount3 = [Select Name From Picklist_Mapping__c Where Id = :account3.ID];
        System.assert(deletedAccount3.size() == 0);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork2 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result2.sfdcId];
        System.assertEquals(2l, epAdapterUnitOfWork2.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_SINGLE', epAdapterUnitOfWork2.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork2.Status__c);
    }

    static testmethod void testExecuteAtomicSingleDeleteWithFailure()
    {
        Picklist_Mapping__c account1 = new Picklist_Mapping__c(Name = 'MY_FIRST_ACCOUNT', Object_Name__c='OBJECT1', Field_Name__c='FIELD1');
        insert account1;
        Picklist_Mapping__c account3 = new Picklist_Mapping__c(Name = 'MY_THIRD_ACCOUNT', Object_Name__c='OBJECT3', Field_Name__c='FIELD3');
        insert account3;
        String invalidId = ('' + account1.ID).subString(0, 7) + 'INVALID' + ('' + account1.ID).subString(14);

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"DELETE", "fields": [{"Name":"Id","Value":"' + account1.ID + '"}]}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"DELETE", "fields": [{"Name":"Id","Value":"' + invalidId + '"}]}';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_SINGLE, '4711', '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}'));

        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"DELETE", "fields": [{"Name":"Id","Value":"' + account3.ID + '"}]}';
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
        System.assert(result1.operationResult.get(1).sfdcId != null);
        System.assert(!result1.operationResult.get(1).success);
        System.assert(!result1.operationResult.get(1).created);
        System.assert(result1.operationResult.get(1).errors != null);

        List<Picklist_Mapping__c> deletedAccount1 = [Select Name From Picklist_Mapping__c Where Id = :account1.ID];
        System.assert(deletedAccount1.size() == 0);

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

        List<Picklist_Mapping__c> deletedAccount3 = [Select Name From Picklist_Mapping__c Where Id = :account3.ID];
        System.assert(deletedAccount3.size() == 0);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork2 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result2.sfdcId];
        System.assertEquals(2l, epAdapterUnitOfWork2.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_SINGLE', epAdapterUnitOfWork2.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork2.Status__c);
    }

    static testmethod void testExecuteAtomicMultipleDelete()
    {
        Picklist_Mapping__c account1 = new Picklist_Mapping__c(Name = 'MY_FIRST_ACCOUNT', Object_Name__c='OBJECT1', Field_Name__c='FIELD1');
        insert account1;
        Picklist_Mapping__c account2 = new Picklist_Mapping__c(Name = 'MY_SECOND_ACCOUNT', Object_Name__c='OBJECT2', Field_Name__c='FIELD2');
        insert account2;
        Picklist_Mapping__c account3 = new Picklist_Mapping__c(Name = 'MY_THIRD_ACCOUNT', Object_Name__c='OBJECT3', Field_Name__c='FIELD3');
        insert account3;
        
        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"DELETE", "fields": [{"Name":"Id","Value":"' + account1.ID + '"}]}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"DELETE", "fields": [{"Name":"Id","Value":"' + account2.ID + '"}]}';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_MULTIPLE, '4711', '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}'));

        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"DELETE", "fields": [{"Name":"Id","Value":"' + account3.ID + '"}]}';
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

        List<Picklist_Mapping__c> deletedAccount1 = [Select Name From Picklist_Mapping__c Where Id = :account1.ID];
        System.assert(deletedAccount1.size() == 0);

        List<Picklist_Mapping__c> deletedAccount2 = [Select Name From Picklist_Mapping__c Where Id = :account2.ID];
        System.assert(deletedAccount2.size() == 0);

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

        List<Picklist_Mapping__c> deletedAccount3 = [Select Name From Picklist_Mapping__c Where Id = :account3.ID];
        System.assert(deletedAccount3.size() == 0);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork2 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result2.sfdcId];
        System.assertEquals(2l, epAdapterUnitOfWork2.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_MULTIPLE', epAdapterUnitOfWork2.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork2.Status__c);
    }

    public static testmethod void testExecuteCompoundSameTypeUpdateMoreThan200Records()
    {
        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();
        Integer numRecords = 402;

        List<Picklist_Mapping__c> accounts = new List<Picklist_Mapping__c>();
        for (Integer i = 0; i < numRecords; i++) {
            accounts.add(new Picklist_Mapping__c(Name = 'MY_ACCOUNT_' + fillLeft(i, 4), Object_Name__c = 'OBJECT', FIELD_NAME__c='FIELD'));
        }
        insert accounts;

        String objectsAsString = '';

        for (Integer i = 0; i < numRecords; i++) {
          if (objectsAsString.length() > 0) {
            objectsAsString += ', ';
          }
          objectsAsString += '{"uniqueId":' + i + ', "sObjectType":"Picklist_Mapping__c", "operationType":"DELETE", "fields": [{"Name":"Id","Value":"' + accounts.get(i).Id + '"}]}';
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

        accounts = [select Name from Picklist_Mapping__c where Name like 'My Account %' order by Name];
        System.assertEquals(0, accounts.size());

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

        List<Picklist_Mapping__c> accounts = new List<Picklist_Mapping__c>();
        for (Integer i = 0; i < numRecords; i++) {
            accounts.add(new Picklist_Mapping__c(Name = 'MY_ACCOUNT_' + fillLeft(i, 4), Object_Name__c = 'OBJECT', FIELD_NAME__c='FIELD'));
        }
        insert accounts;

        String objectsAsString = '';

        for (Integer i = 0; i < numRecords; i++) {
          if (objectsAsString.length() > 0) {
            objectsAsString += ', ';
          }

          if (i == recordWithError) {
              String invalidId = ('' + accounts.get(i).Id).subString(0, 7) + 'INVALID' + ('' + accounts.get(i).Id).subString(14);

              objectsAsString += '{"uniqueId":' + i + ', "sObjectType":"Picklist_Mapping__c", "operationType":"DELETE", "fields": [{"Name":"Id","Value":"' + invalidId + '"}]}';

          }
          else {
              objectsAsString += '{"uniqueId":' + i + ', "sObjectType":"Picklist_Mapping__c", "operationType":"DELETE", "fields": [{"Name":"Id","Value":"' + accounts.get(i).Id + '"}]}';
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

        List<String> accountIds = new List<String>();
        for (Integer i = 0; i < numRecords; i++) {
            System.assert(result1.operationResult.get(i).entityId == i);
            System.assert(result1.operationResult.get(i).sfdcId == null);
            System.assert(!result1.operationResult.get(i).success);
            System.assert(!result1.operationResult.get(i).created);
        }

        accounts = [select Name from Picklist_Mapping__c where Name like 'MY_ACCOUNT_%' order by Name];
        System.assertEquals(numRecords, accounts.size());

        for (Integer i = 0; i < numRecords; i++) {
            System.assertEquals('MY_ACCOUNT_' + fillLeft(i, 4), accounts.get(i).Name);
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