public abstract class BaseUowExecutor
{
    public final static String DELIMITER = '_||_';
    public final static String TRANSACTION_SEPARATOR = ';';
    private static final Integer UPDATED_BY_EPA_TRANSACTIONS_MAX_LEN = 255;
    private static final Integer MAX_UPSERT_CHUNK_SIZE = 200;
    private static final Integer MAX_DELETE_CHUNK_SIZE = 200;

    private static Map<String, Schema.DescribeSObjectResult> sObjectDescriptionsByTypeName = new Map<String, Schema.DescribeSObjectResult>();

    public abstract List<OperationResult> execute(List<Operation> aOperationList);

    protected OperationResult executeQuery(Operation aQuery)
    {
        try {
            String fieldList = createFieldList(aQuery.sObjectType, aQuery.fields, '', 1);
            String queryAsString = 'select ' + fieldList + ' from ' + aQuery.sObjectType + ' where ' + aQuery.whereClause;
            System.debug('Query: ' + queryAsString);
            List<SObject> queryResult = Database.query(queryAsString);

            return buildOperationResultFromQueryResult(queryResult, aQuery);
        }
        catch (System.QueryException e) {
            return buildOperationResultFromQueryException(e, aQuery.uniqueId);
        }
    }

    private String createFieldList(String aSObjectType, List<Field> aFieldsList, String aPrefix, Integer aLevel)
    {
        String result = '';
        Schema.DescribeSObjectResult schema = getDescribeSObjectResult(aSObjectType);

        for (Field field : aFieldsList) {
            if (field.subEntities != null && field.subEntities.size() == 1) {
            	  String relationFieldName;

            	  if (field.Name.endsWith('__r')) {
            	  	  relationFieldName = field.Name.replace('__r', '__c');
            	  }
            	  else {
            	  	  relationFieldName = field.Name + 'Id';
            	  }
                Schema.SObjectField parentRelationField = getField(schema, relationFieldName);
                Entity subEntity = field.subEntities.get(0);

                if (parentRelationField != null && aLevel <= 5) {
                    if (result.length() > 0) {
                        result += ', ';
                    }
                    result += createFieldList(subEntity.sObjectType, subEntity.fields, aPrefix + field.Name + '.', aLevel + 1);
                }
                else {
                    if (aLevel <= 1) {
                        if (result.length() > 0) {
                            result += ', ';
                        }

                        Schema.ChildRelationship childRelationship = getChildRelationship(schema, field.Name);

                        if (childRelationship != null) {
                            String subEntityFieldList = createFieldList(subEntity.sObjectType, subEntity.fields, aPrefix, aLevel + 1);
                            result += '(Select ' + subEntityFieldList + ' From ' + field.Name + ')';
                        }
                        else {
                            throw new IllegalArgumentException('No relationship found for name ' + field.Name);
                        }
                    }
                }
            }
            else if (field.subEntities != null && field.subEntities.size() > 1) {
                throw new IllegalArgumentException('SubEntities in queries must always be of size 1');
            }
            else {
                if (result.length() > 0) {
                    result += ', ';
                }
                result += aPrefix + field.Name;
            }
        }

        return result;
    }

    private OperationResult buildOperationResultFromQueryResult(List<SObject> aQueryResultList, Operation aQuery)
    {
        OperationResult operationResult = new OperationResult();

        operationResult.entityId = aQuery.uniqueId;
        operationResult.success = true;
        operationResult.created = false;

        List<Entity> resultObjects = createEntitiesFromSObjects(aQueryResultList, aQuery);
        operationResult.resultObjectsAsString = JSON.serialize(resultObjects);

        return operationResult;
    }

    private List<Entity> createEntitiesFromSObjects(List<SObject> aSObjectList, Operation aQuery)
    {
        List<Entity> result = new List<Entity>();

        if (aSObjectList != null) {
            for (SObject obj : aSObjectList) {
                Entity entity = createEntityFromSObject(obj, aQuery.Fields, 1);

                result.add(entity);
            }
        }

        return result;
    }

