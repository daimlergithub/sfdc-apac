global class UnitOfWork
{
    webservice long unitOfWorkId;
    webservice Datetime triggeredDateTime;
    webservice transient UnitOfWorkType type;
    public Integer typeOrdinal {
        get {
            if (type == null) {
                return 0;
            }
            else {
                return type.ordinal();
            }
        }
        set {
            type = UnitOfWorkType.values()[value];
        }
    }
    webservice String btlId;
    webservice String objectsAsString;
}