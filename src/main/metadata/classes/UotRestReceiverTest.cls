@isTest
public class UotRestReceiverTest
{
    static testmethod void testExecuteAtomicSingleUpdate()
    {
        Picklist_Mapping__c account1 = new Picklist_Mapping__c(Name = 'MY_FIRST_ACCOUNT', Object_Name__c = 'OBJECT1', Field_Name__c = 'FIELD');
        insert account1;
        Picklist_Mapping__c account2 = new Picklist_Mapping__c(Name = 'MY_SECOND_ACCOUNT', Object_Name__c = 'OBJECT2', Field_Name__c = 'FIELD');
        insert account2;
        Picklist_Mapping__c account3 = new Picklist_Mapping__c(Name = 'MY_THIRD_ACCOUNT', Object_Name__c = 'OBJECT3', Field_Name__c = 'FIELD');
        insert account3;

        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"' + account1.ID + '"}, {"Name":"Name","Value":"MY_FIRST_ACCOUNT_CHANGED"}]}';
        String object2AsJson = '{"uniqueId":2, "sObjectType":"Picklist_Mapping__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"' + account2.ID + '"}, {"Name":"Name","Value":"MY_SECOND_ACCOUNT_CHANGED"}]}';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_SINGLE, '4711', '{"entityList":[' + object1AsJson + ', ' + object2AsJson + ']}'));

        String object3AsJson = '{"uniqueId":3, "sObjectType":"Picklist_Mapping__c", "operationType":"UPDATE", "fields": [{"Name":"Id","Value":"' + account3.ID + '"}, {"Name":"Name","Value":"MY_THIRD_ACCOUNT_CHANGED"}]}';
        unitsOfWork.add(createUnitOfWork(2l, DateTime.now(), UnitOfWorkType.ATOMIC_SINGLE, '4712', '{"entityList":[' + object3AsJson + ']}'));

        String unitsOfWorkAsJsonString = JSON.serialize(unitsOfWork);

        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/UotReceiver/test';
        RestContext.request.requestBody = Blob.valueOf('{"transferId":1, "unitOfWork":' + unitsOfWorkAsJsonString + '}');

        String resultAsString = UotRestReceiver.doPost();
        List<UnitOfWorkResponse> result = (List<UnitOfWorkResponse>)JSON.deserialize(resultAsString, List<UnitOfWorkResponse>.class);

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
        System.assertEquals('MY_FIRST_ACCOUNT_CHANGED', changedAccount1.Name);

        Picklist_Mapping__c changedAccount2 = [Select Name From Picklist_Mapping__c Where Id = :result1.operationResult.get(1).sfdcId];
        System.assertEquals('MY_SECOND_ACCOUNT_CHANGED', changedAccount2.Name);

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
        System.assertEquals('MY_THIRD_ACCOUNT_CHANGED', changedAccount3.Name);

        EpAdapterUnitOfWork__c epAdapterUnitOfWork2 = [select UnitOfWorkId__c, Type__c, Status__c from EpAdapterUnitOfWork__c where Id = :result2.sfdcId];
        System.assertEquals(2l, epAdapterUnitOfWork2.UnitOfWorkId__c);
        System.assertEquals('ATOMIC_SINGLE', epAdapterUnitOfWork2.Type__c);
        System.assertEquals('PROCESSED', epAdapterUnitOfWork2.Status__c);
    }

    private static UnitOfWork createUnitOfWork(long aUnitOfWorkId, Datetime aTriggeredDateTime, UnitOfWorkType aType, String aBtlId, String aObjectsAsString)
    {
        UnitOfWork result = new UnitOfWork();
        result.unitOfWorkId = aUnitOfWorkId;
        result.triggeredDateTime = aTriggeredDateTime;
        result.typeOrdinal = aType.ordinal();
        result.btlId = aBtlId;
        result.objectsAsString = aObjectsAsString;
        return result;
    }
}