    private Entity createEntityFromSObject(SObject aSObject, List<Field> aQueryFieldList, Integer aLevel)
    {
        Schema.DescribeSObjectResult objSchema = aSObject.getsObjectType().getDescribe();
        Entity result = new Entity();
        result.sObjectType = objSchema.getName();
        result.Fields = new List<Field>();

        for (Field queryField : aQueryFieldList) {
            Field field = new Field();

            field.Name = queryField.Name;
            result.Fields.add(field);

            if (queryField.subEntities != null && queryField.subEntities.size() == 1) {
                String relationFieldName;

                if (field.Name.endsWith('__r')) {
                    relationFieldName = queryField.Name.replace('__r', '__c');
                }
                else {
                    relationFieldName = queryField.Name + 'Id';
                }

                Schema.SObjectField parentRelationField = getField(objSchema, relationFieldName);
                Schema.ChildRelationship childRelationship = getChildRelationship(objSchema, queryField.Name);

                if (parentRelationField != null && aLevel <= 5) {
                    SObject subEntity = aSObject.getSObject(queryField.Name);
                    field.SubEntities = new List<Entity>();
                    if (subEntity != null) {
                        field.SubEntities.add(createEntityFromSObject(subEntity , queryField.subEntities.get(0).Fields, aLevel + 1));
                    }
                }
                else if (childRelationship != null) {
                    if (aLevel <= 1) {
                        field.SubEntities = new List<Entity>();
                        for (SObject childObject : aSObject.getSObjects(queryField.Name)) {
                            if (childObject != null) {
                                field.SubEntities.add(createEntityFromSObject(childObject, queryField.subEntities.get(0).Fields, aLevel + 1));
                            }
                        }
                    }
                }
            }
            else {
                field.Value = String.valueOf(aSObject.get(queryField.Name));
            }
        }

        return result;
    }

    private OperationResult buildOperationResultFromQueryException(QueryException aException, Long aQueryId)
    {
        OperationResult operationResult = new OperationResult();

        operationResult.entityId = aQueryId;
        operationResult.sfdcId = null;
        operationResult.success = false;
        operationResult.created = false;

        Error resultErr = new Error();

        resultErr.message = aException.getMessage();
        resultErr.statusCode = aException.getTypeName();

        operationResult.errors = new List<Error>();
        operationResult.errors.add(resultErr);

        System.assert(operationResult != null);
        return operationResult;
    }

    protected List<OperationResult> executeInsert(List<SObject> aSObjectList, List<Long> aOperationIdList, Boolean aAllOrNothingFlag)
    {
        System.assert(aSObjectList.size() == aOperationIdList.size(), 'Inconsistent lists as parameters to executeInsert');

        List<OperationResult> result = new List<OperationResult>();

        if (aSObjectList.size() > 0) {
            if (aSObjectList.size() > MAX_UPSERT_CHUNK_SIZE) {
                System.Savepoint sp = null;

                if (aAllOrNothingFlag) {
                    sp = Database.setSavepoint();
                }

                Integer nextChunkOffset = 0;

                while (nextChunkOffset < aSObjectList.size()) {
                    List<SObject> chunk = subList(aSObjectList, nextChunkOffset, MAX_UPSERT_CHUNK_SIZE);
                    List<Long> operationIdChunk = subList(aOperationIdList, nextChunkOffset, MAX_UPSERT_CHUNK_SIZE);

                    try {
                        List<Database.SaveResult> saveResults = Database.insert(chunk, aAllOrNothingFlag);
                        result.addAll(buildOperationResultFromSaveResult(saveResults, operationIdChunk, true));
                    }
                    catch (System.DmlException e) {
                        if (aAllOrNothingFlag) {
                            Database.rollback(sp);
                            result.clear();
                            result.addAll(buildOperationResultFromDmlException(e, aOperationIdList, true));
                            setAllFailed(result);
                            break;
                        }
                        else {
                            result.addAll(buildOperationResultFromDmlException(e, operationIdChunk, true));
                        }
                    }
                    finally {
                        nextChunkOffset += chunk.size();
                    }
                }
            }
            else {
                try {
                    List<Database.SaveResult> saveResults = Database.insert(aSObjectList, aAllOrNothingFlag);

                    result.addAll(buildOperationResultFromSaveResult(saveResults, aOperationIdList, true));
                }
                catch (System.DmlException e) {
                    result.addAll(buildOperationResultFromDmlException(e, aOperationIdList, true));
                }
            }
        }

        return result;
    }

