public class UowDecompiler
{
    public UnitOfWorkResponse decompile(EpAdapterUnitOfWork__c aSfdcUnitOfWork, String aUowObjectsAsJson)
    {
        Long startTime = System.currentTimeMillis();
        Long initialCpuTime = Limits.getCpuTime();
        Integer initialNumSoqlQueries = Limits.getQueries();
        Integer initialNumSoqlRecords = Limits.getQueryRows();
        Integer initialNumDmlStatements = Limits.getDMLStatements();
        Integer initialNumDmlRecords = Limits.getDMLRows();

        List<Operation> operationList= parseOperations(aUowObjectsAsJson);
        UnitOfWorkResponse response = new UnitOfWorkResponse();

        response.unitOfWorkId = (Long)aSfdcUnitOfWork.UnitOfWorkId__c;
        response.sfdcId = aSfdcUnitOfWork.Id;

        try {
            if (UnitOfWorkType.ATOMIC_SINGLE.name().equals(aSfdcUnitOfWork.Type__c)) {
              response.operationResult = new AtomicSingleUowExecutor().execute(operationList);
            }
            else if (UnitOfWorkType.ATOMIC_MULTIPLE.name().equals(aSfdcUnitOfWork.Type__c)) {
              response.operationResult = new AtomicMultipleUowExecutor().execute(operationList);
            }
            else if (UnitOfWorkType.COMPOUND_SAME_TYPE.name().equals(aSfdcUnitOfWork.Type__c)) {
              response.operationResult = new CompoundSameTypeUowExecutor().execute(operationList);
            }
            else if (UnitOfWorkType.COMPOUND_MULTIPLE_TYPES.name().equals(aSfdcUnitOfWork.Type__c)) {
              response.operationResult = new CompoundMultiTypeUowExecutor().execute(operationList);
            }
            else if (UnitOfWorkType.SOQL.name().equals(aSfdcUnitOfWork.Type__c)) {
              response.operationResult = new SoqlUowExecutor().execute(operationList);
            }

            response.status = getStatus(response.operationResult);

            aSfdcUnitOfWork.Status__c = response.status.name();
            if (UnitOfWorkStatus.FAILED == response.status) {
                aSfdcUnitOfWork.Error_Message__c = getErrorMessage(response.operationResult);
            }
        }
        catch (Exception e) {
            response.status = UnitOfWorkStatus.FAILED;
            if (operationList != null) {
                List<OperationResult> operationResults = new List<OperationResult>();

                for (Operation operation : operationList) {
                    OperationResult operationResult = new OperationResult();

                    operationResult.entityId = operation.uniqueId;
                    operationResult.sfdcId = null;
                    operationResult.success = false;
                    operationResult.created = false;

                    Error resultErr = new Error();

                    resultErr.message = '' + e + ' at ' + e.getStackTraceString();
                    resultErr.statusCode = e.getTypeName();

                    operationResult.errors = new List<Error>();
                    operationResult.errors.add(resultErr);
                	  operationResults.add(operationResult);
                }

                response.operationResult = operationResults;
            }
            aSfdcUnitOfWork.Status__c = response.status.name();
            aSfdcUnitOfWork.Error_Message__c = '' + e;
        }
        aSfdcUnitOfWork.NumSoqlQueries__c = Limits.getQueries() - initialNumSoqlQueries;
        aSfdcUnitOfWork.NumSoqlRecords__c = Limits.getQueryRows() - initialNumSoqlRecords;
        aSfdcUnitOfWork.NumDmlStatements__c = Limits.getDMLStatements() - initialNumDmlStatements + 1;
        aSfdcUnitOfWork.NumDmlRecords__c = Limits.getDMLRows() - initialNumDmlRecords + 1;
        aSfdcUnitOfWork.RunTime__c = System.currentTimeMillis() - startTime;
        aSfdcUnitOfWork.CpuTime__c = Limits.getCpuTime() - initialCpuTime;
        update aSfdcUnitOfWork;

        return response;
    }

    private List<Operation> parseOperations(String aUowObjectsAsJson)
    {
        List<Operation> result = new List<Operation>();
        JSONParser parser = JSON.createParser(aUowObjectsAsJson);

        while (parser.nextToken() != null) {
            // Start at the array of entities.
            if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
                while (parser.nextToken() != null) {
                    // Advance to the start object marker to
                    //  find next operation object.
                    if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                        // Read entire invoice object, including its array of fields.
                        Operation op = (Operation)parser.readValueAs(Operation.class);

                        result.add(op);

                        // Skip the child start array and start object markers.
                        parser.skipChildren();
                    }
                }
            }
        }

        return result;
    }

    private UnitOfWorkStatus getStatus(List<OperationResult> aOperationResult)
    {
        if (aOperationResult != null) {
            for (OperationResult operationResult : aOperationResult) {
                if (operationResult != null && !operationResult.success) {
                    return UnitOfWorkStatus.FAILED;
                }
            }
        }

        return UnitOfWorkStatus.PROCESSED;
    }

    private String getErrorMessage(List<OperationResult> aOperationResult)
    {
        String result = '';

        if (aOperationResult != null) {
            for (OperationResult operationResult : aOperationResult) {
                if (operationResult != null && operationResult.errors != null && !operationResult.success) {
                    for (Error err : operationResult.errors) {
                        if (result.length() > 0) {
                            result += '; ';
                        }
                        result += err.message;
                    }
                }
            }
        }

        if (result.length() > 255) {
            result = result.substring(0, 255);
        }

        return result;
    }
}