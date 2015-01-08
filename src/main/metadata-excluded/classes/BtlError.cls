public class BtlError
{
    public String Id  {get;set;}
    public String Organization  {get;set;}
    public String UseCase  {get;set;}
    public String UniqueExternalId  {get;set;}
    public String Origin  {get;set;}
    public String OriginDetails  {get;set;}
    public String TrnsctId  {get;set;}
    public String ParentTrnsctId  {get;set;}
    public DateTime StartDt  {get;set;}
    public DateTime EndDt  {get;set;}
    public String Status  {get;set;}
    public String Step  {get;set;}
    public String Error  {get;set;}
    public String ErrorCode  {get;set;}
    public String ErrorSeverity  {get;set;}
    public String Message  {get;set;}
    public String ProblemSolver  {get;set;}
    public String ErrorType  {get;set;}
    public List<BtlAdditionalInfo> AdditionalInformation  {get;set;}

    public String getShortMessage()
    {
        return Message != null && Message.length() > 100 ? Message.substring(0, 96) + ' ...'
                                 : Message;
    }
}