    protected List<SObject> subList(List<SObject> aList, Integer aOffset, Integer aSize)
    {
      	List<SObject> result = new List<SObject>();

      	for (Integer i = aOffset; i < Math.min(aList.size(), aOffset + aSize); i++) {
    		    result.add(aList.get(i));
    	  }

      	return result;
    }

    protected List<Long> subList(List<Long> aList, Integer aOffset, Integer aSize)
    {
        List<Long> result = new List<Long>();

        for (Integer i = aOffset; i < Math.min(aList.size(), aOffset + aSize); i++) {
            result.add(aList.get(i));
        }

        return result;
    }

    protected List<OperationResult> executeUpdate(List<SObject> aSObjectList, List<Long> aOperationIdList, Boolean aAllOrNothingFlag)
    {
        System.assert(aSObjectList.size() == aOperationIdList.size(), 'Inconsistent lists as parameters to executeUpdate');

        List<OperationResult> result = new List<OperationResult>();

        if (aSObjectList.size() > 0) {
            List<SObject> aUniqueSObjectList = new List<SObject>();
            List<Long> aUniqueOperationIdList = new List<Long>();
            List<SObject> aDuplicateSObjectList = new List<SObject>();
            List<Long> aDuplicateOperationIdList = new List<Long>();

            for (Integer i = 0; i < aSobjectList.size(); i++) {
                SObject obj = aSObjectList.get(i);
                Long operationId = aOperationIdList.get(i);

                if (!containsId(aUniqueSObjectList, obj.Id)) {
                    aUniqueSObjectList.add(obj);
                    aUniqueOperationIdList.add(operationId);
                }
                else {
                    aDuplicateSObjectList.add(obj);
                    aDuplicateOperationIdList.add(operationId);
                }
            }

            result.addAll(executeUpdateWithUniqueIds(aUniqueSObjectList, aUniqueOperationIdList, aAllOrNothingFlag));
            if ((!aAllOrNothingFlag || UnitOfWorkStatus.PROCESSED == getStatus(result)) && aDuplicateSObjectList.size() > 0) {
                result.addAll(executeUpdate(aDuplicateSObjectList, aDuplicateOperationIdList, aAllOrNothingFlag));
            }
        }

        return result;
    }

    private List<OperationResult> executeUpdateWithUniqueIds(List<SObject> aSObjectList, List<Long> aOperationIdList, Boolean aAllOrNothingFlag)
    {
        System.assert(aSObjectList.size() == aOperationIdList.size(), 'Inconsistent lists as parameters to executeUpdateWithUniqueIds');

        List<OperationResult> result = new List<OperationResult>();

        if (aSObjectList.size() > 0) {
            if (aSObjectList.size() > MAX_UPSERT_CHUNK_SIZE) {
                System.Savepoint sp = null;

                if (aAllOrNothingFlag) {
                    sp = Database.setSavepoint();
                }

                Integer nextChunkOffset = 0;

                while (nextChunkOffset < aSObjectList.size()) {
                    List<SObject> chunk = subList(aSObjectList, nextChunkOffset, MAX_UPSERT_CHUNK_SIZE);
                    List<Long> operationIdChunk = subList(aOperationIdList, nextChunkOffset, MAX_UPSERT_CHUNK_SIZE);

                    try {
                        List<Database.SaveResult> saveResults = Database.update(chunk, aAllOrNothingFlag);
                        result.addAll(buildOperationResultFromSaveResult(saveResults, operationIdChunk, false));
                    }
                    catch (System.DmlException e) {
                        if (aAllOrNothingFlag) {
                            Database.rollback(sp);
                            result.clear();
                            result.addAll(buildOperationResultFromDmlException(e, aOperationIdList, false));
                            setAllFailed(result);
                            break;
                        }
                        else {
                            result.addAll(buildOperationResultFromDmlException(e, operationIdChunk, false));
                        }
                    }
                    finally {
                        nextChunkOffset += chunk.size();
                    }
                }
            }
            else {
                try {
                    List<Database.SaveResult> saveResults = Database.update(aSObjectList, aAllOrNothingFlag);

                    result.addAll(buildOperationResultFromSaveResult(saveResults, aOperationIdList, false));
                }
                catch (System.DmlException e) {
                    result.addAll(buildOperationResultFromDmlException(e, aOperationIdList, false));
                }
            }
        }

        return result;
    }

