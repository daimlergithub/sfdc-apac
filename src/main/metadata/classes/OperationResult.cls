global class OperationResult
{
    webservice long entityId;
    webservice Id sfdcId;
    webservice Boolean success;
    webservice Boolean created;
    webservice String resultObjectsAsString;
    webservice List<Error> errors;
}