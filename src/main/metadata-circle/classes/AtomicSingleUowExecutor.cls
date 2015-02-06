public class AtomicSingleUowExecutor
    extends BaseUowExecutor
{
  public override List<OperationResult> execute(List<Operation> aOperationList)
  {
        List<OperationResult> result = new List<OperationResult>();

        if (aOperationList != null) {
            for (Operation operation : aOperationList) {
                if ('QUERY'.equalsIgnoreCase(operation.operationType)) {
                    result.add(executeQuery(operation));
                }
                else {
                    SObject obj = createSObjectFromOperation(operation);

                    if ('INSERT'.equalsIgnoreCase(operation.operationType)) {
                        result.addAll(executeInsert(createList(obj), createList(operation.uniqueId), false));
                    }
                    else if ('UPDATE'.equalsIgnoreCase(operation.operationType)) {
                        result.addAll(executeUpdate(createList(obj), createList(operation.uniqueId), false));
                    }
                    else if ('UPSERT'.equalsIgnoreCase(operation.operationType)) {
                        result.addAll(executeUpsert(createList(obj), createList(operation.uniqueId), operation.sObjectType, operation.externalIdField, false));
                    }
                    else if ('DELETE'.equalsIgnoreCase(operation.operationType)) {
                        result.addAll(executeDelete(createList(obj), createList(operation.uniqueId), false));
                    }
                }
            }
        }

        return result;
  }
}