    private List<OperationResult> buildOperationResultFromSaveResult(List<Database.SaveResult> aSaveResultList, List<Long> aOperationIdList, Boolean aIsInsertFlag)
    {
        System.assert(aSaveResultList.size() == aOperationIdList.size(), 'The number of SaveResults does not match the number of saved objects');

        List<OperationResult> result = new List<OperationResult>();
        for (Integer i = 0; i < aSaveResultList.size(); i++) {
            Database.SaveResult saveResult = aSaveResultList.get(i);
            OperationResult operationResult = new OperationResult();

            operationResult.entityId = aOperationIdList.get(i);
            operationResult.sfdcId = saveResult.Id;

            if (!saveResult.isSuccess()) {
                operationResult.success = false;
                operationResult.created = false;
                operationResult.errors = new List<Error>();
                for (Database.Error err : saveResult.Errors) {
                    Error resultErr = new Error();

                    resultErr.message = err.Message;
                    resultErr.statusCode = err.StatusCode.name();
                    resultErr.fields = new List<String>();
                    for (String field : err.Fields) {
                        resultErr.fields.add(field);
                    }
                    operationResult.errors.add(resultErr);
                }
            }
            else {
                operationResult.success = true;
                operationResult.created = aIsInsertFlag;
            }

            System.assert(operationResult != null);
            result.add(operationResult);
        }

        return result;
    }

    private List<OperationResult> buildOperationResultFromDmlException(DmlException aException, List<Long> aOperationIdList, Boolean aIsInsertFlag)
    {
        List<OperationResult> result = new List<OperationResult>();

        if (aOperationIdList != null) {
            for (Integer i = 0; i < aOperationIdList.size(); i++) {
                OperationResult operationResult = new OperationResult();

                operationResult.entityId = aOperationIdList.get(i);
                operationResult.sfdcId = null;
                operationResult.success = false;
                operationResult.created = false;

                Error resultErr = new Error();

                for (Integer j = 0; j < aException.getNumDml(); j++) {
                    if (aException.getDmlIndex(j) == i) {
                        resultErr.message = aException.getDmlMessage(j);
                        if (aException.getDmlType(j) != null) {
                            resultErr.statusCode = aException.getDmlType(j).name();
                        }
                        resultErr.fields = new List<String>();
                        for (String field : aException.getDmlFieldNames(j)) {
                            resultErr.fields.add(field);
                        }

                        operationResult.errors = new List<Error>();
                        operationResult.errors.add(resultErr);
                    }
                }

                System.assert(operationResult != null);
                result.add(operationResult);
            }
        }

        return result;
    }

    protected List<OperationResult> buildAllOrNothingOperationFailedResult(List<Long> aOperationIdList)
    {
        List<OperationResult> result = new List<OperationResult>();

        if (aOperationIdList != null) {
            for (Integer i = 0; i < aOperationIdList.size(); i++) {
                OperationResult operationResult = new OperationResult();

                operationResult.entityId = aOperationIdList.get(i);
                operationResult.sfdcId = null;
                operationResult.success = false;
                operationResult.created = false;

                operationResult.errors = new List<Error>();
                operationResult.errors.add(new Error());
                operationResult.errors.get(0).message = 'Error occurred on other Entity in AllOrNothing operation.';

                result.add(operationResult);
            }
        }

        return result;
    }

