global class UnitOfWorkResponse
{
    webservice long unitOfWorkId;
    webservice Id sfdcId;
    webservice transient UnitOfWorkStatus status;
    public Integer statusOrdinal {
        get {
            if (status == null) {
                return 0;
            }
            else {
                return status.ordinal();
            }
        }
        set {
            status = UnitOfWorkStatus.values()[value];
        }
    }
    webservice List<OperationResult> operationResult;
}