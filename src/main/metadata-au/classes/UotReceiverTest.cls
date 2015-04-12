@isTest
public class UotReceiverTest
{
    static testmethod void testExecuteRetryUoT()
    {
        List<UnitOfWork> unitsOfWork = new List<UnitOfWork>();

        String object1AsJson = '{"uniqueId":1, "sObjectType":"Picklist_Mapping__c", "operationType":"INSERT", "fields": [{"Name":"External_Key__c","Value":"PM-000001"}, {"Name":"Name","Value":"MY_FIRST_ACCOUNT"}, {"Name":"Object_Name__c","Value":"OBJECT1"}, {"Name":"Field_Name__c","Value":"FIELD"}]}';
        unitsOfWork.add(createUnitOfWork(1l, DateTime.now(), UnitOfWorkType.ATOMIC_SINGLE, '4711', '{"entityList":[' + object1AsJson + ']}'));

        test.startTest();
        List<UnitOfWorkResponse> result = UotReceiver.execute(1, unitsOfWork, true).UnitOfWorkResponses;
        try {
            UotReceiver.execute(1, unitsOfWork, true);
            System.assert(false, 'Exception should be thrown on retry of UoT');
        }
        catch (System.DMLException expected) {
        		System.debug('------expected:------->' + expected.getMessage());
        }
        test.stopTest();
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