    protected List<OperationResult> executeUpsert(List<SObject> aSObjectList, List<Long> aOperationIdList, String aSObjectType, String aExternalIdField, Boolean aAllOrNothingFlag)
    {
        System.assert(aSObjectList.size() == aOperationIdList.size(), 'Inconsistent lists as parameters to executeUpsert');

        List<OperationResult> result = new List<OperationResult>();
        Schema.SObjectField createdByEpTransactionField = getField(aSObjectType, 'Created_By_EP_Transaction__c');
        Schema.SObjectField updatedByEpTransactionsField = getField(aSObjectType, 'Updated_By_EP_Transactions__c');

        if (aSObjectList.size() > 0) {
            List<SObject> sObjectToInsertList = new List<SObject>();
            List<Long> operationIdToInsertList = new List<Long>();
            List<SObject> sObjectToUpdateList = new List<SObject>();
            List<Long> operationIdToUpdateList = new List<Long>();
            Map<Object, List<SObject>> sObjectsToQueryByExternalId = new Map<Object, List<SObject>>();
            Map<Object, List<Long>> operationIdsToQueryByExternalId = new Map<Object, List<Long>>();


            for (Integer i = 0; i < aSObjectList.size(); i++) {
                SObject obj = aSObjectList.get(i);
                Long operationId = aOperationIdList.get(i);
                Object externalId = null;

                if (aExternalIdField != null) {
                    externalId = obj.get(aExternalIdField);
                }

                if (obj.Id != null) {
                    sObjectToUpdateList.add(obj);
                    operationIdToUpdateList.add(operationId);
                }
                else if (externalId == null || aSObjectType == null) {
                    if (createdByEpTransactionField != null && updatedByEpTransactionsField != null && obj.get(updatedByEpTransactionsField) != null) {
                        obj.put(createdByEpTransactionField, obj.get(updatedByEpTransactionsField));
                        obj.put(updatedByEpTransactionsField, null);
                    }
                    sObjectToInsertList.add(obj);
                    operationIdToInsertList.add(operationId);
                }
                else {
                    System.assert(externalId != null, 'Entity does not have an external ID - ' + obj);
                    List<SObject> sObjectsForExternalId = sObjectsToQueryByExternalId.get(externalId);
                    if (sObjectsForExternalId == null) {
                        sObjectsForExternalId = new List<SObject>();
                        sObjectsToQueryByExternalId.put(externalId, sObjectsForExternalId );
                    }
                    sObjectsForExternalId.add(obj);

                    List<Long> operationIdsForExternalId = operationIdsToQueryByExternalId.get(externalId);
                    if (operationIdsForExternalId == null) {
                        operationIdsForExternalId = new List<Long>();
                        operationIdsToQueryByExternalId.put(externalId, operationIdsForExternalId );
                    }
                    operationIdsForExternalId.add(operationId);
                }
            }

            if (sObjectsToQueryByExternalId.size() > 0) {
                String fieldList = 'Id, ' + aExternalIdField;

                if (createdByEpTransactionField != null) {
                    fieldList += ', Created_By_EP_Transaction__c';
                }
                if (updatedByEpTransactionsField != null) {
                    fieldList += ', Updated_By_EP_Transactions__c';
                }

                String whereClause = aExternalIdField + ' in (\'' + asString(sObjectsToQueryByExternalId.keySet(), '\',\'') + '\')';
                String query = 'Select ' + fieldList + ' From ' + aSObjectType + ' Where ' + whereClause;
                List<SObject> objs = Database.query(query);

                if (objs != null && objs.size() > 0) {
                    for (SObject obj : objs) {
                        Object externalId = obj.get(aExternalIdField);
                        List<SObject> objsToUpdate = sObjectsToQueryByExternalId.remove(externalId);

                        if (objsToUpdate != null) {
                            for (SObject objToUpdate : objsToUpdate) {
                                objToUpdate.Id = obj.Id;
                                if (updatedByEpTransactionsField != null) {
                                    String updatedByEpTransactions = appendUpdatedByEpaTransaction((String)obj.get(updatedByEpTransactionsField),
                                                                                                   (String)objToUpdate.get(updatedByEpTransactionsField));

                                    objToUpdate.put(updatedByEpTransactionsField, updatedByEpTransactions);
                                }
                                sObjectToUpdateList.add(objToUpdate);
                            }
                            operationIdToUpdateList.addAll(operationIdsToQueryByExternalId.remove(externalId));
                        }
                    }
                }
                if (sObjectsToQueryByExternalId.size() > 0) {
                    for (Object externalId : sObjectsToQueryByExternalId.keySet()) {
                        List<SObject> objsToInsert = sObjectsToQueryByExternalId.remove(externalId);

                        if (objsToInsert != null) {
                            for (SObject objToInsert : objsToInsert) {
                                if (createdByEpTransactionField != null && updatedByEpTransactionsField != null && objToInsert.get(updatedByEpTransactionsField) != null) {
                                    objToInsert.put(createdByEpTransactionField, objToInsert.get(updatedByEpTransactionsField));
                                    objToInsert.put(updatedByEpTransactionsField, null);
                                }
                                sObjectToInsertList.add(objToInsert);
                            }
                            operationIdToInsertList.addAll(operationIdsToQueryByExternalId.remove(externalId));
                        }
                    }
                }
            }

            Savepoint sp = null;

            if (aAllOrNothingFlag) {
                // setSavepoint counts as DML operation, so only use it if necessary
                sp = Database.setSavepoint();
            }

            if (sObjectToInsertList.size() > 0) {
                result.addAll(executeInsert(sObjectToInsertList, operationIdToInsertList, aAllOrNothingFlag));

            }

            if (aAllOrNothingFlag && getStatus(result) == UnitOfWorkStatus.FAILED) {
                System.debug('Insert failed - rollback');
                Database.rollback(sp);
		            if (!sObjectToUpdateList.isEmpty()) {
		                result.addAll(buildAllOrNothingOperationFailedResult(operationIdToUpdateList));
		            }
            }
            else if (sObjectToUpdateList.size() > 0) {
                result.addAll(executeUpdate(sObjectToUpdateList, operationIdToUpdateList, aAllOrNothingFlag));
                if (aAllOrNothingFlag && getStatus(result) == UnitOfWorkStatus.FAILED) {
                    System.debug('Update failed - rollback');
                    Database.rollback(sp);
                    setAllFailed(result);
                }
            }

            result = orderOperationResult(result, aOperationIdList);
        }

        return result;
    }

