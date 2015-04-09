public class AtomicMultipleUowExecutor
    extends BaseUowExecutor
{
    public override List<OperationResult> execute(List<Operation> aOperationList)
    {
        return executeMultipleEntitiesSameType(aOperationList, false);
    }

    private List<OperationResult> executeMultipleEntitiesSameType(List<Operation> aOperationList, Boolean aAllOrNothingFlag)
    {
        List<OperationResult> result = new List<OperationResult>();
        List<SObject> objs = new List<SObject>();
        List<Long> operationIds = new List<Long>();
        String operationType = null;
        Schema.SObjectType sObjectType = null;
        String type = null;
        String externalIdField = null;

        if (aOperationList != null) {
            for (Operation operation : aOperationList) {
                if (operationType == null) {
                    operationType = operation.operationType;
                }
                else if (operationType != operation.operationType) {
                    throw new IllegalArgumentException('All operations in a AtomicMultiple UoW must be identical');
                }

                if ('QUERY'.equalsIgnoreCase(operationType)) {
                    result.add(executeQuery(operation));
                }
                else {
                    SObject obj = createSObjectFromOperation(operation);

                    if (sObjectType == null) {
                        sObjectType = obj.getSObjectType();
                        type = operation.sObjectType;
                    }
                    else if (sObjectType != obj.getSObjectType()) {
                        throw new IllegalArgumentException('All operations in a MultipleEntitiesSameType UoW must have the same type');
                    }

                    if (externalIdField == null) {
                        externalIdField = operation.externalIdField;
                    }
                    else if (externalIdField != operation.externalIdField) {
                        throw new IllegalArgumentException('All operations in a MultipleEntitiesSameType UoW must have the same external ID field for upsert');
                    }

                    objs.add(obj);
                    operationIds.add(operation.uniqueId);
                }
            }

            if ('INSERT'.equalsIgnoreCase(operationType)) {
                result.addAll(executeInsert(objs, operationIds, aAllOrNothingFlag));
            }
            else if ('UPDATE'.equalsIgnoreCase(operationType)) {
                result.addAll(executeUpdate(objs, operationIds, aAllOrNothingFlag));
            }
            else if ('UPSERT'.equalsIgnoreCase(operationType)) {
                result.addAll(executeUpsert(objs, operationIds, type, externalIdField, aAllOrNothingFlag));
            }
            else if ('DELETE'.equalsIgnoreCase(operationType)) {
                result.addAll(executeDelete(objs, operationIds, aAllOrNothingFlag));
            }
        }

        return result;
    }
}