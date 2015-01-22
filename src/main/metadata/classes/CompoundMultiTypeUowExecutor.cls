public class CompoundMultiTypeUowExecutor
    extends BaseUowExecutor
{
    public override List<OperationResult> execute(List<Operation> aOperationList)
    {
        List<OperationResult> result = new List<OperationResult>();
        List<Long> operationIds = new List<Long>();
        List<SObject> objsToInsert = new List<SObject>();
        List<Long> operationIdsToInsert = new List<Long>();
        List<SObject> objsToUpdate = new List<SObject>();
        List<Long> operationIdsToUpdate = new List<Long>();
        List<SObject> objsToUpsert = new List<SObject>();
        List<Long> operationIdsToUpsert = new List<Long>();
        Map<String, List<SObject>> objsToUpsertByExternalIdAndType = new Map<String, List<SObject>>();
        Map<String, List<Long>> operationIdsToUpsertByExternalIdAndType = new Map<String, List<Long>>();
        List<SObject> objsToDelete = new List<SObject>();
        List<Long> operationIdsToDelete = new List<Long>();

        if (aOperationList != null) {
            for (Operation operation : aOperationList) {
                operationIds.add(operation.uniqueId);

                if ('QUERY'.equalsIgnoreCase(operation.operationType)) {
                    continue;
                }

                SObject obj = createSObjectFromOperation(operation);

                if ('INSERT'.equalsIgnoreCase(operation.operationType)) {
                    objsToInsert.add(obj);
                    operationIdsToInsert.add(operation.uniqueId);
                }
                else if ('UPDATE'.equalsIgnoreCase(operation.operationType)) {
                    objsToUpdate.add(obj);
                    operationIdsToUpdate.add(operation.uniqueId);
                }
                else if ('UPSERT'.equalsIgnoreCase(operation.operationType)) {
                    if (operation.externalIdField != null) {
                        addObjectToUpsert(objsToUpsertByExternalIdAndType, operationIdsToUpsertByExternalIdAndType, obj, operation.uniqueId, operation.externalIdField);
                    }
                    else {
                        objsToUpsert.add(obj);
                        operationIdsToUpsert.add(operation.uniqueId);
                    }
                }
                else if ('DELETE'.equalsIgnoreCase(operation.operationType)) {
                    objsToDelete.add(obj);
                    operationIdsToDelete.add(operation.uniqueId);
                }
            }

            System.Savepoint sp = Database.setSavepoint();

            if (!objsToInsert.isEmpty()) {
                result.addAll(executeInsert(objsToInsert, operationIdsToInsert, true));
            }

            if (getStatus(result) != UnitOfWorkStatus.FAILED && !objsToUpsert.isEmpty()) {
                result.addAll(executeUpsert(objsToUpsert, operationIdsToUpsert, null, null, true));
            }
            else if (!objsToUpsert.isEmpty()) {
            	  result.addAll(buildAllOrNothingOperationFailedResult(operationIdsToUpsert));
            }

            if (getStatus(result) != UnitOfWorkStatus.FAILED && !objsToUpsertByExternalIdAndType.isEmpty()) {
                for (String externalIdAndType : objsToUpsertByExternalIdAndType.keySet()) {
                    String externalId = getExternalId(externalIdAndType);
                    String sObjectType = getType(externalIdAndType);
                    result.addAll(executeUpsert(objsToUpsertByExternalIdAndType.get(externalIdAndType), operationIdsToUpsertByExternalIdAndType.get(externalIdAndType), sObjectType, externalId, true));
                }
            }
            else if (!objsToUpsertByExternalIdAndType.isEmpty()) {
                for (String externalIdAndType : objsToUpsertByExternalIdAndType.keySet()) {
                    result.addAll(buildAllOrNothingOperationFailedResult(operationIdsToUpsertByExternalIdAndType.get(externalIdAndType)));
                }
            }

            if (getStatus(result) != UnitOfWorkStatus.FAILED && !objsToUpdate.isEmpty()) {
                result.addAll(executeUpdate(objsToUpdate, operationIdsToUpdate, true));
            }
            else if (!objsToUpdate.isEmpty()) {
                result.addAll(buildAllOrNothingOperationFailedResult(operationIdsToUpdate));
            }

            if (getStatus(result) != UnitOfWorkStatus.FAILED && !objsToDelete.isEmpty()) {
                result.addAll(executeDelete(objsToDelete, operationIdsToDelete, true));
            }
            else if (!objsToDelete.isEmpty()) {
                result.addAll(buildAllOrNothingOperationFailedResult(operationIdsToDelete));
            }

            if (getStatus(result) == UnitOfWorkStatus.FAILED) {
                System.debug('Compound operation failed - rollback');
                Database.rollback(sp);
                setAllFailed(result);
            }

            for (Operation operation : aOperationList) {
                if ('QUERY'.equalsIgnoreCase(operation.operationType)) {
                    result.add(executeQuery(operation));
                }
            }
        }

        return orderOperationResult(result, operationIds);
    }

    private void addObjectToUpsert(Map<String, List<SObject>> aObjectsToUpsertByExternalIdAndTypeMap, Map<String, List<Long>> aOperationIdsToUpsertByExternalIdAndTypeMap, SObject aObject, Long aOperationId, String aExternalId)
    {
        System.assert(aExternalId != null, 'addObjectToUpsert must not be called when no externalId is specified');

        String externalIdAndType = aExternalId + DELIMITER + aObject.getSObjectType().getDescribe().getName();

        List<SObject> objectsToUpsertForExternalIdAndType = aObjectsToUpsertByExternalIdAndTypeMap.get(externalIdAndType);
        if (objectsToUpsertForExternalIdAndType == null) {
            objectsToUpsertForExternalIdAndType = new List<SObject>();
            aObjectsToUpsertByExternalIdAndTypeMap.put(externalIdAndType, objectsToUpsertForExternalIdAndType);
        }
        objectsToUpsertForExternalIdAndType.add(aObject);

        List<Long> operationIdsToUpsertForExternalIdAndType = aOperationIdsToUpsertByExternalIdAndTypeMap.get(externalIdAndType);
        if (operationIdsToUpsertForExternalIdAndType == null) {
            operationIdsToUpsertForExternalIdAndType = new List<Long>();
            aOperationIdsToUpsertByExternalIdAndTypeMap.put(externalIdAndType, operationIdsToUpsertForExternalIdAndType);
        }
        operationIdsToUpsertForExternalIdAndType.add(aOperationId);
    }

    private String getExternalId(String aExternalIdAndType)
    {
        Integer pos = aExternalIdAndType.indexOf(DELIMITER);
        return aExternalIdAndType.substring(0, pos);
    }

    private String getType(String aExternalIdAndType)
    {
        Integer pos = aExternalIdAndType.indexOf(DELIMITER);
        return aExternalIdAndType.substring(pos + DELIMITER.length());
    }
}