    protected List<OperationResult> orderOperationResult(List<OperationResult> aOperationResultList, List<Long> aOperationIdList)
    {
        List<OperationResult> result = new List<OperationResult>();
        Map<Long, OperationResult> operationResultById = getOperationResultById(aOperationResultList);

        if (aOperationIdList != null) {
            for (Long operationId : aOperationIdList) {
                OperationResult operationResult = operationResultById.get(operationId);
                System.assert(operationResult != null, 'No operation result found for operation ID ' + operationId );
                result.add(operationResult );
            }
        }

        return result;
    }

    private Map<Long, OperationResult> getOperationResultById(List<OperationResult> aOperationResultList)
    {
        Map<Long, OperationResult> result = new Map<Long, OperationResult>();

        if (aOperationResultList != null) {
            for (OperationResult operationResult : aOperationResultList) {
                result.put(operationResult.entityId, operationResult);
            }
        }

        return result;
    }

    protected List<OperationResult> executeDelete(List<SObject> aSObjectList, List<Long> aOperationIdList, Boolean aAllOrNothingFlag)
    {
        System.assert(aSObjectList.size() == aOperationIdList.size(), 'Inconsistent lists as parameters to executeDelete');

        List<OperationResult> result = new List<OperationResult>();

        if (aSObjectList.size() > 0) {
            if (aSObjectList.size() > MAX_DELETE_CHUNK_SIZE) {
                System.Savepoint sp = null;

                if (aAllOrNothingFlag) {
                    sp = Database.setSavepoint();
                }

                Integer nextChunkOffset = 0;

                while (nextChunkOffset < aSObjectList.size()) {
                    List<SObject> chunk = subList(aSObjectList, nextChunkOffset, MAX_DELETE_CHUNK_SIZE);
                    List<Long> operationIdChunk = subList(aOperationIdList, nextChunkOffset, MAX_DELETE_CHUNK_SIZE);

                    try {
                        List<Database.DeleteResult> deleteResults = Database.delete(chunk, aAllOrNothingFlag);
                        result.addAll(buildOperationResultFromDeleteResult(deleteResults, operationIdChunk));
                    }
                    catch (System.DmlException e) {
                        if (aAllOrNothingFlag) {
                            Database.rollback(sp);
                            result.clear();
                            result.addAll(buildOperationResultFromDmlException(e, aOperationIdList, false));
                            setAllFailed(result);
                            break;
                        }
                        else {
                            result.addAll(buildOperationResultFromDmlException(e, operationIdChunk, false));
                        }
                    }
                    finally {
                        nextChunkOffset += chunk.size();
                    }
                }
            }
            else {
                try {
                    List<Database.DeleteResult> deleteResults = Database.delete(aSObjectList, aAllOrNothingFlag);

                    result.addAll(buildOperationResultFromDeleteResult(deleteResults, aOperationIdList));
                }
                catch (System.DmlException e) {
                    result.addAll(buildOperationResultFromDmlException(e, aOperationIdList, false));
                }
            }
        }

        return result;
    }

