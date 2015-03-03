global class UnitOfTransferResponse
{
    webservice long unitOfTransferId;
    webservice List<UnitOfWorkResponse> unitOfWorkResponses;
    webservice long numSoqlQueries;
    webservice long numSoqlRecords;
    webservice long numDmlStatements;
    webservice long numDmlRecords;
    webservice long runTimeInMsecs;
    webservice long cpuTimeInMsecs;
}