    private List<OperationResult> buildOperationResultFromDeleteResult(List<Database.DeleteResult> aDeleteResultList, List<Long> aOperationIdList)
    {
        System.assert(aDeleteResultList.size() == aOperationIdList.size(), 'The number of DeleteResults does not match the number of deleted objects');

        List<OperationResult> result = new List<OperationResult>();

        for (Integer i = 0; i < aDeleteResultList.size(); i++) {
            Database.DeleteResult deleteResult = aDeleteResultList.get(i);
            OperationResult operationResult = new OperationResult();

            operationResult.entityId = aOperationIdList.get(i);
            operationResult.sfdcId = deleteResult.Id;

            if (!deleteResult.isSuccess()) {
                operationResult.success = false;
                operationResult.created = false;
                operationResult.errors = new List<Error>();
                for (Database.Error err : deleteResult.Errors) {
                    Error resultErr = new Error();

                    resultErr.message = err.Message;
                    resultErr.statusCode = err.StatusCode.name();
                    resultErr.fields = new List<String>();
                    for (String field : err.Fields) {
                        resultErr.fields.add(field);
                    }
                    operationResult.errors.add(resultErr);
                }
            }
            else {
                operationResult.success = true;
                operationResult.created = false;
            }

            result.add(operationResult);
        }

        return result;
    }

    protected SObject createSObjectFromOperation(Operation aOperation)
    {
        Type entityType = Type.forName(aOperation.sObjectType);
        SObject result = (SObject)entityType.newInstance();
        Map<String, Schema.SObjectField> fields = getDescribeSObjectResult(aOperation.sObjectType).fields.getMap();

        for (Field field : aOperation.fields)
        {
            Schema.SObjectField sObjectField = fields.get(field.name);
            setFieldValue(result, sObjectField, field.value);
        }

        if (aOperation.fieldsToNull != null) {
            for (Field fieldToNull : aOperation.fieldsToNull)
            {
                Schema.SObjectField sObjectField = fields.get(fieldToNull.name);
                setFieldValue(result, sObjectField, null);
            }
        }

        return result;
    }

    private Schema.SObjectField getField(String aClassName, String aFieldName)
    {
        if (aClassName == null || aFieldName == null) {
            return null;
        }

        return getField(getDescribeSObjectResult(aClassName), aFieldName);
    }

    private Schema.SObjectField getField(Schema.DescribeSObjectResult aSchema, String aFieldName)
    {
        if (aSchema == null || aFieldName == null) {
            return null;
        }

        Map<String, Schema.SObjectField> fields = aSchema.fields.getMap();

        return fields.get(aFieldName);
    }

    private Schema.ChildRelationship getChildRelationship(String aClassName, String aFieldName)
    {
        if (aClassName == null || aFieldName == null) {
            return null;
        }

        return getChildRelationship(getDescribeSObjectResult(aClassName), aFieldName);
    }

    private Schema.ChildRelationship getChildRelationship(Schema.DescribeSObjectResult aSchema, String aFieldName)
    {
        if (aSchema == null || aFieldName == null) {
            return null;
        }

        List<Schema.ChildRelationship> childRelationships = aSchema.getChildRelationships();

        for (Schema.ChildRelationship childRelationship : childRelationships) {
            if (aFieldName.equals(childRelationship.getRelationshipName() )) {
                return childRelationship;
            }
        }

        return null;
    }

    private Schema.DescribeSObjectResult getDescribeSObjectResult(String aClassName)
    {
        Schema.DescribeSObjectResult result = sObjectDescriptionsByTypeName.get(aClassName);

        if (result == null) {
            Type entityType = Type.forName(aClassName);
            if (entityType == null) {
                throw new IllegalArgumentException('Class ' + aClassName + ' not found.');
            }
            SObject entity = (SObject)entityType.newInstance();
            result = entity.getSObjectType().getDescribe();
            sObjectDescriptionsByTypeName.put(aClassName, result);
        }

        return result;
    }

    private void setFieldValue(SObject aObject, Schema.SObjectField aField, String aValue)
    {
        if (aObject == null || aField == null) {
            return;
        }

        Schema.DescribeFieldResult fieldDescription = aField.getDescribe();

        if (aValue == null) {
            aObject.put(fieldDescription.getName(), null);
        }
        else if (Schema.DisplayType.Integer == fieldDescription.getType()) {
            aObject.put(fieldDescription.getName(), Integer.valueOf(aValue));
        }
        else if (Schema.DisplayType.Double == fieldDescription.getType()) {
            aObject.put(fieldDescription.getName(), Double.valueOf(aValue));
        }
        else if (Schema.DisplayType.Currency == fieldDescription.getType()) {
            aObject.put(fieldDescription.getName(), Double.valueOf(aValue));
        }
        else if (Schema.DisplayType.Boolean == fieldDescription.getType()) {
            aObject.put(fieldDescription.getName(), Boolean.valueOf(aValue));
        }
        else if (Schema.DisplayType.Date == fieldDescription.getType()) {
            aObject.put(fieldDescription.getName(), Date.valueOf(aValue));
        }
        else if (Schema.DisplayType.DateTime == fieldDescription.getType()) {
            aObject.put(fieldDescription.getName(), DateTime.valueOf(aValue));
        }
        else {
            aObject.put(fieldDescription.getName(), aValue);
        }
    }

    protected List<SObject> createList(SObject aObj)
    {
        List<SObject> result = new List<SObject>();
        if (aObj != null) {
            result.add(aObj);
        }
        return result;
    }

    protected List<Long> createList(Long aLong)
    {
        List<Long> result = new List<Long>();
        if (aLong != null) {
            result.add(aLong);
        }
        return result;
    }

    private String asString(Set<Object> aList, String aSeparator)
    {
        String result = '';

        if (aList != null) {
            for (Object obj : aList) {
                if (result.length() > 0) {
                    result += aSeparator;
                }
                result += obj;
            }
        }

        return result;
    }

    protected UnitOfWorkStatus getStatus(List<OperationResult> aOperationResult)
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

    protected void setAllFailed(List<OperationResult> aOperationResult)
    {
        if (aOperationResult != null) {
            for (OperationResult operationResult : aOperationResult) {
                operationResult.sfdcId = null;
                operationResult.success = false;
                operationResult.created = false;
            }
        }
    }

    private boolean containsId(List<SObject> aSObjectList, Id aId)
    {
        if (aSObjectList != null) {
            for (SObject obj : aSObjectList) {
                if (obj.Id == aId) {
                    return true;
                }
            }
        }

        return false;
    }

    private String appendUpdatedByEpaTransaction(String aExistingValue, String aEpaTransactionId)
    {
        if (aEpaTransactionId == null) {
            return aExistingValue;
        }

        String newValue = aExistingValue;
        if (newValue == null || !getLastTransaction(newValue).equals(aEpaTransactionId)) {
            newValue = (newValue == null ? aEpaTransactionId : newValue + TRANSACTION_SEPARATOR + aEpaTransactionId);
            if (newValue != null && newValue.length() > UPDATED_BY_EPA_TRANSACTIONS_MAX_LEN) {
                newValue = newValue.substring(newValue.length() - UPDATED_BY_EPA_TRANSACTIONS_MAX_LEN);
                Integer semiColonPos = newValue.indexOf(TRANSACTION_SEPARATOR);
                if (semiColonPos >= 0) {
                    newValue = newValue.substring(semiColonPos + 1);
                }
            }
        }
        return newValue;
    }

    private String getLastTransaction(String aUpdatedByEpaTransactions)
    {
        String result = aUpdatedByEpaTransactions;

        if (aUpdatedByEpaTransactions.contains(TRANSACTION_SEPARATOR)) {
            Integer pos = aUpdatedByEpaTransactions.lastIndexOf(TRANSACTION_SEPARATOR);

            result = aUpdatedByEpaTransactions.substring(pos + 1);
        }

        return result;
    }
}